// La machine synchrone du cours, en coupe : diphasée, bipolaire, à entrefer
// constant (rotor lisse). Ce module ne fait que la dessiner ; la physique est
// dans machine-synchrone.js.
//
// On la voit coupée en son milieu, dans le plan z = 0 : la moitié avant est
// ôtée, le plan de coupe montre les tôles, les encoches et la section des
// conducteurs. Derrière, les têtes de bobines, l'arbre et ses bagues.
//
// Le stator porte deux enroulements décalés de 90° (cf. le cours) :
//   - l'enroulement 1, d'axe θ = 0 : ses conducteurs aller (« 1 ») autour de
//     θ = 90°, retour (« 1′ ») autour de θ = 270° ;
//   - l'enroulement 2, d'axe θ = −90° : aller (« 2 ») autour de θ = 0,
//     retour (« 2′ ») autour de θ = 180°.
// C'est ce qui donne, avec i₁ = I cos(ωt) et i₂ = I cos(ωt + π/2), le champ
// glissant B_s ∝ cos(ωt − θ) du cours. Le rotor porte l'enroulement
// d'excitation, parcouru par le courant continu I_e : aller autour de
// θ_r + 90°, retour autour de θ_r − 90°, son axe (le pôle nord) en θ_r.

import * as THREE from 'three';

// -- Dimensions (unités arbitraires) ------------------------------------------

export const R_ARBRE = 0.55;
export const R_ROTOR = 2.9;
export const R_ALÉSAGE = 3.02; // l'alésage du stator : l'entrefer est très étroit
export const R_STATOR = 5;
export const R_ENTREFER = (R_ROTOR + R_ALÉSAGE) / 2;
/** Longueur de la demi-machine visible, derrière le plan de coupe. */
export const LONGUEUR = 3.2;

const ENCOCHES = 24;
const OUVERTURE = 0.14; // largeur de l'ouverture d'une encoche du stator
const LARGEUR_ENCOCHE = 0.36;
const R_COL = 3.12; // où l'encoche s'élargit
const CHANFREIN = 0.07;
const R_FOND = 4.08;

/** Encoches du rotor, en degrés depuis son axe : cinq de part et d'autre,
 *  les pôles lisses entre elles. */
const ENCOCHES_ROTOR = [-34, -17, 0, 17, 34].flatMap((δ) => [90 + δ, -90 + δ]);
const LARGEUR_ENCOCHE_ROTOR = 0.3;
const PROFONDEUR_ENCOCHE_ROTOR = 0.78;
const CALE = 0.13; // la cale qui ferme l'encoche du rotor

const deg = THREE.MathUtils.degToRad;
const polaire = (r, a) => new THREE.Vector2(r * Math.cos(a), r * Math.sin(a));
/** Le point à la distance r de l'axe, décalé de s de côté par rapport à la
 *  direction a. */
const local = (a, r, s) => polaire(r, a).add(polaire(s, a + Math.PI / 2));

// -- Matériaux ----------------------------------------------------------------

/** Sur les flancs, les tôles se groupent en paquets, séparés par les canaux
 *  de ventilation : une rainure en relief tous les 0,8. Pas une rayure par
 *  tôle, trop fine pour l'écran : elle moirerait. */
function textureTôles() {
    const toile = document.createElement('canvas');
    toile.width = 2;
    toile.height = 64;
    const c = toile.getContext('2d');
    c.fillStyle = '#fff';
    c.fillRect(0, 0, 2, 64);
    c.fillStyle = '#000';
    c.fillRect(0, 58, 2, 6);
    const texture = new THREE.CanvasTexture(toile);
    texture.wrapS = texture.wrapT = THREE.RepeatWrapping;
    texture.repeat.set(1, 1.25);
    return texture;
}

const tôles = textureTôles();
export const MATÉRIAUX = {
    // Le plan de coupe, plus clair que les flancs : on lit la section.
    coupe: new THREE.MeshStandardMaterial({ color: '#868c93', metalness: 0.3, roughness: 0.5 }),
    flanc: new THREE.MeshStandardMaterial({
        color: '#5d636a',
        metalness: 0.6,
        roughness: 0.5,
        bumpMap: tôles,
        bumpScale: 3,
    }),
    cuivre: new THREE.MeshStandardMaterial({ color: '#b4602a', metalness: 0.8, roughness: 0.35 }),
    isolant: new THREE.MeshStandardMaterial({ color: '#c9b98a', metalness: 0, roughness: 0.8 }),
    cale: new THREE.MeshStandardMaterial({ color: '#5b4a3a', metalness: 0.1, roughness: 0.6 }),
    arbre: new THREE.MeshStandardMaterial({ color: '#a4a9ae', metalness: 0.9, roughness: 0.3 }),
    bague: new THREE.MeshStandardMaterial({ color: '#c9a150', metalness: 1, roughness: 0.28 }),
    balai: new THREE.MeshStandardMaterial({ color: '#2e2e30', metalness: 0.1, roughness: 0.85 }),
};

/** Un profil extrudé de `z0` à `z1`, coupe et flancs chacun leur matériau.
 *  Ses arcs sont découpés en `segments` morceaux chacun. */
function extrude(forme, z0, z1, flanc, coupe = flanc, segments = 10) {
    const géométrie = new THREE.ExtrudeGeometry(forme, { depth: z1 - z0, bevelEnabled: false, curveSegments: segments });
    géométrie.translate(0, 0, z0);
    return new THREE.Mesh(géométrie, [coupe, flanc]);
}

// -- Profils --------------------------------------------------------------------

/**
 * Le contour d'une encoche du stator d'axe `a` : depuis le bord de l'alésage
 * (où le chemin doit déjà se trouver), l'ouverture étroite, puis l'encoche à
 * fond plat, jusqu'à l'autre bord — dans le sens trigonométrique autour de
 * l'axe de la machine.
 */
function contourEncoche(chemin, a) {
    const P = (r, s) => chemin.lineTo(...local(a, r, s).toArray());
    const [o, l] = [OUVERTURE / 2, LARGEUR_ENCOCHE / 2];
    P(R_COL, -o);
    P(R_COL + CHANFREIN, -l);
    P(R_FOND, -l);
    P(R_FOND, l);
    P(R_COL + CHANFREIN, l);
    P(R_COL, o);
    P(Math.sqrt(R_ALÉSAGE ** 2 - o * o), o);
}

/** De même pour une encoche du rotor, creusée vers l'axe et ouverte sur
 *  l'entrefer sur toute sa largeur. */
function contourEncocheRotor(chemin, a) {
    const P = (r, s) => chemin.lineTo(...local(a, r, s).toArray());
    const l = LARGEUR_ENCOCHE_ROTOR / 2;
    P(R_ROTOR - PROFONDEUR_ENCOCHE_ROTOR, -l);
    P(R_ROTOR - PROFONDEUR_ENCOCHE_ROTOR, l);
    P(Math.sqrt(R_ROTOR ** 2 - l * l), l);
}

/** Un rectangle d'axe `a`, entre les distances r0 et r1 à l'axe, de largeur l. */
function barreau(a, r0, r1, l) {
    const coins = [
        [r0, -l / 2],
        [r1, -l / 2],
        [r1, l / 2],
        [r0, l / 2],
    ].map(([r, s]) => local(a, r, s));
    return new THREE.Shape(coins);
}

/** Les angles des encoches du stator : 15° de pas, décalées d'un demi-pas
 *  pour qu'aucune ne tombe sur un axe d'enroulement. */
export const ANGLES_ENCOCHES = Array.from({ length: ENCOCHES }, (_, k) => deg(7.5 + 15 * k));

/**
 * L'enroulement et le sens d'une encoche du stator : +1 pour un conducteur
 * aller (le courant sort du plan de coupe, ⊙, quand le courant de phase est
 * positif), −1 pour un retour.
 */
export function bobinage(a) {
    const s = Math.sin(a);
    const c = Math.cos(a);
    return Math.abs(s) > Math.abs(c) ? { phase: 1, sens: Math.sign(s) } : { phase: 2, sens: Math.sign(c) };
}

// -- Stator ---------------------------------------------------------------------

const R_CUIVRE = R_COL + CHANFREIN + 0.13; // le bas du cuivre, au-dessus de la cale
/** La distance à l'axe du milieu des conducteurs du stator. */
export const R_CONDUCTEUR = (R_CUIVRE + R_FOND - 0.03) / 2;

function stator() {
    const groupe = new THREE.Group();
    // Le contour extérieur en polygone fin : un seul arc de 2π ne recevrait
    // que les quelques segments de tous les autres.
    const forme = new THREE.Shape(Array.from({ length: 192 }, (_, k) => polaire(R_STATOR, (2 * Math.PI * k) / 192)));
    const alésage = new THREE.Path();
    const δ = Math.asin(OUVERTURE / 2 / R_ALÉSAGE);
    alésage.moveTo(...polaire(R_ALÉSAGE, ANGLES_ENCOCHES[0] - δ).toArray());
    ANGLES_ENCOCHES.forEach((a, k) => {
        contourEncoche(alésage, a);
        const suivante = ANGLES_ENCOCHES[(k + 1) % ENCOCHES] + (k + 1 === ENCOCHES ? 2 * Math.PI : 0);
        alésage.absarc(0, 0, R_ALÉSAGE, a + δ, suivante - δ, false);
    });
    forme.holes.push(alésage);
    groupe.add(extrude(forme, -LONGUEUR, 0, MATÉRIAUX.flanc, MATÉRIAUX.coupe));

    // Dans chaque encoche, une cale qui la ferme côté entrefer, et le cuivre
    // dans son isolant. Les conducteurs dépassent du paquet de tôles, vers les
    // têtes de bobines.
    for (const a of ANGLES_ENCOCHES) {
        groupe.add(extrude(barreau(a, R_COL + CHANFREIN, R_CUIVRE - 0.03, LARGEUR_ENCOCHE), -LONGUEUR, 0, MATÉRIAUX.cale));
        const isolant = barreau(a, R_CUIVRE - 0.03, R_FOND, LARGEUR_ENCOCHE);
        const cuivre = barreau(a, R_CUIVRE, R_FOND - 0.03, LARGEUR_ENCOCHE - 0.06);
        isolant.holes.push(cuivre);
        groupe.add(extrude(isolant, -LONGUEUR, 0, MATÉRIAUX.isolant));
        groupe.add(extrude(cuivre, -LONGUEUR - 0.25, 0, MATÉRIAUX.cuivre));
    }

    // Les têtes de bobines : chaque conducteur aller rejoint, derrière la
    // machine, le conducteur retour symétrique par rapport au milieu de
    // la bande de retour — bobines concentriques. L'enroulement 1 passe par
    // θ = 180°, l'enroulement 2 par θ = 270°, un peu plus en arrière et plus
    // au large, pour que les deux se croisent sans se toucher.
    const têtes = { 1: { via: deg(180), hauteur: 0.45, écart: 0.1 }, 2: { via: deg(270), hauteur: 0.8, écart: 0.45 } };
    for (const a of ANGLES_ENCOCHES) {
        const { phase, sens } = bobinage(a);
        if (sens < 0) continue;
        const { via, hauteur, écart } = têtes[phase];
        groupe.add(têteDeBobine(a, via, R_CONDUCTEUR, -LONGUEUR - 0.25, hauteur, écart, 0.075));
    }
    return groupe;
}

/**
 * Une tête de bobine : le cuivre qui relie, derrière la machine, le
 * conducteur d'angle `a` à son symétrique par rapport à `via`, en passant
 * par `via`, en s'écartant de la machine de `hauteur` et de l'axe de `écart`.
 */
function têteDeBobine(a, via, r, z, hauteur, écart, épaisseur) {
    // L'écart angulaire à `via`, ramené dans ]−π, π].
    const d = THREE.MathUtils.euclideanModulo(a - via + Math.PI, 2 * Math.PI) - Math.PI;
    const courbe = new THREE.Curve();
    // Une bobine plus large déborde davantage : les têtes s'emboîtent.
    const débord = hauteur * (Math.abs(d) / Math.PI + 0.4);
    courbe.getPoint = (t, cible = new THREE.Vector3()) => {
        const angle = via + d * (1 - 2 * t);
        const bosse = Math.sin(Math.PI * t) ** 0.6;
        const rayon = r + écart * bosse;
        return cible.set(rayon * Math.cos(angle), rayon * Math.sin(angle), z - débord * (0.35 + 0.65 * bosse));
    };
    // Les deux bouts rejoignent le conducteur à l'arrière du paquet.
    const chemin = new THREE.CurvePath();
    const départ = new THREE.Vector3(r * Math.cos(a), r * Math.sin(a), z + 0.05);
    const retour = 2 * via - a;
    const arrivée = new THREE.Vector3(r * Math.cos(retour), r * Math.sin(retour), z + 0.05);
    chemin.add(new THREE.LineCurve3(départ, courbe.getPoint(0)));
    chemin.add(courbe);
    chemin.add(new THREE.LineCurve3(courbe.getPoint(1), arrivée));
    return new THREE.Mesh(new THREE.TubeGeometry(chemin, 64, épaisseur, 8, false), MATÉRIAUX.cuivre);
}

// -- Rotor ----------------------------------------------------------------------

/** La distance à l'axe du milieu des conducteurs du rotor. */
export const R_CONDUCTEUR_ROTOR = R_ROTOR - CALE - (PROFONDEUR_ENCOCHE_ROTOR - CALE) / 2;

/** Les encoches du rotor : angle (depuis son axe) et sens du courant I_e. */
export const ENCOCHES_DU_ROTOR = ENCOCHES_ROTOR.map((a) => ({ angle: deg(a), sens: Math.sign(Math.sin(deg(a))) }));

function rotor() {
    const groupe = new THREE.Group();
    // Le contour extérieur, creusé des encoches, ouvertes sur l'entrefer.
    const angles = [...ENCOCHES_DU_ROTOR.map((e) => e.angle)].sort((a, b) => a - b);
    const forme = new THREE.Shape();
    const δ = Math.asin(LARGEUR_ENCOCHE_ROTOR / 2 / R_ROTOR);
    forme.moveTo(...polaire(R_ROTOR, angles[0] - δ).toArray());
    angles.forEach((a, k) => {
        contourEncocheRotor(forme, a);
        const suivante = angles[(k + 1) % angles.length] + (k + 1 === angles.length ? 2 * Math.PI : 0);
        forme.absarc(0, 0, R_ROTOR, a + δ, suivante - δ, false);
    });
    forme.holes.push(new THREE.Path().absarc(0, 0, R_ARBRE, 0, 2 * Math.PI, true));
    // Les arcs des pôles couvrent 100° : il leur faut plus de segments.
    groupe.add(extrude(forme, -LONGUEUR, 0, MATÉRIAUX.flanc, MATÉRIAUX.coupe, 40));

    for (const { angle } of ENCOCHES_DU_ROTOR) {
        const fond = R_ROTOR - PROFONDEUR_ENCOCHE_ROTOR;
        const isolant = barreau(angle, fond, R_ROTOR - CALE, LARGEUR_ENCOCHE_ROTOR);
        const cuivre = barreau(angle, fond + 0.03, R_ROTOR - CALE, LARGEUR_ENCOCHE_ROTOR - 0.06);
        isolant.holes.push(cuivre);
        groupe.add(extrude(isolant, -LONGUEUR, 0, MATÉRIAUX.isolant));
        groupe.add(extrude(cuivre, -LONGUEUR - 0.2, 0, MATÉRIAUX.cuivre));
        groupe.add(extrude(barreau(angle, R_ROTOR - CALE, R_ROTOR, LARGEUR_ENCOCHE_ROTOR), -LONGUEUR, 0, MATÉRIAUX.cale));
    }
    // Têtes de bobines du rotor : chaque bobine entoure un pôle.
    for (const { angle, sens } of ENCOCHES_DU_ROTOR) {
        if (sens < 0) continue;
        const via = Math.cos(angle) >= -1e-9 ? 0 : Math.PI;
        groupe.add(têteDeBobine(angle, via, R_CONDUCTEUR_ROTOR - 0.05, -LONGUEUR - 0.2, 0.3, -0.25, 0.065));
    }

    // L'arbre, et les deux bagues qui amènent le courant d'excitation.
    const arbre = new THREE.Mesh(new THREE.CylinderGeometry(R_ARBRE, R_ARBRE, LONGUEUR + 3.4, 40), MATÉRIAUX.arbre);
    arbre.rotation.x = Math.PI / 2;
    arbre.position.z = -(LONGUEUR + 3.4) / 2;
    groupe.add(arbre);
    for (const z of [-LONGUEUR - 1.6, -LONGUEUR - 2.3]) {
        const bague = new THREE.Mesh(new THREE.CylinderGeometry(0.85, 0.85, 0.35, 48), MATÉRIAUX.bague);
        bague.rotation.x = Math.PI / 2;
        bague.position.z = z;
        groupe.add(bague);
    }
    return groupe;
}

/** Les balais, fixes, qui frottent sur les bagues. */
function balais() {
    const groupe = new THREE.Group();
    for (const z of [-LONGUEUR - 1.6, -LONGUEUR - 2.3]) {
        const balai = new THREE.Mesh(new THREE.BoxGeometry(0.3, 0.55, 0.26), MATÉRIAUX.balai);
        balai.position.set(0, 0.85 + 0.27, z);
        groupe.add(balai);
    }
    return groupe;
}

/** La machine : `stator` fixe (avec les balais), `rotor` à faire tourner
 *  autour de (O z) — son axe est en θ = 0 quand sa rotation est nulle. */
export function machine() {
    const fixe = stator();
    fixe.add(balais());
    return { stator: fixe, rotor: rotor() };
}
