// Un dipôle R-L série sous une tension constante : tout ce dont les deux
// pages ont besoin pour écrire leurs régimes périodiques sans rien intégrer
// pas à pas. Entre deux commutations, le courant relaxe vers v/R avec la
// constante de temps L/R ; sans résistance il est affine, sans inductance il
// suit la tension.
//
// Le dipôle se donne par { R, L, f } — ohms, henrys, hertz —, et les durées
// se comptent en périodes T = 1/f, comme le temps des chronogrammes.

/** Le courant au bout de la durée d, parti de i0, sous la tension v. */
export function évolue(i0, v, d, { R, L, f }) {
    if (L === 0) return v / R;
    if (R === 0) return i0 + (v * d) / (L * f);
    return v / R + (i0 - v / R) * Math.exp((-d * R) / (L * f));
}

/** L'intégrale du courant sur la durée d : des ampères-périodes, donc sa
 *  contribution à une valeur moyenne. */
export function intégrale(i0, v, d, { R, L, f }) {
    if (L === 0) return (v / R) * d;
    if (R === 0) return i0 * d + (v * d * d) / (2 * L * f);
    const τ = (L * f) / R;
    return (v / R) * d + (i0 - v / R) * τ * (1 - Math.exp(-d / τ));
}

/** Les instants où tracer le courant entre t0 et t1 : deux pour un segment,
 *  assez pour une exponentielle. */
export function instants(t0, t1, { R, L, f }, minimum = 1) {
    const affine = R === 0 || L === 0;
    const n = Math.max(minimum, affine ? 1 : Math.min(24, Math.ceil((12 * (t1 - t0) * R) / (L * f))));
    return Array.from({ length: n + 1 }, (_, k) => t0 + ((t1 - t0) * k) / n);
}
