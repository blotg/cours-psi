// Une scène three.js dans une page : rendu WebGL, étiquettes KaTeX par-dessus,
// caméra que l'on fait tourner à la souris ou au doigt.
//
// Le rendu ne se refait que lorsqu'il le faut — la caméra a bougé, un réglage
// a changé (`redessine`), ou la scène est animée (`àChaqueImage`) —, et
// seulement quand la scène est à l'écran : une page en porte plusieurs, et
// un téléphone n'a pas de batterie à perdre. Une animation, elle, continue
// tant que son cadre est à l'écran : sur un téléphone, ses réglages et ses
// courbes sont sous la scène, et doivent suivre quand on y descend.

import * as THREE from 'three';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import { CSS2DRenderer } from 'three/addons/renderers/CSS2DRenderer.js';

const créé = (balise, classe, texte = '') =>
    Object.assign(document.createElement(balise), { className: classe, textContent: texte });

/** Le viseur qui dit où le pointeur tombe dans la scène : un seul suffit. */
const viseur = new THREE.Raycaster();

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
        this.modeDEmploi = créé('span', 'aide', 'Glisser pour tourner, molette ou pincement pour zoomer.');
        barre.append(this.modeDEmploi);
        this.barre = barre;
        this.bouton('Vue de départ', () => this.vueDeDépart());
        conteneur.append(scène, barre);
        this.conteneur = scène;

        this.contrôles = new OrbitControls(this.caméra, this.rendu.domElement);
        this.contrôles.enableDamping = true;
        this.contrôles.dampingFactor = 0.15;
        this.contrôles.addEventListener('change', () => this.redessine());

        // Les poignées passent avant les contrôles : leurs écouteurs sont
        // posés sur le cadre, en capture, et arrêtent l'événement avant qu'il
        // n'atteigne le canevas où `OrbitControls` attend le sien.
        this.poignées = [];
        this.attrapée = null;
        scène.addEventListener('pointerdown', (e) => this.attrape(e), true);
        scène.addEventListener('pointermove', (e) => this.déplace(e), true);
        for (const fin of ['pointerup', 'pointercancel']) {
            scène.addEventListener(fin, (e) => this.lâche(e), true);
        }

        this.horloge = new THREE.Timer();
        this.vueDeDépart();
        new ResizeObserver(() => this.redimensionne()).observe(scène);
        new IntersectionObserver(([entrée]) => {
            this.àLÉcran = entrée.isIntersecting;
            this.redessine();
        }).observe(scène);
        const cadre = conteneur.closest('.corps') ?? scène;
        new IntersectionObserver(([entrée]) => this.anime(entrée.isIntersecting)).observe(cadre);
    }

    /** Un bouton de plus dans la barre sous la scène. */
    bouton(texte, action) {
        const bouton = créé('button', '', texte);
        bouton.type = 'button';
        bouton.addEventListener('click', action);
        this.barre.append(bouton);
        return bouton;
    }

    /** Le mode d'emploi, à gauche dans la barre : une scène qui se manipule
     *  autrement le dit à sa façon. */
    aide(texte) {
        this.modeDEmploi.textContent = texte;
        return this;
    }

    ajoute(...objets) {
        this.scène.add(...objets);
        this.redessine();
        return this;
    }

    retire(...objets) {
        this.scène.remove(...objets);
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

    // -- Poignées ---------------------------------------------------------
    //
    // Un point de la scène que l'on attrape et que l'on déplace du doigt ou
    // de la souris. L'espace a trois dimensions et le pointeur deux : c'est
    // la vue qui tranche, et le point glisse dans le plan de l'écran qui le
    // porte. D'où l'intérêt des vues toutes faites (`regarde`), qui rendent
    // le geste prévisible — de face, le point reste dans le plan de face.

    /**
     * `position()` dit où est la poignée ; `auDéplacement(p)` reçoit sa
     * nouvelle place, à la charge de l'animation de la retenir et de la
     * borner. `rayon` est la portée de la prise, en pixels.
     */
    poignée({ position, rayon = 20, auDéplacement }) {
        const poignée = { position, rayon, auDéplacement };
        this.poignées.push(poignée);
        return poignée;
    }

    /** Où un point de la scène se projette dans la vue, en pixels. */
    pixels(p) {
        const { x: largeur = 0, y: hauteur = 0 } = this.dimensions ?? {};
        const q = p.clone().project(this.caméra);
        return new THREE.Vector2(((q.x + 1) * largeur) / 2, ((1 - q.y) * hauteur) / 2);
    }

    /** La poignée sous le pointeur, la plus proche s'il y en a plusieurs. */
    sous(e) {
        const cadre = this.conteneur.getBoundingClientRect();
        const pointeur = new THREE.Vector2(e.clientX - cadre.left, e.clientY - cadre.top);
        let trouvée = null;
        let meilleure = Infinity;
        for (const poignée of this.poignées) {
            const distance = this.pixels(poignée.position()).distanceTo(pointeur);
            if (distance < poignée.rayon && distance < meilleure) {
                meilleure = distance;
                trouvée = poignée;
            }
        }
        return trouvée;
    }

    /** Le point du plan de saisie que vise le pointeur. */
    vise(e) {
        const cadre = this.conteneur.getBoundingClientRect();
        viseur.setFromCamera(
            new THREE.Vector2(
                ((e.clientX - cadre.left) / cadre.width) * 2 - 1,
                -((e.clientY - cadre.top) / cadre.height) * 2 + 1,
            ),
            this.caméra,
        );
        return viseur.ray.intersectPlane(this.planDeSaisie, new THREE.Vector3());
    }

    attrape(e) {
        const poignée = this.sous(e);
        if (!poignée) return;
        this.attrapée = poignée;
        // Le plan de l'écran qui passe par la poignée, et l'écart entre elle
        // et le pointeur : sans lui, elle sauterait sous le doigt.
        const ici = poignée.position().clone();
        this.planDeSaisie = new THREE.Plane().setFromNormalAndCoplanarPoint(
            this.caméra.getWorldDirection(new THREE.Vector3()),
            ici,
        );
        this.écart = ici.sub(this.vise(e) ?? ici);
        this.conteneur.style.cursor = 'grabbing';
        // Suivre le pointeur même s'il sort de la vue ; un navigateur refuse
        // la prise s'il ne connaît plus ce pointeur, et ce n'est pas grave.
        try {
            this.conteneur.setPointerCapture(e.pointerId);
        } catch {
            /* on continue sans capture */
        }
        // Que les contrôles n'en sachent rien : le geste est pour la poignée.
        this.contrôles.enabled = false;
        e.preventDefault();
        e.stopPropagation();
    }

    déplace(e) {
        if (!this.attrapée) {
            this.conteneur.style.cursor = this.sous(e) ? 'grab' : '';
            return;
        }
        const point = this.vise(e);
        if (point) this.attrapée.auDéplacement?.(point.add(this.écart));
        this.redessine();
        e.preventDefault();
        e.stopPropagation();
    }

    lâche(e) {
        if (!this.attrapée) return;
        this.attrapée = null;
        this.contrôles.enabled = true;
        this.conteneur.style.cursor = '';
        try {
            this.conteneur.releasePointerCapture(e.pointerId);
        } catch {
            /* la prise n'avait pas été accordée */
        }
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
        if (!(this.rappel || bougé || this.àRefaire) || !this.dimensions || !this.àLÉcran) return;
        this.àRefaire = false;
        // L'épaisseur des traits (cf. `Trait`) se compte en pixels : il leur
        // faut la taille de l'image, y compris aux traits ajoutés depuis.
        this.scène.traverse((objet) => objet.material?.isLineMaterial && objet.material.resolution.copy(this.dimensions));
        this.rendu.render(this.scène, this.caméra);
        this.étiquettes.render(this.scène, this.caméra);
    }
}
