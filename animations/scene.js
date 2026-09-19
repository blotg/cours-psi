// Une scène three.js dans une page : rendu WebGL, étiquettes KaTeX par-dessus,
// caméra que l'on fait tourner à la souris ou au doigt.
//
// Le rendu ne se refait que lorsqu'il le faut — la caméra a bougé, un réglage
// a changé (`redessine`), ou la scène est animée (`àChaqueImage`) —, et
// s'arrête tant que la scène est hors de l'écran : une page en porte
// plusieurs, et un téléphone n'a pas de batterie à perdre.

import * as THREE from 'three';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import { CSS2DRenderer } from 'three/addons/renderers/CSS2DRenderer.js';

const créé = (balise, classe, texte = '') =>
    Object.assign(document.createElement(balise), { className: classe, textContent: texte });

export class Scène {
    /**
     * @param conteneur  l'élément qui reçoit la scène et sa barre
     * @param perspective  caméra perspective ; orthographique par défaut, qui
     *                     garde les longueurs d'un schéma
     * @param rapport  largeur / hauteur de la scène
     * @param taille  hauteur visible en orthographique, angle de champ (degrés)
     *                en perspective
     * @param position, cible, haut  la vue de départ
     * @param éclairage  l'intensité des lumières : une scène qui a ses propres
     *                   reflets (`scene.environment`) en demande moins
     */
    constructor(
        conteneur,
        {
            perspective = false,
            rapport = 4 / 3,
            taille = 10,
            position = [10, 4, 5],
            cible = [0, 0, 0],
            haut = [0, 0, 1],
            éclairage = 1,
        } = {},
    ) {
        this.rapport = rapport;
        this.taille = taille;
        this.départ = { position, cible };

        this.scène = new THREE.Scene();
        this.scène.background = new THREE.Color(0xffffff);
        this.caméra = perspective
            ? new THREE.PerspectiveCamera(taille, rapport, 0.1, 500)
            : new THREE.OrthographicCamera(-1, 1, 1, -1, -500, 500);
        this.caméra.up.set(...haut);
        this.scène.add(this.caméra);

        // Une lumière d'ambiance, et une autre qui suit la caméra : une face
        // tournée vers l'œil n'est jamais dans l'ombre.
        this.scène.add(new THREE.HemisphereLight(0xffffff, 0xb0b8c0, 1.8 * éclairage));
        const lampe = new THREE.DirectionalLight(0xffffff, 1.6 * éclairage);
        lampe.position.set(-3, 5, 10);
        this.caméra.add(lampe);

        const scène = créé('div', 'scène');
        this.rendu = new THREE.WebGLRenderer({ antialias: true });
        this.rendu.setPixelRatio(Math.min(window.devicePixelRatio, 2));
        this.étiquettes = new CSS2DRenderer();
        this.étiquettes.domElement.className = 'étiquettes';
        scène.append(this.rendu.domElement, this.étiquettes.domElement);

        const barre = créé('div', 'barre');
        barre.append(créé('span', 'aide', 'Glisser pour tourner, molette ou pincement pour zoomer.'));
        this.barre = barre;
        this.bouton('Vue de départ', () => this.vueDeDépart());
        conteneur.append(scène, barre);
        this.conteneur = scène;

        this.contrôles = new OrbitControls(this.caméra, this.rendu.domElement);
        this.contrôles.enableDamping = true;
        this.contrôles.dampingFactor = 0.15;
        this.contrôles.addEventListener('change', () => this.redessine());

        this.horloge = new THREE.Timer();
        this.vueDeDépart();
        new ResizeObserver(() => this.redimensionne()).observe(scène);
        new IntersectionObserver(([entrée]) => this.anime(entrée.isIntersecting)).observe(scène);
    }

    /** Un bouton de plus dans la barre sous la scène. */
    bouton(texte, action) {
        const bouton = créé('button', '', texte);
        bouton.type = 'button';
        bouton.addEventListener('click', action);
        this.barre.append(bouton);
        return bouton;
    }

    ajoute(...objets) {
        this.scène.add(...objets);
        this.redessine();
        return this;
    }

    /** `rappel(dt)` avant chaque image, dt en secondes : la scène est animée. */
    àChaqueImage(rappel) {
        this.rappel = rappel;
        this.redessine();
    }

    /** Un réglage a changé : il faudra refaire l'image. */
    redessine() {
        this.àRefaire = true;
    }

    vueDeDépart() {
        this.regarde(this.départ);
    }

    /** Place la caméra en `position`, tournée vers `cible` : deux triplets. */
    regarde({ position, cible }) {
        this.caméra.position.set(...position);
        this.contrôles.target.set(...cible);
        this.caméra.zoom = 1;
        this.caméra.updateProjectionMatrix();
        this.contrôles.update();
        this.redessine();
    }

    redimensionne() {
        const largeur = this.conteneur.clientWidth;
        if (!largeur) return;
        const hauteur = Math.round(largeur / this.rapport);
        this.rendu.setSize(largeur, hauteur);
        this.étiquettes.setSize(largeur, hauteur);
        this.dimensions = new THREE.Vector2(largeur, hauteur);
        if (this.caméra.isOrthographicCamera) {
            const h = this.taille / 2;
            Object.assign(this.caméra, { left: -h * this.rapport, right: h * this.rapport, top: h, bottom: -h });
        } else {
            this.caméra.aspect = this.rapport;
        }
        this.caméra.updateProjectionMatrix();
        this.redessine();
    }

    anime(visible) {
        // Le temps passé hors de l'écran ne compte pas.
        this.horloge.update();
        this.rendu.setAnimationLoop(visible ? (instant) => this.image(instant) : null);
    }

    image(instant) {
        const dt = Math.min(this.horloge.update(instant).getDelta(), 0.1);
        const bougé = this.contrôles.update();
        if (this.rappel) this.rappel(dt);
        if (!(this.rappel || bougé || this.àRefaire) || !this.dimensions) return;
        this.àRefaire = false;
        // L'épaisseur des traits (cf. `Trait`) se compte en pixels : il leur
        // faut la taille de l'image, y compris aux traits ajoutés depuis.
        this.scène.traverse((objet) => objet.material?.isLineMaterial && objet.material.resolution.copy(this.dimensions));
        this.rendu.render(this.scène, this.caméra);
        this.étiquettes.render(this.scène, this.caméra);
    }
}
