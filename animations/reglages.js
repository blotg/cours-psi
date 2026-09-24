// Le panneau de réglages d'une animation : curseurs, cases, choix et
// formules, nommés en LaTeX comme dans le cours.
//
// Chaque méthode ajoute son contrôle au groupe courant (cf. `groupe`) et le
// renvoie, pour qu'on puisse le lire, l'écrire ou le désactiver ensuite.

import { écritTex } from './objets.js';

const créé = (balise, classe = '', texte = '') =>
    Object.assign(document.createElement(balise), { className: classe, textContent: texte });

/** Le nombre de décimales d'un pas : 0,1 en demande une, 1 aucune. */
const décimales = (pas) => (String(pas).split('.')[1] ?? '').length;

export class Réglages {
    constructor(conteneur) {
        this.conteneur = conteneur;
        this.groupe();
    }

    /**
     * Ouvre un nouveau groupe de contrôles, sous un intitulé facultatif.
     * L'objet renvoyé permet de le réécrire — un groupe dont le contenu
     * change de nom avec un réglage.
     */
    groupe(intitulé = '') {
        const élément = créé('div', 'groupe');
        const titre = créé('div', 'intitulé', intitulé);
        titre.hidden = !intitulé;
        élément.append(titre);
        this.conteneur.append(élément);
        this.courant = élément;
        const groupe = {
            élément,
            écrit(texte) {
                titre.textContent = texte;
                titre.hidden = !texte;
                return groupe;
            },
        };
        return groupe;
    }

    /**
     * Un curseur. `tex` le nomme, `couleur` le relie à ce qu'il règle dans la
     * scène ; la valeur s'affiche à la française, suivie de son `unité`.
     *
     * `aimants` retient le curseur sur quelques valeurs remarquables : il y
     * colle dès qu'il en approche de moins d'`attraction`. Un curseur au pas
     * assez fin pour varier continûment garde ainsi ses valeurs rondes à
     * portée de doigt.
     */
    curseur({ tex, min, max, pas = 1, valeur, unité = '', couleur, aimants = [], attraction = 3 * pas, auChangement }) {
        const ligne = créé('label', 'curseur');
        const nom = écritTex(créé('span', 'nom'), tex);
        if (couleur) nom.style.color = couleur;
        const colle = (v) => aimants.find((a) => Math.abs(v - a) <= attraction) ?? v;
        const entrée = Object.assign(créé('input'), { type: 'range', min, max, step: pas, value: colle(valeur) });
        const sortie = créé('output');
        const format = new Intl.NumberFormat('fr-FR', {
            minimumFractionDigits: décimales(pas),
            maximumFractionDigits: décimales(pas),
        });
        const affiche = () => (sortie.textContent = format.format(Number(entrée.value)) + unité);
        entrée.addEventListener('input', () => {
            // Le curseur repart de la position du pointeur à chaque
            // mouvement : le replacer sur l'aimant ne l'empêche pas de s'en
            // détacher, il faut seulement tirer un peu plus loin.
            const collée = colle(Number(entrée.value));
            if (collée !== Number(entrée.value)) entrée.value = collée;
            affiche();
            auChangement?.(collée);
        });
        affiche();
        ligne.append(nom, entrée, sortie);
        this.courant.append(ligne);
        return {
            ligne,
            get valeur() {
                return Number(entrée.value);
            },
            set valeur(v) {
                entrée.value = colle(v);
                affiche();
            },
            désactive(oui = true) {
                entrée.disabled = oui;
                ligne.classList.toggle('désactivé', oui);
            },
            montre(oui = true) {
                ligne.hidden = !oui;
            },
        };
    }

    /** Une case à cocher, nommée par `texte` puis `tex` ; `couleur` ajoute un
     *  témoin de la couleur dans la scène. */
    case({ texte, tex, valeur = true, couleur, auChangement }) {
        const ligne = créé('label', 'case');
        const entrée = Object.assign(créé('input'), { type: 'checkbox', checked: valeur });
        entrée.addEventListener('change', () => auChangement?.(entrée.checked));
        ligne.append(entrée);
        if (couleur) {
            const témoin = créé('span', 'témoin');
            témoin.style.background = couleur;
            ligne.append(témoin);
        }
        ligne.append(créé('span', '', texte));
        if (tex) ligne.append(écritTex(créé('span'), tex));
        this.courant.append(ligne);
        return {
            ligne,
            get valeur() {
                return entrée.checked;
            },
            montre(oui = true) {
                ligne.hidden = !oui;
            },
        };
    }

    /**
     * Un choix entre quelques options `[valeur, tex]`, en boutons accolés.
     * `réécrit` en change la liste : des options dont les noms dépendent
     * d'un autre réglage.
     */
    choix({ options, valeur, auChangement }) {
        const boutons = créé('div', 'choix');
        const sélectionne = (v) => {
            for (const b of boutons.children) b.setAttribute('aria-pressed', String(b.dataset.valeur === String(v)));
        };
        const réécrit = (liste, retenue = valeur) => {
            boutons.replaceChildren();
            for (const [v, tex] of liste) {
                const bouton = écritTex(Object.assign(créé('button'), { type: 'button' }), tex);
                bouton.dataset.valeur = v;
                bouton.addEventListener('click', () => {
                    sélectionne(v);
                    auChangement?.(v);
                });
                boutons.append(bouton);
            }
            sélectionne(retenue);
        };
        réécrit(options);
        this.courant.append(boutons);
        return { sélectionne, réécrit };
    }

    /** Un bouton d'action. */
    bouton(texte, action) {
        const bouton = Object.assign(créé('button', '', texte), { type: 'button' });
        bouton.addEventListener('click', action);
        this.courant.append(bouton);
        return bouton;
    }

    /** Une formule, que l'on peut réécrire. Elle reste en ligne pour tenir
     *  dans la largeur du panneau ; `\displaystyle` garde ses fractions à
     *  leur taille. */
    formule(tex = '') {
        const div = créé('div', 'formule');
        this.courant.append(div);
        let écrite = null;
        const formule = {
            écrit(t) {
                if (t !== écrite) écritTex(div, `\\displaystyle ${(écrite = t)}`);
                return formule;
            },
        };
        return formule.écrit(tex);
    }

    /** Un paragraphe de texte, que l'on peut réécrire. */
    texte(contenu = '') {
        const p = créé('p', '', contenu);
        this.courant.append(p);
        return p;
    }

    /** Un élément quelconque (un graphique, par exemple). */
    ajoute(élément) {
        this.courant.append(élément);
        return élément;
    }
}
