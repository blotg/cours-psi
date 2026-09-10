# Outils

Production des documents du cours à partir des sources typst.
Tout ce qui est produit atterrit dans `<chapitre>/build/`, ignoré par git,
sous le nom `<type> - <titre court>.<ext>`.

Le titre court vient du champ `titre-court` de l'`infos.yml` du chapitre ; à
défaut — les TP n'en ont pas — c'est le nom du dossier privé de son préfixe de
classement (`2 - Filtre de Wien` donne `Filtre de Wien`). Le type vient en tête
pour qu'un dossier de téléchargements regroupe les documents de même nature
plutôt que ceux d'un même chapitre.

## Installation

```sh
python3 -m venv outils/.venv
outils/.venv/bin/pip install -r outils/requirements.txt
```

Le hook `pre-commit` utilise ce venv s'il existe, sinon le `python3` du système.
Sans les dépendances, il se contente d'un avertissement : les PDF sont quand
même produits, seules les flashcards et la copie des DM manquent.

## Ligne de commande

Depuis la racine du dépôt :

```sh
python3 -m outils build "Cours/8 - Électrochimie"           # tout ce qui suit, en une passe
python3 -m outils flashcards "Cours/8 - Électrochimie"      # .apkg et planche .pdf
python3 -m outils manipulations "Cours/8 - Électrochimie"   # manipulations - Électrochimie.pdf
python3 -m outils diapo "Cours/8 - Électrochimie"           # diapo - Électrochimie.pdf
python3 -m outils dm "Cours/8 - Électrochimie"              # DM 1 - Électrochimie.pdf, ...
python3 -m outils imprimable "Cours/8 - Électrochimie"      # poly-imprimable - Électrochimie.pdf
python3 -m outils imprimable --quadrillage "Cours/8 - ..."  # poly-quadrillé - Électrochimie.pdf
python3 -m outils colles Colles 2026-09-29 "Cours/8 - Électrochimie"
python3 -m outils questions-de-colle                # toutes les questions de colle de l'année
python3 -m outils tp "TP/1 - .../TP.typ" péda/élèves.csv --numéro 1
python3 -m outils qcm questions.yaml dates/
python3 -m outils site                              # site/ : le cours en HTML
```

Toutes ces commandes acceptent plusieurs chapitres à la suite.

`build` est ce qu'appelle le hook : il enchaine `dm`, `flashcards`,
`manipulations`, `diapo` et `imprimable` sur un même objet `Chapitre`, donc une seule
requête `typst query` par chapitre — c'est de loin le poste le plus cher.

`flashcards` produit deux fichiers : le paquet Anki (`.apkg`) et une planche à
découper (`.pdf`), quatre cartes A6 par page A4. Les rectos d'un groupe de
quatre occupent une page et leurs versos la suivante, en miroir horizontal :
imprimée en recto-verso avec **retournement sur le bord long**, chaque carte a
bien son verso derrière son recto.

Chaque carte est coiffée d'un bandeau qui porte le titre court du chapitre et
le rang de la carte dans le paquet : découpée, elle dit encore d'où elle vient.
C'est le titre *court* (« Électronique 2 »), le seul qui tienne sur une ligne de
105 mm — les cases vides d'une planche incomplète, elles, restent vierges.

Le paquet Anki reprend l'arborescence de `Cours/`, `::` séparant les niveaux
comme Anki l'attend : `Cours/1 - Électronique/2 - Rétroaction` donne
« Physique-Chimie PSI::1 - Électronique::2 - Rétroaction ». Les préfixes de
classement des dossiers sont gardés — Anki trie ses paquets par nom, ce sont eux
qui remettent les thèmes et les chapitres dans l'ordre du cours. Le nom se
règle en tête de `chapitre.py` (`PAQUET_ANKI`) ; l'identifiant du paquet en
étant déduit, le renommer fait apparaitre un **nouveau** paquet dans Anki : les
anciens, plats, restent à supprimer à la main.

`diapo` produit le diaporama des questions de début de cours du chapitre :
une question par diapo, en QCM, et le corrigé sur la dernière. Les réponses
sont saisies avec **la bonne en tête** ; l'ordre d'affichage est tiré au sort
par le gabarit, de façon déterministe — le tirage ne dépend que du texte de la
question, donc une recompilation redonne le même corrigé. Un chapitre sans
question ne produit rien.

Les tirages au sort du dépôt — cet ordre-là, et la personne à qui l'on explique
dans un exercice « J'explique à… » — sont ceux de
[`suiji`](https://typst.app/universe/package/suiji). Le paquet `prepa` ne garde
que la conversion du texte en graine (`graine-du-texte`) : c'est elle qui rend
le tirage reproductible d'une compilation à l'autre.

`questions-de-colle` rassemble en un seul document **toutes** les questions de
colle de l'année : celles de tous les chapitres de `Cours/`, dans l'ordre du
tri lexicographique des dossiers, groupées par chapitre. La numérotation, elle,
est continue d'un bout à l'autre — chaque question porte un numéro qui vaut
pour l'année, là où le programme de colle hebdomadaire repart à 1 à chaque
chapitre. Un chapitre encore sans question y figure quand même, signalé comme
tel : ce qui reste à écrire se voit. Le document atterrit dans
`Cours/build/questions de colle.pdf` (`--sortie` pour en changer) ; nommer des
chapitres à la suite restreint la liste à ceux-là.

Il n'est **pas** produit par le hook : il dépend de tous les chapitres à la
fois, et les interroger coûte une vingtaine de secondes — c'est une commande
qu'on lance quand on en a besoin.

`imprimable` produit par défaut un **fascicule A3 paysage** : deux pages A4 par
face, à imprimer en recto-verso (retournement sur le bord court) puis à plier.
`--quadrillage` donne l'autre mise en page : le poly A4 tel quel, avec une page
quadrillée en regard de chaque page de cours (pour écrire face au texte).

## Modules

| Module | Rôle |
|---|---|
| `typst.py` | appels à `typst compile` / `typst query`, rendu HTML d'un fragment |
| `chapitre.py` | un chapitre : ses métadonnées et les documents qu'on en tire |
| `pdf.py` | imposition de PDF (mise en fascicule A3) |
| `anki.py` | écriture d'un paquet `.apkg` |
| `programme_de_colle.py` | programme de colle hebdomadaire (en typst) |
| `questions_de_colle.py` | liste de toutes les questions de colle de l'année |
| `tp.py` | sujets de TP personnalisés par binôme, mis en fascicule |
| `qcm_cam.py` | questions au format QCMCam |
| `site.py` | site statique du cours, en HTML |

`site` produit le site statique dans `site/`, ignoré par git : une page par
exercice et par cours, plus un sommaire par chapitre, l'accueil regroupant les
chapitres par thème. Les pages de contenu ne sont pas une réécriture du cours
en HTML — ce sont les mêmes sources typst, compilées avec `--format html` :
les formules deviennent du MathML, les schémas cetz/zap des SVG, et la mise en
page se refait en CSS (cf. `gabarits/site.css`, noir sur blanc comme le
papier). Le sommaire d'un chapitre offre en plus le poly et les flashcards
(planche à découper et paquet Anki) au téléchargement : ce sont les fichiers
de `build/`, donc ceux qu'`outils build` a produits — un chapitre jamais
construit est signalé et son lien omis.

Coups de pouce et corrigés y figurent, mais floutés : il faut tenir le survol
— ou l'appui, sur écran tactile — cinq secondes pour un coup de pouce, quinze
pour un corrigé (transition CSS, aucun script ; les délais se règlent en tête
de `site.css`). C'est le hook `pre-push` qui reconstruit tout ça, et qui publie
sur la branche `gh-pages` si on le lui demande (`git config hooks.site true`).

**On ne recompile que ce qui a bougé.** Chaque page note dans
`.site-manifeste.json` (à la racine, ignoré par git) sa recette et l'empreinte
— taille et date — de tout ce dont typst dit dépendre (`--make-deps`) : la
source, le gabarit, le paquet, les paquets typst. Une page dont rien n'a bougé
n'est pas refaite. Une reconstruction complète prend une minute ; un push qui
ne touche qu'un exercice, deux secondes. `outils site` fait par ailleurs le
ménage : une page qu'il n'a pas produite — exercice retiré du TD, chapitre
renommé — disparait de `site/`. Effacer le manifeste refait tout.

Les compilations sont **menées de front** (huit à la fois par défaut, cf.
`--processus`) : dans `outils site` page par page, dans `outils build` chapitre
par chapitre, et dans le hook `pre-commit` document par document. Elles sont
indépendantes et le gain est d'un facteur trois à cinq.

Les documents qui ne viennent pas d'une source propre au chapitre sont rendus
depuis un gabarit typst de [`gabarits/`](../gabarits) — la planche de
flashcards, la liste des manipulations, le diaporama, les questions de colle
et les pages de liens du site. Les données leur arrivent en JSON par
`--input données`.

## D'où viennent les données

Le paquet typst `@local/prepa` émet des `metadata` que les outils relisent avec
`typst query` :

| Étiquette | Source interrogée | Utilisée par |
|---|---|---|
| `<flashcard>` | `cours.typ` | `flashcards` |
| `<question-de-colle>` | `cours.typ` | `colles`, `questions-de-colle` |
| `<question-de-début-de-cours>` | `cours.typ` | `diapo` |
| `<coups-de-pouce>` | `TD.typ` | `Chapitre.coups_de_pouce` |
| `<manipulation>` | `cours.typ` | `manipulations` |
| `titre-court` (infos.yml) | — | nom des documents produits, bandeau des flashcards |
| `DM` (infos.yml) | — | `dm` |
| `<première-page-cours>`, `<dernière-page-cours>`, `<première-page>`, `<dernière-page>` | `poly.typ` | `imprimable` |

On interroge toujours le document le moins cher qui contient l'information :
compiler le poly coute bien plus que le seul cours.
