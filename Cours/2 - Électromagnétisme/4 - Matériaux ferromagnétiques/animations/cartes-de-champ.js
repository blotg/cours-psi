// Les cartes de champ du chapitre : celles des figures du poly
// (Simulations/), que l'on manipule.
//
//   - Un aimant droit, une spire et un dipôle de même moment, dans un plan qui
//     contient leur axe : loin d'eux, leurs lignes de champ se confondent, et
//     l'on peut superposer celles du dipôle pour le voir (aimant.js).
//   - Des circuits magnétiques bobinés : sans entrefer, avec un entrefer que
//     l'on règle, et un électroaimant dont on déplace le barreau. Le champ y
//     est calculé par différences finies à chaque réglage (circuit.js).
//
// Dans les deux cas, les lignes de champ sont les lignes de niveau d'une
// fonction dont l'écart entre deux lignes est le flux qu'elles encadrent :
// des niveaux régulièrement espacés font une carte à flux constant.

import { contours, polylignes } from '#animations/carte.js';
import { COULEURS, écritTex } from '#animations/objets.js';
import { cadre, lance } from '#animations/page.js';
import { Plan, chemin, conducteur, disque, flèche, lignesDeChamp } from '#animations/plan.js';
import { Réglages } from '#animations/reglages.js';
import { AIMANT, DIPÔLE, fluxDeLAimant, fluxDeLaSpire, fluxDuDipôle, grilleDeFlux, niveaux } from './aimant.js';
import { Grille, MU0, champ, circuit, électroaimant } from './circuit.js';

/** Les couleurs des figures du poly (Simulations/lib.py) : le fer en gris
 *  clair, les pôles d'un aimant en rose et en vert. */
const COULEUR = {
    fer: '#d3d3d3',
    nord: '#f4a3a3',
    sud: '#a8dca8',
    ligne: COULEURS.noir,
    dipôle: COULEURS.bleu,
    règle: COULEURS.gris,
};

const format = new Intl.NumberFormat('fr-FR', { maximumSignificantDigits: 3, useGrouping: false });
/** Un nombre, écrit à la française et lisible par KaTeX. */
const nombre = (x) => format.format(x).replace('−', '-').replace(',', '{,}');

/** Les rectangles [x₁, x₂, y₁, y₂] d'un objet, remplis d'un seul tenant :
 *  pas de liseré entre deux rectangles accolés. */
function rectangles(c, plan, liste, couleur) {
    c.save();
    c.beginPath();
    for (const [x1, x2, y1, y2] of liste) {
        const [px, py] = plan.vers(x1, y2);
        c.rect(px, py, plan.long(x2 - x1), plan.long(y2 - y1));
    }
    c.fillStyle = couleur;
    c.fill();
    c.restore();
}

/** L'échelle : une règle de `longueur`, en bas à gauche de la vue. */
function règle(c, plan, nom, longueur) {
    const { x0, y0 } = plan.cadre();
    const [px, py] = [plan.X(x0) + 24, plan.Y(y0) - 20];
    const bouts = [
        [px, py],
        [px + plan.long(longueur), py],
    ];
    chemin(c, bouts, { couleur: COULEUR.règle, épaisseur: 2 });
    for (const [x, y] of bouts) chemin(c, [[x, y - 5], [x, y + 5]], { couleur: COULEUR.règle, épaisseur: 2 });
    const [x, y] = plan.depuis(px + plan.long(longueur) / 2, py - 13);
    nom.place(x, y);
}

// -- Aimant, spire et dipôle ---------------------------------------------------

function aimantSpireDipôle(section) {
    const { vue, réglages: panneau } = cadre(section);
    const plan = new Plan(vue, { rapport: 5 / 4, étendue: 7.5 });
    const état = { objet: 'aimant', dipôle: false };
    const nomNord = plan.étiquette('\\mathbf{N}', { taille: '0.95rem' });
    const nomSud = plan.étiquette('\\mathbf{S}', { taille: '0.95rem' });

    // Les lignes de chaque objet ne se calculent qu'une fois, à la demande :
    // celles de l'aimant demandent soixante-quatre spires par point.
    const flux = { spire: fluxDeLaSpire, dipôle: fluxDuDipôle, aimant: null };
    const cartes = {};
    function carte(objet, n) {
        const clé = `${objet}-${n}`;
        if (!cartes[clé]) {
            flux.aimant ??= fluxDeLAimant();
            const grille = grilleDeFlux(flux[objet], plan.cadre(), 300);
            cartes[clé] = { grille, lignes: polylignes(contours(grille, niveaux(n))) };
        }
        return cartes[clé];
    }

    /** Le sens du champ en (x, y), d'après la grille de F : B = −(1/x)
     *  (∂F/∂y, −∂F/∂x), et c'est le signe de x qui compte. Sur l'axe, le
     *  champ va vers le haut, dans le sens du moment. */
    const sens = (grille) => (x, y) => {
        if (Math.abs(x) < 1e-9) return [0, 1];
        const [a, b] = champ(grille, x, y);
        return x < 0 ? [a, b] : [-a, -b];
    };

    /** L'axe est une ligne de champ, que le champ parcourt vers le haut : on
     *  le trace hors du disque qui figure le dipôle. */
    function axe(objet) {
        const { y0, y1 } = plan.cadre();
        if (objet !== 'dipôle') return [[[0, y0], [0, y1]]];
        return [
            [[0, y0], [0, -DIPÔLE]],
            [[0, DIPÔLE], [0, y1]],
        ];
    }

    plan.dessine((c) => {
        const { objet } = état;
        const { rayon: R, hauteur: L } = AIMANT;
        if (objet === 'aimant') {
            rectangles(c, plan, [[-R, R, 0, L / 2]], COULEUR.nord);
            rectangles(c, plan, [[-R, R, -L / 2, 0]], COULEUR.sud);
        }

        // Les pointes sur le plan équatorial, comme dans le poly : près de
        // l'objet, les lignes se resserrent trop pour en porter chacune.
        const { grille, lignes } = carte(objet, objet === 'dipôle' ? 30 : 16);
        lignesDeChamp(c, plan, [...lignes, ...axe(objet)], sens(grille), {
            traversée: { y: 0, écart: plan.long(0.3) },
        });
        if (état.dipôle && objet !== 'dipôle') {
            const autre = carte('dipôle', 16);
            lignesDeChamp(c, plan, autre.lignes, sens(autre.grille), {
                couleur: COULEUR.dipôle,
                épaisseur: 1.6,
                pointillés: [7, 5],
                entre: Infinity,
            });
        }

        nomNord.montre(objet === 'aimant').place(0, L / 2 - 0.25);
        nomSud.montre(objet === 'aimant').place(0, -L / 2 + 0.25);
        if (objet === 'aimant') {
            const [px, py] = plan.vers(-R, L / 2);
            c.save();
            c.strokeStyle = COULEURS.noir;
            c.lineWidth = 1.4;
            c.strokeRect(px, py, plan.long(2 * R), plan.long(L));
            c.restore();
        }
        if (objet === 'spire') {
            // Le moment est selon +y : le courant vient vers nous à gauche.
            conducteur(c, plan.vers(-1, 0), 1, plan.long(0.08));
            conducteur(c, plan.vers(1, 0), -1, plan.long(0.08));
        }
        if (objet === 'dipôle') {
            disque(c, plan.vers(0, 0), plan.long(DIPÔLE), { couleur: '#fff', bord: COULEURS.noir, épaisseur: 1.4 });
            flèche(c, plan.vers(0, -0.7 * DIPÔLE), [0, -1], plan.long(1.4 * DIPÔLE), { épaisseur: 2.2, tête: 9 });
        }
    });

    const réglages = new Réglages(panneau);
    réglages.groupe('Objet');
    réglages.choix({
        options: [
            ['spire', '\\text{spire}'],
            ['dipôle', '\\text{dipôle}'],
            ['aimant', '\\text{aimant}'],
        ],
        valeur: état.objet,
        auChangement: (objet) => {
            état.objet = objet;
            superposition.montre(objet !== 'dipôle');
            plan.redessine();
        },
    });
    const superposition = réglages.case({
        texte: 'Le dipôle de même moment',
        couleur: COULEUR.dipôle,
        valeur: état.dipôle,
        auChangement: (oui) => {
            état.dipôle = oui;
            plan.redessine();
        },
    });
}

// -- Circuits magnétiques ------------------------------------------------------

/** La vue de chaque circuit, en mètres : le cadre et l'électroaimant. */
const VUES = {
    cadre: { étendue: 0.2, centre: [0, 0] },
    électroaimant: { étendue: 0.22, centre: [0, 0.014] },
};

/** Le pas de la grille, fin au repos, grossier tant que l'on manipule. */
const PAS = { fin: 1e-3, grossier: 2e-3 };

/** La perméabilité relative du fer : celle des figures du poly. */
const μr = 1e5;

/** Le barreau de l'électroaimant : sa largeur et son épaisseur, en mètres,
 *  et les entrefers entre lesquels on le déplace. */
const BARREAU = { largeur: 0.1, épaisseur: 0.02, e: [2e-3, 40e-3], décalage: 0.03 };

/**
 * Les circuits. L'écart de flux entre deux lignes voisines (en webers par
 * mètre de circuit selon z) est fixé pour chacun : quand l'entrefer s'ouvre,
 * le flux diminue, et les lignes se raréfient. Le circuit sans entrefer, que
 * rien ne règle, garde dix lignes, comme dans le poly.
 */
const CIRCUITS = {
    fermé: { vue: 'cadre', pas: null },
    entrefer: { vue: 'cadre', pas: 0.4e-3 },
    électroaimant: { vue: 'électroaimant', pas: 0.25e-3 },
};

function circuitsMagnétiques(section) {
    const { vue, réglages: panneau } = cadre(section);
    const plan = new Plan(vue, { rapport: 5 / 4, ...VUES.cadre });
    const état = { circuit: 'entrefer', e: 5e-3, barreau: [0, -5e-3 - BARREAU.épaisseur / 2] };
    const nomRègle = plan.étiquette('5\\,\\mathrm{cm}', { couleur: COULEUR.règle, taille: '0.9rem' });

    /** Le circuit tel que les réglages le décrivent. */
    function géométrie() {
        if (état.circuit === 'fermé') return circuit({ e: 0 });
        if (état.circuit === 'entrefer') return circuit({ e: état.e });
        return électroaimant({ barreau: état.barreau });
    }

    // Une grille par vue et par pas, gardée d'un calcul à l'autre : chacun
    // part de la solution du précédent.
    const grilles = {};
    function grille(précision) {
        const clé = `${CIRCUITS[état.circuit].vue}-${précision}`;
        if (!grilles[clé]) {
            const { x0, x1, y0, y1 } = plan.cadre();
            grilles[clé] = new Grille({ x0, x1, y0, y1 }, PAS[précision]);
        }
        return grilles[clé];
    }

    let résultat = null;
    function calcule(précision) {
        const objet = géométrie();
        const g = grille(précision);
        g.remplit(objet, μr);
        g.résout();
        const carte = g.carte();
        let [bas, haut] = [Infinity, -Infinity];
        for (const v of carte.valeurs) [bas, haut] = [Math.min(bas, v), Math.max(haut, v)];
        const { pas } = CIRCUITS[état.circuit];
        // Dix lignes entre les extrêmes, ou une tous les `pas`. Pas de ligne
        // à moins d'un demi-écart d'un extrême : elle ne ferait qu'un lacet
        // autour du sommet de A_z, le long d'une rangée de fils.
        const [premier, dernier] = pas ? [Math.ceil(bas / pas + 0.5), Math.floor(haut / pas - 0.5)] : [1, 10];
        const niveaux = Array.from({ length: Math.max(0, dernier - premier + 1) }, (_, k) =>
            pas ? (premier + k) * pas : bas + ((haut - bas) * (premier + k)) / 11,
        );
        résultat = { objet, carte, lignes: polylignes(contours(carte, niveaux)), B: Math.hypot(...champ(carte, ...objet.sonde)) };
        écritLesMesures();
        plan.redessine();
    }

    // On calcule à chaque image où quelque chose a changé : sur la grille
    // grossière tant que l'on manipule, sur la fine dès que l'on s'arrête un
    // quart de seconde.
    let version = 0;
    let grossière = -1;
    let fine = -1;
    let calme = Infinity;
    function change() {
        version++;
        calme = 0;
    }
    plan.àChaqueImage((dt) => {
        calme += dt;
        if (fine === version) return;
        if (calme > 0.25) {
            calcule('fin');
            fine = grossière = version;
        } else if (grossière !== version) {
            calcule('grossier');
            grossière = version;
        }
    });

    const sens = (x, y) => champ(résultat.carte, x, y);
    plan.dessine((c) => {
        if (!résultat) return;
        const { objet, lignes } = résultat;
        rectangles(c, plan, objet.fer, COULEUR.fer);
        // Les pointes là où les lignes traversent l'entrefer, comme dans le
        // poly.
        lignesDeChamp(c, plan, lignes, sens, { traversée: { y: objet.sonde[1], écart: plan.long(0.004) } });
        for (const [x, y, r, I] of objet.fils) conducteur(c, plan.vers(x, y), I, plan.long(r));
        règle(c, plan, nomRègle, 0.05);
    });

    // Le barreau se prend n'importe où, et ne touche jamais le U.
    const dansLeBarreau = (x, y) =>
        état.circuit === 'électroaimant' &&
        Math.abs(x - état.barreau[0]) < BARREAU.largeur / 2 &&
        Math.abs(y - état.barreau[1]) < BARREAU.épaisseur / 2 + 2e-3;
    function placeLeBarreau(x, y) {
        const [eMin, eMax] = BARREAU.e;
        const demi = BARREAU.épaisseur / 2;
        état.barreau = [
            Math.min(Math.max(x, -BARREAU.décalage), BARREAU.décalage),
            Math.min(Math.max(y, -eMax - demi), -eMin - demi),
        ];
        curseurs.électroaimant.valeur = 1e3 * (-état.barreau[1] - demi);
        change();
    }
    plan.poignée({
        position: () => état.barreau,
        contient: dansLeBarreau,
        auDéplacement: placeLeBarreau,
    });

    // -- Réglages -------------------------------------------------------------

    const réglages = new Réglages(panneau);
    réglages.groupe('Circuit magnétique');
    réglages.choix({
        options: [
            ['fermé', '\\text{sans entrefer}'],
            ['entrefer', '\\text{avec entrefer}'],
            ['électroaimant', '\\text{électroaimant}'],
        ],
        valeur: état.circuit,
        auChangement: (choisi) => {
            état.circuit = choisi;
            Object.assign(plan, VUES[CIRCUITS[choisi].vue]);
            plan.redimensionne();
            montreLesRéglages();
            change();
            calme = Infinity;
        },
    });
    const curseurs = {
        entrefer: réglages.curseur({
            tex: 'e',
            min: 2,
            max: 20,
            pas: 0.1,
            valeur: 1e3 * état.e,
            unité: ' mm',
            auChangement: (v) => {
                état.e = v * 1e-3;
                change();
            },
        }),
        électroaimant: réglages.curseur({
            tex: 'e',
            min: 1e3 * BARREAU.e[0],
            max: 1e3 * BARREAU.e[1],
            pas: 0.1,
            valeur: 1e3 * (-état.barreau[1] - BARREAU.épaisseur / 2),
            unité: ' mm',
            auChangement: (v) => {
                état.barreau = [état.barreau[0], -v * 1e-3 - BARREAU.épaisseur / 2];
                change();
            },
        }),
    };

    const mesures = réglages.groupe('Au milieu de l’entrefer');
    const simulé = réglages.formule();
    const attendu = réglages.formule();
    const note = réglages.texte();
    note.className = 'note';
    note.append(
        écritTex(document.createElement('span'), 'N i = 500\\,\\mathrm{A}'),
        ', ',
        écritTex(document.createElement('span'), '\\mu_r = 10^5'),
        '. Moins de lignes, moins de flux.',
    );

    function montreLesRéglages() {
        curseurs.entrefer.montre(état.circuit === 'entrefer');
        curseurs.électroaimant.montre(état.circuit === 'électroaimant');
        mesures.élément.hidden = état.circuit === 'fermé';
        plan.toile.style.cursor = '';
    }

    function écritLesMesures() {
        if (état.circuit === 'fermé') return;
        const { objet, B } = résultat;
        // Deux entrefers en série pour l'électroaimant.
        const deux = état.circuit === 'électroaimant';
        const e = deux ? objet.e : état.e;
        simulé.écrit(`B = ${nombre(B * 1e3)}\\,\\mathrm{mT}`);
        attendu.écrit(
            `\\frac{\\mu_0 N i}{${deux ? '2e' : 'e'}} = ${nombre(((MU0 * objet.Ni) / ((deux ? 2 : 1) * e)) * 1e3)}\\,\\mathrm{mT}`,
        );
    }

    montreLesRéglages();
}

const ANIMATIONS = { aimant: aimantSpireDipôle, circuits: circuitsMagnétiques };

lance('section.animation', (section) => ANIMATIONS[section.dataset.animation](section));
