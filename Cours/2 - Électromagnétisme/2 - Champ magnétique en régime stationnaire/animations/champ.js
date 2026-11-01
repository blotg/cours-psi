// Le champ magnétique des distributions du chapitre, et de quoi en tracer les
// lignes de champ comme des lignes de niveau.
//
// Deux familles :
//
//   - des fils rectilignes infinis perpendiculaires à l'écran. Leurs courants
//     se comptent en ampères, positifs vers le lecteur, et les longueurs en
//     centimètres : le champ sort en teslas. Les lignes de champ sont les
//     lignes de niveau du potentiel vecteur A_z (B = rot(A_z e_z)), et le
//     flux qui passe entre deux d'entre elles, par mètre de fil, est l'écart
//     de A_z : des niveaux régulièrement espacés font une carte à flux
//     constant ;
//   - des spires circulaires coaxiales, d'axe (Oz). En unités où μ₀I = 1,
//     longueurs en centimètres. Les lignes de champ, dans un plan qui
//     contient l'axe, sont les lignes de niveau de ψ = r A_θ, dont 2πψ est
//     le flux à travers le disque de rayon r.

// Le champ et le flux d'une spire seule sont dans la bibliothèque commune
// (spires.js) : le chapitre des matériaux ferromagnétiques s'en sert aussi.
import { champDUneSpire, fluxDUneSpire } from '#animations/spires.js';

/** μ₀/2π, en unités SI. */
const MU0_SUR_2PI = 2e-7;

// -- Fils rectilignes ----------------------------------------------------------

/** Le champ créé en (x, y) par les fils `{ x, y, I }`, en teslas. */
export function champDesFils(fils, x, y) {
    let bx = 0;
    let by = 0;
    for (const fil of fils) {
        const dx = x - fil.x;
        const dy = y - fil.y;
        const r2 = dx * dx + dy * dy;
        if (r2 < 1e-12) continue;
        // μ₀I/(2πr) e_θ, avec r en centimètres : un facteur 100.
        const facteur = (100 * MU0_SUR_2PI * fil.I) / r2;
        bx -= facteur * dy;
        by += facteur * dx;
    }
    return [bx, by];
}

/** Le potentiel vecteur A_z en (x, y), en microwebers par mètre, nul à un
 *  centimètre d'un fil seul. */
export function potentielDesFils(fils, x, y) {
    let a = 0;
    for (const fil of fils) {
        // Sur le fil lui-même, A_z diverge : on ne l'y calcule pas.
        const r = Math.max(Math.hypot(x - fil.x, y - fil.y), 1e-4);
        a -= 1e6 * MU0_SUR_2PI * fil.I * Math.log(r);
    }
    return a;
}

// -- Spires --------------------------------------------------------------------

/** Le champ de spires de rayon a, aux cotes `cotes`, au point (z, r) :
 *  [B_r, B_z]. */
export function champDesSpires(a, cotes, z, r) {
    let br = 0;
    let bz = 0;
    for (const c of cotes) {
        const [dr, dz] = champDUneSpire(a, r, z - c);
        br += dr;
        bz += dz;
    }
    return [br, bz];
}

/** ψ pour des spires de rayon a, aux cotes `cotes`, au point (z, r). */
export function fluxDesSpires(a, cotes, z, r) {
    let ψ = 0;
    for (const c of cotes) ψ += fluxDUneSpire(a, r, z - c);
    return ψ;
}

/** Le champ sur l'axe, μ₀Ia²/(2(a² + ζ²)^{3/2}) par spire : sans intégrale
 *  elliptique. */
export function champSurLAxe(a, cotes, z) {
    let bz = 0;
    for (const c of cotes) bz += (a * a) / (2 * (a * a + (z - c) ** 2) ** 1.5);
    return bz;
}
