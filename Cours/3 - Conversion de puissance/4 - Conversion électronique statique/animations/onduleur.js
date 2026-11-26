// L'onduleur du cours : une source de tension E, un pont de quatre
// interrupteurs, et une charge. Deux états seulement relient la source à la
// charge — K₁ et K₃ fermés (u = E), ou K₂ et K₄ fermés (u = −E).
//
// Deux commandes : un rapport cyclique α = 1/2 (un état par demi-période, la
// tension est un créneau), ou la modulation de largeur d'impulsion de
// l'exercice « Onduleur alimentant une charge inductive » — N périodes de
// MLI par période T, et dans la k-ième un rapport cyclique
// α = (1 + cos(2πk/N))/2, pris à son début comme dans le code de l'exercice.
//
// Trois charges :
// - une source de courant idéale, alternative : un courant sinusoïdal
//   d'amplitude I, en retard de φ sur le fondamental de u ;
// - un dipôle R-L ;
// - une phase d'un moteur synchrone : R, L et une force contre-électromotrice
//   sinusoïdale e, de même fréquence que la commande (le rotor tourne au
//   synchronisme) et d'amplitude Φ_max ω. Comme pour le hacheur, c'est le
//   couple résistant que l'on règle : il fixe le retard δ de e sur le
//   fondamental de u, jusqu'au couple maximal. Au-delà le moteur
//   décrocherait : on le laisse à cette limite, pour que e reste à l'écran,
//   et une note le dit.
//
// Rien ne s'intègre pas à pas. La charge est linéaire : le courant est la
// somme de la réponse de R-L à la tension u (entre deux commutations, il
// relaxe vers ±E/R, et il revient à sa valeur au bout d'une période, cf.
// `rl.js`) et de sa réponse à −e, sinusoïdale. Pour le moteur, seul le
// fondamental du courant échange de la puissance avec e, d'où δ : en
// notant U l'amplitude du fondamental de u, Z et φ le module et l'argument
// de R + jLω, et avec deux phases,
//     Γ_r = Φ_max (U cos(φ − δ) − Φ_max ω cos φ) / Z.
//
// À gauche le schéma, où des pointes suivent le courant : juste après une
// commutation, il remonte la source — la bobine lui rend de l'énergie, et
// i_e est négatif. À droite les chronogrammes de u, i et i_e.

import { Graphe, échantillons } from '#animations/graphe.js';
import { COULEURS, écritTex } from '#animations/objets.js';
import { cadre, lance } from '#animations/page.js';
import { Plan } from '#animations/plan.js';
import { Réglages } from '#animations/reglages.js';
import { instants, intégrale, évolue } from './rl.js';
import { secondes } from './temps.js';
import { bobine, courant, fil, interrupteur, nœud, résistance, sens, source, tension } from './schema.js';

/** La source, en volts, et l'échelle des courants, en ampères.
 *
 *  L'animation est à l'échelle 1 : la fréquence est celle que l'on voit à
 *  l'écran, une fraction de hertz, et l'inductance se compte en henrys pour
 *  que L/R soit de l'ordre de la période. */
const E = 100;
const I0 = 10;
const AIR = 1.22;
/** Le flux maximal du rotor à travers une phase du moteur, en webers : à
 *  1 Hz, la plus haute fréquence, e tient encore dans l'échelle de u. */
const Φ = 18;

/** Le nombre de périodes que montrent les chronogrammes. */
const PÉRIODES = 2;
/** La vitesse des pointes du schéma, en pixels par seconde et par ampère. */
const ALLURE = 13;

const COULEUR = { u: COULEURS.vert, i: COULEURS.vermillon, ie: COULEURS.bleu, visée: COULEURS.noir };
const GRIS = '#8a8a8a';
const TOUR = 2 * Math.PI;

const décimales = (n) => new Intl.NumberFormat('fr-FR', { minimumFractionDigits: n, maximumFractionDigits: n });
const [UNE, DEUX] = [décimales(1), décimales(2)];
/** Un nombre écrit à la française et lisible par KaTeX, espace des milliers
 *  comprise. */
const nombre = (x, format = DEUX) =>
    format.format(x).replace('−', '-').replace(',', '{,}').replace(/\s/g, '\\,');

/**
 * La séquence de commutation sur une période, le temps compté en périodes :
 * des intervalles { t0, t1, s }, s = +1 quand K₁ et K₃ sont fermés, −1 quand
 * ce sont K₂ et K₄.
 */
function séquence(commande, N) {
    if (commande === 'créneau') {
        return [
            { t0: 0, t1: 0.5, s: 1 },
            { t0: 0.5, t1: 1, s: -1 },
        ];
    }
    const intervalles = [];
    for (let k = 0; k < N; k++) {
        const α = (1 + Math.cos((TOUR * k) / N)) / 2;
        const bascule = (k + α) / N;
        if (α > 1e-9) intervalles.push({ t0: k / N, t1: bascule, s: 1 });
        if (α < 1 - 1e-9) intervalles.push({ t0: bascule, t1: (k + 1) / N, s: -1 });
    }
    return intervalles;
}

/** Le fondamental de la tension, U cos(2πt/T − θ) : son amplitude et son
 *  retard θ. */
function fondamental(intervalles) {
    let [C, S] = [0, 0];
    for (const { t0, t1, s } of intervalles) {
        C += (s * (Math.sin(TOUR * t1) - Math.sin(TOUR * t0))) / Math.PI;
        S += (s * (Math.cos(TOUR * t0) - Math.cos(TOUR * t1))) / Math.PI;
    }
    return { amplitude: E * Math.hypot(C, S), retard: Math.atan2(S, C) };
}

/**
 * La réponse périodique du dipôle R-L à la tension u : chaque intervalle
 * reçoit `i0`, le courant à son début. Sans résistance, c'est celle de
 * moyenne nulle.
 */
function réponse(intervalles, dipôle) {
    const { R, L, f } = dipôle;
    const suite = (i, x) => évolue(i, x.s * E, x.t1 - x.t0, dipôle);
    let i = 0;
    if (L > 0 && R > 0) {
        // i(T) est une fonction affine de i(0), de pente exp(−RT/L).
        i = intervalles.reduce(suite, 0) / (1 - Math.exp(-R / (L * f)));
    } else if (L > 0) {
        let aire = 0;
        for (const x of intervalles) {
            aire += intégrale(i, x.s * E, x.t1 - x.t0, dipôle);
            i = suite(i, x);
        }
        i = -aire;
    }
    return intervalles.map((x) => {
        const i0 = i;
        i = suite(i0, x);
        return { ...x, i0 };
    });
}

/**
 * Le régime périodique : les intervalles et leur courant de départ dans le
 * dipôle R-L (s'il y en a un), le terme sinusoïdal A cos(2πt/T − θ) qui s'y
 * ajoute, la force contre-électromotrice, la moyenne de i_e.
 */
function régime(état) {
    const { charge, f } = état;
    const suite = séquence(état.commande, état.N);
    const U = fondamental(suite);
    const r = { U, dipôle: null, sinus: null, fcém: null, limite: false };
    if (charge === 'source') {
        r.intervalles = suite;
        r.sinus = { A: état.source.I, θ: U.retard + (état.source.φ * Math.PI) / 180 };
    } else {
        const { R, L } = état[charge];
        r.dipôle = { R, L, f };
        r.intervalles = réponse(suite, r.dipôle);
        const X = L * TOUR * f;
        r.Z = Math.hypot(R, X);
        r.φ = Math.atan2(X, R);
        if (charge === 'ms') {
            const amplitude = Φ * TOUR * f;
            const cosinus = ((r.Z * état.ms.Γ) / Φ + amplitude * Math.cos(r.φ)) / U.amplitude;
            r.limite = cosinus > 1;
            // La branche stable : le couple croit avec le retard de e, jusqu'à
            // son maximum, où l'on s'arrête.
            const θ = U.retard + r.φ - Math.acos(Math.min(1, cosinus));
            r.fcém = { amplitude, θ };
            r.sinus = { A: -amplitude / r.Z, θ: θ + r.φ };
        }
    }
    r.moyenne = 0;
    for (const x of r.intervalles) {
        const durée = x.t1 - x.t0;
        if (r.dipôle) r.moyenne += x.s * intégrale(x.i0, x.s * E, durée, r.dipôle);
        if (r.sinus) {
            const { A, θ } = r.sinus;
            r.moyenne += (x.s * A * (Math.sin(TOUR * x.t1 - θ) - Math.sin(TOUR * x.t0 - θ))) / TOUR;
        }
    }
    return r;
}

/** Le courant à l'instant p d'un intervalle. */
const courantDe = (r, x, p) =>
    (r.dipôle ? évolue(x.i0, x.s * E, p - x.t0, r.dipôle) : 0) + (r.sinus ? r.sinus.A * Math.cos(TOUR * p - r.sinus.θ) : 0);

/** L'état du montage à l'instant t, compté en périodes. */
function instant(r, t) {
    const p = t - Math.floor(t);
    const x = r.intervalles.find(({ t1 }) => p < t1) ?? r.intervalles.at(-1);
    return { s: x.s, i: courantDe(r, x, p) };
}

/** Les chronogrammes, le temps en périodes. */
function chronogrammes(r) {
    const [u, i, ie] = [[], [], []];
    const dipôle = r.dipôle ?? { R: 0, L: 1, f: 1 };
    for (let k = 0; k < PÉRIODES; k++) {
        for (const x of r.intervalles) {
            u.push([k + x.t0, x.s * E], [k + x.t1, x.s * E]);
            // Assez de points pour la sinusoïde, s'il y en a une.
            const minimum = r.sinus ? Math.ceil(60 * (x.t1 - x.t0)) : 1;
            for (const p of instants(x.t0, x.t1, dipôle, minimum)) {
                const valeur = courantDe(r, x, p);
                i.push([k + p, valeur]);
                ie.push([k + p, x.s * valeur]);
            }
        }
    }
    return { u, i, ie };
}

function onduleur(section) {
    const { vue, réglages: panneau } = cadre(section);
    const état = {
        commande: 'créneau',
        N: 20,
        f: 0.25,
        visée: true,
        charge: 'rl',
        source: { I: 8, φ: 30 },
        rl: { R: 10, L: 6 },
        ms: { R: 2, L: 12, Γ: 20 },
        temps: 0,
        avance: 0,
        pause: false,
    };
    let r = régime(état);

    // -- La mise en page : le schéma, les chronogrammes à côté ----------------

    const grille = document.createElement('div');
    const caseSchéma = document.createElement('div');
    const pile = document.createElement('div');
    Object.assign(grille.style, { display: 'grid', alignItems: 'center' });
    grille.append(caseSchéma, pile);
    vue.append(grille);

    // -- Les chronogrammes ----------------------------------------------------

    const taille = { largeur: 480, hauteur: 150, grand: true, coupe: true };
    const marges = { gauche: 58, droite: 68, haut: 24, bas: 8 };
    // L'abscisse se compte en périodes ; les graduations, en secondes, se
    // posent à chaque réglage.
    const temps = { min: 0, max: PÉRIODES, graduations: [] };
    const courants = [-10, 0, 10];
    const graphes = {
        u: new Graphe({
            ...taille,
            marges,
            x: temps,
            y: { min: -AIR * E, max: AIR * E, nom: 'u\\ (\\mathrm{V})', couleur: COULEUR.u, graduations: [-100, 0, 100] },
        }),
        i: new Graphe({
            ...taille,
            marges,
            x: temps,
            y: { min: -AIR * I0, max: AIR * I0, nom: 'i\\ (\\mathrm{A})', couleur: COULEUR.i, graduations: courants },
        }),
        ie: new Graphe({
            ...taille,
            hauteur: 164,
            marges: { ...marges, bas: 22 },
            x: temps,
            y: { min: -AIR * I0, max: AIR * I0, nom: 'i_e\\ (\\mathrm{A})', couleur: COULEUR.ie, graduations: courants },
        }),
    };
    for (const g of Object.values(graphes)) g.élément.style.margin = '0.6rem 0.6rem';
    pile.append(...Object.values(graphes).map((g) => g.élément));
    // Le nom de l'axe des temps, au bout de ses graduations : sur l'axe, il
    // tomberait sur celui de la moyenne.
    graphes.ie.légende('t\\ (\\mathrm{s})', { x: PÉRIODES, y: -AIR * I0, ancre: 'gauche', décalage: [20, 13] });
    // La période, cotée au-dessus de la tension.
    graphes.u.cote('T', { couleur: GRIS }).place(0, 1, 1.13 * E);

    // La force contre-électromotrice du moteur, sous la tension.
    const fcém = {
        courbe: graphes.u.courbe({ couleur: GRIS, épaisseur: 1.6 }),
        nom: graphes.u.légende('e', { ancre: 'gauche', couleur: GRIS, décalage: [5, 0] }),
    };
    const tracés = {};
    const repères = {};
    for (const [nom, g] of Object.entries(graphes)) {
        tracés[nom] = g.courbe({ couleur: COULEUR[nom], épaisseur: nom === 'i' ? 2.2 : 1.8 });
        repères[nom] = { instant: g.verticale({ couleur: GRIS }), point: g.point({ couleur: COULEUR[nom], rayon: 4.5 }) };
    }
    // Ce que vise la MLI : la tension moyennée sur une période de MLI, et le
    // courant qu'elle ferait passer.
    const visées = {
        u: graphes.u.courbe({ couleur: COULEUR.visée, épaisseur: 1.4, pointillés: true }),
        i: graphes.i.courbe({ couleur: COULEUR.visée, épaisseur: 1.4, pointillés: true }),
    };
    const moyenne = {
        droite: graphes.ie.courbe({ couleur: COULEURS.noir, épaisseur: 1.4, pointillés: true }),
        nom: graphes.ie.légende('\\langle i_e\\rangle', { ancre: 'gauche', décalage: [5, 0] }),
    };

    // -- Le schéma --------------------------------------------------------------
    //
    // Celui du cours : la source à gauche, K₁ et K₄ sur le bras de gauche, K₂
    // et K₃ sur celui de droite, la charge entre leurs milieux.

    const bord = { x0: -1.6, x1: 8.4, y0: -0.7, y1: 5.3 };
    const schéma = new Plan(caseSchéma, {
        rapport: (bord.x1 - bord.x0) / (bord.y1 - bord.y0),
        étendue: bord.x1 - bord.x0,
        centre: [(bord.x0 + bord.x1) / 2, (bord.y0 + bord.y1) / 2],
    });
    const pause = schéma.bouton('Pause', () => {
        état.pause = !état.pause;
        pause.textContent = état.pause ? 'Reprendre' : 'Pause';
    });
    const étiquette = (tex, options = {}) => schéma.étiquette(tex, { taille: '1rem', ...options });
    const noms = [
        ['E', -1.15, 2.2, {}],
        ['K_1', 1.4, 3.3, {}],
        ['K_4', 1.4, 1.1, {}],
        ['K_2', 7.6, 3.3, {}],
        ['K_3', 7.6, 1.1, {}],
        ['u', 4.5, 1.15, { couleur: COULEUR.u }],
        ['i', 2.42, 2.6, { couleur: COULEUR.i }],
        ['i_e', 1, 4.82, { couleur: COULEUR.ie }],
    ].map(([tex, x, y, options]) => [étiquette(tex, options), x, y]);
    /** Les noms des dipôles de la charge : chacune a les siens. */
    const dipôles = { R: étiquette('R'), L: étiquette('L'), e: étiquette('e') };

    /**
     * Les deux mailles, dans le sens où i est positif. Elles partent du même
     * point et commencent par la charge, où le courant ne s'interrompt pas ;
     * leur longueur commune, 22,8, est un multiple du pas des pointes.
     * Celles de la charge ne sautent donc pas à la commutation, alors que le
     * courant se retourne dans la source.
     */
    const MAILLES = {
        1: [[2, 2.2], [7, 2.2], [7, 0], [0, 0], [0, 4.4], [2, 4.4]],
        '-1': [[2, 2.2], [7, 2.2], [7, 4.4], [0, 4.4], [0, 0], [2, 0]],
    };
    const PAS = 1.2;

    /** La charge, entre les milieux des deux bras, et les noms de ses
     *  dipôles. */
    function dessineLaCharge(c, plan) {
        const posés = new Set();
        const nomme = (nom, x, y) => {
            dipôles[nom].montre().place(x, y);
            posés.add(nom);
        };
        if (état.charge === 'source') {
            source(c, plan, [2, 2.2], [7, 2.2], { genre: 'courant' });
        } else if (état.charge === 'rl') {
            résistance(c, plan, [2, 2.2], [4.5, 2.2]);
            bobine(c, plan, [4.5, 2.2], [7, 2.2]);
            nomme('R', 3.3, 2.78);
            nomme('L', 5.7, 2.85);
        } else {
            // La source s'arrête avant le bras de droite : la lame de K₂,
            // ouverte, passe au-dessus du fil.
            résistance(c, plan, [2, 2.2], [4.05, 2.2], { longueur: 0.95 });
            bobine(c, plan, [4.05, 2.2], [5.15, 2.2], { longueur: 0.9 });
            source(c, plan, [5.15, 2.2], [6.45, 2.2], { rayon: 0.4, genre: 'alternative' });
            fil(c, plan, [[6.45, 2.2], [7, 2.2]]);
            tension(c, plan, [6.25, 2.82], [5.35, 2.82]);
            nomme('R', 3.02, 2.78);
            nomme('L', 4.6, 2.85);
            nomme('e', 5.8, 3.22);
        }
        for (const [nom, dipôle] of Object.entries(dipôles)) if (!posés.has(nom)) dipôle.montre(false);
    }

    schéma.dessine((c, plan) => {
        const { s, i } = instant(r, état.temps);
        // Le courant d'abord, sous les fils.
        if (Math.abs(i) > 0.02) {
            courant(c, plan, MAILLES[s], { décalage: état.avance, sens: Math.sign(i), couleur: COULEUR.i, pas: PAS });
        }
        fil(c, plan, [[0, 4.4], [7, 4.4]]);
        fil(c, plan, [[0, 0], [7, 0]]);
        source(c, plan, [0, 0], [0, 4.4]);
        interrupteur(c, plan, [2, 4.4], [2, 2.2], s > 0);
        interrupteur(c, plan, [2, 2.2], [2, 0], s < 0);
        interrupteur(c, plan, [7, 4.4], [7, 2.2], s < 0, { côté: -1 });
        interrupteur(c, plan, [7, 2.2], [7, 0], s > 0, { côté: -1 });
        dessineLaCharge(c, plan);
        for (const P of [[2, 4.4], [2, 2.2], [7, 2.2], [2, 0]]) nœud(c, plan, P);
        tension(c, plan, [-0.75, 1.6], [-0.75, 2.8]);
        tension(c, plan, [6.4, 1.6], [2.6, 1.6], { couleur: COULEUR.u });
        sens(c, plan, [2.42, 2.2], [1, 0], { couleur: COULEUR.i });
        sens(c, plan, [1, 4.4], [1, 0], { couleur: COULEUR.ie });
        for (const [nom, x, y] of noms) nom.place(x, y);
    });

    // Côte à côte sur un écran large, l'un sous l'autre sur un écran étroit.
    new ResizeObserver(() => {
        const étroit = grille.clientWidth < 620;
        grille.style.gridTemplateColumns = étroit ? 'minmax(0, 1fr)' : 'minmax(0, 5fr) minmax(0, 6fr)';
        Object.assign(caseSchéma.style, {
            maxWidth: étroit ? '24rem' : '',
            width: '100%',
            justifySelf: 'center',
        });
        pile.style.borderLeft = étroit ? '' : '1px solid var(--filet-clair)';
        pile.style.borderTop = étroit ? '1px solid var(--filet-clair)' : '';
        for (const g of Object.values(graphes)) g.élément.classList.toggle('grand', g.élément.clientWidth >= 360);
    }).observe(grille);

    // -- Réglages -------------------------------------------------------------

    const réglages = new Réglages(panneau);
    /** Un curseur qui règle `objet[clé]`. */
    const curseur = (objet, clé, options) =>
        réglages.curseur({
            ...options,
            valeur: objet[clé],
            auChangement: (v) => {
                objet[clé] = v;
                recalcule();
            },
        });
    /** Une ligne du panneau — une formule ou une note — que l'on cache en
     *  ne lui donnant rien à écrire. */
    const formule = () => {
        const f = réglages.formule();
        const ligne = réglages.courant.lastElementChild;
        return {
            écrit(tex) {
                ligne.hidden = !tex;
                if (tex) f.écrit(tex);
            },
        };
    };
    const note = () => {
        const p = réglages.texte();
        p.className = 'note';
        return p;
    };

    réglages.groupe('Commande');
    curseur(état, 'f', { tex: 'f', min: 0.1, max: 1, pas: 0.005, unité: ' Hz' });
    const période = formule();
    réglages.choix({
        options: [
            ['créneau', '\\alpha = 1/2'],
            ['mli', '\\text{MLI}'],
        ],
        valeur: état.commande,
        auChangement: (commande) => {
            état.commande = commande;
            recalcule();
        },
    });
    const curseurN = curseur(état, 'N', { tex: 'N', min: 3, max: 50, pas: 1 });
    const périodeMLI = formule();
    const caseVisée = réglages.case({
        texte: 'Sinusoïdes visées',
        valeur: état.visée,
        auChangement: (oui) => {
            état.visée = oui;
            recalcule();
        },
    });

    réglages.groupe('Charge');
    réglages.choix({
        options: [
            ['source', '\\text{source}'],
            ['rl', 'R\\text{-}L'],
            ['ms', '\\text{moteur}'],
        ],
        valeur: état.charge,
        auChangement: (charge) => {
            état.charge = charge;
            recalcule();
        },
    });
    const curseurs = {
        source: [
            curseur(état.source, 'I', { tex: 'I', min: 0, max: 10, pas: 0.1, unité: ' A', couleur: COULEUR.i }),
            curseur(état.source, 'φ', { tex: '\\varphi', min: -180, max: 180, pas: 1, unité: '°', aimants: [-90, 0, 90] }),
        ],
        rl: [
            curseur(état.rl, 'R', { tex: 'R', min: 10, max: 60, pas: 0.5, unité: ' Ω' }),
            curseur(état.rl, 'L', { tex: 'L', min: 0, max: 20, pas: 0.2, unité: ' H' }),
        ],
        ms: [
            curseur(état.ms, 'Γ', { tex: '\\Gamma_r', min: 0, max: 100, pas: 0.5, unité: ' N·m' }),
            curseur(état.ms, 'R', { tex: 'R', min: 0, max: 20, pas: 0.2, unité: ' Ω' }),
            curseur(état.ms, 'L', { tex: 'L', min: 2, max: 20, pas: 0.2, unité: ' H' }),
        ],
    };
    const mesure = formule();
    const remarque = note();
    const données = note();

    // -- Le calcul, à chaque réglage ------------------------------------------

    const τs = échantillons(0, PÉRIODES, 240);

    function recalcule() {
        const { charge } = état;
        const mli = état.commande === 'mli';
        r = régime(état);
        const courbes = chronogrammes(r);
        for (const [nom, points] of Object.entries(courbes)) tracés[nom].place(points);
        const { nommées, muettes } = secondes(PÉRIODES, état.f);
        graphes.u.grilleX.place(muettes);
        graphes.i.grilleX.place(muettes);
        graphes.ie.grilleX.place(nommées);
        moyenne.droite.place([[0, r.moyenne], [PÉRIODES, r.moyenne]]);
        moyenne.nom.place(PÉRIODES, r.moyenne);

        // La force contre-électromotrice, nommée à un maximum de la seconde
        // période : la première porte la cote de T.
        fcém.courbe.montre(Boolean(r.fcém));
        fcém.nom.montre(Boolean(r.fcém));
        if (r.fcém) {
            const { amplitude, θ } = r.fcém;
            fcém.courbe.place(τs.map((t) => [t, amplitude * Math.cos(TOUR * t - θ)]));
            const sommet = (((θ / TOUR) % 1) + 1) % 1;
            fcém.nom.place(1 + sommet, Math.min(amplitude, AIR * E - 14));
        }

        // La tension visée, E cos(2πt/T), et le courant qu'elle impose à la
        // charge : la réponse de R-L, d'amplitude E/Z et en retard de φ, et
        // celle à la force contre-électromotrice.
        const sinus = r.sinus ?? { A: 0, θ: 0 };
        visées.u.place(τs.map((t) => [t, E * Math.cos(TOUR * t)])).montre(mli && état.visée);
        if (r.dipôle) {
            visées.i.place(
                τs.map((t) => [t, (E / r.Z) * Math.cos(TOUR * t - r.φ) + sinus.A * Math.cos(TOUR * t - sinus.θ)]),
            );
        }
        visées.i.montre(mli && état.visée && Boolean(r.dipôle));

        curseurN.montre(mli);
        caseVisée.montre(mli);
        for (const [nom, liste] of Object.entries(curseurs)) for (const c of liste) c.montre(nom === charge);
        période.écrit(`T = \\dfrac{1}{f} = ${nombre(1 / état.f)}\\,\\mathrm{s}`);
        périodeMLI.écrit(mli ? `T_\\text{MLI} = \\dfrac{T}{N} = ${nombre(1 / (état.f * état.N))}\\,\\mathrm{s}` : '');
        mesure.écrit(
            charge === 'rl'
                ? `\\dfrac{L}{R} = ${nombre(état.rl.L / état.rl.R)}\\,\\mathrm{s}`
                : charge === 'ms'
                  ? `e_{\\max} = \\Phi_{\\max}\\,\\omega = ${nombre(Φ * TOUR * état.f, UNE)}\\,\\mathrm{V}`
                  : '',
        );
        remarque.hidden = !(charge === 'source' || r.limite);
        remarque.textContent = r.limite
            ? 'Couple maximal atteint : au-delà, le moteur décroche.'
            : 'φ : retard de i sur le fondamental de u.';
        données.replaceChildren(
            écritTex(
                document.createElement('span'),
                `E = ${E}\\,\\mathrm{V}${charge === 'ms' ? `,\\ \\Phi_{\\max} = ${Φ}\\,\\mathrm{Wb}` : ''}`,
            ),
            '.',
        );
        place();
    }

    /** Ce qui suit l'instant courant : les repères des chronogrammes, et le
     *  schéma. */
    function place() {
        const t = état.temps;
        const { s, i } = instant(r, t);
        for (const [nom, valeur] of Object.entries({ u: s * E, i, ie: s * i })) {
            repères[nom].instant.place(t);
            repères[nom].point.place(t, valeur);
        }
        schéma.redessine();
    }

    schéma.àChaqueImage((dt) => {
        if (état.pause || !dt) return;
        // Le temps se compte en périodes : au bout de la deuxième, il reprend
        // au début de la première, dans le même état.
        état.temps = (état.temps + dt * état.f) % PÉRIODES;
        // Les pointes suivent i, le courant de la charge : c'est sur elle
        // qu'elles avancent sans à-coup.
        état.avance += ALLURE * instant(r, état.temps).i * dt;
        place();
    });

    recalcule();
}

lance('section.animation', onduleur);
