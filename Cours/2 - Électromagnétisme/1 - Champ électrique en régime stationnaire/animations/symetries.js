// Invariances et symétries d'une distribution de charges : les deux gestes
// du chapitre, que la figure du tableau réduit à un trait.
//
// Les deux scènes sont celles de `#animations/distributions.js`, que le
// chapitre sur le champ magnétique reprend avec des courants. Ne sont ici
// que les charges : six distributions, uniformément chargées et positives,
// plus deux charges opposées pour l'antisymétrie, que rien d'autre ne
// montre. Leur couleur dit le signe de la charge.

import * as THREE from 'three';
import { Étiquette, vecteur, ORIGINE, Z } from '#animations/objets.js';
import { lance } from '#animations/page.js';
import {
    DEMI_ÉCART,
    LONGUEUR_FIL,
    RAYON_BOULE,
    RAYON_SPIRE,
    cercleDePoints,
    couleurDe,
    groupe,
    invariances,
    matière,
    nappe,
    ossature,
    ossatureDeNappe,
    poseLaNappe,
    symétries,
    tige,
    unCercle,
    uneDroite,
    unPlan,
    unPoint,
    uneSphère,
} from '#animations/distributions.js';

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
        dessine: (fantôme) => (fantôme ? ossatureDeNappe() : nappe()),
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
                          matière(couleurDe(1), false),
                      ),
                  ),
    },
    doublet: {
        nom: '\\text{2 charges}',
        formes: DOUBLET,
        dessine: (fantôme) => groupe(...DOUBLET.map(({ p, q }) => bille(p, q, fantôme))),
    },
};

const ANIMATIONS = { invariances, symetries: symétries };

lance('section.animation', (section) =>
    ANIMATIONS[section.dataset.animation](section, { distributions: DISTRIBUTIONS, champ: 'E' }),
);
