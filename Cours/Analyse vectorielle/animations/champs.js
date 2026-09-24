// Les champs de la page, et les opérateurs qu'on leur applique.
//
// Tous sont plans : ils ne dépendent que de x et de y, et un champ vectoriel
// reste dans le plan de l'écran (A_z = 0). Le gradient et le laplacien
// vectoriel y restent donc aussi, et le rotationnel est porté par e_z — il
// sort de l'écran ou s'y enfonce.
//
// Les opérateurs se calculent par différences finies centrées, sur n'importe
// quel champ : une page qui voudrait un champ de plus n'a qu'à l'écrire. Ils
// ne s'annulent donc jamais tout à fait, d'où `SEUIL`.

/** Le pas des dérivées premières, et celui des dérivées secondes : assez
 *  grand pour que les arrondis ne l'emportent pas sur la différence. */
const H1 = 1e-4;
const H2 = 1e-3;

/**
 * En deçà de cette fraction de l'échelle du champ — l'écart entre ses valeurs
 * extrêmes sur la carte, ou la norme de son plus grand vecteur —, un
 * opérateur est nul. La carte faisant douze unités de large, une dérivée y est
 * de l'ordre du champ lui-même, et le bruit des différences finies n'en
 * dépasse pas 2·10⁻⁹ (la divergence d'un tourbillon, le laplacien d'un col).
 *
 * Le seuil se prend sur le champ, jamais sur l'opérateur : la divergence d'un
 * tourbillon n'est faite que de bruit, et rapportée à son propre maximum —
 * du bruit aussi —, elle couvrirait la carte de disques.
 */
export const SEUIL = 1e-6;

// -- Les opérateurs ------------------------------------------------------------

/** grad f, par différences centrées. */
export function gradient(f, x, y, h = H1) {
    return [(f(x + h, y) - f(x - h, y)) / (2 * h), (f(x, y + h) - f(x, y - h)) / (2 * h)];
}

/** Δf = ∂²f/∂x² + ∂²f/∂y², sur cinq points. */
export function laplacien(f, x, y, h = H2) {
    return (f(x + h, y) + f(x - h, y) + f(x, y + h) + f(x, y - h) - 4 * f(x, y)) / (h * h);
}

/** div A = ∂A_x/∂x + ∂A_y/∂y. */
export function divergence(A, x, y, h = H1) {
    return (A(x + h, y)[0] - A(x - h, y)[0] + A(x, y + h)[1] - A(x, y - h)[1]) / (2 * h);
}

/** La composante de rot A sur e_z, la seule d'un champ plan :
 *  ∂A_y/∂x − ∂A_x/∂y. */
export function rotationnel(A, x, y, h = H1) {
    return (A(x + h, y)[1] - A(x - h, y)[1] - A(x, y + h)[0] + A(x, y - h)[0]) / (2 * h);
}

/** Δ⃗A = (ΔA_x, ΔA_y), composante par composante. */
export function laplacienVectoriel(A, x, y) {
    return [0, 1].map((k) => laplacien((u, v) => A(u, v)[k], x, y));
}

// -- Les champs scalaires --------------------------------------------------------

/** Une bosse gaussienne de hauteur `h`, centrée en (x₀, y₀), de largeur² `l2`. */
const bosse = (h, x0, y0, l2) => (x, y) => h * Math.exp(-((x - x0) ** 2 + (y - y0) ** 2) / l2);

const relief = [bosse(1, -2.6, 1, 2.2), bosse(0.7, -0.4, -1.9, 1.3), bosse(-1, 2.6, 0.4, 2.6)];

/**
 * Les champs scalaires, chacun avec son nom et sa formule. On
 * passe de l'un à l'autre du plus simple au plus quelconque : un gradient
 * uniforme, un laplacien uniforme, un laplacien nul malgré la courbure, un
 * laplacien qui change de signe.
 */
export const SCALAIRES = {
    pente: {
        nom: '\\text{pente}',
        tex: 'f = x + \\frac{y}{2}',
        f: (x, y) => x + y / 2,
    },
    cuvette: {
        nom: '\\text{cuvette}',
        tex: 'f = x^2 + y^2',
        f: (x, y) => x * x + y * y,
    },
    col: {
        nom: '\\text{col}',
        tex: 'f = x^2 - y^2',
        f: (x, y) => x * x - y * y,
    },
    colline: {
        nom: '\\text{colline}',
        tex: 'f = e^{-(x^2 + y^2)/4}',
        f: bosse(1, 0, 0, 4),
    },
    relief: {
        nom: '\\text{quelconque}',
        tex: '',
        f: (x, y) => relief.reduce((somme, b) => somme + b(x, y), 0),
    },
};

// -- Les champs vectoriels -------------------------------------------------------

/**
 * Le profil d'un tube de rayon R : A = k(r²) OM⃗, avec
 * k = R² (1 − e^{−r²/R²}) / r². Linéaire au cœur (k → 1), en 1/r au loin.
 * Un champ radial de ce profil a pour divergence 2 e^{−r²/R²}, un champ
 * orthoradial le même rotationnel : ce sont le champ électrique d'un cylindre
 * chargé et le champ magnétique d'un fil épais, sans l'arête qu'aurait une
 * densité uniforme — où la dérivée seconde serait infinie.
 */
function tube(R2, x, y) {
    const u = (x * x + y * y) / R2;
    return u === 0 ? 1 : -Math.expm1(-u) / u;
}

const R2 = 1.5 ** 2;

/** Une source (s > 0) ou un puits de rayon R, centré en (x₀, y₀). */
const source = (s, x0, y0, r2) => (x, y) => {
    const k = s * tube(r2, x - x0, y - y0);
    return [k * (x - x0), k * (y - y0)];
};

/** Un tourbillon, dans le sens trigonométrique si s > 0. */
const tourbillon = (s, x0, y0, r2) => (x, y) => {
    const k = s * tube(r2, x - x0, y - y0);
    return [-k * (y - y0), k * (x - x0)];
};

const quelconque = [
    source(1, -3, 1, 1),
    source(-0.8, 0.3, -1.6, 1),
    tourbillon(1, 3, 1.2, 1),
    tourbillon(-0.6, -0.8, 2.1, 0.8),
];

/** Les champs vectoriels : deux tubes qui ne font qu'un opérateur chacun,
 *  deux écoulements, et un champ quelconque. */
export const VECTORIELS = {
    source: {
        nom: '\\text{source}',
        tex: '\\vec A = \\frac{R^2}{r}\\left(1 - e^{-r^2/R^2}\\right)\\vec e_r',
        A: source(1, 0, 0, R2),
    },
    tourbillon: {
        nom: '\\text{tourbillon}',
        tex: '\\vec A = \\frac{R^2}{r}\\left(1 - e^{-r^2/R^2}\\right)\\vec e_\\theta',
        A: tourbillon(1, 0, 0, R2),
    },
    cisaillement: {
        nom: '\\text{cisaillement}',
        tex: '\\vec A = y\\,\\vec e_x',
        A: (x, y) => [y, 0],
    },
    jet: {
        nom: '\\text{jet}',
        tex: '\\vec A = e^{-y^2/2}\\,\\vec e_x',
        A: (x, y) => [Math.exp(-(y * y) / 2), 0],
    },
    quelconque: {
        nom: '\\text{quelconque}',
        tex: '',
        A: (x, y) =>
            quelconque.reduce(
                (somme, a) => {
                    const [ax, ay] = a(x, y);
                    return [somme[0] + ax, somme[1] + ay];
                },
                [0.25, 0.1],
            ),
    },
};
