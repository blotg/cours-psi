"""Programme de colle hebdomadaire, tiré des `#question-de-colle(...)` des cours.

Remplace la version LaTeX historique : le document est désormais produit en
Typst, via le type de document ``programme-de-colle`` du paquet ``@local/prepa``.

Les questions portent du content, que `typst query` ne restitue qu'avec perte :
le programme ne les recopie donc pas, il inclut les cours de la semaine en
annexe (cf. ``cours-en-annexe``) et les liste sur place.
"""

import os
from datetime import date
from pathlib import Path

from . import typst
from .chapitre import RACINE, Chapitre

_ENTÊTE = """// Produit par `python3 -m outils colles`, qu'il vaut mieux relancer : les cours
// y sont inclus en annexe depuis le dépôt, et à la main il faudrait à typst
//     typst compile --root "{racine}" --input inclus=1 programme.typ
// qui imprimerait aussi les pages des cours.
#import "@local/prepa:0.1.1": *
#show: programme-de-colle.with(date: datetime(year: {an}, month: {mois}, day: {jour}))
"""

# Un chapitre sans question ne fait pas de titre vide.
_LISTE = """
#context for (titre, questions) in titres.zip(par-cours(<question-de-colle>)) {
    if questions.len() > 0 {
        heading(markup(titre))
        enum(..questions)
    }
}
"""


def _tableau(éléments: list[str]) -> str:
    # La virgule finale est indispensable : sans elle, typst lit un élément
    # seul comme une simple parenthèse et non comme un tableau d'une entrée.
    return "(" + ", ".join(éléments) + ("," if éléments else "") + ")"


def source(semaine: date, chapitres: list[Chapitre], racine: Path) -> str:
    """Le document typst du programme de colle, pour la racine typst `racine`."""
    inclusions = ", ".join(f"include {typst.chaine(c.inclusion(racine))}" for c in chapitres)
    return (
        _ENTÊTE.format(racine=racine, an=semaine.year, mois=semaine.month, jour=semaine.day)
        + f"#show: cours-en-annexe.with({inclusions})\n"
        + f"#let titres = {_tableau([typst.chaine(c.titre(inline=True)) for c in chapitres])}\n"
        + _LISTE
    )


def génère(racine: Path | str, semaine: date, chapitres: list[Chapitre]) -> Path:
    """Écrit `<racine>/<AA.MM.JJ>/programme.typ` et le compile à côté."""
    dossier = Path(racine) / semaine.strftime("%y.%m.%d")
    dossier.mkdir(parents=True, exist_ok=True)
    # typst ne lit rien hors de sa racine : il la faut au-dessus du programme
    # comme des cours.
    racine_typst = Path(os.path.commonpath([dossier.resolve(), RACINE]))
    fichier = dossier / "programme.typ"
    fichier.write_text(source(semaine, chapitres, racine_typst), encoding="utf-8")
    typst.compile_avec_annexe(fichier, dossier / "programme.pdf", entrées={"inclus": "1"}, racine=racine_typst)
    return dossier / "programme.pdf"
