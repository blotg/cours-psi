// Les cartes du chapitre : lignes de champ et équipotentielles d'un jeu de
// charges que l'on déplace, et le champ d'un condensateur plan, uniforme sauf
// près des bords.
//
// La physique est dans `champ.js`. Les charges de la première carte sont
// ponctuelles et posées dans le plan de l'écran : tout s'y lit en vraies
// unités — des centimètres, que porte la règle dessinée sur la carte, des
// nanocoulombs, des volts par mètre et des volts. Les armatures du
// condensateur, elles, sont des plaques vues par la tranche, sans quoi le
// champ entre elles ne serait pas uniforme ; son panneau ne parle qu'en σ/ε.

import { Graphe, échantillons } from '#animations/graphe.js';
import { COULEURS } from '#animations/objets.js';
import { cadre, lance } from '#animations/page.js';
import { Plan, chemin, disque, flèche, pointe } from '#animations/plan.js';
import { Réglages } from '#animations/reglages.js';
import { contours, niveaux, ronde } from '#animations/carte.js';
import { champ, FILS, grilleDePotentiel, lignesDeChamp, ligneDeChamp, potentiel } from './champ.js';

const COULEUR = {
    positive: COULEURS.vermillon,
    négative: COULEURS.bleu,
    ligne: COULEURS.noir,
    équipotentielle: COULEURS.vert,
    sonde: COULEURS.violet,
    règle: COULEURS.gris,
};

/** La règle posée sur la carte, en centimètres. */
const RÈGLE = 5;

/**
 * L'écart entre équipotentielles, en volts. C'est lui qui fait parler la
 * carte : toutes sont tracées du même écart, et leur resserrement dit le
 * champ. Il suit la plus forte des charges, pour qu'une charge faible ne
 * donne pas une carte vide et une charge forte un pâté illisible — le
 * potentiel d'une charge ponctuelle varie en 1/r, et se resserre vite. La
 * valeur retenue s'annonce dans le panneau : c'est l'échelle du potentiel.
 */
function pasDuPotentiel(charges) {
    return ronde(100 * Math.max(...charges.map((c) => Math.abs(c.q)), 0.01));
}

/** Le nombre d'équipotentielles que porte la carte au plus ; `niveaux` les
 *  répartit de part et d'autre du potentiel nul. */
const ÉQUIPOTENTIELLES = 16;

/** Le champ, en volts par mètre, où la flèche en M a pris la moitié de sa
 *  longueur : elle sature, faute de quoi elle traverserait la carte dès
 *  qu'on approche M d'une charge. */
const CHAMP_DE_RÉFÉRENCE = 9e3;

const format = new Intl.NumberFormat('fr-FR', { maximumSignificantDigits: 3, useGrouping: false });
/** Un nombre, écrit à la française et lisible par KaTeX. */
const nombre = (x) => format.format(x).replace('−', '-').replace(',', '{,}');

/** Les préfixes du système international, du plus grand au plus petit. */
const PRÉFIXES = [
    [1e9, 'G'],
    [1e6, 'M'],
    [1e3, 'k'],
];

/** Une mesure et son unité, sous le préfixe qui rend le nombre lisible. */
function mesure(valeur, unité) {
    const [facteur, préfixe] = PRÉFIXES.find(([seuil]) => Math.abs(valeur) >= seuil) ?? [1, ''];
    return `${nombre(valeur / facteur)}\\,\\mathrm{${préfixe}${unité}}`;
}

// -- Ce qui se dessine ---------------------------------------------------------

/** Le rayon du disque d'une charge, en pixels : il grandit avec elle, mais
 *  lentement, pour qu'une charge triple ne dévore pas la carte — et il
 *  s'annule avec elle, plutôt que de la faire disparaître d'un coup. */
const rayonDeCharge = (q) => 11 * Math.cbrt(Math.abs(q));

/** Les charges : un disque, plus le signe en blanc par-dessus. */
function dessineCharges(c, plan, charges) {
    for (const charge of charges) {
        if (!charge.q) continue;
        const centre = plan.vers(charge.x, charge.y);
        const rayon = rayonDeCharge(charge.q);
        disque(c, centre, rayon, { couleur: charge.q > 0 ? COULEUR.positive : COULEUR.négative });
        const barre = rayon * 0.55;
        const traits = [
            [
                [centre[0] - barre, centre[1]],
                [centre[0] + barre, centre[1]],
            ],
        ];
        if (charge.q > 0) {
            traits.push([
                [centre[0], centre[1] - barre],
                [centre[0], centre[1] + barre],
            ]);
        }
        for (const trait of traits) chemin(c, trait, { couleur: '#fff', épaisseur: Math.max(1.2, rayon * 0.22) });
    }
}

/** Les lignes de champ, fléchées de loin en loin dans le sens du champ. */
function dessineLignes(c, plan, lignes, { couleur = COULEUR.ligne, épaisseur = 1.4, entreFlèches = 16 } = {}) {
    for (const ligne of lignes) {
        const points = ligne.map(([x, y]) => plan.vers(x, y));
        chemin(c, points, { couleur, épaisseur });
        for (let i = entreFlèches; i < points.length - 1; i += entreFlèches) {
            pointe(c, points[i], [points[i + 1][0] - points[i][0], points[i + 1][1] - points[i][1]], { couleur });
        }
    }
}

/** Les équipotentielles, toutes espacées du même écart de potentiel. */
function dessineÉquipotentielles(c, plan, grille, pas) {
    const trait = new Path2D();
    for (const [a, b] of contours(grille, niveaux(grille, pas, ÉQUIPOTENTIELLES))) {
        trait.moveTo(...plan.vers(...a));
        trait.lineTo(...plan.vers(...b));
    }
    c.save();
    c.strokeStyle = COULEUR.équipotentielle;
    c.lineWidth = 1;
    c.stroke(trait);
    c.restore();
}

const TEINTE = { positif: [213, 94, 0], négatif: [0, 114, 178] };

/** Le dégradé de potentiel, peint sur la grille puis étiré à la taille de la
 *  vue : le calculer pixel par pixel coûterait trente fois plus. */
function dessineDégradé(c, plan, grille, toile, saturation) {
    const { colonnes, lignes, valeurs, cadre: vue } = grille;
    if (toile.width !== colonnes || toile.height !== lignes) {
        toile.width = colonnes;
        toile.height = lignes;
    }
    const pinceau = toile.getContext('2d');
    const image = pinceau.createImageData(colonnes, lignes);
    for (let j = 0; j < lignes; j++) {
        for (let i = 0; i < colonnes; i++) {
            const t = Math.tanh(valeurs[j * colonnes + i] / saturation);
            const [r, v, b] = t >= 0 ? TEINTE.positif : TEINTE.négatif;
            const poids = Math.abs(t) * 0.55;
            // L'image se remplit de haut en bas, la grille de bas en haut.
            const k = 4 * ((lignes - 1 - j) * colonnes + i);
            image.data[k] = 255 + (r - 255) * poids;
            image.data[k + 1] = 255 + (v - 255) * poids;
            image.data[k + 2] = 255 + (b - 255) * poids;
            image.data[k + 3] = 255;
        }
    }
    pinceau.putImageData(image, 0, 0);
    c.save();
    c.imageSmoothingEnabled = true;
    c.drawImage(toile, ...plan.vers(vue.x0, vue.y1), plan.long(vue.x1 - vue.x0), plan.long(vue.y1 - vue.y0));
    c.restore();
}

/** L'échelle de la carte : une règle posée en bas à gauche. Sans elle, ni les
 *  volts par mètre ni les volts affichés ne voudraient dire grand-chose. */
function dessineÉchelle(c, plan, nom) {
    const { x0, y0 } = plan.cadre();
    const y = y0 + 0.5;
    const bouts = [plan.vers(x0 + 0.6, y), plan.vers(x0 + 0.6 + RÈGLE, y)];
    chemin(c, bouts, { couleur: COULEUR.règle, épaisseur: 2 });
    for (const [px, py] of bouts) {
        chemin(
            c,
            [
                [px, py - 5],
                [px, py + 5],
            ],
            { couleur: COULEUR.règle, épaisseur: 2 },
        );
    }
    nom.place(x0 + 0.6 + RÈGLE / 2, y, [0, -13]);
}

// -- Lignes de champ et équipotentielles ---------------------------------------

const CONFIGURATIONS = {
    une: [{ x: 0, y: 0, q: 1 }],
    opposées: [
        { x: -2.6, y: 0, q: 1 },
        { x: 2.6, y: 0, q: -1 },
    ],
    mêmes: [
        { x: -2.6, y: 0, q: 1 },
        { x: 2.6, y: 0, q: 1 },
    ],
};

function carteDeChamp(section) {
    const { vue, réglages: panneau } = cadre(section);
    const plan = new Plan(vue, {
        rapport: 16 / 10,
        étendue: 16,
        aide: 'Glisser les charges, et le point M.',
    });
    const état = {
        configuration: 'opposées',
        M: [1.4, 2.6],
        montre: { lignes: true, équipotentielles: true, dégradé: false, sonde: true },
    };
    let charges = CONFIGURATIONS[état.configuration].map((c) => ({ ...c }));
    const toile = document.createElement('canvas');

    const nomM = plan.étiquette('M');
    const nomE = plan.étiquette('\\vec{E}', { couleur: COULEUR.sonde });
    const nomRègle = plan.étiquette(`${RÈGLE}\\,\\mathrm{cm}`, { couleur: COULEUR.règle, taille: '0.9rem' });

    // Les charges et le point M se prennent à la souris ; rien ne sort du
    // cadre, où le calcul a un sens.
    const borne = (p) => {
        const { x0, x1, y0, y1 } = plan.cadre();
        return [Math.min(Math.max(p[0], x0 + 0.4), x1 - 0.4), Math.min(Math.max(p[1], y0 + 0.4), y1 - 0.4)];
    };
    for (const k of [0, 1]) {
        plan.poignée({
            position: () => (charges[k] ? [charges[k].x, charges[k].y] : [1e6, 1e6]),
            auDéplacement: (x, y) => {
                if (charges[k]) [charges[k].x, charges[k].y] = borne([x, y]);
            },
        });
    }
    plan.poignée({ position: () => état.M, auDéplacement: (x, y) => (état.M = borne([x, y])) });

    plan.dessine((c) => {
        const vueDuPlan = plan.cadre();
        const pas = pasDuPotentiel(charges);
        if (état.montre.équipotentielles || état.montre.dégradé) {
            const grille = grilleDePotentiel(charges, vueDuPlan, 130);
            // Le dégradé prend toute sa couleur à quelques équipotentielles
            // du potentiel nul, quelle que soit la charge.
            if (état.montre.dégradé) dessineDégradé(c, plan, grille, toile, 4 * pas);
            if (état.montre.équipotentielles) dessineÉquipotentielles(c, plan, grille, pas);
        }
        if (état.montre.lignes) {
            dessineLignes(c, plan, lignesDeChamp(charges, { vue: vueDuPlan, pas: 0.07 }));
        }
        dessineCharges(c, plan, charges);
        dessineÉchelle(c, plan, nomRègle);

        // Le champ en M : une flèche qui sature, pour rester lisible partout.
        const [ex, ey] = champ(charges, ...état.M);
        const norme = Math.hypot(ex, ey);
        const départ = plan.vers(...état.M);
        nomM.montre(état.montre.sonde).place(...état.M, [-15, 13]);
        nomE.montre(état.montre.sonde && norme > 1e-6);
        if (état.montre.sonde) {
            const longueur = 12 + 104 * (norme / (norme + CHAMP_DE_RÉFÉRENCE));
            disque(c, départ, 4, { couleur: COULEURS.noir });
            flèche(c, départ, [ex, -ey], longueur, { couleur: COULEUR.sonde, épaisseur: 2.5 });
            const bout = longueur + 14;
            nomE.place(...état.M, [(ex / norme) * bout, (-ey / norme) * bout]);
        }
        mesures.écrit(
            `\\begin{aligned} \\lVert\\vec{E}\\rVert &= ${mesure(norme, 'V\\,m^{-1}')} \\\\ ` +
                `V &= ${mesure(potentiel(charges, ...état.M), 'V')} \\end{aligned}`,
        );
        écritLaNote(pas);
    });

    // -- Réglages -------------------------------------------------------------

    const réglages = new Réglages(panneau);
    const curseurs = [];

    function change(configuration) {
        état.configuration = configuration;
        charges = CONFIGURATIONS[configuration].map((c) => ({ ...c }));
        curseurs.forEach((curseur, k) => {
            curseur.montre(Boolean(charges[k]));
            if (charges[k]) curseur.valeur = charges[k].q;
        });
        plan.redessine();
    }

    réglages.groupe('Distribution');
    réglages.choix({
        options: [
            ['une', '\\text{une charge}'],
            ['opposées', '+\\,-'],
            ['mêmes', '+\\,+'],
        ],
        valeur: état.configuration,
        auChangement: change,
    });
    for (const k of [0, 1]) {
        curseurs.push(
            réglages.curseur({
                tex: `q_${k + 1}`,
                min: -3,
                max: 3,
                pas: 0.05,
                valeur: charges[k]?.q ?? 1,
                unité: ' nC',
                aimants: [-1, 1],
                couleur: k ? COULEUR.négative : COULEUR.positive,
                auChangement: (v) => {
                    if (charges[k]) charges[k].q = v;
                    plan.redessine();
                },
            }),
        );
    }
    curseurs[1].montre(Boolean(charges[1]));

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
    case_('Équipotentielles', 'équipotentielles', COULEUR.équipotentielle);
    case_('Dégradé de potentiel', 'dégradé');
    case_('Champ en M', 'sonde', COULEUR.sonde);

    réglages.groupe('En M');
    const mesures = réglages.formule();
    const note = réglages.texte();
    note.className = 'note';

    let pasÉcrit = null;
    function écritLaNote(pas) {
        if (pas === pasÉcrit) return;
        pasÉcrit = pas;
        note.textContent =
            `Les équipotentielles sont tracées tous les ${pas.toLocaleString('fr-FR')} V, toujours du même ` +
            'écart : là où elles se resserrent, le champ est intense. Le champ leur est perpendiculaire et ' +
            'descend les potentiels.';
    }
}

// -- Condensateur plan ---------------------------------------------------------

/** Les armatures, chacune découpée en fils de même charge. */
function armatures({ e, largeur, σ }, fils = 60) {
    const charges = [];
    for (const signe of [1, -1]) {
        for (let k = 0; k < fils; k++) {
            charges.push({
                x: -largeur / 2 + (largeur * (k + 0.5)) / fils,
                y: (signe * e) / 2,
                q: (signe * σ * largeur) / fils,
            });
        }
    }
    return charges;
}

function condensateurPlan(section) {
    const { vue, réglages: panneau } = cadre(section);
    const plan = new Plan(vue, { rapport: 16 / 9, étendue: 15 });
    const état = { e: 2, largeur: 9, σ: 1, montre: { lignes: true, équipotentielles: true } };
    let charges = armatures(état);

    const armature = [
        plan.étiquette('+\\sigma', { couleur: COULEUR.positive, ancre: 'droite' }),
        plan.étiquette('-\\sigma', { couleur: COULEUR.négative, ancre: 'droite' }),
    ];

    plan.dessine((c) => {
        const vueDuPlan = plan.cadre();
        if (état.montre.équipotentielles) {
            dessineÉquipotentielles(c, plan, grilleDePotentiel(charges, vueDuPlan, 110, FILS), 1.2);
        }
        if (état.montre.lignes) {
            // Les lignes partent de l'armature positive, régulièrement
            // réparties, et de ses deux bords où le champ fuit au dehors.
            // Celles-là s'en vont pour de bon : la carte s'arrête au cadre.
            const départs = échantillons(-0.98, 0.98, 21).map((t) => [(t * état.largeur) / 2, état.e / 2 - 0.05]);
            départs.push([-état.largeur / 2 - 0.05, état.e / 2 + 0.08], [état.largeur / 2 + 0.05, état.e / 2 + 0.08]);
            dessineLignes(
                c,
                plan,
                départs.map((départ) =>
                    ligneDeChamp(charges, départ, { pas: 0.06, vue: vueDuPlan, portée: 1.2, arrivée: 0.06, loi: FILS }),
                ),
                { entreFlèches: 12 },
            );
        }
        for (const signe of [1, -1]) {
            const y = (signe * état.e) / 2;
            chemin(c, [plan.vers(-état.largeur / 2, y), plan.vers(état.largeur / 2, y)], {
                couleur: signe > 0 ? COULEUR.positive : COULEUR.négative,
                épaisseur: 5,
            });
        }
        armature.forEach((nom, k) => nom.place((-état.largeur / 2) * 1.02, ((k ? -1 : 1) * état.e) / 2, [-14, 0]));
    });

    // Le champ le long du plan médian : uniforme au milieu, il s'effondre aux
    // bords.
    const profil = new Graphe({
        x: { min: -1, max: 1, nom: 'x', graduations: [[-0.5, '-\\frac{L}{2}'], [0.5, '\\frac{L}{2}']] },
        y: {
            min: 0,
            max: 1.25,
            graduations: [[1, '\\frac{\\sigma}{\\varepsilon}']],
        },
        hauteur: 150,
        marges: { gauche: 40 },
    });
    const courbe = profil.courbe({ couleur: COULEUR.ligne });

    function recalcule() {
        charges = armatures(état);
        const uniforme = 2 * Math.PI * état.σ;
        // L'abscisse se compte en largeurs d'armature : le tracé va donc
        // jusqu'au double de la demi-largeur, bien au-delà des bords.
        courbe.place(
            échantillons(-1, 1, 200).map((u) => [u, Math.hypot(...champ(charges, u * état.largeur, 0, FILS)) / uniforme]),
        );
        plan.redessine();
    }

    const réglages = new Réglages(panneau);
    réglages.groupe('Armatures');
    for (const [clé, options] of [
        ['e', { tex: 'e', min: 0.6, max: 5, pas: 0.05 }],
        ['largeur', { tex: 'L', min: 4, max: 13, pas: 0.1 }],
    ]) {
        réglages.curseur({
            ...options,
            valeur: état[clé],
            auChangement: (v) => {
                état[clé] = v;
                recalcule();
            },
        });
    }

    réglages.groupe('Afficher');
    for (const [texte, clé, couleur] of [
        ['Lignes de champ', 'lignes', COULEUR.ligne],
        ['Équipotentielles', 'équipotentielles', COULEUR.équipotentielle],
    ]) {
        réglages.case({
            texte,
            couleur,
            valeur: état.montre[clé],
            auChangement: (v) => {
                état.montre[clé] = v;
                plan.redessine();
            },
        });
    }

    réglages.groupe('Champ sur le plan médian');
    réglages.ajoute(profil.élément);
    réglages.formule('E = \\frac{\\sigma}{\\varepsilon}');
    réglages.formule('C = \\frac{\\varepsilon S_a}{e}');
    réglages.texte(
        'Le champ vaut σ/ε partout entre les armatures, sauf au voisinage des bords, sur une distance de ' +
            'l’ordre de leur écartement : c’est là que le modèle du condensateur plan cesse de valoir.',
    ).className = 'note';

    recalcule();
}

const ANIMATIONS = { carte: carteDeChamp, condensateur: condensateurPlan };

lance('section.animation', (section) => ANIMATIONS[section.dataset.animation](section));
