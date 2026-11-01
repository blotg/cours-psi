// Le champ d'une spire circulaire, et le flux qui la traverse : de quoi
// tracer les lignes de champ de spires coaxiales, et de ce qu'on en fait —
// un solénoïde, un aimant (une nappe de courant sur sa surface latérale).
//
// En unités où μ₀I = 1. Le point est repéré par sa distance r à l'axe et par
// sa cote ζ par rapport au plan de la spire ; dans un plan qui contient l'axe,
// les lignes de champ sont les lignes de niveau de ψ = r A_θ, dont 2πψ est le
// flux à travers le disque de rayon r.

/**
 * Les intégrales elliptiques complètes K(m) et E(m), de paramètre m = k²,
 * par la moyenne arithmético-géométrique : quelques itérations suffisent à la
 * précision de la machine.
 */
export function elliptiques(m) {
    let a = 1;
    let b = Math.sqrt(1 - m);
    let somme = m / 2;
    let puissance = 1;
    for (let i = 0; i < 30 && Math.abs(a - b) > 1e-15 * a; i++) {
        const c = (a - b) / 2;
        [a, b] = [(a + b) / 2, Math.sqrt(a * b)];
        somme += puissance * c * c;
        puissance *= 2;
    }
    const K = Math.PI / (2 * a);
    return [K, K * (1 - somme)];
}

/** Le paramètre m des intégrales pour une spire de rayon a, au point de
 *  rayon r et de cote ζ par rapport à la spire ; sur le fil, m = 1. */
const paramètre = (a, r, D2) => Math.min((4 * a * r) / D2, 1 - 1e-15);

/** Le champ d'une spire de rayon a, au point de rayon r et de cote ζ par
 *  rapport à elle : [B_r, B_z], en unités de μ₀I par centimètre. */
export function champDUneSpire(a, r, ζ) {
    const D2 = (a + r) ** 2 + ζ * ζ;
    const D = Math.sqrt(D2);
    const d2 = (a - r) ** 2 + ζ * ζ;
    const [K, E] = elliptiques(paramètre(a, r, D2));
    const bz = (K + ((a * a - r * r - ζ * ζ) / d2) * E) / (2 * Math.PI * D);
    // Sur l'axe, la composante radiale est nulle par symétrie.
    const br = r < 1e-9 ? 0 : (ζ * (-K + ((a * a + r * r + ζ * ζ) / d2) * E)) / (2 * Math.PI * r * D);
    return [br, bz];
}

/**
 * ψ = r A_θ pour une spire de rayon a : 2πψ est le flux de son champ à
 * travers le disque de rayon r, à la cote ζ. Près de l'axe, le crochet se
 * perd dans les arrondis — deux nombres voisins de π/2 qui se retranchent —
 * et l'on prend son développement, πm²(1 + 3m/4)/32.
 */
export function fluxDUneSpire(a, r, ζ) {
    const D2 = (a + r) ** 2 + ζ * ζ;
    const m = paramètre(a, r, D2);
    let crochet;
    if (m < 1e-3) {
        crochet = ((Math.PI * m * m) / 32) * (1 + (3 * m) / 4);
    } else {
        const [K, E] = elliptiques(m);
        crochet = (1 - m / 2) * K - E;
    }
    return (Math.sqrt(D2) / (2 * Math.PI)) * crochet;
}
