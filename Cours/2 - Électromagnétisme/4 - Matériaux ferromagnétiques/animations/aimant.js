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
 * Les n nœuds et poids de la méthode de Gauss-Legendre sur [−1, 1] : les
 * racines du polynôme de Legendre P_n, par la méthode de Newton.
 */
function gaussLegendre(n) {
    const nœuds = [];
    const poids = [];
    for (let i = 1; i <= n; i++) {
        let x = Math.cos((Math.PI * (i - 0.25)) / (n + 0.5));
        let dérivée = 1;
        for (let itération = 0; itération < 100; itération++) {
            // P_n(x) et P_{n−1}(x) par la relation de récurrence.
            let [p0, p1] = [1, x];
            for (let k = 2; k <= n; k++) [p0, p1] = [p1, ((2 * k - 1) * x * p1 - (k - 1) * p0) / k];
            dérivée = (n * (x * p1 - p0)) / (x * x - 1);
            const pas = p1 / dérivée;
            x -= pas;
            if (Math.abs(pas) < 1e-15) break;
        }
        nœuds.push(x);
        poids.push(2 / ((1 - x * x) * dérivée * dérivée));
    }
    return { nœuds, poids };
}

/**
 * F d'un aimant cylindrique d'aimantation uniforme M selon +y, centré en O :
 * il équivaut à une nappe de courant M sur sa surface latérale, découpée ici
 * en `n` spires placées aux nœuds de Gauss-Legendre. M vaut 1/(πR²L), pour un
 * moment égal à 1.
 */
export function fluxDeLAimant(n = 64) {
    const { rayon: R, hauteur: L } = AIMANT;
    const M = 1 / (Math.PI * R * R * L);
    const { nœuds, poids } = gaussLegendre(n);
    // Le courant de chaque spire, et μ₀ = 4π.
    const spires = nœuds.map((z, k) => [(z * L) / 2, 4 * Math.PI * ((M * L) / 2) * poids[k]]);
    return (x, y) => {
        let F = 0;
        for (const [cote, μ0I] of spires) F += μ0I * fluxDUneSpire(R, Math.abs(x), y - cote);
        return F;
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
