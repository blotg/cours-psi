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
    // En O même, F diverge : un point de la grille peut y tomber.
    return r2 ? (x * x) / (r2 * Math.sqrt(r2)) : 1e9;
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
 * en spires régulièrement espacées. M vaut 1/(πR²L), pour un moment égal à 1.
 *
 * Il faut que les spires soient plus serrées que la distance du point à la
 * nappe : à 64 spires, la carte ondulait le long du flanc, et faisait des
 * lacets à ses lignes les plus proches. Mais deux cents spires partout
 * coûteraient trop dès que l'on dézoome : leur nombre suit donc la distance
 * à la nappe, de deux cents tout contre elle à douze au loin, où l'écart
 * entre deux spires reste six fois plus petit que la distance.
 */
export function fluxDeLAimant() {
    const { rayon: R, hauteur: L } = AIMANT;
    const M = 1 / (Math.PI * R * R * L);
    const découpages = [
        [0.1, 200],
        [0.3, 64],
        [1, 24],
        [Infinity, 12],
    ].map(([jusquÀ, n]) => ({
        jusquÀ,
        // Le courant de chaque spire, M L/n, fois μ₀ = 4π.
        μ0I: (4 * Math.PI * M * L) / n,
        cotes: Array.from({ length: n }, (_, k) => -L / 2 + ((k + 0.5) * L) / n),
    }));
    return (x, y) => {
        const r = Math.abs(x);
        // La distance au flanc, segment r = R, |y| ≤ L/2 du plan de coupe.
        const distance = Math.hypot(r - R, Math.max(Math.abs(y) - L / 2, 0));
        const { μ0I, cotes } = découpages.find((d) => distance < d.jusquÀ);
        let F = 0;
        for (const cote of cotes) F += fluxDUneSpire(R, r, y - cote);
        return μ0I * F;
    };
}
