// L'onduleur du cours : une source de tension E, un pont de quatre
// interrupteurs, une charge R-L. Deux états seulement relient la source à la
// charge — K₁ et K₃ fermés (u = E), ou K₂ et K₄ fermés (u = −E).
//
// Deux commandes : un rapport cyclique α = 1/2 (un état par demi-période, la
// tension est un créneau), ou la modulation de largeur d'impulsion de
// l'exercice « Onduleur alimentant une charge inductive » — N périodes de
// MLI par période T, et dans la k-ième un rapport cyclique
// α = (1 + cos(2πk/N))/2, pris à son début comme dans le code de l'exercice.
//
// Rien ne s'intègre pas à pas : entre deux commutations, le courant relaxe
// vers ±E/R avec la constante de temps L/R, et le régime périodique se
// trouve en écrivant que le courant revient à sa valeur au bout d'une
// période (l'application i(0) ↦ i(T) est affine).
//
// À gauche le schéma, où des pointes suivent le courant : juste après une
// commutation, il remonte la source — la bobine lui rend de l'énergie, et
// i_e est négatif. À droite les chronogrammes de u, i et i_e.

import { Graphe, échantillons } from '#animations/graphe.js';
import { COULEURS, écritTex } from '#animations/objets.js';
import { cadre, lance } from '#animations/page.js';
import { Plan } from '#animations/plan.js';
import { Réglages } from '#animations/reglages.js';
import { bobine, courant, fil, interrupteur, nœud, résistance, sens, source, tension } from './schema.js';

/** La source, la résistance de la charge et la période voulue en sortie :
 *  volts, ohms, secondes. Le courant se compte donc en E/R = 10 A.
 *
 *  L'animation est à l'échelle 1 : la période est celle que l'on voit à
 *  l'écran, quatre secondes, et l'inductance se compte en henrys pour que
 *  L/R soit de cet ordre. */
const E = 100;
const R = 10;
const T = 4;
const I0 = E / R;
const AIR = 1.22;

/** La vitesse des pointes du schéma, en pixels par seconde et par ampère. */
const ALLURE = 13;

const COULEUR = { u: COULEURS.vert, i: COULEURS.vermillon, ie: COULEURS.bleu, visée: COULEURS.noir };
const GRIS = '#8a8a8a';

const décimales = (n) => new Intl.NumberFormat('fr-FR', { minimumFractionDigits: n, maximumFractionDigits: n });
const DEUX = décimales(2);
/** Un nombre écrit à la française et lisible par KaTeX. */
const nombre = (x, format = DEUX) => format.format(x).replace('−', '-').replace(',', '{,}');

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
        const α = (1 + Math.cos((2 * Math.PI * k) / N)) / 2;
        const bascule = (k + α) / N;
        if (α > 1e-9) intervalles.push({ t0: k / N, t1: bascule, s: 1 });
        if (α < 1 - 1e-9) intervalles.push({ t0: bascule, t1: (k + 1) / N, s: -1 });
    }
    return intervalles;
}

/**
 * Le régime périodique, pour une constante de temps τ = L/R comptée en
 * périodes : chaque intervalle reçoit `i0`, le courant à son début (en
 * unités de E/R), et l'on rend aussi la moyenne de i_e.
 */
function régime(intervalles, τ) {
    if (τ === 0) return { intervalles: intervalles.map((x) => ({ ...x, i0: x.s })), moyenne: 1 };
    const suite = (i, { t0, t1, s }) => s + (i - s) * Math.exp(-(t1 - t0) / τ);
    // i(T) = a i(0) + b, avec a = exp(−T/τ) : le point fixe est b/(1 − a).
    let i = intervalles.reduce(suite, 0) / (1 - Math.exp(-1 / τ));
    let aire = 0;
    const avecCourant = intervalles.map((x) => {
        const i0 = i;
        i = suite(i0, x);
        // ∫ s i dt sur l'intervalle, i relaxant de i0 vers s.
        aire += x.s * (x.s * (x.t1 - x.t0) + (i0 - x.s) * τ * (1 - Math.exp(-(x.t1 - x.t0) / τ)));
        return { ...x, i0 };
    });
    return { intervalles: avecCourant, moyenne: aire };
}

/** Le courant (en E/R) à l'instant p d'un intervalle. */
const relaxe = ({ t0, s, i0 }, τ, p) => (τ === 0 ? s : s + (i0 - s) * Math.exp(-(p - t0) / τ));

/** L'état du montage à l'instant t, compté en périodes. */
function instant(r, τ, t) {
    const p = t - Math.floor(t);
    const x = r.intervalles.find(({ t1 }) => p < t1) ?? r.intervalles.at(-1);
    return { s: x.s, i: I0 * relaxe(x, τ, p) };
}

/** Les chronogrammes sur deux périodes. */
function chronogrammes(r, τ) {
    const [u, i, ie] = [[], [], []];
    for (const k of [0, 1]) {
        for (const x of r.intervalles) {
            const Δ = x.t1 - x.t0;
            u.push([k + x.t0, x.s * E], [k + x.t1, x.s * E]);
            // Assez de points pour une exponentielle, deux pour un segment.
            const n = τ === 0 ? 1 : Math.min(24, Math.max(1, Math.ceil((10 * Δ) / τ)));
            for (const p of échantillons(x.t0, x.t1, n)) {
                const valeur = I0 * relaxe(x, τ, p);
                i.push([k + p, valeur]);
                ie.push([k + p, x.s * valeur]);
            }
        }
    }
    return { u, i, ie };
}

function onduleur(section) {
    const { vue, réglages: panneau } = cadre(section);
    const état = { commande: 'créneau', N: 20, L: 6, visée: true, temps: 0, avance: 0, pause: false };
    const τ = () => état.L / R / T;
    let r = régime(séquence(état.commande, état.N), τ());

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
    // Le calcul compte le temps en périodes, l'axe le gradue en
    // secondes : deux périodes de 4 s.
    const INSTANTS = [0, 0.5, 1, 1.5, 2].map((t) => [t, String(t * T)]);
    const temps = (noms) => ({ min: 0, max: 2, graduations: noms ? INSTANTS : INSTANTS.map(([t]) => [t, '']) });
    const courants = [-10, 0, 10];
    const graphes = {
        u: new Graphe({
            ...taille,
            marges,
            x: temps(false),
            y: { min: -AIR * E, max: AIR * E, nom: 'u\\ (\\mathrm{V})', couleur: COULEUR.u, graduations: [-100, 0, 100] },
        }),
        i: new Graphe({
            ...taille,
            marges,
            x: temps(false),
            y: { min: -AIR * I0, max: AIR * I0, nom: 'i\\ (\\mathrm{A})', couleur: COULEUR.i, graduations: courants },
        }),
        ie: new Graphe({
            ...taille,
            hauteur: 164,
            marges: { ...marges, bas: 22 },
            x: temps(true),
            y: { min: -AIR * I0, max: AIR * I0, nom: 'i_e\\ (\\mathrm{A})', couleur: COULEUR.ie, graduations: courants },
        }),
    };
    for (const g of Object.values(graphes)) g.élément.style.margin = '0.6rem 0.6rem';
    pile.append(...Object.values(graphes).map((g) => g.élément));
    // Le nom de l'axe des temps, au bout de ses graduations : sur l'axe, il
    // tomberait sur celui de la moyenne.
    graphes.ie.légende('t\\ (\\mathrm{s})', { x: 2, y: -AIR * I0, ancre: 'gauche', décalage: [15, 13] });

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
    const noms = [
        ['E', -1.15, 2.2, {}],
        ['K_1', 1.4, 3.3, {}],
        ['K_4', 1.4, 1.1, {}],
        ['K_2', 7.6, 3.3, {}],
        ['K_3', 7.6, 1.1, {}],
        ['R', 3.3, 2.78, {}],
        ['L', 5.7, 2.85, {}],
        ['u', 4.5, 1.15, { couleur: COULEUR.u }],
        ['i', 2.42, 2.6, { couleur: COULEUR.i }],
        ['i_e', 1, 4.82, { couleur: COULEUR.ie }],
    ].map(([tex, x, y, options]) => [schéma.étiquette(tex, { taille: '1rem', ...options }), x, y]);

    /** Les deux mailles, orientées comme i_e : de la borne + de la source
     *  vers la charge. */
    const MAILLES = {
        1: [[0, 0], [0, 4.4], [2, 4.4], [2, 2.2], [7, 2.2], [7, 0]],
        '-1': [[0, 0], [0, 4.4], [7, 4.4], [7, 2.2], [2, 2.2], [2, 0]],
    };

    schéma.dessine((c, plan) => {
        const { s, i } = instant(r, τ(), état.temps);
        // Le courant d'abord, sous les fils : il suit i_e = s i.
        if (Math.abs(i) > 0.02) {
            courant(c, plan, MAILLES[s], { décalage: état.avance, sens: Math.sign(s * i), couleur: COULEUR.i });
        }
        fil(c, plan, [[0, 4.4], [7, 4.4]]);
        fil(c, plan, [[0, 0], [7, 0]]);
        source(c, plan, [0, 0], [0, 4.4]);
        interrupteur(c, plan, [2, 4.4], [2, 2.2], s > 0);
        interrupteur(c, plan, [2, 2.2], [2, 0], s < 0);
        interrupteur(c, plan, [7, 4.4], [7, 2.2], s < 0, { côté: -1 });
        interrupteur(c, plan, [7, 2.2], [7, 0], s > 0, { côté: -1 });
        résistance(c, plan, [2, 2.2], [4.5, 2.2]);
        bobine(c, plan, [4.5, 2.2], [7, 2.2]);
        for (const P of [[2, 4.4], [2, 2.2], [7, 2.2], [2, 0]]) nœud(c, plan, P);
        tension(c, plan, [-0.75, 1.6], [-0.75, 2.8]);
        tension(c, plan, [6.4, 1.6], [2.6, 1.6], { couleur: COULEUR.u });
        sens(c, plan, [2.42, 2.2], [1, 0], { couleur: COULEUR.i });
        sens(c, plan, [1, 4.4], [1, 0], { couleur: COULEUR.ie });
        for (const [étiquette, x, y] of noms) étiquette.place(x, y);
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
    réglages.groupe('Commande');
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
    const curseurN = réglages.curseur({
        tex: 'N',
        min: 3,
        max: 50,
        pas: 1,
        valeur: état.N,
        auChangement: (N) => {
            état.N = N;
            recalcule();
        },
    });
    const formuleMLI = réglages.formule();
    const ligneMLI = réglages.courant.lastElementChild;
    const caseVisée = réglages.case({
        texte: 'Sinusoïdes visées',
        valeur: état.visée,
        auChangement: (oui) => {
            état.visée = oui;
            recalcule();
        },
    });

    réglages.groupe('Charge');
    réglages.curseur({
        tex: 'L',
        min: 0,
        max: 20,
        pas: 0.2,
        valeur: état.L,
        unité: ' H',
        auChangement: (L) => {
            état.L = L;
            recalcule();
        },
    });
    const formuleτ = réglages.formule();
    const données = réglages.texte();
    données.className = 'note';
    données.append(
        écritTex(document.createElement('span'), `E = ${E}\\,\\mathrm{V},\\ R = ${R}\\,\\Omega,\\ T = ${T}\\,\\mathrm{s}`),
        '.',
    );

    // -- Le calcul, à chaque réglage ------------------------------------------

    const τs = échantillons(0, 2, 240);

    function recalcule() {
        const mli = état.commande === 'mli';
        r = régime(séquence(état.commande, état.N), τ());
        const courbes = chronogrammes(r, τ());
        for (const [nom, points] of Object.entries(courbes)) tracés[nom].place(points);
        moyenne.droite.place([[0, I0 * r.moyenne], [2, I0 * r.moyenne]]);
        moyenne.nom.place(2, I0 * r.moyenne);

        // La tension visée, E cos(2πt/T), et le courant qu'elle impose à la
        // charge : amplitude E/|Z|, retard φ = arg(R + jLω).
        const X = (2 * Math.PI * état.L) / T;
        const [Z, φ] = [Math.hypot(R, X), Math.atan2(X, R)];
        visées.u.place(τs.map((t) => [t, E * Math.cos(2 * Math.PI * t)])).montre(mli && état.visée);
        visées.i.place(τs.map((t) => [t, (E / Z) * Math.cos(2 * Math.PI * t - φ)])).montre(mli && état.visée);

        curseurN.montre(mli);
        caseVisée.montre(mli);
        ligneMLI.hidden = !mli;
        formuleMLI.écrit(`T_\\text{MLI} = \\dfrac{T}{N} = ${nombre(T / état.N)}\\,\\mathrm{s}`);
        formuleτ.écrit(`\\dfrac{L}{R} = ${nombre(état.L / R)}\\,\\mathrm{s}`);
        place();
    }

    /** Ce qui suit l'instant courant : les repères des chronogrammes, et le
     *  schéma. */
    function place() {
        const t = état.temps;
        const { s, i } = instant(r, τ(), t);
        for (const [nom, valeur] of Object.entries({ u: s * E, i, ie: s * i })) {
            repères[nom].instant.place(t);
            repères[nom].point.place(t, valeur);
        }
        schéma.redessine();
    }

    schéma.àChaqueImage((dt) => {
        if (état.pause || !dt) return;
        état.temps = (état.temps + dt / T) % 2;
        const { s, i } = instant(r, τ(), état.temps);
        état.avance += ALLURE * s * i * dt;
        place();
    });

    recalcule();
}

lance('section.animation', onduleur);
