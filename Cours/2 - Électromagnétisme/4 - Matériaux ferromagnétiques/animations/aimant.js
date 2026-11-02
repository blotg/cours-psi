// Le champ d'un aimant droit, d'une spire et d'un dipôle de même moment
// magnétique, dans un plan qui contient leur axe (Oy) : les figures du poly
// (Simulations/lib.py), aux mêmes dimensions et aux mêmes niveaux.
//
// Les lignes de champ sont les lignes de niveau de F = x A_φ, x étant la
// distance à l'axe : 2πF est le flux à travers le disque de rayon x. Les
// longueurs se comptent en rayons de la spire, le moment vaut 1 et F est en
// unités de μ₀/4π : loin des trois objets, leurs F se confondent.

import { fluxDUneSpire } from '#animations/spires.js';

/** Le rayon et la hauteur de l'aimant, en rayons de la spire. */
export const AIMANT = { rayon: 0.4, hauteur: 2 };

/** Le rayon du disque qui figure le dipôle. */
export const DIPÔLE = 0.4;

/**
 * Les niveaux tracés : la k-ième ligne du dipôle coupe son plan équatorial à
 * la distance 12/k. Seize lignes pour la spire et l'aimant ; trente pour le
 * dipôle, qui descendent jusqu'au bord de son disque.
 */
export const niveaux = (n) => Array.from({ length: n }, (_, k) => (k + 1) / 12);

/** F d'un dipôle de moment 1 selon +y, placé en O. */
export function fluxDuDipôle(x, y) {
    const r2 = x * x + y * y;
    return (x * x) / (r2 * Math.sqrt(r2));
}

/**
 * F d'une spire de rayon 1 et de moment 1 (I = 1/π) : μ₀I ψ avec μ₀ = 4π
 * dans ces unités, ψ étant le flux réduit de spires.js.
 */
export function fluxDeLaSpire(x, y) {
    return 4 * fluxDUneSpire(1, Math.abs(x), y);
}

/**
 * F d'un aimant cylindrique d'aimantation uniforme M selon +y, centré en O :
 * il équivaut à une nappe de courant M sur sa surface latérale, découpée ici
 * en `n` spires régulièrement espacées. M vaut 1/(πR²L), pour un moment égal
 * à 1.
 *
 * Il faut que les spires soient plus serrées que la grille n'approche la
 * nappe : à 64, la carte ondulait le long du flanc, et faisait des lacets à
 * ses lignes les plus proches. À 200, on n'y voit plus que le champ.
 */
export function fluxDeLAimant(n = 200) {
    const { rayon: R, hauteur: L } = AIMANT;
    const M = 1 / (Math.PI * R * R * L);
    // Le courant de chaque spire, M L/n, fois μ₀ = 4π.
    const μ0I = (4 * Math.PI * M * L) / n;
    const cotes = Array.from({ length: n }, (_, k) => -L / 2 + ((k + 0.5) * L) / n);
    return (x, y) => {
        let F = 0;
        for (const cote of cotes) F += fluxDUneSpire(R, Math.abs(x), y - cote);
        return μ0I * F;
    };
}

/**
 * F sur une grille du cadre, au sens de carte.js. F est paire en x et en y :
 * on n'en calcule qu'un quart, le reste s'en déduit.
 */
export function grilleDeFlux(F, cadre, colonnes) {
    const lignes = Math.round((colonnes * (cadre.y1 - cadre.y0)) / (cadre.x1 - cadre.x0));
    const valeurs = new Float64Array(colonnes * lignes);
    for (let j = 0; j < Math.ceil(lignes / 2); j++) {
        const y = cadre.y0 + ((cadre.y1 - cadre.y0) * j) / (lignes - 1);
        for (let i = 0; i < Math.ceil(colonnes / 2); i++) {
            const x = cadre.x0 + ((cadre.x1 - cadre.x0) * i) / (colonnes - 1);
            const v = F(x, y);
            for (const jj of [j, lignes - 1 - j]) {
                for (const ii of [i, colonnes - 1 - i]) valeurs[jj * colonnes + ii] = v;
            }
        }
    }
    return { colonnes, lignes, cadre, valeurs };
}
