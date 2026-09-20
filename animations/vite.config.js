// Construit les animations d'un chapitre : chaque page HTML de son dossier
// `animations/` devient une page autonome dans `build/animations/`.
//
// Lancé par `python3 -m outils animations` (cf. outils/animations.py), qui
// passe par l'environnement :
//
//   ANIMATIONS_SOURCE  le dossier `animations/` du chapitre
//   ANIMATIONS_SORTIE  le dossier produit (défaut : `../build/animations`)
//   ANIMATIONS_FIL     le fil d'Ariane du site jusqu'au chapitre, en JSON :
//                      [["Accueil", "../../index.html"], …]
//
// Les pages n'écrivent que leur titre et leur contenu : le fil d'Ariane et le
// pied de page du site leur sont ajoutés ici, la feuille de style par
// `#animations/page.js`, qu'importe leur script.

import { readFileSync, readdirSync } from 'node:fs';
import { basename, dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { defineConfig } from 'vite';

const ici = dirname(fileURLToPath(import.meta.url));
const racine = resolve(ici, '..');
const source = resolve(process.env.ANIMATIONS_SOURCE ?? '.');
const sortie = resolve(process.env.ANIMATIONS_SORTIE ?? resolve(source, '../build/animations'));
const fil = JSON.parse(process.env.ANIMATIONS_FIL ?? '[]');

// Une animation par page HTML du dossier : pas de liste à tenir à jour.
const pages = Object.fromEntries(
    readdirSync(source)
        .filter((f) => f.endsWith('.html'))
        .map((f) => [f.slice(0, -'.html'.length), resolve(source, f)]),
);

const échappe = (texte) =>
    String(texte).replace(/[&<>"]/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' })[c]);

// Le même habillage que les pages que typst produit pour le site (cf.
// gabarits/site.typ) : fil d'Ariane en tête, licence en pied.
function pageDuSite() {
    return {
        name: 'page-du-site',
        transformIndexHtml(html) {
            const titre = html.match(/<title>([^<]*)<\/title>/)?.[1] ?? '';
            const liens = fil.map(([texte, url]) =>
                url ? `<a href="${échappe(url)}">${échappe(texte)}</a>` : `<span>${échappe(texte)}</span>`,
            );
            const nav =
                '<nav class="fil">' +
                [...liens, `<span class="ici">${titre}</span>`].join('<span class="sep">›</span>') +
                '</nav>';
            // Même texte que le pied des pages typst (gabarits/site.typ).
            const pied =
                '<footer><span>Cours de PSI — lycée Brizeux</span>' +
                '<a href="https://creativecommons.org/licenses/by-nc/4.0/deed.fr">CC BY-NC 4.0</a></footer>';
            if (!/<meta name="viewport"/.test(html)) {
                html = html.replace(
                    /<meta charset="[^"]*">/,
                    '$&\n<meta name="viewport" content="width=device-width, initial-scale=1">',
                );
            }
            return html.replace(/<body([^>]*)>/, `<body$1>\n${nav}`).replace('</body>', `${pied}\n</body>`);
        },
    };
}

// Un dossier `animations/` de chapitre n'a pas d'`index.html` : à la racine,
// le serveur de développement sert le sommaire de ses pages, pour que
// l'adresse qu'il annonce mène quelque part.
function sommaireDeDéveloppement() {
    return {
        name: 'sommaire-de-développement',
        apply: 'serve',
        configureServer(serveur) {
            serveur.middlewares.use((requête, réponse, suite) => {
                const chemin = requête.url.split('?')[0];
                if (chemin !== '/' && chemin !== '/index.html') return suite();
                const liens = Object.entries(pages)
                    .map(([nom, fichier]) => {
                        const html = readFileSync(fichier, 'utf-8');
                        const titre = html.match(/<title>([^<]*)<\/title>/)?.[1] ?? nom;
                        return `<li><a href="./${échappe(nom)}.html">${échappe(titre)}</a></li>`;
                    })
                    .join('\n');
                réponse.setHeader('Content-Type', 'text/html; charset=utf-8');
                réponse.end(
                    '<!doctype html>\n<html lang="fr">\n<head>\n<meta charset="utf-8">\n' +
                        `<title>Animations — ${échappe(basename(resolve(source, '..')))}</title>\n` +
                        '</head>\n<body>\n<h1>Animations</h1>\n' +
                        `<ul>\n${liens}\n</ul>\n</body>\n</html>\n`,
                );
            });
        },
    };
}

export default defineConfig(({ command }) => ({
    root: source,
    // Des adresses relatives : les pages sont recopiées telles quelles dans
    // le site, à un endroit que vite n'a pas à connaître.
    base: './',
    publicDir: false,
    // vite annonce l'adresse du serveur en niveau `info` ; une
    // construction, elle, n'a rien à dire tant qu'elle réussit.
    logLevel: command === 'serve' ? 'info' : 'warn',
    clearScreen: false,
    build: {
        outDir: sortie,
        emptyOutDir: true,
        // three.js pèse à lui seul plus que le seuil par défaut.
        chunkSizeWarningLimit: 1500,
        rolldownOptions: { input: pages },
    },
    // Le serveur de développement doit pouvoir lire la bibliothèque commune
    // et la feuille du site, hors du dossier du chapitre.
    server: { fs: { allow: [racine] } },
    plugins: [pageDuSite(), sommaireDeDéveloppement()],
}));
