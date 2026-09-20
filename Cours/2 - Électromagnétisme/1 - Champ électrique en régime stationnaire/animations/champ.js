// Le champ et le potentiel d'une distribution de charges dans le plan de
// l'écran, et de quoi les dessiner : lignes de champ, équipotentielles,
// dégradé de potentiel.
//
// Deux distributions, deux lois :
//
//   - `PONCTUELLES` — des charges ponctuelles posées dans le plan de l'écran,
//     celles du cours. Elles se comptent en nanocoulombs et les longueurs en
//     centimètres : le champ sort alors en volts par mètre et le potentiel en
//     volts, des ordres de grandeur que l'on peut lire sur la carte.
//   - `FILS` — des fils rectilignes infinis perpendiculaires à l'écran, dont
//     la juxtaposition fait une plaque vue par la tranche. C'est ainsi qu'est
//     bâti le condensateur plan : une armature ponctuelle n'aurait pas de
//     champ uniforme entre elle et sa voisine. Les unités sont alors celles
//     du dessin (1/(2πε₀) = 1), et seuls comptent les rapports — le panneau
//     n'y affiche que des σ/ε.

/** 1/(4πε₀), en unités SI. */
const COULOMB = 8.9875517873681764e9;

/**
 * Des charges ponctuelles : E = q/(4πε₀ r²), V = q/(4πε₀ r).
 *
 * `radial(r²)` est le facteur par lequel multiplier q (x − x₀, y − y₀) pour
 * obtenir le champ. Les facteurs 10⁻⁵ et 10⁻⁷ font le change : q en
 * nanocoulombs et r en centimètres donnent E en volts par mètre et V en volts.
 */
export const PONCTUELLES = {
    radial: (r2) => (1e-5 * COULOMB) / (r2 * Math.sqrt(r2)),
    potentiel: (r) => (1e-7 * COULOMB) / r,
};

/** Des fils infinis perpendiculaires à l'écran : E = λ/(2πε₀ r), et un
 *  potentiel en −ln r, nul à la distance 1. En unités du dessin. */
export const FILS = {
    radial: (r2) => 1 / r2,
    potentiel: (r) => -Math.log(r),
};

/** Le champ créé en (x, y) par les charges. */
export function champ(charges, x, y, loi = PONCTUELLES) {
    let ex = 0;
    let ey = 0;
    for (const charge of charges) {
        const dx = x - charge.x;
        const dy = y - charge.y;
        const r2 = dx * dx + dy * dy;
        if (r2 < 1e-9) continue;
        const facteur = charge.q * loi.radial(r2);
        ex += facteur * dx;
        ey += facteur * dy;
    }
    return [ex, ey];
}

/** Le potentiel, nul à l'infini pour des charges ponctuelles. */
export function potentiel(charges, x, y, loi = PONCTUELLES) {
    let v = 0;
    for (const charge of charges) {
        // Le potentiel diverge sur la charge : on ne l'y calcule pas.
        const r = Math.max(Math.hypot(x - charge.x, y - charge.y), 1e-3);
        v += charge.q * loi.potentiel(r);
    }
    return v;
}

/**
 * Une ligne de champ, suivie depuis `départ` dans le sens du champ (`sens`
 * vaut -1 pour la remonter). Elle s'arrête en atteignant une charge, ou en
 * partant si loin qu'elle ne reviendra pas (`portée`, en rayons de la `vue`).
 * Elle se calcule par Runge-Kutta d'ordre 4 sur le champ normalisé : le pas
 * est alors une longueur d'arc, et la ligne garde sa finesse là où le champ
 * s'emballe.
 *
 * Hors de la `vue`, le pas grandit avec la distance. Deux charges opposées
 * échangent toutes leurs lignes, y compris celles qui partent à l'opposé
 * l'une de l'autre : celles-là s'éloignent de cent fois la vue avant de
 * revenir, et les couper au bord les ferait partir sans jamais revenir. Ce
 * qu'elles font là-bas ne se voit pas — seul compte le point où elles
 * reviennent —, et un pas proportionnel à la distance les y suit en quelques
 * centaines de pas au lieu de dizaines de milliers.
 */
export function ligneDeChamp(
    charges,
    départ,
    { sens = 1, pas = 0.06, maximum = 4000, vue, portée = 400, arrivée = 0.1, loi = PONCTUELLES } = {},
) {
    const direction = (x, y) => {
        const [ex, ey] = champ(charges, x, y, loi);
        const norme = Math.hypot(ex, ey);
        return norme < 1e-12 ? [0, 0] : [(sens * ex) / norme, (sens * ey) / norme];
    };
    const centre = vue ? [(vue.x0 + vue.x1) / 2, (vue.y0 + vue.y1) / 2] : [0, 0];
    const rayon = vue ? Math.hypot(vue.x1 - vue.x0, vue.y1 - vue.y0) / 2 : Infinity;
    // De loin, une distribution n'est plus que sa charge totale, pour peu
    // qu'on soit assez loin devant son moment dipolaire. Une ligne que cette
    // charge-là pousse vers le dehors ne reviendra pas : inutile de la
    // suivre plus avant.
    const total = charges.reduce((somme, c) => somme + c.q, 0);
    const moment = Math.hypot(
        charges.reduce((somme, c) => somme + c.q * (c.x - centre[0]), 0),
        charges.reduce((somme, c) => somme + c.q * (c.y - centre[1]), 0),
    );
    const points = [[...départ]];
    let [x, y] = départ;
    for (let i = 0; i < maximum; i++) {
        const loin = Math.hypot(x - centre[0], y - centre[1]);
        if (loin > portée * rayon) break;
        if (loin > 3 * rayon && sens * total > 0 && loin * Math.abs(total) > 5 * moment) break;
        const h = pas * Math.max(1, loin / rayon);
        const [ax, ay] = direction(x, y);
        if (!ax && !ay) break;
        const [bx, by] = direction(x + (h * ax) / 2, y + (h * ay) / 2);
        const [cx, cy] = direction(x + (h * bx) / 2, y + (h * by) / 2);
        const [dx, dy] = direction(x + h * cx, y + h * cy);
        x += (h * (ax + 2 * bx + 2 * cx + dx)) / 6;
        y += (h * (ay + 2 * by + 2 * cy + dy)) / 6;
        points.push([x, y]);
        if (charges.some((c) => c.q && Math.hypot(x - c.x, y - c.y) < arrivée)) break;
    }
    return points;
}

/**
 * Les lignes de champ d'une distribution : elles partent des charges
 * positives, en couronne, à raison de `parUnité` lignes par unité de charge —
 * une charge double reçoit ainsi deux fois plus de lignes.
 *
 * Si les charges négatives en absorbent plus que les positives n'en
 * émettent, le surplus vient de l'infini : ces lignes-là se remontent depuis
 * les charges négatives, en proportion du surplus, et aucune n'est tracée
 * deux fois.
 */
export function lignesDeChamp(charges, { parUnité = 8, rayon = 0.16, maximumParCharge = 40, ...options } = {}) {
    const total = (signe) => charges.reduce((somme, c) => somme + Math.max(0, signe * c.q), 0);
    const émises = total(1);
    const absorbées = total(-1);
    const surplus = absorbées > émises ? (absorbées - émises) / absorbées : 0;
    const lignes = [];
    for (const charge of charges) {
        const part = charge.q > 0 ? charge.q : -charge.q * surplus;
        const nombre = Math.min(maximumParCharge, Math.round(parUnité * part));
        for (let k = 0; k < nombre; k++) {
            const angle = (2 * Math.PI * (k + 0.5)) / nombre;
            const départ = [charge.x + rayon * Math.cos(angle), charge.y + rayon * Math.sin(angle)];
            lignes.push(ligneDeChamp(charges, départ, { sens: Math.sign(charge.q), ...options }));
        }
    }
    return lignes;
}

/** Le potentiel sur une grille régulière du cadre : de quoi en tirer les
 *  équipotentielles et le dégradé, sans le recalculer deux fois. */
export function grilleDePotentiel(charges, cadre, colonnes = 150, loi = PONCTUELLES) {
    const lignes = Math.max(2, Math.round((colonnes * (cadre.y1 - cadre.y0)) / (cadre.x1 - cadre.x0)));
    const valeurs = new Float64Array(colonnes * lignes);
    for (let j = 0; j < lignes; j++) {
        const y = cadre.y0 + ((cadre.y1 - cadre.y0) * j) / (lignes - 1);
        for (let i = 0; i < colonnes; i++) {
            const x = cadre.x0 + ((cadre.x1 - cadre.x0) * i) / (colonnes - 1);
            valeurs[j * colonnes + i] = potentiel(charges, x, y, loi);
        }
    }
    return { colonnes, lignes, cadre, valeurs };
}

/**
 * Des potentiels régulièrement espacés, de `pas` en `pas` : c'est leur
 * espacement constant qui fait dire la carte — là où les équipotentielles se
 * resserrent, le champ est intense.
 *
 * Le potentiel diverge près des charges, et prendre toute l'étendue de la
 * grille donnerait des milliers de niveaux serrés sur quelques millimètres.
 * On s'en tient donc à une fenêtre centrée sur zéro, d'au plus `maximum`
 * niveaux : c'est loin des charges que la carte se lit.
 */
export function niveaux(grille, pas, maximum = 40) {
    let bas = Infinity;
    let haut = -Infinity;
    for (const v of grille.valeurs) {
        if (v < bas) bas = v;
        if (v > haut) haut = v;
    }
    const bord = Math.floor(maximum / 2);
    const premier = Math.max(Math.ceil(bas / pas), -bord);
    const dernier = Math.min(Math.floor(haut / pas), bord);
    const trouvés = [];
    for (let k = premier; k <= dernier; k++) trouvés.push(k * pas);
    return trouvés;
}

/**
 * Les segments des équipotentielles, par la méthode des carrés marchants :
 * dans chaque maille, le contour coupe les arêtes dont les extrémités
 * encadrent le niveau, et l'interpolation linéaire dit où.
 *
 * Tous les niveaux se tracent en une seule passe sur la grille. Ils sont
 * régulièrement espacés : une maille en déduit par un calcul ceux qu'elle
 * traverse — jamais plus d'un ou deux — au lieu de les essayer tous. Avec une
 * quarantaine de niveaux, la carte se redessine quarante fois plus vite, et
 * suit les curseurs.
 */
export function contours(grille, niveaux) {
    const { colonnes, lignes, cadre, valeurs } = grille;
    if (niveaux.length === 0) return [];
    const base = niveaux[0];
    const pas = niveaux.length > 1 ? niveaux[1] - niveaux[0] : 1;
    const dx = (cadre.x1 - cadre.x0) / (colonnes - 1);
    const dy = (cadre.y1 - cadre.y0) / (lignes - 1);
    const segments = [];
    const v = [0, 0, 0, 0];
    for (let j = 0; j < lignes - 1; j++) {
        for (let i = 0; i < colonnes - 1; i++) {
            v[0] = valeurs[j * colonnes + i];
            v[1] = valeurs[j * colonnes + i + 1];
            v[2] = valeurs[(j + 1) * colonnes + i + 1];
            v[3] = valeurs[(j + 1) * colonnes + i];
            const bas = Math.min(v[0], v[1], v[2], v[3]);
            const haut = Math.max(v[0], v[1], v[2], v[3]);
            const premier = Math.max(0, Math.ceil((bas - base) / pas));
            const dernier = Math.min(niveaux.length - 1, Math.floor((haut - base) / pas));
            if (premier > dernier) continue;
            const x = cadre.x0 + i * dx;
            const y = cadre.y0 + j * dy;
            // Les quatre coins de la maille, dans le sens trigonométrique.
            const coins = [
                [x, y],
                [x + dx, y],
                [x + dx, y + dy],
                [x, y + dy],
            ];
            for (let n = premier; n <= dernier; n++) {
                const niveau = niveaux[n];
                const points = [];
                for (let a = 0; a < 4; a++) {
                    const b = (a + 1) % 4;
                    if (v[a] === v[b] || v[a] < niveau === v[b] < niveau) continue;
                    const t = (niveau - v[a]) / (v[b] - v[a]);
                    points.push([
                        coins[a][0] + t * (coins[b][0] - coins[a][0]),
                        coins[a][1] + t * (coins[b][1] - coins[a][1]),
                    ]);
                }
                // Deux points : un segment. Quatre (un col) : on relie dans
                // l'ordre des arêtes, ce qui donne deux segments acceptables
                // à l'échelle d'une maille.
                for (let k = 0; k + 1 < points.length; k += 2) segments.push([points[k], points[k + 1]]);
            }
        }
    }
    return segments;
}
