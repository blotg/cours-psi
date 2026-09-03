"""Questions de QCM au format attendu par QCMCam (lecture par caméra).

Une question est faite d'un énoncé et d'une liste de réponses dont la
**première est la bonne**. L'ordre d'affichage est ensuite tiré au sort.
"""

import json
import re
from pathlib import Path
from random import shuffle


def _échappe(texte: str) -> str:
    """Passe les formules `$...$` dans le `<span>` que QCMCam sait rendre."""
    return re.sub(r"\${1,2}(?P<formule>[\s\S]*?)\${1,2}", r'<span class="math-tex">\g<formule></span>', texte)


class Question:
    def __init__(self, énoncé: str = "", réponses: list[str] | None = None):
        self.énoncé = énoncé
        self.réponses = list(réponses or [])

    def vers_dict(self) -> dict:
        positions = list(range(len(self.réponses)))
        shuffle(positions)  # positions[i] : place de la i-ème réponse à l'affichage

        html = [f"<h3>{_échappe(self.énoncé)}</h3>", "<ol>"]
        for place in range(len(positions)):
            indice = positions.index(place)
            classe = ' class="rondvert"' if indice == 0 else ""
            html.append(f"<li{classe}>{_échappe(self.réponses[indice])}</li>")
        html.append("</ol>")

        return {"question": "".join(html), "reponse": chr(ord("A") + positions[0])}


def vers_json(questions: list[Question]) -> str:
    résultat: dict = {str(i): q.vers_dict() for i, q in enumerate(questions)}
    résultat["size"] = {"width": "834px", "height": "604px"}
    return json.dumps(résultat)


def écrit_fichier(questions: list[Question], fichier: Path | str) -> Path:
    fichier = Path(fichier)
    fichier.parent.mkdir(parents=True, exist_ok=True)
    fichier.write_text(vers_json(questions), encoding="utf-8")
    return fichier


def depuis_yaml(source: Path | str, destination: Path | str) -> list[Path]:
    """Éclate un YAML `date: [{énoncé: [réponses…]}, …]` en un fichier par date."""
    import yaml

    données = yaml.full_load(Path(source).read_text(encoding="utf-8"))
    écrits = []
    for date, questions in données.items():
        liste = [
            Question(list(q.keys())[0], [str(r) for r in list(q.values())[0]])
            for q in questions
        ]
        écrits.append(écrit_fichier(liste, Path(destination) / f"{date:%Y-%m-%d}.txt"))
    return écrits
