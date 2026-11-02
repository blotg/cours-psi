// Le courant dans une bobine avec cœur magnétique : la tension sinusoïdale
// imposée à ses bornes impose un champ sinusoïdal dans le cœur, et le cycle
// d'hystérésis dit quel courant il faut pour cela.
//
// La construction est celle de l'animation « Power Transformer
// Over-Excitation » de Wikimedia Commons, citée dans le cours : le champ B(t)
// à gauche, le cycle B(H) à droite, le courant i(t) dessous, le temps
// défilant à partir du cycle. Le point du cycle se lit en projetant celui de
// B(t) horizontalement, et l'on en tire le courant en projetant verticalement.
//
// Les trois graphiques sont des `Graphe` de même taille, dans une grille
// sans espace entre ses cases : le champ a la même échelle à gauche et dans
// le cycle, l'excitation la même dans le cycle et dessous (i = H l/N), et les
// projections passent d'un graphique à l'autre sans se briser.

import { Graphe, svg } from '#animations/graphe.js';
import { COULEURS, écritTex } from '#animations/objets.js';
import { cadre, lance } from '#animations/page.js';
import { Réglages } from '#animations/reglages.js';
import { MATÉRIAUX, période } from './noyau.js';

/** La bobine et son cœur : N spires sur une section S, une ligne moyenne de
 *  longueur l, une tension de fréquence f. Avec N/l = 800 m⁻¹, 1 A correspond
 *  à 800 A/m. */
const N = 200;
const S = 14e-4;
const l = 0.25;
const f = 50;

/** Le champ maximal, en teslas, que dessinent les graphiques. */
const B_AXE = 1.9;

/** La durée à l'écran d'une période, en secondes : un ralenti de deux cents
 *  fois. Et le nombre de périodes que garde l'historique. */
const DURÉE = 4;
const HISTOIRE = 2;

const COULEUR = { u: COULEURS.vert, B: COULEURS.bleu, i: COULEURS.vermillon, cycle: COULEURS.noir, projection: '#9a9a9a' };

const format = (chiffres) => new Intl.NumberFormat('fr-FR', { maximumSignificantDigits: chiffres, useGrouping: false });
const trois = format(3);
/** Un nombre, écrit à la française et lisible par KaTeX. */
const nombre = (x, f = trois) => f.format(x).replace('−', '-').replace(',', '{,}');

/** La plus petite valeur ronde qui dépasse x, et dont la moitié se lit
 *  aussi. Les seules valeurs 1, 2 et 5 laissaient le cycle n'occuper parfois
 *  que le tiers du graphique. */
function rondeAuDessus(x) {
    const décade = 10 ** Math.floor(Math.log10(x));
    return décade * [1, 1.2, 1.5, 2, 2.5, 3, 4, 5, 6, 8, 10].find((m) => m * décade >= x * (1 - 1e-9));
}

function bobine(section) {
    const { vue, réglages: panneau } = cadre(section);
    const état = { matériau: 'doux', Um: 130, temps: 0, pause: false };

    // -- Les trois graphiques -------------------------------------------------

    const taille = { largeur: 300, hauteur: 250, grand: true };
    const champ = new Graphe({
        ...taille,
        x: { min: -HISTOIRE, max: 0, nom: 't', graduations: [] },
        y: {
            min: -B_AXE,
            max: B_AXE,
            nom: 'B\\ (\\mathrm{T})',
            graduations: [
                [-1.5, '-1{,}5'],
                [0, '0'],
                [1.5, '1{,}5'],
            ],
        },
        marges: { gauche: 52, droite: 12, haut: 22, bas: 22 },
    });
    const cycle = new Graphe({
        ...taille,
        x: { min: -1.08, max: 1.08, nom: 'H\\ (\\mathrm{A/m})' },
        y: {
            min: -B_AXE,
            max: B_AXE,
            graduations: [
                [-1.5, ''],
                [0, ''],
                [1.5, ''],
            ],
        },
        marges: { gauche: 12, droite: 22, haut: 22, bas: 22 },
    });
    const courant = new Graphe({
        ...taille,
        x: { min: -1.08, max: 1.08 },
        y: { min: -HISTOIRE, max: 0, nom: '' },
        marges: { gauche: 12, droite: 22, haut: 6, bas: 22 },
    });

    // La case vide, en bas à gauche : les deux relations qui font passer
    // d'un graphique à l'autre.
    const relations = document.createElement('div');
    Object.assign(relations.style, { padding: '1rem 1.2rem', alignSelf: 'center' });
    const relation = (tex, texte) => {
        const p = document.createElement('p');
        p.style.margin = '0.7rem 0';
        const légende = document.createElement('span');
        Object.assign(légende.style, { fontSize: '0.85rem', color: 'var(--gris)' });
        légende.textContent = texte;
        p.append(écritTex(document.createElement('span'), tex), document.createElement('br'), légende);
        return p;
    };
    relations.append(
        relation(
            `{\\color{${COULEUR.u}}u} = N S \\dfrac{\\mathrm{d}{\\color{${COULEUR.B}}B}}{\\mathrm{d}t}`,
            'La tension imposée fixe le champ.',
        ),
        relation(`H\\,l = N\\,{\\color{${COULEUR.i}}i}`, 'Le cycle fixe l’excitation, donc le courant.'),
    );

    const grille = document.createElement('div');
    Object.assign(grille.style, { display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0', padding: '0.4rem' });
    for (const g of [champ, cycle, courant]) g.élément.style.margin = '0';
    grille.append(champ.élément, cycle.élément, relations, courant.élément);
    vue.append(grille);

    // Les tracés.
    const tension = champ.courbe({ couleur: COULEUR.u, épaisseur: 1.8 });
    const champB = champ.courbe({ couleur: COULEUR.B, épaisseur: 2.2 });
    // Le courant défile vers le bas : son nom va au pied de son axe.
    courant.légende('i\\ (\\mathrm{A})', { x: 1.08, y: -HISTOIRE, ancre: 'droite', décalage: [0, -10] });
    const boucle = cycle.courbe({ couleur: COULEUR.cycle, épaisseur: 1.8 });
    const tracéI = courant.courbe({ couleur: COULEUR.i, épaisseur: 2.2 });

    // Les projections, en pointillés, qui débordent des graphiques pour se
    // rejoindre d'une case à l'autre.
    const pointillé = (graphe) =>
        svg('line', { stroke: COULEUR.projection, 'stroke-width': 1.2, 'stroke-dasharray': '4 3' }, graphe.couches.repères);
    const projections = {
        champ: pointillé(champ),
        horizontale: pointillé(cycle),
        verticale: pointillé(cycle),
        courant: pointillé(courant),
    };
    const trait = (ligne, xa, ya, xb, yb) =>
        Object.entries({ x1: xa, y1: ya, x2: xb, y2: yb }).forEach(([clé, v]) => ligne.setAttribute(clé, v.toFixed(1)));
    const points = {
        u: champ.point({ couleur: COULEUR.u, rayon: 3.5 }),
        B: champ.point({ couleur: COULEUR.B, rayon: 4.5 }),
        cycle: cycle.point({ couleur: COULEUR.cycle, rayon: 4.5 }),
        i: courant.point({ couleur: COULEUR.i, rayon: 4.5 }),
    };

    // -- Le régime établi, recalculé à chaque réglage -------------------------

    let régime = null;
    function recalcule() {
        const ω = 2 * Math.PI * f;
        const Bm = état.Um / (N * S * ω);
        const p = période(MATÉRIAUX[état.matériau], Bm);
        const î = (p.Hm * l) / N;
        // L'échelle du courant suit son maximum, de valeur ronde en valeur
        // ronde : on lit le courant sur les graduations, et sa forme reste
        // lisible quand il ne vaut que quelques dizaines de milliampères.
        const iAxe = rondeAuDessus(Math.max(1.05 * î, 0.02));
        const HAxe = (iAxe * N) / l;
        régime = { ...p, Bm, î, iAxe, HAxe };

        gradue();

        boucle.place(Array.from(p.H, (H, k) => [H / HAxe, p.B[k]]));
        const P = Math.max(0, S * l * f * p.aire);
        mesures.Bm.écrit(`B_{\\max} = ${nombre(Bm)}\\,\\mathrm{T}`);
        mesures.î.écrit(`i_{\\max} = ${nombre(î)}\\,\\mathrm{A}`);
        mesures.P.écrit(`\\langle \\mathcal{P} \\rangle = V f \\mathcal{A} = ${P < 0.005 ? '0' : nombre(P)}\\,\\mathrm{W}`);
        place();
    }
    /** Les graduations du cycle et du courant, en A/m et en A. Sur un écran
     *  étroit, les demi-graduations se chevaucheraient, et les légendes à
     *  la taille d'une scène déborderaient : on ne garde que les graduations
     *  extrêmes, et des légendes à la taille du panneau. */
    function gradue() {
        if (!régime) return;
        const étroit = grille.clientWidth > 0 && grille.clientWidth < 560;
        for (const g of [champ, cycle, courant]) g.élément.classList.toggle('grand', !étroit);
        const valeurs = étroit ? [-1, 0, 1] : [-1, -0.5, 0, 0.5, 1];
        const graduations = (échelle) => valeurs.map((v) => [v, v === 0 ? '0' : nombre(v * échelle)]);
        cycle.grilleX.place(graduations(régime.HAxe));
        courant.grilleX.place(graduations(régime.iAxe));
    }
    new ResizeObserver(gradue).observe(grille);

    /** H à la phase τ (en périodes), par interpolation dans la période. */
    function excitation(τ) {
        const { H, n } = régime;
        const x = (((τ % 1) + 1) % 1) * n;
        const k = Math.min(Math.floor(x), n - 1);
        return H[k] + (x - k) * (H[k + 1] - H[k]);
    }

    /** Tout ce qui dépend de l'instant : les courbes défilent. */
    function place() {
        const { Bm, HAxe, iAxe } = régime;
        const t = état.temps;
        const échantillons = Array.from({ length: 241 }, (_, k) => -HISTOIRE + (HISTOIRE * k) / 240);
        const B = (τ) => Bm * Math.sin(2 * Math.PI * τ);
        // u est en avance d'un quart de période sur B ; on le dessine de la
        // même amplitude, sans échelle propre.
        const u = (τ) => Bm * Math.cos(2 * Math.PI * τ);
        tension.place(échantillons.map((s) => [s, u(t + s)]));
        champB.place(échantillons.map((s) => [s, B(t + s)]));
        tracéI.place(échantillons.map((s) => [(excitation(t + s) * l) / N / iAxe, s]));

        const [b, h] = [B(t), excitation(t)];
        points.u.place(0, u(t));
        points.B.place(0, b);
        points.cycle.place(h / HAxe, b);
        points.i.place(h / HAxe, 0);
        const [xB, yB] = champ.vers(0, b);
        trait(projections.champ, xB, yB, champ.largeur, yB);
        const [xC, yC] = cycle.vers(h / HAxe, b);
        trait(projections.horizontale, 0, yC, xC, yC);
        trait(projections.verticale, xC, yC, xC, cycle.hauteur);
        const [xI, yI] = courant.vers(h / HAxe, 0);
        trait(projections.courant, xI, 0, xI, yI);
    }

    // -- Le temps qui passe, tant que l'animation est à l'écran ---------------

    let àLÉcran = false;
    let enCours = false;
    let précédent = null;
    function image(instant) {
        if (!àLÉcran) {
            enCours = false;
            return;
        }
        requestAnimationFrame(image);
        const dt = précédent === null ? 0 : Math.min((instant - précédent) / 1000, 0.1);
        précédent = instant;
        if (état.pause || !dt) return;
        état.temps += dt / DURÉE;
        place();
    }
    new IntersectionObserver(([entrée]) => {
        àLÉcran = entrée.isIntersecting;
        if (àLÉcran && !enCours) {
            enCours = true;
            précédent = null;
            requestAnimationFrame(image);
        }
    }).observe(section.querySelector('.corps'));

    // -- Réglages -------------------------------------------------------------

    const réglages = new Réglages(panneau);
    réglages.groupe('Matériau du cœur');
    réglages.choix({
        options: [
            ['linéaire', '\\text{linéaire}'],
            ['saturable', '\\text{saturable}'],
            ['doux', '\\text{doux}'],
            ['dur', '\\text{dur}'],
        ],
        valeur: état.matériau,
        auChangement: (m) => {
            état.matériau = m;
            recalcule();
        },
    });
    const note = réglages.texte('Linéaire : ni saturation ni hystérésis. Saturable : sans hystérésis.');
    note.className = 'note';

    réglages.groupe('Tension imposée');
    réglages.curseur({
        tex: 'U_{\\max}',
        min: 0,
        max: 150,
        pas: 1,
        valeur: état.Um,
        unité: ' V',
        auChangement: (v) => {
            état.Um = v;
            recalcule();
        },
    });
    const caractéristiques = réglages.texte();
    caractéristiques.className = 'note';
    caractéristiques.append(
        écritTex(
            document.createElement('span'),
            'f = 50\\,\\mathrm{Hz},\\ N = 200,\\ S = 14\\,\\mathrm{cm^2},\\ l = 25\\,\\mathrm{cm}',
        ),
        '.',
    );

    réglages.groupe('Régime établi');
    const mesures = { Bm: réglages.formule(), î: réglages.formule(), P: réglages.formule() };
    const pause = réglages.bouton('Pause', () => {
        état.pause = !état.pause;
        pause.textContent = état.pause ? 'Reprendre' : 'Pause';
    });

    recalcule();
}

lance('section.animation', bobine);
