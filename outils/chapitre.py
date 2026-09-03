"""Un chapitre du cours : ses sources typst et les documents qu'on en tire."""

from functools import cached_property
from pathlib import Path

import yaml

from . import typst

#: Sous-dossier où atterrissent tous les documents produits (ignoré par git).
SORTIE = "build"

#: Documents compilés directement depuis une source du même nom.
DOCUMENTS = ("cours", "TD", "poly", "TP")


class Chapitre:
    def __init__(self, chemin: Path | str):
        self.chemin = Path(chemin)
        self._cache_métadonnées: dict[str, list[dict]] = {}

    def __repr__(self) -> str:
        return f"Chapitre({self.chemin.name!r})"

    # -- Sources et métadonnées ------------------------------------------

    @cached_property
    def infos(self) -> dict:
        fichier = self.chemin / "infos.yml"
        return yaml.safe_load(fichier.read_text(encoding="utf-8")) if fichier.is_file() else {}

    def titre(self, inline: bool = False) -> str:
        titre = self.infos.get("titre", self.chemin.name).strip()
        return titre.replace("\n", " : ") if inline else titre

    def _toutes_métadonnées(self, document: str) -> list[dict]:
        """Métadonnées d'un document, en une requête typst (mise en cache)."""
        if document not in self._cache_métadonnées:
            self._cache_métadonnées[document] = typst.query(self.chemin / f"{document}.typ", "metadata") or []
        return self._cache_métadonnées[document]

    def métadonnées(self, étiquette: str, document: str = "poly") -> list:
        """Valeurs des métadonnées portant l'étiquette donnée, ex. `<flashcard>`.

        `document` désigne la source à interroger : le poly contient tout, mais
        le compiler coûte plus cher que le seul cours ou le seul TD.
        """
        return [d["value"] for d in self._toutes_métadonnées(document) if d.get("label") == étiquette]

    @cached_property
    def signets(self) -> dict[str, int]:
        """Pages (indexées à partir de 0) délimitant le cours dans le poly."""
        return {
            nom: self.métadonnées(f"<{nom}>")[0] - 1
            for nom in ("première-page", "dernière-page", "première-page-cours", "dernière-page-cours")
        }

    @cached_property
    def coups_de_pouce(self) -> list[list[list[str]]]:
        """Coups de pouce du TD, indexés par [exercice][question]."""
        liste: list[list[list[str]]] = []
        for x in self.métadonnées("<coups-de-pouce>", "TD"):
            while len(liste) < x["exercice"]:
                liste.append([])
            questions = liste[x["exercice"] - 1]
            while len(questions) < x["question"]:
                questions.append([])
            questions[x["question"] - 1] += x["coups-de-pouce"]
        return liste

    @cached_property
    def questions_de_colle(self) -> list[str]:
        return self.métadonnées("<question-de-colle>", "cours")

    @cached_property
    def DMs(self) -> list[dict]:
        """Sujets et corrigés de DM, chemins rendus absolus."""
        dms = self.infos.get("DMs") or []
        for dm in dms:
            for clé in ("sujet", "corrigé"):
                if dm.get(clé):
                    dm[clé] = self.chemin / dm[clé]
        return dms

    # -- Documents produits ----------------------------------------------

    @property
    def sortie(self) -> Path:
        return self.chemin / SORTIE

    def document(self, nom: str) -> Path | None:
        """Compile `<nom>.typ` vers `build/<nom>.pdf`. None si la source manque."""
        source = self.chemin / f"{nom}.typ"
        if not source.is_file():
            return None
        cible = self.sortie / f"{nom}.pdf"
        typst.compile_fichier(source, cible)
        return cible

    def cours(self) -> Path | None:
        return self.document("cours")

    def TD(self) -> Path | None:
        return self.document("TD")

    def poly(self) -> Path | None:
        return self.document("poly")

    def flashcards(self) -> Path | None:
        """Paquet Anki tiré des `#flashcard(...)` du poly. None s'il n'y en a pas."""
        cartes = self.métadonnées("<flashcard>", "cours")
        if not cartes:
            return None
        from . import anki

        # Recto et verso de toutes les cartes en une seule compilation typst.
        faces = typst.vers_html_lot([f for c in cartes for f in (c["recto"], c["verso"])])
        return anki.écrit_paquet(
            self.titre(inline=True),
            list(zip(faces[::2], faces[1::2])),
            self.sortie / "flashcards.apkg",
        )

    def poly_imprimable(self) -> Path:
        """Le poly avec une page quadrillée en regard de chaque page de cours,
        pour une impression recto-verso où l'on écrit face au texte."""
        from tempfile import TemporaryDirectory

        from pypdf import PdfWriter

        poly = self.poly()
        if poly is None:
            raise FileNotFoundError(f"{self.chemin}/poly.typ est introuvable")
        s = self.signets
        cible = self.sortie / "poly-imprimable.pdf"

        with TemporaryDirectory() as tmp:
            quadrillage = Path(tmp) / "quadrillage.pdf"
            typst.compile_source(_SOURCE_QUADRILLAGE.format(titre=self.titre(inline=True)), quadrillage)

            fusion = PdfWriter()
            fusion.append(poly, pages=(0, s["première-page-cours"]))
            # Chaque page de cours doit tomber en belle page (recto) pour avoir
            # sa page quadrillée en vis-a-vis : on decale d'une page blanche si
            # la premiere page de cours tombe du mauvais cote.
            if s["première-page-cours"] % 2 == 0:
                fusion.append(str(quadrillage))
            for page in range(s["première-page-cours"], s["dernière-page-cours"] + 1):
                fusion.append(poly, pages=[page])
                fusion.append(str(quadrillage))
            if s["dernière-page-cours"] < s["dernière-page"]:
                fusion.append(poly, pages=(s["dernière-page-cours"] + 1, s["dernière-page"] + 1))

            cible.parent.mkdir(parents=True, exist_ok=True)
            with open(cible, "wb") as f:
                fusion.write(f)
        return cible


_SOURCE_QUADRILLAGE = """
#import "@local/prepa:0.1.1": *
#show: init-document.with(titre: "{titre}")
#set page(numbering: none, background: rect(width: 100%, height: 100%, stroke: none, fill: tiling(size: (5mm, 5mm))[
    #place(line(start: (0%, 0%), end: (100%, 0%), stroke: 0.5pt + rgb("#CCCCCC")))
    #place(line(start: (0%, 0%), end: (0%, 100%), stroke: 0.5pt + rgb("#CCCCCC")))
]))
#v(1fr)
"""


def chapitres(racine: Path | str) -> list[Chapitre]:
    """Tous les dossiers sous `racine` qui portent un poly.typ."""
    return sorted(
        (Chapitre(p.parent) for p in Path(racine).rglob("poly.typ")),
        key=lambda c: str(c.chemin),
    )
