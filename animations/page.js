// Mise en page commune des animations : la feuille du site, celle de KaTeX,
// et le lancement des animations d'une page.

import 'katex/dist/katex.min.css';
import './page.css';

const créé = (balise, classe) => Object.assign(document.createElement(balise), { className: classe });

/**
 * Le cadre d'une animation, sous le titre de sa section : la scène, et ses
 * réglages à côté — dessous sur un écran étroit.
 */
export function cadre(section) {
    const corps = créé('div', 'corps');
    const vue = créé('div', 'vue');
    const réglages = créé('div', 'panneau');
    corps.append(vue, réglages);
    section.append(corps);
    return { vue, réglages };
}

/**
 * Lance `fabrique(section)` sur chaque élément que désigne `sélecteur`, à
 * l'approche de l'écran seulement : une page porte plusieurs scènes, et un
 * téléphone limite le nombre de contextes WebGL ouverts à la fois.
 */
export function lance(sélecteur, fabrique) {
    const observateur = new IntersectionObserver(
        (entrées) => {
            for (const { isIntersecting, target } of entrées) {
                if (!isIntersecting) continue;
                observateur.unobserve(target);
                try {
                    fabrique(target);
                } catch (erreur) {
                    console.error(erreur);
                    const message = créé('p', 'vide');
                    message.textContent =
                        'Cette animation ne peut pas s’afficher : le navigateur ne permet pas le dessin en 3D (WebGL).';
                    target.append(message);
                }
            }
        },
        { rootMargin: '300px' },
    );
    document.querySelectorAll(sélecteur).forEach((élément) => observateur.observe(élément));
}
