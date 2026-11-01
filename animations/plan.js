// Une vue plane : un canevas dessiné dans les coordonnées du problème, des
// étiquettes en LaTeX par-dessus, et des poignées que l'on déplace à la
// souris ou au doigt.
//
// C'est le pendant à deux dimensions de `Scène` (cf. scene.js), et il en
// reprend les partis pris : le dessin ne se refait qu'à la demande
// (`redessine`) ou à chaque image d'une animation, et jamais hors de
// l'écran. Un schéma plan n'a pas besoin de WebGL : une carte de champ, des
// chronogrammes ou un cycle se dessinent mieux — et partout — sur un canevas.

import { écritTex } from './objets.js';

const créé = (balise, classe = '', texte = '') =>
    Object.assign(document.createElement(balise), { className: classe, textContent: texte });

export class Plan {
    /**
     * @param conteneur  l'élément qui reçoit la vue et sa barre
     * @param rapport    largeur / hauteur de la vue
     * @param étendue    la largeur visible, en unités du problème
     * @param centre     le point du problème au centre de la vue
     * @param aide       le mode d'emploi, dans la barre sous la vue
     */
    constructor(conteneur, { rapport = 4 / 3, étendue = 10, centre = [0, 0], aide = '' } = {}) {
        Object.assign(this, { rapport, étendue, centre, poignées: [], attrapée: null, prise: [0, 0] });

        const vue = créé('div', 'scène');
        this.toile = créé('canvas');
        this.toile.style.touchAction = 'none';
        this.contexte = this.toile.getContext('2d');
        this.calque = créé('div', 'étiquettes');
        vue.append(this.toile, this.calque);

        this.barre = créé('div', 'barre');
        if (aide) this.barre.append(créé('span', 'aide', aide));
        conteneur.append(vue, this.barre);
        this.conteneur = vue;

        this.toile.addEventListener('pointerdown', (e) => this.attrape(e));
        this.toile.addEventListener('pointermove', (e) => this.déplace(e));
        for (const fin of ['pointerup', 'pointercancel']) this.toile.addEventListener(fin, (e) => this.lâche(e));

        new ResizeObserver(() => this.redimensionne()).observe(vue);
        new IntersectionObserver(([entrée]) => {
            this.àLÉcran = entrée.isIntersecting;
            this.redessine();
        }).observe(vue);
        const cadre = conteneur.closest('.corps') ?? vue;
        new IntersectionObserver(([entrée]) => this.anime(entrée.isIntersecting)).observe(cadre);
        this.redimensionne();
    }

    /** Un bouton de plus dans la barre sous la vue. */
    bouton(texte, action) {
        const bouton = créé('button', '', texte);
        bouton.type = 'button';
        bouton.addEventListener('click', action);
        this.barre.append(bouton);
        return bouton;
    }

    // -- Repère ---------------------------------------------------------------

    /** L'abscisse d'un point du problème, en pixels de la vue. */
    X(x) {
        return this.largeur / 2 + (x - this.centre[0]) * this.échelle;
    }

    /** L'ordonnée, comptée vers le haut comme en mathématiques. */
    Y(y) {
        return this.hauteur / 2 - (y - this.centre[1]) * this.échelle;
    }

    /** Le point du problème, en pixels de la vue. */
    vers(x, y) {
        return [this.X(x), this.Y(y)];
    }

    /** L'inverse : le point du problème sous un pixel de la vue. */
    depuis(px, py) {
        return [
            this.centre[0] + (px - this.largeur / 2) / this.échelle,
            this.centre[1] - (py - this.hauteur / 2) / this.échelle,
        ];
    }

    /** Une longueur du problème, en pixels. */
    long(l) {
        return l * this.échelle;
    }

    /** Le rectangle du problème que la vue montre. */
    cadre() {
        const demi = this.étendue / 2;
        const haut = demi / this.rapport;
        const [cx, cy] = this.centre;
        return { x0: cx - demi, x1: cx + demi, y0: cy - haut, y1: cy + haut };
    }

    // -- Dessin ---------------------------------------------------------------

    /** `rappel(c, plan)` dessine la vue ; il est rappelé à chaque besoin. */
    dessine(rappel) {
        this.rappel = rappel;
        this.redessine();
        return this;
    }

    /** Un réglage a changé : il faudra refaire le dessin. */
    redessine() {
        this.àRefaire = true;
    }

    /** `rappel(dt)` avant chaque image, dt en secondes : la vue est animée. */
    àChaqueImage(rappel) {
        this.àChaqueDt = rappel;
        this.redessine();
    }

    redimensionne() {
        const largeur = this.conteneur.clientWidth;
        if (!largeur) return;
        const hauteur = Math.round(largeur / this.rapport);
        const densité = Math.min(window.devicePixelRatio || 1, 2);
        Object.assign(this.toile, { width: Math.round(largeur * densité), height: Math.round(hauteur * densité) });
        Object.assign(this.toile.style, { width: `${largeur}px`, height: `${hauteur}px` });
        // Le canevas se dessine en pixels de la page : la densité de l'écran
        // ne change que la finesse du tracé.
        this.contexte.setTransform(densité, 0, 0, densité, 0, 0);
        Object.assign(this, { largeur, hauteur, échelle: largeur / this.étendue });
        this.redessine();
    }

    anime(visible) {
        if (this.boucle) cancelAnimationFrame(this.boucle);
        this.boucle = null;
        this.instant = null;
        if (visible) this.boucle = requestAnimationFrame((t) => this.image(t));
    }

    image(instant) {
        this.boucle = requestAnimationFrame((t) => this.image(t));
        const dt = Math.min((instant - (this.instant ?? instant)) / 1000, 0.1);
        this.instant = instant;
        if (this.àChaqueDt) this.àChaqueDt(dt);
        if (!this.àRefaire || !this.àLÉcran || !this.largeur) return;
        this.àRefaire = false;
        const c = this.contexte;
        c.clearRect(0, 0, this.largeur, this.hauteur);
        c.lineJoin = c.lineCap = 'round';
        this.rappel?.(c, this);
    }

    // -- Étiquettes -----------------------------------------------------------

    /**
     * Une étiquette en LaTeX posée sur la vue, aux coordonnées du problème.
     * `décalage` l'écarte du point, en pixels, pour dégager ce qu'elle nomme.
     */
    étiquette(tex = '', { couleur = '', taille = '1.05rem', ancre = 'centre' } = {}) {
        const span = créé('span', 'étiquette');
        Object.assign(span.style, { position: 'absolute', color: couleur, fontSize: taille });
        this.calque.append(span);
        let écrite = null;
        const étiquette = {
            élément: span,
            écrit(t) {
                if (t !== écrite) écritTex(span, (écrite = t));
                return étiquette;
            },
            place: (x, y, décalage = [0, 0]) => {
                const [px, py] = this.vers(x, y);
                span.style.left = `${px + décalage[0]}px`;
                span.style.top = `${py + décalage[1]}px`;
                span.style.translate = `${ancre === 'centre' ? '-50%' : ancre === 'droite' ? '-100%' : '0'} -50%`;
                return étiquette;
            },
            montre(oui = true) {
                span.style.display = oui ? '' : 'none';
                return étiquette;
            },
        };
        return étiquette.écrit(tex);
    }

    // -- Poignées -------------------------------------------------------------

    /**
     * Un point que l'on attrape et que l'on déplace : `auDéplacement(x, y)`
     * reçoit sa nouvelle position, à la charge de l'animation de la retenir
     * (et de la borner). `rayon` est la portée de la prise, en pixels.
     *
     * Un objet étendu (un barreau, une plaque) se prend n'importe où :
     * `contient(x, y)` dit si le point du problème est dessus. Sa position
     * suit alors le pointeur à l'écart où on l'a pris : il ne saute pas sous
     * le doigt.
     */
    poignée({ position, rayon = 16, contient = null, auDéplacement, auRelâchement } = {}) {
        const poignée = { position, rayon, contient, auDéplacement, auRelâchement };
        this.poignées.push(poignée);
        return poignée;
    }

    /** La poignée sous le pointeur, la plus proche s'il y en a plusieurs. */
    sous(e) {
        const cadre = this.toile.getBoundingClientRect();
        const px = e.clientX - cadre.left;
        const py = e.clientY - cadre.top;
        let trouvée = null;
        let meilleure = Infinity;
        const point = this.depuis(px, py);
        for (const poignée of this.poignées) {
            const [x, y] = this.vers(...poignée.position());
            const distance = poignée.contient?.(...point) ? 0 : Math.hypot(px - x, py - y);
            if (distance < poignée.rayon && distance < meilleure) {
                meilleure = distance;
                trouvée = poignée;
            }
        }
        return { poignée: trouvée, point };
    }

    attrape(e) {
        const { poignée, point } = this.sous(e);
        if (!poignée) return;
        this.attrapée = poignée;
        const [x, y] = poignée.position();
        this.prise = poignée.contient ? [x - point[0], y - point[1]] : [0, 0];
        // Suivre le pointeur même s'il sort de la vue ; un navigateur refuse
        // la prise s'il ne connaît plus ce pointeur, et ce n'est pas grave.
        try {
            this.toile.setPointerCapture(e.pointerId);
        } catch {
            /* on continue sans capture */
        }
        this.toile.style.cursor = 'grabbing';
        e.preventDefault();
    }

    déplace(e) {
        const { poignée, point } = this.sous(e);
        if (this.attrapée) {
            this.attrapée.auDéplacement?.(point[0] + this.prise[0], point[1] + this.prise[1]);
            this.redessine();
            e.preventDefault();
            return;
        }
        this.toile.style.cursor = poignée ? 'grab' : '';
    }

    lâche(e) {
        if (!this.attrapée) return;
        this.attrapée.auRelâchement?.();
        this.attrapée = null;
        this.toile.style.cursor = '';
        try {
            this.toile.releasePointerCapture(e.pointerId);
        } catch {
            /* la prise n'avait pas été accordée */
        }
        this.redessine();
    }
}

// -- De quoi dessiner ---------------------------------------------------------
//
// Ces fonctions travaillent en pixels de la vue : une animation y amène ses
// points par `plan.vers(x, y)`. Les couleurs et les épaisseurs sont celles
// d'un schéma (cf. COULEURS dans objets.js).

/** Une ligne brisée, passant par les points [px, py] donnés. */
export function chemin(c, points, { couleur = '#000', épaisseur = 1.5, pointillés = null, fermé = false } = {}) {
    if (points.length < 2) return;
    c.save();
    c.beginPath();
    c.moveTo(...points[0]);
    for (const p of points.slice(1)) c.lineTo(...p);
    if (fermé) c.closePath();
    Object.assign(c, { strokeStyle: couleur, lineWidth: épaisseur });
    if (pointillés) c.setLineDash(pointillés);
    c.stroke();
    c.restore();
}

/** Un disque plein, éventuellement cerné. */
export function disque(c, [px, py], rayon, { couleur = '#000', bord = null, épaisseur = 1.5 } = {}) {
    c.save();
    c.beginPath();
    c.arc(px, py, rayon, 0, 2 * Math.PI);
    c.fillStyle = couleur;
    c.fill();
    if (bord) {
        Object.assign(c, { strokeStyle: bord, lineWidth: épaisseur });
        c.stroke();
    }
    c.restore();
}

/**
 * Une flèche, du point `départ` et sur `longueur` pixels dans la direction
 * `direction` (un couple [dx, dy] en pixels, de norme quelconque).
 */
export function flèche(c, [px, py], direction, longueur, { couleur = '#000', épaisseur = 2, tête = 7 } = {}) {
    const norme = Math.hypot(...direction);
    if (!norme || longueur < 0.5) return;
    const [ux, uy] = [direction[0] / norme, direction[1] / norme];
    // Une flèche courte garde une pointe à sa mesure.
    const pointe = Math.min(tête, 0.55 * longueur);
    const bout = [px + ux * longueur, py + uy * longueur];
    const pied = [bout[0] - ux * pointe, bout[1] - uy * pointe];
    chemin(c, [[px, py], pied], { couleur, épaisseur });
    c.save();
    c.beginPath();
    c.moveTo(...bout);
    c.lineTo(pied[0] - uy * pointe * 0.42, pied[1] + ux * pointe * 0.42);
    c.lineTo(pied[0] + uy * pointe * 0.42, pied[1] - ux * pointe * 0.42);
    c.closePath();
    c.fillStyle = couleur;
    c.fill();
    c.restore();
}

/** Une pointe de flèche seule, centrée sur un point : le sens d'une ligne
 *  de champ, qui n'a ni début ni fin. */
export function pointe(c, [px, py], direction, { couleur = '#000', taille = 7 } = {}) {
    const norme = Math.hypot(...direction);
    if (!norme) return;
    const [ux, uy] = [direction[0] / norme, direction[1] / norme];
    const bout = [px + (ux * taille) / 2, py + (uy * taille) / 2];
    const pied = [px - (ux * taille) / 2, py - (uy * taille) / 2];
    aplat(
        c,
        [bout, [pied[0] - uy * taille * 0.42, pied[1] + ux * taille * 0.42], [pied[0] + uy * taille * 0.42, pied[1] - ux * taille * 0.42]],
        couleur,
    );
}

/** Un aplat : une surface fermée, remplie sans bord. */
export function aplat(c, points, couleur) {
    if (points.length < 3) return;
    c.save();
    c.beginPath();
    c.moveTo(...points[0]);
    for (const p of points.slice(1)) c.lineTo(...p);
    c.closePath();
    c.fillStyle = couleur;
    c.fill();
    c.restore();
}

/**
 * Un conducteur vu en coupe, comme sur les figures du cours : un point si le
 * courant vient vers nous (⊙), une croix s'il s'en éloigne (⊗), rien s'il
 * est nul. Trop petit pour porter un signe, il n'est plus qu'un point noir.
 */
export function conducteur(c, [px, py], I, rayon, { couleur = '#000' } = {}) {
    if (rayon < 3.5) {
        disque(c, [px, py], rayon, { couleur });
        return;
    }
    disque(c, [px, py], rayon, { couleur: '#fff', bord: couleur, épaisseur: 1.6 });
    if (I > 0) disque(c, [px, py], rayon * 0.3, { couleur });
    if (I < 0) {
        const d = rayon / Math.SQRT2;
        chemin(c, [[px - d, py - d], [px + d, py + d]], { couleur, épaisseur: 1.6 });
        chemin(c, [[px - d, py + d], [px + d, py - d]], { couleur, épaisseur: 1.6 });
    }
}

/**
 * Des lignes de champ, données aux coordonnées du problème (des lignes
 * brisées, cf. `polylignes` dans carte.js) et fléchées dans le sens du champ :
 * `champ(x, y)` le donne, et une pointe prend le sens de la ligne qui
 * s'accorde avec lui.
 *
 * Les pointes sont posées tous les `entre` pixels le long de chaque ligne, la
 * première à mi-distance de son début : une ligne courte, fermée sur un fil,
 * en a encore une. Ou bien, comme dans les figures du poly, là où les lignes
 * traversent la droite horizontale `traversée` = { y, écart } : une rangée
 * de pointes alignées, à `écart` pixels au moins l'une de l'autre — de quoi
 * flécher des lignes qui se resserrent sans les couvrir de pointes.
 */
export function lignesDeChamp(
    c,
    plan,
    lignes,
    champ,
    { couleur = '#000', épaisseur = 1.4, entre = 110, pointillés = null, traversée = null } = {},
) {
    const pointes = [];
    for (const ligne of lignes) {
        const points = ligne.map(([x, y]) => plan.vers(x, y));
        chemin(c, points, { couleur, épaisseur, pointillés });
        let prochaine = entre / 2;
        let parcouru = 0;
        for (let i = 0; i + 1 < points.length; i++) {
            const [a, b] = [points[i], points[i + 1]];
            const tangente = [b[0] - a[0], b[1] - a[1]];
            const longueur = Math.hypot(...tangente);
            const pose = (t) => {
                const [x, y] = [ligne[i][0] + t * (ligne[i + 1][0] - ligne[i][0]), ligne[i][1] + t * (ligne[i + 1][1] - ligne[i][1])];
                const [bx, by] = champ(x, y);
                // L'écran compte y vers le bas.
                const sens = Math.sign(tangente[0] * bx - tangente[1] * by) || 1;
                pointes.push([[a[0] + t * tangente[0], a[1] + t * tangente[1]], [sens * tangente[0], sens * tangente[1]]]);
            };
            if (traversée) {
                const [ya, yb] = [ligne[i][1] - traversée.y, ligne[i + 1][1] - traversée.y];
                if (ya * yb < 0 || (ya === 0 && yb !== 0)) pose(ya / (ya - yb));
                continue;
            }
            while (longueur && parcouru + longueur >= prochaine) {
                pose((prochaine - parcouru) / longueur);
                prochaine += entre;
            }
            parcouru += longueur;
        }
        // Les pointes d'une ligne, sur elle, sous la ligne suivante.
        if (!traversée) {
            for (const [point, direction] of pointes) pointe(c, point, direction, { couleur });
            pointes.length = 0;
        }
    }
    if (traversée) {
        // De gauche à droite, en sautant celles qui tomberaient trop près de
        // la dernière posée.
        pointes.sort((p, q) => p[0][0] - q[0][0]);
        let dernière = -Infinity;
        for (const [point, direction] of pointes) {
            if (point[0] - dernière < traversée.écart) continue;
            dernière = point[0];
            pointe(c, point, direction, { couleur });
        }
    }
}
