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

    /** Ouvre un nouveau groupe de contrôles, sous un intitulé facultatif. */
    groupe(intitulé = '') {
        this.courant = créé('div', 'groupe');
        if (intitulé) this.courant.append(créé('div', 'intitulé', intitulé));
        this.conteneur.append(this.courant);
        return this.courant;
    }

    /**
     * Un curseur. `tex` le nomme, `couleur` le relie à ce qu'il règle dans la
     * scène ; la valeur s'affiche à la française, suivie de son `unité`.
     */
    curseur({ tex, min, max, pas = 1, valeur, unité = '', couleur, auChangement }) {
        const ligne = créé('label', 'curseur');
        const nom = écritTex(créé('span', 'nom'), tex);
        if (couleur) nom.style.color = couleur;
        const entrée = Object.assign(créé('input'), { type: 'range', min, max, step: pas, value: valeur });
        const sortie = créé('output');
        const format = new Intl.NumberFormat('fr-FR', {
            minimumFractionDigits: décimales(pas),
            maximumFractionDigits: décimales(pas),
        });
        const affiche = () => (sortie.textContent = format.format(Number(entrée.value)) + unité);
        entrée.addEventListener('input', () => {
            affiche();
            auChangement?.(Number(entrée.value));
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
                entrée.value = v;
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
            get valeur() {
                return entrée.checked;
            },
        };
    }

    /** Un choix entre quelques options `[valeur, tex]`, en boutons accolés. */
    choix({ options, valeur, auChangement }) {
        const boutons = créé('div', 'choix');
        const sélectionne = (v) => {
            for (const b of boutons.children) b.setAttribute('aria-pressed', String(b.dataset.valeur === String(v)));
        };
        for (const [v, tex] of options) {
            const bouton = écritTex(Object.assign(créé('button'), { type: 'button' }), tex);
            bouton.dataset.valeur = v;
            bouton.addEventListener('click', () => {
                sélectionne(v);
                auChangement?.(v);
            });
            boutons.append(bouton);
        }
        sélectionne(valeur);
        this.courant.append(boutons);
        return { sélectionne };
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
