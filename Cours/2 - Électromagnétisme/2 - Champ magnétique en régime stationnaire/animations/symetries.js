// Invariances et symétries d'une distribution de courant : les scènes du
// chapitre précédent (`#animations/distributions.js`), avec des courants au
// lieu de charges.
//
// Deux différences, qui sont tout le chapitre :
//
//   - une distribution de courant a un sens, que des pointes donnent à voir.
//     Un plan d'antisymétrie ne change pas la couleur de la distribution,
//     comme il le faisait des charges : il retourne ses pointes ;
//   - le champ magnétique est un pseudo-vecteur, orthogonal aux plans de
//     symétrie et contenu dans les plans d'antisymétrie. Une case montre le
//     champ en M et son reflet dans le plan : dans un plan de symétrie, ce
//     reflet est l'opposé du champ, alors que la distribution n'a pas changé.

import * as THREE from 'three';
import { vecteur, ORIGINE, X, Z } from '#animations/objets.js';
import { lance } from '#animations/page.js';
import {
    COULEUR,
    DEMI_ÉCART,
    LONGUEUR_FIL,
    RAYON_SPIRE,
    cercleDePoints,
    groupe,
    invariances,
    matière,
    nappe,
    ossature,
    ossatureDeNappe,
    poseLaNappe,
    symétries,
    tige,
    unFil,
    uneNappe,
    unSolénoïde,
    uneSpire,
    unTore,
} from '#animations/distributions.js';
import { champDUneSpire } from './champ.js';

const RAYON_SOLÉNOÏDE = 1.6;
const TORE = { rayon: 2.4, tube: 0.75 };

/** La surface d'un solénoïde ou d'un tore, que l'on voit au travers : les
 *  pointes du courant sont dessus, et le point M peut être dedans. */
const peau = () =>
    new THREE.MeshLambertMaterial({
        color: COULEUR.positive,
        transparent: true,
        opacity: 0.3,
        side: THREE.DoubleSide,
        depthWrite: false,
    });

/** Un fil parallèle à (Ox), à la cote z : la tige de (Oz), couchée. */
function tigeCouchée(z) {
    const t = tige();
    t.rotation.y = Math.PI / 2;
    t.position.z = z;
    return t;
}

/** Les angles de 45° en 45°, décalés d'un demi-pas. */
const HUIT = Array.from({ length: 8 }, (_, k) => ((k + 0.5) * Math.PI) / 4);

/** L'ossature d'un solénoïde : des génératrices, et quelques cercles. */
function ossatureDeSolénoïde() {
    const demi = LONGUEUR_FIL / 2;
    const génératrices = HUIT.map((α) => {
        const [x, y] = [RAYON_SOLÉNOÏDE * Math.cos(α), RAYON_SOLÉNOÏDE * Math.sin(α)];
        return [vecteur(x, y, -demi), vecteur(x, y, demi)];
    });
    const cercles = [-4, -2, 0, 2, 4].map((z) => cercleDePoints(RAYON_SOLÉNOÏDE).map((p) => p.setZ(z)));
    return ossature(...génératrices, ...cercles);
}

/** L'ossature d'un tore : des cercles méridiens, et les équateurs. */
function ossatureDeTore() {
    const { rayon, tube } = TORE;
    const méridiens = HUIT.map((α) =>
        Array.from({ length: 37 }, (_, i) => {
            const β = (2 * Math.PI * i) / 36;
            const r = rayon + tube * Math.cos(β);
            return vecteur(r * Math.cos(α), r * Math.sin(α), tube * Math.sin(β));
        }),
    );
    const équateurs = [
        cercleDePoints(rayon + tube),
        cercleDePoints(rayon - tube),
        cercleDePoints(rayon).map((p) => p.setZ(tube)),
        cercleDePoints(rayon).map((p) => p.setZ(-tube)),
    ];
    return ossature(...méridiens, ...équateurs);
}

const DEUX_FILS = [unFil(vecteur(0, 0, DEMI_ÉCART), X, 1), unFil(vecteur(0, 0, -DEMI_ÉCART), X, -1)];

/**
 * Les distributions proposées : celles du cours et des méthodes. Les deux
 * fils parcourus en sens inverses sont là pour l'antisymétrie, comme les
 * deux charges opposées l'étaient ; couchés selon (Ox), leur plan médiateur
 * est (O x y), où M se pose de lui-même.
 */
const DISTRIBUTIONS = {
    fil: {
        nom: '\\text{Fil}',
        formes: [unFil(ORIGINE, Z)],
        dessine: (fantôme) =>
            fantôme
                ? ossature([Z.clone().multiplyScalar(-LONGUEUR_FIL / 2), Z.clone().multiplyScalar(LONGUEUR_FIL / 2)])
                : tige(),
    },
    spire: {
        nom: '\\text{Spire}',
        formes: [uneSpire(ORIGINE, Z, RAYON_SPIRE)],
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
    solénoïde: {
        nom: '\\text{Solénoïde}',
        formes: [unSolénoïde(ORIGINE, Z, RAYON_SOLÉNOÏDE)],
        dessine: (fantôme) =>
            fantôme
                ? ossatureDeSolénoïde()
                : groupe(
                      new THREE.Mesh(
                          new THREE.CylinderGeometry(RAYON_SOLÉNOÏDE, RAYON_SOLÉNOÏDE, LONGUEUR_FIL, 64, 1, true).rotateX(
                              Math.PI / 2,
                          ),
                          peau(),
                      ),
                  ),
    },
    tore: {
        nom: '\\text{Tore}',
        formes: [unTore(ORIGINE, Z, TORE.rayon, TORE.tube)],
        dessine: (fantôme) =>
            fantôme
                ? ossatureDeTore()
                : groupe(new THREE.Mesh(new THREE.TorusGeometry(TORE.rayon, TORE.tube, 32, 96), peau())),
    },
    nappe: {
        nom: '\\text{Nappe}',
        formes: [uneNappe(ORIGINE, Z, X)],
        dessine: (fantôme) => (fantôme ? ossatureDeNappe() : nappe()),
        réajuste: poseLaNappe,
    },
    fils: {
        nom: '\\text{2 fils}',
        formes: DEUX_FILS,
        dessine: (fantôme) =>
            fantôme
                ? ossature(
                      ...[DEMI_ÉCART, -DEMI_ÉCART].map((z) => [
                          vecteur(-LONGUEUR_FIL / 2, 0, z),
                          vecteur(LONGUEUR_FIL / 2, 0, z),
                      ]),
                  )
                : groupe(tigeCouchée(DEMI_ÉCART), tigeCouchée(-DEMI_ÉCART)),
    },
};

/** Le champ d'un fil parcouru par I = ±1 selon `u`, passant par `p`, au
 *  point M — à un facteur μ₀/2π près, qui n'importe pas ici. */
function champDUnFil(p, u, I, M) {
    const d = M.clone().sub(p);
    d.addScaledVector(u, -d.dot(u));
    const r2 = d.lengthSq();
    return r2 < 1e-6 ? vecteur() : u.clone().cross(d).multiplyScalar(I / r2);
}

/**
 * Le champ en M de chaque distribution, dans le sens que donnent ses
 * pointes. Seule sa direction se dessine : les facteurs constants sont
 * omis. Il est nul là où le cours l'établit — hors du solénoïde, hors du
 * tore —, et sur une nappe, où il change de sens.
 */
const CHAMPS = {
    fil: (M) => champDUnFil(ORIGINE, Z, 1, M),
    spire: (M) => {
        const ρ = Math.hypot(M.x, M.y);
        const [br, bz] = champDUneSpire(RAYON_SPIRE, ρ, M.z);
        const er = ρ > 1e-9 ? vecteur(M.x / ρ, M.y / ρ, 0) : vecteur();
        return er.multiplyScalar(br).add(vecteur(0, 0, bz));
    },
    solénoïde: (M) => (Math.hypot(M.x, M.y) < RAYON_SOLÉNOÏDE ? Z.clone() : vecteur()),
    tore: (M) => {
        const ρ = Math.hypot(M.x, M.y);
        const dedans = (ρ - TORE.rayon) ** 2 + M.z ** 2 < TORE.tube ** 2;
        return dedans ? vecteur(-M.y, M.x, 0).divideScalar(ρ * ρ) : vecteur();
    },
    nappe: (M) => vecteur(0, -Math.sign(M.z), 0),
    fils: (M) => DEUX_FILS.reduce((B, { p, o, q }) => B.add(champDUnFil(p, o, q, M)), vecteur()),
};

const ANIMATIONS = { invariances, symetries: symétries };

lance('section.animation', (section) =>
    ANIMATIONS[section.dataset.animation](section, {
        distributions: DISTRIBUTIONS,
        champ: 'B',
        pseudo: true,
        champEn: (clé, M) => CHAMPS[clé](M),
    }),
);
