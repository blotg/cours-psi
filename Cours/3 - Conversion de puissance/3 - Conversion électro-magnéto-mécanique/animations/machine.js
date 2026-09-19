// La machine synchrone du cours, en coupe : diphasée, bipolaire, à entrefer
// constant (rotor lisse). Ce module ne fait que la dessiner ; la physique est
// dans machine-synchrone.js.
//
// On la voit coupée en son milieu, dans le plan z = 0 : la moitié avant est
// ôtée, le plan de coupe montre les tôles, les encoches et la section des
// conducteurs. Derrière, les têtes de bobines, l'arbre et ses bagues.
//
// Trois circuits, de N spires chacun, logées dans N encoches de part et
// d'autre de l'axe du circuit :
//   - le circuit statorique 1, d'axe θ = 0 : ses conducteurs aller (« 1 »)
//     autour de θ = 90°, retour (« 1′ ») autour de θ = 270° ;
//   - le circuit statorique 2, d'axe θ = −90° : aller (« 2 ») autour de
//     θ = 0, retour (« 2′ ») autour de θ = 180° ;
//   - le circuit rotorique, d'axe θ_r : aller autour de θ_r + 90°, retour
//     autour de θ_r − 90°.
// C'est ce qui donne, avec i₁ = I cos(ωt) et i₂ = I cos(ωt + π/2), le champ
// glissant B_s ∝ cos(ωt − θ) du cours — à la limite N → ∞.

import * as THREE from 'three';

// -- Dimensions (unités arbitraires) ------------------------------------------

export const R_ARBRE = 0.55;
export const R_ROTOR = 2.9;
export const R_ALÉSAGE = 3.02; // l'alésage du stator : l'entrefer est très étroit
export const R_STATOR = 5;
export const R_ENTREFER = (R_ROTOR + R_ALÉSAGE) / 2;
/** Longueur de la demi-machine visible, derrière le plan de coupe. */
export const LONGUEUR = 3.2;

const R_FOND = 4; // le fond des encoches du stator
const PROFONDEUR_ROTOR = 0.72; // la profondeur des encoches du rotor
const LARGEUR_MAX = { stator: 0.34, rotor: 0.3 };
/** Le rayon des fils des têtes de bobines pour N = 1 : ils s'affinent en 1/N,
 *  et leur faisceau garde la même largeur. */
const RAYON_FIL = { stator: 0.15, rotor: 0.12 };
/** L'isolant entre le conducteur et les bords de son encoche : une fine
 *  bordure sombre, à la mesure de l'encoche. */
const isolant = (l) => Math.min(0.035, 0.15 * l);

const polaire = (r, a) => new THREE.Vector2(r * Math.cos(a), r * Math.sin(a));
/** Le point à la distance r de l'axe, décalé de s de côté par rapport à la
 *  direction a. */
const local = (a, r, s) => polaire(r, a).add(polaire(s, a + Math.PI / 2));
/** Un angle ramené dans ]−π, π]. */
const angleSigné = (a) => THREE.MathUtils.euclideanModulo(a + Math.PI, 2 * Math.PI) - Math.PI;
const tourPositif = (a) => THREE.MathUtils.euclideanModulo(a, 2 * Math.PI);

// -- Les conducteurs ------------------------------------------------------------

/**
 * Où placer les N spires d'un circuit, depuis son axe : pour que le champ,
 * qui saute du même cran à chaque conducteur (théorème d'Ampère), descende
 * en N marches égales qui épousent un cosinus. Le k-ième conducteur aller est
 * à l'angle φ tel que cos φ = 1 − (2k + 1)/N ; son retour, à −φ. Pour N = 1,
 * c'est la spire unique du cours, à ±90° de l'axe. Au stator, `répartis` les
 * décale un peu, pour faire place aux deux circuits.
 */
function positions(N) {
    return Array.from({ length: N }, (_, k) => Math.acos(1 - (2 * k + 1) / N));
}

/**
 * Les conducteurs des circuits : leur angle (dans le repère du rotor pour
 * celui-ci) et leur sens, +1 pour un aller — le courant sort du plan de coupe
 * (⊙) quand celui du circuit est positif —, −1 pour un retour. `via` dit par
 * où passe la tête de bobine d'un aller : chaque spire entoure l'axe de son
 * circuit, ou l'axe opposé.
 */
export function circuits(N) {
    const circuit = (nom, axe) =>
        positions(N).flatMap((φ) => [
            { circuit: nom, angle: axe + φ, sens: 1, via: φ <= Math.PI / 2 + 1e-9 ? axe : axe + Math.PI },
            { circuit: nom, angle: axe - φ, sens: -1 },
        ]);
    return { stator: répartis([...circuit(1, 0), ...circuit(2, -Math.PI / 2)], N), rotor: circuit('rotor', 0) };
}

/**
 * À leur place idéale, des conducteurs des deux circuits statoriques
 * tomberaient presque les uns sur les autres — à 0,2° près pour N = 17 : plus
 * la place d'une encoche entre eux. On garde leur ordre autour de l'alésage,
 * mais on les espace selon leur densité moyenne, N/2 (|sin θ| + |cos θ|) par
 * radian — |sin θ| pour le circuit 1, |cos θ| pour le 2. Aucun ne bouge de
 * plus d'un écart entre encoches : les champs tendent toujours vers le champ
 * sinusoïdal quand N → ∞. Et deux encoches voisines sont à √2/N radian au
 * moins l'une de l'autre, là où la densité est la plus forte, à 45° des axes.
 */
function répartis(conducteurs, N) {
    // L'angle où le nombre moyen de conducteurs, compté depuis θ = 0, atteint
    // n : il en passe N par quart de tour.
    const angle = (n) => {
        const quarts = Math.floor(n / N);
        const x = (2 * (n - quarts * N)) / N - 1;
        return (quarts * Math.PI) / 2 + Math.PI / 4 + Math.asin(THREE.MathUtils.clamp(x / Math.SQRT2, -1, 1));
    };
    // Pour N impair, un conducteur du circuit 2 est en θ = 0 : il y reste.
    const départ = N % 2 ? 0 : 0.5;
    [...conducteurs]
        .sort((a, b) => tourPositif(a.angle) - tourPositif(b.angle))
        .forEach((c, k) => (c.angle = angle(k + départ)));
    return conducteurs;
}

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

const MATÉRIAUX = {
    // Le plan de coupe, plus clair que les flancs : on lit la section.
    coupe: new THREE.MeshStandardMaterial({ color: '#868c93', metalness: 0.3, roughness: 0.5 }),
    flanc: new THREE.MeshStandardMaterial({
        color: '#5d636a',
        metalness: 0.6,
        roughness: 0.5,
        bumpMap: textureTôles(),
        bumpScale: 3,
    }),
    arbre: new THREE.MeshStandardMaterial({ color: '#a4a9ae', metalness: 0.9, roughness: 0.3 }),
    bague: new THREE.MeshStandardMaterial({ color: '#c9a150', metalness: 1, roughness: 0.28 }),
    balai: new THREE.MeshStandardMaterial({ color: '#2e2e30', metalness: 0.1, roughness: 0.85 }),
    isolant: new THREE.MeshStandardMaterial({ color: '#33383d', metalness: 0, roughness: 0.8 }),
};

/** Un profil extrudé de `z0` à `z1`, coupe et flancs chacun leur matériau.
 *  Ses arcs sont découpés en `segments` morceaux chacun. */
function extrude(forme, z0, z1, flanc, coupe = flanc, segments = 10) {
    const géométrie = new THREE.ExtrudeGeometry(forme, { depth: z1 - z0, bevelEnabled: false, curveSegments: segments });
    géométrie.translate(0, 0, z0);
    return new THREE.Mesh(géométrie, [coupe, flanc]);
}

// -- Profils --------------------------------------------------------------------

/** Un rectangle d'axe `a`, entre les distances r0 et r1 à l'axe, de largeur l. */
function barreau(a, r0, r1, l) {
    return new THREE.Shape([local(a, r0, -l / 2), local(a, r1, -l / 2), local(a, r1, l / 2), local(a, r0, l / 2)]);
}

/**
 * Ce qui remplit une encoche d'axe `a`, entre r0 et r1, de largeur l : le
 * conducteur, du matériau `fil`, qui dépasse de `dépassement` derrière le
 * paquet de tôles, et l'isolant qui l'entoure.
 */
function encoche(a, r0, r1, l, fil, dépassement) {
    const e = isolant(l);
    const cuivre = barreau(a, r0 + e, r1 - e, l - 2 * e);
    const gaine = barreau(a, r0, r1, l);
    gaine.holes.push(cuivre);
    return [extrude(cuivre, -LONGUEUR - dépassement, 0, fil), extrude(gaine, -LONGUEUR, 0, MATÉRIAUX.isolant)];
}

/**
 * Un contour circulaire de rayon `r`, creusé d'encoches rectangulaires de
 * largeur `l` aux angles des conducteurs, jusqu'à la distance `fond` de
 * l'axe : vers l'extérieur pour le stator, vers l'axe pour le rotor.
 */
function contourEncoché(chemin, conducteurs, r, fond, l) {
    const angles = conducteurs.map((c) => tourPositif(c.angle)).sort((a, b) => a - b);
    const δ = Math.asin(l / 2 / r);
    const bord = Math.sqrt(r * r - (l * l) / 4);
    chemin.moveTo(...polaire(r, angles[0] - δ).toArray());
    angles.forEach((a, k) => {
        chemin.lineTo(...local(a, fond, -l / 2).toArray());
        chemin.lineTo(...local(a, fond, l / 2).toArray());
        chemin.lineTo(...local(a, bord, l / 2).toArray());
        const suivante = k + 1 < angles.length ? angles[k + 1] : angles[0] + 2 * Math.PI;
        chemin.absarc(0, 0, r, a + δ, suivante - δ, false);
    });
    return chemin;
}

/**
 * Une tête de bobine : le fil qui relie, derrière la machine, le conducteur
 * d'angle `a` à son symétrique par rapport à `via`, en passant par `via`, en
 * s'écartant de la machine de `hauteur` et de l'axe de `écart`.
 */
function têteDeBobine(a, via, { r, z, hauteur, écart, épaisseur, matériau }) {
    // L'écart angulaire à `via`, ramené dans ]−π, π].
    const d = angleSigné(a - via);
    // Une bobine plus large déborde davantage : les têtes s'emboîtent.
    const débord = hauteur * (Math.abs(d) / Math.PI + 0.4);
    const courbe = new THREE.Curve();
    courbe.getPoint = (t, cible = new THREE.Vector3()) => {
        const angle = via + d * (1 - 2 * t);
        const bosse = Math.sin(Math.PI * t) ** 0.6;
        const rayon = r + écart * bosse;
        return cible.set(rayon * Math.cos(angle), rayon * Math.sin(angle), z - débord * (0.35 + 0.65 * bosse));
    };
    // Les deux bouts rejoignent le conducteur à l'arrière du paquet de tôles.
    const bout = (angle) => new THREE.Vector3(r * Math.cos(angle), r * Math.sin(angle), z + 0.05);
    const chemin = new THREE.CurvePath();
    chemin.add(new THREE.LineCurve3(bout(a), courbe.getPoint(0)));
    chemin.add(courbe);
    chemin.add(new THREE.LineCurve3(courbe.getPoint(1), bout(2 * via - a)));
    return new THREE.Mesh(new THREE.TubeGeometry(chemin, 64, épaisseur, 8, false), matériau);
}

// -- La machine -------------------------------------------------------------------

/**
 * La machine à N encoches par côté de chaque circuit, les fils de chaque
 * circuit de sa couleur (`couleurs[1]`, `couleurs[2]`, `couleurs.rotor`).
 *
 * Renvoie le `stator`, fixe (avec les balais), le `rotor`, à faire tourner
 * autour de (O z) — son axe est en θ = 0 quand sa rotation est nulle —, les
 * conducteurs de chacun (cf. `circuits`, complétés de la distance `rayon` de
 * leur milieu à l'axe), le rayon des symboles de courant qui tiennent sur
 * leur section, et `libère()`, qui rend la mémoire de la carte graphique.
 */
export function machine(N, couleurs) {
    const { stator: conducteursStator, rotor: conducteursRotor } = circuits(N);
    const fils = Object.fromEntries(
        Object.entries(couleurs).map(([nom, couleur]) => [
            nom,
            new THREE.MeshStandardMaterial({ color: couleur, metalness: 0.35, roughness: 0.45 }),
        ]),
    );

    // Le stator : les tôles, et dans chaque encoche le conducteur, qui
    // dépasse du paquet vers les têtes de bobines.
    const stator = new THREE.Group();
    // Les encoches occupent 70 % de l'écart entre les deux plus proches,
    // √2/N radian (cf. `répartis`).
    const lStator = Math.min(LARGEUR_MAX.stator, (0.7 * R_ALÉSAGE * Math.SQRT2) / N);
    const tôles = new THREE.Shape(Array.from({ length: 192 }, (_, k) => polaire(R_STATOR, (2 * Math.PI * k) / 192)));
    tôles.holes.push(contourEncoché(new THREE.Path(), conducteursStator, R_ALÉSAGE, R_FOND, lStator));
    stator.add(extrude(tôles, -LONGUEUR, 0, MATÉRIAUX.flanc, MATÉRIAUX.coupe));
    const rStator = (R_ALÉSAGE + R_FOND) / 2;
    // Les têtes des deux circuits se croisent : celles du circuit 2 passent
    // plus en arrière et plus au large.
    const têtes = { 1: { hauteur: 0.45, écart: 0.1 }, 2: { hauteur: 0.8, écart: 0.45 } };
    for (const c of conducteursStator) {
        c.rayon = rStator;
        stator.add(...encoche(c.angle, R_ALÉSAGE, R_FOND, lStator, fils[c.circuit], 0.25));
        if (c.via === undefined) continue;
        stator.add(
            têteDeBobine(c.angle, c.via, {
                r: rStator,
                z: -LONGUEUR - 0.25,
                épaisseur: RAYON_FIL.stator / N,
                matériau: fils[c.circuit],
                ...têtes[c.circuit],
            }),
        );
    }
    // Les balais, fixes, qui frottent sur les bagues du rotor.
    for (const z of [-LONGUEUR - 1.6, -LONGUEUR - 2.3]) {
        const balai = new THREE.Mesh(new THREE.BoxGeometry(0.3, 0.55, 0.26), MATÉRIAUX.balai);
        balai.position.set(0, 0.85 + 0.27, z);
        stator.add(balai);
    }

    // Le rotor : ses tôles, creusées d'encoches ouvertes sur l'entrefer.
    const rotor = new THREE.Group();
    const fond = R_ROTOR - PROFONDEUR_ROTOR;
    // Au rotor, deux conducteurs voisins sont à 2/N radian au moins (cf.
    // `positions`). Les dents s'amincissent vers l'axe : c'est au fond des
    // encoches qu'on mesure leur écart.
    const lRotor = Math.min(LARGEUR_MAX.rotor, (0.7 * fond * 2) / N);
    const profil = contourEncoché(new THREE.Shape(), conducteursRotor, R_ROTOR, fond, lRotor);
    profil.holes.push(new THREE.Path().absarc(0, 0, R_ARBRE, 0, 2 * Math.PI, true));
    // Les pôles couvrent jusqu'à 90° d'un seul arc : il leur faut plus de
    // segments.
    rotor.add(extrude(profil, -LONGUEUR, 0, MATÉRIAUX.flanc, MATÉRIAUX.coupe, 40));
    const rRotor = (R_ROTOR + fond) / 2;
    for (const c of conducteursRotor) {
        c.rayon = rRotor;
        rotor.add(...encoche(c.angle, fond, R_ROTOR, lRotor, fils.rotor, 0.2));
        if (c.via === undefined) continue;
        rotor.add(
            têteDeBobine(c.angle, c.via, {
                r: rRotor - 0.05,
                z: -LONGUEUR - 0.2,
                hauteur: 0.3,
                écart: -0.25,
                épaisseur: RAYON_FIL.rotor / N,
                matériau: fils.rotor,
            }),
        );
    }
    // L'arbre, et les deux bagues qui amènent le courant d'excitation.
    const arbre = new THREE.Mesh(new THREE.CylinderGeometry(R_ARBRE, R_ARBRE, LONGUEUR + 3.4, 40), MATÉRIAUX.arbre);
    arbre.rotation.x = Math.PI / 2;
    arbre.position.z = -(LONGUEUR + 3.4) / 2;
    rotor.add(arbre);
    for (const z of [-LONGUEUR - 1.6, -LONGUEUR - 2.3]) {
        const bague = new THREE.Mesh(new THREE.CylinderGeometry(0.85, 0.85, 0.35, 48), MATÉRIAUX.bague);
        bague.rotation.x = Math.PI / 2;
        bague.position.z = z;
        rotor.add(bague);
    }

    return {
        stator,
        rotor,
        conducteurs: { stator: conducteursStator, rotor: conducteursRotor },
        symboles: { stator: Math.min(0.13, 0.42 * lStator), rotor: Math.min(0.13, 0.42 * lRotor) },
        libère() {
            for (const groupe of [stator, rotor]) groupe.traverse((objet) => objet.geometry?.dispose());
            for (const fil of Object.values(fils)) fil.dispose();
        },
    };
}
