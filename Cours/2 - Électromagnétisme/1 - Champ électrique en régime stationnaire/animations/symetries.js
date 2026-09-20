// Invariances et symétries d'une distribution : les deux gestes du chapitre,
// que la figure du tableau réduit à un trait.
//
// Deux scènes, les mêmes distributions et les mêmes systèmes de coordonnées :
//
//   - « Invariances » applique à la distribution la transformation qu'un
//     curseur commande — la translation ou la rotation qui fait varier une
//     coordonnée. Si la distribution est invariante, l'image ne bouge pas
//     d'un pixel : c'est cela qu'il faut voir, et non l'entendre dire. Sa
//     position de départ reste dessinée en fil de fer, pour en juger.
//   - « Plans de symétrie » place un point M que l'on déplace à la main, y
//     dresse la base locale, et trace le symétrique de la distribution par
//     l'un des trois plans de coordonnées passant par M.
//
// Ce à quoi tient cette écriture :
//
//   - une distribution infinie (le fil, le plan) est dessinée bien au-delà
//     de la vue : si l'on voyait ses bords, la faire glisser le long
//     d'elle-même la ferait bouger à l'écran, et l'invariance ne se verrait
//     plus. Une image, elle, est en fil de fer, et garde sa couleur : c'est
//     elle qui dit le signe de la charge ;
//   - les vues toutes faites dispensent de tourner la scène, et rendent
//     prévisible le déplacement de M, qui se fait dans le plan de l'écran ;
//   - les symétries ne sont pas décidées à l'œil mais calculées, sur les
//     formes qui décrivent la distribution (un point, une droite, un plan,
//     une sphère, un cercle) : c'est le même calcul qui décide de
//     l'invariance et de la nature d'un plan ;
//   - ce qu'on en déduit s'écrit dans le panneau, à mesure : les variables
//     dont le champ dépend encore, puis ses composantes.

import * as THREE from 'three';
import { COULEURS, Arc, Étiquette, Flèche, Trait, point, repère, vecteur, ORIGINE, X, Y, Z } from '#animations/objets.js';
import { cadre, lance } from '#animations/page.js';
import { Réglages } from '#animations/reglages.js';
import { Scène } from '#animations/scene.js';

const COULEUR = {
    positive: COULEURS.vermillon,
    négative: COULEURS.bleu,
    plan: COULEURS.violet,
    base: COULEURS.noir,
    repère: COULEURS.grisClair,
    geste: COULEURS.gris,
};

const deg = THREE.MathUtils.degToRad;
const format = new Intl.NumberFormat('fr-FR', { minimumFractionDigits: 1, maximumFractionDigits: 1 });
/** Un nombre écrit à la française, et lisible par KaTeX. */
const nombre = (x) => format.format(x).replace('−', '-').replace(',', '{,}');

/** Une énumération à la française : « a, b et c ». */
const énumère = (mots) => (mots.length < 2 ? (mots[0] ?? '') : `${mots.slice(0, -1).join(', ')} et ${mots.at(-1)}`);

/** La vue de départ, commune aux deux scènes. */
const DÉPART = { position: [10, -12, 8], cible: [0, 0, 0] };

// -- Les formes dont une distribution est faite -------------------------------
//
// Une distribution se décrit deux fois : par ses formes, sur lesquelles se
// calculent invariances et symétries, et par ce qui la dessine. Les formes
// portent le signe de la charge : c'est lui qui sépare un plan de symétrie
// d'un plan d'antisymétrie.

const unPoint = (p, q = 1) => ({ forme: 'point', p, q });
const uneDroite = (p, n, q = 1) => ({ forme: 'droite', p, n, q });
const unPlan = (p, n, q = 1) => ({ forme: 'plan', p, n, q });
const uneSphère = (p, r, q = 1) => ({ forme: 'sphère', p, r, q });
const unCercle = (p, n, r, q = 1) => ({ forme: 'cercle', p, n, r, q });

/** De combien deux formes peuvent différer et rester la même : de rien, ou
 *  presque. Les positions remarquables sont atteintes exactement (cf.
 *  `borne`), et ce qui s'en écarte d'un millième n'est pas la même chose. */
const ÉPSILON = 1e-3;
const colinéaires = (u, v) => u.clone().cross(v).length() < ÉPSILON;

/** L'image d'une forme par une isométrie : son point de référence suit, sa
 *  direction aussi — le rayon, lui, ne change pas. */
const transforme = (forme, m) => ({
    ...forme,
    p: forme.p.clone().applyMatrix4(m),
    n: forme.n ? forme.n.clone().transformDirection(m) : undefined,
});

/** Deux formes sont-elles la même partie de l'espace ? Une droite et un plan
 *  ne retiennent de leur direction que sa droite vectorielle : le sens n'en
 *  fait pas une autre. */
function mêmeForme(a, b) {
    if (a.forme !== b.forme) return false;
    switch (a.forme) {
        case 'point':
            return a.p.distanceTo(b.p) < ÉPSILON;
        case 'droite':
            return colinéaires(a.n, b.n) && b.p.clone().sub(a.p).cross(a.n).length() < ÉPSILON;
        case 'plan':
            return colinéaires(a.n, b.n) && Math.abs(b.p.clone().sub(a.p).dot(a.n)) < ÉPSILON;
        case 'sphère':
            return a.p.distanceTo(b.p) < ÉPSILON && Math.abs(a.r - b.r) < ÉPSILON;
        case 'cercle':
            return a.p.distanceTo(b.p) < ÉPSILON && colinéaires(a.n, b.n) && Math.abs(a.r - b.r) < ÉPSILON;
        default:
            return false;
    }
}

/**
 * Ce que la transformation `m` fait de la distribution : la laisse-t-elle
 * identique à elle-même (invariance, ou plan de symétrie), la change-t-elle
 * en son opposée (antisymétrie), ou ni l'un ni l'autre ?
 *
 * L'image de chaque forme doit retrouver une forme de départ, et une seule :
 * deux charges ne peuvent pas avoir la même image.
 */
function nature(formes, m) {
    const images = formes.map((forme) => transforme(forme, m));
    const correspond = (signe) => {
        const restantes = [...formes];
        for (const image of images) {
            const k = restantes.findIndex(
                (forme) => mêmeForme(forme, image) && Math.abs(forme.q - signe * image.q) < ÉPSILON,
            );
            if (k < 0) return false;
            restantes.splice(k, 1);
        }
        return true;
    };
    return correspond(1) ? 'symétrie' : correspond(-1) ? 'antisymétrie' : 'aucune';
}

/** La matrice de la symétrie par le plan passant par `p`, de normale `n` :
 *  la part parallèle au plan reste, la part normale change de signe. */
function réflexion(p, n) {
    const u = n.clone().normalize();
    const miroir = new THREE.Matrix4().set(
        1 - 2 * u.x * u.x, -2 * u.x * u.y, -2 * u.x * u.z, 0,
        -2 * u.y * u.x, 1 - 2 * u.y * u.y, -2 * u.y * u.z, 0,
        -2 * u.z * u.x, -2 * u.z * u.y, 1 - 2 * u.z * u.z, 0,
        0, 0, 0, 1,
    );
    return new THREE.Matrix4()
        .makeTranslation(p.x, p.y, p.z)
        .multiply(miroir)
        .multiply(new THREE.Matrix4().makeTranslation(-p.x, -p.y, -p.z));
}

// -- Ce qui les dessine --------------------------------------------------------

/** La longueur sur laquelle on dessine le fil : assez grande pour que ses
 *  bouts restent hors de la vue, quoi qu'on en fasse. */
const LONGUEUR_FIL = 34;
/** Le plan, lui, ne saurait sortir de la vue de tous les côtés : il est
 *  dessiné autour de son point le plus proche de l'origine, et s'efface vers
 *  le bord (cf. `poseLaNappe`). */
const RAYON_NAPPE = 5.2;
const PLEIN = 0.6;
const RAYON_BOULE = 1.4;
const RAYON_SPIRE = 1.9;
const DEMI_ÉCART = 1.5;

/**
 * La couleur d'une charge, et celle de son image : la même, en plus sombre.
 * Une image posée sur son original doit se voir — c'est tout l'objet de la
 * manœuvre —, et elle ne le ferait pas si elle en avait exactement la
 * couleur ; mais elle ne peut pas non plus en changer, puisque c'est la
 * couleur qui dit le signe de la charge.
 */
const assombrit = (couleur) =>
    '#' +
    [1, 3, 5]
        .map((i) =>
            Math.round(0.5 * parseInt(couleur.slice(i, i + 2), 16))
                .toString(16)
                .padStart(2, '0'),
        )
        .join('');

const couleurDe = (q, fantôme = false) => {
    const couleur = q >= 0 ? COULEUR.positive : COULEUR.négative;
    return fantôme ? assombrit(couleur) : couleur;
};

/** La matière d'une distribution : pleine et éclairée pour l'originale, en
 *  fil de fer pour une image ou une position de départ. La couleur reste la
 *  même : c'est elle qui dit le signe de la charge, et c'est en la comparant
 *  qu'on distingue une symétrie d'une antisymétrie. */
const matière = (couleur, fantôme) =>
    fantôme
        ? new THREE.MeshBasicMaterial({
              color: couleur,
              wireframe: true,
              transparent: true,
              opacity: 0.8,
              toneMapped: false,
          })
        : new THREE.MeshLambertMaterial({ color: couleur });

const groupe = (...objets) => new THREE.Group().add(...objets);
const UN = vecteur(1, 1, 1);

/** Une charge ponctuelle, et son signe écrit à côté — au-dessus pour
 *  l'originale, au-dessous pour son image, de sorte que les deux se lisent
 *  encore quand elles se superposent. */
function bille(p, q, fantôme) {
    // La carcasse est plus large que la bille, et à peine maillée : serrée,
    // elle ferait une boule pleine de sa couleur, et cacherait celle qu'elle
    // recouvre — justement ce qu'il faut voir.
    const maille = new THREE.Mesh(
        fantôme ? new THREE.SphereGeometry(0.34, 7, 4) : new THREE.SphereGeometry(0.21, 28, 18),
        matière(couleurDe(q, fantôme), fantôme),
    );
    maille.position.copy(p);
    const signe = new Étiquette(q >= 0 ? '{+}' : '{-}', {
        couleur: couleurDe(q, fantôme),
        décalage: fantôme ? '0 1.1em' : '0 -1.1em',
    }).place(p);
    return groupe(maille, signe);
}

/** L'ossature d'une image, en un ou plusieurs traits pointillés que rien ne
 *  cache : posée sur la distribution, c'est justement ce qu'il faut voir. */
function ossature(...chemins) {
    return groupe(
        ...chemins.map((points) => {
            const trait = new Trait({ couleur: couleurDe(1, true), épaisseur: 2.5, pointillés: true, tiret: 0.22 });
            trait.material.depthTest = false;
            trait.renderOrder = 6;
            return trait.trace(points);
        }),
    );
}

/** Un fil rectiligne infini, porté par (Oz). */
const tige = () =>
    groupe(
        new THREE.Mesh(
            new THREE.CylinderGeometry(0.075, 0.075, LONGUEUR_FIL, 16).rotateX(Math.PI / 2),
            matière(COULEUR.positive, false),
        ),
    );

/** Une teinte qui s'efface vers le bord : un morceau de plan sans bord
 *  franc, qu'on ne prendra pas pour un disque chargé. */
function dégradé() {
    const toile = Object.assign(document.createElement('canvas'), { width: 128, height: 128 });
    const crayon = toile.getContext('2d');
    const fondu = crayon.createRadialGradient(64, 64, 0, 64, 64, 64);
    fondu.addColorStop(0, 'rgba(255,255,255,1)');
    fondu.addColorStop(PLEIN, 'rgba(255,255,255,1)');
    fondu.addColorStop(1, 'rgba(255,255,255,0)');
    crayon.fillStyle = fondu;
    crayon.fillRect(0, 0, 128, 128);
    const texture = new THREE.CanvasTexture(toile);
    texture.colorSpace = THREE.SRGBColorSpace;
    return texture;
}

/** Un plan infini : une nappe teintée, que l'on voit au travers. */
const nappe = () =>
    groupe(
        new THREE.Mesh(
            new THREE.PlaneGeometry(2 * RAYON_NAPPE, 2 * RAYON_NAPPE),
            new THREE.MeshBasicMaterial({
                color: COULEUR.positive,
                map: dégradé(),
                transparent: true,
                opacity: 0.4,
                side: THREE.DoubleSide,
                depthWrite: false,
                toneMapped: false,
            }),
        ),
    );

/**
 * Le plan se dessine autour du pied de la perpendiculaire menée de O, et sa
 * nappe est ronde : ce point et cette normale ne dépendent que du plan, et
 * non du chemin qui l'y a amené. Le faire glisser le long de lui-même, ou le
 * tourner autour de sa normale, ne déplace donc pas un pixel — c'est
 * exactement ce qu'une invariance doit donner à voir.
 */
function poseLaNappe(objet, m) {
    const normale = Z.clone().transformDirection(m);
    const dessus = ORIGINE.clone().applyMatrix4(m).dot(normale);
    objet.matrix.compose(
        normale.clone().multiplyScalar(dessus),
        new THREE.Quaternion().setFromUnitVectors(Z, normale),
        UN,
    );
}

/** Les points d'un cercle du plan (O x y), pour l'ossature d'une spire. */
const cercleDePoints = (rayon, pas = 72) =>
    Array.from({ length: pas + 1 }, (_, i) => {
        const t = (2 * Math.PI * i) / pas;
        return vecteur(rayon * Math.cos(t), rayon * Math.sin(t), 0);
    });

const DOUBLET = [unPoint(vecteur(0, 0, DEMI_ÉCART), 1), unPoint(vecteur(0, 0, -DEMI_ÉCART), -1)];

/**
 * Les distributions proposées, des plus simples aux moins symétriques. Les
 * cinq premières sont uniformément chargées, positives ; les deux charges
 * opposées sont là pour l'antisymétrie, que rien d'autre ne montre.
 */
const DISTRIBUTIONS = {
    charge: {
        nom: '\\text{Charge}',
        formes: [unPoint(ORIGINE)],
        dessine: (fantôme) => bille(ORIGINE, 1, fantôme),
    },
    boule: {
        nom: '\\text{Boule}',
        formes: [uneSphère(ORIGINE, RAYON_BOULE)],
        dessine: (fantôme) =>
            groupe(
                new THREE.Mesh(
                    // La carcasse est un rien plus large que la boule : sans
                    // cela, superposées, les deux se disputeraient le pixel.
                    new THREE.SphereGeometry(RAYON_BOULE * (fantôme ? 1.015 : 1), fantôme ? 16 : 48, fantôme ? 10 : 32),
                    matière(couleurDe(1, fantôme), fantôme),
                ),
            ),
    },
    fil: {
        nom: '\\text{Fil}',
        formes: [uneDroite(ORIGINE, Z)],
        dessine: (fantôme) =>
            fantôme
                ? ossature([Z.clone().multiplyScalar(-LONGUEUR_FIL / 2), Z.clone().multiplyScalar(LONGUEUR_FIL / 2)])
                : tige(),
    },
    plan: {
        nom: '\\text{Plan}',
        formes: [unPlan(ORIGINE, Z)],
        dessine: (fantôme) => {
            if (!fantôme) return nappe();
            const r = PLEIN * RAYON_NAPPE;
            return ossature(
                cercleDePoints(r),
                [vecteur(-r, 0, 0), vecteur(r, 0, 0)],
                [vecteur(0, -r, 0), vecteur(0, r, 0)],
            );
        },
        réajuste: poseLaNappe,
    },
    spire: {
        nom: '\\text{Spire}',
        formes: [unCercle(ORIGINE, Z, RAYON_SPIRE)],
        dessine: (fantôme) =>
            fantôme
                ? ossature(cercleDePoints(RAYON_SPIRE))
                : groupe(
                      new THREE.Mesh(
                          new THREE.TorusGeometry(RAYON_SPIRE, 0.075, 12, 80),
                          matière(COULEUR.positive, false),
                      ),
                  ),
    },
    doublet: {
        nom: '\\text{2 charges}',
        formes: DOUBLET,
        dessine: (fantôme) => groupe(...DOUBLET.map(({ p, q }) => bille(p, q, fantôme))),
    },
};

// -- Les systèmes de coordonnées ----------------------------------------------
//
// La base locale au point M, les coordonnées qui repèrent M, et les
// déplacements qui font varier chacune d'elles. Seuls ceux qui sont des
// isométries y figurent : faire varier r n'en est pas une, et ne peut donc
// pas être une invariance — d'où deux curseurs seulement hors des
// cartésiennes.

const radial = (α) => vecteur(Math.cos(α), Math.sin(α), 0);
const orthoradial = (α) => vecteur(-Math.sin(α), Math.cos(α), 0);
const polaire = (θ, φ) => vecteur(Math.cos(θ) * Math.cos(φ), Math.cos(θ) * Math.sin(φ), -Math.sin(θ));

/** Un angle en degrés, compté de 0 à 360 comme dans le cours — et non de
 *  −180 à 180, comme le donne l'arc tangente. */
const degrés = (radians) => (((THREE.MathUtils.radToDeg(radians) % 360) + 360) % 360);

const translation = (axe, v) => new THREE.Matrix4().makeTranslation(axe.x * v, axe.y * v, axe.z * v);
const rotation = (axe, v) => new THREE.Matrix4().makeRotationAxis(axe, deg(v));

/** Un curseur de translation, et le déplacement qu'il commande. `témoin` est
 *  la valeur quelconque sur laquelle se juge l'invariance : elle ne doit
 *  rien avoir de remarquable, car une distribution peut se retrouver sur
 *  elle-même à une valeur particulière sans être invariante pour autant. */
const glisse = (tex, axe, phrase) => ({
    tex,
    phrase,
    min: -3,
    max: 3,
    pas: 0.05,
    unité: '',
    aimants: [0],
    témoin: 1.37,
    matrice: (v) => translation(axe, v),
});

/** Un curseur de rotation, en degrés. */
const tourne = (tex, axe, phrase, max = 360) => ({
    tex,
    phrase,
    min: 0,
    max,
    pas: 1,
    unité: '°',
    aimants: [0, 90, 180, 270, 360].filter((a) => a <= max),
    témoin: 41,
    matrice: (v) => rotation(axe, v),
    // L'arc qui dessine le geste : de `u` vers `v`, autour de `axe`.
    arc: axe === Z ? [X, Y] : [Z, X],
});

const SYSTÈMES = {
    cartésiennes: {
        nom: 'Coordonnées cartésiennes',
        abrégé: '(x, y, z)',
        coordonnées: ['x', 'y', 'z'],
        vecteurs: ['\\vec{e}_x', '\\vec{e}_y', '\\vec{e}_z'],
        base: () => [X, Y, Z],
        mesure: (p) => [p.x, p.y, p.z],
        unités: ['', '', ''],
        déplacements: [
            glisse('x', X, 'translation selon (Ox)'),
            glisse('y', Y, 'translation selon (Oy)'),
            glisse('z', Z, 'translation selon (Oz)'),
        ],
    },
    cylindriques: {
        nom: 'Coordonnées cylindriques',
        abrégé: '(r, \\theta, z)',
        coordonnées: ['r', '\\theta', 'z'],
        vecteurs: ['\\vec{e}_r', '\\vec{e}_\\theta', '\\vec{e}_z'],
        base: (p) => [radial(p.azimut), orthoradial(p.azimut), Z],
        mesure: (p) => [p.ρ, degrés(p.azimut), p.z],
        unités: ['', '^\\circ', ''],
        déplacements: [
            tourne('\\theta', Z, 'rotation autour de (Oz)'),
            glisse('z', Z, 'translation selon (Oz)'),
        ],
    },
    sphériques: {
        nom: 'Coordonnées sphériques',
        abrégé: '(r, \\theta, \\varphi)',
        coordonnées: ['r', '\\theta', '\\varphi'],
        vecteurs: ['\\vec{e}_r', '\\vec{e}_\\theta', '\\vec{e}_\\varphi'],
        base: (p) => [
            vecteur(
                Math.sin(p.colatitude) * Math.cos(p.azimut),
                Math.sin(p.colatitude) * Math.sin(p.azimut),
                Math.cos(p.colatitude),
            ),
            polaire(p.colatitude, p.azimut),
            orthoradial(p.azimut),
        ],
        mesure: (p) => [p.r, degrés(p.colatitude), degrés(p.azimut)],
        unités: ['', '^\\circ', '^\\circ'],
        déplacements: [
            // Une rotation autour de (Oy) fait varier θ, comme une rotation
            // autour de (Oz) fait varier φ : les deux engendrent toutes les
            // rotations autour de O.
            tourne('\\theta', Y, 'rotation autour de (Oy)', 180),
            tourne('\\varphi', Z, 'rotation autour de (Oz)'),
        ],
    },
};

/**
 * Les grandeurs qui repèrent M, avec leur mémoire : sur l'axe (Oz), l'azimut
 * n'est plus défini — toute direction y convient —, et à l'origine, la
 * colatitude non plus. On garde alors les derniers connus, pour que la base
 * locale ne saute pas d'un coup.
 */
function repérage(M, mémoire) {
    const ρ = Math.hypot(M.x, M.y);
    const r = M.length();
    if (ρ > ÉPSILON) mémoire.azimut = Math.atan2(M.y, M.x);
    if (r > ÉPSILON) mémoire.colatitude = Math.acos(THREE.MathUtils.clamp(M.z / r, -1, 1));
    return { x: M.x, y: M.y, z: M.z, ρ, r, ...mémoire };
}

// -- De quoi meubler les deux scènes ------------------------------------------

/** Les six distributions, construites une fois pour toutes : on ne montre
 *  que celle que l'on a choisie. `fantôme` en donne les carcasses. */
function copies(fantôme) {
    const dessinées = Object.fromEntries(
        Object.entries(DISTRIBUTIONS).map(([clé, { dessine }]) => [clé, dessine(fantôme)]),
    );
    for (const objet of Object.values(dessinées)) {
        objet.visible = false;
        // Leur place est donnée par une matrice — une symétrie en retourne
        // l'espace, ce qu'aucune position ni rotation ne saurait décrire.
        objet.matrixAutoUpdate = false;
    }
    return dessinées;
}

/** Montre la distribution choisie, et la pose où la transformation l'envoie —
 *  à sa façon, si elle en a une (cf. `poseLaNappe`). */
function pose(dessinées, choisie, matrice) {
    for (const [clé, objet] of Object.entries(dessinées)) {
        objet.visible = clé === choisie && matrice !== null;
        if (!objet.visible) continue;
        const réajuste = DISTRIBUTIONS[clé].réajuste;
        if (réajuste) réajuste(objet, matrice);
        else objet.matrix.copy(matrice);
        objet.matrixWorldNeedsUpdate = true;
    }
}

/** Le repère et les vues toutes faites, sans lesquels les curseurs ne
 *  nommeraient rien et la scène demanderait de savoir la tourner. */
function meuble(scène) {
    scène.ajoute(repère(4, ['x', 'y', 'z'], COULEUR.repère));
    scène.bouton('De face', () => scène.regarde({ position: [0, -16, 0], cible: [0, 0, 0] }));
    scène.bouton('De dessus', () => scène.regarde({ position: [0, -0.01, 16], cible: [0, 0, 0] }));
}

/** Une surface teintée et quadrillée : un plan de symétrie, que l'on voit
 *  comme un plan et non comme un trait. */
function planDeSymétrie(taille = 6.6) {
    const objet = new THREE.Group();
    const surface = new THREE.Mesh(
        new THREE.PlaneGeometry(taille, taille).rotateX(-Math.PI / 2),
        new THREE.MeshBasicMaterial({
            color: COULEUR.plan,
            transparent: true,
            opacity: 0.12,
            side: THREE.DoubleSide,
            depthWrite: false,
            toneMapped: false,
        }),
    );
    const grille = new THREE.GridHelper(taille, 10, COULEUR.plan, COULEUR.plan);
    Object.assign(grille.material, { transparent: true, opacity: 0.35, depthWrite: false, toneMapped: false });
    objet.add(surface, grille);
    /** Le plan passant par `centre`, de normale `normale`. */
    objet.oriente = (centre, normale) => {
        objet.position.copy(centre);
        objet.quaternion.setFromUnitVectors(Y, normale);
    };
    return objet;
}

/** Les cases « La distribution » et « Le système de coordonnées », que les
 *  deux animations posent de la même façon. */
function choixCommuns(réglages, état, replace) {
    réglages.groupe('La distribution');
    réglages.choix({
        options: Object.entries(DISTRIBUTIONS).map(([clé, { nom }]) => [clé, nom]),
        valeur: état.distribution,
        auChangement: (v) => {
            état.distribution = v;
            replace();
        },
    });

    const titre = réglages.groupe(SYSTÈMES[état.système].nom);
    réglages.choix({
        options: Object.entries(SYSTÈMES).map(([clé, { abrégé }]) => [clé, abrégé]),
        valeur: état.système,
        auChangement: (v) => {
            état.système = v;
            titre.écrit(SYSTÈMES[v].nom);
            replace();
        },
    });
}

// -- Invariances ---------------------------------------------------------------

function invariances(section) {
    const { vue, réglages: panneau } = cadre(section);
    const scène = new Scène(vue, { rapport: 4 / 3, taille: 10, ...DÉPART });
    meuble(scène);

    const état = { distribution: 'fil', système: 'cylindriques', départ: true };

    const carcasses = copies(true);
    const déplacées = copies(false);
    scène.ajoute(...Object.values(carcasses), ...Object.values(déplacées));

    // Le geste que commande le curseur, dessiné lui aussi : sans lui, une
    // invariance ne se distinguerait pas d'un curseur en panne.
    const gestes = SYSTÈMES.cartésiennes.déplacements.map(() => {
        const flèche = new Flèche({ couleur: COULEUR.geste, rayon: 0.02, largeur: 0.08, tête: 0.24 });
        flèche.nom = new Étiquette('', { couleur: COULEUR.geste });
        const arc = new Arc('', { couleur: COULEUR.geste, épaisseur: 2 });
        scène.ajoute(flèche, flèche.nom, arc);
        return { flèche, arc };
    });

    // -- Réglages ---------------------------------------------------------------

    const réglages = new Réglages(panneau);
    choixCommuns(réglages, état, () => {
        remetÀZéro();
        place();
    });

    // Les curseurs des trois systèmes, posés une fois : on ne montre que ceux
    // du système choisi, et chacun garde sa valeur.
    réglages.groupe('Déplacer la distribution');
    const curseurs = Object.fromEntries(
        Object.entries(SYSTÈMES).map(([clé, { déplacements }]) => [
            clé,
            déplacements.map((d) =>
                réglages.curseur({
                    tex: d.tex,
                    min: d.min,
                    max: d.max,
                    pas: d.pas,
                    valeur: 0,
                    unité: d.unité,
                    aimants: d.aimants,
                    auChangement: () => place(),
                }),
            ),
        ]),
    );
    const remetÀZéro = () => {
        for (const liste of Object.values(curseurs)) {
            for (const curseur of liste) curseur.valeur = 0;
        }
    };
    réglages.bouton('Tout remettre à zéro', () => {
        remetÀZéro();
        place();
    });
    réglages.case({
        texte: 'Montrer la position de départ',
        valeur: état.départ,
        auChangement: (v) => {
            état.départ = v;
            place();
        },
    });

    réglages.groupe('Ce qu’on voit');
    const observé = réglages.texte();

    réglages.groupe('Ce qu’on en déduit');
    const déduit = réglages.texte();
    const dépendance = réglages.formule();
    const remarque = réglages.texte();
    remarque.className = 'note';

    // -- Placement --------------------------------------------------------------

    function place() {
        const système = SYSTÈMES[état.système];
        const { formes } = DISTRIBUTIONS[état.distribution];
        for (const [clé, liste] of Object.entries(curseurs)) {
            for (const curseur of liste) curseur.montre(clé === état.système);
        }
        const valeurs = curseurs[état.système].map((c) => c.valeur);

        // La transformation totale : chaque déplacement s'applique après le
        // précédent — deux rotations d'axes différents ne commutent pas.
        const totale = new THREE.Matrix4();
        système.déplacements.forEach((d, i) => totale.premultiply(d.matrice(valeurs[i])));

        pose(déplacées, état.distribution, totale);
        pose(carcasses, état.distribution, état.départ ? new THREE.Matrix4() : null);

        // Les gestes : une flèche pour une translation, un arc pour une
        // rotation. Les curseurs des autres systèmes ne dessinent rien.
        for (const [i, { flèche, arc }] of gestes.entries()) {
            const d = système.déplacements[i];
            const valeur = d ? valeurs[i] : 0;
            flèche.visible = flèche.nom.visible = false;
            arc.visible = false;
            if (!d || Math.abs(valeur) < 1e-9) continue;
            if (d.arc) {
                const [u, v] = d.arc;
                arc.place(ORIGINE, u, v, deg(valeur), 2.9);
                arc.étiquette.écrit(d.tex);
            } else {
                const axe = valeur > 0 ? d.matrice(1) : d.matrice(-1);
                const direction = vecteur(axe.elements[12], axe.elements[13], axe.elements[14]);
                flèche.place(ORIGINE, direction, Math.abs(valeur));
                flèche.nom.écrit(d.tex).place(direction.clone().multiplyScalar(Math.abs(valeur) + 0.4));
                flèche.nom.visible = true;
            }
        }

        // Ce qu'on voit : la distribution est-elle, à cet instant, là où elle
        // était ? C'est la question que pose la scène, et rien d'autre.
        const bougé = valeurs.some((v) => Math.abs(v) > 1e-9);
        observé.textContent = !bougé
            ? 'Les curseurs sont à zéro : déplacez-en un.'
            : nature(formes, totale) === 'symétrie'
              ? 'La distribution est exactement là où elle était : rien n’a changé.'
              : 'La distribution a quitté sa position de départ : elle ne s’y superpose plus.';

        // Ce qu'on en déduit : l'invariance se juge coordonnée par
        // coordonnée, sur une valeur quelconque — une distribution peut se
        // retrouver sur elle-même à un angle particulier sans être invariante.
        const invariantes = système.déplacements.filter((d) => nature(formes, d.matrice(d.témoin)) === 'symétrie');
        déduit.textContent = invariantes.length
            ? `La distribution est invariante par ${énumère(invariantes.map((d) => d.phrase))}.`
            : 'La distribution n’est invariante par aucun de ces déplacements.';
        const variables = système.coordonnées.filter((c) => !invariantes.some((d) => d.tex === c));
        dépendance.écrit(`\\vec{E}(M) = \\vec{E}(${variables.join(', ')})`);
        // remarque.textContent = {
        //     1: 'Une seule variable : c’est le système adapté à cette distribution.',
        //     2: 'Deux variables au lieu de trois ; un autre système fait peut-être mieux.',
        //     3: 'Aucune invariance : ce système n’apprend rien ici, essayez-en un autre.',
        // }[variables.length];

        scène.redessine();
    }

    place();
}

// -- Plans de symétrie ---------------------------------------------------------

/**
 * Où M peut aller, et où il se pose de lui-même : sur l'axe (Oz), où se
 * coupent tous les plans méridiens, et dans le plan (O x y), qui est le plan
 * médiateur des deux charges, celui de la spire, et le plan chargé lui-même.
 * Ce sont les positions dont tout le chapitre parle, et la main seule ne les
 * atteindrait jamais exactement.
 */
function borne(p) {
    const ρ = Math.hypot(p.x, p.y);
    const retenu = ρ < 0.18 ? 0 : Math.min(ρ, 4);
    const α = Math.atan2(p.y, p.x);
    const z = Math.abs(p.z) < 0.15 ? 0 : THREE.MathUtils.clamp(p.z, -3.5, 3.5);
    return vecteur(retenu * Math.cos(α), retenu * Math.sin(α), z);
}

const VERDICT = {
    symétrie: '\\text{plan de symétrie}',
    antisymétrie: '\\text{plan d’antisymétrie}',
    aucune: '\\text{ni l’un ni l’autre}',
};

function symétries(section) {
    const { vue, réglages: panneau } = cadre(section);
    const scène = new Scène(vue, { rapport: 4 / 3, taille: 10, ...DÉPART });
    meuble(scène);
    scène.aide('Glisser M pour le déplacer, glisser ailleurs pour tourner la scène.');

    const état = {
        distribution: 'fil',
        système: 'cylindriques',
        plan: 1,
        M: vecteur(2.3, 1.3, 1.4),
        mémoire: { azimut: 0, colatitude: Math.PI / 2 },
    };

    const originales = copies(false);
    const images = copies(true);
    scène.ajoute(...Object.values(originales), ...Object.values(images));

    const plan = planDeSymétrie();
    const pointM = point(COULEUR.base, 0.13);
    const nomM = new Étiquette('M', { couleur: COULEUR.base, décalage: '-1.1em 1em' });
    const base = [0, 1, 2].map(() => {
        const flèche = new Flèche({ couleur: COULEUR.base, dessus: true });
        flèche.nom = new Étiquette('', { couleur: COULEUR.base });
        return flèche;
    });
    scène.ajoute(plan, pointM, nomM, ...base, ...base.map((f) => f.nom));

    scène.poignée({
        position: () => état.M,
        auDéplacement: (p) => {
            état.M.copy(borne(p));
            place();
        },
    });

    // -- Réglages ---------------------------------------------------------------

    const réglages = new Réglages(panneau);
    choixCommuns(réglages, état, () => place());

    réglages.groupe('Le plan, passant par M');
    const boutonsDuPlan = réglages.choix({
        options: [[-1, '\\text{aucun}']],
        valeur: état.plan,
        auChangement: (v) => {
            état.plan = Number(v);
            place();
        },
    });

    réglages.groupe('Le point M');
    const coordonnées = réglages.formule();
    réglages.texte('Glissez M dans la scène. De face, il reste dans le plan (x O z) ; de dessus, dans le plan (x O y).').className =
        'note';

    réglages.groupe('Ce qu’on lit');
    const verdicts = [0, 1, 2].map(() => réglages.formule());

    réglages.groupe('Ce qu’on en déduit');
    const composantes = réglages.formule();
    const remarque = réglages.texte();
    remarque.className = 'note';

    // Les trois plans ne se nomment qu'une fois le système connu : leurs
    // boutons se refont donc quand on en change, et seulement alors.
    let nommésPour = null;
    function nommeLesPlans(système) {
        if (système === nommésPour) return;
        nommésPour = système;
        const options = [[-1, '\\text{aucun}']];
        for (const i of [0, 1, 2]) {
            const [u, v] = [0, 1, 2].filter((k) => k !== i);
            options.push([i, `(${système.vecteurs[u]}, ${système.vecteurs[v]})`]);
        }
        boutonsDuPlan.réécrit(options, état.plan);
    }

    // -- Placement --------------------------------------------------------------

    function place() {
        const système = SYSTÈMES[état.système];
        const { formes } = DISTRIBUTIONS[état.distribution];
        const M = état.M;
        const p = repérage(M, état.mémoire);
        const vecteurs = système.base(p);
        nommeLesPlans(système);

        pointM.position.copy(M);
        nomM.place(M);

        // La base locale, et le plan choisi : les deux vecteurs qui le
        // dirigent prennent sa couleur, le troisième en est la normale.
        for (const [i, flèche] of base.entries()) {
            const couleur = état.plan >= 0 && i !== état.plan ? COULEUR.plan : COULEUR.base;
            flèche.couleur(couleur).place(M, vecteurs[i], 1.2);
            flèche.nom
                .écrit(système.vecteurs[i])
                .couleur(couleur)
                .place(M.clone().addScaledVector(vecteurs[i], 1.5));
        }

        const normale = état.plan >= 0 ? vecteurs[état.plan] : null;
        plan.visible = normale !== null;
        if (normale) plan.oriente(M, normale);

        // La distribution, et son image par le plan choisi : c'est en les
        // comparant que tout se joue.
        pose(originales, état.distribution, new THREE.Matrix4());
        pose(images, état.distribution, normale ? réflexion(M, normale) : null);

        const natures = vecteurs.map((n) => nature(formes, réflexion(M, n)));
        for (const [i, formule] of verdicts.entries()) {
            const [u, v] = [0, 1, 2].filter((k) => k !== i);
            formule.écrit(`(${système.vecteurs[u]}, ${système.vecteurs[v]}) : ${VERDICT[natures[i]]}`);
        }

        // M appartient à chacun de ces plans : le champ y est contenu si le
        // plan est de symétrie, et perpendiculaire s'il est d'antisymétrie.
        let permises = new Set([0, 1, 2]);
        natures.forEach((n, i) => {
            if (n === 'symétrie') permises.delete(i);
            if (n === 'antisymétrie') permises = new Set([...permises].filter((k) => k === i));
        });
        const restantes = [...permises];
        composantes.écrit(
            restantes.length
                ? `\\vec{E}(M) = ${restantes.map((i) => `E_{${système.coordonnées[i]}}\\,${système.vecteurs[i]}`).join(' + ')}`
                : '\\vec{E}(M) = \\vec{0}',
        );
        // remarque.textContent = {
        //     0: 'Tous ces plans imposent une direction, et elles se contredisent : le champ est nul en M.',
        //     1: 'Une seule direction possible : la symétrie donne la direction du champ, mais pas son sens.',
        //     2: 'Le champ est contenu dans le plan de symétrie ; il y faut une invariance de plus, ou un autre point M.',
        //     3: 'Aucun de ces plans n’est de symétrie : ils n’apprennent rien en ce point.',
        // }[restantes.length];

        const mesures = système.mesure(p);
        coordonnées.écrit(
            système.coordonnées.map((c, i) => `${c} = ${nombre(mesures[i])}${système.unités[i]}`).join(',\\; '),
        );

        scène.redessine();
    }

    place();
}

lance('section.animation', (section) => {
    ({ invariances, symetries: symétries })[section.dataset.animation](section);
});
