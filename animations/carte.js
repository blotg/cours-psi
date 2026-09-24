// La carte d'un champ scalaire : ses valeurs sur une grille du cadre, et les
// lignes de niveau qu'on en tire — les équipotentielles d'un potentiel.
//
// Une grille se calcule une fois par champ : le dégradé, les lignes de niveau
// et celle qui passe par un point s'en tirent ensuite sans rappeler le champ.

/** Les valeurs de `f(x, y)` sur une grille régulière du cadre, rangées ligne
 *  après ligne, de bas en haut. */
export function grille(f, cadre, colonnes = 150) {
    const lignes = Math.max(2, Math.round((colonnes * (cadre.y1 - cadre.y0)) / (cadre.x1 - cadre.x0)));
    const valeurs = new Float64Array(colonnes * lignes);
    for (let j = 0; j < lignes; j++) {
        const y = cadre.y0 + ((cadre.y1 - cadre.y0) * j) / (lignes - 1);
        for (let i = 0; i < colonnes; i++) {
            const x = cadre.x0 + ((cadre.x1 - cadre.x0) * i) / (colonnes - 1);
            valeurs[j * colonnes + i] = f(x, y);
        }
    }
    return { colonnes, lignes, cadre, valeurs };
}

/** La plus petite et la plus grande valeur d'une grille. */
export function étendue(grille) {
    let bas = Infinity;
    let haut = -Infinity;
    for (const v of grille.valeurs) {
        if (v < bas) bas = v;
        if (v > haut) haut = v;
    }
    return [bas, haut];
}

/** La valeur ronde la plus proche : 1, 2 ou 5 fois une puissance de dix. */
export function ronde(x) {
    const décade = 10 ** Math.floor(Math.log10(x));
    const mantisse = x / décade;
    return décade * (mantisse < 1.5 ? 1 : mantisse < 3.5 ? 2 : mantisse < 7.5 ? 5 : 10);
}

/**
 * Des niveaux régulièrement espacés, de `pas` en `pas` : c'est leur
 * espacement constant qui fait parler la carte — là où les lignes de niveau
 * se resserrent, le champ varie vite.
 *
 * Un potentiel diverge près des charges, et prendre toute l'étendue de la
 * grille donnerait des milliers de niveaux serrés sur quelques millimètres.
 * On s'en tient donc à une fenêtre centrée sur zéro, d'au plus `maximum`
 * niveaux : c'est loin des charges que la carte se lit.
 */
export function niveaux(grille, pas, maximum = 40) {
    const [bas, haut] = étendue(grille);
    const bord = Math.floor(maximum / 2);
    const premier = Math.max(Math.ceil(bas / pas), -bord);
    const dernier = Math.min(Math.floor(haut / pas), bord);
    const trouvés = [];
    for (let k = premier; k <= dernier; k++) trouvés.push(k * pas);
    return trouvés;
}

/**
 * Les segments des lignes de niveau, par la méthode des carrés marchants :
 * dans chaque maille, la ligne coupe les arêtes dont les extrémités
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
