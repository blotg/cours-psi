// Ce que partagent les deux animations où un moteur entraîne une charge : un
// arbre qui a de l'inertie, le couple résistant qui le freine, et le
// chronogramme de sa vitesse.

import { COULEURS } from '#animations/objets.js';

/** La couleur du couple résistant, dans la scène et sur les graphiques :
 *  franche, pour se lire sur le gris des tôles. */
export const COULEUR_CHARGE = COULEURS.bleu;

/** Le pas du calcul, en secondes : bien plus fin qu'une image. */
const PAS = 1e-3;

/** Le couple que la charge oppose à l'arbre qui tourne à Ω sous le couple
 *  moteur Γm. Elle s'oppose au mouvement avec le couple Γr ; à l'arrêt, elle
 *  retient l'arbre tant que le moteur ne dépasse pas Γr. */
export function coupleDeCharge(Ω, Γm, Γr) {
    return Ω !== 0 ? Math.sign(Ω) * Γr : Math.max(-Γr, Math.min(Γr, Γm));
}

/**
 * Fait tourner pendant `dt` un arbre de moment d'inertie J :
 *     J dΩ/dt = Γm − Γ_charge.
 * `état` porte sa vitesse `Ω` ; `avance(h)` donne le couple moteur Γm de
 * l'instant, puis fait avancer de h ce qui tourne avec l'arbre, une fois la
 * vitesse mise à jour. Renvoie les deux couples du dernier pas.
 */
export function tourne(état, dt, { J, Γr, couple, avance }) {
    let Γm = couple();
    for (let reste = dt; reste > 1e-9; reste -= PAS) {
        const h = Math.min(PAS, reste);
        Γm = couple();
        const suivante = état.Ω + ((Γm - coupleDeCharge(état.Ω, Γm, Γr)) / J) * h;
        // La charge arrête l'arbre, elle ne le relance pas dans l'autre sens.
        état.Ω = état.Ω * suivante < 0 ? 0 : suivante;
        avance(h);
    }
    return { Γm, Γcharge: coupleDeCharge(état.Ω, Γm, Γr) };
}

/**
 * Le chronogramme d'une grandeur sur un graphique dont l'abscisse va de
 * −durée à 0 : ses dernières secondes, qui défilent. Le graphique se
 * construit avec `coupe: true`, pour que la courbe s'arrête à son bord.
 */
export function chronogramme(graphe, { couleur = COULEURS.noir } = {}) {
    const durée = -graphe.domaine.x.min;
    const courbe = graphe.courbe({ couleur });
    const points = [];
    let t = 0;
    return {
        /** `dt` secondes ont passé, la grandeur vaut `valeur`. */
        ajoute(dt, valeur) {
            t += dt;
            points.push([t, valeur]);
            // On garde un point hors du cadre : la courbe en part.
            while (points.length > 2 && points[1][0] < t - durée) points.shift();
            courbe.place(points.map(([instant, v]) => [instant - t, v]));
        },
    };
}

/** Un nombre à la française, pour une formule. */
export function virgule(v, décimales = 2) {
    const arrondi = Math.abs(v) < 0.5 * 10 ** -décimales ? 0 : v;
    return arrondi.toFixed(décimales).replace('.', '{,}');
}

/** Un curseur dont le nom est une fraction : sa ligne prend la hauteur qu'il
 *  lui faut, sans quoi deux fractions voisines se chevauchent. */
export function fraction(curseur) {
    curseur.ligne.style.minHeight = '3.3rem';
    return curseur;
}
