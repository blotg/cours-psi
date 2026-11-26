// Le hacheur série alimentant un moteur à courant continu, tel que le cours
// l'étudie : une source de tension E, la cellule de commutation (K₁, K₂), et
// le moteur, une inductance L en série avec sa force contre-électromotrice,
// de résistance négligée.
//
// Rien ne s'intègre pas à pas : sans résistance, le courant est affine par
// morceaux et le régime périodique s'écrit. Le courant moyen ⟨i_s⟩ est une
// donnée — c'est le couple résistant qui le fixe —, et la force
// contre-électromotrice s'ajuste (le moteur prend sa vitesse) pour que la
// tension moyenne aux bornes de la bobine soit nulle.
//
// - Conduction continue, tant que ⟨i_s⟩ dépasse la demi-ondulation :
//   E_cém = αE, et i_s oscille de Δi_s = α(1 − α)E/(Lf) autour de sa moyenne.
// - Conduction discontinue, en deçà : le courant s'annule avant la fin de la
//   période, les deux interrupteurs sont alors ouverts et u_s = E_cém. La
//   force contre-électromotrice dépasse αE : à vide, le moteur s'emballe.
//
// À gauche le schéma, où des pointes suivent le courant ; à droite les
// chronogrammes de u_s, i_s et i_e, que parcourt le même instant.
//
// L'animation est à l'échelle 1 : la fréquence affichée est celle à laquelle
// les interrupteurs commutent à l'écran, de l'ordre du hertz, et le temps
// des chronogrammes se compte en secondes. Pas de ralenti à deviner : on
// hache lentement, et l'inductance se compte en henrys pour que l'ondulation
// reste de l'ordre de l'ampère (seul compte le produit L f). Les
// chronogrammes montrent toujours les mêmes dix secondes : monter la
// fréquence resserre les périodes — et l'on voit pourquoi l'ondulation
// diminue, les pentes du courant ne changent pas, il a seulement moins de
// temps pour monter.

import { Graphe } from '#animations/graphe.js';
import { COULEURS, écritTex } from '#animations/objets.js';
import { cadre, lance } from '#animations/page.js';
import { Plan, chemin } from '#animations/plan.js';
import { Réglages } from '#animations/reglages.js';
import { bobine, courant, fil, interrupteur, nœud, sens, source, tension } from './schema.js';

/** La tension de la source, en volts : la batterie d'une perceuse. */
const E = 18;

/** Le haut de l'échelle des courants, en ampères. Avec les bornes des
 *  curseurs (L ≥ 5 H, f ≥ 0,2 Hz, ⟨i_s⟩ ≤ 4 A), i_s ne dépasse pas 6,25 A. */
const I_AXE = 6;
const AIR = 1.14;

/** La fenêtre de temps des chronogrammes, en secondes : l'instant courant
 *  la parcourt en temps réel. */
const FENÊTRE = 10;
/** La vitesse des pointes du schéma, en pixels par seconde et par ampère. */
const ALLURE = 22;

const COULEUR = { us: COULEURS.vert, is: COULEURS.vermillon, ie: COULEURS.bleu, moyenne: COULEURS.noir };
const GRIS = '#8a8a8a';

const décimales = (n) => new Intl.NumberFormat('fr-FR', { minimumFractionDigits: n, maximumFractionDigits: n });
const [UNE, DEUX] = [décimales(1), décimales(2)];
/** Un nombre écrit à la française et lisible par KaTeX. */
const nombre = (x, format = DEUX) => format.format(x).replace('−', '-').replace(',', '{,}');

/**
 * Le régime périodique : la force contre-électromotrice, les extrêmes du
 * courant et β, la part de la période où K₂ conduit. f en hertz, L en henrys.
 */
function régime({ α, f, L, I }) {
    const K = E / (2 * L * f);
    const demiOndulation = α * (1 - α) * K;
    if (I >= demiOndulation) {
        return { continu: true, Ecém: α * E, min: I - demiOndulation, max: I + demiOndulation, β: 1 - α };
    }
    // Le courant part de zéro, monte pendant αT, redescend pendant βT, et la
    // moyenne ⟨i_s⟩ = i_max (α + β)/2 fixe x = E_cém/E.
    const x = (α * α * K) / (I + α * α * K);
    return { continu: false, Ecém: x * E, min: 0, max: 2 * K * α * (1 - x), β: (α * (1 - x)) / x };
}

/** L'état du montage à l'instant t, compté en périodes (t = f × le temps). */
function instant(r, α, t) {
    const p = t - Math.floor(t);
    if (p < α) return { K1: true, K2: false, us: E, is: r.min + ((r.max - r.min) * p) / α };
    if (r.continu || p < α + r.β) return { K1: false, K2: true, us: 0, is: r.max - ((r.max - r.min) * (p - α)) / r.β };
    return { K1: false, K2: false, us: r.Ecém, is: 0 };
}

/** Les chronogrammes sur la fenêtre, en lignes brisées : le temps en
 *  secondes, f en hertz. La dernière période dépasse, le cadre la
 *  coupe. */
function chronogrammes(r, α, f) {
    const [us, is, ie] = [[], [], []];
    const fin = α + r.β;
    for (let k = 0; k < FENÊTRE * f; k++) {
        if (α > 0) {
            us.push([k, E], [k + α, E]);
            is.push([k, r.min], [k + α, r.max]);
            ie.push([k, 0], [k, r.min], [k + α, r.max], [k + α, 0]);
        }
        if (r.β > 0) {
            us.push([k + α, 0], [k + fin, 0]);
            is.push([k + α, r.max], [k + fin, r.min]);
        }
        if (!r.continu) {
            us.push([k + fin, r.Ecém], [k + 1, r.Ecém]);
            is.push([k + fin, 0], [k + 1, 0]);
        }
        ie.push([k + α, 0], [k + 1, 0]);
    }
    const enMs = (points) => points.map(([t, y]) => [t / f, y]);
    return { us: enMs(us), is: enMs(is), ie: enMs(ie) };
}

function hacheur(section) {
    const { vue, réglages: panneau } = cadre(section);
    const état = { α: 0.5, f: 0.3, L: 10, I: 2, temps: 0, avance: 0, pause: false };
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
    const SECONDES = [0, 2, 4, 6, 8, 10];
    const temps = (noms) => ({
        min: 0,
        max: FENÊTRE,
        graduations: noms ? SECONDES : SECONDES.map((t) => [t, '']),
    });
    const courants = [0, 2, 4, 6];
    const graphes = {
        us: new Graphe({
            ...taille,
            marges,
            x: temps(false),
            y: { min: 0, max: AIR * E, nom: 'u_s\\ (\\mathrm{V})', couleur: COULEUR.us, graduations: [0, 6, 12, 18] },
        }),
        is: new Graphe({
            ...taille,
            marges,
            x: temps(false),
            y: { min: 0, max: AIR * I_AXE, nom: 'i_s\\ (\\mathrm{A})', couleur: COULEUR.is, graduations: courants },
        }),
        ie: new Graphe({
            ...taille,
            hauteur: 164,
            marges: { ...marges, bas: 22 },
            x: temps(true),
            y: { min: 0, max: AIR * I_AXE, nom: 'i_e\\ (\\mathrm{A})', couleur: COULEUR.ie, graduations: courants },
        }),
    };
    for (const g of Object.values(graphes)) g.élément.style.margin = '0.6rem 0.6rem';
    pile.append(...Object.values(graphes).map((g) => g.élément));
    // Le nom de l'axe des temps, au bout de ses graduations : sur l'axe, il
    // tomberait sur celui de la moyenne.
    graphes.ie.légende('t\\ (\\mathrm{s})', { x: FENÊTRE, y: 0, ancre: 'gauche', décalage: [20, 13] });
    // La période, cotée au-dessus du premier créneau.
    const période = graphes.us.cote('T', { couleur: GRIS });

    // L'ondulation : la bande que balaie le courant.
    const bande = graphes.is.zone({ couleur: COULEUR.is, opacité: 0.13 });
    const tracés = {};
    const moyennes = {};
    const repères = {};
    for (const [nom, g] of Object.entries(graphes)) {
        tracés[nom] = g.courbe({ couleur: COULEUR[nom], épaisseur: 2.2 });
        moyennes[nom] = {
            droite: g.courbe({ couleur: COULEUR.moyenne, épaisseur: 1.4, pointillés: true }),
            // Un peu au-dessus de la droite : nulle, elle longe les graduations.
            nom: g.légende(`\\langle ${nom[0]}_${nom[1]}\\rangle`, { ancre: 'gauche', décalage: [5, -5] }),
        };
        repères[nom] = { instant: g.verticale({ couleur: GRIS }), point: g.point({ couleur: COULEUR[nom], rayon: 4.5 }) };
    }

    // -- Le schéma --------------------------------------------------------------
    //
    // La source à gauche, K₁ sur le fil du haut, K₂ entre les deux fils, le
    // moteur à droite : la bobine au-dessus de la force contre-électromotrice.

    const bord = { x0: -1.5, x1: 8.5, y0: -0.75, y1: 5.1 };
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
        ['E', -1.15, 2, {}],
        ['K_1', 1.5, 4.65, {}],
        ['K_2', 2.45, 2, {}],
        ['u_s', 4.75, 2, { couleur: COULEUR.us }],
        ['L', 5.45, 3, {}],
        ['E_\\text{cém}', 6.95, 1, { ancre: 'gauche' }],
        ['i_e', 0.42, 4.45, { couleur: COULEUR.ie }],
        ['i_s', 4.6, 4.45, { couleur: COULEUR.is }],
        ['\\text{moteur}', 6, 4.75, { couleur: GRIS, taille: '0.85rem' }],
    ].map(([tex, x, y, options]) => [schéma.étiquette(tex, { taille: '1rem', ...options }), x, y]);

    /** Les deux mailles que le courant peut suivre. */
    const MAILLES = {
        K1: [[0, 0], [0, 4], [6, 4], [6, 0]],
        K2: [[3, 0], [3, 4], [6, 4], [6, 0]],
    };

    schéma.dessine((c, plan) => {
        const { K1, K2, is } = instant(r, état.α, état.temps * état.f);
        // Le courant d'abord, sous les fils.
        if (is > 1e-3 && (K1 || K2)) {
            courant(c, plan, K1 ? MAILLES.K1 : MAILLES.K2, { décalage: état.avance, couleur: COULEUR.is });
        }
        // Le moteur, encadré.
        chemin(c, [[5.2, -0.35], [5.2, 4.4], [7, 4.4], [7, -0.35]].map((p) => plan.vers(...p)), {
            couleur: '#b0b0b0',
            épaisseur: 1,
            pointillés: [4, 4],
            fermé: true,
        });
        fil(c, plan, [[0, 0], [6, 0]]);
        fil(c, plan, [[3, 4], [6, 4]]);
        source(c, plan, [0, 0], [0, 4]);
        interrupteur(c, plan, [0, 4], [3, 4], K1);
        interrupteur(c, plan, [3, 0], [3, 4], K2, { côté: -1 });
        bobine(c, plan, [6, 4], [6, 2], { côté: -1 });
        source(c, plan, [6, 2], [6, 0]);
        for (const P of [[3, 0], [3, 4]]) nœud(c, plan, P);
        tension(c, plan, [-0.75, 1.4], [-0.75, 2.6]);
        tension(c, plan, [4.3, 0.8], [4.3, 3.2], { couleur: COULEUR.us });
        tension(c, plan, [6.75, 0.4], [6.75, 1.6]);
        sens(c, plan, [0.42, 4], [1, 0], { couleur: COULEUR.ie });
        sens(c, plan, [4.6, 4], [1, 0], { couleur: COULEUR.is });
        for (const [étiquette, x, y] of noms) étiquette.place(x, y);
    });

    // Côte à côte sur un écran large, l'un sous l'autre sur un écran étroit.
    new ResizeObserver(() => {
        const étroit = grille.clientWidth < 620;
        grille.style.gridTemplateColumns = étroit ? 'minmax(0, 1fr)' : 'minmax(0, 5fr) minmax(0, 6fr)';
        Object.assign(caseSchéma.style, {
            maxWidth: étroit ? '26rem' : '',
            width: '100%',
            justifySelf: 'center',
        });
        pile.style.borderLeft = étroit ? '' : '1px solid var(--filet-clair)';
        pile.style.borderTop = étroit ? '1px solid var(--filet-clair)' : '';
        for (const g of Object.values(graphes)) g.élément.classList.toggle('grand', g.élément.clientWidth >= 360);
    }).observe(grille);

    // -- Réglages -------------------------------------------------------------

    const réglages = new Réglages(panneau);
    const curseur = (clé, options) =>
        réglages.curseur({
            ...options,
            valeur: état[clé],
            auChangement: (v) => {
                état[clé] = v;
                recalcule();
            },
        });
    réglages.groupe('Commande');
    curseur('α', { tex: '\\alpha', min: 0, max: 1, pas: 0.01 });
    curseur('f', { tex: 'f', min: 0.2, max: 2, pas: 0.01, unité: ' Hz' });
    const donnée = réglages.texte();
    donnée.className = 'note';
    donnée.append(écritTex(document.createElement('span'), `E = ${E}\\,\\mathrm{V}`), '.');

    réglages.groupe('Moteur');
    curseur('L', { tex: 'L', min: 5, max: 50, pas: 0.2, unité: ' H' });
    curseur('I', { tex: '\\langle i_s\\rangle', min: 0, max: 4, pas: 0.02, unité: ' A', couleur: COULEUR.is });

    réglages.groupe('Régime périodique');
    const mesures = { us: réglages.formule(), ondulation: réglages.formule(), ie: réglages.formule() };
    const nature = réglages.texte();
    nature.className = 'note';

    // -- Le calcul, à chaque réglage ------------------------------------------

    function recalcule() {
        const { α, I } = état;
        r = régime(état);
        const courbes = chronogrammes(r, α, état.f);
        for (const [nom, points] of Object.entries(courbes)) tracés[nom].place(points);
        bande.place(0, FENÊTRE, r.min, r.max);
        // Trop courte, la cote n'est plus que deux pointes qui se touchent.
        période.place(0, 1 / état.f, 1.07 * E).montre(graphes.us.X(1 / état.f) - graphes.us.X(0) >= 26);

        const ie = (α * (r.min + r.max)) / 2;
        for (const [nom, valeur] of Object.entries({ us: r.Ecém, is: I, ie })) {
            moyennes[nom].droite.place([[0, valeur], [FENÊTRE, valeur]]);
            moyennes[nom].nom.place(FENÊTRE, valeur);
        }

        const vert = `{\\color{${COULEUR.us}}\\langle u_s\\rangle}`;
        const rouge = `{\\color{${COULEUR.is}}\\Delta i_s}`;
        const bleu = `{\\color{${COULEUR.ie}}\\langle i_e\\rangle}`;
        mesures.us.écrit(
            r.continu
                ? `${vert} = E_\\text{cém} = \\alpha E = ${nombre(r.Ecém, UNE)}\\,\\mathrm{V}`
                : `${vert} = E_\\text{cém} = ${nombre(r.Ecém, UNE)}\\,\\mathrm{V} > \\alpha E`,
        );
        mesures.ondulation.écrit(
            r.continu
                ? `${rouge} = \\dfrac{\\alpha (1 - \\alpha) E}{L f} = ${nombre(r.max - r.min)}\\,\\mathrm{A}`
                : `${rouge} = i_{s,\\max} = ${nombre(r.max)}\\,\\mathrm{A}`,
        );
        mesures.ie.écrit(
            r.continu
                ? `${bleu} = \\alpha \\langle i_s\\rangle = ${nombre(ie)}\\,\\mathrm{A}`
                : `${bleu} = ${nombre(ie)}\\,\\mathrm{A}`,
        );
        nature.textContent = r.continu
            ? 'Conduction continue.'
            : 'Conduction discontinue : le courant s’annule avant la fin de la période.';
        place();
    }

    /** Ce qui suit l'instant courant : les repères des chronogrammes, et le
     *  schéma. */
    function place() {
        const t = état.temps;
        const { K1, us, is } = instant(r, état.α, t * état.f);
        for (const [nom, valeur] of Object.entries({ us, is, ie: K1 ? is : 0 })) {
            repères[nom].instant.place(t);
            repères[nom].point.place(t, valeur);
        }
        schéma.redessine();
    }

    schéma.àChaqueImage((dt) => {
        if (état.pause || !dt) return;
        état.temps = (état.temps + dt) % FENÊTRE;
        état.avance += ALLURE * instant(r, état.α, état.temps * état.f).is * dt;
        place();
    });

    recalcule();
}

lance('section.animation', hacheur);
