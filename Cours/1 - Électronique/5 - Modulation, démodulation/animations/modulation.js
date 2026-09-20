// Les signaux du chapitre : la porteuse modulée en amplitude, en fréquence ou
// en phase ; le signal modulé en amplitude, son enveloppe et son spectre ; et
// le spectre qui voyage le long de la chaîne de démodulation synchrone.
//
// Le temps se compte en périodes de porteuse T_p, et les fréquences en
// fréquences de porteuse. L'écran garde donc toujours le même nombre
// d'oscillations de la porteuse : quand on change f_s, c'est bien la période
// du signal à transmettre que l'on voit changer, et elle seule.
//
// Le taux de modulation est noté h, comme dans le cours.

import { Graphe, échantillons } from '#animations/graphe.js';
import { COULEURS } from '#animations/objets.js';
import { cadre, lance } from '#animations/page.js';
import { Réglages } from '#animations/reglages.js';

const TAU = 2 * Math.PI;

/** Les couleurs : le signal à transmettre en bleu et la porteuse en gris,
 *  comme les figures du poly ; l'enveloppe en rouge, d'où le noir du signal
 *  modulé là où les deux se croisent ; les filtres en vert. */
const COULEUR = {
    signal: COULEURS.bleu,
    porteuse: COULEURS.gris,
    modulé: COULEURS.vermillon,
    porté: COULEURS.noir,
    enveloppe: COULEURS.vermillon,
    filtre: COULEURS.vert,
};

const LARGEUR = 640;

// -- Les trois modulations ----------------------------------------------------

/** Dix périodes de porteuse par période du signal, comme les figures du poly. */
const F_P = 10;

const MODULANTES = {
    créneau: {
        valeur: (t) => (t % 1 < 0.5 ? 1 : -1),
        // Une rampe qui monte puis redescend : la phase de la porteuse reste
        // continue là même où sa fréquence saute.
        primitive: (t) => (t % 1 < 0.5 ? t % 1 : 1 - (t % 1)),
    },
    sinus: {
        valeur: (t) => Math.cos(TAU * t),
        primitive: (t) => Math.sin(TAU * t) / TAU,
    },
};

/**
 * Les trois modulations : l'amplitude, la fréquence ou la phase de la porteuse
 * suit le signal à transmettre.
 *
 * La fréquence instantanée est la dérivée de la phase, et non le facteur de
 * `t` : la modulation de fréquence s'écrit donc avec la primitive du signal.
 * L'écrire cos(2π f(t) t) donnerait, avec un créneau, une phase qui saute à
 * chaque alternance — une courbe qui ne serait celle d'aucun signal.
 */
const MODULÉS = {
    AM: (t, m, p) => (1 + p * m.valeur(t)) * Math.cos(TAU * F_P * t),
    FM: (t, m, p) => Math.cos(TAU * F_P * (t + p * m.primitive(t))),
    PM: (t, m, p) => Math.cos(TAU * F_P * t + p * m.valeur(t)),
};

const TYPES = ['AM', 'FM', 'PM'];

/** Les trois formules du cours, écrites en parallèle : seul change, en
 *  couleur, le paramètre de la porteuse que l'on fait varier. */
const FORMULES = {
    AM: 's_{\\text{AM}} = {\\color{VARIE} A(t)}\\cos(2\\pi f_p t + \\varphi_p)',
    FM: 's_{\\text{FM}} = A_p\\cos(2\\pi {\\color{VARIE} f(t)}\\,t + \\varphi_p)',
    PM: 's_{\\text{PM}} = A_p\\cos(2\\pi f_p t + {\\color{VARIE} \\varphi(t)})',
};

/** Ce que règle le curseur, selon la modulation. */
const RÉGLAGES = {
    AM: { intitulé: 'Taux de modulation', tex: 'h', min: 0, max: 1.6, pas: 0.01 },
    FM: { intitulé: 'Excursion en fréquence', tex: '\\Delta f', min: 0, max: 0.6, pas: 0.005, unité: ' f_p' },
    PM: { intitulé: 'Excursion en phase', tex: '\\Delta\\varphi', min: 0, max: 3.2, pas: 0.02, unité: ' rad' },
};

/** Les graduations du temps, compté en périodes du signal à transmettre. */
const PÉRIODES_DU_SIGNAL = [
    [1, 'T_s'],
    [2, '2T_s'],
];

function troisModulations(section) {
    const { vue, réglages: panneau } = cadre(section);
    const état = { type: 'AM', forme: 'créneau', profondeur: { AM: 0.3, FM: 0.3, PM: 2 } };

    const axeT = { min: 0, max: 2, nom: 't', graduations: PÉRIODES_DU_SIGNAL };
    const commun = { largeur: LARGEUR, hauteur: 118, grand: true };
    const signal = new Graphe({ ...commun, x: axeT, y: { min: -1.3, max: 1.3, nom: 's' } });
    const porteuse = new Graphe({ ...commun, x: axeT, y: { min: -1.3, max: 1.3, nom: 's_p' } });
    // Un graphique par modulation : le signal modulé en amplitude monte
    // jusqu'à 1 + h, les deux autres restent dans l'amplitude de la porteuse.
    const modulés = {
        AM: new Graphe({ ...commun, x: axeT, y: { min: -2.8, max: 2.8, nom: 's_{\\text{AM}}' }, hauteur: 168 }),
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
    const note = réglages.texte(
        'La fréquence instantanée est la dérivée de la phase : pour tracer la courbe, c’est la phase ' +
            '2π∫f qu’il faut accumuler. L’écrire cos(2π f(t) t) la ferait sauter à chaque alternance du créneau.',
    );
    note.className = 'note';
    const curseurs = {};

    function dessine() {
        const m = MODULANTES[état.forme];
        const profondeur = état.profondeur[état.type];
        courbes.signal.place(échantillons(0, 2, 1200).map((t) => [t, m.valeur(t)]));
        courbes[état.type].place(échantillons(0, 2, 2400).map((t) => [t, MODULÉS[état.type](t, m, profondeur)]));
        for (const type of TYPES) {
            modulés[type].montre(type === état.type);
            curseurs[type].montre(type === état.type);
        }
        réglage.écrit(RÉGLAGES[état.type].intitulé);
        formule.écrit(FORMULES[état.type].replace('VARIE', COULEUR.modulé));
        note.hidden = état.type !== 'FM';
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

    const réglage = réglages.groupe(RÉGLAGES.AM.intitulé);
    for (const type of TYPES) {
        const { intitulé, ...options } = RÉGLAGES[type];
        curseurs[type] = réglages.curseur({
            ...options,
            valeur: état.profondeur[type],
            auChangement: (v) => {
                état.profondeur[type] = v;
                dessine();
            },
        });
    }

    dessine();
}

// -- Le signal à transmettre ---------------------------------------------------
//
// Deux formes, partagées par les deux sections qui suivent.
//
//   - sinusoïdal : une seule composante, de fréquence f_s ;
//   - quelconque : une bande continue de fréquences, entre 0,25 f_max et
//     f_max. On se donne son spectre, et le signal s'en déduit : c'est la
//     transformée de Fourier inverse, ici la somme de ses composantes. Il ne
//     se répète pas à l'échelle de l'écran, et son spectre se dessine comme
//     une aire et non comme des raies.

/** Le bas de la bande, en fractions de f_max : un signal réel n'a pas de
 *  composantes jusqu'à la fréquence nulle. */
const BAS_DE_BANDE = 0.25;
const COMPOSANTES = 64;

/**
 * Le profil du spectre : deux bosses inégales, séparées par un creux. Il est
 * volontairement dissymétrique — la bande du bas, que la modulation renverse,
 * se distingue alors au premier coup d'œil de celle du haut.
 *
 * Il s'annule aux deux bords de la bande, pour que l'aire retombe sur l'axe.
 */
function profil(u) {
    const x = (u - BAS_DE_BANDE) / (1 - BAS_DE_BANDE);
    if (x <= 0 || x >= 1) return 0;
    const bosse = (centre, largeur) => Math.exp(-(((x - centre) / largeur) ** 2));
    return Math.sin(Math.PI * x) ** 0.4 * (bosse(0.24, 0.16) + 0.55 * bosse(0.66, 0.1));
}

/** La densité spectrale, ramenée à un maximum de 1. */
const PIC = Math.max(...échantillons(BAS_DE_BANDE, 1, 400).map(profil));
const densité = (u) => profil(u) / PIC;

/** Les fréquences de la bande, en fractions de f_max. Les deux extrémités,
 *  de densité nulle, font retomber l'aire du spectre sur l'axe. */
const BANDE = échantillons(BAS_DE_BANDE, 1, COMPOSANTES);

/**
 * Des phases tirées au hasard, une fois pour toutes : le signal est toujours
 * le même d'un chargement à l'autre, mais ses composantes n'ont aucun rapport
 * entre elles et leur somme est erratique.
 *
 * Il y faut un vrai tirage. Des phases en progression arithmétique — l'angle
 * d'or, par exemple — ne décalent le signal que dans le temps : toutes les
 * composantes restent en phase au même instant, et leur somme est une
 * impulsion bien lisse, tout le contraire de ce qu'on veut montrer.
 */
function tirage(graine) {
    let x = graine;
    return () => {
        x = (Math.imul(x, 1103515245) + 12345) & 0x7fffffff;
        return x / 0x7fffffff;
    };
}

const hasard = tirage(20250920);
const PHASES = BANDE.map(() => hasard() * TAU);

/** La fenêtre de temps affichée : trente périodes de porteuse, toujours les
 *  mêmes — c'est le signal à transmettre qui change de période, pas elle.
 *  Assez large pour que la bande de fréquences y déploie ses battements. */
const FENÊTRE = 30;

/** Le signal à transmettre, somme de ses composantes [fréquence, amplitude]. */
function signalDe(comps) {
    return (t) => comps.reduce((somme, [f, a], k) => somme + a * Math.cos(TAU * f * t + (PHASES[k] ?? 0)), 0);
}

/**
 * Les composantes [fréquence, amplitude] du signal à transmettre, pour la
 * fréquence caractéristique `f` — f_s si le signal est sinusoïdal, f_max
 * s'il est quelconque.
 *
 * Elles sont ramenées à un signal d'amplitude 1 *sur la fenêtre affichée* :
 * le taux de modulation h vaut alors le réglage lui-même, et l'enveloppe
 * touche zéro exactement à h = 1, là où l'élève la regarde. Le battement de
 * la bande est bien plus long que la fenêtre : normaliser sur lui donnerait
 * à l'écran un signal presque plat.
 */
function composantes(forme, f) {
    if (forme === 'sinus') return [[f, 1]];
    const brutes = BANDE.map((u) => [u * f, densité(u)]);
    const s = signalDe(brutes);
    const maximum = Math.max(...échantillons(0, FENÊTRE, 900).map((t) => Math.abs(s(t))));
    return brutes.map(([fréquence, a]) => [fréquence, a / maximum]);
}

/**
 * La bande telle qu'elle se dessine : une aire, centrée sur `centre` et
 * étalée du côté `sens`, de la forme de la densité spectrale.
 *
 * Sa `hauteur` est celle qu'aurait la raie d'un signal sinusoïdal — c'est la
 * convention du cours, et il n'y en a pas d'autre : le spectre d'un signal
 * qui ne se répète pas est une densité, qui ne se compte pas en volts. Les
 * amplitudes de ses composantes, elles, sont d'autant plus petites qu'on les
 * prend nombreuses.
 */
function aireDeBande(centre, sens, f, hauteur, gain = () => 1) {
    return BANDE.map((u) => {
        const fréquence = centre + sens * u * f;
        return [fréquence, hauteur * densité(u) * gain(fréquence)];
    }).sort((a, b) => a[0] - b[0]);
}

/**
 * Le curseur de fréquence de l'une des deux formes du signal. Chacune garde la
 * sienne — f_s pour une sinusoïde, f_max pour une bande — et seul le curseur
 * de la forme choisie s'affiche.
 */
function curseurDeF(réglages, état, forme, tex, options, dessine) {
    const curseur = réglages.curseur({
        ...options,
        tex,
        valeur: état.f[forme],
        couleur: COULEUR.signal,
        auChangement: (v) => {
            état.f[forme] = v;
            dessine();
        },
    });
    curseur.montre(état.forme === forme);
    return curseur;
}

const montreLeBon = (curseurs, forme) => {
    for (const [nom, curseur] of Object.entries(curseurs)) curseur.montre(nom === forme);
};

// -- Modulation d'amplitude ---------------------------------------------------

const PÉRIODES_DE_PORTEUSE = [
    [0, '0'],
    [15, '15\\,T_p'],
    [30, '30\\,T_p'],
];

function modulationAmplitude(section) {
    const { vue, réglages: panneau } = cadre(section);
    const état = { h: 0.3, f: { sinus: 0.1, quelconque: 0.3 }, forme: 'sinus', enveloppe: true };

    const axeT = { min: 0, max: FENÊTRE, nom: 't', graduations: PÉRIODES_DE_PORTEUSE };
    const signal = new Graphe({
        x: axeT,
        y: { min: -1.35, max: 1.35, nom: 's', graduations: [[1, 'A_s']] },
        largeur: LARGEUR,
        hauteur: 126,
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
    const période = signal.cote('T_s', { couleur: COULEUR.signal });
    const courbeModulé = modulé.courbe({ couleur: COULEUR.porté, épaisseur: 1.2 });
    // La modulante 1 + k s(t) en haut et en bas du signal modulé, et
    // par-dessus, en pointillés rouges, sa valeur absolue : l'enveloppe,
    // celle que ressort une détection d'enveloppe. Elle se confond avec la
    // modulante du haut tant que le taux de modulation ne dépasse pas 1 ;
    // au-delà, la modulante passe sous zéro et l'enveloppe la reflète.
    const modulantes = [0, 1].map(() => modulé.courbe({ couleur: COULEUR.signal, épaisseur: 1.6 }));
    const enveloppe = modulé.courbe({ couleur: COULEUR.enveloppe, épaisseur: 2, pointillés: true });
    const raies = spectre.raies({ couleur: COULEUR.modulé });
    const bandes = [0, 1].map(() => spectre.aire({ couleur: COULEUR.modulé, visible: false }));
    const largeurDeBande = spectre.cote('2f_s');
    const nomsLatéraux = ['f_p - f_s', 'f_p + f_s'].map((tex) => spectre.légende(tex, { couleur: COULEURS.gris }));

    const réglages = new Réglages(panneau);

    function dessine() {
        const { h, forme } = état;
        const f = état.f[forme];
        const sinusoïdal = forme === 'sinus';
        const comps = composantes(forme, f);
        const s = signalDe(comps);

        // Le signal à transmettre, et sa période quand il en a une.
        courbeSignal.place(échantillons(0, FENÊTRE, 1400).map((t) => [t, s(t)]));
        période.montre(sinusoïdal).place(0, 1 / f, 1.15);

        // Le signal modulé et son enveloppe. La porteuse, elle, ne bouge
        // jamais : vingt oscillations, quoi qu'on règle.
        const modulante = (t) => 1 + h * s(t);
        courbeModulé.place(échantillons(0, FENÊTRE, 3200).map((t) => [t, modulante(t) * Math.cos(TAU * t)]));
        const instants = échantillons(0, FENÊTRE, 1400);
        for (const [i, courbe] of modulantes.entries()) {
            courbe.place(instants.map((t) => [t, (i ? 1 : -1) * modulante(t)]));
        }
        enveloppe.montre(état.enveloppe).place(instants.map((t) => [t, Math.abs(modulante(t))]));

        // Le spectre : la porteuse, et de part et d'autre le spectre du
        // signal à transmettre — deux raies, ou deux bandes.
        raies.place(
            sinusoïdal
                ? [
                      [1, 1],
                      [1 - f, h / 2],
                      [1 + f, h / 2],
                  ]
                : [[1, 1]],
        );
        for (const [i, bande] of bandes.entries()) {
            bande.montre(!sinusoïdal);
            if (!sinusoïdal) bande.place(aireDeBande(1, i ? 1 : -1, f, h / 2));
        }
        largeurDeBande.place(1 - f, 1 + f, 1.15).écrit(sinusoïdal ? '2f_s' : '2f_{\\max}');
        for (const [i, nom] of nomsLatéraux.entries()) {
            nom.montre(sinusoïdal && h > 0.05).place(1 + (i ? f : -f), h / 2 + 0.12);
        }
        spectre.grilleY.place(
            sinusoïdal && h > 0.15 ? [[1, 'A_p'], [h / 2, '\\frac{h\\,A_p}{2}']] : [[1, 'A_p']],
        );

        verdict.textContent =
            h <= 1
                ? 'L’enveloppe se confond avec la modulante et reproduit le signal à transmettre : une détection d’enveloppe suffit à le retrouver.'
                : 'Surmodulation : là où la modulante passe sous zéro, l’enveloppe diffère de la modulante.';
    }

    réglages.groupe('Modulation');
    réglages.curseur({
        tex: 'h',
        min: 0,
        max: 1.6,
        pas: 0.01,
        valeur: état.h,
        auChangement: (v) => {
            état.h = v;
            dessine();
        },
    });
    réglages.formule('s_{\\text{AM}} = \\bigl(1 + k\\,s(t)\\bigr)\\,s_p(t)');
    // réglages.formule('h = k \\cdot \\max(s)');
    const verdict = réglages.texte();
    réglages.case({
        texte: 'Enveloppe',
        tex: '\\bigl|1 + k\\,s(t)\\bigr|',
        couleur: COULEUR.enveloppe,
        valeur: état.enveloppe,
        auChangement: (v) => {
            état.enveloppe = v;
            dessine();
        },
    });

    réglages.groupe('Signal à transmettre');
    réglages.choix({
        options: [
            ['sinus', '\\text{sinusoïdal}'],
            ['quelconque', '\\text{quelconque}'],
        ],
        valeur: état.forme,
        auChangement: (forme) => {
            état.forme = forme;
            fréquence.écrit(forme === 'sinus' ? 'Fréquence du signal' : 'Largeur du spectre du signal');
            montreLeBon(curseurs, forme);
            dessine();
        },
    });
    // réglages.texte(
    //     'Un signal quelconque n’est pas périodique et son spectre est continu : il occupe toute une bande de ' +
    //         'fréquences, que la modulation reporte de part et d’autre de la porteuse. Ce spectre-ci n’est pas ' +
    //         'symétrique, et l’on voit que la bande du bas est renversée — celle du haut, non. La hauteur de la ' +
    //         'bande est conventionnelle : une densité spectrale ne se compte pas en volts.',
    // ).className = 'note';

    const fréquence = réglages.groupe('Fréquence du signal');
    const U = (min, max) => ({ min, max, pas: 0.002, unité: ' f_p' });
    const curseurs = {
        sinus: curseurDeF(réglages, état, 'sinus', 'f_s', U(0.04, 0.25), dessine),
        quelconque: curseurDeF(réglages, état, 'quelconque', 'f_{\\max}', U(0.1, 0.32), dessine),
    };
    // réglages.texte(
    //     'La porteuse, elle, garde la même fréquence : l’écran montre toujours trente de ses oscillations.',
    // ).className = 'note';

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

/** La largeur de l'axe des fréquences, en unités arbitraires : elle ne bouge
 *  pas, c'est la porteuse qui s'y déplace. */
const AXE = 2.8;

function démodulationSynchrone(section) {
    const { vue, réglages: panneau } = cadre(section);
    const état = { h: 0.6, f: { sinus: 0.1, quelconque: 0.13 }, fp: 1, bas: 0.3, haut: 0.006, forme: 'sinus' };

    const spectres = ÉTAPES.map((titre) => {
        const graphe = new Graphe({
            x: { min: 0, max: AXE, nom: 'f' },
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
    const bandes = spectres.map((g) => [0, 1, 2].map(() => g.aire({ couleur: COULEUR.modulé, visible: false })));
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
        const { h, fp, bas, haut, forme } = état;
        const f = état.f[forme];
        const sinusoïdal = forme === 'sinus';

        // Le gain de chaque étape : la multiplication ne filtre rien, le
        // passe-bas puis le passe-haut s'ajoutent.
        const gains = [
            () => 1,
            () => 1,
            (ν) => GAIN.bas(ν, bas),
            (ν) => GAIN.bas(ν, bas) * GAIN.haut(ν, haut),
        ];

        for (const [étape, gain] of gains.entries()) {
            // Les raies : la porteuse avant multiplication, la composante
            // continue et celle de 2 f_p après ; plus les raies latérales si
            // le signal à transmettre est sinusoïdal.
            const discrètes =
                étape === 0
                    ? [[fp, 1]]
                    : [
                          [0, 0.5],
                          [2 * fp, 0.5],
                      ];
            if (sinusoïdal) {
                discrètes.push(
                    ...(étape === 0
                        ? [
                              [fp - f, h / 2],
                              [fp + f, h / 2],
                          ]
                        : [
                              [f, h / 2],
                              [2 * fp - f, h / 4],
                              [2 * fp + f, h / 4],
                          ]),
                );
            }
            raies[étape].place(discrètes.map(([ν, a]) => [ν, a * gain(ν)]));

            // Les bandes, quand le signal à transmettre est quelconque : son
            // spectre continu, reporté autour de la porteuse puis ramené
            // autour de 0 et de 2 f_p.
            const aires =
                étape === 0
                    ? [aireDeBande(fp, -1, f, h / 2, gain), aireDeBande(fp, 1, f, h / 2, gain)]
                    : [
                          aireDeBande(0, 1, f, h / 2, gain),
                          aireDeBande(2 * fp, -1, f, h / 4, gain),
                          aireDeBande(2 * fp, 1, f, h / 4, gain),
                      ];
            bandes[étape].forEach((bande, i) => {
                bande.montre(!sinusoïdal && i < aires.length);
                if (!sinusoïdal && i < aires.length) bande.place(aires[i]);
            });

            // Les graduations suivent la porteuse ; les étapes qui suivent la
            // multiplication montrent aussi où est le signal utile.
            const graduations = [0, [fp, 'f_p'], [2 * fp, '2f_p']];
            if (étape > 0) graduations.splice(1, 0, [f, sinusoïdal ? 'f_s' : 'f_{\\max}']);
            spectres[étape].grilleX.place(graduations);
        }

        // Le gain des filtres, par-dessus le spectre qu'ils reçoivent.
        filtres[0].courbe.place(échantillons(0, AXE, 260).map((ν) => [ν, GAIN.bas(ν, bas)]));
        filtres[1].courbe.place(échantillons(0, AXE, 260).map((ν) => [ν, GAIN.haut(ν, haut)]));
        filtres[0].coupure.place(bas);
        filtres[1].coupure.place(haut);
        filtres[0].nom.place(bas, 1.12);
        filtres[1].nom.place(haut, 1.12);

        // Ce qui ressort : la composante utile la plus malmenée par les deux
        // filtres, et la plus grosse de celles qui auraient dû disparaître.
        const utiles = sinusoïdal ? [f] : BANDE.filter((u) => densité(u) > 0.05).map((u) => u * f);
        const utile = Math.min(...utiles.map((ν) => GAIN.bas(ν, bas) * GAIN.haut(ν, haut)));
        const résidu = Math.max(...[2 * fp - f, 2 * fp, 2 * fp + f].map((ν) => GAIN.bas(ν, bas)));
        const pour = (x) => `${Math.round(100 * x)} %`;
        verdict.textContent =
            `Le signal utile ressort à ${pour(utile)} au moins de son amplitude, et les raies autour de ` +
            `2 f_p à ${pour(résidu)} de la leur. ` +
            (utile > 0.9 && résidu < 0.2
                ? 'La condition f_s ≪ f_c ≪ 2 f_p est bien remplie.'
                : utile <= 0.9
                  ? 'Le filtre passe-bas coupe trop bas, ou le passe-haut trop haut : le signal utile est entamé.'
                  : 'Le filtre passe-bas coupe trop haut : les raies autour de 2 f_p passent encore.');
    }

    réglages.groupe('Signal modulé');
    réglages.curseur({
        tex: 'h',
        min: 0,
        max: 1,
        pas: 0.01,
        valeur: état.h,
        auChangement: (v) => {
            état.h = v;
            dessine();
        },
    });
    réglages.curseur({
        tex: 'f_p',
        min: 0.5,
        max: 1.2,
        pas: 0.005,
        valeur: état.fp,
        auChangement: (v) => {
            état.fp = v;
            dessine();
        },
    });
    réglages.texte(
        'Rapprocher la porteuse du signal à transmettre fait se chevaucher ce que les filtres doivent séparer.',
    ).className = 'note';

    réglages.groupe('Signal à transmettre');
    réglages.choix({
        options: [
            ['sinus', '\\text{sinusoïdal}'],
            ['quelconque', '\\text{quelconque}'],
        ],
        valeur: état.forme,
        auChangement: (forme) => {
            état.forme = forme;
            montreLeBon(curseurs, forme);
            dessine();
        },
    });
    const V = (min, max) => ({ min, max, pas: 0.002 });
    const curseurs = {
        sinus: curseurDeF(réglages, état, 'sinus', 'f_s', V(0.02, 0.3), dessine),
        quelconque: curseurDeF(réglages, état, 'quelconque', 'f_{\\max}', V(0.04, 0.3), dessine),
    };
    réglages.texte(
        'Le spectre du signal quelconque n’est pas symétrique : on suit ainsi, d’une étape à l’autre, ' +
            'laquelle de ses deux copies est renversée.',
    ).className = 'note';

    réglages.groupe('Filtres du premier ordre');
    réglages.curseur({
        tex: 'f_c',
        min: 0.02,
        max: AXE,
        pas: 0.02,
        valeur: état.bas,
        couleur: COULEUR.filtre,
        auChangement: (v) => {
            état.bas = v;
            dessine();
        },
    });
    réglages.curseur({
        tex: "f_c'",
        min: 0.001,
        max: 0.11,
        pas: 0.001,
        valeur: état.haut,
        couleur: COULEUR.filtre,
        auChangement: (v) => {
            état.haut = v;
            dessine();
        },
    });
    const verdict = réglages.texte();
    // réglages.texte(
    //     'La multiplication ramène une partie du spectre autour de 0 : c’est elle qui déplace les fréquences, ' +
    //         'ce qu’aucun filtre ne sait faire. Le passe-bas écarte ensuite ce qui est resté autour de 2 f_p, et ' +
    //         'le passe-haut la composante continue. Un filtre du premier ordre ne coupe que de 20 dB par ' +
    //         'décade : il faut vraiment f_s ≪ f_c ≪ 2 f_p pour qu’il fasse les deux à la fois.',
    // ).className = 'note';

    dessine();
}

const ANIMATIONS = {
    types: troisModulations,
    amplitude: modulationAmplitude,
    demodulation: démodulationSynchrone,
};

lance('section.animation', (section) => ANIMATIONS[section.dataset.animation](section));
