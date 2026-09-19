// La machine synchrone diphasée et bipolaire du cours, en fonctionnement.
//
// Dans l'entrefer, les deux champs du cours, en flèches radiales dont la
// longueur suit leur valeur :
//
//   B_s(θ, t) ∝ cos(ωt − θ)   le champ glissant, créé par les courants
//                             i₁ = I cos(ωt) et i₂ = I cos(ωt + π/2) ;
//   B_r(θ, t) ∝ cos(θ − θ_r)  le champ du rotor, qui tourne avec lui.
//
// Le rotor tourne à Ω, avec θ_r = Ωt − α. Au synchronisme (Ω = ω), l'angle α
// entre le maximum du champ glissant et l'axe du rotor reste constant, et le
// couple Γ_ém = Γ_max sin(ωt − θ_r) = Γ_max sin α aussi. Hors synchronisme,
// cet angle défile, le couple change de signe et sa moyenne est nulle.

import * as THREE from 'three';
import { RoomEnvironment } from 'three/addons/environments/RoomEnvironment.js';
import { Arc, COULEURS, Étiquette, Flèche, Trait, vecteur } from '#animations/objets.js';
import { cadre, lance } from '#animations/page.js';
import { Réglages } from '#animations/reglages.js';
import { Scène } from '#animations/scene.js';
import {
    ANGLES_ENCOCHES,
    ENCOCHES_DU_ROTOR,
    R_ARBRE,
    R_CONDUCTEUR,
    R_CONDUCTEUR_ROTOR,
    R_ENTREFER,
    R_ROTOR,
    R_STATOR,
    bobinage,
    machine,
} from './machine.js';

const COULEUR_BS = COULEURS.bleu;
const COULEUR_BR = COULEURS.vermillon;
const COULEUR_PHASE = { 1: COULEURS.vert, 2: COULEURS.pourpre };

const deg = THREE.MathUtils.degToRad;
/** Un angle ramené dans ]−π, π]. */
const angleSigné = (a) => THREE.MathUtils.euclideanModulo(a + Math.PI, 2 * Math.PI) - Math.PI;
const direction = (a) => vecteur(Math.cos(a), Math.sin(a), 0);

/** Ce qui se dessine par-dessus le plan de coupe, juste devant lui, et les
 *  étiquettes qui ne se lisent que devant lui. */
const Z_SCHÉMA = 0.03;
const DEVANT = vecteur(0, 0, 1);
/** Des flèches de champ tous les 15° ; celles de B_r entre celles de B_s. */
const FLÈCHES = 24;
/** La longueur d'une flèche de champ maximal. */
const LONGUEUR_MAX = 0.85;

const VUE_DE_TROIS_QUARTS = { position: [6, -9.3, 20.5], cible: [0, -0.4, -1.5] };
const VUE_DE_FACE = { position: [0, 0, 22.5], cible: [0, 0, -1] };

// -- Le sens des courants : ⊙ et ⊗ --------------------------------------------

/** Le symbole d'un courant qui sort du plan (⊙) ou y entre (⊗), sur un disque
 *  blanc qui le détache du cuivre. */
function textureCourant(sortant, couleur) {
    const toile = document.createElement('canvas');
    toile.width = toile.height = 128;
    const c = toile.getContext('2d');
    c.fillStyle = '#fff';
    c.beginPath();
    c.arc(64, 64, 62, 0, 2 * Math.PI);
    c.fill();
    c.strokeStyle = c.fillStyle = couleur;
    c.lineWidth = 9;
    c.beginPath();
    c.arc(64, 64, 50, 0, 2 * Math.PI);
    c.stroke();
    if (sortant) {
        c.beginPath();
        c.arc(64, 64, 15, 0, 2 * Math.PI);
        c.fill();
    } else {
        c.lineWidth = 10;
        c.beginPath();
        c.moveTo(34, 34);
        c.lineTo(94, 94);
        c.moveTo(94, 34);
        c.lineTo(34, 94);
        c.stroke();
    }
    const texture = new THREE.CanvasTexture(toile);
    texture.colorSpace = THREE.SRGBColorSpace;
    return texture;
}

const DISQUE = new THREE.CircleGeometry(0.13, 32);
const texturesCourant = new Map();

/** Le sens du courant dans un conducteur, posé sur sa section. */
class Courant extends THREE.Mesh {
    constructor(couleur) {
        if (!texturesCourant.has(couleur)) {
            texturesCourant.set(couleur, [textureCourant(true, couleur), textureCourant(false, couleur)]);
        }
        super(DISQUE, new THREE.MeshBasicMaterial({ transparent: true, toneMapped: false }));
        [this.sortant, this.entrant] = texturesCourant.get(couleur);
    }

    /** `i` entre −1 et 1 : le symbole pâlit avec l'intensité. */
    montre(i) {
        this.material.map = i >= 0 ? this.sortant : this.entrant;
        this.material.opacity = Math.min(1, Math.abs(i));
        return this;
    }
}

// -- Petits graphiques -----------------------------------------------------------

const SVG = 'http://www.w3.org/2000/svg';

function svg(balise, attributs, parent) {
    const élément = document.createElementNS(SVG, balise);
    for (const [clé, valeur] of Object.entries(attributs)) élément.setAttribute(clé, valeur);
    parent?.append(élément);
    return élément;
}

/**
 * Un graphique de `largeur` × `hauteur` pixels, x de x0 à x1, y de −1 à 1.
 * `trace(f, couleur)` y trace y = f(x) ; `vers(x, y)` donne les coordonnées
 * d'un point dans le dessin.
 */
function graphique({ x0, x1, graduations, largeur = 272, hauteur = 132, nomX, nomY }) {
    const marge = { gauche: 22, droite: 14, haut: 16, bas: 20 };
    const racine = svg('svg', { viewBox: `0 0 ${largeur} ${hauteur}`, width: '100%', class: 'graphique' });
    const X = (x) => marge.gauche + ((x - x0) / (x1 - x0)) * (largeur - marge.gauche - marge.droite);
    const Y = (y) => marge.haut + ((1.15 - y) / 2.3) * (hauteur - marge.haut - marge.bas);
    const texte = (contenu, x, y, attributs = {}) => {
        const t = svg('text', { x, y, 'font-size': 11, fill: COULEURS.gris, ...attributs }, racine);
        t.textContent = contenu;
        return t;
    };
    const fond = svg('g', {}, racine);
    for (const [x, étiquette] of graduations) {
        svg('line', { x1: X(x), x2: X(x), y1: Y(1.15), y2: Y(-1.15), stroke: '#e3e3e3' }, racine);
        texte(étiquette, X(x), hauteur - 6, { 'text-anchor': 'middle' });
    }
    for (const y of [-1, 1]) {
        svg('line', { x1: X(x0), x2: X(x1), y1: Y(y), y2: Y(y), stroke: '#e3e3e3' }, racine);
        texte(y === 1 ? '1' : '−1', marge.gauche - 5, Y(y) + 4, { 'text-anchor': 'end' });
    }
    svg('line', { x1: X(x0), x2: X(x1), y1: Y(0), y2: Y(0), stroke: '#555' }, racine);
    texte(nomX, largeur - 2, Y(0) - 5, { 'text-anchor': 'end', 'font-style': 'italic' });
    texte(nomY, marge.gauche + 3, 11, { 'font-style': 'italic' });
    return {
        racine,
        fond,
        vers: (x, y) => [X(x), Y(y)],
        texte,
        trace(f, couleur) {
            const points = Array.from({ length: 121 }, (_, k) => {
                const x = x0 + ((x1 - x0) * k) / 120;
                return `${X(x).toFixed(1)},${Y(f(x)).toFixed(1)}`;
            });
            svg('polyline', { points: points.join(' '), fill: 'none', stroke: couleur, 'stroke-width': 2 }, racine);
        },
        point: (couleur) => svg('circle', { r: 4, fill: couleur }, racine),
        curseur: () => svg('line', { y1: Y(1.15), y2: Y(-1.15), stroke: '#000', 'stroke-dasharray': '3 3' }, racine),
    };
}

// -- L'animation -------------------------------------------------------------------

function machineSynchrone(section) {
    const { vue, réglages: panneau } = cadre(section);
    const scène = new Scène(vue, {
        perspective: true,
        rapport: 1.12,
        taille: 30,
        haut: [0, 1, 0],
        ...VUE_DE_TROIS_QUARTS,
        éclairage: 0.45,
    });
    scène.bouton('De face', () => scène.regarde(VUE_DE_FACE));
    // Un rendu photographique pour la machine : des reflets pour les métaux —
    // une pièce éclairée, que les tôles, le cuivre et l'arbre renvoient —, et
    // une exposition qui ne brûle pas les faces claires.
    const pmrem = new THREE.PMREMGenerator(scène.rendu);
    scène.scène.environment = pmrem.fromScene(new RoomEnvironment(), 0.04).texture;
    scène.scène.environmentIntensity = 0.35;
    scène.rendu.toneMapping = THREE.NeutralToneMapping;

    const { stator, rotor } = machine();
    scène.ajoute(stator, rotor);

    // Le sens des courants, sur la section des conducteurs.
    const courantsStator = ANGLES_ENCOCHES.map((a) => {
        const { phase, sens } = bobinage(a);
        const symbole = new Courant(COULEUR_PHASE[phase]);
        symbole.position.copy(direction(a).multiplyScalar(R_CONDUCTEUR)).setZ(0.01);
        return { symbole, phase, sens };
    });
    const courantsRotor = ENCOCHES_DU_ROTOR.map(({ angle, sens }) => {
        const symbole = new Courant(COULEURS.noir).montre(sens);
        symbole.position.copy(direction(angle).multiplyScalar(R_CONDUCTEUR_ROTOR)).setZ(0.01);
        return symbole;
    });
    stator.add(...courantsStator.map((c) => c.symbole));
    rotor.add(...courantsRotor);

    // Le nom des bandes de conducteurs de chaque enroulement, et les pôles du
    // rotor.
    const bandes = [
        ['1', 90, 1],
        ["1'", 270, 1],
        ['2', 0, 2],
        ["2'", 180, 2],
    ].map(([tex, a, phase]) =>
        new Étiquette(tex, { couleur: COULEUR_PHASE[phase], face: DEVANT }).place(
            direction(deg(a)).multiplyScalar(R_STATOR + 0.55),
        ),
    );
    const pôles = [
        new Étiquette('\\mathrm{N}', { couleur: COULEURS.gris, face: DEVANT }).place(vecteur(1.55, 0, Z_SCHÉMA)),
        new Étiquette('\\mathrm{S}', { couleur: COULEURS.gris, face: DEVANT }).place(vecteur(-1.55, 0, Z_SCHÉMA)),
    ];
    scène.ajoute(...bandes);
    rotor.add(...pôles);

    // Les champs dans l'entrefer.
    const flèche = (couleur) => new Flèche({ couleur, rayon: 0.026, tête: 0.18, largeur: 0.07 });
    const champs = {
        Bs: Array.from({ length: FLÈCHES }, (_, k) => ({
            θ: (2 * Math.PI * k) / FLÈCHES,
            flèche: flèche(COULEUR_BS),
        })),
        Br: Array.from({ length: FLÈCHES }, (_, k) => ({
            θ: (2 * Math.PI * (k + 0.5)) / FLÈCHES,
            flèche: flèche(COULEUR_BR),
        })),
    };
    const groupeBs = new THREE.Group().add(...champs.Bs.map((c) => c.flèche));
    const groupeBr = new THREE.Group().add(...champs.Br.map((c) => c.flèche));

    // L'angle α, du rotor au maximum du champ glissant, et le couple.
    const schéma = new THREE.Group();
    const axeRotor = new Trait({ couleur: COULEUR_BR, épaisseur: 2, pointillés: true, tiret: 0.15 });
    const maximumBs = new Trait({ couleur: COULEUR_BS, épaisseur: 2, pointillés: true, tiret: 0.15 });
    const arcα = new Arc('\\alpha', { face: DEVANT });
    const arcΓ = new Arc('\\Gamma_{\\text{ém}}', { face: DEVANT });
    schéma.add(axeRotor, maximumBs, arcα, arcΓ);
    scène.ajoute(groupeBs, groupeBr, schéma);

    // -- Réglages --------------------------------------------------------------

    const état = { ωt: 0, θr: 0, α: 45, rapport: 1, f: 0.15, pause: false };
    const réglages = new Réglages(panneau);

    réglages.groupe('Fonctionnement');
    const curseurα = réglages.curseur({
        tex: '\\alpha',
        min: -180,
        max: 180,
        pas: 1,
        valeur: état.α,
        unité: '°',
        auChangement: (v) => (état.α = v),
    });
    réglages.curseur({
        tex: '\\Omega/\\omega',
        min: 0,
        max: 2,
        pas: 0.05,
        valeur: état.rapport,
        auChangement: (v) => {
            état.rapport = v;
            curseurα.désactive(v !== 1);
        },
    });
    réglages.curseur({
        tex: 'f',
        min: 0.05,
        max: 1,
        pas: 0.05,
        valeur: état.f,
        unité: ' Hz',
        auChangement: (v) => (état.f = v),
    });
    réglages.texte('La fréquence des courants, très ralentie.').className = 'note';
    const pause = réglages.bouton('Pause', () => {
        état.pause = !état.pause;
        pause.textContent = état.pause ? 'Reprendre' : 'Pause';
    });

    réglages.groupe('Couple électromagnétique');
    réglages.formule('\\Gamma_{\\text{ém}} = \\Gamma_{\\max} \\sin(\\omega t - \\theta_r)');
    const couple = graphique({
        x0: -180,
        x1: 180,
        graduations: [
            [-180, '−180°'],
            [-90, '−90°'],
            [0, '0'],
            [90, '90°'],
            [180, '180°'],
        ],
        nomX: 'α',
        nomY: 'Γ / Γmax',
    });
    // La zone stable, |α| < 90° : le couple y croît avec α.
    const [xs0, ys0] = couple.vers(-90, 1.15);
    const [xs1, ys1] = couple.vers(90, -1.15);
    svg('rect', { x: xs0, y: ys0, width: xs1 - xs0, height: ys1 - ys0, fill: '#f0f0f0' }, couple.fond);
    couple.texte('stable', (xs0 + xs1) / 2, ys0 + 10, { 'text-anchor': 'middle' });
    // Le signe du couple sépare les deux fonctionnements.
    couple.texte('moteur →', ...couple.vers(175, -0.78), { 'text-anchor': 'end' });
    couple.texte('← générateur', ...couple.vers(-175, 0.66), { 'text-anchor': 'start' });
    couple.trace((α) => Math.sin(deg(α)), '#000');
    const pointCouple = couple.point(COULEURS.noir);
    réglages.ajoute(couple.racine);
    const bilan = réglages.texte();

    réglages.groupe('Courants statoriques');
    const courants = graphique({
        x0: 0,
        x1: 360,
        graduations: [
            [0, '0'],
            [90, '90°'],
            [180, '180°'],
            [270, '270°'],
            [360, '360°'],
        ],
        nomX: 'ωt',
        nomY: 'i / I',
    });
    courants.trace((x) => Math.cos(deg(x)), COULEUR_PHASE[1]);
    courants.trace((x) => Math.cos(deg(x) + Math.PI / 2), COULEUR_PHASE[2]);
    const curseurTemps = courants.curseur();
    const points = [1, 2].map((phase) => courants.point(COULEUR_PHASE[phase]));
    réglages.ajoute(courants.racine);
    réglages.formule(
        `\\begin{gathered} {\\color{${COULEUR_PHASE[1]}} i_1 = I\\cos(\\omega t)} \\\\ {\\color{${COULEUR_PHASE[2]}} i_2 = I\\cos(\\omega t + \\pi/2)} \\end{gathered}`,
    );
    réglages.texte(
        'Dans les encoches, ⊙ : le courant sort du plan de coupe, ⊗ : il y entre ; ' +
            'le symbole pâlit avec l’intensité. En vert l’enroulement 1 (conducteurs 1 et 1′), ' +
            'en rose l’enroulement 2 (2 et 2′) ; en noir, l’enroulement du rotor, parcouru par le courant continu Iₑ.',
    ).className = 'note';

    réglages.groupe('Afficher');
    const montre = (objets) => (visible) => {
        objets.forEach((o) => (o.visible = visible));
        scène.redessine();
    };
    réglages.case({ texte: 'Champ statorique ', tex: 'B_s', couleur: COULEUR_BS, auChangement: montre([groupeBs]) });
    réglages.case({ texte: 'Champ rotorique ', tex: 'B_r', couleur: COULEUR_BR, auChangement: montre([groupeBr]) });
    réglages.case({
        texte: 'Sens des courants',
        auChangement: montre([...courantsStator.map((c) => c.symbole), ...courantsRotor]),
    });
    réglages.case({ texte: 'Angle α et couple', auChangement: montre([schéma, ...pôles]) });

    // -- À chaque image ----------------------------------------------------------

    scène.àChaqueImage((dt) => {
        if (!état.pause) {
            const dφ = 2 * Math.PI * état.f * dt;
            état.ωt += dφ;
            état.θr += état.rapport * dφ;
        }
        // Au synchronisme, le rotor garde son retard α sur le champ glissant.
        if (état.rapport === 1) état.θr = état.ωt - deg(état.α);
        const { ωt, θr } = état;
        const ψ = angleSigné(ωt - θr);

        rotor.rotation.z = θr;
        const i = { 1: Math.cos(ωt), 2: Math.cos(ωt + Math.PI / 2) };
        for (const { symbole, phase, sens } of courantsStator) symbole.montre(sens * i[phase]);

        for (const { θ, flèche } of champs.Bs) champ(flèche, θ, Math.cos(ωt - θ));
        for (const { θ, flèche } of champs.Br) champ(flèche, θ, Math.cos(θ - θr));

        const centre = vecteur(0, 0, Z_SCHÉMA);
        const rayon = (a) => [R_ARBRE + 0.15, R_ROTOR - 0.1].map((r) => direction(a).multiplyScalar(r).setZ(Z_SCHÉMA));
        axeRotor.trace(rayon(θr));
        maximumBs.trace(rayon(ωt));
        arcα.place(centre, direction(θr), direction(θr + Math.PI / 2), ψ, 2.05);
        // Le couple, en arc autour de l'arbre : dans le sens de rotation
        // quand il entraîne le rotor.
        const Γ = Math.sin(ψ);
        arcΓ.place(centre, direction(θr + Math.PI), direction(θr + (3 * Math.PI) / 2), 1.7 * Γ, 1.05);

        const [x, y] = couple.vers(THREE.MathUtils.radToDeg(ψ), Γ);
        pointCouple.setAttribute('cx', x);
        pointCouple.setAttribute('cy', y);
        const t = THREE.MathUtils.radToDeg(THREE.MathUtils.euclideanModulo(ωt, 2 * Math.PI));
        const [xt] = courants.vers(t, 0);
        curseurTemps.setAttribute('x1', xt);
        curseurTemps.setAttribute('x2', xt);
        points.forEach((p, k) => {
            const [, yi] = courants.vers(t, i[k + 1]);
            p.setAttribute('cx', xt);
            p.setAttribute('cy', yi);
        });
        const texte = régime(état.rapport, état.α);
        if (bilan.textContent !== texte) bilan.textContent = texte;
    });
}

/** Une flèche de champ : radiale, vers l'extérieur si le champ est positif,
 *  partant du milieu de l'entrefer. */
function champ(flèche, θ, valeur) {
    const e = direction(θ);
    const origine = e.clone().multiplyScalar(R_ENTREFER).setZ(Z_SCHÉMA);
    flèche.place(origine, e.multiplyScalar(Math.sign(valeur) || 1), LONGUEUR_MAX * Math.abs(valeur));
}

/** Ce que le cours dit du régime de fonctionnement. */
function régime(rapport, α) {
    if (rapport !== 1) {
        return (
            'Ω ≠ ω : l’angle entre le rotor et le champ glissant défile, ' +
            'le couple change sans cesse de signe ; sa moyenne est nulle.'
        );
    }
    if (α === 0) return 'α = 0 : le couple est nul, la machine tourne à vide.';
    const sens =
        α > 0
            ? 'Moteur (α > 0) : le champ glissant est en avance sur le rotor'
            : 'Générateur (α < 0) : le rotor est en avance sur le champ glissant';
    const stabilité =
        Math.abs(α) < 90 ? 'fonctionnement stable.' : 'fonctionnement instable, le rotor décroche si la charge augmente.';
    return `${sens} ; ${stabilité}`;
}

lance('section.animation', machineSynchrone);
