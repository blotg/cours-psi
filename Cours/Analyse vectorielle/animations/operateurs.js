// Les opérateurs de l'analyse vectorielle, appliqués à des champs plans que
// l'on parcourt en déplaçant un point M.
//
// Le champ est dessiné en entier — un champ scalaire par une échelle de
// couleurs, un champ vectoriel par des flèches —, et l'opérateur en M
// seulement, sous une forme qui dit sa nature :
//
//   - un scalaire (div, Δ) par un disque marqué de son signe, rouge s'il est
//     positif et bleu sinon, comme les charges du chapitre d'électrostatique :
//     une divergence positive est une source ;
//   - un vecteur du plan (grad, Δ⃗) par une flèche ;
//   - un vecteur perpendiculaire à l'écran (rot) par ⊙ s'il en sort, ⊗ s'il
//     s'y enfonce.
//
// La case « dans tout le plan » répète ce dessin sur une grille : on y voit
// d'un coup où sont les sources et les tourbillons.
//
// Les champs et les opérateurs sont dans `champs.js`.

import { contours, étendue, grille, niveaux, ronde } from '#animations/carte.js';
import { COULEURS } from '#animations/objets.js';
import { cadre, lance } from '#animations/page.js';
import { Plan, chemin, disque, flèche } from '#animations/plan.js';
import { Réglages } from '#animations/reglages.js';
import {
    cercle,
    circulationParSurface,
    divergence,
    fluxParVolume,
    gradient,
    gradientDeLaDivergence,
    laplacien,
    laplacienVectoriel,
    moinsRotationnelDuRotationnel,
    rotationnel,
    SCALAIRES,
    SEUIL,
    VECTORIELS,
} from './champs.js';

const COULEUR = {
    opérateur: COULEURS.violet,
    positif: COULEURS.vermillon,
    négatif: COULEURS.bleu,
    champ: '#3d3d3d',
    niveau: 'rgba(0, 0, 0, 0.4)',
    contour: COULEURS.gris,
    roue: '#444',
    gradDiv: COULEURS.vert,
    rotRot: COULEURS.orange,
};

/** L'échelle de couleurs du champ scalaire : une seule teinte, du plus clair
 *  (les valeurs basses) au plus foncé. Elle s'arrête à mi-sombre, pour que
 *  les équipotentielles et les flèches restent lisibles par-dessus. */
const TEINTES = [
    [0, [244, 249, 247]],
    [0.5, [157, 207, 189]],
    [1, [46, 132, 104]],
];

function teinte(t) {
    const k = t < TEINTES[1][0] ? 0 : 1;
    const [[a, ca], [b, cb]] = [TEINTES[k], TEINTES[k + 1]];
    const u = Math.min(Math.max((t - a) / (b - a), 0), 1);
    return ca.map((c, i) => c + (cb[i] - c) * u);
}

/** Les tailles, en unités du problème : elles suivent la vue quand elle
 *  change de largeur, sur un téléphone comme au tableau. */
const TAILLE = {
    /** Écart entre deux flèches du champ (cf. `pasDesFlèches`). */
    pas: 0.8,
    /** La plus longue flèche en M, et le plus grand disque. */
    flèche: 1.6,
    rayon: 0.4,
    /** La roue à aubes. */
    roue: 0.55,
    /** La plus longue flèche sur le contour. */
    contour: 0.6,
};

/** L'écart entre deux flèches d'une grille : celui de `TAILLE`, sauf sur un
 *  petit écran, où les flèches se toucheraient presque — on en met moins. */
const pasDesFlèches = (plan) => (plan.long(TAILLE.pas) < 36 ? 1.5 : 1) * TAILLE.pas;

/** Le nombre de flèches dessinées sur le contour autour de M. */
const FLÈCHES_DU_CONTOUR = 16;

/** La vitesse angulaire de la roue à aubes là où le rotationnel est le plus
 *  fort, en radians par seconde. */
const VITESSE_DE_LA_ROUE = 2.5;

const format = new Intl.NumberFormat('fr-FR', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
    useGrouping: false,
});

/** Un nombre, écrit à la française et lisible par KaTeX ; `zéro` en deçà
 *  duquel il est nul — ce que les différences finies laissent de bruit. */
function nombre(x, zéro = 0) {
    if (Math.abs(x) <= zéro) return '0';
    // Presque nul, mais pas tout à fait : 0,00, et sans signe.
    const écrit = format.format(x).replace(/^[-−](0,0+)$/, '$1');
    return écrit.replace('−', '-').replace(',', '{,}');
}

const colonne = ([x, y], zéro) => `\\begin{pmatrix} ${nombre(x, zéro)} \\\\ ${nombre(y, zéro)} \\end{pmatrix}`;

const norme = (v) => (typeof v === 'number' ? Math.abs(v) : Math.hypot(...v));

/** Les points d'une grille régulière du cadre, décalée de `décalage` par
 *  rapport à l'origine, sans rien trop près du bord. */
function réseau(vue, pas, décalage = 0, marge = 0.3) {
    const points = [];
    const premier = (a) => décalage + Math.ceil((a + marge - décalage) / pas) * pas;
    for (let y = premier(vue.y0); y <= vue.y1 - marge; y += pas) {
        for (let x = premier(vue.x0); x <= vue.x1 - marge; x += pas) points.push([x, y]);
    }
    return points;
}

/**
 * L'échelle du dessin d'un opérateur : sa plus grande valeur (en norme) sur
 * la vue, qui prend la taille entière, et `zéro`, en deçà duquel il est nul
 * — ce que tient `SEUIL` de l'échelle du champ (cf. champs.js).
 */
function échelle(opérateur, vue, zéro) {
    let max = 0;
    for (const [x, y] of réseau(vue, 0.15, 0, 0)) max = Math.max(max, norme(opérateur(x, y)));
    return { max, zéro };
}

// -- Ce qui se dessine ---------------------------------------------------------

/** Un scalaire : un disque marqué de son signe, d'aire proportionnelle à sa
 *  valeur. Il disparaît avec elle plutôt que de rester un point. Renvoie le
 *  rayon dessiné. */
function signe(c, centre, rayon, positif) {
    if (rayon < 1.5) return 0;
    disque(c, centre, rayon, { couleur: positif ? COULEUR.positif : COULEUR.négatif, bord: '#fff', épaisseur: 1 });
    if (rayon < 5) return rayon;
    const barre = rayon * 0.55;
    const épaisseur = Math.max(1.2, rayon * 0.2);
    const [px, py] = centre;
    chemin(
        c,
        [
            [px - barre, py],
            [px + barre, py],
        ],
        { couleur: '#fff', épaisseur },
    );
    if (positif) {
        chemin(
            c,
            [
                [px, py - barre],
                [px, py + barre],
            ],
            { couleur: '#fff', épaisseur },
        );
    }
    return rayon;
}

/** Un vecteur perpendiculaire à l'écran : ⊙ s'il en sort (vers nous), ⊗ s'il
 *  s'y enfonce. Le symbole garde une taille lisible, mais son aire suit la
 *  valeur au-delà. */
function axial(c, centre, rayon, sortant, couleur = COULEUR.opérateur) {
    if (rayon < 2) return 0;
    const r = Math.max(rayon, 6);
    const [px, py] = centre;
    disque(c, centre, r, { couleur: '#fff', bord: couleur, épaisseur: 2 });
    if (sortant) {
        disque(c, centre, Math.max(1.8, r * 0.26), { couleur });
        return r;
    }
    const d = r * 0.5;
    const épaisseur = Math.max(1.5, r * 0.12);
    chemin(
        c,
        [
            [px - d, py - d],
            [px + d, py + d],
        ],
        { couleur, épaisseur },
    );
    chemin(
        c,
        [
            [px - d, py + d],
            [px + d, py - d],
        ],
        { couleur, épaisseur },
    );
    return r;
}

/**
 * La valeur d'un opérateur en un point, dessinée selon sa nature :
 * `scalaire`, `axial` (porté par e_z) ou `vecteur` (dans le plan, une flèche
 * qui part du point), à son `échelle`.
 */
function représente(c, plan, nature, valeur, { max, zéro }, point, { flèche: long, rayon, épaisseur = 2.5 }) {
    if (!(max > zéro) || norme(valeur) <= zéro) return null;
    const centre = plan.vers(...point);
    if (nature === 'vecteur') {
        const longueur = plan.long(long) * (norme(valeur) / max);
        const u = [valeur[0] / norme(valeur), -valeur[1] / norme(valeur)];
        flèche(c, centre, u, longueur, { couleur: COULEUR.opérateur, épaisseur });
        return { u, longueur };
    }
    const r = plan.long(rayon) * Math.sqrt(norme(valeur) / max);
    return { rayon: (nature === 'scalaire' ? signe : axial)(c, centre, r, valeur > 0) };
}

/** Des flèches centrées sur les points d'une grille, de longueur
 *  proportionnelle à la norme du vecteur. */
function flèches(c, plan, points, vecteur, { max, zéro }, { longueur, couleur = COULEUR.champ, épaisseur = 1.4 } = {}) {
    if (!(max > zéro)) return;
    for (const p of points) {
        const v = vecteur(...p);
        const n = Math.hypot(...v);
        if (n <= zéro) continue;
        const l = plan.long(longueur) * (n / max);
        const u = [v[0] / n, -v[1] / n];
        const [px, py] = plan.vers(...p);
        flèche(c, [px - (u[0] * l) / 2, py - (u[1] * l) / 2], u, l, { couleur, épaisseur, tête: 6 });
    }
}

/**
 * Le contour autour de M : un cercle de rayon ρ, et sur son bord la
 * composante `normale` (un flux) ou `tangente` (une circulation) du champ
 * `vecteur`, rouge quand elle compte positivement, bleue sinon. Une
 * composante normale entrante arrive sur le cercle du dehors : on la voit
 * entrer.
 *
 * Les flèches se mesurent à la plus longue d'entre elles, et non au champ
 * sur toute la vue : ce qu'elles montrent, c'est l'équilibre d'un côté du
 * cercle à l'autre, qui doit se lire même là où le champ est faible. En deçà
 * de `zéro`, une composante est nulle.
 */
function contour(c, plan, M, ρ, vecteur, zéro, composante) {
    const [cx, cy] = plan.vers(...M);
    c.save();
    c.beginPath();
    c.arc(cx, cy, plan.long(ρ), 0, 2 * Math.PI);
    Object.assign(c, { strokeStyle: COULEUR.contour, lineWidth: 1.5 });
    c.setLineDash([5, 4]);
    c.stroke();
    c.restore();
    const flèches = cercle(...M, ρ, FLÈCHES_DU_CONTOUR).map(({ point, normale, tangente }) => {
        const direction = composante === 'normale' ? normale : tangente;
        const [ax, ay] = vecteur(...point);
        return { point, direction, a: ax * direction[0] + ay * direction[1] };
    });
    const plus = Math.max(...flèches.map(({ a }) => Math.abs(a)));
    if (!(plus > zéro)) return;
    for (const { point, direction, a } of flèches) {
        if (Math.abs(a) <= zéro) continue;
        const l = plan.long(TAILLE.contour) * (Math.abs(a) / plus);
        const u = [Math.sign(a) * direction[0], -Math.sign(a) * direction[1]];
        let départ = plan.vers(...point);
        if (composante === 'normale' && a < 0) départ = [départ[0] - u[0] * l, départ[1] - u[1] * l];
        if (composante === 'tangente') départ = [départ[0] - (u[0] * l) / 2, départ[1] - (u[1] * l) / 2];
        flèche(c, départ, u, l, { couleur: a > 0 ? COULEUR.positif : COULEUR.négatif, épaisseur: 2, tête: 6 });
    }
}

/** Une roue à aubes posée en M, tournée de `angle` (sens trigonométrique). */
function roue(c, plan, M, angle) {
    const centre = plan.vers(...M);
    const R = plan.long(TAILLE.roue);
    for (let k = 0; k < 4; k++) {
        const θ = angle + (k * Math.PI) / 2;
        const u = [Math.cos(θ), -Math.sin(θ)];
        const à = (r) => [centre[0] + u[0] * r, centre[1] + u[1] * r];
        chemin(c, [centre, à(R)], { couleur: COULEUR.roue, épaisseur: 1.5 });
        chemin(c, [à(0.55 * R), à(R)], { couleur: COULEUR.roue, épaisseur: 6 });
    }
}

/**
 * Pose une étiquette à `distance` pixels d'un point, dans la direction `u`
 * (en pixels, unitaire), sans que sa boîte déborde vers le point : on
 * l'écarte d'autant plus qu'elle est longue dans cette direction.
 */
function écarte(étiquette, point, u, distance) {
    const { offsetWidth: l, offsetHeight: h } = étiquette.élément;
    const d = distance + 4 + (Math.abs(u[0]) * l) / 2 + (Math.abs(u[1]) * h) / 2;
    étiquette.place(...point, [u[0] * d, u[1] * d]);
}

/**
 * Le point M, et son nom écarté de ce qui y est dessiné : à l'opposé de la
 * flèche s'il y en a une, en bas à gauche sinon, au-delà du disque, du
 * symbole ou de la roue (`autour`, en pixels). Un disque ou un symbole
 * centré sur M le montre déjà : un point par-dessus en cacherait le signe.
 */
function dessineM(c, plan, M, nom, dessin, autour = 0) {
    const rayon = dessin?.rayon ?? 0;
    if (rayon < 5) disque(c, plan.vers(...M), 4, { couleur: COULEURS.noir, bord: '#fff', épaisseur: 1.5 });
    const u = dessin?.u ? [-dessin.u[0], -dessin.u[1]] : [-Math.SQRT1_2, Math.SQRT1_2];
    écarte(nom, M, u, Math.max(rayon, autour, 5));
}

/** Le nom d'une flèche, posé au-delà de sa pointe. */
function nommeLaFlèche(nom, M, dessin) {
    nom.montre(Boolean(dessin?.u));
    if (dessin?.u) écarte(nom, M, dessin.u, dessin.longueur + 2);
}

// -- Les réglages communs ---------------------------------------------------------

/** Le point M, que l'on déplace sans le sortir du cadre. */
function poignéeM(plan, état) {
    plan.poignée({
        position: () => état.M,
        rayon: 18,
        auDéplacement: (x, y) => {
            const { x0, x1, y0, y1 } = plan.cadre();
            état.M = [Math.min(Math.max(x, x0 + 0.25), x1 - 0.25), Math.min(Math.max(y, y0 + 0.25), y1 - 0.25)];
        },
    });
}

/** Une note grise du panneau, que l'on réécrit. */
function note(réglages) {
    const p = réglages.texte();
    p.className = 'note';
    return p;
}

/** Une case du panneau qui redessine la vue. */
function caseQuiRedessine(réglages, plan, état, clé, { texte, tex, couleur }) {
    return réglages.case({
        texte,
        tex,
        couleur,
        valeur: état.montre[clé],
        auChangement: (v) => {
            état.montre[clé] = v;
            plan.redessine();
        },
    });
}

// -- Sur un champ scalaire ---------------------------------------------------------

const OPÉRATEURS_SCALAIRES = {
    gradient: {
        tex: '\\overrightarrow{\\mathrm{grad}}\\,f',
        nature: 'vecteur',
        calcule: gradient,
        note:
            'Le gradient pointe vers les valeurs croissantes de f, perpendiculairement à l’équipotentielle ' +
            'qui passe par M (en noir). Il est d’autant plus long que les équipotentielles sont serrées.',
    },
    laplacien: {
        tex: '\\Delta f',
        nature: 'scalaire',
        calcule: laplacien,
        note:
            'Le laplacien compare f(M) à la moyenne de f sur un petit cercle autour de M : il est positif (+) ' +
            'si f(M) est plus basse que ses voisines, négatif (−) si elle est plus haute. C’est la divergence ' +
            'du gradient.',
    },
};

/** Le dégradé d'un champ scalaire, peint sur sa grille une fois pour
 *  toutes : il ne change qu'avec le champ, pas quand M se déplace. */
function peint(g, toile, bas, haut) {
    const { colonnes, lignes, valeurs } = g;
    Object.assign(toile, { width: colonnes, height: lignes });
    const pinceau = toile.getContext('2d');
    const image = pinceau.createImageData(colonnes, lignes);
    for (let j = 0; j < lignes; j++) {
        for (let i = 0; i < colonnes; i++) {
            const [r, v, b] = teinte((valeurs[j * colonnes + i] - bas) / (haut - bas || 1));
            // L'image se remplit de haut en bas, la grille de bas en haut.
            const k = 4 * ((lignes - 1 - j) * colonnes + i);
            image.data.set([r, v, b, 255], k);
        }
    }
    pinceau.putImageData(image, 0, 0);
}

/** L'échelle de couleurs, sous la formule du champ : une barre et ses deux
 *  bornes. */
function échelleDeCouleurs(réglages) {
    const bloc = document.createElement('div');
    const barre = document.createElement('div');
    const pas = TEINTES.map(([t, [r, v, b]]) => `rgb(${r}, ${v}, ${b}) ${100 * t}%`).join(', ');
    Object.assign(barre.style, {
        height: '0.6rem',
        margin: '0.35rem 0 0.15rem',
        background: `linear-gradient(to right, ${pas})`,
        border: '1px solid var(--filet-clair)',
    });
    const bornes = document.createElement('div');
    Object.assign(bornes.style, {
        display: 'flex',
        justifyContent: 'space-between',
        fontSize: '0.8rem',
        color: 'var(--gris)',
        fontVariantNumeric: 'tabular-nums',
    });
    const [bas, haut] = [document.createElement('span'), document.createElement('span')];
    bornes.append(bas, haut);
    bloc.append(barre, bornes);
    réglages.ajoute(bloc);
    const lisible = new Intl.NumberFormat('fr-FR', { maximumFractionDigits: 2 });
    return (min, max) => {
        bas.textContent = `f = ${lisible.format(min)}`;
        haut.textContent = lisible.format(max);
    };
}

function surUnChampScalaire(section) {
    const { vue, réglages: panneau } = cadre(section);
    const plan = new Plan(vue, { rapport: 16 / 10, étendue: 12, aide: 'Glisser le point M.' });
    const état = {
        champ: 'colline',
        opérateur: 'gradient',
        M: [1.3, 0.7],
        ρ: 1,
        montre: { niveaux: true, partout: false, contour: true },
    };
    const toile = document.createElement('canvas');
    const nomM = plan.étiquette('M');
    const nomFlèche = plan.étiquette(OPÉRATEURS_SCALAIRES.gradient.tex, { couleur: COULEUR.opérateur });

    // Tout ce qui ne dépend que du champ : sa grille, son dégradé, ses
    // équipotentielles, et l'échelle de chaque opérateur. Le champ a pour
    // échelle l'écart entre ses valeurs extrêmes.
    let carte = null;
    function prépare() {
        const { f } = SCALAIRES[état.champ];
        const vueDuPlan = plan.cadre();
        const g = grille(f, vueDuPlan, 140);
        const [bas, haut] = étendue(g);
        peint(g, toile, bas, haut);
        const zéro = SEUIL * (haut - bas);
        const échelles = Object.fromEntries(
            Object.entries(OPÉRATEURS_SCALAIRES).map(([clé, o]) => [
                clé,
                échelle((x, y) => o.calcule(f, x, y), vueDuPlan, zéro),
            ]),
        );
        carte = { f, grille: g, lignes: contours(g, niveaux(g, ronde((haut - bas) / 12))), échelles };
        écritLÉchelle(bas, haut);
    }

    plan.dessine((c) => {
        const vueDuPlan = plan.cadre();
        const opérateur = OPÉRATEURS_SCALAIRES[état.opérateur];
        const { f, échelles } = carte;
        const { zéro } = échelles[état.opérateur];
        const calcule = (x, y) => opérateur.calcule(f, x, y);

        c.save();
        c.imageSmoothingEnabled = true;
        c.drawImage(
            toile,
            ...plan.vers(vueDuPlan.x0, vueDuPlan.y1),
            plan.long(vueDuPlan.x1 - vueDuPlan.x0),
            plan.long(vueDuPlan.y1 - vueDuPlan.y0),
        );
        c.restore();

        if (état.montre.niveaux) {
            const trait = (segments, couleur, épaisseur) => {
                const tracé = new Path2D();
                for (const [a, b] of segments) {
                    tracé.moveTo(...plan.vers(...a));
                    tracé.lineTo(...plan.vers(...b));
                }
                c.save();
                Object.assign(c, { strokeStyle: couleur, lineWidth: épaisseur });
                c.stroke(tracé);
                c.restore();
            };
            trait(carte.lignes, COULEUR.niveau, 1);
            // L'équipotentielle de M : c'est à elle que le gradient est
            // perpendiculaire.
            trait(contours(carte.grille, [f(...état.M)]), COULEURS.noir, 2);
        }

        if (état.montre.partout) {
            const pas = pasDesFlèches(plan);
            if (opérateur.nature === 'vecteur') {
                flèches(c, plan, réseau(vueDuPlan, pas, pas / 2), calcule, échelles[état.opérateur], {
                    longueur: 0.85 * pas,
                    couleur: COULEUR.opérateur,
                });
            } else {
                for (const p of réseau(vueDuPlan, pas, pas / 2)) {
                    représente(c, plan, opérateur.nature, calcule(...p), échelles[état.opérateur], p, {
                        rayon: 0.3 * pas,
                    });
                }
            }
        }

        const laplacienEnM = état.opérateur === 'laplacien';
        if (laplacienEnM && état.montre.contour) {
            contour(c, plan, état.M, état.ρ, (x, y) => gradient(f, x, y), zéro, 'normale');
        }

        const valeur = calcule(...état.M);
        const dessin = représente(c, plan, opérateur.nature, valeur, échelles[état.opérateur], état.M, {
            flèche: TAILLE.flèche,
            rayon: TAILLE.rayon,
            épaisseur: 3,
        });
        dessineM(c, plan, état.M, nomM, dessin);
        nommeLaFlèche(nomFlèche, état.M, dessin);

        // Le panneau : la valeur en M, et ce qu'en donne le contour.
        const lignes = [`f(M) &= ${nombre(f(...état.M))}`];
        const enM = opérateur.nature === 'vecteur' ? colonne(valeur, zéro) : nombre(valeur, zéro);
        lignes.push(`${opérateur.tex}(M) &= ${enM}`);
        if (laplacienEnM && état.montre.contour) {
            const flux = fluxParVolume((x, y) => gradient(f, x, y), ...état.M, état.ρ);
            lignes.push(`\\frac{\\Phi}{V} &= ${nombre(flux, zéro)}`);
        }
        mesures.écrit(`\\begin{aligned} ${lignes.join(' \\\\ ')} \\end{aligned}`);
    });

    // -- Réglages -------------------------------------------------------------

    const réglages = new Réglages(panneau);
    réglages.groupe('Opérateur');
    réglages.choix({
        options: Object.entries(OPÉRATEURS_SCALAIRES).map(([clé, o]) => [clé, o.tex]),
        valeur: état.opérateur,
        auChangement: (v) => {
            état.opérateur = v;
            montreCeQuiSert();
            plan.redessine();
        },
    });

    réglages.groupe('Champ');
    réglages.choix({
        options: Object.entries(SCALAIRES).map(([clé, champ]) => [clé, champ.nom]),
        valeur: état.champ,
        auChangement: (v) => {
            état.champ = v;
            écritLeChamp();
            prépare();
            plan.redessine();
        },
    });
    const formule = réglages.formule();
    const écritLÉchelle = échelleDeCouleurs(réglages);
    const noteDuChamp = note(réglages);
    function écritLeChamp() {
        formule.écrit(SCALAIRES[état.champ].tex);
        noteDuChamp.textContent = SCALAIRES[état.champ].note;
    }

    réglages.groupe('Afficher');
    caseQuiRedessine(réglages, plan, état, 'niveaux', { texte: 'Équipotentielles', couleur: COULEURS.noir });
    caseQuiRedessine(réglages, plan, état, 'partout', {
        texte: 'L’opérateur dans tout le plan',
        couleur: COULEUR.opérateur,
    });
    const caseContour = caseQuiRedessine(réglages, plan, état, 'contour', {
        texte: 'Contour autour de M',
        couleur: COULEUR.contour,
    });
    const curseurρ = réglages.curseur({
        tex: '\\rho',
        min: 0.2,
        max: 2.5,
        pas: 0.02,
        valeur: état.ρ,
        aimants: [1],
        auChangement: (v) => {
            état.ρ = v;
            plan.redessine();
        },
    });

    réglages.groupe('En M');
    const mesures = réglages.formule();
    const noteDeLOpérateur = note(réglages);
    const noteDuContour = note(réglages);
    noteDuContour.textContent =
        'Sur le cercle de rayon ρ, la composante normale de grad f, rouge quand elle sort, bleue quand elle ' +
        'entre. Φ est son flux sortant d’un cylindre d’axe (Mz) de même rayon, V le volume du cylindre : ' +
        'Φ/V tend vers Δf(M) = div(grad f) quand ρ tend vers zéro.';

    function montreCeQuiSert() {
        const laplacien = état.opérateur === 'laplacien';
        caseContour.montre(laplacien);
        curseurρ.montre(laplacien);
        noteDuContour.hidden = !laplacien;
        noteDeLOpérateur.textContent = OPÉRATEURS_SCALAIRES[état.opérateur].note;
    }

    poignéeM(plan, état);
    écritLeChamp();
    montreCeQuiSert();
    prépare();
    plan.redessine();
}

// -- Sur un champ vectoriel -------------------------------------------------------

/**
 * Les deux termes de Δ⃗A = grad(div A) − rot(rot A) en M, et le
 * parallélogramme qui les somme ; renvoie leurs lignes du panneau. Ils
 * passent par-dessus Δ⃗A, plus fins : l'un des deux est souvent Δ⃗A lui-même,
 * qu'il cacherait sinon. Ils se dessinent à l'`échelle` de Δ⃗A.
 */
function dessineLesDeuxTermes(c, plan, A, M, { max, zéro }) {
    const termes = [
        [gradientDeLaDivergence(A, ...M), COULEUR.gradDiv, '\\overrightarrow{\\mathrm{grad}}(\\mathrm{div}\\,\\vec A)'],
        [
            moinsRotationnelDuRotationnel(A, ...M),
            COULEUR.rotRot,
            '-\\overrightarrow{\\mathrm{rot}}(\\overrightarrow{\\mathrm{rot}}\\,\\vec A)',
        ],
    ];
    if (max > zéro) {
        const bout = (v) => [M[0] + (TAILLE.flèche * v[0]) / max, M[1] + (TAILLE.flèche * v[1]) / max];
        if (termes.every(([v]) => norme(v) > zéro)) {
            const [a, b] = termes.map(([v]) => bout(v));
            const somme = [a[0] + b[0] - M[0], a[1] + b[1] - M[1]];
            for (const p of [a, b]) {
                chemin(c, [plan.vers(...p), plan.vers(...somme)], { couleur: COULEURS.gris, pointillés: [4, 4] });
            }
        }
        for (const [v, couleur] of termes) {
            if (norme(v) <= zéro) continue;
            flèche(c, plan.vers(...M), [v[0], -v[1]], plan.long(TAILLE.flèche) * (norme(v) / max), {
                couleur,
                épaisseur: 1.8,
                tête: 6,
            });
        }
    }
    return termes.map(([v, couleur, tex]) => `\\textcolor{${couleur}}{${tex}} &= ${colonne(v, zéro)}`);
}

const OPÉRATEURS_VECTORIELS = {
    divergence: {
        tex: '\\mathrm{div}\\,\\vec A',
        nature: 'scalaire',
        calcule: divergence,
        note:
            'La divergence dit ce qui sort du voisinage de M : positive (+), M est une source, le champ en ' +
            'sort plus qu’il n’y entre ; négative (−), M est un puits.',
        contour: {
            composante: 'normale',
            tex: '\\frac{\\Phi}{V}',
            mesure: fluxParVolume,
            note:
                'Sur le cercle de rayon ρ, la composante normale de A, rouge quand elle sort, bleue quand elle ' +
                'entre. Φ est le flux sortant d’un cylindre d’axe (Mz) de même rayon, V son volume : Φ/V tend ' +
                'vers div A(M) quand ρ tend vers zéro, c’est le théorème d’Ostrogradski.',
        },
    },
    rotationnel: {
        tex: '\\overrightarrow{\\mathrm{rot}}\\,\\vec A',
        nature: 'axial',
        calcule: rotationnel,
        note:
            'Le rotationnel d’un champ plan est perpendiculaire à l’écran : ⊙ s’il en sort, ⊗ s’il s’y ' +
            'enfonce. Une roue à aubes plongée en M dans un écoulement de vitesse A tourne sur elle-même à la ' +
            'vitesse angulaire ½ rot A : dans le sens trigonométrique pour ⊙.',
        contour: {
            composante: 'tangente',
            tex: '\\frac{\\mathcal{C}}{S}',
            mesure: circulationParSurface,
            note:
                'Sur le cercle de rayon ρ, la composante tangentielle de A, rouge dans le sens ' +
                'trigonométrique, bleue dans l’autre. La circulation C sur le cercle, divisée par l’aire S du ' +
                'disque, tend vers la composante de rot A sur e_z quand ρ tend vers zéro : c’est le théorème ' +
                'de Stokes.',
        },
    },
    laplacienVectoriel: {
        tex: '\\vec\\Delta\\,\\vec A',
        nature: 'vecteur',
        calcule: laplacienVectoriel,
        note:
            'Le laplacien vectoriel compare A(M) à la moyenne de A autour de M, composante par composante : ' +
            'ses composantes sont les laplaciens de celles de A. C’est aussi la somme de grad(div A) et de ' +
            '−rot(rot A), ses deux termes.',
    },
};

function surUnChampVectoriel(section) {
    const { vue, réglages: panneau } = cadre(section);
    const plan = new Plan(vue, { rapport: 16 / 10, étendue: 12, aide: 'Glisser le point M.' });
    const état = {
        champ: 'source',
        opérateur: 'divergence',
        M: [1.2, 0.8],
        ρ: 1,
        angle: 0,
        montre: { champ: true, partout: false, contour: true, roue: true, décomposition: false },
    };
    const nomM = plan.étiquette('M');
    const nomFlèche = plan.étiquette(OPÉRATEURS_VECTORIELS.laplacienVectoriel.tex, { couleur: COULEUR.opérateur });

    // Les échelles des dessins, du champ et de chaque opérateur : elles ne
    // changent qu'avec le champ, qui a pour échelle son plus grand vecteur.
    let échelles = null;
    function prépare() {
        const { A } = VECTORIELS[état.champ];
        const vueDuPlan = plan.cadre();
        const champ = échelle(A, vueDuPlan, 0);
        champ.zéro = SEUIL * champ.max;
        échelles = { champ };
        for (const [clé, o] of Object.entries(OPÉRATEURS_VECTORIELS)) {
            échelles[clé] = échelle((x, y) => o.calcule(A, x, y), vueDuPlan, champ.zéro);
        }
    }

    // La roue à aubes tourne à une vitesse proportionnelle au rotationnel en
    // M ; la vue ne se redessine que si elle tourne.
    plan.àChaqueImage((dt) => {
        if (état.opérateur !== 'rotationnel' || !état.montre.roue || !échelles) return;
        const { max, zéro } = échelles.rotationnel;
        const ω = rotationnel(VECTORIELS[état.champ].A, ...état.M);
        if (Math.abs(ω) <= zéro) return;
        état.angle += VITESSE_DE_LA_ROUE * (ω / max) * dt;
        plan.redessine();
    });

    plan.dessine((c) => {
        const vueDuPlan = plan.cadre();
        const opérateur = OPÉRATEURS_VECTORIELS[état.opérateur];
        const { A } = VECTORIELS[état.champ];
        const { zéro } = échelles.champ;
        const calcule = (x, y) => opérateur.calcule(A, x, y);

        const pasDuChamp = pasDesFlèches(plan);
        if (état.montre.champ) {
            flèches(c, plan, réseau(vueDuPlan, pasDuChamp), A, échelles.champ, { longueur: 0.85 * pasDuChamp });
        }
        // L'opérateur partout : entre les flèches du champ, une case sur deux.
        if (état.montre.partout) {
            const pas = 2 * pasDuChamp;
            const points = réseau(vueDuPlan, pas, pasDuChamp / 2);
            if (opérateur.nature === 'vecteur') {
                flèches(c, plan, points, calcule, échelles[état.opérateur], {
                    longueur: 0.8 * pas,
                    couleur: COULEUR.opérateur,
                    épaisseur: 2,
                });
            } else {
                for (const p of points) {
                    représente(c, plan, opérateur.nature, calcule(...p), échelles[état.opérateur], p, {
                        rayon: 0.22 * pas,
                    });
                }
            }
        }
        if (opérateur.contour && état.montre.contour) {
            contour(c, plan, état.M, état.ρ, A, zéro, opérateur.contour.composante);
        }

        const valeur = calcule(...état.M);
        const lignes = [`\\vec A(M) &= ${colonne(A(...état.M), zéro)}`];
        const avecRoue = état.opérateur === 'rotationnel' && état.montre.roue;
        if (avecRoue) roue(c, plan, état.M, état.angle);
        const dessin = représente(c, plan, opérateur.nature, valeur, échelles[état.opérateur], état.M, {
            flèche: TAILLE.flèche,
            rayon: TAILLE.rayon,
            épaisseur: 3.5,
        });
        if (état.opérateur === 'laplacienVectoriel' && état.montre.décomposition) {
            lignes.push(...dessineLesDeuxTermes(c, plan, A, état.M, échelles.laplacienVectoriel));
        }
        dessineM(c, plan, état.M, nomM, dessin, avecRoue ? plan.long(TAILLE.roue) : 0);
        nommeLaFlèche(nomFlèche, état.M, dessin);

        const enM =
            opérateur.nature === 'vecteur'
                ? colonne(valeur, zéro)
                : nombre(valeur, zéro) + (opérateur.nature === 'axial' ? '\\,\\vec e_z' : '');
        lignes.push(`${opérateur.tex}(M) &= ${enM}`);
        if (opérateur.contour && état.montre.contour) {
            const { tex, mesure } = opérateur.contour;
            lignes.push(`${tex} &= ${nombre(mesure(A, ...état.M, état.ρ), zéro)}`);
        }
        mesures.écrit(`\\begin{aligned} ${lignes.join(' \\\\ ')} \\end{aligned}`);
    });

    // -- Réglages -------------------------------------------------------------

    const réglages = new Réglages(panneau);
    réglages.groupe('Opérateur');
    réglages.choix({
        options: Object.entries(OPÉRATEURS_VECTORIELS).map(([clé, o]) => [clé, o.tex]),
        valeur: état.opérateur,
        auChangement: (v) => {
            état.opérateur = v;
            montreCeQuiSert();
            plan.redessine();
        },
    });

    réglages.groupe('Champ');
    réglages.choix({
        options: Object.entries(VECTORIELS).map(([clé, champ]) => [clé, champ.nom]),
        valeur: état.champ,
        auChangement: (v) => {
            état.champ = v;
            écritLeChamp();
            prépare();
            plan.redessine();
        },
    });
    const formule = réglages.formule();
    const noteDuChamp = note(réglages);
    function écritLeChamp() {
        formule.écrit(VECTORIELS[état.champ].tex);
        noteDuChamp.textContent = VECTORIELS[état.champ].note;
    }

    réglages.groupe('Afficher');
    caseQuiRedessine(réglages, plan, état, 'champ', { texte: 'Le champ', tex: '\\vec A', couleur: COULEUR.champ });
    caseQuiRedessine(réglages, plan, état, 'partout', {
        texte: 'L’opérateur dans tout le plan',
        couleur: COULEUR.opérateur,
    });
    const caseContour = caseQuiRedessine(réglages, plan, état, 'contour', {
        texte: 'Contour autour de M',
        couleur: COULEUR.contour,
    });
    const curseurρ = réglages.curseur({
        tex: '\\rho',
        min: 0.2,
        max: 2.5,
        pas: 0.02,
        valeur: état.ρ,
        aimants: [1],
        auChangement: (v) => {
            état.ρ = v;
            plan.redessine();
        },
    });
    const caseRoue = caseQuiRedessine(réglages, plan, état, 'roue', { texte: 'Roue à aubes', couleur: COULEUR.roue });
    const caseDécomposition = caseQuiRedessine(réglages, plan, état, 'décomposition', { texte: 'Ses deux termes' });

    réglages.groupe('En M');
    const mesures = réglages.formule();
    const noteDeLOpérateur = note(réglages);
    const noteDuContour = note(réglages);

    function montreCeQuiSert() {
        const opérateur = OPÉRATEURS_VECTORIELS[état.opérateur];
        caseContour.montre(Boolean(opérateur.contour));
        curseurρ.montre(Boolean(opérateur.contour));
        caseRoue.montre(état.opérateur === 'rotationnel');
        caseDécomposition.montre(état.opérateur === 'laplacienVectoriel');
        noteDeLOpérateur.textContent = opérateur.note;
        noteDuContour.hidden = !opérateur.contour;
        noteDuContour.textContent = opérateur.contour?.note ?? '';
    }

    poignéeM(plan, état);
    écritLeChamp();
    montreCeQuiSert();
    prépare();
    plan.redessine();
}

const ANIMATIONS = { scalaire: surUnChampScalaire, vectoriel: surUnChampVectoriel };

lance('section.animation', (section) => ANIMATIONS[section.dataset.animation](section));
