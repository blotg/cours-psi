"""Programme de colle hebdomadaire, tiré des `#question-de-colle(...)` des polys.

Remplace la version LaTeX historique : le document est désormais produit en
Typst, via le type de document ``programme-de-colle`` du paquet ``@local/prepa``.
"""

from datetime import date
from pathlib import Path

from .chapitre import Chapitre
from .typst import compile_fichier

_ENTÊTE = """#import "@local/prepa:0.1.1": *
#show: programme-de-colle.with(date: datetime(year: {an}, month: {mois}, day: {jour}))
"""


def source(semaine: date, chapitres: list[Chapitre]) -> str:
    """Le document typst du programme de colle."""
    morceaux = [_ENTÊTE.format(an=semaine.year, mois=semaine.month, jour=semaine.day)]
    for chapitre in chapitres:
        questions = chapitre.questions_de_colle
        if not questions:
            continue
        morceaux.append(f"\n= {chapitre.titre(inline=True)}\n")
        morceaux += [f"+ {q}\n" for q in questions]
    return "".join(morceaux)


def génère(racine: Path | str, semaine: date, chapitres: list[Chapitre]) -> Path:
    """Écrit `<racine>/<AA.MM.JJ>/programme.typ` et le compile à côté."""
    dossier = Path(racine) / semaine.strftime("%y.%m.%d")
    dossier.mkdir(parents=True, exist_ok=True)
    fichier = dossier / "programme.typ"
    fichier.write_text(source(semaine, chapitres), encoding="utf-8")
    compile_fichier(fichier, dossier / "programme.pdf")
    return dossier / "programme.pdf"
