// Les cartes du chapitre : lignes de champ et équipotentielles d'un jeu de
// charges que l'on déplace, conservation du flux le long d'un tube de champ,
// et le champ d'un condensateur plan, uniforme sauf près des bords.
//
// La physique est dans `champ.js` : des fils rectilignes infinis vus en
// coupe, pour que tout ce qui se lit sur la carte vaille dans le plan.

import { Graphe, échantillons } from '#animations/graphe.js';
import { COULEURS } from '#animations/objets.js';
import { cadre, lance } from '#animations/page.js';
import { Plan, aplat, chemin, disque, flèche, pointe } from '#animations/plan.js';
import { Réglages } from '#animations/reglages.js';
import { champ, contour, flux, grilleDePotentiel, lignesDeChamp, ligneDeChamp, niveaux, potentiel } from './champ.js';

const COULEUR = {
    positive: COULEURS.vermillon,
    négative: COULEURS.bleu,
    ligne: COULEURS.noir,
    équipotentielle: COULEURS.vert,
    sonde: COULEURS.violet,
    tube: 'rgba(230, 159, 0, 0.18)',
    section: COULEURS.orange,
};

/** L'espacement des équipotentielles : c'est lui qui fait parler la carte. */
const PAS_DU_POTENTIEL = 0.4;

const format = new Intl.NumberFormat('fr-FR', { maximumSignificantDigits: 3 });
/** Un nombre, écrit à la française et lisible par KaTeX. */
const nombre = (x) => format.format(x).replace('−', '-').replace(',', '{,}');

// -- Ce qui se dessine ---------------------------------------------------------

/** Les charges : un disque, plus le signe en blanc par-dessus. */
function dessineCharges(c, plan, charges, rayon = 11) {
    for (const charge of charges) {
        if (!charge.q) continue;
        const centre = plan.vers(charge.x, charge.y);
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
        for (const trait of traits) chemin(c, trait, { couleur: '#fff', épaisseur: 2.4 });
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
function dessineÉquipotentielles(c, plan, grille, pas = PAS_DU_POTENTIEL) {
    const trait = new Path2D();
    for (const niveau of niveaux(grille, pas)) {
        for (const [a, b] of contour(grille, niveau)) {
            trait.moveTo(...plan.vers(...a));
            trait.lineTo(...plan.vers(...b));
        }
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
function dessineDégradé(c, plan, grille, toile) {
    const { colonnes, lignes, valeurs, cadre: vue } = grille;
    if (toile.width !== colonnes || toile.height !== lignes) {
        toile.width = colonnes;
        toile.height = lignes;
    }
    const pinceau = toile.getContext('2d');
    const image = pinceau.createImageData(colonnes, lignes);
    for (let j = 0; j < lignes; j++) {
        for (let i = 0; i < colonnes; i++) {
            const t = Math.tanh(valeurs[j * colonnes + i] / 2.5);
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

/** Le cadre où les lignes de champ continuent de se calculer : un peu plus
 *  large que la vue, pour qu'aucune ne s'arrête sur son bord. */
const élargi = ({ x0, x1, y0, y1 }, marge = 3) => ({ x0: x0 - marge, x1: x1 + marge, y0: y0 - marge, y1: y1 + marge });

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
        if (état.montre.équipotentielles || état.montre.dégradé) {
            const grille = grilleDePotentiel(charges, vueDuPlan, 130);
            if (état.montre.dégradé) dessineDégradé(c, plan, grille, toile);
            if (état.montre.équipotentielles) dessineÉquipotentielles(c, plan, grille);
        }
        if (état.montre.lignes) {
            dessineLignes(c, plan, lignesDeChamp(charges, { cadre: élargi(vueDuPlan), pas: 0.07 }));
        }
        dessineCharges(c, plan, charges);

        // Le champ en M : une flèche qui sature, pour rester lisible partout.
        const [ex, ey] = champ(charges, ...état.M);
        const norme = Math.hypot(ex, ey);
        const départ = plan.vers(...état.M);
        nomM.montre(état.montre.sonde).place(...état.M, [-15, 13]);
        nomE.montre(état.montre.sonde && norme > 1e-6);
        if (état.montre.sonde) {
            const longueur = 12 + 104 * (norme / (norme + 0.9));
            disque(c, départ, 4, { couleur: COULEURS.noir });
            flèche(c, départ, [ex, -ey], longueur, { couleur: COULEUR.sonde, épaisseur: 2.5 });
            const bout = longueur + 14;
            nomE.place(...état.M, [(ex / norme) * bout, (-ey / norme) * bout]);
        }
        mesures.écrit(
            `\\lVert\\vec{E}\\rVert = ${nombre(norme)} \\quad V = ${nombre(potentiel(charges, ...état.M))}`,
        );
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
                pas: 0.5,
                valeur: charges[k]?.q ?? 1,
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
    réglages.texte('En unités arbitraires.').className = 'note';
    réglages.texte(
        'Les équipotentielles sont tracées de potentiel en potentiel, toujours du même écart : là où elles ' +
            'se resserrent, le champ est intense. Le champ leur est perpendiculaire et descend les potentiels.',
    ).className = 'note';
}

// -- Tube de champ -------------------------------------------------------------

const TUBES = {
    une: [{ x: -4, y: 0, q: 1 }],
    opposées: [
        { x: -4, y: 0, q: 1 },
        { x: 4, y: -0.6, q: -1 },
    ],
};

function tubeDeChamp(section) {
    const { vue, réglages: panneau } = cadre(section);
    const plan = new Plan(vue, { rapport: 16 / 10, étendue: 18, aide: 'Glisser les deux sections le long du tube.' });
    const état = { configuration: 'une', θ: 12, ouverture: 22, sections: [0.25, 0.75] };

    const noms = [1, 2].map((k) => plan.étiquette(`S_${k}`, { couleur: COULEUR.section }));

    /** Les deux lignes qui bordent le tube. Elles ne se recalculent que
     *  lorsque sa forme change : le pointeur interroge les poignées à chaque
     *  mouvement, et suivre une ligne de champ coûte. */
    let dernier = null;
    function bords() {
        const clé = `${état.configuration} ${état.θ} ${état.ouverture}`;
        if (dernier?.clé === clé) return dernier;
        const charges = TUBES[état.configuration];
        const cadreLarge = élargi(plan.cadre(), 1);
        const lignes = [-0.5, 0.5].map((côté) => {
            const angle = ((état.θ + côté * état.ouverture) * Math.PI) / 180;
            const départ = [charges[0].x + 0.18 * Math.cos(angle), charges[0].y + 0.18 * Math.sin(angle)];
            return ligneDeChamp(charges, départ, { pas: 0.06, cadre: cadreLarge, maximum: 1500 });
        });
        dernier = { clé, charges, lignes, longueur: Math.min(...lignes.map((l) => l.length)) };
        return dernier;
    }

    /** Le tube et ses deux sections, aux places où les curseurs les ont mises. */
    function tube() {
        const { charges, lignes, longueur } = bords();
        const sections = état.sections.map((part) => {
            const i = Math.min(longueur - 1, Math.max(1, Math.round(part * (longueur - 1))));
            return { i, a: lignes[0][i], b: lignes[1][i] };
        });
        return { charges, bords: lignes, longueur, sections };
    }

    plan.dessine((c) => {
        const { charges, bords, sections } = tube();
        // Le tube entre les deux sections : la portion dont on compare les
        // deux bouts.
        const [premier, second] = [...sections].sort((u, v) => u.i - v.i);
        aplat(
            c,
            [
                ...bords[0].slice(premier.i, second.i + 1).map(([x, y]) => plan.vers(x, y)),
                ...bords[1]
                    .slice(premier.i, second.i + 1)
                    .reverse()
                    .map(([x, y]) => plan.vers(x, y)),
            ],
            COULEUR.tube,
        );
        dessineLignes(c, plan, lignesDeChamp(charges, { cadre: élargi(plan.cadre()), pas: 0.07, parUnité: 10 }), {
            couleur: '#b6b6b6',
            épaisseur: 1,
        });
        dessineLignes(c, plan, bords, { épaisseur: 2 });
        for (const [k, s] of sections.entries()) {
            chemin(c, [plan.vers(...s.a), plan.vers(...s.b)], { couleur: COULEUR.section, épaisseur: 3 });
            const milieu = [(s.a[0] + s.b[0]) / 2, (s.a[1] + s.b[1]) / 2];
            disque(c, plan.vers(...milieu), 5, { couleur: COULEUR.section });
            noms[k].place(...milieu, [14, -12]);
        }
        dessineCharges(c, plan, charges);

        // Les mesures, en tableau : la longueur de la section, le champ en
        // son milieu, et le flux qui la traverse — calculé, non supposé.
        const colonne = sections.map((s) => {
            const milieu = [(s.a[0] + s.b[0]) / 2, (s.a[1] + s.b[1]) / 2];
            return {
                ℓ: Math.hypot(s.b[0] - s.a[0], s.b[1] - s.a[1]),
                E: Math.hypot(...champ(charges, ...milieu)),
                Φ: Math.abs(flux(charges, s.a, s.b)),
            };
        });
        const ligne = (nom, clé) => `${nom} & ${nombre(colonne[0][clé])} & ${nombre(colonne[1][clé])}`;
        mesures.écrit(
            `\\begin{array}{r|cc} & {\\color{${COULEUR.section}} S_1} & {\\color{${COULEUR.section}} S_2} \\\\ \\hline ` +
                `${ligne('\\ell', 'ℓ')} \\\\ ${ligne('\\lVert\\vec{E}\\rVert', 'E')} \\\\ ` +
                `${ligne('\\Phi', 'Φ')} \\end{array}`,
        );
    });

    for (const k of [0, 1]) {
        plan.poignée({
            position: () => {
                const s = tube().sections[k];
                return [(s.a[0] + s.b[0]) / 2, (s.a[1] + s.b[1]) / 2];
            },
            auDéplacement: (x, y) => {
                // La section suit le point du tube le plus proche du doigt.
                const { bords, longueur } = tube();
                let meilleure = état.sections[k];
                let écart = Infinity;
                for (let i = 1; i < longueur; i += 2) {
                    const mx = (bords[0][i][0] + bords[1][i][0]) / 2;
                    const my = (bords[0][i][1] + bords[1][i][1]) / 2;
                    const d = Math.hypot(x - mx, y - my);
                    if (d < écart) {
                        écart = d;
                        meilleure = i / (longueur - 1);
                    }
                }
                état.sections[k] = meilleure;
            },
        });
    }

    const réglages = new Réglages(panneau);
    réglages.groupe('Distribution');
    réglages.choix({
        options: [
            ['une', '\\text{une charge}'],
            ['opposées', '+\\,-'],
        ],
        valeur: état.configuration,
        auChangement: (v) => {
            état.configuration = v;
            plan.redessine();
        },
    });

    réglages.groupe('Tube');
    for (const [clé, options] of [
        ['θ', { tex: '\\theta', min: -180, max: 180, pas: 1, unité: '°' }],
        ['ouverture', { tex: '\\Delta\\theta', min: 4, max: 60, pas: 1, unité: '°' }],
    ]) {
        réglages.curseur({
            ...options,
            valeur: état[clé],
            auChangement: (v) => {
                état[clé] = v;
                plan.redessine();
            },
        });
    }

    réglages.groupe('Sections');
    const mesures = réglages.formule();
    réglages.texte(
        'Le tube ne contient aucune charge : ce qui entre par une section ressort par l’autre. Quand le tube ' +
            's’élargit, le champ faiblit d’autant — leur produit, le flux, ne bouge pas.',
    ).className = 'note';
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
    const toile = document.createElement('canvas');
    let charges = armatures(état);

    const armature = [
        plan.étiquette('+\\sigma', { couleur: COULEUR.positive, ancre: 'droite' }),
        plan.étiquette('-\\sigma', { couleur: COULEUR.négative, ancre: 'droite' }),
    ];

    plan.dessine((c) => {
        const vueDuPlan = plan.cadre();
        if (état.montre.équipotentielles) {
            dessineÉquipotentielles(c, plan, grilleDePotentiel(charges, vueDuPlan, 110), 1.2);
        }
        if (état.montre.lignes) {
            // Les lignes partent de l'armature positive, régulièrement
            // réparties, et de ses deux bords où le champ fuit au dehors.
            const départs = échantillons(-0.98, 0.98, 21).map((t) => [(t * état.largeur) / 2, état.e / 2 - 0.05]);
            départs.push([-état.largeur / 2 - 0.05, état.e / 2 + 0.08], [état.largeur / 2 + 0.05, état.e / 2 + 0.08]);
            dessineLignes(
                c,
                plan,
                départs.map((départ) => ligneDeChamp(charges, départ, { pas: 0.06, cadre: élargi(vueDuPlan, 1), arrivée: 0.06 })),
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
            échantillons(-1, 1, 200).map((u) => [u, Math.hypot(...champ(charges, u * état.largeur, 0)) / uniforme]),
        );
        plan.redessine();
    }

    const réglages = new Réglages(panneau);
    réglages.groupe('Armatures');
    for (const [clé, options] of [
        ['e', { tex: 'e', min: 0.6, max: 5, pas: 0.2 }],
        ['largeur', { tex: 'L', min: 4, max: 13, pas: 0.5 }],
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

const ANIMATIONS = { carte: carteDeChamp, tube: tubeDeChamp, condensateur: condensateurPlan };

lance('section.animation', (section) => ANIMATIONS[section.dataset.animation](section));
