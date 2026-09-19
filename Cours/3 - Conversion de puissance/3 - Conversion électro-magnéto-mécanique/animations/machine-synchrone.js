// La machine synchrone diphasée et bipolaire du cours, en fonctionnement.
//
// Dans l'entrefer, les deux champs, en flèches radiales dont la longueur suit
// leur valeur : le champ statorique B_s, créé par les courants i₁ = I cos(ωt)
// et i₂ = I cos(ωt + π/2), et le champ rotorique B_r, créé par le courant
// continu I_e du rotor. Chaque circuit a N spires, dans N encoches de part et
// d'autre de son axe : ses champs sont en marches — le théorème d'Ampère les
// fait sauter d'un cran à chaque conducteur. Quand N → ∞, ils tendent vers
// ceux du cours : B_s ∝ cos(ωt − θ), le champ glissant, et B_r ∝ cos(θ − θ_r).
//
// Le rotor tourne au synchronisme : θ_r = ωt − α, l'angle α entre le maximum
// du champ glissant et l'axe du rotor reste constant, et le couple vaut
// Γ_ém = Γ_max sin α.

import * as THREE from 'three';
import { RoomEnvironment } from 'three/addons/environments/RoomEnvironment.js';
import { Arc, COULEURS, Étiquette, Flèche, Trait, écritTex, vecteur } from '#animations/objets.js';
import { cadre, lance } from '#animations/page.js';
import { Réglages } from '#animations/reglages.js';
import { Scène } from '#animations/scene.js';
import { R_ARBRE, R_ENTREFER, R_ROTOR, R_STATOR, machine } from './machine.js';

/** Une couleur par circuit — celle de ses fils, de son courant —, et une par
 *  champ. */
const COULEUR = {
    1: '#1e9a3c',
    2: COULEURS.bleu,
    rotor: COULEURS.vermillon,
    Bs: COULEURS.violet,
    Br: COULEURS.orange,
};

const deg = THREE.MathUtils.degToRad;
/** Une graduation en degrés, et celles d'un tour. */
const degrés = (a) => [a, a ? `${a}^\\circ` : '0'];
const TOUR = [0, 90, 180, 270, 360].map(degrés);
const DEUX_PI = 2 * Math.PI;
const direction = (a) => vecteur(Math.cos(a), Math.sin(a), 0);

/** Ce qui se dessine par-dessus le plan de coupe, juste devant lui, et les
 *  étiquettes qui ne se lisent que devant lui. */
const Z_SCHÉMA = 0.03;
const DEVANT = vecteur(0, 0, 1);
/** Des flèches de champ tous les 10° ; celles de B_r entre celles de B_s. */
const FLÈCHES = 36;
/** L'amplitude de la limite sinusoïdale de chaque champ, celle de B_s pour
 *  unité. Rien ne lie les deux : B_s suit I_s, B_r suit I_e. */
const AMPLITUDE = { Bs: 1, Br: 0.6 };
/** La longueur d'une flèche pour un champ égal à l'amplitude de B_s. */
const LONGUEUR_MAX = 0.85;
/** Les points du contour qui relie les pointes des flèches. */
const ÉCHANTILLONS = 720;
const N_DÉPART = 5;

const VUE_DE_FACE = { position: [0, 0, 30], cible: [0, 0, 0] };
const VUE_DE_TROIS_QUARTS = { position: [9, -14, 26], cible: [0, -0.3, -1.5] };

/**
 * Le champ dans l'entrefer en θ, créé par des conducteurs parcourus par
 * `courant(c)` (positif s'il sort du plan de coupe) : quand on franchit un
 * conducteur dans le sens trigonométrique, le champ baisse de son courant
 * (théorème d'Ampère), et il est de moyenne nulle (conservation du flux).
 * Les courants d'un circuit étant de somme nulle, cela donne
 * B(θ) = Σ I_c · frac((θ − θ_c) / 2π). `décalage` tourne les conducteurs :
 * ceux du rotor, de θ_r.
 */
function champEnMarches(conducteurs, courant, θ, décalage = 0) {
    let B = 0;
    for (const c of conducteurs) B += courant(c) * THREE.MathUtils.euclideanModulo((θ - c.angle - décalage) / DEUX_PI, 1);
    return B;
}

/** Le même champ, marche par marche : les points [θ, B] de sa courbe, de 0 à
 *  2π, qui saute d'un coup à chaque conducteur. */
function marches(conducteurs, courant, décalage = 0) {
    const sauts = conducteurs.map((c) => THREE.MathUtils.euclideanModulo(c.angle + décalage, DEUX_PI));
    const bornes = [0, ...sauts.sort((a, b) => a - b), DEUX_PI];
    return bornes.slice(1).flatMap((fin, k) => {
        const B = champEnMarches(conducteurs, courant, (bornes[k] + fin) / 2, décalage);
        return [
            [bornes[k], B],
            [fin, B],
        ];
    });
}

// -- Le sens des courants : ⊙ et ⊗ --------------------------------------------

/** Le symbole d'un courant qui sort du plan (⊙) ou y entre (⊗), sur un disque
 *  blanc qui le détache du fil. */
function textureCourant(sortant, couleur) {
    const toile = document.createElement('canvas');
    toile.width = toile.height = 128;
    const c = toile.getContext('2d');
    c.fillStyle = '#fff';
    c.beginPath();
    c.arc(64, 64, 62, 0, DEUX_PI);
    c.fill();
    c.strokeStyle = c.fillStyle = couleur;
    c.lineWidth = 9;
    c.beginPath();
    c.arc(64, 64, 50, 0, DEUX_PI);
    c.stroke();
    if (sortant) {
        c.beginPath();
        c.arc(64, 64, 15, 0, DEUX_PI);
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

const texturesCourant = new Map();

/** Le sens du courant dans un conducteur, posé sur sa section. */
class Courant extends THREE.Mesh {
    constructor(couleur, disque) {
        if (!texturesCourant.has(couleur)) {
            texturesCourant.set(couleur, [textureCourant(true, couleur), textureCourant(false, couleur)]);
        }
        super(disque, new THREE.MeshBasicMaterial({ transparent: true, toneMapped: false }));
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
 * Un graphique, x de x0 à x1, y de −`étendue` à `étendue` : le dessin en SVG,
 * ses légendes en KaTeX par-dessus. Les graduations sont des couples (valeur,
 * tex). `trace(f, couleur)` y trace y = f(x) ; `courbe(couleur)` donne une
 * courbe à retracer, par sa méthode `place([[x, y], …])` ; `vers(x, y)` donne
 * les coordonnées d'un point dans le dessin ; `légende(tex, x, y, ancre)` y
 * écrit.
 */
function graphique({ x0, x1, graduationsX, graduationsY, nomX, nomY, hauteur = 140, étendue = 1.15 }) {
    const largeur = 272;
    const marge = { gauche: 44, droite: 14, haut: 22, bas: 20 };
    const conteneur = Object.assign(document.createElement('div'), { className: 'graphique' });
    const racine = svg('svg', { viewBox: `0 0 ${largeur} ${hauteur}` }, conteneur);
    const X = (x) => marge.gauche + ((x - x0) / (x1 - x0)) * (largeur - marge.gauche - marge.droite);
    const Y = (y) => marge.haut + ((étendue - y) / (2 * étendue)) * (hauteur - marge.haut - marge.bas);
    const décalages = { gauche: '0', centre: '-50%', droite: '-100%' };
    const légende = (tex, x, y, ancre = 'centre', couleur = '') => {
        const span = écritTex(Object.assign(document.createElement('span'), { className: 'légende' }), tex);
        Object.assign(span.style, {
            left: `${(100 * x) / largeur}%`,
            top: `${(100 * y) / hauteur}%`,
            translate: `${décalages[ancre]} -50%`,
            color: couleur,
        });
        conteneur.append(span);
        return span;
    };
    const fond = svg('g', {}, racine);
    const trait = (xa, ya, xb, yb, attributs = {}) =>
        svg('line', { x1: xa, y1: ya, x2: xb, y2: yb, stroke: '#e3e3e3', ...attributs }, racine);
    for (const [x, tex] of graduationsX) {
        trait(X(x), Y(étendue), X(x), Y(-étendue));
        légende(tex, X(x), hauteur - 9);
    }
    for (const [y, tex] of graduationsY) {
        trait(X(x0), Y(y), X(x1), Y(y));
        légende(tex, marge.gauche - 5, Y(y), 'droite');
    }
    trait(X(x0), Y(0), X(x1), Y(0), { stroke: '#555' });
    légende(nomX, largeur - 2, Y(0) - 8, 'droite');
    // Le nom de l'axe au-dessus de ses graduations : le haut du graphique
    // reste libre pour ses propres légendes.
    légende(nomY, marge.gauche - 5, 9, 'droite', COULEURS.noir);
    const courbe = (couleur, attributs = {}) => {
        const ligne = svg('polyline', { fill: 'none', stroke: couleur, 'stroke-width': 2, ...attributs }, racine);
        return {
            élément: ligne,
            place(points) {
                ligne.setAttribute('points', points.map(([x, y]) => `${X(x).toFixed(1)},${Y(y).toFixed(1)}`).join(' '));
            },
        };
    };
    return {
        élément: conteneur,
        fond,
        vers: (x, y) => [X(x), Y(y)],
        légende,
        trait,
        courbe,
        trace(f, couleur) {
            courbe(couleur).place(échantillons(x0, x1, 120).map((x) => [x, f(x)]));
        },
        point: (couleur) => svg('circle', { r: 4, fill: couleur }, racine),
        curseur: () => trait(0, Y(étendue), 0, Y(-étendue), { stroke: '#000', 'stroke-dasharray': '3 3' }),
    };
}

/** n + 1 valeurs régulièrement espacées, de a à b. */
function échantillons(a, b, n) {
    return Array.from({ length: n + 1 }, (_, k) => a + ((b - a) * k) / n);
}

// -- L'animation -------------------------------------------------------------------

function machineSynchrone(section) {
    const { vue, réglages: panneau } = cadre(section);
    const scène = new Scène(vue, { rapport: 1.12, taille: 12.6, haut: [0, 1, 0], ...VUE_DE_FACE, éclairage: 0.45 });
    scène.bouton('Vue de trois quarts', () => scène.regarde(VUE_DE_TROIS_QUARTS));
    // Un rendu photographique pour la machine : des reflets pour les métaux —
    // une pièce éclairée, que les tôles, les fils et l'arbre renvoient —, et
    // une exposition qui ne brûle pas les faces claires.
    const pmrem = new THREE.PMREMGenerator(scène.rendu);
    scène.scène.environment = pmrem.fromScene(new RoomEnvironment(), 0.04).texture;
    scène.scène.environmentIntensity = 0.35;
    scène.rendu.toneMapping = THREE.NeutralToneMapping;

    const état = { N: N_DÉPART, ωt: 0, α: 45, f: 0.15, pause: false, courants: true, limites: false };

    // La machine, reconstruite quand N change, et le sens des courants sur
    // la section de ses conducteurs.
    let modèle = null;
    let symboles = [];
    function construis() {
        if (modèle) {
            scène.scène.remove(modèle.stator, modèle.rotor);
            modèle.libère();
            for (const { symbole } of symboles) symbole.material.dispose();
        }
        modèle = machine(état.N, { 1: COULEUR[1], 2: COULEUR[2], rotor: COULEUR.rotor });
        symboles = [];
        for (const partie of ['stator', 'rotor']) {
            const disque = new THREE.CircleGeometry(modèle.symboles[partie], 32);
            for (const c of modèle.conducteurs[partie]) {
                const symbole = new Courant(COULEUR[c.circuit], disque);
                symbole.position.copy(direction(c.angle).multiplyScalar(c.rayon)).setZ(0.01);
                symbole.visible = état.courants;
                modèle[partie].add(symbole);
                symboles.push({ symbole, c });
            }
        }
        scène.ajoute(modèle.stator, modèle.rotor);
    }
    construis();

    // Le nom des bandes de conducteurs des circuits statoriques, et les pôles
    // du rotor, qui tournent avec lui.
    const bandes = [
        ['1', 90, 1],
        ["1'", 270, 1],
        ['2', 0, 2],
        ["2'", 180, 2],
    ].map(([tex, a, circuit]) =>
        new Étiquette(tex, { couleur: COULEUR[circuit], face: DEVANT }).place(
            direction(deg(a)).multiplyScalar(R_STATOR + 0.55),
        ),
    );
    const pôles = new THREE.Group().add(
        new Étiquette('\\mathrm{N}', { couleur: COULEURS.gris, face: DEVANT }).place(vecteur(1.55, 0, Z_SCHÉMA)),
        new Étiquette('\\mathrm{S}', { couleur: COULEURS.gris, face: DEVANT }).place(vecteur(-1.55, 0, Z_SCHÉMA)),
    );

    // Les champs dans l'entrefer : des flèches, le contour qui relie leurs
    // pointes, et en pointillés la limite sinusoïdale.
    const flèches = (couleur, décalage) =>
        Array.from({ length: FLÈCHES }, (_, k) => ({
            θ: (DEUX_PI * (k + décalage)) / FLÈCHES,
            flèche: new Flèche({ couleur, rayon: 0.026, tête: 0.18, largeur: 0.07 }),
        }));
    const champs = {
        Bs: { flèches: flèches(COULEUR.Bs, 0), contour: new Trait({ couleur: COULEUR.Bs, épaisseur: 2 }) },
        Br: { flèches: flèches(COULEUR.Br, 0.5), contour: new Trait({ couleur: COULEUR.Br, épaisseur: 2 }) },
    };
    const limites = {
        Bs: new Trait({ couleur: COULEUR.Bs, épaisseur: 1.5, pointillés: true, tiret: 0.1 }),
        Br: new Trait({ couleur: COULEUR.Br, épaisseur: 1.5, pointillés: true, tiret: 0.1 }),
    };
    const groupeBs = new THREE.Group().add(...champs.Bs.flèches.map((f) => f.flèche), champs.Bs.contour);
    const groupeBr = new THREE.Group().add(...champs.Br.flèches.map((f) => f.flèche), champs.Br.contour);
    const groupeLimites = new THREE.Group().add(limites.Bs, limites.Br);

    // L'angle α, du rotor au maximum du champ glissant, et le couple.
    const schéma = new THREE.Group();
    const axeRotor = new Trait({ couleur: COULEUR.rotor, épaisseur: 2, pointillés: true, tiret: 0.15 });
    const maximumBs = new Trait({ couleur: COULEUR.Bs, épaisseur: 2, pointillés: true, tiret: 0.15 });
    const arcα = new Arc('\\alpha', { face: DEVANT });
    const arcΓ = new Arc('\\Gamma_{\\text{ém}}', { face: DEVANT });
    schéma.add(axeRotor, maximumBs, arcα, arcΓ, pôles);
    scène.ajoute(...bandes, groupeBs, groupeBr, groupeLimites, schéma);

    // -- Réglages --------------------------------------------------------------

    const réglages = new Réglages(panneau);

    réglages.groupe('Fonctionnement');
    réglages.curseur({
        tex: '\\alpha',
        min: -180,
        max: 180,
        pas: 1,
        valeur: état.α,
        unité: '°',
        auChangement: (v) => (état.α = v),
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
    réglages.texte('La fréquence des courants, très ralentie. Le rotor tourne au synchronisme : Ω = ω.').className =
        'note';
    const pause = réglages.bouton('Pause', () => {
        état.pause = !état.pause;
        pause.textContent = état.pause ? 'Reprendre' : 'Pause';
    });

    réglages.groupe('Enroulements');
    réglages.curseur({
        tex: 'N',
        min: 1,
        max: 20,
        pas: 1,
        valeur: état.N,
        auChangement: (v) => {
            état.N = v;
            construis();
        },
    });
    réglages.texte(
        'Encoches de chaque côté de chaque circuit. Le champ saute d’un cran à chaque conducteur : ' +
            'il est en marches, qui tendent vers le champ sinusoïdal du cours quand N → ∞.',
    ).className = 'note';

    // Le graphique des champs, en fonction de θ : la case « Limite
    // sinusoïdale » en montre aussi les pointillés.
    const champsEnθ = graphique({
        x0: 0,
        x1: 360,
        graduationsX: TOUR,
        graduationsY: [
            [AMPLITUDE.Bs, `{\\color{${COULEUR.Bs}} B_{s,\\max}}`],
            [AMPLITUDE.Br, `{\\color{${COULEUR.Br}} B_{r,\\max}}`],
            [-AMPLITUDE.Br, `{\\color{${COULEUR.Br}} -B_{r,\\max}}`],
            [-AMPLITUDE.Bs, `{\\color{${COULEUR.Bs}} -B_{s,\\max}}`],
        ],
        nomX: '\\theta',
        nomY: `{\\color{${COULEUR.Bs}} B_s}, {\\color{${COULEUR.Br}} B_r}`,
        hauteur: 170,
        // Pour N = 1, B_s monte jusqu'à √2 : les créneaux des deux circuits
        // s'ajoutent.
        étendue: 1.5,
    });
    const pointillés = { 'stroke-width': 1.2, 'stroke-dasharray': '4 3', style: 'display: none' };
    const courbesLimites = {
        Bs: champsEnθ.courbe(COULEUR.Bs, pointillés),
        Br: champsEnθ.courbe(COULEUR.Br, pointillés),
    };
    const courbesChamps = { Bs: champsEnθ.courbe(COULEUR.Bs), Br: champsEnθ.courbe(COULEUR.Br) };

    réglages.groupe('Afficher');
    const montre = (objets) => (visible) => {
        objets.forEach((o) => (o.visible = visible));
        scène.redessine();
    };
    réglages.case({ texte: 'Champ statorique ', tex: 'B_s', couleur: COULEUR.Bs, auChangement: montre([groupeBs]) });
    réglages.case({ texte: 'Champ rotorique ', tex: 'B_r', couleur: COULEUR.Br, auChangement: montre([groupeBr]) });
    groupeLimites.visible = false;
    réglages.case({
        texte: 'Limite sinusoïdale (N → ∞)',
        valeur: false,
        auChangement: (visible) => {
            état.limites = visible;
            for (const courbe of Object.values(courbesLimites)) courbe.élément.style.display = visible ? '' : 'none';
            montre([groupeLimites])(visible);
        },
    });
    réglages.case({
        texte: 'Sens des courants',
        auChangement: (visible) => {
            état.courants = visible;
            montre(symboles.map((s) => s.symbole))(visible);
        },
    });
    réglages.case({ texte: 'Angle α et couple', auChangement: montre([schéma]) });

    réglages.groupe('Champs dans l’entrefer');
    réglages.ajoute(champsEnθ.élément);
    réglages.texte(
        'Rien ne lie les amplitudes des deux champs : celle du champ statorique suit l’amplitude I des ' +
            'courants statoriques, celle du champ rotorique le courant d’excitation Iₑ.',
    ).className = 'note';

    réglages.groupe('Couple électromagnétique');
    réglages.formule('\\Gamma_{\\text{ém}} = \\Gamma_{\\max} \\sin\\alpha');
    const couple = graphique({
        x0: -180,
        x1: 180,
        graduationsX: [-180, -90, 0, 90, 180].map(degrés),
        graduationsY: [
            [1, '\\Gamma_{\\max}'],
            [-1, '-\\Gamma_{\\max}'],
        ],
        nomX: '\\alpha',
        nomY: '\\Gamma_{\\text{ém}}',
        hauteur: 150,
    });
    // La zone stable, |α| < 90° : le couple y croît avec α. Le signe de α
    // sépare les deux fonctionnements, de part et d'autre du pointillé.
    const [xs0, ys0] = couple.vers(-90, 1.15);
    const [xs1, ys1] = couple.vers(90, -1.15);
    svg('rect', { x: xs0, y: ys0, width: xs1 - xs0, height: ys1 - ys0, fill: '#f0f0f0' }, couple.fond);
    couple.trait(...couple.vers(0, 1.15), ...couple.vers(0, -1.15), { stroke: '#000', 'stroke-dasharray': '4 3' });
    couple.légende('\\text{générateur}', ...couple.vers(-90, 1.3), 'centre', COULEURS.noir);
    couple.légende('\\text{moteur}', ...couple.vers(90, 1.3), 'centre', COULEURS.noir);
    // Chaque zone nommée là où la courbe n'est pas : du côté opposé au signe
    // du couple.
    for (const [α, y, tex] of [
        [-135, 0.55, 'instable'],
        [-45, 0.55, 'stable'],
        [45, -0.55, 'stable'],
        [135, -0.55, 'instable'],
    ]) {
        couple.légende(`\\text{${tex}}`, ...couple.vers(α, y));
    }
    couple.trace((α) => Math.sin(deg(α)), '#000');
    const pointCouple = couple.point(COULEURS.noir);
    réglages.ajoute(couple.élément);
    const bilan = réglages.texte();

    réglages.groupe('Courants statoriques');
    const courants = graphique({
        x0: 0,
        x1: 360,
        graduationsX: TOUR,
        graduationsY: [
            [1, 'I'],
            [-1, '-I'],
        ],
        nomX: '\\omega t',
        nomY: `{\\color{${COULEUR[1]}} i_1}, {\\color{${COULEUR[2]}} i_2}`,
    });
    courants.trace((x) => Math.cos(deg(x)), COULEUR[1]);
    courants.trace((x) => Math.cos(deg(x) + Math.PI / 2), COULEUR[2]);
    const curseurTemps = courants.curseur();
    const points = [1, 2].map((circuit) => courants.point(COULEUR[circuit]));
    réglages.ajoute(courants.élément);
    réglages.formule(
        `\\begin{gathered} {\\color{${COULEUR[1]}} i_1 = I\\cos(\\omega t)} \\\\ ` +
            `{\\color{${COULEUR[2]}} i_2 = I\\cos(\\omega t + \\pi/2)} \\end{gathered}`,
    );
    réglages.texte(
        'Dans les encoches, ⊙ : le courant sort du plan de coupe, ⊗ : il y entre ; le symbole pâlit avec ' +
            'l’intensité. En vert le circuit statorique 1 (conducteurs 1 et 1′), en bleu le circuit 2 (2 et 2′), ' +
            'en rouge le circuit rotorique, parcouru par le courant continu Iₑ.',
    ).className = 'note';

    // -- À chaque image ----------------------------------------------------------

    scène.àChaqueImage((dt) => {
        if (!état.pause) état.ωt += DEUX_PI * état.f * dt;
        // Au synchronisme, le rotor garde son retard α sur le champ glissant.
        const ωt = état.ωt;
        const θr = ωt - deg(état.α);
        const i = { 1: Math.cos(ωt), 2: Math.cos(ωt + Math.PI / 2), rotor: 1 };

        modèle.rotor.rotation.z = θr;
        pôles.rotation.z = θr;
        for (const { symbole, c } of symboles) symbole.montre(c.sens * i[c.circuit]);

        // Chaque conducteur porte 2/N du courant de son circuit : la limite
        // sinusoïdale a pour amplitude 1, quel que soit N.
        const poids = 2 / état.N;
        const { stator, rotor } = modèle.conducteurs;
        const courantStator = (c) => poids * AMPLITUDE.Bs * c.sens * i[c.circuit];
        const courantRotor = (c) => poids * AMPLITUDE.Br * c.sens;
        const limiteBs = (θ) => AMPLITUDE.Bs * Math.cos(ωt - θ);
        const limiteBr = (θ) => AMPLITUDE.Br * Math.cos(θ - θr);
        dessineChamp(champs.Bs, (θ) => champEnMarches(stator, courantStator, θ), limites.Bs, limiteBs);
        dessineChamp(champs.Br, (θ) => champEnMarches(rotor, courantRotor, θ, θr), limites.Br, limiteBr);

        // Les mêmes champs sur le graphique, θ en degrés.
        const enDegrés = (points) => points.map(([θ, B]) => [THREE.MathUtils.radToDeg(θ), B]);
        courbesChamps.Bs.place(enDegrés(marches(stator, courantStator)));
        courbesChamps.Br.place(enDegrés(marches(rotor, courantRotor, θr)));
        if (état.limites) {
            const θs = échantillons(0, DEUX_PI, 120);
            courbesLimites.Bs.place(enDegrés(θs.map((θ) => [θ, limiteBs(θ)])));
            courbesLimites.Br.place(enDegrés(θs.map((θ) => [θ, limiteBr(θ)])));
        }

        const centre = vecteur(0, 0, Z_SCHÉMA);
        const rayon = (a) => [R_ARBRE + 0.15, R_ROTOR - 0.1].map((r) => direction(a).multiplyScalar(r).setZ(Z_SCHÉMA));
        axeRotor.trace(rayon(θr));
        maximumBs.trace(rayon(ωt));
        const α = deg(état.α);
        arcα.place(centre, direction(θr), direction(θr + Math.PI / 2), α, 2.05);
        // Le couple, en arc autour de l'arbre : dans le sens de rotation
        // quand il entraîne le rotor.
        const Γ = Math.sin(α);
        arcΓ.place(centre, direction(θr + Math.PI), direction(θr + (3 * Math.PI) / 2), 1.7 * Γ, 1.05);

        const [x, y] = couple.vers(état.α, Γ);
        pointCouple.setAttribute('cx', x);
        pointCouple.setAttribute('cy', y);
        const t = THREE.MathUtils.radToDeg(THREE.MathUtils.euclideanModulo(ωt, DEUX_PI));
        const [xt] = courants.vers(t, 0);
        curseurTemps.setAttribute('x1', xt);
        curseurTemps.setAttribute('x2', xt);
        points.forEach((p, k) => {
            const [, yi] = courants.vers(t, i[k + 1]);
            p.setAttribute('cx', xt);
            p.setAttribute('cy', yi);
        });
        const texte = régime(état.α);
        if (bilan.textContent !== texte) bilan.textContent = texte;
    });
}

/**
 * Un champ dans l'entrefer : ses flèches, radiales, vers l'extérieur s'il est
 * positif, partant du milieu de l'entrefer ; le contour qui relie leurs
 * pointes, et la limite sinusoïdale `limite(θ)`.
 */
function dessineChamp({ flèches, contour }, champ, pointillés, limite) {
    for (const { θ, flèche } of flèches) {
        const valeur = champ(θ);
        const e = direction(θ);
        const origine = e.clone().multiplyScalar(R_ENTREFER).setZ(Z_SCHÉMA);
        flèche.place(origine, e.multiplyScalar(Math.sign(valeur) || 1), LONGUEUR_MAX * Math.abs(valeur));
    }
    const autour = (f) =>
        Array.from({ length: ÉCHANTILLONS + 1 }, (_, k) => {
            const θ = (DEUX_PI * k) / ÉCHANTILLONS;
            return direction(θ).multiplyScalar(R_ENTREFER + LONGUEUR_MAX * f(θ)).setZ(Z_SCHÉMA);
        });
    contour.trace(autour(champ));
    pointillés.trace(autour(limite));
}

/** Ce que le cours dit du régime de fonctionnement. */
function régime(α) {
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
