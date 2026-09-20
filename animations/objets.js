// Ce que dessinent les animations : étiquettes en LaTeX, flèches, traits,
// arcs d'angle, repère. Tout se place par des méthodes qu'on peut rappeler à
// chaque changement de réglage, sans rien recréer.
//
// Ce sont des tracés de schéma, de couleurs franches : ils échappent au
// rendu photographique (`toneMapped: false`) qu'une scène peut choisir pour
// ses objets réalistes.

import * as THREE from 'three';
import katex from 'katex';
import { Line2 } from 'three/addons/lines/Line2.js';
import { LineGeometry } from 'three/addons/lines/LineGeometry.js';
import { LineMaterial } from 'three/addons/lines/LineMaterial.js';
import { CSS2DObject } from 'three/addons/renderers/CSS2DRenderer.js';

/** La palette d'Okabe et Ito : des couleurs qui restent distinctes pour les
 *  daltoniens, et sur le papier blanc du site. Plus un violet, qui n'en est
 *  pas, pour une cinquième couleur vive. */
export const COULEURS = {
    noir: '#000000',
    gris: '#6b6b6b',
    grisClair: '#c8c8c8',
    vermillon: '#d55e00',
    bleu: '#0072b2',
    vert: '#009e73',
    pourpre: '#cc79a7',
    violet: '#8b44ac',
    orange: '#e69f00',
    ciel: '#56b4e9',
};

export const vecteur = (x = 0, y = 0, z = 0) => new THREE.Vector3(x, y, z);
export const ORIGINE = vecteur();
export const X = vecteur(1, 0, 0);
export const Y = vecteur(0, 1, 0);
export const Z = vecteur(0, 0, 1);

/** Écrit `tex` dans `élément` avec KaTeX. */
export function écritTex(élément, tex) {
    katex.render(tex, élément, { throwOnError: false });
    return élément;
}

/**
 * Une étiquette en LaTeX, centrée sur un point de la scène — ou décalée de
 * `décalage` à l'écran (une longueur CSS en x et en y, « -0.8em -0.4em ») :
 * ce qui l'entoure dans l'espace peut venir la couvrir sous certains angles.
 *
 * Une étiquette est du HTML posé sur l'image : rien ne la cache. Celle qui
 * nomme ce qui est dessiné sur une face se donne la normale de cette face
 * (`face`, dans le repère de son parent) : vue de derrière, elle s'efface.
 */
export class Étiquette extends CSS2DObject {
    constructor(tex = '', { couleur = COULEURS.noir, taille = '1.1rem', décalage = '', face = null } = {}) {
        const div = document.createElement('div');
        div.className = 'étiquette';
        div.style.color = couleur;
        div.style.fontSize = taille;
        div.style.translate = décalage;
        super(div);
        this.face = face;
        this.écrit(tex);
    }

    écrit(tex) {
        if (tex !== this.tex) écritTex(this.element, (this.tex = tex));
        return this;
    }

    place(position) {
        this.position.copy(position);
        this.candidats = null;
        return this;
    }

    /** Sa couleur, quand ce qu'elle nomme change de rôle avec un réglage. */
    couleur(couleur) {
        this.element.style.color = couleur;
        return this;
    }

    /**
     * À côté d'un segment, du côté opposé à `loin` : la cote d'une arête,
     * hors de la figure. Parmi les `segments` [a, b] candidats, c'est celui
     * qui s'écarte le plus de `loin` à l'écran qui la porte — une arête du
     * contour. Le choix et le côté se refont à chaque image, puisqu'ils
     * dépendent de la vue.
     */
    àCôté(segments, loin, écart = 5) {
        this.candidats = segments.map(([a, b]) => [a.clone(), b.clone()]);
        this.loin = loin.clone();
        this.écart = écart;
        // Le point d'attache ; le déplacement jusqu'au segment choisi se fait
        // à l'écran : three.js a déjà situé l'étiquette quand il nous appelle.
        this.position.copy(segments[0][0]).add(segments[0][1]).multiplyScalar(0.5);
        return this;
    }

    onBeforeRender(rendu, scène, caméra) {
        if (this.face) {
            const ici = new THREE.Vector3().setFromMatrixPosition(this.matrixWorld);
            const normale = this.face.clone().transformDirection(this.parent.matrixWorld);
            if (normale.dot(caméra.position.clone().sub(ici)) < 0) this.element.style.display = 'none';
        }
        if (!this.candidats) return;
        const { width, height } = rendu.getSize();
        // En pixels, y vers le bas comme en CSS.
        const écran = (p) => {
            const q = p.clone().project(caméra);
            return new THREE.Vector2(((q.x + 1) * width) / 2, ((1 - q.y) * height) / 2);
        };
        const loin = écran(this.loin);
        const milieu = ([a, b]) => a.clone().add(b).multiplyScalar(0.5);
        const [a, b] = this.candidats
            .map((segment) => segment.map(écran))
            .reduce((m, s) => (milieu(s).distanceTo(loin) > milieu(m).distanceTo(loin) ? s : m));
        const centre = milieu([a, b]);
        const normale = new THREE.Vector2(a.y - b.y, b.x - a.x).normalize();
        if (normale.dot(loin.clone().sub(centre)) > 0) normale.negate();
        // Jusqu'au bord de l'étiquette, qui est centrée sur le point.
        const demi = (Math.abs(normale.x) * this.element.offsetWidth + Math.abs(normale.y) * this.element.offsetHeight) / 2;
        const attache = écran(new THREE.Vector3().setFromMatrixPosition(this.matrixWorld));
        const décalage = centre.sub(attache).addScaledVector(normale, demi + this.écart);
        this.element.style.translate = `${décalage.x}px ${décalage.y}px`;
    }
}

// Une flèche est un cylindre et un cône de hauteur 1, mis à l'échelle : on
// partage donc leurs géométries, et leurs matériaux par couleur.
const TIGE = new THREE.CylinderGeometry(1, 1, 1, 12).translate(0, 0.5, 0);
const POINTE = new THREE.ConeGeometry(1, 1, 20).translate(0, 0.5, 0);
const matériaux = new Map();

function matériauUni(couleur, dessus) {
    const clé = `${couleur}${dessus}`;
    if (!matériaux.has(clé)) {
        matériaux.set(clé, new THREE.MeshBasicMaterial({ color: couleur, depthTest: !dessus, toneMapped: false }));
    }
    return matériaux.get(clé);
}

/**
 * Une flèche pleine, d'un ton uni, comme sur un schéma. `dessus` la dessine
 * par-dessus le reste de la scène, même cachée derrière.
 */
export class Flèche extends THREE.Group {
    constructor({ couleur = COULEURS.noir, rayon = 0.025, tête = 0.24, largeur = 0.085, dessus = false } = {}) {
        super();
        Object.assign(this, { rayon, tête, largeur, dessus });
        const matériau = matériauUni(couleur, dessus);
        this.tige = new THREE.Mesh(TIGE, matériau);
        this.pointe = new THREE.Mesh(POINTE, matériau);
        if (dessus) this.tige.renderOrder = this.pointe.renderOrder = 10;
        this.add(this.tige, this.pointe);
    }

    /** Sa couleur, quand son rôle change avec un réglage. Les matériaux étant
     *  partagés par couleur, elle en prend un autre plutôt que de teindre
     *  celui qu'elle a — qui est aussi celui des autres. */
    couleur(couleur) {
        this.tige.material = this.pointe.material = matériauUni(couleur, this.dessus);
        return this;
    }

    /** De `origine`, dans la direction `direction`, sur `longueur`. */
    place(origine, direction, longueur) {
        this.visible = longueur > 1e-4;
        if (!this.visible) return this;
        this.position.copy(origine);
        this.quaternion.setFromUnitVectors(Y, direction.clone().normalize());
        // Une flèche courte garde une pointe à sa mesure.
        const tête = Math.min(this.tête, 0.5 * longueur);
        const largeur = (this.largeur * tête) / this.tête;
        this.tige.scale.set(this.rayon, longueur - tête, this.rayon);
        this.pointe.scale.set(largeur, tête, largeur);
        this.pointe.position.y = longueur - tête;
        return this;
    }
}

/**
 * Un trait, plein ou en pointillés, d'une épaisseur en pixels — WebGL ne sait
 * tracer ses lignes qu'à un pixel. `trace` le refait sur place : recréer ses
 * tampons à chaque réglage les laisserait s'accumuler dans la carte graphique.
 */
export class Trait extends Line2 {
    constructor({ couleur = COULEURS.noir, épaisseur = 2, pointillés = false, tiret = 0.12 } = {}) {
        super(
            new LineGeometry(),
            new LineMaterial({
                color: couleur,
                linewidth: épaisseur,
                dashed: pointillés,
                dashSize: tiret,
                gapSize: 0.7 * tiret,
                // Un trait épais est un ruban tourné vers l'œil, et un ruban
                // a un endroit : sous une matrice qui retourne l'espace — la
                // symétrie par un plan —, il serait présenté par l'envers, et
                // le rendu l'écarterait. Un trait n'a pas d'envers.
                side: THREE.DoubleSide,
                toneMapped: false,
            }),
        );
    }

    /** Relie les points donnés, dans l'ordre. */
    trace(points) {
        const segments = points.length - 1;
        if (this.geometry.attributes.instanceStart?.count !== segments) {
            this.geometry.dispose();
            this.geometry = new LineGeometry().setPositions(new Float32Array(3 * points.length));
            if (this.material.dashed) this.computeLineDistances();
        }
        const tampon = this.geometry.attributes.instanceStart.data;
        for (let i = 0; i < segments; i++) {
            points[i].toArray(tampon.array, 6 * i);
            points[i + 1].toArray(tampon.array, 6 * i + 3);
        }
        tampon.needsUpdate = true;
        if (this.material.dashed) {
            const distances = this.geometry.attributes.instanceDistanceStart.data;
            let cumul = 0;
            for (let i = 0; i < segments; i++) {
                distances.array[2 * i] = cumul;
                cumul += points[i].distanceTo(points[i + 1]);
                distances.array[2 * i + 1] = cumul;
            }
            distances.needsUpdate = true;
        }
        this.geometry.computeBoundingSphere();
        return this;
    }
}

/** Un petit point plein. */
export function point(couleur = COULEURS.noir, rayon = 0.07) {
    return new THREE.Mesh(
        new THREE.SphereGeometry(rayon, 24, 16),
        new THREE.MeshBasicMaterial({ color: couleur, toneMapped: false }),
    );
}

/**
 * Un arc d'angle orienté, avec sa pointe et son nom : de la direction `u` à
 * la direction qui fait l'angle `angle` avec elle, en tournant vers `v`.
 */
export class Arc extends THREE.Group {
    constructor(tex = '', { couleur = COULEURS.noir, épaisseur = 2, segments = 48, face = null } = {}) {
        super();
        this.segments = segments;
        this.trait = new Trait({ couleur, épaisseur });
        this.pointe = new Flèche({ couleur, largeur: 0.07, tête: 0.18 });
        this.étiquette = new Étiquette(tex, { couleur, face });
        this.add(this.trait, this.pointe, this.étiquette);
    }

    /** `u` et `v` unitaires et orthogonaux ; `angle` en radians. */
    place(centre, u, v, angle, rayon) {
        const sur = (t, r = rayon) =>
            centre.clone().addScaledVector(u, r * Math.cos(t)).addScaledVector(v, r * Math.sin(t));
        this.visible = Math.abs(angle) > 1e-3;
        if (!this.visible) return this;
        this.trait.trace(Array.from({ length: this.segments + 1 }, (_, i) => sur((angle * i) / this.segments)));
        // La pointe finit sur l'arc, tangente à lui.
        const sens = Math.sign(angle);
        const tangente = u.clone().multiplyScalar(-Math.sin(angle) * sens).addScaledVector(v, Math.cos(angle) * sens);
        const tête = Math.min(0.18, 0.5 * Math.abs(angle) * rayon);
        this.pointe.place(sur(angle).addScaledVector(tangente, -tête), tangente, tête);
        this.étiquette.place(sur(angle / 2, rayon + 0.3));
        return this;
    }
}

/** Le repère (O, x, y, z) : trois axes fléchés et leurs noms. */
export function repère(longueur = 5, noms = ['x', 'y', 'z'], couleur = COULEURS.noir) {
    const groupe = new THREE.Group();
    [X, Y, Z].forEach((axe, i) => {
        groupe.add(new Flèche({ couleur, rayon: 0.014, largeur: 0.07, tête: 0.22 }).place(ORIGINE, axe, longueur));
        groupe.add(new Étiquette(noms[i], { couleur }).place(axe.clone().multiplyScalar(longueur + 0.35)));
    });
    groupe.add(new Étiquette('O', { couleur }).place(vecteur(-0.25, -0.25, -0.25)));
    return groupe;
}

/** Un quadrillage discret du plan (O x y), qui aide l'œil à situer la profondeur. */
export function quadrillage(taille = 10, divisions = 10) {
    const grille = new THREE.GridHelper(taille, divisions, 0xd9d9d9, 0xececec);
    grille.rotation.x = Math.PI / 2;
    return grille;
}
