// L'axe des temps des chronogrammes. Ils couvrent un nombre entier de
// périodes, pour que l'instant qui les parcourt revienne au début sans que
// rien ne saute : leurs abscisses se comptent donc en périodes. L'axe, lui,
// se gradue en secondes — les secondes rondes, qui glissent sous les courbes
// quand la fréquence change : c'est là que la fréquence se voit.

/**
 * Les graduations de `périodes` périodes à la fréquence f, des couples
 * [abscisse en périodes, nom] : `nommées` pour le graphique du bas, `muettes`
 * pour ceux qui le surmontent. Le pas, 0,5 s, 1 s, 2 s ou 5 s, en laisse
 * huit au plus.
 */
export function secondes(périodes, f) {
    const durée = périodes / f;
    const pas = [0.5, 1, 2, 5].find((p) => durée / p <= 8) ?? 10;
    const instants = Array.from({ length: Math.floor(durée / pas + 1e-9) + 1 }, (_, k) => k * pas);
    return {
        nommées: instants.map((t) => [t * f, String(t).replace('.', '{,}')]),
        muettes: instants.map((t) => [t * f, '']),
    };
}
