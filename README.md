# Cours de physique-chimie en PSI

Les sources du cours de physique-chimie de PSI de Guillaume Blot-Teyssedre : cours, exercices, DM, TP, flashcards et questions de colle, rédigés en [typst](https://typst.app), ainsi que les outils qui en tirent les documents distribués aux élèves et le site du cours.

## Le site

**<https://blotg.github.io/cours-psi/>**

On y lit en ligne les cours et les exercices de chaque chapitre, les TP et les révisions de PCSI.

Les coups de pouce et les corrigés sont floutés : il faut maintenir le survol, appuyer sur un écran tactile, cinq secondes pour un coup de pouce et quinze pour un corrigé. Le sommaire de chaque chapitre propose aussi le poly en PDF et les flashcards à télécharger, en planche à imprimer et en paquet [Anki](https://apps.ankiweb.net/).

## Contenu

| Dossier | Contenu |
|---|---|
| [`Cours/`](Cours) | les chapitres, rangés par thème et les chapitres d'outils (méthodes numériques, opérateurs vectoriels, systèmes de coordonnées) |
| [`révisions/`](révisions) | les révisions de PCSI : flashcards et questions de colle, sans cours rédigé |
| [`TP/`](TP) | les sujets de TP |
| [`prepa/`](prepa) | le paquet typst `@local/prepa`, qui donne leur forme à tous les documents |
| [`gabarits/`](gabarits) | les gabarits des documents tirés du cours : planche de flashcards, diaporama, questions de colle, pages du site, notebooks |
| [`animations/`](animations) | la bibliothèque commune des animations 3D des chapitres, et leur construction par vite |
| [`outils/`](outils) | les outils Python de production et de publication |
| [`.githooks/`](.githooks) | les hooks qui recompilent les documents au commit et publient le site au push |

Un chapitre de `Cours/` contient :

- `infos.yml` : titre, titre court, DM, exercices du cahier d'entraînement ;
- `cours.typ` : le cours, avec ses flashcards, questions de colle, questions de
  début de cours et manipulations ;
- `compétences.typ` et `méthodes.typ` ;
- `TD.typ`, qui rassemble les exercices du dossier `exercices/` ;
- `poly.typ`, qui assemble le tout en un seul document ;
- éventuellement `DM/` (sujets et corrigés en PDF), `Simulations/` (scripts
  Python, et parfois les figures qu'ils produisent) et `animations/` (pages
  animées en 3D, liées depuis le sommaire du chapitre sur le site).

Les documents produits atterrissent dans un dossier `build/` propre à chaque
chapitre, ignoré par git.

## Compiler

Il faut [typst](https://github.com/typst/typst) (version >= 0.15) dans le `PATH`. Le paquet `prepa` s'installe comme paquet local, par un lien dans le dossier de données de typst (ici sous Linux) :

```sh
mkdir -p ~/.local/share/typst/packages/local/prepa
ln -s "$PWD/prepa/0.1.1" ~/.local/share/typst/packages/local/prepa/0.1.1
```

Un chapitre se compile alors depuis son dossier :

```sh
cd "Cours/1 - Électronique/3 - Oscillateurs"
mkdir -p build
typst compile poly.typ build/poly.pdf
```

Le reste (flashcards, diaporama, poly imprimable en fascicule, notebooks, sujets de TP par binôme, programme de colle, site) passe par les outils Python :

```sh
python3 -m venv outils/.venv
outils/.venv/bin/pip install -r outils/requirements.txt
outils/.venv/bin/python -m outils build "Cours/1 - Électronique/3 - Oscillateurs"
```

Pour que les documents d'un chapitre se recompilent à chaque commit qui le touche :

```sh
git config core.hooksPath .githooks
```

Les animations demandent en plus [Node.js](https://nodejs.org) (version >= 20.19) ; leurs dépendances s'installent seules à la première construction (cf. [`animations/README.md`](animations/README.md)).

Toutes les commandes, les hooks et leurs réglages sont décrits dans [`outils/README.md`](outils/README.md).

## Usage de l'IA

**Cours et exercices :** La rédaction est entièrement manuelle. Une IA (Claude Opus) a ensuite ensuite le texte pour y chercher des erreurs, et les corrections sont faites à la main.

**Simulations et animations :** Les scripts des dossiers `Simulations/` ont été conçus par une IA (Claude Opus). La cohérence physique des résultats est vérifiée à la main, et le code est relu manuellement.

**Outils de publication et gabarits :** Une première version, écrite à la main, a servi de version alpha. Elle a ensuite été réécrite presque entièrement par une IA (Claude Opus), sans relecture manuelle du code. Cela concerne le paquet [`prepa/`](prepa), les [`gabarits/`](gabarits), les [`outils/`](outils) et les [`.githooks/`](.githooks).

## Licences

- Le code (`prepa/`, `gabarits/`, `outils/`, `animations/`, `.githooks/`) est sous [EUPL-1.2](LICENCES/EUPL-1.2.txt).
- Le cours et ses documents (`Cours/`, `révisions/`, `TP/`, et tout ce qui en est tiré) sont sous [CC BY-NC 4.0](LICENCES/CC-BY-NC-4.0.txt) : libres de réutilisation et d'adaptation, y compris pour son propre enseignement, en citant l'auteur et sans usage commercial.
- Le logo du lycée et les énoncés d'origine externe (concours, ouvrages) ne relèvent d'aucune de ces deux licences.

Le détail, et l'attribution attendue, sont dans [`LICENCE.md`](LICENCE.md).
