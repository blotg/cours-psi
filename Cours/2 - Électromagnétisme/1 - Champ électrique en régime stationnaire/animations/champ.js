// Le champ et le potentiel d'une distribution de charges, dans un plan de
// coupe, et de quoi les dessiner : lignes de champ, équipotentielles, dégradé
// de potentiel.
//
// Les charges sont des fils rectilignes infinis perpendiculaires à l'écran,
// de densité linéique λ. La carte est alors la même dans tous les plans de
// coupe, et tout ce qui se voit à l'écran est exact : le flux à travers un
// tube de champ se compte dans le plan, par unité de longueur de fil. Le
// champ d'un fil décroît en 1/r, son potentiel en -ln r ; les cartes ont la
// même allure que celles du poly.
//
// Les unités sont celles du dessin : 1/(2π ε₀) = 1.

/** Le champ créé en (x, y) par les charges. */
export function champ(charges, x, y) {
    let ex = 0;
    let ey = 0;
    for (const charge of charges) {
        const dx = x - charge.x;
        const dy = y - charge.y;
        const r2 = dx * dx + dy * dy;
        if (r2 < 1e-9) continue;
        ex += (charge.q * dx) / r2;
        ey += (charge.q * dy) / r2;
    }
    return [ex, ey];
}

/** Le potentiel, nul à la distance 1 d'une charge seule. */
export function potentiel(charges, x, y) {
    let v = 0;
    for (const charge of charges) {
        const r = Math.hypot(x - charge.x, y - charge.y);
        v -= charge.q * Math.log(Math.max(r, 1e-3));
    }
    return v;
}

/**
 * Une ligne de champ, suivie depuis `départ` dans le sens du champ (`sens`
 * vaut -1 pour la remonter). Elle s'arrête en atteignant une charge ou en
 * sortant du `cadre`, et se calcule par Runge-Kutta d'ordre 4 sur le champ
 * normalisé : le pas est alors une longueur d'arc, et la ligne garde sa
 * finesse là où le champ s'emballe.
 */
export function ligneDeChamp(charges, départ, { sens = 1, pas = 0.06, maximum = 1200, cadre, arrivée = 0.1 } = {}) {
    const direction = (x, y) => {
        const [ex, ey] = champ(charges, x, y);
        const norme = Math.hypot(ex, ey);
        return norme < 1e-12 ? [0, 0] : [(sens * ex) / norme, (sens * ey) / norme];
    };
    const points = [[...départ]];
    let [x, y] = départ;
    for (let i = 0; i < maximum; i++) {
        const [ax, ay] = direction(x, y);
        if (!ax && !ay) break;
        const [bx, by] = direction(x + (pas * ax) / 2, y + (pas * ay) / 2);
        const [cx, cy] = direction(x + (pas * bx) / 2, y + (pas * by) / 2);
        const [dx, dy] = direction(x + pas * cx, y + pas * cy);
        x += (pas * (ax + 2 * bx + 2 * cx + dx)) / 6;
        y += (pas * (ay + 2 * by + 2 * cy + dy)) / 6;
        points.push([x, y]);
        if (cadre && (x < cadre.x0 || x > cadre.x1 || y < cadre.y0 || y > cadre.y1)) break;
        if (charges.some((c) => Math.hypot(x - c.x, y - c.y) < arrivée)) break;
    }
    return points;
}

/**
 * Les lignes de champ d'une distribution : elles partent des charges
 * positives, en couronne, à raison de `parUnité` lignes par unité de charge —
 * chacune porte ainsi le même flux, et une charge double reçoit deux fois
 * plus de lignes.
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
export function grilleDePotentiel(charges, cadre, colonnes = 150) {
    const lignes = Math.max(2, Math.round((colonnes * (cadre.y1 - cadre.y0)) / (cadre.x1 - cadre.x0)));
    const valeurs = new Float64Array(colonnes * lignes);
    for (let j = 0; j < lignes; j++) {
        const y = cadre.y0 + ((cadre.y1 - cadre.y0) * j) / (lignes - 1);
        for (let i = 0; i < colonnes; i++) {
            const x = cadre.x0 + ((cadre.x1 - cadre.x0) * i) / (colonnes - 1);
            valeurs[j * colonnes + i] = potentiel(charges, x, y);
        }
    }
    return { colonnes, lignes, cadre, valeurs };
}

/**
 * Des potentiels régulièrement espacés, de `pas` en `pas` : c'est leur
 * espacement constant qui fait dire la carte — là où les équipotentielles se
 * resserrent, le champ est intense. On en limite le nombre pour que la carte
 * reste lisible près des charges, où le potentiel diverge.
 */
export function niveaux(grille, pas, maximum = 40) {
    let bas = Infinity;
    let haut = -Infinity;
    for (const v of grille.valeurs) {
        if (v < bas) bas = v;
        if (v > haut) haut = v;
    }
    const premier = Math.ceil(bas / pas);
    const dernier = Math.floor(haut / pas);
    const trouvés = [];
    for (let k = premier; k <= dernier && trouvés.length < maximum; k++) trouvés.push(k * pas);
    return trouvés;
}

/**
 * Les segments de l'équipotentielle `niveau`, par la méthode des carrés
 * marchants : dans chaque maille, le contour coupe les arêtes dont les
 * extrémités encadrent le niveau, et l'interpolation linéaire dit où.
 */
export function contour(grille, niveau) {
    const { colonnes, lignes, cadre, valeurs } = grille;
    const dx = (cadre.x1 - cadre.x0) / (colonnes - 1);
    const dy = (cadre.y1 - cadre.y0) / (lignes - 1);
    const segments = [];
    for (let j = 0; j < lignes - 1; j++) {
        for (let i = 0; i < colonnes - 1; i++) {
            const v = [
                valeurs[j * colonnes + i],
                valeurs[j * colonnes + i + 1],
                valeurs[(j + 1) * colonnes + i + 1],
                valeurs[(j + 1) * colonnes + i],
            ];
            const x = cadre.x0 + i * dx;
            const y = cadre.y0 + j * dy;
            // Les quatre coins de la maille, dans le sens trigonométrique.
            const coins = [
                [x, y],
                [x + dx, y],
                [x + dx, y + dy],
                [x, y + dy],
            ];
            const points = [];
            for (let a = 0; a < 4; a++) {
                const b = (a + 1) % 4;
                if (v[a] === v[b] || v[a] < niveau === v[b] < niveau) continue;
                const t = (niveau - v[a]) / (v[b] - v[a]);
                points.push([coins[a][0] + t * (coins[b][0] - coins[a][0]), coins[a][1] + t * (coins[b][1] - coins[a][1])]);
            }
            // Deux points : un segment. Quatre (un col) : on relie dans
            // l'ordre des arêtes, ce qui donne deux segments acceptables à
            // l'échelle d'une maille.
            for (let k = 0; k + 1 < points.length; k += 2) segments.push([points[k], points[k + 1]]);
        }
    }
    return segments;
}

/**
 * Le flux du champ à travers le segment [a, b], par unité de longueur de
 * fil, compté vers la gauche du trajet de a vers b. C'est la grandeur du
 * théorème de Gauss dans le plan de coupe — et c'est elle qui se conserve
 * le long d'un tube de champ.
 */
export function flux(charges, a, b, échantillons = 200) {
    const dx = (b[0] - a[0]) / échantillons;
    const dy = (b[1] - a[1]) / échantillons;
    // La normale au segment, tournée de +90° par rapport à son sens.
    const [nx, ny] = [-dy, dx];
    let somme = 0;
    for (let k = 0; k < échantillons; k++) {
        const x = a[0] + dx * (k + 0.5);
        const y = a[1] + dy * (k + 0.5);
        const [ex, ey] = champ(charges, x, y);
        somme += ex * nx + ey * ny;
    }
    return somme;
}
