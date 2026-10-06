// Les trois systèmes de coordonnées du cours, décrits par des données. Les
// animations (coordonnees.js) n'en connaissent pas d'autre forme : ajouter un
// élément de surface, ou un système, ne demande rien de plus ici.
//
// Les angles sont en radians partout ici : seuls les curseurs parlent en
// degrés. Notations, bornes et formules sont celles du cours.

import { COULEURS, ORIGINE, X, Y, Z, vecteur } from '#animations/objets.js';

/** Une couleur par coordonnée : celle de son curseur, de son vecteur de
 *  base, et des arêtes le long desquelles elle varie. */
export const COULEURS_COORDONNÉES = [COULEURS.vermillon, COULEURS.bleu, COULEURS.vert];

const d = (tex) => `\\mathrm{d}${tex}`;
const milieu = (a, b) => a.clone().add(b).multiplyScalar(0.5);

/** Une coordonnée de longueur, et le curseur de son accroissement : au
 *  centième, pour qu'ils glissent sans à-coups. */
const longueur = (tex, min = -4) => ({ tex, min, max: 4, pas: 0.01, d: { min: 0.1, max: 2.5, pas: 0.01 } });

/** Une coordonnée angulaire, en degrés pour les curseurs. `borné` : elle ne
 *  peut dépasser son maximum (θ des sphériques ne va pas au-delà de π). */
const angle = (tex, max, dmax, borné = false) => ({
    tex,
    min: 0,
    max,
    pas: 1,
    angle: true,
    borné,
    d: { min: 1, max: dmax, pas: 1 },
});

/** Le curseur d'une dimension d'un volume creux ; `couleur` est l'indice de
 *  la coordonnée qu'elle mesure. */
const dimension = (tex, couleur, min, max) => ({ tex, couleur, min, max, pas: 0.01 });

// -- Coordonnées cartésiennes ------------------------------------------------

const cartesiennes = {
    coordonnées: [longueur('x'), longueur('y'), longueur('z')],
    position: ([x, y, z]) => vecteur(x, y, z),
    base: () => [X, Y, Z],
    vecteurs: ['\\vec{e}_x', '\\vec{e}_y', '\\vec{e}_z'],
    OM: '\\overrightarrow{OM} = x\\,\\vec{e}_x + y\\,\\vec{e}_y + z\\,\\vec{e}_z',
    // La longueur des arêtes le long desquelles chaque coordonnée varie, et
    // les coordonnées dont elle dépend : elle n'est exacte que sur les arêtes
    // où celles-ci valent q (r dθ, sur l'arc de rayon r).
    arêtes: [[d('x'), []], [d('y'), []], [d('z'), []]],
    volume: `${d('V')} = ${d('x')} \\cdot ${d('y')} \\cdot ${d('z')}`,
    // L'élément de surface dont la i-ème coordonnée est constante : dS e_i.
    surfaces: [`${d('y')} \\cdot ${d('z')}`, `${d('x')} \\cdot ${d('z')}`, `${d('x')} \\cdot ${d('y')}`],
    // Les réglages de départ, en unités des curseurs (degrés), et
    // l'élément de surface montré d'abord.
    départ: { point: [2, 3, 2.5], élément: [1, 1.5, 1], accroissements: [1.5, 1.5, 1.2], surface: 2 },

    /** Ce qui repère le point : ses projections sur les axes. */
    construction([x, y, z]) {
        const M = vecteur(x, y, z);
        const H = vecteur(x, y, 0);
        return {
            pointillés: [[M, H], [H, vecteur(x, 0, 0)], [H, vecteur(0, y, 0)], [M, vecteur(0, 0, z)]],
            cotes: [
                [0, 'x', vecteur(x, -0.35, -0.2)],
                [1, 'y', vecteur(-0.35, y, -0.2)],
                [2, 'z', vecteur(-0.3, -0.3, z)],
            ],
            arcs: [],
        };
    },
};

// -- Coordonnées cylindriques ------------------------------------------------

// Les directions du plan (O x y) qui font l'angle α avec (O x), et leur
// perpendiculaire : e_r et e_θ des cylindriques, e_φ des sphériques.
const radial = (α) => vecteur(Math.cos(α), Math.sin(α), 0);
const orthoradial = (α) => vecteur(-Math.sin(α), Math.cos(α), 0);

const cylindriques = {
    coordonnées: [longueur('r', 0), angle('\\theta', 359, 180), longueur('z')],
    position: ([r, θ, z]) => radial(θ).multiplyScalar(r).setZ(z),
    base: ([, θ]) => [radial(θ), orthoradial(θ), Z],
    vecteurs: ['\\vec{e}_r', '\\vec{e}_\\theta', '\\vec{e}_z'],
    OM: '\\overrightarrow{OM} = r\\,\\vec{e}_r + z\\,\\vec{e}_z',
    arêtes: [[d('r'), []], [`r\\,${d('\\theta')}`, [0]], [d('z'), []]],
    volume: `${d('V')} = ${d('r')} \\cdot r \\cdot ${d('\\theta')} \\cdot ${d('z')}`,
    surfaces: [
        `r \\cdot ${d('\\theta')} \\cdot ${d('z')}`,
        `${d('r')} \\cdot ${d('z')}`,
        `${d('r')} \\cdot r \\cdot ${d('\\theta')}`,
    ],
    départ: { point: [3, 60, 2], élément: [2, 30, 1], accroissements: [1, 40, 1.2], surface: 0 },

    /** La distance à l'axe (O z), l'angle depuis (O x) dans le plan (O x y),
     *  et la cote. */
    construction([r, θ, z]) {
        const M = cylindriques.position([r, θ, z]);
        const H = cylindriques.position([r, θ, 0]);
        return {
            pointillés: [[ORIGINE, H], [H, M]],
            cotes: [
                [0, 'r', milieu(ORIGINE, H).addScaledVector(orthoradial(θ), -0.3)],
                [2, 'z', milieu(H, M).addScaledVector(radial(θ), 0.3)],
            ],
            arcs: [[1, '\\theta', ORIGINE, X, Y, θ, 1]],
        };
    },

    // Le cylindre creux : l'élément de volume étendu à tout un tour et à
    // toute la hauteur — r de r à r + dr, θ de 0 à 2π, z de 0 à h.
    creux: {
        nom: 'Cylindre creux',
        volume: `${d('V')} = 2\\pi r h \\, ${d('r')}`,
        dimensions: [dimension('r', 0, 1, 3), dimension(d('r'), 0, 0.05, 1.5), dimension('h', 2, 0.5, 4)],
        départ: [2, 0.5, 2.5],
        // Le centre de la vue de départ, et ce qu'elle embrasse.
        vue: { cible: [0, 0, 1.6], taille: 9 },

        /**
         * Ses faces, nappes de [0, 1]² (les deux parois, les deux couronnes) ;
         * ses bords, avec la coordonnée qui varie le long d'eux (les quatre
         * cercles) ; ses cotes, avec la coordonnée qu'elles mesurent, le
         * segment qui les porte, un point dont elles s'écartent et, pour r,
         * des pointillés — sur la couronne du haut et sur une génératrice.
         */
        construction([r, dr, h]) {
            const p = (ρ, θ, z) => cylindriques.position([ρ, θ, z]);
            const tour = 2 * Math.PI;
            const α = Math.PI / 2;
            return {
                faces: [
                    (s, t) => p(r, s * tour, t * h),
                    (s, t) => p(r + dr, s * tour, t * h),
                    (s, t) => p(r + s * dr, t * tour, 0),
                    (s, t) => p(r + s * dr, t * tour, h),
                ],
                bords: [r, r + dr].flatMap((ρ) => [0, h].map((z) => [1, (t) => p(ρ, t * tour, z)])),
                aides: [],
                centre: p(0, α, h),
                cotes: [
                    [0, 'r', [p(0, α, h), p(r, α, h)], ORIGINE, true],
                    [0, d('r'), [p(r, α, h), p(r + dr, α, h)], ORIGINE],
                    [2, 'h', [p(r + dr, α, 0), p(r + dr, α, h)], p(0, α, h / 2)],
                ],
            };
        },
    },
};

// -- Coordonnées sphériques --------------------------------------------------

const e_r = (θ, φ) => vecteur(Math.sin(θ) * Math.cos(φ), Math.sin(θ) * Math.sin(φ), Math.cos(θ));
const e_θ = (θ, φ) => vecteur(Math.cos(θ) * Math.cos(φ), Math.cos(θ) * Math.sin(φ), -Math.sin(θ));

const spheriques = {
    coordonnées: [longueur('r', 0), angle('\\theta', 180, 90, true), angle('\\varphi', 359, 180)],
    position: ([r, θ, φ]) => e_r(θ, φ).multiplyScalar(r),
    base: ([, θ, φ]) => [e_r(θ, φ), e_θ(θ, φ), orthoradial(φ)],
    vecteurs: ['\\vec{e}_r', '\\vec{e}_\\theta', '\\vec{e}_\\varphi'],
    OM: '\\overrightarrow{OM} = r\\,\\vec{e}_r',
    arêtes: [[d('r'), []], [`r\\,${d('\\theta')}`, [0]], [`r\\sin\\theta\\,${d('\\varphi')}`, [0, 1]]],
    volume: `${d('V')} = r^2 \\sin\\theta \\cdot ${d('r')} \\cdot ${d('\\theta')} \\cdot ${d('\\varphi')}`,
    surfaces: [
        `r^2 \\sin\\theta \\cdot ${d('\\theta')} \\cdot ${d('\\varphi')}`,
        `r \\sin\\theta \\cdot ${d('r')} \\cdot ${d('\\varphi')}`,
        `r \\cdot ${d('r')} \\cdot ${d('\\theta')}`,
    ],
    départ: { point: [3.5, 50, 60], élément: [2.5, 55, 70], accroissements: [0.8, 30, 40], surface: 0 },

    /** La distance à l'origine, l'angle depuis (O z), et l'angle depuis (O x)
     *  du projeté dans le plan (O x y). */
    construction([r, θ, φ]) {
        const M = spheriques.position([r, θ, φ]);
        const H = vecteur(M.x, M.y, 0);
        return {
            pointillés: [[ORIGINE, M], [ORIGINE, H], [H, M]],
            cotes: [[0, 'r', milieu(ORIGINE, M).addScaledVector(e_θ(θ, φ), 0.3)]],
            arcs: [
                [1, '\\theta', ORIGINE, Z, radial(φ), θ, 1.3],
                [2, '\\varphi', ORIGINE, X, Y, φ, 1],
            ],
        };
    },

    // La boule creuse : l'élément de volume étendu à toutes les directions —
    // r de r à r + dr, θ de 0 à π, φ de 0 à 2π.
    creux: {
        nom: 'Boule creuse',
        volume: `${d('V')} = 4\\pi r^2 \\, ${d('r')}`,
        dimensions: [dimension('r', 0, 1, 3), dimension(d('r'), 0, 0.05, 1.5)],
        départ: [2.2, 0.5],
        vue: { cible: [0, 0, 0.4], taille: 10 },

        /** Deux sphères, qui n'ont pas de bord : leurs équateurs aident l'œil.
         *  Les cotes sont sur un rayon du plan (O y z). */
        construction([r, dr]) {
            const p = (ρ, θ, φ) => spheriques.position([ρ, θ, φ]);
            const tour = 2 * Math.PI;
            const [θ, φ] = [Math.PI / 3, Math.PI / 2];
            const loin = p(r, θ + Math.PI / 2, φ);
            return {
                faces: [r, r + dr].map((ρ) => (s, t) => p(ρ, s * Math.PI, t * tour)),
                bords: [],
                aides: [r, r + dr].map((ρ) => (t) => p(ρ, Math.PI / 2, t * tour)),
                centre: ORIGINE,
                cotes: [
                    [0, 'r', [ORIGINE, p(r, θ, φ)], loin, true],
                    [0, d('r'), [p(r, θ, φ), p(r + dr, θ, φ)], loin],
                ],
            };
        },
    },
};

export const SYSTÈMES = { cartesiennes, cylindriques, spheriques };
