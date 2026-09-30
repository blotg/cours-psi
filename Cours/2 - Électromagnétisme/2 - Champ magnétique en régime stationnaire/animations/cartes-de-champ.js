// Les cartes du chapitre : les lignes de champ de fils rectilignes que l'on
// déplace, puis celles de spires que l'on empile jusqu'à faire un solénoïde.
//
// La physique est dans `champ.js`. Les lignes de champ n'y sont pas suivies
// pas à pas comme au chapitre précédent : ce sont les lignes de niveau d'une
// fonction dont le champ dérive (A_z pour les fils, r A_θ pour les spires).
// Elles se ferment donc d'elles-mêmes, sans rien laisser au hasard d'une
// intégration, et `#animations/carte.js` les trace comme des
// équipotentielles.

import { contours, grille, polylignes, ronde } from '#animations/carte.js';
import { Graphe, échantillons } from '#animations/graphe.js';
import { COULEURS } from '#animations/objets.js';
import { cadre, lance } from '#animations/page.js';
import { Plan, chemin, disque, flèche, pointe } from '#animations/plan.js';
import { Réglages } from '#animations/reglages.js';
import { champDesFils, champDesSpires, champSurLAxe, fluxDesSpires, potentielDesFils } from './champ.js';

const COULEUR = {
    fil: COULEURS.noir,
    ligne: COULEURS.noir,
    sonde: COULEURS.violet,
    règle: COULEURS.gris,
    axe: COULEURS.gris,
};

/** La règle posée sur la carte, en centimètres. */
const RÈGLE = 5;

/** Le champ, en teslas, où la flèche en M a pris la moitié de sa longueur —
 *  celui de la Terre, à peu près. */
const CHAMP_DE_RÉFÉRENCE = 50e-6;

/** L'écart, en pixels, entre deux pointes le long d'une ligne de champ. */
const ENTRE_POINTES = 110;

const format = new Intl.NumberFormat('fr-FR', { maximumSignificantDigits: 3, useGrouping: false });
/** Un nombre, écrit à la française et lisible par KaTeX. */
const nombre = (x) => format.format(x).replace('−', '-').replace(',', '{,}');

/** Les préfixes d'un champ magnétique, du plus grand au plus petit. */
const PRÉFIXES = [
    [1, ''],
    [1e-3, 'm'],
    [1e-6, '\\mu'],
];

/** Un champ en teslas, sous le préfixe qui rend le nombre lisible. */
function mesure(valeur) {
    const [facteur, préfixe] = PRÉFIXES.find(([seuil]) => Math.abs(valeur) >= seuil) ?? [1e-6, '\\mu'];
    return `${nombre(valeur / facteur)}\\,${préfixe}\\mathrm{T}`;
}

// -- Ce qui se dessine ---------------------------------------------------------

/**
 * Un fil vu en coupe, comme sur les figures du cours : un point si le
 * courant vient vers nous (⊙), une croix s'il s'en éloigne (⊗), rien s'il
 * est nul. Trop petit pour porter un signe, il n'est plus qu'un point noir.
 */
function dessineFil(c, [px, py], I, rayon) {
    if (rayon < 3.5) {
        disque(c, [px, py], rayon, { couleur: COULEUR.fil });
        return;
    }
    disque(c, [px, py], rayon, { couleur: '#fff', bord: COULEUR.fil, épaisseur: 1.6 });
    if (I > 0) disque(c, [px, py], rayon * 0.3, { couleur: COULEUR.fil });
    if (I < 0) {
        const d = rayon / Math.SQRT2;
        chemin(c, [[px - d, py - d], [px + d, py + d]], { couleur: COULEUR.fil, épaisseur: 1.6 });
        chemin(c, [[px - d, py + d], [px + d, py - d]], { couleur: COULEUR.fil, épaisseur: 1.6 });
    }
}

/**
 * Des lignes de champ, fléchées à distance régulière dans le sens du champ :
 * `champ(x, y)` le donne en coordonnées de l'écran, et une pointe prend le
 * sens de la ligne qui s'accorde avec lui. La première pointe d'une ligne est
 * à mi-distance de son début : une ligne courte, fermée sur un fil, en a
 * encore une.
 */
function dessineLignes(c, plan, lignes, champ, { couleur = COULEUR.ligne, épaisseur = 1.4 } = {}) {
    for (const ligne of lignes) {
        const points = ligne.map(([x, y]) => plan.vers(x, y));
        chemin(c, points, { couleur, épaisseur });
        let prochaine = ENTRE_POINTES / 2;
        let parcouru = 0;
        for (let i = 0; i + 1 < points.length; i++) {
            const [a, b] = [points[i], points[i + 1]];
            const tangente = [b[0] - a[0], b[1] - a[1]];
            const longueur = Math.hypot(...tangente);
            while (longueur && parcouru + longueur >= prochaine) {
                const t = (prochaine - parcouru) / longueur;
                const [x, y] = [ligne[i][0] + t * (ligne[i + 1][0] - ligne[i][0]), ligne[i][1] + t * (ligne[i + 1][1] - ligne[i][1])];
                const [bx, by] = champ(x, y);
                // L'écran compte y vers le bas.
                const sens = Math.sign(tangente[0] * bx - tangente[1] * by) || 1;
                pointe(c, [a[0] + t * tangente[0], a[1] + t * tangente[1]], [sens * tangente[0], sens * tangente[1]], {
                    couleur,
                });
                prochaine += ENTRE_POINTES;
            }
            parcouru += longueur;
        }
    }
}

/** L'échelle de la carte : une règle posée en bas à gauche. */
function dessineÉchelle(c, plan, nom) {
    const { x0, y0 } = plan.cadre();
    const y = y0 + 0.5;
    const bouts = [plan.vers(x0 + 0.6, y), plan.vers(x0 + 0.6 + RÈGLE, y)];
    chemin(c, bouts, { couleur: COULEUR.règle, épaisseur: 2 });
    for (const [px, py] of bouts) {
        chemin(c, [[px, py - 5], [px, py + 5]], { couleur: COULEUR.règle, épaisseur: 2 });
    }
    nom.place(x0 + 0.6 + RÈGLE / 2, y, [0, -13]);
}

// -- Fils rectilignes ----------------------------------------------------------

/**
 * Les distributions proposées : les places des fils, et les curseurs qui
 * règlent leurs courants — chacun sur un ou plusieurs fils, avec un signe.
 * L'hexagone est celui de l'exercice « Piège à neutrons » : un seul courant,
 * de sens alterné d'un fil au suivant.
 */
const CONFIGURATIONS = {
    un: { fils: [[0, 0]], curseurs: { I: [[0, 1]] }, courants: { I: 5 } },
    opposés: {
        fils: [
            [-2.6, 0],
            [2.6, 0],
        ],
        curseurs: { I_1: [[0, 1]], I_2: [[1, 1]] },
        courants: { I_1: 5, I_2: -5 },
    },
    mêmes: {
        fils: [
            [-2.6, 0],
            [2.6, 0],
        ],
        curseurs: { I_1: [[0, 1]], I_2: [[1, 1]] },
        courants: { I_1: 5, I_2: 5 },
    },
    hexagone: {
        fils: Array.from({ length: 6 }, (_, k) => [3 * Math.cos((k * Math.PI) / 3), 3 * Math.sin((k * Math.PI) / 3)]),
        curseurs: { I: Array.from({ length: 6 }, (_, k) => [k, (-1) ** k]) },
        courants: { I: 5 },
    },
};

/** La distance d'un fil en deçà de laquelle on ne trace plus de ligne, en
 *  centimètres : A_z y diverge, et les cercles s'y entasseraient. */
const PRÈS_DU_FIL = 0.6;

/**
 * L'écart de flux entre deux lignes voisines, en microwebers par mètre de
 * fil. Il suit le plus fort des courants, comme l'écart des équipotentielles
 * suivait la plus forte des charges : un courant double s'entoure alors de
 * deux fois plus de lignes que son voisin, et la carte reste lisible quel
 * que soit le courant.
 */
const pasDuFlux = (fils) => ronde(0.06 * Math.max(...fils.map((f) => Math.abs(f.I)), 0.01));

/** Les niveaux de A_z, tous les `pas`, qu'atteint la carte hors du voisinage
 *  immédiat des fils. */
function niveauxDesFils(carte, fils, pas) {
    const { colonnes, lignes, cadre: vue, valeurs } = carte;
    let bas = Infinity;
    let haut = -Infinity;
    for (let j = 0; j < lignes; j++) {
        const y = vue.y0 + ((vue.y1 - vue.y0) * j) / (lignes - 1);
        for (let i = 0; i < colonnes; i++) {
            const x = vue.x0 + ((vue.x1 - vue.x0) * i) / (colonnes - 1);
            if (fils.some((f) => Math.hypot(x - f.x, y - f.y) < PRÈS_DU_FIL)) continue;
            const v = valeurs[j * colonnes + i];
            if (v < bas) bas = v;
            if (v > haut) haut = v;
        }
    }
    const trouvés = [];
    for (let k = Math.ceil(bas / pas); k <= Math.floor(haut / pas) && trouvés.length < 80; k++) trouvés.push(k * pas);
    return trouvés;
}

function carteDesFils(section) {
    const { vue, réglages: panneau } = cadre(section);
    const plan = new Plan(vue, {
        rapport: 16 / 10,
        étendue: 16,
        aide: 'Glisser les fils, et le point M.',
    });
    const état = {
        configuration: 'opposés',
        M: [0.6, 2.4],
        montre: { lignes: true, sonde: true },
    };
    let fils = [];

    const nomM = plan.étiquette('M');
    const nomB = plan.étiquette('\\vec{B}', { couleur: COULEUR.sonde });
    const nomRègle = plan.étiquette(`${RÈGLE}\\,\\mathrm{cm}`, { couleur: COULEUR.règle, taille: '0.9rem' });

    // Les fils et le point M se prennent à la souris ; rien ne sort du
    // cadre, où le calcul a un sens.
    const borne = (p) => {
        const { x0, x1, y0, y1 } = plan.cadre();
        return [Math.min(Math.max(p[0], x0 + 0.4), x1 - 0.4), Math.min(Math.max(p[1], y0 + 0.4), y1 - 0.4)];
    };
    for (let k = 0; k < 6; k++) {
        plan.poignée({
            position: () => (fils[k] ? [fils[k].x, fils[k].y] : [1e6, 1e6]),
            auDéplacement: (x, y) => {
                if (fils[k]) [fils[k].x, fils[k].y] = borne([x, y]);
            },
        });
    }
    plan.poignée({ position: () => état.M, auDéplacement: (x, y) => (état.M = borne([x, y])) });

    plan.dessine((c) => {
        const vueDuPlan = plan.cadre();
        const pas = pasDuFlux(fils);
        const champÉcran = (x, y) => champDesFils(fils, x, y);
        // Le potentiel vecteur sur une grille, calculé une fois pour toutes
        // les lignes — et pour celle qui passe par M.
        const potentiel = grille((x, y) => potentielDesFils(fils, x, y), vueDuPlan, 220);
        if (état.montre.lignes && fils.some((f) => f.I)) {
            dessineLignes(c, plan, polylignes(contours(potentiel, niveauxDesFils(potentiel, fils, pas))), champÉcran);
        }

        // Le champ en M : la ligne de champ qui y passe, et une flèche qui
        // sature, pour rester lisible partout.
        const [bx, by] = champDesFils(fils, ...état.M);
        const norme = Math.hypot(bx, by);
        nomM.montre(état.montre.sonde).place(...état.M, [-15, 13]);
        nomB.montre(état.montre.sonde && norme > 1e-12);
        if (état.montre.sonde) {
            if (norme > 1e-12) {
                const niveau = potentielDesFils(fils, ...état.M);
                dessineLignes(c, plan, polylignes(contours(potentiel, [niveau])), champÉcran, {
                    couleur: COULEUR.sonde,
                    épaisseur: 2,
                });
            }
            const départ = plan.vers(...état.M);
            const longueur = 12 + 104 * (norme / (norme + CHAMP_DE_RÉFÉRENCE));
            disque(c, départ, 4, { couleur: COULEURS.noir });
            flèche(c, départ, [bx, -by], longueur, { couleur: COULEUR.sonde, épaisseur: 2.5 });
            const bout = longueur + 14;
            if (norme > 1e-12) nomB.place(...état.M, [(bx / norme) * bout, (-by / norme) * bout]);
        }

        for (const fil of fils) dessineFil(c, plan.vers(fil.x, fil.y), fil.I, 9);
        dessineÉchelle(c, plan, nomRègle);

        mesures.écrit(`\\lVert\\vec{B}\\rVert = ${mesure(norme)}`);
        écritLaNote(pas);
    });

    // -- Réglages -------------------------------------------------------------

    const réglages = new Réglages(panneau);
    const curseurs = {};

    function change(configuration) {
        état.configuration = configuration;
        const { fils: places, curseurs: réglés, courants } = CONFIGURATIONS[configuration];
        fils = places.map(([x, y]) => ({ x, y, I: 0 }));
        for (const [tex, curseur] of Object.entries(curseurs)) {
            curseur.montre(tex in réglés);
            if (tex in réglés) {
                curseur.valeur = courants[tex];
                règle(tex, courants[tex]);
            }
        }
        plan.redessine();
    }

    /** Le courant `tex` vaut `v` : il le donne aux fils qu'il règle. */
    function règle(tex, v) {
        for (const [k, signe] of CONFIGURATIONS[état.configuration].curseurs[tex] ?? []) fils[k].I = signe * v;
        plan.redessine();
    }

    réglages.groupe('Distribution');
    réglages.choix({
        options: [
            ['un', '\\text{un fil}'],
            ['opposés', '\\odot\\;\\otimes'],
            ['mêmes', '\\odot\\;\\odot'],
            ['hexagone', '\\text{hexagone}'],
        ],
        valeur: état.configuration,
        auChangement: change,
    });
    for (const tex of ['I', 'I_1', 'I_2']) {
        curseurs[tex] = réglages.curseur({
            tex,
            min: -10,
            max: 10,
            pas: 0.1,
            valeur: 5,
            unité: ' A',
            aimants: [-5, 5],
            auChangement: (v) => règle(tex, v),
        });
    }

    réglages.groupe('Afficher');
    const case_ = (texte, clé, couleur) =>
        réglages.case({
            texte,
            couleur,
            valeur: état.montre[clé],
            auChangement: (v) => {
                état.montre[clé] = v;
                plan.redessine();
            },
        });
    case_('Lignes de champ', 'lignes', COULEUR.ligne);
    case_('Champ en M, et sa ligne de champ', 'sonde', COULEUR.sonde);

    réglages.groupe('En M');
    const mesures = réglages.formule();
    const note = réglages.texte();
    note.className = 'note';

    let pasÉcrit = null;
    function écritLaNote(pas) {
        if (pas === pasÉcrit) return;
        pasÉcrit = pas;
        note.textContent =
            `Deux lignes de champ voisines encadrent toujours le même flux, ${pas.toLocaleString('fr-FR')} µWb ` +
            'par mètre de fil : là où elles se resserrent, le champ est intense.';
    }

    change(état.configuration);
}

// -- Des spires au solénoïde ---------------------------------------------------

/** Le rayon des spires, et l'écart entre deux spires voisines, en
 *  centimètres : des spires jointives d'un fil de 3,5 mm. */
const RAYON = 2;
const ÉCART = 0.35;

/** Le nombre de lignes de champ qui traversent chaque moitié du plan médian,
 *  à l'intérieur des spires. */
const LIGNES_PAR_MOITIÉ = 5;

/**
 * ψ sur une grille du cadre, qui est symétrique par rapport à l'axe et par
 * rapport au plan médian : on n'en calcule qu'un quart, et le reste s'en
 * déduit. Le calcul coûte une intégrale elliptique par point et par spire.
 */
function grilleDeFlux(cotes, vue, colonnes) {
    const lignes = Math.round((colonnes * (vue.y1 - vue.y0)) / (vue.x1 - vue.x0));
    const valeurs = new Float64Array(colonnes * lignes);
    for (let j = 0; j < Math.ceil(lignes / 2); j++) {
        const r = Math.abs(vue.y0 + ((vue.y1 - vue.y0) * j) / (lignes - 1));
        for (let i = 0; i < Math.ceil(colonnes / 2); i++) {
            const z = vue.x0 + ((vue.x1 - vue.x0) * i) / (colonnes - 1);
            const ψ = fluxDesSpires(RAYON, cotes, z, r);
            for (const jj of [j, lignes - 1 - j]) {
                for (const ii of [i, colonnes - 1 - i]) valeurs[jj * colonnes + ii] = ψ;
            }
        }
    }
    return { colonnes, lignes, cadre: vue, valeurs };
}

function solénoïde(section) {
    const { vue, réglages: panneau } = cadre(section);
    const plan = new Plan(vue, { rapport: 2, étendue: 20 });
    const état = { N: 1 };
    let cotes = [];
    let lignes = [];

    const nomAxe = plan.étiquette('z', { couleur: COULEUR.axe });

    /** Le champ en (z, y) du plan de coupe, en coordonnées de l'écran. */
    const champÉcran = (z, y) => {
        const [br, bz] = champDesSpires(RAYON, cotes, z, Math.abs(y));
        return [bz, Math.sign(y) * br];
    };

    // Le profil radial se prend entre deux spires : sur l'une d'elles, il
    // traverserait le fil, où le champ diverge.
    const coteDuProfil = () => (état.N % 2 ? ÉCART / 2 : 0);

    plan.dessine((c) => {
        const { x0, x1, y1 } = plan.cadre();
        chemin(c, [plan.vers(x0, 0), plan.vers(x1, 0)], { couleur: COULEUR.axe, épaisseur: 1, pointillés: [10, 4, 2, 4] });
        nomAxe.place(x1, 0, [-12, -12]);
        const z = coteDuProfil();
        chemin(c, [plan.vers(z, 0), plan.vers(z, y1)], { couleur: COULEUR.axe, épaisseur: 1, pointillés: [4, 4] });

        dessineLignes(c, plan, lignes, champÉcran);

        // Les spires coupées par le plan : le courant sort de l'écran en
        // haut et y entre en bas, et le champ intérieur va vers la droite.
        const rayon = Math.min(7, 0.42 * plan.long(ÉCART));
        for (const cote of cotes) {
            dessineFil(c, plan.vers(cote, RAYON), 1, rayon);
            dessineFil(c, plan.vers(cote, -RAYON), -1, rayon);
        }
    });

    // -- Le champ, sur l'axe et au milieu -----------------------------------------

    const surLAxe = new Graphe({
        x: { min: -10, max: 10, nom: 'z', graduations: [] },
        y: {
            min: 0,
            max: 1.2,
            graduations: [
                [0.5, '\\mu_0 n I/2'],
                [1, '\\mu_0 n I'],
            ],
        },
        hauteur: 130,
        marges: { gauche: 56 },
    });
    const courbeSurLAxe = surLAxe.courbe({ couleur: COULEUR.ligne });

    const auMilieu = new Graphe({
        x: { min: 0, max: 5, nom: 'r', graduations: [[RAYON, 'R']] },
        y: {
            min: -0.2,
            max: 1.2,
            graduations: [
                [0, '0'],
                [1, '\\mu_0 n I'],
            ],
        },
        hauteur: 130,
        marges: { gauche: 56 },
    });
    const courbeAuMilieu = auMilieu.courbe({ couleur: COULEUR.ligne });

    function recalcule() {
        const L = état.N * ÉCART;
        cotes = Array.from({ length: état.N }, (_, k) => -L / 2 + ÉCART * (k + 0.5));

        // Les lignes qui traversent le plan médian en des points
        // régulièrement espacés, entre l'axe et les spires : dans un champ
        // uniforme, elles sont régulièrement espacées elles aussi.
        const flux = grilleDeFlux(cotes, plan.cadre(), 200);
        const niveaux = Array.from({ length: LIGNES_PAR_MOITIÉ }, (_, k) =>
            fluxDesSpires(RAYON, cotes, 0, (RAYON * (k + 0.5)) / LIGNES_PAR_MOITIÉ),
        );
        lignes = niveaux.flatMap((niveau) => polylignes(contours(flux, [niveau])));

        // Les champs se rapportent à celui du solénoïde infini, μ₀nI, avec
        // n = 1/ÉCART : μ₀I = 1 dans champ.js, les longueurs en centimètres.
        const borné = (b) => Math.min(Math.max(b * ÉCART, -0.2), 1.2);
        courbeSurLAxe.place(échantillons(-10, 10, 300).map((z) => [z, borné(champSurLAxe(RAYON, cotes, z))]));
        const z = coteDuProfil();
        courbeAuMilieu.place(échantillons(0, 5, 250).map((r) => [r, borné(champDesSpires(RAYON, cotes, z, r)[1])]));
        // Les bouts du solénoïde, quand il est assez long pour que leurs noms
        // ne se chevauchent pas.
        surLAxe.grilleX.place(
            L > 6
                ? [
                      [-L / 2, '-L/2'],
                      [L / 2, 'L/2'],
                  ]
                : [[0, '0']],
        );
        plan.redessine();
    }

    const réglages = new Réglages(panneau);
    réglages.groupe('Les spires');
    réglages.curseur({
        tex: 'N',
        min: 1,
        max: 40,
        pas: 1,
        valeur: état.N,
        auChangement: (v) => {
            état.N = v;
            recalcule();
        },
    });

    réglages.groupe('Le champ sur l’axe');
    réglages.ajoute(surLAxe.élément);
    réglages.groupe('Le champ au milieu, selon r');
    réglages.ajoute(auMilieu.élément);
    réglages.formule('B = \\mu_0 n I');

    recalcule();
}

const ANIMATIONS = { fils: carteDesFils, solenoide: solénoïde };

lance('section.animation', (section) => ANIMATIONS[section.dataset.animation](section));
