// Les tracés 2D des animations : un graphique en SVG, dessiné dans les
// coordonnées du problème et légendé en LaTeX comme le cours.
//
// Un graphique se construit une fois — ses axes, ses graduations, ses
// courbes —, puis tout se replace à chaque réglage : `place` réécrit les
// mêmes éléments, comme les objets d'une scène 3D (cf. objets.js). Même les
// graduations se déplacent, pour un axe dont les repères dépendent d'un
// réglage (la fréquence de la porteuse, par exemple).
//
// Les courbes sont dessinées en SVG, les légendes écrites en HTML par-dessus :
// KaTeX y est à sa taille, et le graphique se lit à la loupe comme le reste
// de la page.

import { COULEURS, écritTex } from './objets.js';

const ESPACE = 'http://www.w3.org/2000/svg';

/** Un élément SVG, avec ses attributs, ajouté à `parent`. */
export function svg(balise, attributs = {}, parent = null) {
    const élément = document.createElementNS(ESPACE, balise);
    for (const [clé, valeur] of Object.entries(attributs)) élément.setAttribute(clé, valeur);
    parent?.append(élément);
    return élément;
}

/** n + 1 valeurs régulièrement espacées, de a à b. */
export function échantillons(a, b, n = 120) {
    return Array.from({ length: n + 1 }, (_, k) => a + ((b - a) * k) / n);
}

const format = new Intl.NumberFormat('fr-FR');

/**
 * Une graduation, donnée par un couple [valeur, tex] — ou par sa seule
 * valeur, qui se nomme alors elle-même, à la française (la virgule décimale
 * garde en LaTeX l'espacement d'un séparateur).
 */
function graduation(g) {
    if (Array.isArray(g)) return g;
    return [g, format.format(g).replace('−', '-').replace(',', '{,}')];
}

const créé = (balise, classe = '') =>
    Object.assign(document.createElement(balise), { className: classe });

/** Le décalage CSS qui amène le point d'ancrage demandé sur la position. */
const ANCRES = {
    gauche: '0',
    centre: '-50%',
    droite: '-100%',
};

/** Le chemin SVG d'un disque de rayon r, à composer avec d'autres. */
const disque = (x, y, r) => `M ${x} ${y} m ${-r} 0 a ${r} ${r} 0 1 0 ${2 * r} 0 a ${r} ${r} 0 1 0 ${-2 * r} 0`;

const CHEMIN_VIDE = 'M 0 0';
const GRIS_GRILLE = '#e3e3e3';
const GRIS_AXE = '#555';

/**
 * Un graphique : x de `x.min` à `x.max`, y de `y.min` à `y.max`, chaque axe
 * avec son nom (`nom`, en LaTeX) et ses graduations (`graduations`, des
 * couples [valeur, tex] ou des nombres).
 *
 *     const g = new Graphe({
 *         x: { min: 0, max: 360, nom: '\\theta', graduations: [0, 180, 360] },
 *         y: { min: -1.2, max: 1.2, nom: 'B', graduations: [[1, 'B_{\\max}']] },
 *     });
 *     const courbe = g.courbe({ couleur: COULEURS.bleu });
 *     courbe.place(points);   // [[x, y], …], à chaque image
 *
 * `largeur` et `hauteur` sont celles du dessin : les unités du `viewBox`, qui
 * valent le pixel quand le graphique s'affiche à sa taille naturelle — celle
 * du panneau de réglages. `grand` agrandit les légendes, pour un graphique
 * qui tient la place d'une scène.
 */
export class Graphe {
    constructor({ x, y, largeur = 272, hauteur = 140, marges = {}, grand = false }) {
        const marge = { gauche: 44, droite: 14, haut: 22, bas: 20, ...marges };
        Object.assign(this, { largeur, hauteur, marge, domaine: { x, y } });

        this.élément = créé('div', grand ? 'graphique grand' : 'graphique');
        this.racine = svg('svg', { viewBox: `0 0 ${largeur} ${hauteur}` }, this.élément);
        // Les couches, dans l'ordre où elles se recouvrent : les aplats sous
        // la grille, la grille sous les courbes, les repères par-dessus tout.
        this.couches = Object.fromEntries(
            ['fond', 'grille', 'tracés', 'repères'].map((nom) => [nom, svg('g', {}, this.racine)]),
        );

        const dedans = { largeur: largeur - marge.gauche - marge.droite, hauteur: hauteur - marge.haut - marge.bas };
        this.X = (v) => marge.gauche + ((v - x.min) / (x.max - x.min)) * dedans.largeur;
        this.Y = (v) => marge.haut + ((y.max - v) / (y.max - y.min)) * dedans.hauteur;

        this.grilleX = this._grille('x');
        this.grilleY = this._grille('y');
        this.grilleX.place(x.graduations ?? []);
        this.grilleY.place(y.graduations ?? []);

        // L'axe des abscisses, à y = 0 s'il est dans le cadre.
        const zéro = Math.min(Math.max(0, y.min), y.max);
        this.axe = this._trait(this.X(x.min), this.Y(zéro), this.X(x.max), this.Y(zéro), {
            stroke: GRIS_AXE,
        }, this.couches.grille);
        if (x.nom) this._légende(x.nom, largeur - 2, this.Y(zéro) - 8, 'droite');
        // Le nom de l'ordonnée au-dessus de ses graduations : le haut du
        // graphique reste libre pour les légendes des courbes.
        if (y.nom) this._légende(y.nom, marge.gauche - 5, 9, 'droite', COULEURS.noir);
    }

    // -- Repères et légendes --------------------------------------------------

    /** Les coordonnées d'un point du dessin, en unités du `viewBox`. */
    vers(x, y) {
        return [this.X(x), this.Y(y)];
    }

    /** Montre ou cache le graphique tout entier, légendes comprises. */
    montre(oui = true) {
        this.élément.style.display = oui ? '' : 'none';
        return this;
    }

    _trait(xa, ya, xb, yb, attributs = {}, couche = this.couches.grille) {
        return svg('line', { x1: xa, y1: ya, x2: xb, y2: yb, stroke: GRIS_GRILLE, ...attributs }, couche);
    }

    /** Une légende posée aux coordonnées du dessin. */
    _légende(tex, x, y, ancre = 'centre', couleur = '') {
        const span = créé('span', 'légende');
        Object.assign(span.style, {
            left: `${(100 * x) / this.largeur}%`,
            top: `${(100 * y) / this.hauteur}%`,
            translate: `${ANCRES[ancre]} -50%`,
            color: couleur,
        });
        this.élément.append(span);
        let écrite = null;
        const légende = {
            élément: span,
            écrit(t) {
                if (t !== écrite) écritTex(span, (écrite = t));
                return légende;
            },
            montre(oui = true) {
                span.style.display = oui ? '' : 'none';
                return légende;
            },
        };
        return légende.écrit(tex);
    }

    /**
     * Une légende aux coordonnées du problème, que l'on peut replacer :
     * nommer une courbe, une zone, un point remarquable.
     */
    légende(tex = '', { x = 0, y = 0, ancre = 'centre', couleur = '', décalage = [0, 0] } = {}) {
        const légende = this._légende(tex, 0, 0, ancre, couleur);
        const graphe = this;
        return Object.assign(légende, {
            place(px, py) {
                légende.élément.style.left = `${(100 * (graphe.X(px) + décalage[0])) / graphe.largeur}%`;
                légende.élément.style.top = `${(100 * (graphe.Y(py) + décalage[1])) / graphe.hauteur}%`;
                return légende;
            },
        }).place(x, y);
    }

    /**
     * Les graduations d'un axe, que l'on peut refaire : `place` reprend les
     * traits et les légendes déjà là, et n'en crée que s'il en manque — un
     * axe dont les repères suivent un réglage ne rejoue pas KaTeX tant que
     * leurs noms ne changent pas.
     */
    _grille(axe) {
        const { x, y } = this.domaine;
        const pool = [];
        const grille = {
            place: (graduations) => {
                const valeurs = graduations.map(graduation);
                while (pool.length < valeurs.length) {
                    const horizontal = axe === 'x';
                    pool.push({
                        trait: this._trait(0, 0, 0, 0, {}, this.couches.grille),
                        légende: this._légende('', 0, 0, horizontal ? 'centre' : 'droite'),
                    });
                }
                pool.forEach(({ trait, légende }, i) => {
                    const présente = i < valeurs.length;
                    trait.style.display = présente ? '' : 'none';
                    légende.montre(présente);
                    if (!présente) return;
                    const [valeur, tex] = valeurs[i];
                    if (axe === 'x') {
                        const px = this.X(valeur);
                        trait.setAttribute('x1', px);
                        trait.setAttribute('x2', px);
                        trait.setAttribute('y1', this.Y(y.max));
                        trait.setAttribute('y2', this.Y(y.min));
                        légende.élément.style.left = `${(100 * px) / this.largeur}%`;
                        légende.élément.style.top = `${(100 * (this.hauteur - 9)) / this.hauteur}%`;
                    } else {
                        const py = this.Y(valeur);
                        trait.setAttribute('x1', this.X(x.min));
                        trait.setAttribute('x2', this.X(x.max));
                        trait.setAttribute('y1', py);
                        trait.setAttribute('y2', py);
                        légende.élément.style.left = `${(100 * (this.marge.gauche - 5)) / this.largeur}%`;
                        légende.élément.style.top = `${(100 * py) / this.hauteur}%`;
                    }
                    légende.écrit(tex);
                });
                return grille;
            },
        };
        return grille;
    }

    // -- Tracés ---------------------------------------------------------------

    /** Une courbe, à replacer par `place([[x, y], …])`. */
    courbe({ couleur = COULEURS.noir, épaisseur = 2, pointillés = false, visible = true, couche = 'tracés' } = {}) {
        const ligne = svg(
            'polyline',
            {
                fill: 'none',
                stroke: couleur,
                'stroke-width': épaisseur,
                'stroke-linejoin': 'round',
                ...(pointillés ? { 'stroke-dasharray': '4 3' } : {}),
            },
            this.couches[couche],
        );
        const courbe = {
            élément: ligne,
            couleur,
            place: (points) => {
                ligne.setAttribute(
                    'points',
                    points.map(([x, y]) => `${this.X(x).toFixed(1)},${this.Y(y).toFixed(1)}`).join(' '),
                );
                return courbe;
            },
            montre(oui = true) {
                ligne.style.display = oui ? '' : 'none';
                return courbe;
            },
        };
        return courbe.montre(visible);
    }

    /** La courbe y = f(x), échantillonnée sur toute la largeur. */
    trace(f, options = {}, n = 160) {
        const { min, max } = this.domaine.x;
        return this.courbe(options).place(échantillons(min, max, n).map((x) => [x, f(x)]));
    }

    /**
     * Un spectre : une raie verticale par composante, surmontée d'un point.
     * `place([[f, amplitude], …])`. Tout tient dans deux chemins : les raies
     * vont et viennent sans que rien ne se crée.
     */
    raies({ couleur = COULEURS.noir, épaisseur = 2, rayon = 2.6, visible = true } = {}) {
        const groupe = svg('g', { stroke: couleur, fill: couleur }, this.couches.tracés);
        const tiges = svg('path', { 'stroke-width': épaisseur, fill: 'none' }, groupe);
        const têtes = svg('path', { stroke: 'none' }, groupe);
        const raies = {
            élément: groupe,
            couleur,
            place: (composantes) => {
                const base = this.Y(Math.min(Math.max(0, this.domaine.y.min), this.domaine.y.max));
                const visibles = composantes.filter(([, a]) => Math.abs(a) > 1e-9);
                tiges.setAttribute(
                    'd',
                    visibles.map(([f, a]) => `M ${this.X(f).toFixed(1)} ${base.toFixed(1)} V ${this.Y(a).toFixed(1)}`).join(' ') ||
                        CHEMIN_VIDE,
                );
                têtes.setAttribute(
                    'd',
                    visibles.map(([f, a]) => disque(this.X(f).toFixed(1), this.Y(a).toFixed(1), rayon)).join(' ') ||
                        CHEMIN_VIDE,
                );
                return raies;
            },
            montre(oui = true) {
                groupe.style.display = oui ? '' : 'none';
                return raies;
            },
        };
        return raies.montre(visible);
    }

    /** Un point mobile, à placer aux coordonnées du problème. */
    point({ couleur = COULEURS.noir, rayon = 4, visible = true } = {}) {
        const cercle = svg('circle', { r: rayon, fill: couleur }, this.couches.repères);
        const point = {
            élément: cercle,
            place: (x, y) => {
                cercle.setAttribute('cx', this.X(x).toFixed(1));
                cercle.setAttribute('cy', this.Y(y).toFixed(1));
                return point;
            },
            montre(oui = true) {
                cercle.style.display = oui ? '' : 'none';
                return point;
            },
        };
        return point.montre(visible);
    }

    /** Un repère vertical — le temps qui court, une fréquence de coupure. */
    verticale({ couleur = COULEURS.noir, épaisseur = 1, pointillés = true, visible = true, couche = 'repères' } = {}) {
        const { y } = this.domaine;
        const ligne = svg(
            'line',
            {
                y1: this.Y(y.max),
                y2: this.Y(y.min),
                stroke: couleur,
                'stroke-width': épaisseur,
                ...(pointillés ? { 'stroke-dasharray': '3 3' } : {}),
            },
            this.couches[couche],
        );
        const verticale = {
            élément: ligne,
            place: (x) => {
                ligne.setAttribute('x1', this.X(x).toFixed(1));
                ligne.setAttribute('x2', this.X(x).toFixed(1));
                return verticale;
            },
            montre(oui = true) {
                ligne.style.display = oui ? '' : 'none';
                return verticale;
            },
        };
        return verticale.montre(visible);
    }

    /** Un aplat rectangulaire, derrière la grille : une zone remarquable. */
    zone({ couleur = '#f0f0f0', opacité = 1, visible = true } = {}) {
        const rect = svg('rect', { fill: couleur, 'fill-opacity': opacité }, this.couches.fond);
        const zone = {
            élément: rect,
            place: (x0, x1, y0 = this.domaine.y.min, y1 = this.domaine.y.max) => {
                const [xa, ya] = this.vers(Math.min(x0, x1), Math.max(y0, y1));
                const [xb, yb] = this.vers(Math.max(x0, x1), Math.min(y0, y1));
                Object.entries({ x: xa, y: ya, width: xb - xa, height: yb - ya }).forEach(([clé, v]) =>
                    rect.setAttribute(clé, v.toFixed(1)),
                );
                return zone;
            },
            montre(oui = true) {
                rect.style.display = oui ? '' : 'none';
                return zone;
            },
        };
        return zone.montre(visible);
    }

    /**
     * Une cote horizontale entre deux abscisses, à double flèche, avec son
     * nom au-dessus : la largeur d'une bande, l'écart de deux raies.
     */
    cote(tex = '', { couleur = COULEURS.gris, visible = true } = {}) {
        const chemin = svg(
            'path',
            { stroke: couleur, fill: 'none', 'stroke-width': 1.2 },
            this.couches.repères,
        );
        const nom = this._légende(tex, 0, 0, 'centre', couleur);
        const cote = {
            élément: chemin,
            légende: nom,
            place: (x0, x1, y) => {
                const [xa, py] = this.vers(x0, y);
                const [xb] = this.vers(x1, y);
                const d = Math.sign(xb - xa) * 4;
                chemin.setAttribute(
                    'd',
                    `M ${xa} ${py} H ${xb} M ${xa + d} ${py - 3} L ${xa} ${py} L ${xa + d} ${py + 3} ` +
                        `M ${xb - d} ${py - 3} L ${xb} ${py} L ${xb - d} ${py + 3}`,
                );
                nom.élément.style.left = `${(50 * (xa + xb)) / this.largeur}%`;
                nom.élément.style.top = `${(100 * (py - 9)) / this.hauteur}%`;
                return cote;
            },
            écrit: (t) => (nom.écrit(t), cote),
            montre(oui = true) {
                chemin.style.display = oui ? '' : 'none';
                nom.montre(oui);
                return cote;
            },
        };
        return cote.montre(visible);
    }
}

/** Un graphique tout fait, prêt à recevoir ses tracés. */
export const graphe = (options) => new Graphe(options);
