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
python3 -m outils build "Cours/8 - Électrochimie"           # DM + flashcards + manipulations
python3 -m outils flashcards "Cours/8 - Électrochimie"      # .apkg et planche .pdf
python3 -m outils manipulations "Cours/8 - Électrochimie"   # manipulations - Électrochimie.pdf
python3 -m outils dm "Cours/8 - Électrochimie"              # DM 1 - Électrochimie.pdf, ...
python3 -m outils imprimable "Cours/8 - Électrochimie"      # poly-imprimable - Électrochimie.pdf
python3 -m outils imprimable --quadrillage "Cours/8 - ..."  # poly-quadrillé - Électrochimie.pdf
python3 -m outils colles Colles 2026-09-29 "Cours/8 - Électrochimie"
python3 -m outils tp "TP/1 - .../TP.typ" péda/élèves.csv --numéro 1
python3 -m outils qcm questions.yaml dates/
```

Toutes ces commandes acceptent plusieurs chapitres à la suite.

`build` est ce qu'appelle le hook : il enchaîne `dm`, `flashcards` et
`manipulations` sur un même objet `Chapitre`, donc une seule requête
`typst query` par chapitre — c'est de loin le poste le plus cher.

`flashcards` produit deux fichiers : le paquet Anki (`.apkg`) et une planche à
découper (`.pdf`), quatre cartes A6 par page A4. Les rectos d'un groupe de
quatre occupent une page et leurs versos la suivante, en miroir horizontal :
imprimée en recto-verso avec **retournement sur le bord long**, chaque carte a
bien son verso derrière son recto.

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
| `tp.py` | sujets de TP personnalisés par binôme, mis en fascicule |
| `qcm_cam.py` | questions au format QCMCam |

Les documents qui ne viennent pas d'une source propre au chapitre sont rendus
depuis un gabarit typst de [`gabarits/`](../gabarits) — la planche de
flashcards et la liste des manipulations. Les données leur arrivent en JSON par
`--input données`.

## D'où viennent les données

Le paquet typst `@local/prepa` émet des `metadata` que les outils relisent avec
`typst query` :

| Étiquette | Source interrogée | Utilisée par |
|---|---|---|
| `<flashcard>` | `cours.typ` | `flashcards` |
| `<question-de-colle>` | `cours.typ` | `colles` |
| `<coups-de-pouce>` | `TD.typ` | `Chapitre.coups_de_pouce` |
| `<manipulation>` | `cours.typ` | `manipulations` |
| `titre-court` (infos.yml) | — | nom des documents produits |
| `DM` (infos.yml) | — | `dm` |
| `<première-page-cours>`, `<dernière-page-cours>`, `<première-page>`, `<dernière-page>` | `poly.typ` | `imprimable` |

On interrogue toujours le document le moins cher qui contient l'information :
compiler le poly coûte bien plus que le seul cours.
