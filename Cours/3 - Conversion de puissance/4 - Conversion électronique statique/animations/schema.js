// Les schémas électriques des animations du chapitre, dessinés sur un `Plan`
// comme les figures du poly : fils fins, interrupteurs que l'on voit ouverts
// ou fermés, dipôles à l'européenne.
//
// Tout se donne dans les coordonnées du problème (celles du `Plan`) ; un
// dipôle se place entre deux points, ses bornes, et se raccorde lui-même à
// ces points par deux bouts de fil.
//
// Le courant ne se devine pas sur un schéma : `courant` repasse en couleur la
// maille qu'il parcourt et y fait avancer des pointes, d'autant plus vite
// qu'il est fort — sans à-coup là où il continue de passer quand les
// interrupteurs commutent.

import { chemin, disque, flèche, pointe } from '#animations/plan.js';

const NOIR = '#000';
const TRAIT = 1.5;

const vers = (plan, points) => points.map((p) => plan.vers(...p));
const le = ([x, y], [ux, uy], d) => [x + ux * d, y + uy * d];

/** Le repère d'un dipôle placé entre A et B : ses bornes et son milieu en
 *  pixels, le vecteur unitaire de A vers B. */
function axe(plan, A, B) {
    const [a, b] = vers(plan, [A, B]);
    const l = Math.hypot(b[0] - a[0], b[1] - a[1]);
    return { a, b, u: [(b[0] - a[0]) / l, (b[1] - a[1]) / l], m: [(a[0] + b[0]) / 2, (a[1] + b[1]) / 2] };
}

/** Un fil, passant par les points donnés. */
export function fil(c, plan, points, { couleur = NOIR, épaisseur = TRAIT } = {}) {
    chemin(c, vers(plan, points), { couleur, épaisseur });
}

/** Un nœud : un point sur les fils qui s'y rejoignent. */
export function nœud(c, plan, P) {
    disque(c, plan.vers(...P), 2.8, { couleur: NOIR });
}

/**
 * Un interrupteur entre A et B, fermé ou ouvert : sa lame part de la borne
 * du côté de A et se lève de 30°, du côté que donne `côté` (±1).
 */
export function interrupteur(c, plan, A, B, fermé, { longueur = 1.1, côté = 1 } = {}) {
    const { a, b, u, m } = axe(plan, A, B);
    const d = plan.long(longueur) / 2;
    const [p, q] = [le(m, u, -d), le(m, u, d)];
    chemin(c, [a, p], { épaisseur: TRAIT });
    chemin(c, [q, b], { épaisseur: TRAIT });
    const θ = fermé ? 0 : (-côté * Math.PI) / 6;
    const lame = [u[0] * Math.cos(θ) - u[1] * Math.sin(θ), u[0] * Math.sin(θ) + u[1] * Math.cos(θ)];
    chemin(c, [p, le(p, lame, fermé ? 2 * d : 2.1 * d)], { épaisseur: 2 });
    for (const borne of [p, q]) disque(c, borne, 2.4, { couleur: NOIR });
}

/** Un résistor : un rectangle. */
export function résistance(c, plan, A, B, { longueur = 1.1, largeur = 0.42 } = {}) {
    const { a, b, u, m } = axe(plan, A, B);
    const [d, h] = [plan.long(longueur) / 2, plan.long(largeur) / 2];
    const n = [-u[1], u[0]];
    chemin(c, [a, le(m, u, -d)], { épaisseur: TRAIT });
    chemin(c, [le(m, u, d), b], { épaisseur: TRAIT });
    const coins = [le(le(m, u, -d), n, h), le(le(m, u, d), n, h), le(le(m, u, d), n, -h), le(le(m, u, -d), n, -h)];
    chemin(c, coins, { épaisseur: TRAIT, fermé: true });
}

/** Une bobine : quatre spires en demi-cercles. */
export function bobine(c, plan, A, B, { longueur = 1.3, côté = 1 } = {}) {
    const { a, b, u, m } = axe(plan, A, B);
    const d = plan.long(longueur) / 2;
    const r = d / 4;
    chemin(c, [a, le(m, u, -d)], { épaisseur: TRAIT });
    chemin(c, [le(m, u, d), b], { épaisseur: TRAIT });
    c.save();
    c.translate(...m);
    c.rotate(Math.atan2(u[1], u[0]));
    c.beginPath();
    for (let k = 0; k < 4; k++) {
        c.moveTo(-d + 2 * r * k, 0);
        c.arc(-d + r * (2 * k + 1), 0, r, Math.PI, 0, côté < 0);
    }
    Object.assign(c, { strokeStyle: NOIR, lineWidth: TRAIT });
    c.stroke();
    c.restore();
}

/**
 * Une source idéale : un cercle, que barre un trait comme sur les schémas du
 * poly — le long du fil pour une source de `tension` continue, en travers
 * pour une source de `courant` —, ou qui porte une sinusoïde pour une source
 * de tension `alternative`. Sa tension se flèche à côté (cf. `tension`).
 */
export function source(c, plan, A, B, { rayon = 0.42, genre = 'tension' } = {}) {
    const { a, b, u, m } = axe(plan, A, B);
    const r = plan.long(rayon);
    const n = [-u[1], u[0]];
    chemin(c, [a, le(m, u, -r)], { épaisseur: TRAIT });
    chemin(c, [le(m, u, r), b], { épaisseur: TRAIT });
    c.save();
    c.beginPath();
    c.arc(m[0], m[1], r, 0, 2 * Math.PI);
    Object.assign(c, { strokeStyle: NOIR, lineWidth: TRAIT });
    c.stroke();
    c.restore();
    if (genre === 'tension') chemin(c, [le(m, u, -r), le(m, u, r)], { épaisseur: TRAIT });
    else if (genre === 'courant') chemin(c, [le(m, n, -r), le(m, n, r)], { épaisseur: TRAIT });
    else {
        // Une période de sinusoïde, toujours à l'horizontale.
        const points = Array.from({ length: 25 }, (_, k) => {
            const x = k / 24 - 0.5;
            return [m[0] + 1.15 * r * x, m[1] - 0.3 * r * Math.sin(2 * Math.PI * x)];
        });
        chemin(c, points, { épaisseur: TRAIT });
    }
}

/** La flèche d'une tension, de A vers B : elle pointe vers le potentiel
 *  que l'on compte positivement. */
export function tension(c, plan, A, B, { couleur = NOIR } = {}) {
    const [a, b] = vers(plan, [A, B]);
    flèche(c, a, [b[0] - a[0], b[1] - a[1]], Math.hypot(b[0] - a[0], b[1] - a[1]), { couleur, épaisseur: 1.3, tête: 9 });
}

/** Le sens dans lequel on compte un courant : une pointe sur le fil, en P,
 *  tournée selon `direction` (dans le repère du problème, y vers le haut). */
export function sens(c, plan, P, [dx, dy], { couleur = NOIR } = {}) {
    pointe(c, plan.vers(...P), [dx, -dy], { couleur, taille: 10 });
}

/**
 * Le courant qui parcourt une maille : la maille (une ligne fermée, donnée
 * par ses sommets) repassée en couleur, et des pointes régulièrement
 * espacées, décalées de `décalage` pixels le long d'elle. `sens` (±1) dit si
 * le courant suit l'ordre des sommets ou le remonte : les pointes se
 * retournent, sans changer de place.
 *
 * `pas` est l'écart des pointes, dans l'unité du problème ; il s'arrondit
 * pour qu'elles tiennent en nombre entier sur le tour. Quand une commutation
 * fait passer le courant d'une maille à une autre, il continue de circuler
 * dans leur branche commune, et ses pointes ne doivent pas y sauter : il
 * suffit que les deux mailles partent du même point de cette branche, la
 * parcourent dans le même sens, et que `pas` divise leurs deux longueurs.
 */
export function courant(c, plan, sommets, { décalage = 0, sens = 1, couleur = NOIR, pas = 1 } = {}) {
    const points = vers(plan, [...sommets, sommets[0]]);
    c.save();
    c.globalAlpha = 0.3;
    chemin(c, points, { couleur, épaisseur: 5 });
    c.restore();
    const longueurs = points.slice(1).map((p, k) => Math.hypot(p[0] - points[k][0], p[1] - points[k][1]));
    const total = longueurs.reduce((s, l) => s + l, 0);
    const n = Math.max(1, Math.round(total / plan.long(pas)));
    const écart = total / n;
    let s = ((décalage % écart) + écart) % écart;
    let k = 0;
    let début = 0;
    for (let j = 0; j < n; j++, s += écart) {
        while (k < longueurs.length - 1 && s > début + longueurs[k]) début += longueurs[k++];
        const [p, q] = [points[k], points[k + 1]];
        const u = [(q[0] - p[0]) / longueurs[k], (q[1] - p[1]) / longueurs[k]];
        pointe(c, le(p, u, s - début), [sens * u[0], sens * u[1]], { couleur, taille: 10 });
    }
}
