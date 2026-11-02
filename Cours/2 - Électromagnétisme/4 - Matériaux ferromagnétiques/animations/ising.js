// Le modèle d'Ising à deux dimensions : des domaines qui se forment, et le
// cycle d'hystérésis qu'ils dessinent quand l'excitation varie.
//
// Un réseau carré de L × L moments, chacun valant +1 (vers le haut) ou −1, aux
// bords périodiques. L'énergie d'un moment s vaut −s (J Σ voisins + H) : il
// préfère s'aligner sur ses quatre voisins (l'interaction d'échange, J = 1)
// et sur l'excitation H. La température se compte en J/k_B ; celle de Curie
// vaut alors T_C = 2/ln(1 + √2) ≈ 2,27 (Onsager).
//
// La dynamique est celle de Metropolis : on tire un moment au hasard, on le
// retourne si cela abaisse l'énergie, et sinon avec la probabilité
// exp(−ΔE/T). N tirages font un pas de Monte-Carlo, l'unité de temps.
//
// Le cycle que l'on voit dépend de la vitesse à laquelle H varie : le
// retournement passe par la naissance d'un domaine de l'autre couleur, qu'il
// faut attendre d'autant plus longtemps que T est basse. À 2 400 pas par
// période, le champ coercitif vaut environ 1 à T = 0,5 T_C et 0,35 à 0,9 T_C,
// et le cycle se referme au-dessus de T_C : plus d'aimantation spontanée.

import { Graphe } from '#animations/graphe.js';
import { COULEURS, écritTex } from '#animations/objets.js';
import { cadre, lance } from '#animations/page.js';
import { Plan } from '#animations/plan.js';
import { Réglages } from '#animations/reglages.js';

/** Le côté du réseau. */
const L = 128;
const N = L * L;

/** La température de Curie du réseau carré, en J/k_B. */
const TC = 2 / Math.log(1 + Math.SQRT2);

/** Les pas de Monte-Carlo par seconde, et par période d'excitation alternative. */
const PAS_PAR_SECONDE = 240;
const PAS_PAR_PÉRIODE = 2400;

/** L'excitation la plus forte, en unités de J. */
const H_MAX = 3;

/** Le nombre de points que garde la trace : cinq cycles de l'excitation
 *  alternative, un point par image. */
const TRACE = 3000;

/** Les couleurs des moments, en RGBA rangé à l'envers (petit-boutiste) :
 *  vermillon vers le haut, bleu vers le bas, éclaircis pour de grands aplats. */
const éclairci = ([r, g, b]) => {
    const c = (v) => Math.round(0.7 * v + 0.3 * 255);
    return (255 << 24) | (c(b) << 16) | (c(g) << 8) | c(r);
};
const PIXEL = { haut: éclairci([213, 94, 0]), bas: éclairci([0, 114, 178]) };

/** Un générateur pseudo-aléatoire (xorshift32), de graine fixe. */
function générateur(graine = 0x9e3779b9) {
    let état = graine;
    return () => {
        état ^= état << 13;
        état ^= état >>> 17;
        état ^= état << 5;
        return (état >>> 0) / 4294967296;
    };
}

/** Le réseau et sa dynamique. */
class Réseau {
    constructor() {
        this.moments = new Int8Array(N);
        this.hasard = générateur();
        // Les quatre voisins de chaque case, bords périodiques compris.
        this.voisins = new Int32Array(4 * N);
        for (let y = 0; y < L; y++) {
            for (let x = 0; x < L; x++) {
                const p = 4 * (y * L + x);
                this.voisins[p] = y * L + ((x + 1) % L);
                this.voisins[p + 1] = y * L + ((x + L - 1) % L);
                this.voisins[p + 2] = ((y + 1) % L) * L + x;
                this.voisins[p + 3] = ((y + L - 1) % L) * L + x;
            }
        }
        // La probabilité de retourner un moment, selon son signe et la somme
        // de ses voisins : dix cas seulement, recalculés à chaque réglage.
        this.probabilité = new Float64Array(10);
        this.désordonne();
    }

    désordonne() {
        let somme = 0;
        for (let p = 0; p < N; p++) somme += this.moments[p] = this.hasard() < 0.5 ? 1 : -1;
        this.somme = somme;
    }

    règle(T, H) {
        for (let signe = 0; signe < 2; signe++) {
            for (let k = 0; k < 5; k++) {
                const s = signe ? 1 : -1;
                const ΔE = 2 * s * (2 * k - 4 + H);
                this.probabilité[5 * signe + k] = ΔE <= 0 ? 1 : Math.exp(-ΔE / T);
            }
        }
    }

    /** Un pas de Monte-Carlo : N moments tirés au hasard. */
    pas() {
        const { moments, voisins, probabilité, hasard } = this;
        for (let n = 0; n < N; n++) {
            const p = (hasard() * N) | 0;
            const q = 4 * p;
            const voisinage = moments[voisins[q]] + moments[voisins[q + 1]] + moments[voisins[q + 2]] + moments[voisins[q + 3]];
            const s = moments[p];
            if (hasard() < probabilité[(s > 0 ? 5 : 0) + ((voisinage + 4) >> 1)]) {
                moments[p] = -s;
                this.somme -= 2 * s;
            }
        }
    }

    /** L'aimantation, rapportée à sa valeur à saturation. */
    get aimantation() {
        return this.somme / N;
    }
}

function ising(section) {
    const { vue, réglages: panneau } = cadre(section);
    const réseau = new Réseau();
    const état = { T: 0.5, H: 0, alternative: false, amplitude: 2, phase: 0, trace: true };
    réseau.règle(état.T * TC, état.H);

    // Le réseau à gauche, le cycle à droite ; l'un sous l'autre sur un
    // écran étroit.
    const côteÀCôte = document.createElement('div');
    Object.assign(côteÀCôte.style, {
        display: 'grid',
        gridTemplateColumns: 'repeat(auto-fit, minmax(15rem, 1fr))',
        alignItems: 'center',
    });
    const gauche = document.createElement('div');
    côteÀCôte.append(gauche);
    vue.append(côteÀCôte);

    const plan = new Plan(gauche, { rapport: 1, étendue: 1, aide: 'Rouge : moment vers le haut ; bleu : vers le bas.' });
    const image = new OffscreenCanvas(L, L);
    const contexte = image.getContext('2d');
    const pixels = contexte.createImageData(L, L);
    const mots = new Uint32Array(pixels.data.buffer);
    plan.dessine((c) => {
        for (let p = 0; p < N; p++) mots[p] = réseau.moments[p] > 0 ? PIXEL.haut : PIXEL.bas;
        contexte.putImageData(pixels, 0, 0);
        c.imageSmoothingEnabled = false;
        c.drawImage(image, 0, 0, plan.largeur, plan.hauteur);
    });
    plan.bouton('Désordonner', () => {
        réseau.désordonne();
        plan.redessine();
    });

    const cycle = new Graphe({
        x: { min: -H_MAX, max: H_MAX, nom: 'H', graduations: [-2, -1, 0, 1, 2] },
        y: {
            min: -1.15,
            max: 1.15,
            nom: 'M',
            graduations: [
                [-1, '-M_s'],
                [0, '0'],
                [1, 'M_s'],
            ],
        },
        largeur: 340,
        hauteur: 320,
        marges: { gauche: 40, droite: 16, haut: 26, bas: 24 },
        grand: true,
    });
    cycle.élément.style.margin = '0.8rem';
    côteÀCôte.append(cycle.élément);
    const trace = cycle.courbe({ couleur: COULEURS.noir, épaisseur: 1.5 });
    const point = cycle.point({ couleur: COULEURS.vermillon, rayon: 5.5 });
    const points = [];

    plan.àChaqueImage((dt) => {
        état.reste = (état.reste ?? 0) + dt * PAS_PAR_SECONDE;
        const pas = Math.min(Math.floor(état.reste), 12);
        état.reste -= Math.floor(état.reste);
        if (!pas) return;
        for (let k = 0; k < pas; k++) {
            if (état.alternative) {
                état.phase += (2 * Math.PI) / PAS_PAR_PÉRIODE;
                état.H = état.amplitude * Math.sin(état.phase);
                réseau.règle(état.T * TC, état.H);
            }
            réseau.pas();
        }
        if (état.alternative) curseurs.H.valeur = état.H;
        const M = réseau.aimantation;
        point.place(état.H, M);
        if (état.trace) {
            points.push([état.H, M]);
            if (points.length > TRACE) points.splice(0, points.length - TRACE);
            trace.place(points);
        }
        mesure.écrit(`M = ${nombre(M)}\\,M_s`);
        plan.redessine();
    });

    // -- Réglages -------------------------------------------------------------

    const réglages = new Réglages(panneau);
    réglages.groupe('Réglages');
    const curseurs = {
        T: réglages.curseur({
            tex: 'T/T_\\mathrm{C}',
            min: 0.2,
            max: 2,
            pas: 0.01,
            valeur: état.T,
            aimants: [1],
            auChangement: (v) => {
                état.T = v;
                réseau.règle(état.T * TC, état.H);
            },
        }),
        H: réglages.curseur({
            tex: 'H',
            min: -H_MAX,
            max: H_MAX,
            pas: 0.01,
            valeur: état.H,
            aimants: [0],
            auChangement: (v) => {
                état.H = v;
                réseau.règle(état.T * TC, état.H);
            },
        }),
    };

    réglages.groupe('Excitation alternative');
    réglages.case({
        texte: 'Faire varier H',
        valeur: état.alternative,
        auChangement: (oui) => {
            état.alternative = oui;
            // Repartir de l'excitation du moment, sans saut.
            if (oui) état.phase = Math.asin(Math.min(Math.max(état.H / état.amplitude, -1), 1));
            curseurs.H.désactive(oui);
        },
    });
    réglages.curseur({
        tex: 'H_{\\max}',
        min: 0.1,
        max: H_MAX,
        pas: 0.01,
        valeur: état.amplitude,
        auChangement: (v) => {
            état.amplitude = v;
            if (état.alternative) état.phase = Math.asin(Math.min(Math.max(état.H / v, -1), 1));
        },
    });

    réglages.groupe('Cycle');
    réglages.case({
        texte: 'Laisser une trace',
        valeur: état.trace,
        auChangement: (oui) => {
            état.trace = oui;
            points.length = 0;
            trace.place(points);
        },
    });
    réglages.bouton('Effacer la trace', () => {
        points.length = 0;
        trace.place(points);
    });

    réglages.groupe('Aimantation');
    const mesure = réglages.formule();
    const note = réglages.texte();
    note.className = 'note';
    note.append(
        'La moyenne des moments : ',
        écritTex(document.createElement('span'), 'M = M_s'),
        ' quand ils sont tous vers le haut.',
    );
}

const format = new Intl.NumberFormat('fr-FR', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
/** Un nombre à deux décimales, à la française et lisible par KaTeX. */
const nombre = (x) => format.format(x).replace('−', '-').replace(',', '{,}');

lance('section.animation', ising);
