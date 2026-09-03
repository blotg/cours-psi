# Outils

Production des documents du cours à partir des sources typst.
Tout ce qui est produit atterrit dans `<chapitre>/build/`, ignoré par git.

## Installation

```sh
python3 -m venv outils/.venv
outils/.venv/bin/pip install -r outils/requirements.txt
```

Le hook `pre-commit` utilise ce venv s'il existe, sinon le `python3` du système.
Sans les dépendances, il se contente d'un avertissement : les PDF sont quand
même produits, seules les flashcards manquent.

## Ligne de commande

Depuis la racine du dépôt :

```sh
python3 -m outils flashcards "Cours/8 - Électrochimie"    # build/flashcards.apkg
python3 -m outils imprimable "Cours/8 - Électrochimie"    # build/poly-imprimable.pdf
python3 -m outils colles Colles 2026-09-29 "Cours/8 - Électrochimie"
python3 -m outils tp "TP/1 - .../TP.typ" péda/élèves.csv --numéro 1
python3 -m outils qcm questions.yaml dates/
```

`flashcards` et `imprimable` acceptent plusieurs chapitres à la suite.

## Modules

| Module | Rôle |
|---|---|
| `typst.py` | appels à `typst compile` / `typst query`, rendu HTML d'un fragment |
| `chapitre.py` | un chapitre : ses métadonnées et les documents qu'on en tire |
| `anki.py` | écriture d'un paquet `.apkg` |
| `programme_de_colle.py` | programme de colle hebdomadaire (en typst) |
| `tp.py` | fascicules de TP personnalisés par binôme, imposés en A3 |
| `qcm_cam.py` | questions au format QCMCam |

## D'où viennent les données

Le paquet typst `@local/prepa` émet des `metadata` que les outils relisent avec
`typst query` :

| Étiquette | Source interrogée | Utilisée par |
|---|---|---|
| `<flashcard>` | `cours.typ` | `flashcards` |
| `<question-de-colle>` | `cours.typ` | `colles` |
| `<coups-de-pouce>` | `TD.typ` | `Chapitre.coups_de_pouce` |
| `<première-page-cours>`, `<dernière-page-cours>`, `<première-page>`, `<dernière-page>` | `poly.typ` | `imprimable` |

On interrogue toujours le document le moins cher qui contient l'information :
compiler le poly coûte bien plus que le seul cours.
