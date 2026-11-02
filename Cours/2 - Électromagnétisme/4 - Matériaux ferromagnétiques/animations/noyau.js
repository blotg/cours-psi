// Le noyau d'un transformateur à vide : son cycle d'hystérésis B(H), et le
// courant qu'il faut pour y imposer un champ sinusoïdal.
//
// Le réseau impose la tension, et u = N S dB/dt : le champ dans le noyau est
// sinusoïdal, quel que soit le matériau. C'est l'excitation qui ne l'est pas,
// et le courant avec elle, puisque H l = N i.
//
// Les cycles suivent le modèle de Takács : chaque branche est une somme de
// tangentes hyperboliques, décalées de ±H_c, et relevées juste assez pour que
// la branche montante et la branche descendante se rejoignent aux extrémités
// du cycle, (−H_m, −B_m) et (H_m, B_m). Le cycle se ferme ainsi à toute
// amplitude, s'amincit quand elle diminue, et chaque branche se renverse : à
// un champ B donné, on sait trouver l'excitation H.
//
// B en teslas, H en ampères par mètre.

const MU0 = 4e-7 * Math.PI;

/**
 * Les matériaux, par les termes [B_k, H_k, H_c,k] de leur branche montante,
 *
 *     B(H) = Σ B_k th((H − H_c,k)/H_k) + b_k + μ₀ H,
 *
 * ou par leur perméabilité s'ils sont linéaires. Le premier terme fait
 * l'essentiel du champ, et le coude de la saturation ; le second, la lente
 * approche de la saturation que l'on mesure sur une tôle de fer au silicium
 * (environ 1,5 T à 1 kA/m, 2 T à 10 kA/m). Le matériau linéaire a la
 * perméabilité du saturable aux champs faibles, μ_r ≈ 7 800.
 */
export const MATÉRIAUX = {
    linéaire: { μ: 1.45 / 150 + 0.55 / 5000 + MU0 },
    saturable: {
        termes: [
            [1.45, 150, 0],
            [0.55, 5000, 0],
        ],
    },
    doux: {
        termes: [
            [1.45, 150, 40],
            [0.55, 5000, 0],
        ],
    },
    dur: {
        termes: [
            [1.4, 300, 1500],
            [0.6, 8000, 0],
        ],
    },
};

/** Le relèvement b_k d'un terme, qui ferme le cycle d'amplitude H_m. */
const relèvement = ([B, H, Hc], Hm) => (B / 2) * (Math.tanh((Hm + Hc) / H) - Math.tanh((Hm - Hc) / H));

/** La branche montante du cycle d'amplitude H_m, en H. */
export function montante(matériau, Hm, H) {
    if (matériau.μ) return matériau.μ * H;
    let B = MU0 * H;
    for (const terme of matériau.termes) {
        const [Bk, Hk, Hc] = terme;
        B += Bk * Math.tanh((H - Hc) / Hk) + relèvement(terme, Hm);
    }
    return B;
}

/** La branche descendante, symétrique de la montante par rapport à O. */
export const descendante = (matériau, Hm, H) => -montante(matériau, Hm, -H);

/** La racine d'une fonction croissante sur [a, b], par dichotomie. */
function racine(f, a, b) {
    for (let k = 0; k < 60; k++) {
        const m = (a + b) / 2;
        if (f(m) < 0) a = m;
        else b = m;
    }
    return (a + b) / 2;
}

/** L'amplitude H_m de l'excitation qui porte le champ à B_m. */
export function amplitude(matériau, Bm) {
    if (Bm <= 0) return 0;
    if (matériau.μ) return Bm / matériau.μ;
    let haut = 1;
    while (montante(matériau, haut, haut) < Bm) haut *= 2;
    return racine((Hm) => montante(matériau, Hm, Hm) - Bm, 0, haut);
}

/**
 * Une période du régime établi, B = B_m sin φ, échantillonnée en n phases :
 * le champ, l'excitation (sur la branche montante tant que B croît), et
 * l'aire du cycle, ∮ H dB, en joules par mètre cube.
 */
export function période(matériau, Bm, n = 400) {
    const Hm = amplitude(matériau, Bm);
    const B = new Float64Array(n + 1);
    const H = new Float64Array(n + 1);
    for (let k = 0; k <= n; k++) {
        const φ = (2 * Math.PI * k) / n;
        B[k] = Bm * Math.sin(φ);
        if (Hm === 0) continue;
        const croît = Math.cos(φ) > 0;
        const branche = croît ? montante : descendante;
        H[k] = racine((h) => branche(matériau, Hm, h) - B[k], -Hm, Hm);
    }
    let aire = 0;
    for (let k = 0; k < n; k++) aire += ((H[k] + H[k + 1]) / 2) * (B[k + 1] - B[k]);
    return { Hm, B, H, aire, n };
}
