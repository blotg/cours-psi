// Les signaux du chapitre : la porteuse modulée en amplitude, en fréquence ou
// en phase ; le signal modulé en amplitude, son enveloppe et son spectre ; et
// le spectre qui voyage le long de la chaîne de démodulation synchrone.
//
// Les fréquences se comptent en fréquences de porteuse : f_p = 1. La
// fréquence du signal à transmettre est le réglage f_s, et le temps se compte
// en périodes T_s = 1/f_s du signal à transmettre — l'écran garde ainsi deux
// périodes du signal, quelle que soit sa fréquence.

import { Graphe, échantillons } from '#animations/graphe.js';
import { COULEURS } from '#animations/objets.js';
import { cadre, lance } from '#animations/page.js';
import { Réglages } from '#animations/reglages.js';

const TAU = 2 * Math.PI;

/** Les couleurs des figures du cours : le signal à transmettre en bleu, le
 *  signal modulé en rouge ; les filtres, qui n'y sont pas, en vert. */
const COULEUR = {
    signal: COULEURS.bleu,
    porteuse: COULEURS.gris,
    modulé: COULEURS.vermillon,
    enveloppe: COULEURS.bleu,
    filtre: COULEURS.vert,
};

const LARGEUR = 640;

/** Les graduations du temps, compté en périodes du signal à transmettre. */
const PÉRIODES = [
    [1, 'T_s'],
    [2, '2T_s'],
];

// -- Les trois modulations ----------------------------------------------------

/** Dix périodes de porteuse par période du signal, comme les figures du poly. */
const F_P = 10;

const MODULANTES = {
    créneau: (t) => (t % 1 < 0.5 ? 1 : -1),
    sinus: (t) => Math.cos(TAU * t),
};

/** Les trois modulations, telles que le cours les écrit : l'amplitude, la
 *  fréquence ou la phase de la porteuse suit le signal à transmettre. */
const MODULÉS = {
    AM: (t, m, p) => (1 + p * m) * Math.cos(TAU * F_P * t),
    FM: (t, m, p) => Math.cos(TAU * F_P * (1 + p * m) * t),
    PM: (t, m, p) => Math.cos(TAU * F_P * t + p * m),
};

const TYPES = ['AM', 'FM', 'PM'];

/** Les trois formules du cours, écrites en parallèle : seul change, en
 *  couleur, le paramètre de la porteuse que l'on fait varier. */
const FORMULES = {
    AM: 's_{\\text{AM}} = {\\color{VARIE} A(t)}\\cos(2\\pi f_p t + \\varphi_p)',
    FM: 's_{\\text{FM}} = A_p\\cos(2\\pi {\\color{VARIE} f(t)}\\,t + \\varphi_p)',
    PM: 's_{\\text{PM}} = A_p\\cos(2\\pi f_p t + {\\color{VARIE} \\varphi(t)})',
};

function troisModulations(section) {
    const { vue, réglages: panneau } = cadre(section);
    const état = { type: 'AM', forme: 'créneau', profondeur: { AM: 0.3, FM: 0.3, PM: 2 } };

    const axeT = { min: 0, max: 2, nom: 't', graduations: PÉRIODES };
    const commun = { largeur: LARGEUR, hauteur: 118, grand: true };
    const signal = new Graphe({ ...commun, x: axeT, y: { min: -1.3, max: 1.3, nom: 's' } });
    const porteuse = new Graphe({ ...commun, x: axeT, y: { min: -1.3, max: 1.3, nom: 's_p' } });
    // Un graphique par modulation : le signal modulé en amplitude monte
    // jusqu'à 1 + h, les deux autres restent dans l'amplitude de la porteuse.
    const modulés = {
        AM: new Graphe({ ...commun, x: axeT, y: { min: -1.9, max: 1.9, nom: 's_{\\text{AM}}' }, hauteur: 140 }),
        FM: new Graphe({ ...commun, x: axeT, y: { min: -1.3, max: 1.3, nom: 's_{\\text{FM}}' } }),
        PM: new Graphe({ ...commun, x: axeT, y: { min: -1.3, max: 1.3, nom: 's_{\\text{PM}}' } }),
    };
    vue.append(signal.élément, porteuse.élément, ...TYPES.map((type) => modulés[type].élément));

    const courbes = {
        signal: signal.courbe({ couleur: COULEUR.signal }),
        ...Object.fromEntries(
            TYPES.map((type) => [type, modulés[type].courbe({ couleur: COULEUR.modulé, épaisseur: 1.4 })]),
        ),
    };
    porteuse.trace((t) => Math.cos(TAU * F_P * t), { couleur: COULEUR.porteuse }, 2400);

    const réglages = new Réglages(panneau);
    const formule = réglages.formule();
    const curseurs = {};

    function dessine() {
        const m = MODULANTES[état.forme];
        const profondeur = état.profondeur[état.type];
        courbes.signal.place(échantillons(0, 2, 1200).map((t) => [t, m(t)]));
        courbes[état.type].place(échantillons(0, 2, 2400).map((t) => [t, MODULÉS[état.type](t, m(t), profondeur)]));
        for (const type of TYPES) {
            modulés[type].montre(type === état.type);
            curseurs[type].montre(type === état.type);
        }
        formule.écrit(FORMULES[état.type].replace('VARIE', COULEUR.modulé));
    }

    réglages.groupe('Modulation');
    réglages.choix({
        options: TYPES.map((type) => [type, `\\text{${type}}`]),
        valeur: état.type,
        auChangement: (type) => {
            état.type = type;
            dessine();
        },
    });

    réglages.groupe('Signal à transmettre');
    réglages.choix({
        options: [
            ['créneau', '\\text{créneau}'],
            ['sinus', '\\text{sinusoïdal}'],
        ],
        valeur: état.forme,
        auChangement: (forme) => {
            état.forme = forme;
            dessine();
        },
    });

    réglages.groupe('Profondeur de la modulation');
    const profondeur = (type, options) =>
        (curseurs[type] = réglages.curseur({
            ...options,
            valeur: état.profondeur[type],
            auChangement: (v) => {
                état.profondeur[type] = v;
                dessine();
            },
        }));
    profondeur('AM', { tex: 'h', min: 0, max: 0.8, pas: 0.05 });
    profondeur('FM', { tex: '\\Delta f', min: 0, max: 0.5, pas: 0.05, unité: ' f_p' });
    profondeur('PM', { tex: '\\Delta\\varphi', min: 0, max: 3, pas: 0.1, unité: ' rad' });
    réglages.texte(
        'Une seule des trois grandeurs de la porteuse varie : son amplitude (AM), sa fréquence (FM) ou sa ' +
            'phase (PM). Avec un créneau, la modulation de fréquence change la largeur des alternances, la ' +
            'modulation de phase les décale.',
    ).className = 'note';

    dessine();
}

// -- Modulation d'amplitude ---------------------------------------------------

/** Le signal à transmettre, périodique, dans ses deux formes : sinusoïdal, ou
 *  riche en harmoniques. Les harmoniques sont impaires, ce qui garde le
 *  signal symétrique — max(s) = -min(s), comme le suppose le cours. */
const HARMONIQUES = { sinus: [1], riche: [1, 0, 0.4, 0, 0.2] };

/** Les amplitudes des harmoniques, ramenées à un signal de maximum 1 : le
 *  taux de modulation h = k·max(s) vaut alors le réglage k lui-même. */
function amplitudes(forme) {
    const brut = HARMONIQUES[forme];
    const s = (τ) => brut.reduce((somme, a, k) => somme + a * Math.cos(TAU * (k + 1) * τ), 0);
    const maximum = Math.max(...échantillons(0, 1, 720).map(s));
    return brut.map((a) => a / maximum);
}

function modulationAmplitude(section) {
    const { vue, réglages: panneau } = cadre(section);
    const état = { h: 0.3, fs: 0.1, forme: 'sinus' };

    const axeT = { min: 0, max: 2, nom: 't', graduations: PÉRIODES };
    const signal = new Graphe({
        x: axeT,
        y: { min: -1.25, max: 1.25, nom: 's', graduations: [[1, 'A_s']] },
        largeur: LARGEUR,
        hauteur: 118,
        grand: true,
    });
    const modulé = new Graphe({
        x: axeT,
        y: { min: -2.7, max: 2.7, nom: 's_{\\text{AM}}' },
        largeur: LARGEUR,
        hauteur: 175,
        grand: true,
    });
    const spectre = new Graphe({
        x: { min: 0, max: 1.6, nom: 'f', graduations: [0, [1, 'f_p']] },
        y: { min: 0, max: 1.3, graduations: [[1, 'A_p']] },
        largeur: LARGEUR,
        hauteur: 165,
        marges: { haut: 30, gauche: 58 },
        grand: true,
    });
    vue.append(signal.élément, modulé.élément, spectre.élément);

    const courbeSignal = signal.courbe({ couleur: COULEUR.signal });
    const courbeModulé = modulé.courbe({ couleur: COULEUR.modulé, épaisseur: 1.4 });
    const enveloppes = [0, 1].map(() => modulé.courbe({ couleur: COULEUR.enveloppe, épaisseur: 2 }));
    const raies = spectre.raies({ couleur: COULEUR.modulé });
    const bande = spectre.cote('2f_s');
    const nomsLatéraux = ['f_p - f_s', 'f_p + f_s'].map((tex) =>
        spectre.légende(tex, { couleur: COULEURS.gris }),
    );

    const réglages = new Réglages(panneau);

    function dessine() {
        const a = amplitudes(état.forme);
        const { h, fs } = état;
        // Le signal à transmettre, et la modulante qui en découle.
        const s = (τ) => a.reduce((somme, ai, k) => somme + ai * Math.cos(TAU * (k + 1) * τ), 0);
        courbeSignal.place(échantillons(0, 2, 1200).map((τ) => [τ, s(τ)]));
        const modulante = (τ) => 1 + h * s(τ);
        courbeModulé.place(échantillons(0, 2, 2600).map((τ) => [τ, modulante(τ) * Math.cos((TAU * τ) / fs)]));
        for (const [i, enveloppe] of enveloppes.entries()) {
            enveloppe.place(échantillons(0, 2, 600).map((τ) => [τ, (i ? 1 : -1) * modulante(τ)]));
        }

        // Le spectre : la porteuse, et deux raies par harmonique du signal.
        const latérales = a.flatMap((ai, k) =>
            ai ? [[1 - (k + 1) * fs, (h * ai) / 2], [1 + (k + 1) * fs, (h * ai) / 2]] : [],
        );
        raies.place([[1, 1], ...latérales]);
        // Le rang de la dernière harmonique présente donne f_max.
        const fMax = (a.findLastIndex((ai) => ai > 0) + 1) * fs;
        bande.place(1 - fMax, 1 + fMax, 1.15).écrit(état.forme === 'sinus' ? '2f_s' : '2f_{\\max}');
        // Les raies latérales de la fondamentale, nommées de part et d'autre
        // de la porteuse — seulement quand il n'y en a qu'une paire.
        for (const [i, nom] of nomsLatéraux.entries()) {
            nom.montre(état.forme === 'sinus' && h > 0.05).place(1 + (i ? fs : -fs), (h * a[0]) / 2 + 0.12);
        }
        spectre.grilleY.place(
            état.forme === 'sinus' && h > 0.15 ? [[1, 'A_p'], [h / 2, '\\frac{h\\,A_p}{2}']] : [[1, 'A_p']],
        );
        verdict.textContent =
            h <= 1
                ? 'L’enveloppe reproduit le signal à transmettre : une détection d’enveloppe suffit à le retrouver.'
                : 'Surmodulation : l’enveloppe s’annule puis se retourne, elle ne reproduit plus le signal.';
    }

    réglages.groupe('Modulation');
    réglages.curseur({
        tex: 'h',
        min: 0,
        max: 1.6,
        pas: 0.05,
        valeur: état.h,
        auChangement: (v) => {
            état.h = v;
            dessine();
        },
    });
    réglages.curseur({
        tex: 'f_s',
        min: 0.04,
        max: 0.16,
        pas: 0.01,
        unité: ' f_p',
        valeur: état.fs,
        auChangement: (v) => {
            état.fs = v;
            dessine();
        },
    });
    réglages.formule('s_{\\text{AM}} = \\bigl(1 + k\\,s(t)\\bigr)\\,s_p(t)');
    réglages.formule('h = k \\cdot \\max(s)');
    const verdict = réglages.texte();

    réglages.groupe('Signal à transmettre');
    réglages.choix({
        options: [
            ['sinus', '\\text{sinusoïdal}'],
            ['riche', '\\text{quelconque}'],
        ],
        valeur: état.forme,
        auChangement: (forme) => {
            état.forme = forme;
            dessine();
        },
    });
    réglages.texte(
        'Un signal périodique quelconque est une somme d’harmoniques : chacune donne sa paire de raies ' +
            'latérales, et la largeur de bande vaut 2 f_max.',
    ).className = 'note';

    dessine();
}

// -- Démodulation synchrone ---------------------------------------------------

/** Le gain d'un filtre du premier ordre, passe-bas et passe-haut. */
const GAIN = {
    bas: (f, fc) => 1 / Math.hypot(1, f / fc),
    haut: (f, fc) => f / fc / Math.hypot(1, f / fc),
};

const ÉTAPES = [
    '\\text{signal modulé } s_{\\text{AM}}',
    '\\text{après multiplication par la porteuse}',
    '\\text{après le filtre passe-bas}',
    '\\text{après le filtre passe-haut : le signal retrouvé}',
];

function démodulationSynchrone(section) {
    const { vue, réglages: panneau } = cadre(section);
    const état = { h: 0.6, fs: 0.1, bas: 0.3, haut: 0.02 };

    const spectres = ÉTAPES.map((titre) => {
        const graphe = new Graphe({
            x: { min: 0, max: 2.4, nom: 'f', graduations: [0, [1, 'f_p'], [2, '2f_p']] },
            y: {
                min: 0,
                max: 1.25,
                graduations: [
                    [0.5, '\\frac{A_p}{2}'],
                    [1, 'A_p'],
                ],
            },
            largeur: LARGEUR,
            hauteur: 125,
            marges: { haut: 26 },
            grand: true,
        });
        graphe.légende(titre, { x: 0.02, y: 1.42, ancre: 'gauche', couleur: COULEURS.noir });
        return graphe;
    });

    vue.append(...spectres.map((g) => g.élément));
    const raies = spectres.map((g) => g.raies({ couleur: COULEUR.modulé }));
    const filtres = [2, 3].map((i) => ({
        courbe: spectres[i].courbe({ couleur: COULEUR.filtre, épaisseur: 1.5 }),
        coupure: spectres[i].verticale({ couleur: COULEUR.filtre }),
        nom: spectres[i].légende(i === 2 ? 'f_c' : "f_c'", {
            couleur: COULEUR.filtre,
            ancre: i === 2 ? 'centre' : 'gauche',
            décalage: [i === 2 ? 0 : 4, 0],
        }),
    }));

    const réglages = new Réglages(panneau);

    function dessine() {
        const { h, fs, bas, haut } = état;
        // Le signal modulé, puis son produit par la porteuse : chaque raie de
        // fréquence f donne deux raies, en |f_p - f| et f_p + f, de moitié
        // d'amplitude.
        const modulé = [
            [1, 1],
            [1 - fs, h / 2],
            [1 + fs, h / 2],
        ];
        const multiplié = [
            [0, 0.5],
            [fs, h / 2],
            [2 - fs, h / 4],
            [2, 0.5],
            [2 + fs, h / 4],
        ];
        const filtré = multiplié.map(([f, a]) => [f, a * GAIN.bas(f, bas)]);
        const démodulé = filtré.map(([f, a]) => [f, a * GAIN.haut(f, haut)]);
        [modulé, multiplié, filtré, démodulé].forEach((composantes, i) => raies[i].place(composantes));
        for (const g of spectres.slice(1)) {
            g.grilleX.place([0, [fs, 'f_s'], [1, 'f_p'], [2, '2f_p']]);
        }

        // Le gain des filtres, par-dessus le spectre qu'ils reçoivent.
        filtres[0].courbe.place(échantillons(0, 2.4, 240).map((f) => [f, GAIN.bas(f, bas)]));
        filtres[1].courbe.place(échantillons(0, 2.4, 240).map((f) => [f, GAIN.haut(f, haut)]));
        filtres[0].coupure.place(bas);
        filtres[1].coupure.place(haut);
        filtres[0].nom.place(bas, 1.12);
        filtres[1].nom.place(haut, 1.12);

        const utile = GAIN.bas(fs, bas) * GAIN.haut(fs, haut);
        const résidu = Math.max(...[2 - fs, 2, 2 + fs].map((f) => GAIN.bas(f, bas)));
        const pour = (x) => `${Math.round(100 * x)} %`;
        verdict.textContent =
            `Le signal utile ressort à ${pour(utile)} de son amplitude, et les raies autour de 2 f_p à ` +
            `${pour(résidu)} de la leur. ` +
            (utile > 0.9 && résidu < 0.2
                ? 'La condition f_s ≪ f_c ≪ 2 f_p est bien remplie.'
                : utile <= 0.9
                  ? 'Le filtre passe-bas coupe trop bas, ou le passe-haut trop haut : le signal utile est entamé.'
                  : 'Le filtre passe-bas coupe trop haut : les raies autour de 2 f_p passent encore.');
    }

    réglages.groupe('Signal modulé');
    réglages.curseur({
        tex: 'h',
        min: 0.1,
        max: 1,
        pas: 0.05,
        valeur: état.h,
        auChangement: (v) => {
            état.h = v;
            dessine();
        },
    });
    réglages.curseur({
        tex: 'f_s',
        min: 0.05,
        max: 0.3,
        pas: 0.01,
        unité: ' f_p',
        valeur: état.fs,
        auChangement: (v) => {
            état.fs = v;
            dessine();
        },
    });

    réglages.groupe('Filtres du premier ordre');
    réglages.curseur({
        tex: 'f_c',
        min: 0.05,
        max: 2.4,
        pas: 0.05,
        unité: ' f_p',
        valeur: état.bas,
        couleur: COULEUR.filtre,
        auChangement: (v) => {
            état.bas = v;
            dessine();
        },
    });
    réglages.curseur({
        tex: "f_c'",
        min: 0.005,
        max: 0.1,
        pas: 0.005,
        unité: ' f_p',
        valeur: état.haut,
        couleur: COULEUR.filtre,
        auChangement: (v) => {
            état.haut = v;
            dessine();
        },
    });
    const verdict = réglages.texte();
    réglages.texte(
        'La multiplication ramène une partie du spectre autour de 0 : c’est elle qui déplace les fréquences, ' +
            'ce qu’aucun filtre ne sait faire. Le passe-bas écarte ensuite ce qui est resté autour de 2 f_p, et ' +
            'le passe-haut la composante continue. Un filtre du premier ordre ne coupe que de 20 dB par ' +
            'décade : il faut vraiment f_s ≪ f_c ≪ 2 f_p pour qu’il fasse les deux à la fois.',
    ).className = 'note';

    dessine();
}

const ANIMATIONS = {
    types: troisModulations,
    amplitude: modulationAmplitude,
    demodulation: démodulationSynchrone,
};

lance('section.animation', (section) => ANIMATIONS[section.dataset.animation](section));
