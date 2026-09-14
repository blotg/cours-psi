"""Liste de toutes les questions de colle de l'année, tirée des cours.

Le programme de colle hebdomadaire (`programme_de_colle.py`) ne montre que les
chapitres d'une semaine, renumérotés à partir de 1. Ce document-ci est l'autre
bout : tout le cours d'un coup, dans l'ordre des chapitres, avec une
numérotation continue qui donne à chaque question un numéro pour l'année.

Les questions portent du content, que `typst query` ne restitue qu'avec perte :
le gabarit inclut donc tous les cours en annexe, et les lit sur place. C'est ce
qui coûte : deux compilations de toute l'année, l'une pour savoir où s'arrête
la liste, l'autre pour ne produire qu'elle.
"""

import json
from pathlib import Path

from .chapitre import GABARITS, RACINE, RACINE_COURS, RACINE_RÉVISIONS, Chapitre, chapitres
from .typst import compile_avec_annexe

#: Où atterrit le document. Un `build/` comme celui des chapitres : c'est un
#: produit et non une source, et `.gitignore` l'ignore déjà à ce titre.
SORTIE = Path(RACINE_COURS) / "build" / "questions de colle.pdf"

#: Le même document pour les révisions de PCSI, rangé à côté d'elles.
SORTIE_RÉVISIONS = Path(RACINE_RÉVISIONS) / "build" / "questions de colle.pdf"


def données(liste: list[Chapitre]) -> dict:
    """Ce que le gabarit attend : les chapitres, dans l'ordre, et leur cours.

    Les chapitres sans question restent dans la liste : le gabarit les signale
    « à venir » plutôt que de les taire.

    `révisions` dit au gabarit de titrer « révisions de PCSI » plutôt que
    « PSI » : c'est le cas quand tous les chapitres sont sous `révisions/`,
    `-r` ou non.
    """
    return {
        "révisions": bool(liste) and all(c.révision for c in liste),
        "chapitres": [{"titre": c.titre(inline=True), "cours": c.inclusion()} for c in liste],
    }


def génère(
    sortie: Path | str = SORTIE,
    racine: Path | str = "Cours",
    liste: list[Chapitre] | None = None,
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
    compile_avec_annexe(
        GABARITS / "questions-de-colle.typ",
        sortie,
        entrées={"données": json.dumps(données(liste), ensure_ascii=False), "inclus": "1"},
        racine=RACINE,
    )
    return sortie
