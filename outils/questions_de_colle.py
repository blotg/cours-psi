"""Liste de toutes les questions de colle de l'année, tirée des cours.

Le programme de colle hebdomadaire (`programme_de_colle.py`) ne montre que les
chapitres d'une semaine, renumérotés à partir de 1. Ce document-ci est l'autre
bout : tout le cours d'un coup, dans l'ordre des chapitres, avec une
numérotation continue qui donne à chaque question un numéro pour l'année.
"""

import json
import os
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

from .chapitre import GABARITS, Chapitre, chapitres
from .typst import compile_fichier

#: Où atterrit le document. Un `build/` comme celui des chapitres : c'est un
#: produit et non une source, et `.gitignore` l'ignore déjà à ce titre.
SORTIE = Path("Cours") / "build" / "questions de colle.pdf"

#: Chapitres interrogés de front. Une requête `typst query` par cours, et il y
#: en a une trentaine : c'est tout le coût du document.
PROCESSUS = min(8, os.cpu_count() or 1)


def données(liste: list[Chapitre], processus: int = PROCESSUS) -> dict:
    """Ce que le gabarit attend : les chapitres, dans l'ordre, avec leurs questions.

    Les chapitres sans question restent dans la liste, questions vides : le
    gabarit les signale « à venir » plutôt que de les taire.
    """
    if len(liste) > 1 and processus > 1:
        # `questions_de_colle` est un cached_property : on le déclenche de front
        # pour que la boucle qui suit trouve tout en cache. Chaque appel attend
        # un sous-processus typst, les fils s'y prêtent donc bien.
        with ThreadPoolExecutor(max_workers=processus) as pool:
            list(pool.map(lambda c: c.questions_de_colle, liste))
    return {
        "chapitres": [
            {"titre": c.titre(inline=True), "questions": c.questions_de_colle}
            for c in liste
        ]
    }


def génère(
    sortie: Path | str = SORTIE,
    racine: Path | str = "Cours",
    liste: list[Chapitre] | None = None,
    processus: int = PROCESSUS,
) -> Path:
    """Compile le document. `liste` remplace, si elle est donnée, les chapitres
    trouvés sous `racine`.

    À défaut, ce sont tous les chapitres portant un `poly.typ` sous `racine`,
    dans l'ordre du tri lexicographique de leur chemin — celui du dossier
    `Cours/`, donc les thèmes puis les chapitres.
    """
    sortie = Path(sortie)
    if liste is None:
        liste = chapitres(racine)
    compile_fichier(
        GABARITS / "questions-de-colle.typ",
        sortie,
        entrées={"données": json.dumps(données(liste, processus), ensure_ascii=False)},
    )
    return sortie
