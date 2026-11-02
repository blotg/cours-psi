// Les cartes de champ du chapitre : celles des figures du poly
// (Simulations/), que l'on manipule.
//
//   - Un aimant droit, une spire et un dipôle de même moment, dans un plan qui
//     contient leur axe : loin d'eux, leurs lignes de champ se confondent, et
//     l'on peut superposer celles du dipôle pour le voir (aimant.js).
//   - Des circuits magnétiques bobinés : sans entrefer, avec un entrefer que
//     l'on règle, et un électroaimant dont on déplace le barreau. Le champ y
//     est calculé par différences finies à chaque réglage (circuit.js).
//   - Le même calcul, à la perméabilité du fer près, que l'on règle de l'air
//     au mu-métal : un noyau droit dans sa bobine, comme le clou de la
//     situation déclenchante, le circuit fermé, et un blindage dans un champ
//     uniforme. Le fer canalise les lignes de champ.
//
// Dans les deux cas, les lignes de champ sont les lignes de niveau d'une
// fonction dont l'écart entre deux lignes est le flux qu'elles encadrent :
// des niveaux régulièrement espacés font une carte à flux constant.
//
// Les deux vues se déplacent et se zoomment : le champ se calcule sur ce
// qu'elles montrent, grossièrement pendant le geste, finement dès qu'il
// s'arrête.

import { contours, grille, polylignes, ronde } from '#animations/carte.js';
import { COULEURS, écritTex } from '#animations/objets.js';
import { cadre, lance } from '#animations/page.js';
import { Plan, chemin, conducteur, disque, flèche, lignesDeChamp } from '#animations/plan.js';
import { Réglages } from '#animations/reglages.js';
import { AIMANT, DIPÔLE, fluxDeLAimant, fluxDeLaSpire, fluxDuDipôle, niveaux } from './aimant.js';
import { Grille, MU0, blindage, champ, circuit, noyauDroit, électroaimant } from './circuit.js';

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

/** Ce que l'on peut faire de la vue : la rapprocher deux fois, l'éloigner
 *  quatre fois. */
const NAVIGATION = { rapproche: 2, éloigne: 4 };

/** L'écart minimal entre deux pointes, en pixels : sur la droite qu'elles
 *  jalonnent — l'équateur de l'aimant, l'entrefer d'un circuit —, ou entre
 *  deux lignes que le fer resserre. */
const ENTRE_POINTES = { aimant: 30, circuit: 15, perméabilité: 24 };

/**
 * Refait un calcul à chaque image où quelque chose a changé — un réglage, la
 * vue : grossier (`calcule(false)`) tant que l'on manipule, fin
 * (`calcule(true)`) dès que l'on s'arrête un quart de seconde. `change(true)`
 * demande tout de suite le calcul fin : un autre objet, qui ne se manipule
 * pas.
 */
function àLaDemande(plan, calcule) {
    let version = 0;
    let grossière = -1;
    let fine = -1;
    let calme = Infinity;
    plan.àChaqueImage((dt) => {
        calme += dt;
        if (fine === version) return;
        if (calme > 0.25) {
            calcule(true);
            fine = grossière = version;
        } else if (grossière !== version) {
            calcule(false);
            grossière = version;
        }
    });
    const change = (toutDeSuite = false) => {
        version++;
        calme = toutDeSuite ? Infinity : 0;
    };
    plan.àChaqueVue(() => change());
    return change;
}

/**
 * Le domaine d'un calcul : la vue, et la vue de départ, qui contient l'objet
 * tout entier — le barreau de l'électroaimant compris, où qu'on le mette —,
 * plus une marge. Quand on zoome sur un coin, le reste de l'objet compte
 * encore.
 */
function domaine(plan, vue, marge) {
    const { étendue, centre } = plan.départ;
    const [demiLargeur, demiHauteur] = [étendue / 2, étendue / 2 / plan.rapport];
    return {
        x0: Math.min(vue.x0, centre[0] - demiLargeur) - marge,
        x1: Math.max(vue.x1, centre[0] + demiLargeur) + marge,
        y0: Math.min(vue.y0, centre[1] - demiHauteur) - marge,
        y1: Math.max(vue.y1, centre[1] + demiHauteur) + marge,
    };
}

/** Les niveaux `niveau(k)`, pour k de `premier` à `dernier`. */
const suite = (premier, dernier, niveau) =>
    Array.from({ length: Math.max(0, dernier - premier + 1) }, (_, k) => niveau(premier + k));

/** L'échelle : une règle de longueur ronde, en bas à gauche de la vue, qui
 *  en prend à peu près le cinquième. */
function règle(c, plan, nom) {
    const longueur = ronde(plan.étendue / 5);
    nom.écrit(`${nombre(longueur * 100)}\\,\\mathrm{cm}`);
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
    const plan = new Plan(vue, { rapport: 5 / 4, étendue: 7.5, navigable: NAVIGATION });
    const état = { objet: 'aimant', dipôle: false };
    const nomNord = plan.étiquette('\\mathbf{N}', { taille: '0.95rem' });
    const nomSud = plan.étiquette('\\mathbf{S}', { taille: '0.95rem' });

    // F sur une grille de la vue, et ses lignes de niveau : pour l'objet
    // choisi, et pour le dipôle qu'on lui superpose.
    const flux = { spire: fluxDeLaSpire, dipôle: fluxDuDipôle, aimant: fluxDeLAimant() };
    const carte = (objet, n, colonnes) => {
        const valeurs = grille(flux[objet], plan.cadre(), colonnes);
        return { grille: valeurs, lignes: polylignes(contours(valeurs, niveaux(n))) };
    };
    let cartes = null;
    const change = àLaDemande(plan, (fin) => {
        const colonnes = fin ? 300 : 150;
        const { objet } = état;
        cartes = {
            objet: carte(objet, objet === 'dipôle' ? 30 : 16, colonnes),
            dipôle: état.dipôle && objet !== 'dipôle' ? carte('dipôle', 16, colonnes) : null,
        };
        plan.redessine();
    });

    /** Le sens du champ en (x, y), d'après la grille de F : B = −(1/x)
     *  (∂F/∂y, −∂F/∂x), et c'est le signe de x qui compte. Sur l'axe, le
     *  champ va vers le haut, dans le sens du moment. */
    const sens = (F) => (x, y) => {
        if (Math.abs(x) < 1e-9) return [0, 1];
        const [a, b] = champ(F, x, y);
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
        ].filter(([[, a], [, b]]) => a < b);
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
        if (!cartes) return;
        const { grille: valeurs, lignes } = cartes.objet;
        lignesDeChamp(c, plan, [...lignes, ...axe(objet)], sens(valeurs), {
            traversée: { y: 0, écart: ENTRE_POINTES.aimant },
        });
        if (cartes.dipôle) {
            const autre = cartes.dipôle;
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
            change(true);
        },
    });
    const superposition = réglages.case({
        texte: 'Le dipôle de même moment',
        couleur: COULEUR.dipôle,
        valeur: état.dipôle,
        auChangement: (oui) => {
            état.dipôle = oui;
            change(true);
        },
    });
}

// -- Circuits magnétiques ------------------------------------------------------

/** La vue de chaque circuit, en mètres : le cadre et l'électroaimant. */
const VUES = {
    cadre: { étendue: 0.2, centre: [0, 0] },
    électroaimant: { étendue: 0.22, centre: [0, 0.014] },
};

/** Le nombre de mailles sur la largeur de la vue, au repos et tant que
 *  l'on manipule : le calcul coûte autant à tout zoom, et la maille vaut
 *  1 mm dans la vue de départ du cadre. */
const MAILLES = { fin: 200, grossier: 100 };

/** La marge, en mètres, entre le circuit et le bord lointain du calcul. */
const MARGE = 0.06;

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
    const plan = new Plan(vue, {
        rapport: 5 / 4,
        ...VUES.cadre,
        navigable: NAVIGATION,
        aide: 'Glisser la vue, ou le barreau de l’électroaimant ; molette ou pincement pour zoomer.',
    });
    const état = { circuit: 'entrefer', e: 5e-3, barreau: [0, -5e-3 - BARREAU.épaisseur / 2] };
    const nomRègle = plan.étiquette('5\\,\\mathrm{cm}', { couleur: COULEUR.règle, taille: '0.9rem' });

    /** Le circuit tel que les réglages le décrivent. */
    function géométrie() {
        if (état.circuit === 'fermé') return circuit({ e: 0 });
        if (état.circuit === 'entrefer') return circuit({ e: état.e });
        return électroaimant({ barreau: état.barreau });
    }

    // Une grille par précision, refaite à chaque calcul sur la vue et sur le
    // fer.
    const grilles = { fin: new Grille(), grossier: new Grille() };

    let résultat = null;
    const change = àLaDemande(plan, (fin) => {
        const objet = géométrie();
        const vue = plan.cadre();
        const mailles = MAILLES[fin ? 'fin' : 'grossier'];
        const g = grilles[fin ? 'fin' : 'grossier'].maille(vue, (vue.x1 - vue.x0) / mailles, domaine(plan, vue, MARGE), objet.fer);
        g.remplit(objet, μr);
        g.résout();
        const carte = g.carte(vue, mailles + 1);
        let [bas, haut] = [Infinity, -Infinity];
        for (const v of carte.valeurs) [bas, haut] = [Math.min(bas, v), Math.max(haut, v)];
        const { pas } = CIRCUITS[état.circuit];
        // Dix lignes entre les extrêmes, ou une tous les `pas`. Pas de ligne
        // à moins d'un demi-écart d'un extrême : elle ne ferait qu'un lacet
        // autour du sommet de A_z, le long d'une rangée de fils. Ni de ligne
        // A_z = 0, qui file vers le bord lointain du calcul.
        //
        // `contours` veut des niveaux régulièrement espacés : ceux d'en
        // dessous de zéro, puis ceux d'au-dessus, en deux passes.
        const passes = pas
            ? [
                  suite(Math.ceil(bas / pas + 0.5), -1, (k) => k * pas),
                  suite(1, Math.floor(haut / pas - 0.5), (k) => k * pas),
              ]
            : [suite(1, 10, (k) => bas + ((haut - bas) * k) / 11)];
        const segments = passes.flatMap((niveaux) => contours(carte, niveaux));
        résultat = { objet, carte, lignes: polylignes(segments), B: Math.hypot(...g.champ(...objet.sonde)) };
        écritLesMesures();
        plan.redessine();
    });

    const sens = (x, y) => champ(résultat.carte, x, y);
    plan.dessine((c) => {
        if (!résultat) return;
        const { objet, lignes } = résultat;
        rectangles(c, plan, objet.fer, COULEUR.fer);
        // Les pointes là où les lignes traversent l'entrefer, comme dans le
        // poly.
        lignesDeChamp(c, plan, lignes, sens, { traversée: { y: objet.sonde[1], écart: ENTRE_POINTES.circuit } });
        for (const [x, y, r, I] of objet.fils) conducteur(c, plan.vers(x, y), I, plan.long(r));
        règle(c, plan, nomRègle);
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
            plan.vueDeDépart(VUES[CIRCUITS[choisi].vue]);
            montreLesRéglages();
            change(true);
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
        const cours = (MU0 * objet.Ni) / ((deux ? 2 : 1) * e);
        simulé.écrit(`B = ${nombre(B * 1e3)}\\,\\mathrm{mT}`);
        attendu.écrit(`\\frac{\\mu_0 N i}{${deux ? '2e' : 'e'}} = ${nombre(cours * 1e3)}\\,\\mathrm{mT}`);
    }

    montreLesRéglages();
}

// -- Perméabilité ---------------------------------------------------------------

/**
 * Les situations où l'on règle la perméabilité du fer : un noyau droit dans
 * sa bobine, comme le clou de la situation déclenchante — le champ y
 * plafonne vite, faute de circuit fermé —, le circuit fermé, où il suit
 * μ_r, et un blindage, dont le fer détourne les lignes d'un champ uniforme.
 * `où` nomme le point où l'on compare le champ à celui que l'on aurait sans
 * fer.
 */
const SITUATIONS = {
    noyau: { objet: () => noyauDroit(), vue: { étendue: 0.24, centre: [0, 0] }, où: 'Au centre de la bobine' },
    fermé: { objet: () => circuit({ e: 0 }), vue: VUES.cadre, où: 'Au centre de la bobine' },
    blindage: { objet: () => blindage(), vue: { étendue: 0.24, centre: [0, 0] }, où: 'Au centre du blindage' },
};

/** μ_r, de 1 à 10⁵, par son exposant : deux cents positions. */
const EXPOSANT = { max: 5, pas: 0.025 };

/**
 * Le nombre de lignes : autour d'une bobine, douze entre les extrêmes de A_z,
 * à toute perméabilité — c'est leur chemin qui change, pas leur nombre ; dans
 * un champ uniforme, seize dans la hauteur de la vue de départ.
 */
const LIGNES = { bobine: 12, fond: 16 };

/** La marge jusqu'au bord du calcul, plus large qu'ailleurs : le champ
 *  uniforme y est imposé, et le blindage le dérange d'autant moins qu'il en
 *  est loin (comme le carré de la distance). */
const LOIN = 0.3;

/** La précision du calcul. Le champ dans le blindage n'est qu'une petite
 *  part du champ extérieur, qui fixe l'échelle de la convergence : à 10⁻³,
 *  il serait faux d'un quart. */
const TOLÉRANCE = { bobine: 1e-3, fond: 1e-5 };

const puissance = new Intl.NumberFormat('fr-FR', { maximumSignificantDigits: 2 });

/** Un rapport, en écriture scientifique hors de [0,01 ; 10 000[. */
function rapport(x) {
    if (x >= 0.01 && x < 1e4) return nombre(x);
    const n = Math.floor(Math.log10(x));
    return `${nombre(x / 10 ** n)} \\times 10^{${n}}`;
}

function perméabilité(section) {
    const { vue, réglages: panneau } = cadre(section);
    const état = { situation: 'noyau', exposant: 2 };
    const plan = new Plan(vue, { rapport: 5 / 4, ...SITUATIONS[état.situation].vue, navigable: NAVIGATION });
    const nomRègle = plan.étiquette('5\\,\\mathrm{cm}', { couleur: COULEUR.règle, taille: '0.9rem' });

    // Une grille par précision, et, pour chacune, celle du même calcul sans
    // fer : le champ qu'elle donne ne dépend pas de μ_r, on ne le refait que
    // quand la grille change.
    const grilles = { fin: new Grille(), grossier: new Grille() };
    const vides = { fin: { grille: new Grille(), clé: '' }, grossier: { grille: new Grille(), clé: '' } };

    let résultat = null;
    const change = àLaDemande(plan, (fin) => {
        const précision = fin ? 'fin' : 'grossier';
        const objet = SITUATIONS[état.situation].objet();
        const μr = 10 ** état.exposant;
        const vue = plan.cadre();
        const étendu = domaine(plan, vue, LOIN);
        const mailles = MAILLES[précision];
        const h = (vue.x1 - vue.x0) / mailles;
        const tolérance = TOLÉRANCE[objet.fond ? 'fond' : 'bobine'];
        const g = grilles[précision].maille(vue, h, étendu, objet.fer);
        g.remplit(objet, μr);
        g.résout(tolérance);

        const vide = vides[précision];
        const clé = [état.situation, vue.x0, vue.x1, vue.y0, vue.y1].join();
        if (vide.clé !== clé) {
            vide.grille.maille(vue, h, étendu, objet.fer).remplit(objet, 1);
            vide.grille.résout(tolérance);
            Object.assign(vide, { clé, B: Math.hypot(...vide.grille.champ(...objet.centre)) });
        }

        const carte = g.carte(vue, mailles + 1);
        let niveaux;
        if (objet.fond) {
            // Des niveaux fixes, à mi-chemin entre deux multiples du pas :
            // pas de ligne sur l'axe, qui traverserait le blindage quoi
            // qu'il arrive — par symétrie, A_z y est nul.
            const pas = (Math.hypot(...objet.fond) * plan.départ.étendue) / plan.rapport / LIGNES.fond;
            let [bas, haut] = [Infinity, -Infinity];
            for (const v of carte.valeurs) [bas, haut] = [Math.min(bas, v), Math.max(haut, v)];
            niveaux = suite(Math.ceil(bas / pas - 0.5), Math.floor(haut / pas - 0.5), (k) => (k + 0.5) * pas);
        } else {
            const [bas, haut] = g.extrêmes();
            niveaux = suite(1, LIGNES.bobine, (k) => bas + ((haut - bas) * k) / (LIGNES.bobine + 1));
        }
        résultat = { objet, μr, carte, lignes: polylignes(contours(carte, niveaux)) };
        const B = Math.hypot(...g.champ(...objet.centre));
        gain.écrit(`\\dfrac{B}{B_{\\mu_r = 1}} = ${rapport(B / vide.B)}`);
        plan.redessine();
    });

    const sens = (x, y) => champ(résultat.carte, x, y);
    plan.dessine((c) => {
        if (!résultat) return;
        const { objet, lignes, μr } = résultat;
        // Le fer d'autant plus soutenu que sa perméabilité est grande : à
        // μ_r = 1, ce n'est plus que la place qu'il occupe.
        c.save();
        c.globalAlpha = 0.25 + (0.75 * Math.log10(μr)) / EXPOSANT.max;
        rectangles(c, plan, objet.fer, COULEUR.fer);
        c.restore();
        lignesDeChamp(c, plan, lignes, sens, { écart: ENTRE_POINTES.perméabilité });
        for (const [x, y, r, I] of objet.fils) conducteur(c, plan.vers(x, y), I, plan.long(r));
        règle(c, plan, nomRègle);
    });

    // -- Réglages -------------------------------------------------------------

    const réglages = new Réglages(panneau);
    réglages.groupe('Situation');
    réglages.choix({
        options: [
            ['noyau', '\\text{noyau droit}'],
            ['fermé', '\\text{circuit fermé}'],
            ['blindage', '\\text{blindage}'],
        ],
        valeur: état.situation,
        auChangement: (choisie) => {
            état.situation = choisie;
            plan.vueDeDépart(SITUATIONS[choisie].vue);
            mesure.écrit(SITUATIONS[choisie].où);
            change(true);
        },
    });
    réglages.groupe('Fer');
    réglages.curseur({
        tex: '\\mu_r',
        min: 0,
        max: EXPOSANT.max,
        pas: EXPOSANT.pas,
        valeur: état.exposant,
        aimants: Array.from({ length: EXPOSANT.max + 1 }, (_, k) => k),
        formate: (v) => puissance.format(10 ** v),
        auChangement: (v) => {
            état.exposant = v;
            change();
        },
    });
    const mesure = réglages.groupe(SITUATIONS[état.situation].où);
    const gain = réglages.formule();
    const note = réglages.texte('Fer linéaire, sans saturation.');
    note.className = 'note';
}

const ANIMATIONS = { aimant: aimantSpireDipôle, circuits: circuitsMagnétiques, perméabilité };

lance('section.animation', (section) => ANIMATIONS[section.dataset.animation](section));
