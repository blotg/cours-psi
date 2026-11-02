// Le champ magnétique d'un circuit ferromagnétique bobiné, en deux dimensions :
// les mêmes circuits, et le même calcul, que les figures du poly
// (Simulations/lib.py).
//
// Tout est invariant selon z, les courants vont selon z : le champ dérive du
// potentiel vecteur A_z (B = rot(A_z e_z)), solution de
//
//     div( (1/μ_r) grad A_z ) = −μ₀ j_z,
//
// et les lignes de champ sont ses lignes de niveau. Le flux qui passe entre
// deux d'entre elles, par mètre de circuit selon z, est l'écart de A_z : des
// niveaux régulièrement espacés font une carte à flux constant.
//
// Les longueurs sont en mètres, les courants en ampères, A_z en webers par
// mètre et le champ en teslas.
//
// Le calcul se fait par volumes finis sur une grille de cellules, où le
// courant d'un fil se répartit au prorata de l'aire qu'il couvre. Chaque
// face entre deux cellules voisines laisse passer le « flux » k (A_p − A_q) :
// c'est ce qui assure la continuité de H tangentiel à la surface du fer.
// Trois choses changent par rapport au poly, pour que l'on puisse manipuler
// le circuit, et sa vue, sans attendre :
//
//   - la grille est fine dans la vue seulement, d'un pas proportionnel à sa
//     largeur (le calcul coûte autant à tout zoom), et ses pas grandissent
//     au-delà, jusqu'au bord lointain où A_z = 0 ;
//   - elle épouse le fer : une face de cellule tombe sur chaque bord de
//     rectangle, la plus proche déplacée jusqu'à lui, ou une de plus. Une
//     cellule n'est jamais à cheval sur le fer et l'air. Une cellule à cheval
//     perdait l'air qu'elle contenait, car le flux tourne en elle : avec un
//     quart de millimètre d'air dans une cellule de 1 mm, l'entrefer de 5 mm
//     de l'électroaimant en paraissait 4,75, et le champ y était trop fort
//     de 5 % ;
//   - le coefficient d'une face se calcule sur le fer qu'elle traverse,
//     comme un empilement de couches (cf. `coefficient`), ce qui sert encore
//     loin de la vue, où les rectangles ne sont pas tous épousés.
//
// Un entrefer d'un dixième de millimètre de plus ou de moins change donc le
// champ d'autant, quel que soit le pas : un curseur ne fait pas de marches.
//
// Le système est résolu par la méthode du gradient conjugué, préconditionnée
// par une factorisation de Cholesky incomplète modifiée (MIC(0)) : une
// soixantaine d'itérations, quelle que soit la perméabilité du fer. Avec
// μ_r = 10⁵, le fer et l'air diffèrent de cinq ordres de grandeur, et un
// préconditionnement par la seule diagonale en demanderait plus de sept cents.

export const MU0 = 4e-7 * Math.PI;

// -- Les circuits ---------------------------------------------------------------
//
// Un circuit se décrit par ses rectangles de fer [x₁, x₂, y₁, y₂], disjoints,
// et ses fils [x, y, rayon, I], I > 0 pour un courant qui vient vers nous.
// Ce sont ceux de Simulations/lib.py. S'y ajoute parfois un champ uniforme
// `fond` = [B_x, B_y], imposé au loin, et un point `centre` où l'on compare
// le champ avec et sans fer.

/** n fils de rayon r, régulièrement espacés de `début` à `fin`, parcourus
 *  chacun par I. */
function rangée([xa, ya], [xb, yb], n, r, I) {
    return Array.from({ length: n }, (_, k) => [xa + ((xb - xa) * k) / (n - 1), ya + ((yb - ya) * k) / (n - 1), r, I]);
}

/** Le bobinage : N_fils fils de rayon 2 mm de chaque côté du fer, à 2 mm de
 *  lui, pour N i ampères-tours en tout. */
const BOBINAGE = { fils: 10, rayon: 2e-3, écart: 2e-3 };

/**
 * Un circuit rectangulaire centré sur l'origine, de largeur a, de hauteur b,
 * de branches de largeur d, avec un entrefer d'épaisseur e au milieu de la
 * branche de droite (e = 0 : sans entrefer). Le bobinage entoure la branche
 * de gauche sur une hauteur `bobine`.
 */
export function circuit({ a = 0.1, b = 0.12, d = 0.02, e = 0, Ni = 500, bobine = 0.06 } = {}) {
    const fer = [
        [-a / 2, a / 2, b / 2 - d, b / 2],
        [-a / 2, a / 2, -b / 2, -b / 2 + d],
        [-a / 2, -a / 2 + d, -b / 2 + d, b / 2 - d],
    ];
    if (e > 0) {
        fer.push([a / 2 - d, a / 2, e / 2, b / 2 - d], [a / 2 - d, a / 2, -b / 2 + d, -e / 2]);
    } else {
        fer.push([a / 2 - d, a / 2, -b / 2 + d, b / 2 - d]);
    }
    const { fils: n, rayon: r, écart: g } = BOBINAGE;
    const dehors = -a / 2 - g - r;
    const dedans = -a / 2 + d + g + r;
    const fils = [
        ...rangée([dehors, -bobine / 2], [dehors, bobine / 2], n, r, Ni / n),
        ...rangée([dedans, -bobine / 2], [dedans, bobine / 2], n, r, -Ni / n),
    ];
    return { fer, fils, sonde: [a / 2 - d / 2, 0], centre: [-a / 2 + d / 2, 0], Ni, l: 2 * (a - d) + 2 * (b - d) - e };
}

/**
 * Un noyau droit, comme le clou de la situation déclenchante : un barreau de
 * longueur L et d'épaisseur d, centré sur l'origine, dans une bobine plus
 * courte que lui.
 */
export function noyauDroit({ L = 0.14, d = 0.012, Ni = 500, bobine = 0.06 } = {}) {
    const { fils: n, rayon: r, écart: g } = BOBINAGE;
    const y = d / 2 + g + r;
    const fils = [
        ...rangée([-bobine / 2, y], [bobine / 2, y], n, r, Ni / n),
        ...rangée([-bobine / 2, -y], [bobine / 2, -y], n, r, -Ni / n),
    ];
    return { fer: [[-L / 2, L / 2, -d / 2, d / 2]], fils, centre: [0, 0], Ni };
}

/**
 * Un blindage : un tube de section carrée, de côté a et de paroi d, dans un
 * champ uniforme B₀ selon x, imposé au loin.
 */
export function blindage({ a = 0.1, d = 0.008, B0 = 1e-3 } = {}) {
    const fer = [
        [-a / 2, a / 2, a / 2 - d, a / 2],
        [-a / 2, a / 2, -a / 2, -a / 2 + d],
        [-a / 2, -a / 2 + d, -a / 2 + d, a / 2 - d],
        [a / 2 - d, a / 2, -a / 2 + d, a / 2 - d],
    ];
    return { fer, fils: [], fond: [B0, 0], centre: [0, 0] };
}

/**
 * Un électroaimant : une pièce en U retournée, de largeur a, de hauteur b et
 * de branches de largeur d, le bas de ses branches en y = 0, bobinée sur sa
 * branche horizontale ; en face, un barreau de largeur a et d'épaisseur d,
 * centré en `barreau` = [x, y].
 */
export function électroaimant({ a = 0.1, b = 0.08, d = 0.02, Ni = 500, bobine = 0.05, barreau = [0, -0.015] } = {}) {
    const [xb, yb] = barreau;
    const fer = [
        [-a / 2, a / 2, b - d, b],
        [-a / 2, -a / 2 + d, 0, b - d],
        [a / 2 - d, a / 2, 0, b - d],
        [xb - a / 2, xb + a / 2, yb - d / 2, yb + d / 2],
    ];
    const { fils: n, rayon: r, écart: g } = BOBINAGE;
    const dessus = b + g + r;
    const dessous = b - d - g - r;
    const fils = [
        ...rangée([-bobine / 2, dessus], [bobine / 2, dessus], n, r, Ni / n),
        ...rangée([-bobine / 2, dessous], [bobine / 2, dessous], n, r, -Ni / n),
    ];
    // L'entrefer, sous la branche de gauche du U : le champ se mesure en son
    // milieu — au milieu de ce que la branche a en face d'elle, quand le
    // barreau est décalé sur le côté.
    const e = -(yb + d / 2);
    const [gauche, droite] = [Math.max(-a / 2, xb - a / 2), Math.min(-a / 2 + d, xb + a / 2)];
    const x = gauche < droite ? (gauche + droite) / 2 : -a / 2 + d / 2;
    return { fer, fils, sonde: [x, -e / 2], Ni, e };
}

// -- La grille ------------------------------------------------------------------

/**
 * Les abscisses des faces des cellules le long d'un axe : un pas h sur
 * [a, b] — la vue, où les lignes se tracent —, puis des pas qui grandissent
 * d'un facteur q de part et d'autre, jusqu'à dépasser `bas` et `haut`. Au-delà,
 * A_z = 0 : c'est le bord lointain du calcul.
 *
 * Puis chaque bord du fer devient une face : la plus proche s'y déplace si
 * elle n'en est pas à plus de 30 % du pas, et elle y reste ; sinon, on en
 * ajoute une. Un bord à moins de 5 % du pas d'une face déjà placée sur un
 * autre bord se confond avec elle : deux bords presque confondus feraient
 * une cellule minuscule, qui ralentirait la résolution.
 */
function faces(a, b, h, bas, haut, bords, q = 1.3) {
    const n = Math.max(1, Math.round((b - a) / h));
    const pas = (b - a) / n;
    const dedans = Array.from({ length: n + 1 }, (_, k) => a + k * pas);
    const dessous = [];
    const dessus = [];
    for (let p = pas, v = a; v > bas; ) {
        p *= q;
        dessous.push((v -= p));
    }
    for (let p = pas, v = b; v < haut; ) {
        p *= q;
        dessus.push((v += p));
    }
    const f = [...dessous.reverse(), ...dedans, ...dessus];
    const placée = f.map(() => false);
    for (const bord of [...new Set(bords)].sort((u, v) => u - v)) {
        if (bord <= f[0] || bord >= f.at(-1)) continue;
        const k = cellule(f, bord);
        const proche = bord - f[k] < f[k + 1] - bord ? k : k + 1;
        const local = Math.min(f[k + 1] - f[k], proche > 0 ? f[proche] - f[proche - 1] : Infinity, proche < f.length - 1 ? f[proche + 1] - f[proche] : Infinity);
        const écart = Math.abs(f[proche] - bord);
        if (placée[proche] && écart < 0.05 * local) continue;
        if (!placée[proche] && proche > 0 && proche < f.length - 1 && écart <= 0.3 * local) {
            f[proche] = bord;
            placée[proche] = true;
        } else {
            f.splice(k + 1, 0, bord);
            placée.splice(k + 1, 0, true);
        }
    }
    return Float64Array.from(f);
}

/** L'indice de la cellule qui contient v, parmi les faces f (bornée). */
function cellule(f, v) {
    let bas = 0;
    let haut = f.length - 1;
    while (haut - bas > 1) {
        const milieu = (bas + haut) >> 1;
        if (f[milieu] <= v) bas = milieu;
        else haut = milieu;
    }
    return bas;
}

/**
 * Le coefficient de la face entre deux cellules voisines : la face s'étend
 * de t₁ à t₂ en travers, et l'on va d'un centre à l'autre de l₁ à l₂.
 *
 * Le fer que l'on traverse ne change qu'aux bords des rectangles : entre
 * deux bords, chaque fibre de la face va de l₁ à l₂ à travers une longueur L
 * de fer, et c'est une association en série — 1/μ_r se moyenne en
 * harmonique le long de la fibre. Les fibres, elles, sont en parallèle.
 * `verticale` dit si la face est verticale (on la traverse selon x) ou
 * horizontale.
 */
function coefficient(fer, μr, t1, t2, l1, l2, verticale) {
    const bords = [t1, t2];
    for (const r of fer) {
        const [ta, tb] = verticale ? [r[2], r[3]] : [r[0], r[1]];
        if (ta > t1 && ta < t2) bords.push(ta);
        if (tb > t1 && tb < t2) bords.push(tb);
    }
    if (bords.length > 2) bords.sort((u, v) => u - v);
    let k = 0;
    for (let m = 0; m + 1 < bords.length; m++) {
        const [a, b] = [bords[m], bords[m + 1]];
        if (b <= a) continue;
        const t = (a + b) / 2;
        let L = 0;
        for (const r of fer) {
            const [ta, tb, la, lb] = verticale ? [r[2], r[3], r[0], r[1]] : [r[0], r[1], r[2], r[3]];
            if (t >= ta && t < tb) L += Math.max(0, Math.min(lb, l2) - Math.max(la, l1));
        }
        k += (b - a) / (l2 - l1 + (μr - 1) * L);
    }
    return k;
}

/**
 * Le calcul sur une grille, refaite à chaque fois que le fer ou la vue
 * bougent (cf. `maille`). Les tableaux sont bordés d'une rangée de cellules
 * fantômes, où A_z garde la valeur imposée au bord — 0, ou celle d'un champ
 * uniforme : les boucles n'ont pas à se soucier du bord.
 */
export class Grille {
    /**
     * La grille : fine de pas `h` dans le rectangle `vue` ({ x0, x1, y0, y1 }),
     * élargie jusqu'au bord du rectangle `domaine`, qui la contient — la vue
     * et le circuit tout entier, avec de la marge : quand on zoome sur un
     * coin, le reste du circuit compte encore. Ses faces épousent les bords
     * des rectangles de `fer`.
     *
     * Les tableaux ne changent que si le nombre de cellules change : A_z y
     * reste, et le calcul part de la solution précédente, faite sur une grille
     * voisine — c'est encore un bon point de départ.
     */
    maille(vue, h, domaine, fer) {
        this.fx = faces(vue.x0, vue.x1, h, domaine.x0, domaine.x1, fer.flatMap((r) => [r[0], r[1]]));
        this.fy = faces(vue.y0, vue.y1, h, domaine.y0, domaine.y1, fer.flatMap((r) => [r[2], r[3]]));
        const nx = (this.nx = this.fx.length - 1);
        const ny = (this.ny = this.fy.length - 1);
        const s = nx + 2;
        const N = s * (ny + 2);
        if (s !== this.s || N !== this.N) {
            // Les coefficients des faces ouest (O) et sud (S) de chaque
            // cellule, la diagonale, le second membre, la factorisation, A_z,
            // et les vecteurs du gradient conjugué.
            for (const nom of ['O', 'S', 'D', 'b', 'd', 'A', 'r', 'z', 'p', 'q']) this[nom] = new Float64Array(N);
            Object.assign(this, { s, N });
        }
        // Les centres des cellules ; ceux des fantômes sont sur le bord.
        this.xc = new Float64Array(nx + 2);
        this.yc = new Float64Array(ny + 2);
        for (let i = 0; i < nx; i++) this.xc[i + 1] = (this.fx[i] + this.fx[i + 1]) / 2;
        for (let j = 0; j < ny; j++) this.yc[j + 1] = (this.fy[j] + this.fy[j + 1]) / 2;
        [this.xc[0], this.xc[nx + 1], this.yc[0], this.yc[ny + 1]] = [this.fx[0], this.fx[nx], this.fy[0], this.fy[ny]];
        return this;
    }

    /** Les coefficients, le second membre et le bord d'un circuit. */
    remplit({ fer, fils, fond = [0, 0] }, μr) {
        const { fx, fy, nx, ny, s, xc, yc, O, S, D, b, A } = this;
        // De l'air partout, puis le fer là où un rectangle touche la face.
        for (let j = 1; j <= ny; j++) {
            for (let i = 1; i <= nx + 1; i++) O[j * s + i] = (fy[j] - fy[j - 1]) / (xc[i] - xc[i - 1]);
        }
        for (let j = 1; j <= ny + 1; j++) {
            for (let i = 1; i <= nx; i++) S[j * s + i] = (fx[i] - fx[i - 1]) / (yc[j] - yc[j - 1]);
        }
        for (const r of fer) {
            const [i1, i2] = [Math.max(1, cellule(fx, r[0])), Math.min(nx + 1, cellule(fx, r[1]) + 2)];
            const [j1, j2] = [Math.max(1, cellule(fy, r[2])), Math.min(ny + 1, cellule(fy, r[3]) + 2)];
            for (let j = j1; j <= j2; j++) {
                for (let i = i1; i <= i2; i++) {
                    const p = j * s + i;
                    if (j <= ny) O[p] = coefficient(fer, μr, fy[j - 1], fy[j], xc[i - 1], xc[i], true);
                    if (i <= nx) S[p] = coefficient(fer, μr, fx[i - 1], fx[i], yc[j - 1], yc[j], false);
                }
            }
        }
        for (let j = 1; j <= ny; j++) {
            for (let i = 1, p = j * s + 1; i <= nx; i++, p++) D[p] = O[p] + O[p + 1] + S[p] + S[p + s];
        }

        // Le courant de chaque fil, réparti au prorata de l'aire qu'il couvre
        // dans chaque cellule (4 × 4 points par cellule) : son intensité est
        // exacte quel que soit le pas.
        b.fill(0);
        for (const [x0, y0, r, I] of fils) {
            const parts = [];
            let total = 0;
            for (let j = cellule(fy, y0 - r); j <= cellule(fy, y0 + r); j++) {
                for (let i = cellule(fx, x0 - r); i <= cellule(fx, x0 + r); i++) {
                    const [dx, dy] = [fx[i + 1] - fx[i], fy[j + 1] - fy[j]];
                    let aire = 0;
                    for (let u = 0; u < 4; u++) {
                        for (let v = 0; v < 4; v++) {
                            const x = fx[i] + ((u + 0.5) / 4) * dx;
                            const y = fy[j] + ((v + 0.5) / 4) * dy;
                            if ((x - x0) ** 2 + (y - y0) ** 2 < r * r) aire += dx * dy;
                        }
                    }
                    if (aire) {
                        parts.push([(j + 1) * s + i + 1, aire]);
                        total += aire;
                    }
                }
            }
            // Un fil plus fin que la maille (loin de la vue, où les mailles
            // grandissent) peut tomber entre les points : tout son courant
            // va alors à la cellule de son centre.
            if (!total) parts.push([(cellule(fy, y0) + 1) * s + cellule(fx, x0) + 1, (total = 1)]);
            for (const [p, aire] of parts) b[p] += (MU0 * I * aire) / total;
        }

        // Le bord : A_z = B_x y − B_y x dans les fantômes, ceux d'un champ
        // uniforme (B_x, B_y), nul sans champ imposé. Il agit sur les
        // cellules voisines comme un second membre : c'est avec lui que l'on
        // juge de la convergence, quand il n'y a pas de courant.
        const [Bx, By] = fond;
        const bord = (i, j) => {
            A[j * s + i] = Bx * yc[j] - By * xc[i];
        };
        for (let i = 0; i <= nx + 1; i++) {
            bord(i, 0);
            bord(i, ny + 1);
        }
        for (let j = 1; j <= ny; j++) {
            bord(0, j);
            bord(nx + 1, j);
        }
        this.forçage = 0;
        for (let j = 1; j <= ny; j++) {
            for (let i = 1, p = j * s + 1; i <= nx; i++, p++) {
                let v = b[p];
                if (i === 1) v += O[p] * A[p - 1];
                if (i === nx) v += O[p + 1] * A[p + 1];
                if (j === 1) v += S[p] * A[p - s];
                if (j === ny) v += S[p + s] * A[p + s];
                this.forçage += v * v;
            }
        }
        this.factorise();
    }

    /** Les valeurs extrêmes de A_z sur toute la grille. */
    extrêmes() {
        const { nx, ny, s, A } = this;
        let [bas, haut] = [Infinity, -Infinity];
        for (let j = 1; j <= ny; j++) {
            for (let i = 1, p = j * s + 1; i <= nx; i++, p++) [bas, haut] = [Math.min(bas, A[p]), Math.max(haut, A[p])];
        }
        return [bas, haut];
    }

    /**
     * La factorisation de Cholesky incomplète modifiée : celle de la
     * matrice, aux termes près qu'elle ne garde pas — ajoutés à la diagonale,
     * pour que chaque ligne garde sa somme. C'est ce qui la rend efficace sur
     * une équation de diffusion.
     */
    factorise() {
        const { nx, ny, s, O, S, D, d } = this;
        for (let j = 1; j <= ny; j++) {
            for (let i = 1, p = j * s + 1; i <= nx; i++, p++) {
                let v = D[p];
                if (i > 1) v -= (O[p] * (O[p] + S[p - 1 + s])) / d[p - 1];
                if (j > 1) v -= (S[p] * (S[p] + O[p - s + 1])) / d[p - s];
                d[p] = v;
            }
        }
    }

    /** y = M x, la matrice du système. */
    produit(x, y) {
        const { nx, ny, s, O, S, D } = this;
        for (let j = 1; j <= ny; j++) {
            for (let i = 1, k = j * s + 1; i <= nx; i++, k++) {
                y[k] = D[k] * x[k] - O[k] * x[k - 1] - O[k + 1] * x[k + 1] - S[k] * x[k - s] - S[k + s] * x[k + s];
            }
        }
    }

    /** z = P⁻¹ r, P la factorisation incomplète : une descente, une remontée. */
    préconditionne(r, z) {
        const { nx, ny, s, O, S, d } = this;
        for (let j = 1; j <= ny; j++) {
            for (let i = 1, k = j * s + 1; i <= nx; i++, k++) z[k] = (r[k] + O[k] * z[k - 1] + S[k] * z[k - s]) / d[k];
        }
        for (let j = ny; j >= 1; j--) {
            for (let i = nx, k = j * s + nx; i >= 1; i--, k--) z[k] += (O[k + 1] * z[k + 1] + S[k + s] * z[k + s]) / d[k];
        }
    }

    /**
     * A_z, par le gradient conjugué, en partant de la solution précédente.
     * Une précision de 10⁻³ sur le résidu suffit largement au dessin : l'écart
     * à la solution exacte y est de quelques 10⁻⁵ de A_z.
     */
    résout(tolérance = 1e-3, maximum = 1000) {
        const { N, A, b, r, z, p, q } = this;
        this.produit(A, q);
        let nr = 0;
        for (let k = 0; k < N; k++) {
            r[k] = this.D[k] ? b[k] - q[k] : 0;
            nr += r[k] * r[k];
        }
        this.préconditionne(r, z);
        p.set(z);
        let rz = 0;
        for (let k = 0; k < N; k++) rz += r[k] * z[k];
        const seuil = tolérance * tolérance * this.forçage;
        let itérations = 0;
        while (itérations < maximum && nr > seuil) {
            this.produit(p, q);
            let pq = 0;
            for (let k = 0; k < N; k++) pq += p[k] * q[k];
            const α = rz / pq;
            nr = 0;
            for (let k = 0; k < N; k++) {
                A[k] += α * p[k];
                r[k] -= α * q[k];
                nr += r[k] * r[k];
            }
            this.préconditionne(r, z);
            let rz2 = 0;
            for (let k = 0; k < N; k++) rz2 += r[k] * z[k];
            const β = rz2 / rz;
            rz = rz2;
            for (let k = 0; k < N; k++) p[k] = z[k] + β * p[k];
            itérations++;
        }
        return itérations;
    }

    /**
     * A_z sur une grille régulière du rectangle `cadre`, de `colonnes`
     * points de large : une grille au sens de carte.js, de quoi en tracer les
     * lignes de niveau. On l'interpole entre les centres des cellules, qui ne
     * sont plus régulièrement espacés.
     */
    carte(cadre, colonnes) {
        const lignes = Math.max(2, Math.round((colonnes * (cadre.y1 - cadre.y0)) / (cadre.x1 - cadre.x0)));
        // Pour chaque colonne et chaque ligne de la carte : la cellule dont
        // le centre la précède, et la part de la suivante.
        const repère = (centres, a, b, n) => {
            const indices = new Int32Array(n);
            const parts = new Float64Array(n);
            for (let m = 0, k = 0; m < n; m++) {
                const v = a + ((b - a) * m) / (n - 1);
                while (k < centres.length - 2 && centres[k + 1] <= v) k++;
                indices[m] = k;
                parts[m] = Math.min(Math.max((v - centres[k]) / (centres[k + 1] - centres[k]), 0), 1);
            }
            return [indices, parts];
        };
        const [is, us] = repère(this.xc, cadre.x0, cadre.x1, colonnes);
        const [js, vs] = repère(this.yc, cadre.y0, cadre.y1, lignes);
        const { A, s } = this;
        const valeurs = new Float64Array(colonnes * lignes);
        for (let m = 0; m < lignes; m++) {
            const [j, v] = [js[m], vs[m]];
            for (let n = 0; n < colonnes; n++) {
                const [i, u] = [is[n], us[n]];
                const k = j * s + i;
                valeurs[m * colonnes + n] =
                    (1 - v) * ((1 - u) * A[k] + u * A[k + 1]) + v * ((1 - u) * A[k + s] + u * A[k + s + 1]);
            }
        }
        return { colonnes, lignes, cadre: { ...cadre }, valeurs };
    }

    /**
     * Le champ en (x, y), tiré de la grille du calcul elle-même : B =
     * (∂A/∂y, −∂A/∂x), le gradient étant celui de l'interpolation bilinéaire
     * entre les centres des cellules. Une carte rééchantillonnée, plus
     * grossière que l'entrefer, mêlerait le fer et l'air.
     */
    champ(x, y) {
        const { xc, yc, A, s } = this;
        const i = Math.min(Math.max(cellule(xc, x), 0), xc.length - 2);
        const j = Math.min(Math.max(cellule(yc, y), 0), yc.length - 2);
        const [hx, hy] = [xc[i + 1] - xc[i], yc[j + 1] - yc[j]];
        const [u, v] = [(x - xc[i]) / hx, (y - yc[j]) / hy];
        const k = j * s + i;
        const dAdx = ((1 - v) * (A[k + 1] - A[k]) + v * (A[k + s + 1] - A[k + s])) / hx;
        const dAdy = ((1 - u) * (A[k + s] - A[k]) + u * (A[k + s + 1] - A[k + 1])) / hy;
        return [dAdy, -dAdx];
    }
}

/**
 * Le champ en (x, y), tiré d'une carte de A_z : B = (∂A/∂y, −∂A/∂x), le
 * gradient étant celui de l'interpolation bilinéaire dans la maille.
 */
export function champ({ colonnes, lignes, cadre, valeurs }, x, y) {
    const hx = (cadre.x1 - cadre.x0) / (colonnes - 1);
    const hy = (cadre.y1 - cadre.y0) / (lignes - 1);
    const i = Math.min(Math.max(Math.floor((x - cadre.x0) / hx), 0), colonnes - 2);
    const j = Math.min(Math.max(Math.floor((y - cadre.y0) / hy), 0), lignes - 2);
    const u = Math.min(Math.max((x - cadre.x0) / hx - i, 0), 1);
    const v = Math.min(Math.max((y - cadre.y0) / hy - j, 0), 1);
    const k = j * colonnes + i;
    const [a00, a10, a01, a11] = [valeurs[k], valeurs[k + 1], valeurs[k + colonnes], valeurs[k + colonnes + 1]];
    const dAdx = ((1 - v) * (a10 - a00) + v * (a11 - a01)) / hx;
    const dAdy = ((1 - u) * (a01 - a00) + u * (a11 - a10)) / hy;
    return [dAdy, -dAdx];
}
