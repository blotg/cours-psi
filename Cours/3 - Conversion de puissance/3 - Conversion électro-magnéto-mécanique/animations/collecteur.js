// Le système balais-collecteurs d'une machine à courant continu bipolaire.
//
// Le stator (l'inducteur) a deux pôles saillants, entourés de leurs bobines
// parcourues par le courant continu I_e : sous les pôles, le champ
// statorique B_s est radial, sortant du rotor à droite, y rentrant à gauche.
//
// Le rotor (l'induit) porte M bobines indépendantes d'une seule spire, dont
// les deux conducteurs sont diamétralement opposés : 2M encoches, et 2M lames
// au collecteur, chacune reliée à un conducteur par une barre radiale. Les
// balais, fixes, sont sur l'axe des pôles : le balai + touche la lame la plus
// proche de lui, et le courant ne passe que dans la bobine de cette lame. Le
// champ rotorique B_r reste ainsi à peu près perpendiculaire à B_s : l'angle
// α entre eux reste à moins de 90°/M de 90°, et le couple garde son signe.
//
// Le collecteur est dessiné devant le rotor, comme si l'on regardait la
// machine par le côté du collecteur, dont on aurait ôté le flasque.
//
// Une seconde animation alimente le moteur sous tension constante et lui
// donne une charge à entraîner : sa vitesse baisse quand le couple résistant
// augmente, jusqu'à l'arrêt.

import * as THREE from 'three';
import { Graphe } from '#animations/graphe.js';
import { Arc, COULEURS, Étiquette, Flèche, Trait, vecteur } from '#animations/objets.js';
import { cadre, lance } from '#animations/page.js';
import { Réglages } from '#animations/reglages.js';
import { COULEUR_CHARGE, chronogramme, fraction, tourne, virgule } from './charge.js';
import {
    Courant,
    LONGUEUR,
    MATÉRIAUX,
    angleSigné,
    contourEncoché,
    encoche,
    extrude,
    scèneDeMachine,
    têteDeBobine,
} from './machine.js';

const COULEUR = {
    inducteur: '#1e9a3c',
    // La bobine qui conduit, celle de la machine synchrone ; les autres, d'un
    // cuivre éteint qui ne s'en distingue pas qu'au ton.
    active: COULEURS.vermillon,
    éteinte: '#a59d94',
    Bs: COULEURS.violet,
    Br: COULEURS.orange,
    force: COULEURS.noir,
};

const DEUX_PI = 2 * Math.PI;
const deg = THREE.MathUtils.degToRad;
const direction = (a) => vecteur(Math.cos(a), Math.sin(a), 0);
const polaire = (r, a) => new THREE.Vector2(r * Math.cos(a), r * Math.sin(a));

// -- Dimensions (unités arbitraires) -------------------------------------------

const R_ARBRE = 0.42;
const R_ROTOR = 2.6;
const FOND = 1.95; // le fond des encoches du rotor
const R_ALÉSAGE = 2.72; // la face des pôles, concentrique au rotor
const R_ENTREFER = (R_ROTOR + R_ALÉSAGE) / 2;
const R_CORNE = 3.25; // le dos des épanouissements polaires
const DEMI_ARC = deg(55); // la demi-ouverture d'un pôle
const DEMI_NOYAU = 0.8; // la demi-largeur du noyau d'un pôle
const R_CULASSE = 4.15;
const R_STATOR = 4.9;
/** Une bobine inductrice, de chaque côté du noyau, dans le repère du pôle. */
const BOBINE_INDUCTRICE = { x: [3.32, 3.78], y: [0.88, 1.45] };
/** Le collecteur : ses lames, entre deux rayons, et sa longueur sur l'arbre. */
const COLLECTEUR = { r: [0.62, 0.95], z: [0.22, 1.08] };
const BALAI = { radial: 0.55, largeur: 0.34, z: [0.5, 0.95] };

/** Le centre d'une encoche du rotor : là que se posent les symboles. */
const R_CONDUCTEUR = (FOND + R_ROTOR) / 2;
const Z_SCHÉMA = 0.03;
const DEVANT = vecteur(0, 0, 1);
const FLÈCHES = 36;
const LONGUEUR_MAX = 0.85;
const M_DÉPART = 4;

/** Les axes des champs et les arcs des couples se dessinent devant le
 *  collecteur. */
const Z_AXES = 1.3;

const VUE = { taille: 10.8, troisQuarts: { position: [11, 12, 22], cible: [0, 0, -0.8] } };

/**
 * Le champ statorique dans l'entrefer, rapporté à sa valeur sous les pôles :
 * uniforme sous un pôle, il s'éteint entre eux, où l'entrefer s'ouvre.
 * Positif (sortant du rotor) à droite, sous le pôle sud.
 */
function champStatorique(θ) {
    const c = Math.cos(θ);
    const sous = Math.cos(DEMI_ARC - deg(3));
    const loin = Math.cos(deg(78));
    return Math.sign(c) * THREE.MathUtils.clamp((Math.abs(c) - loin) / (sous - loin), 0, 1);
}

// -- Le stator ------------------------------------------------------------------

/** Le bord de l'alésage autour d'un pôle d'axe `c`, dans le sens
 *  trigonométrique : le flanc du noyau, la corne, la face polaire, l'autre
 *  corne, l'autre flanc. */
function contourDuPôle(c) {
    const points = [];
    const arc = (r, de, à, n = 24) => {
        for (let k = 0; k <= n; k++) points.push(polaire(r, c + de + ((à - de) * k) / n));
    };
    const flanc = (r, côté) =>
        new THREE.Vector2(Math.sqrt(r * r - DEMI_NOYAU ** 2), côté * DEMI_NOYAU).rotateAround(
            new THREE.Vector2(),
            c,
        );
    const corne = Math.asin(DEMI_NOYAU / R_CORNE);
    points.push(flanc(R_CULASSE, -1), flanc(R_CORNE, -1));
    arc(R_CORNE, -corne, -DEMI_ARC, 12);
    arc(R_ALÉSAGE, -DEMI_ARC, DEMI_ARC, 48);
    arc(R_CORNE, DEMI_ARC, corne, 12);
    points.push(flanc(R_CORNE, 1), flanc(R_CULASSE, 1));
    return points;
}

function stator() {
    const groupe = new THREE.Group();
    const tôles = new THREE.Shape(Array.from({ length: 192 }, (_, k) => polaire(R_STATOR, (DEUX_PI * k) / 192)));
    // L'alésage : les deux pôles, reliés par la culasse.
    const bord = Math.asin(DEMI_NOYAU / R_CULASSE);
    const alésage = [];
    for (const c of [0, Math.PI]) {
        alésage.push(...contourDuPôle(c));
        for (let k = 1; k < 48; k++) alésage.push(polaire(R_CULASSE, c + bord + ((Math.PI - 2 * bord) * k) / 48));
    }
    tôles.holes.push(new THREE.Path(alésage));
    groupe.add(extrude(tôles, -LONGUEUR, 0, MATÉRIAUX.flanc, MATÉRIAUX.coupe));

    // Les bobines inductrices, de part et d'autre de chaque noyau, et leurs
    // têtes, qui passent derrière le pôle.
    const cuivre = new THREE.MeshStandardMaterial({ color: COULEUR.inducteur, metalness: 0.35, roughness: 0.45 });
    const { x, y } = BOBINE_INDUCTRICE;
    const symboles = [];
    const disque = new THREE.CircleGeometry(0.2, 32);
    for (const c of [0, Math.PI]) {
        for (const côté of [1, -1]) {
            const coin = (u, v) => new THREE.Vector2(u, côté * v).rotateAround(new THREE.Vector2(), c);
            const forme = new THREE.Shape([coin(x[0], y[0]), coin(x[1], y[0]), coin(x[1], y[1]), coin(x[0], y[1])]);
            groupe.add(extrude(forme, -LONGUEUR - 0.25, 0, cuivre));
            // Le courant sort du plan en haut, y entre en bas, autour des
            // deux pôles : B_s va de gauche à droite dans le rotor.
            const centre = coin((x[0] + x[1]) / 2, (y[0] + y[1]) / 2);
            const symbole = new Courant(COULEUR.inducteur, disque).montre(Math.sign(centre.y));
            symbole.position.set(centre.x, centre.y, 0.01);
            groupe.add(symbole);
            symboles.push(symbole);
        }
        for (const u of [x[0] + 0.12, x[1] - 0.12]) {
            const ym = (y[0] + y[1]) / 2;
            const courbe = new THREE.Curve();
            courbe.getPoint = (t, cible = new THREE.Vector3()) => {
                const p = new THREE.Vector2(u, ym * Math.cos(Math.PI * t)).rotateAround(new THREE.Vector2(), c);
                return cible.set(p.x, p.y, -LONGUEUR - 0.25 - 0.45 * Math.sin(Math.PI * t) ** 0.6);
            };
            groupe.add(new THREE.Mesh(new THREE.TubeGeometry(courbe, 32, 0.1, 8, false), cuivre));
        }
    }

    // Les balais, fixes, sur l'axe des pôles : + à gauche, − à droite.
    for (const sens of [-1, 1]) {
        const balai = new THREE.Mesh(
            new THREE.BoxGeometry(BALAI.radial, BALAI.largeur, BALAI.z[1] - BALAI.z[0]),
            MATÉRIAUX.balai,
        );
        balai.position.set(sens * (COLLECTEUR.r[1] + BALAI.radial / 2 + 0.005), 0, (BALAI.z[0] + BALAI.z[1]) / 2);
        groupe.add(balai);
    }
    return { groupe, symboles, cuivre };
}

// -- Le rotor -------------------------------------------------------------------

/**
 * Le rotor à M bobines, dans son propre repère : le conducteur j (de 0 à
 * 2M − 1) est en π/2 + jπ/M, et la lame j du collecteur au même angle ; la
 * bobine k relie les conducteurs k et k + M. Chaque bobine a son matériau,
 * que l'animation teinte quand elle conduit.
 */
function rotor(M) {
    const groupe = new THREE.Group();
    const conducteurs = Array.from({ length: 2 * M }, (_, j) => ({ j, angle: Math.PI / 2 + (j * Math.PI) / M }));
    const matériaux = Array.from(
        { length: M },
        () => new THREE.MeshStandardMaterial({ color: COULEUR.éteinte, metalness: 0.35, roughness: 0.45 }),
    );
    const bobine = (j) => matériaux[j % M];

    // Les tôles et leurs encoches ; un conducteur par encoche.
    const l = Math.min(0.34, (0.7 * FOND * Math.PI) / M);
    const profil = contourEncoché(new THREE.Shape(), conducteurs, R_ROTOR, FOND, l);
    profil.holes.push(new THREE.Path().absarc(0, 0, R_ARBRE, 0, DEUX_PI, true));
    groupe.add(extrude(profil, -LONGUEUR, 0, MATÉRIAUX.flanc, MATÉRIAUX.coupe, 40));
    for (const c of conducteurs) groupe.add(...encoche(c.angle, FOND, R_ROTOR, l, bobine(c.j), 0.2));

    // Derrière, la tête de chaque bobine relie ses deux conducteurs ; les
    // têtes s'étagent pour ne pas se traverser.
    for (let k = 0; k < M; k++) {
        groupe.add(
            têteDeBobine(conducteurs[k].angle, conducteurs[k].angle + Math.PI / 2, {
                r: R_CONDUCTEUR,
                z: -LONGUEUR - 0.2,
                hauteur: 0.25 + (0.5 * k) / M,
                écart: -0.3 - (0.4 * k) / M,
                épaisseur: 0.06,
                matériau: matériaux[k],
            }),
        );
    }

    // L'arbre.
    const arbre = new THREE.Mesh(new THREE.CylinderGeometry(R_ARBRE, R_ARBRE, LONGUEUR + 3, 40), MATÉRIAUX.arbre);
    arbre.rotation.x = Math.PI / 2;
    arbre.position.z = 1.4 - (LONGUEUR + 3) / 2;
    groupe.add(arbre);

    // Le collecteur : un moyeu isolant, et ses 2M lames de cuivre séparées
    // d'un mince intervalle, chacune reliée à son conducteur par une barre.
    const [r0, r1] = COLLECTEUR.r;
    const [z0, z1] = COLLECTEUR.z;
    // Le moyeu affleure à peine sous les lames, en retrait de leur face
    // avant : on lit les intervalles sans qu'il les recouvre.
    const moyeu = new THREE.Mesh(new THREE.CylinderGeometry(r1 - 0.04, r1 - 0.04, z1 - z0 - 0.08, 48), MATÉRIAUX.isolant);
    moyeu.rotation.x = Math.PI / 2;
    moyeu.position.z = (z0 + z1) / 2 - 0.04;
    groupe.add(moyeu);
    const demi = Math.PI / (2 * M) - 0.03 / r1;
    for (const c of conducteurs) {
        const lame = new THREE.Shape();
        lame.absarc(0, 0, r1, c.angle - demi, c.angle + demi, false);
        lame.absarc(0, 0, r0, c.angle + demi, c.angle - demi, true);
        groupe.add(extrude(lame, z0, z1, MATÉRIAUX.bague, MATÉRIAUX.bague, 16));
        const barre = new THREE.LineCurve3(
            direction(c.angle).multiplyScalar(r1 - 0.04).setZ(z0 + 0.1),
            direction(c.angle).multiplyScalar(FOND + 0.02).setZ(0.06),
        );
        groupe.add(new THREE.Mesh(new THREE.TubeGeometry(barre, 1, 0.05, 8, false), bobine(c.j)));
    }

    return {
        groupe,
        conducteurs,
        matériaux,
        symbole: Math.min(0.13, 0.42 * l),
        libère() {
            groupe.traverse((objet) => objet.geometry?.dispose());
            for (const m of matériaux) m.dispose();
        },
    };
}

// -- Ce que les deux animations dessinent ----------------------------------------

/**
 * L'induit dans une scène : le rotor à M bobines, que `construis` refait
 * quand M change, et le sens du courant dans ses conducteurs — dans ceux de
 * la bobine qui conduit seulement.
 */
function induit(scène, M) {
    let modèle = null;
    let symboles = [];
    // La lame sous le balai + à la dernière image, et si l'on montre le sens
    // des courants : on ne reteint les bobines que lorsque l'un des deux change.
    let active = null;
    let courants = true;
    const soi = {
        /** Les conducteurs du rotor, dans son repère (cf. `rotor`). */
        get conducteurs() {
            return modèle.conducteurs;
        },
        construis(M) {
            if (modèle) {
                scène.scène.remove(modèle.groupe);
                modèle.libère();
                for (const { symbole } of symboles) symbole.material.dispose();
            }
            modèle = rotor(M);
            const disque = new THREE.CircleGeometry(modèle.symbole, 32);
            symboles = modèle.conducteurs.map((c) => {
                const symbole = new Courant(COULEUR.active, disque);
                symbole.position.copy(direction(c.angle).multiplyScalar(R_CONDUCTEUR)).setZ(0.01);
                modèle.groupe.add(symbole);
                return { symbole, c };
            });
            active = null;
            scène.ajoute(modèle.groupe);
        },
        montreLesCourants(oui) {
            courants = oui;
            active = null;
        },
        /**
         * Tourne le rotor en θr et fait commuter les balais. Renvoie les deux
         * conducteurs que le courant parcourt : `j`, dont la lame est sous le
         * balai +, et son `partenaire`.
         */
        tourne(θr) {
            modèle.groupe.rotation.z = θr;
            const M = modèle.matériaux.length;
            // La lame sous le balai + : la plus proche de θ = π.
            const pas = Math.PI / M;
            const j = THREE.MathUtils.euclideanModulo(Math.round((Math.PI - θr - Math.PI / 2) / pas), 2 * M);
            const partenaire = (j + M) % (2 * M);
            if (active !== j) {
                active = j;
                modèle.matériaux.forEach((m, k) => m.color.set(k === j % M ? COULEUR.active : COULEUR.éteinte));
                // Le courant arrive du balai + par l'avant du conducteur j, et
                // s'y enfonce (⊗) ; il ressort vers l'avant (⊙) par l'autre.
                for (const { symbole, c } of symboles) {
                    symbole.visible = courants && (c.j === j || c.j === partenaire);
                    symbole.montre(c.j === j ? -1 : 1);
                }
            }
            return { j, partenaire };
        },
    };
    soi.construis(M);
    return soi;
}

/** Le nom des pôles et des balais. */
function nomsDesPôlesEtDesBalais() {
    return [
        new Étiquette('\\mathrm{N}', { couleur: COULEURS.gris, face: DEVANT }).place(vecteur(-3.6, 0, Z_SCHÉMA)),
        new Étiquette('\\mathrm{S}', { couleur: COULEURS.gris, face: DEVANT }).place(vecteur(3.6, 0, Z_SCHÉMA)),
        new Étiquette('+', { face: DEVANT, taille: '1.3rem' }).place(vecteur(-1.25, 0.5, 1)),
        new Étiquette('-', { face: DEVANT, taille: '1.3rem' }).place(vecteur(1.25, 0.5, 1)),
    ];
}

// -- Le système balais-collecteurs --------------------------------------------------

function balaisCollecteurs(section) {
    const { vue, réglages: panneau } = cadre(section);
    const scène = scèneDeMachine(vue, VUE);

    const état = { M: M_DÉPART, θr: deg(10), n: 0.1, pause: false };

    const fixe = stator();
    scène.ajoute(fixe.groupe);
    const rotorique = induit(scène, état.M);
    const étiquettes = nomsDesPôlesEtDesBalais();

    // Le champ statorique dans l'entrefer : des flèches et leur contour.
    const champ = Array.from({ length: FLÈCHES }, (_, k) => ({
        θ: (DEUX_PI * k) / FLÈCHES,
        flèche: new Flèche({ couleur: COULEUR.Bs, rayon: 0.026, tête: 0.18, largeur: 0.07 }),
    }));
    const contour = new Trait({ couleur: COULEUR.Bs, épaisseur: 2 });
    for (const { θ, flèche } of champ) {
        const valeur = champStatorique(θ);
        const e = direction(θ);
        flèche.place(e.clone().multiplyScalar(R_ENTREFER).setZ(Z_SCHÉMA), e.multiplyScalar(Math.sign(valeur) || 1), LONGUEUR_MAX * Math.abs(valeur));
    }
    contour.trace(
        Array.from({ length: 721 }, (_, k) => {
            const θ = (DEUX_PI * k) / 720;
            return direction(θ).multiplyScalar(R_ENTREFER + LONGUEUR_MAX * champStatorique(θ)).setZ(Z_SCHÉMA);
        }),
    );
    const groupeBs = new THREE.Group().add(...champ.map((f) => f.flèche), contour);

    // Les forces de Laplace sur les deux conducteurs qui conduisent.
    const forces = [0, 1].map(() => new Flèche({ couleur: COULEUR.force, rayon: 0.035, tête: 0.24, largeur: 0.1 }));
    const groupeForces = new THREE.Group().add(...forces);

    // Les axes des deux champs, devant le collecteur, et l'angle α de B_r à
    // B_s.
    const centre = vecteur(0, 0, Z_AXES);
    const axeBs = new Flèche({ couleur: COULEUR.Bs, rayon: 0.04, tête: 0.3, largeur: 0.12, dessus: true }).place(
        centre,
        vecteur(1, 0, 0),
        2.1,
    );
    const axeBr = new Flèche({ couleur: COULEUR.Br, rayon: 0.04, tête: 0.3, largeur: 0.12, dessus: true });
    const nomBs = new Étiquette('\\vec B_s', { couleur: COULEUR.Bs, face: DEVANT }).place(vecteur(2.4, 0.25, Z_AXES));
    const nomBr = new Étiquette('\\vec B_r', { couleur: COULEUR.Br, face: DEVANT });
    const arcα = new Arc('\\alpha', { face: DEVANT });
    const groupeAxes = new THREE.Group().add(axeBs, axeBr, nomBs, nomBr, arcα);

    scène.ajoute(...étiquettes, groupeBs, groupeForces, groupeAxes);

    // -- Réglages --------------------------------------------------------------

    const réglages = new Réglages(panneau);

    réglages.groupe('Fonctionnement');
    réglages.curseur({
        tex: 'n',
        min: 0.01,
        max: 1,
        pas: 0.01,
        valeur: état.n,
        unité: ' tr/s',
        auChangement: (v) => (état.n = v),
    });
    réglages.texte('La vitesse de rotation, très ralentie.').className = 'note';
    const pause = réglages.bouton('Pause', () => {
        état.pause = !état.pause;
        pause.textContent = état.pause ? 'Reprendre' : 'Pause';
    });

    réglages.groupe('Induit');
    réglages.curseur({
        tex: 'M',
        min: 1,
        max: 8,
        pas: 1,
        valeur: état.M,
        auChangement: (v) => {
            état.M = v;
            rotorique.construis(v);
            écritLames();
        },
    });
    const lames = réglages.texte();
    lames.className = 'note';
    const écritLames = () =>
        (lames.textContent = `${état.M === 1 ? 'Une bobine' : `${état.M} bobines`} d’une spire, ${2 * état.M} lames au collecteur.`);
    écritLames();

    réglages.groupe('Afficher');
    const montre = (objets) => (visible) => {
        objets.forEach((o) => (o.visible = visible));
        scène.redessine();
    };
    réglages.case({ texte: 'Champ statorique ', tex: 'B_s', couleur: COULEUR.Bs, auChangement: montre([groupeBs]) });
    réglages.case({ texte: 'Forces de Laplace', couleur: COULEUR.force, auChangement: montre([groupeForces]) });
    réglages.case({ texte: 'Axes des champs et angle α', auChangement: montre([groupeAxes]) });
    réglages.case({
        texte: 'Sens des courants',
        auChangement: (visible) => {
            rotorique.montreLesCourants(visible);
            fixe.symboles.forEach((s) => (s.visible = visible));
            scène.redessine();
        },
    });

    réglages.groupe('Couple électromagnétique');
    réglages.formule('\\Gamma_{\\text{ém}} = K I_e I_r \\sin\\alpha');
    const valeurα = réglages.formule();
    réglages.texte(
        'Les balais ne font passer le courant que dans la bobine la plus proche de α = 90° : α reste entre 90° − 90°/M et 90° + 90°/M.',
    ).className = 'note';
    réglages.texte(
        'En rouge, la bobine parcourue par le courant ; en vert, l’inducteur, parcouru par Iₑ. ' +
            '⊙ : le courant sort du plan, ⊗ : il y entre.',
    ).className = 'note';

    // -- À chaque image ----------------------------------------------------------

    scène.àChaqueImage((dt) => {
        if (!état.pause) état.θr += DEUX_PI * état.n * dt;
        const θr = état.θr;
        const { j, partenaire } = rotorique.tourne(θr);
        const { conducteurs } = rotorique;

        // Les forces : I dl ∧ B, tangentielles, I dl étant selon ±z.
        for (const [k, jc] of [j, partenaire].entries()) {
            const φ = θr + conducteurs[jc].angle;
            const s = jc === j ? -1 : 1;
            const f = s * champStatorique(φ);
            const origine = direction(φ).multiplyScalar(R_CONDUCTEUR).setZ(Z_SCHÉMA + 0.02);
            forces[k].place(origine, direction(φ + Math.PI / 2).multiplyScalar(Math.sign(f) || 1), 1.1 * Math.abs(f));
        }

        // L'axe de B_r : à 90° en arrière du conducteur où le courant sort.
        const axe = θr + conducteurs[partenaire].angle - Math.PI / 2;
        const α = angleSigné(-axe);
        axeBr.place(centre, direction(axe), 1.6);
        nomBr.place(direction(axe).multiplyScalar(1.95).setZ(Z_AXES));
        arcα.place(centre, direction(axe), direction(axe + Math.PI / 2), α, 1.15);
        valeurα.écrit(`\\alpha = ${Math.round(THREE.MathUtils.radToDeg(α))}^\\circ`);
    });
}

// -- Le moteur en charge -------------------------------------------------------------

/**
 * Le moteur, alimenté sous la tension U constante, entraîne une charge qui
 * lui oppose le couple Γ_r. L'inductance de l'induit est négligée : la loi
 * des mailles U = R I_r + Φ₀ Ω donne le courant, donc le couple
 * Γ_ém = Φ₀ I_r, à chaque instant, et le rotor, de moment d'inertie J, suit
 *     J dΩ/dt = Γ_ém − Γ_r = Γ_d (1 − Ω/Ω₀) − Γ_r,
 * où Ω₀ = U/Φ₀ est la vitesse à vide et Γ_d = Φ₀ U/R le couple de démarrage.
 * Les vitesses se comptent en Ω₀, les couples en Γ_d.
 */
const CHARGE = {
    /** À vide, un tour par seconde : on voit encore les balais commuter. */
    Ω0: DEUX_PI,
    /** La constante de temps J₀ R/Φ₀² de la mise en vitesse, en secondes. */
    τ: 1.5,
    /** Ce que retient le chronogramme, en secondes. */
    durée: 20,
    /** La longueur de l'arc d'un couple égal à Γ_d, en radians. */
    arc: 1.7,
};

function charge(section) {
    const { vue, réglages: panneau } = cadre(section);
    const scène = scèneDeMachine(vue, VUE);
    const { Ω0 } = CHARGE;

    const état = { Γr: 0.3, J: 1, θr: deg(10), Ω: 0.7 * Ω0, pause: false };

    scène.ajoute(stator().groupe, ...nomsDesPôlesEtDesBalais());
    const rotorique = induit(scène, M_DÉPART);

    // Les deux couples, en arcs devant le collecteur : celui du moteur dans
    // le sens de rotation, celui de la charge en face, dans l'autre sens.
    const centre = vecteur(0, 0, Z_AXES);
    const arcΓ = new Arc('\\Gamma_{\\text{ém}}', { face: DEVANT });
    const arcΓr = new Arc('\\Gamma_r', { couleur: COULEUR_CHARGE, face: DEVANT });
    scène.ajoute(arcΓ, arcΓr);

    // -- Réglages --------------------------------------------------------------

    const réglages = new Réglages(panneau);

    réglages.groupe('Charge');
    fraction(
        réglages.curseur({
            tex: '\\dfrac{\\Gamma_r}{\\Gamma_d}',
            couleur: COULEUR_CHARGE,
            min: 0,
            max: 1.3,
            pas: 0.01,
            valeur: état.Γr,
            auChangement: (v) => (état.Γr = v),
        }),
    );
    fraction(
        réglages.curseur({
            tex: '\\dfrac{J}{J_0}',
            min: 0.5,
            max: 4,
            pas: 0.05,
            valeur: état.J,
            auChangement: (v) => (état.J = v),
        }),
    );
    const pause = réglages.bouton('Pause', () => {
        état.pause = !état.pause;
        pause.textContent = état.pause ? 'Reprendre' : 'Pause';
    });

    réglages.groupe('Caractéristique couple-vitesse');
    réglages.formule(
        '\\begin{gathered} J\\,\\frac{\\mathrm{d}\\Omega}{\\mathrm{d}t} = \\Phi_0 I_r - \\Gamma_r \\\\ ' +
            'U = R\\,I_r + \\Phi_0\\,\\Omega \\end{gathered}',
    );
    const caractéristique = new Graphe({
        x: { min: 0, max: 1.4, nom: '\\Gamma_{\\text{ém}}', graduations: [0, [1, '\\Gamma_d']] },
        y: { min: 0, max: 1.2, nom: '\\Omega', graduations: [[1, '\\Omega_0']] },
        hauteur: 170,
    });
    caractéristique.courbe({ couleur: COULEURS.noir }).place([
        [0, 1],
        [1, 0],
    ]);
    const niveau = caractéristique.verticale({ couleur: COULEUR_CHARGE, épaisseur: 2 });
    const nomDuNiveau = caractéristique.légende('\\Gamma_r', { couleur: COULEUR_CHARGE, décalage: [0, -7] });
    const pointDeFonctionnement = caractéristique.point({ couleur: COULEURS.noir });
    réglages.ajoute(caractéristique.élément);
    réglages.formule('\\Omega_0 = \\frac{U}{\\Phi_0} \\qquad \\Gamma_d = \\frac{\\Phi_0 U}{R}');
    const valeurs = réglages.formule();

    réglages.groupe('Vitesse du rotor');
    const vitesse = new Graphe({
        x: { min: -CHARGE.durée, max: 0, nom: 't', graduations: [-20, -10, 0].map((t) => [t, t ? `${t}\\,\\text{s}` : '0']) },
        y: { min: -0.1, max: 1.2, nom: '\\Omega', graduations: [[1, '\\Omega_0']] },
        hauteur: 120,
        coupe: true,
    });
    const chrono = chronogramme(vitesse);
    réglages.ajoute(vitesse.élément);

    // -- À chaque image ----------------------------------------------------------

    let couples = { Γm: 0, Γcharge: 0 };

    scène.àChaqueImage((dt) => {
        if (!état.pause) {
            couples = tourne(état, dt, {
                // En unités de Γ_d : J₀ Ω₀ / Γ_d = τ.
                J: (état.J * CHARGE.τ) / Ω0,
                Γr: état.Γr,
                couple: () => 1 - état.Ω / Ω0,
                avance: (h) => (état.θr += état.Ω * h),
            });
            chrono.ajoute(dt, état.Ω / Ω0);
        }
        rotorique.tourne(état.θr);

        const Γ = 1 - état.Ω / Ω0;
        arcΓ.place(centre, direction(deg(200)), direction(deg(290)), CHARGE.arc * Γ, 1.5);
        arcΓr.place(centre, direction(deg(20)), direction(deg(110)), -CHARGE.arc * couples.Γcharge, 1.9);

        niveau.place(état.Γr);
        nomDuNiveau.place(état.Γr, 1.2);
        pointDeFonctionnement.place(Γ, état.Ω / Ω0);
        valeurs.écrit(`\\Omega = ${virgule(état.Ω / Ω0)}\\,\\Omega_0 \\qquad I_r = ${virgule(Γ)}\\,\\frac{U}{R}`);
    });
}

const ANIMATIONS = { collecteur: balaisCollecteurs, charge };

lance('section.animation', (section) => ANIMATIONS[section.dataset.animation](section));
