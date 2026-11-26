// Le hacheur série du cours : une source de tension E, la cellule de
// commutation (K₁, K₂), et l'une des trois charges qu'il étudie ou que l'on
// rencontre en exercice.
//
// - Une source de courant idéale : le courant I ne dépend de rien.
// - Un dipôle R-L : le courant relaxe vers E/R quand K₁ conduit, vers zéro
//   quand c'est K₂.
// - Un moteur à courant continu : une inductance L, sa force
//   contre-électromotrice, et une résistance R, nulle au départ comme dans le
//   cours — elle n'apparait alors pas sur le schéma.
//
// Ce que l'on règle sur le moteur, c'est le couple résistant Γ_r de ce qu'il
// entraine. Sans résistance, les équations électriques ne disent rien du
// courant moyen : la tension moyenne aux bornes de la bobine est nulle, ce
// qui fixe la force contre-électromotrice (E_cém = αE) et donc la vitesse,
// et c'est tout. Le courant moyen vient de la mécanique : à vitesse
// constante, Φ₀⟨i_s⟩ = Γ_r. Le rapport cyclique règle la vitesse, la charge
// mécanique règle le courant.
//
// Rien ne s'intègre pas à pas, les régimes périodiques s'écrivent (cf.
// `rl.js`) :
// - conduction continue, E_cém = αE − R⟨i_s⟩, et le courant revient à sa
//   valeur au bout d'une période ;
// - conduction discontinue, si ce courant devait passer par zéro : il
//   s'annule avant la fin de la période, les deux interrupteurs sont alors
//   ouverts et u_s = E_cém. La force contre-électromotrice dépasse αE (à
//   vide, le moteur s'emballe) ; elle se calcule, sans résistance, ou se
//   cherche par dichotomie ;
// - moteur à l'arrêt, si αE ne suffit pas à faire passer le courant que
//   demande le couple : il ne reste qu'un dipôle R-L.
//
// À gauche le schéma, où des pointes suivent le courant ; à droite les
// chronogrammes de u_s, i_s et i_e, que parcourt le même instant.
//
// L'animation est à l'échelle 1 : la fréquence affichée est celle à laquelle
// les interrupteurs commutent à l'écran, de l'ordre du hertz, et l'inductance
// se compte en henrys pour que l'ondulation reste de l'ordre de l'ampère. Les
// chronogrammes couvrent un nombre entier de périodes : l'instant qui les
// parcourt revient au début sans que rien ne saute, quelle que soit la
// fréquence. L'axe des temps reste gradué en secondes (cf. `temps.js`) : ses
// graduations glissent sous les courbes quand la fréquence change.

import { Graphe } from '#animations/graphe.js';
import { COULEURS, écritTex } from '#animations/objets.js';
import { cadre, lance } from '#animations/page.js';
import { Plan, chemin } from '#animations/plan.js';
import { Réglages } from '#animations/reglages.js';
import { instants, intégrale, évolue } from './rl.js';
import { secondes } from './temps.js';
import { bobine, courant, fil, interrupteur, nœud, résistance, sens, source, tension } from './schema.js';

/** La tension de la source, en volts : la batterie d'une perceuse. */
const E = 18;
/** La constante de couplage du moteur, en webers : à vide, 1800 rad/s. */
const Φ0 = 0.01;

/** Le haut de l'échelle des courants, en ampères : les bornes des curseurs
 *  n'y font presque jamais sortir i_s, et le cadre coupe ce qui dépasse. */
const I_AXE = 6;
const AIR = 1.14;

/** Le nombre de périodes que montrent les chronogrammes. */
const PÉRIODES = 3;
/** La vitesse des pointes du schéma, en pixels par seconde et par ampère. */
const ALLURE = 22;

const COULEUR = { us: COULEURS.vert, is: COULEURS.vermillon, ie: COULEURS.bleu, moyenne: COULEURS.noir };
const GRIS = '#8a8a8a';

const décimales = (n) => new Intl.NumberFormat('fr-FR', { minimumFractionDigits: n, maximumFractionDigits: n });
const [ZÉRO, UNE, DEUX] = [décimales(0), décimales(1), décimales(2)];
/** Un nombre écrit à la française et lisible par KaTeX, espace des milliers
 *  comprise. */
const nombre = (x, format = DEUX) =>
    format.format(x).replace('−', '-').replace(',', '{,}').replace(/\s/g, '\\,');

/** Le dipôle R-L de la charge, et le courant moyen que demande le couple
 *  résistant (réglé en mN·m). */
const DIPÔLE = {
    source: ({ f }) => ({ R: 0, L: 1, f }),
    rl: ({ rl, f }) => ({ ...rl, f }),
    moteur: ({ moteur, f }) => ({ R: moteur.R, L: moteur.L, f }),
};
const demandé = ({ moteur }) => (moteur.Γ * 1e-3) / Φ0;

/**
 * Le régime périodique : une suite de phases { t0, t1, K1, K2, us, v, i0 } —
 * le temps en périodes, v la tension aux bornes du dipôle R-L, i0 le courant
 * au début —, la force contre-électromotrice et les valeurs moyennes.
 */
function régime(état) {
    const { α, charge } = état;
    const dipôle = DIPÔLE[charge](état);
    const r = { dipôle, Ecém: 0, continu: true, arrêt: false };

    /** K₁ puis K₂, sous les tensions `von` et `voff`, en partant de i0. */
    const deux = (i0, von, voff) => [
        { t0: 0, t1: α, K1: true, us: E, v: von, i0 },
        { t0: α, t1: 1, K2: true, us: 0, v: voff, i0: évolue(i0, von, α, dipôle) },
    ];
    /** Le courant qui revient à sa valeur au bout d'une période : celle-ci
     *  est une fonction affine du courant de départ, de pente exp(−RT/L). */
    const périodique = (von, voff) => {
        if (dipôle.L === 0) return 0;
        const retour = évolue(évolue(0, von, α, dipôle), voff, 1 - α, dipôle);
        return retour / (1 - Math.exp(-dipôle.R / (dipôle.L * dipôle.f)));
    };
    /** Parti de zéro, le courant monte puis s'annule au bout de βT. */
    const discontinu = (Ecém, β) => [
        { t0: 0, t1: α, K1: true, us: E, v: E - Ecém, i0: 0 },
        { t0: α, t1: α + β, K2: true, us: 0, v: -Ecém, i0: évolue(0, E - Ecém, α, dipôle) },
        { t0: α + β, t1: 1, us: Ecém, nul: true },
    ];

    if (charge === 'source') {
        r.phases = deux(état.I, 0, 0);
    } else if (charge === 'rl') {
        r.phases = deux(périodique(E, 0), E, 0);
    } else if (dipôle.R === 0) {
        const I = demandé(état);
        const K = E / (2 * dipôle.L * dipôle.f);
        const demiOndulation = α * (1 - α) * K;
        if (I >= demiOndulation) {
            r.Ecém = α * E;
            r.phases = deux(I - demiOndulation, E - r.Ecém, -r.Ecém);
        } else {
            // La moyenne ⟨i_s⟩ = i_max (α + β)/2 fixe x = E_cém/E.
            const x = (α * α * K) / (I + α * α * K);
            r.Ecém = x * E;
            r.continu = false;
            r.phases = discontinu(r.Ecém, (α * (1 - x)) / x);
        }
    } else {
        const I = demandé(état);
        const { R, L, f } = dipôle;
        const Ecém = α * E - R * I;
        const départ = Ecém > 0 ? périodique(E - Ecém, -Ecém) : 0;
        if (Ecém <= 0) {
            r.arrêt = true;
            r.phases = deux(périodique(E, 0), E, 0);
        } else if (départ >= 0) {
            r.Ecém = Ecém;
            r.phases = deux(départ, E - Ecém, -Ecém);
        } else {
            // La force contre-électromotrice qui donne le courant moyen
            // demandé : il décroit quand elle augmente, et s'annule pour E.
            const τ = (L * f) / R;
            const durée = (x) => Math.min(1 - α, τ * Math.log(1 + (évolue(0, E - x, α, dipôle) * R) / x));
            const moyenne = (x) =>
                intégrale(0, E - x, α, dipôle) + intégrale(évolue(0, E - x, α, dipôle), -x, durée(x), dipôle);
            let [bas, haut] = [Ecém, E];
            for (let k = 0; k < 50; k++) {
                const milieu = (bas + haut) / 2;
                if (moyenne(milieu) > I) bas = milieu;
                else haut = milieu;
            }
            r.Ecém = (bas + haut) / 2;
            r.continu = false;
            r.phases = discontinu(r.Ecém, durée(r.Ecém));
        }
    }

    // Les extrêmes et les moyennes : le courant est monotone dans chaque
    // phase.
    r.moyenne = { us: 0, is: 0, ie: 0 };
    const extrêmes = [];
    for (const x of r.phases) {
        const durée = x.t1 - x.t0;
        if (durée < 1e-9) continue;
        r.moyenne.us += x.us * durée;
        if (x.nul) {
            extrêmes.push(0);
            continue;
        }
        const aire = intégrale(x.i0, x.v, durée, dipôle);
        r.moyenne.is += aire;
        if (x.K1) r.moyenne.ie += aire;
        extrêmes.push(évolue(x.i0, x.v, 0, dipôle), évolue(x.i0, x.v, durée, dipôle));
    }
    r.min = Math.max(0, Math.min(...extrêmes));
    r.max = Math.max(...extrêmes);
    return r;
}

/** Le courant à l'instant p d'une phase. */
const courantDe = (r, x, p) => (x.nul ? 0 : Math.max(0, évolue(x.i0, x.v, p - x.t0, r.dipôle)));

/** L'état du montage à l'instant t, compté en périodes. */
function instant(r, t) {
    const p = t - Math.floor(t);
    const x = r.phases.find(({ t1 }) => p < t1) ?? r.phases.at(-1);
    return { K1: Boolean(x.K1), K2: Boolean(x.K2), us: x.us, is: courantDe(r, x, p) };
}

/** Les chronogrammes, en lignes brisées, le temps en périodes. */
function chronogrammes(r) {
    const [us, is, ie] = [[], [], []];
    for (let k = 0; k < PÉRIODES; k++) {
        for (const x of r.phases) {
            if (x.t1 - x.t0 < 1e-9) continue;
            us.push([k + x.t0, x.us], [k + x.t1, x.us]);
            const points = (x.nul ? [x.t0, x.t1] : instants(x.t0, x.t1, r.dipôle)).map((p) => [k + p, courantDe(r, x, p)]);
            is.push(...points);
            if (x.K1) ie.push([k + x.t0, 0], ...points, [k + x.t1, 0]);
            else ie.push([k + x.t0, 0], [k + x.t1, 0]);
        }
    }
    return { us, is, ie };
}

function hacheur(section) {
    const { vue, réglages: panneau } = cadre(section);
    const état = {
        α: 0.5,
        f: 0.3,
        charge: 'moteur',
        I: 2,
        rl: { R: 6, L: 10 },
        moteur: { Γ: 20, L: 10, R: 0 },
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
    const courants = [0, 2, 4, 6];
    const graphes = {
        us: new Graphe({
            ...taille,
            marges,
            x: temps,
            y: { min: 0, max: AIR * E, nom: 'u_s\\ (\\mathrm{V})', couleur: COULEUR.us, graduations: [0, 6, 12, 18] },
        }),
        is: new Graphe({
            ...taille,
            marges,
            x: temps,
            y: { min: 0, max: AIR * I_AXE, nom: 'i_s\\ (\\mathrm{A})', couleur: COULEUR.is, graduations: courants },
        }),
        ie: new Graphe({
            ...taille,
            hauteur: 164,
            marges: { ...marges, bas: 22 },
            x: temps,
            y: { min: 0, max: AIR * I_AXE, nom: 'i_e\\ (\\mathrm{A})', couleur: COULEUR.ie, graduations: courants },
        }),
    };
    for (const g of Object.values(graphes)) g.élément.style.margin = '0.6rem 0.6rem';
    pile.append(...Object.values(graphes).map((g) => g.élément));
    // Le nom de l'axe des temps, au bout de ses graduations : sur l'axe, il
    // tomberait sur celui de la moyenne.
    graphes.ie.légende('t\\ (\\mathrm{s})', { x: PÉRIODES, y: 0, ancre: 'gauche', décalage: [20, 13] });
    // La période, cotée au-dessus du premier créneau.
    graphes.us.cote('T', { couleur: GRIS }).place(0, 1, 1.07 * E);

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
    // La source à gauche, K₁ sur le fil du haut, K₂ entre les deux fils, la
    // charge à droite, de haut en bas.

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
    const étiquette = (tex, options = {}) => schéma.étiquette(tex, { taille: '1rem', ...options });
    const noms = [
        ['E', -1.15, 2, {}],
        ['K_1', 1.5, 4.65, {}],
        ['K_2', 2.45, 2, {}],
        ['u_s', 4.75, 2, { couleur: COULEUR.us }],
        ['i_e', 0.42, 4.45, { couleur: COULEUR.ie }],
        ['i_s', 4.6, 4.45, { couleur: COULEUR.is }],
    ].map(([tex, x, y, options]) => [étiquette(tex, options), x, y]);
    /** Les noms des dipôles de la charge : chacune a les siens. */
    const dipôles = {
        I: étiquette('I', { ancre: 'gauche' }),
        R: étiquette('R'),
        L: étiquette('L'),
        Ecém: étiquette('E_\\text{cém}', { ancre: 'gauche' }),
        moteur: étiquette('\\text{moteur}', { couleur: GRIS, taille: '0.85rem' }),
    };

    /**
     * Les deux mailles que le courant peut suivre. Elles partent du même
     * point et commencent par la charge, où le courant passe toujours ; leurs
     * longueurs, 20 et 14, sont des multiples du pas des pointes. Celles de
     * la charge ne sautent donc pas à la commutation.
     */
    const MAILLES = {
        K1: [[3, 4], [6, 4], [6, 0], [3, 0], [0, 0], [0, 4]],
        K2: [[3, 4], [6, 4], [6, 0], [3, 0]],
    };

    /** La charge, sur la branche de droite, et les noms de ses dipôles. */
    function dessineLaCharge(c, plan) {
        const posés = new Set();
        const nomme = (nom, x, y) => {
            dipôles[nom].montre().place(x, y);
            posés.add(nom);
        };
        if (état.charge === 'source') {
            source(c, plan, [6, 4], [6, 0], { genre: 'courant' });
            nomme('I', 6.6, 2);
        } else if (état.charge === 'rl') {
            résistance(c, plan, [6, 4], [6, 2]);
            bobine(c, plan, [6, 2], [6, 0], { côté: -1 });
            nomme('R', 5.42, 3);
            nomme('L', 5.45, 1);
        } else {
            chemin(c, [[5.2, -0.35], [5.2, 4.4], [7, 4.4], [7, -0.35]].map((p) => plan.vers(...p)), {
                couleur: '#b0b0b0',
                épaisseur: 1,
                pointillés: [4, 4],
                fermé: true,
            });
            nomme('moteur', 6, 4.75);
            if (état.moteur.R > 0) {
                résistance(c, plan, [6, 4], [6, 2.8], { longueur: 0.8, largeur: 0.38 });
                bobine(c, plan, [6, 2.8], [6, 1.55], { longueur: 1, côté: -1 });
                source(c, plan, [6, 1.55], [6, 0], { rayon: 0.4 });
                tension(c, plan, [6.75, 0.3], [6.75, 1.25]);
                nomme('R', 5.5, 3.4);
                nomme('L', 5.5, 2.18);
                nomme('Ecém', 6.95, 0.78);
            } else {
                bobine(c, plan, [6, 4], [6, 2], { côté: -1 });
                source(c, plan, [6, 2], [6, 0]);
                tension(c, plan, [6.75, 0.4], [6.75, 1.6]);
                nomme('L', 5.45, 3);
                nomme('Ecém', 6.95, 1);
            }
        }
        for (const [nom, dipôle] of Object.entries(dipôles)) if (!posés.has(nom)) dipôle.montre(false);
    }

    schéma.dessine((c, plan) => {
        const { K1, K2, is } = instant(r, état.temps);
        // Le courant d'abord, sous les fils.
        if (is > 1e-3 && (K1 || K2)) {
            courant(c, plan, K1 ? MAILLES.K1 : MAILLES.K2, { décalage: état.avance, couleur: COULEUR.is });
        }
        fil(c, plan, [[0, 0], [6, 0]]);
        fil(c, plan, [[3, 4], [6, 4]]);
        source(c, plan, [0, 0], [0, 4]);
        interrupteur(c, plan, [0, 4], [3, 4], K1);
        interrupteur(c, plan, [3, 0], [3, 4], K2, { côté: -1 });
        dessineLaCharge(c, plan);
        for (const P of [[3, 0], [3, 4]]) nœud(c, plan, P);
        tension(c, plan, [-0.75, 1.4], [-0.75, 2.6]);
        tension(c, plan, [4.3, 0.8], [4.3, 3.2], { couleur: COULEUR.us });
        sens(c, plan, [0.42, 4], [1, 0], { couleur: COULEUR.ie });
        sens(c, plan, [4.6, 4], [1, 0], { couleur: COULEUR.is });
        for (const [nom, x, y] of noms) nom.place(x, y);
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
    curseur(état, 'α', { tex: '\\alpha', min: 0, max: 1, pas: 0.01 });
    curseur(état, 'f', { tex: 'f', min: 0.2, max: 2, pas: 0.01, unité: ' Hz' });
    const période = formule();

    réglages.groupe('Charge');
    réglages.choix({
        options: [
            ['source', '\\text{source}'],
            ['rl', 'R\\text{-}L'],
            ['moteur', '\\text{moteur}'],
        ],
        valeur: état.charge,
        auChangement: (charge) => {
            état.charge = charge;
            recalcule();
        },
    });
    const curseurs = {
        source: [curseur(état, 'I', { tex: 'I', min: 0, max: 5, pas: 0.05, unité: ' A', couleur: COULEUR.is })],
        rl: [
            curseur(état.rl, 'R', { tex: 'R', min: 3, max: 20, pas: 0.1, unité: ' Ω' }),
            curseur(état.rl, 'L', { tex: 'L', min: 0, max: 50, pas: 0.5, unité: ' H' }),
        ],
        moteur: [
            curseur(état.moteur, 'Γ', { tex: '\\Gamma_r', min: 0, max: 40, pas: 0.2, unité: ' mN·m' }),
            curseur(état.moteur, 'L', { tex: 'L', min: 5, max: 50, pas: 0.2, unité: ' H' }),
            // Jusqu'à L/R de l'ordre de la période : le courant se courbe.
            curseur(état.moteur, 'R', { tex: 'R', min: 0, max: 10, pas: 0.1, unité: ' Ω' }),
        ],
    };
    const constante = formule();
    const données = note();

    réglages.groupe('Régime périodique');
    const mesures = { us: formule(), Ecém: formule(), vitesse: formule(), is: formule(), ondulation: formule(), ie: formule() };
    const nature = note();

    // -- Le calcul, à chaque réglage ------------------------------------------

    function recalcule() {
        const { α, charge } = état;
        r = régime(état);
        const courbes = chronogrammes(r);
        for (const [nom, points] of Object.entries(courbes)) tracés[nom].place(points);
        const { nommées, muettes } = secondes(PÉRIODES, état.f);
        graphes.us.grilleX.place(muettes);
        graphes.is.grilleX.place(muettes);
        graphes.ie.grilleX.place(nommées);
        bande.place(0, PÉRIODES, r.min, r.max);
        for (const [nom, valeur] of Object.entries(r.moyenne)) {
            moyennes[nom].droite.place([[0, valeur], [PÉRIODES, valeur]]);
            moyennes[nom].nom.place(PÉRIODES, valeur);
        }

        for (const [nom, liste] of Object.entries(curseurs)) for (const c of liste) c.montre(nom === charge);
        période.écrit(`T = \\dfrac{1}{f} = ${nombre(1 / état.f)}\\,\\mathrm{s}`);
        constante.écrit(charge === 'rl' ? `\\dfrac{L}{R} = ${nombre(état.rl.L / état.rl.R)}\\,\\mathrm{s}` : '');
        données.replaceChildren(
            écritTex(
                document.createElement('span'),
                `E = ${E}\\,\\mathrm{V}${charge === 'moteur' ? ',\\ \\Phi_0 = 10\\,\\mathrm{mWb}' : ''}`,
            ),
            '.',
        );

        const moteur = charge === 'moteur';
        const résistif = moteur && état.moteur.R > 0;
        const us = `{\\color{${COULEUR.us}}\\langle u_s\\rangle}`;
        const is = `{\\color{${COULEUR.is}}\\langle i_s\\rangle}`;
        const Δ = `{\\color{${COULEUR.is}}\\Delta i_s}`;
        const ie = `{\\color{${COULEUR.ie}}\\langle i_e\\rangle}`;
        const volts = (x) => `${nombre(x, UNE)}\\,\\mathrm{V}`;
        const ampères = (x) => `${nombre(x)}\\,\\mathrm{A}`;

        if (!moteur) mesures.us.écrit(`${us} = \\alpha E = ${volts(r.moyenne.us)}`);
        else if (résistif) mesures.us.écrit(`${us} = E_\\text{cém} + R ${is} = ${volts(r.moyenne.us)}`);
        else if (r.continu) mesures.us.écrit(`${us} = E_\\text{cém} = \\alpha E = ${volts(r.Ecém)}`);
        else mesures.us.écrit(`${us} = E_\\text{cém} = ${volts(r.Ecém)} > \\alpha E`);
        mesures.Ecém.écrit(résistif ? `E_\\text{cém} = ${volts(r.Ecém)}` : '');
        mesures.vitesse.écrit(
            moteur ? `\\Omega = \\dfrac{E_\\text{cém}}{\\Phi_0} = ${nombre(r.Ecém / Φ0, ZÉRO)}\\,\\mathrm{rad\\cdot s^{-1}}` : '',
        );

        if (charge === 'source') mesures.is.écrit('');
        else if (charge === 'rl' || r.arrêt) mesures.is.écrit(`${is} = \\dfrac{\\alpha E}{R} = ${ampères(r.moyenne.is)}`);
        else mesures.is.écrit(`${is} = \\dfrac{\\Gamma_r}{\\Phi_0} = ${ampères(r.moyenne.is)}`);

        if (charge === 'source') mesures.ondulation.écrit('');
        else if (!r.continu) mesures.ondulation.écrit(`${Δ} = i_{s,\\max} = ${ampères(r.max)}`);
        else if (moteur && !résistif) {
            mesures.ondulation.écrit(`${Δ} = \\dfrac{\\alpha (1 - \\alpha) E}{L f} = ${ampères(r.max - r.min)}`);
        } else mesures.ondulation.écrit(`${Δ} = ${ampères(r.max - r.min)}`);

        if (charge === 'source') mesures.ie.écrit(`${ie} = \\alpha I = ${ampères(r.moyenne.ie)}`);
        else if (moteur && !résistif && r.continu) mesures.ie.écrit(`${ie} = \\alpha ${is} = ${ampères(r.moyenne.ie)}`);
        else mesures.ie.écrit(`${ie} = ${ampères(r.moyenne.ie)}`);

        nature.hidden = !moteur;
        nature.textContent = r.arrêt
            ? 'Moteur à l’arrêt : il ne peut pas fournir le couple demandé.'
            : r.continu
              ? 'Conduction continue.'
              : 'Conduction discontinue : le courant s’annule avant la fin de la période.';
        place();
    }

    /** Ce qui suit l'instant courant : les repères des chronogrammes, et le
     *  schéma. */
    function place() {
        const t = état.temps;
        const { K1, us, is } = instant(r, t);
        for (const [nom, valeur] of Object.entries({ us, is, ie: K1 ? is : 0 })) {
            repères[nom].instant.place(t);
            repères[nom].point.place(t, valeur);
        }
        schéma.redessine();
    }

    schéma.àChaqueImage((dt) => {
        if (état.pause || !dt) return;
        // Le temps se compte en périodes : au bout de la dernière, il reprend
        // au début de la première, dans le même état.
        état.temps = (état.temps + dt * état.f) % PÉRIODES;
        état.avance += ALLURE * instant(r, état.temps).is * dt;
        place();
    });

    recalcule();
}

lance('section.animation', hacheur);
