"""Un chapitre du cours : ses sources typst et les documents qu'on en tire."""

import json
import re
from functools import cached_property
from pathlib import Path
from shutil import copyfile

import yaml

from . import typst

#: Sous-dossier où atterrissent tous les documents produits (ignoré par git).
SORTIE = "build"

#: Documents compilés directement depuis une source du même nom.
DOCUMENTS = ("cours", "TD", "poly", "TP", "évaluation")

#: Gabarits typst des documents construits à partir de données extraites
#: du cours (et non d'une source propre au chapitre).
GABARITS = Path(__file__).resolve().parent.parent / "gabarits"


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

    @cached_property
    def titre_court(self) -> str:
        """Nom court du chapitre, qui sert à nommer les documents produits.

        Il vient de `titre-court` dans infos.yml. À défaut — les TP n'ont pas
        d'infos.yml — on retombe sur le nom du dossier privé de son préfixe de
        classement : « 2 - Filtre de Wien » donne « Filtre de Wien ».
        """
        court = self.infos.get("titre-court")
        return str(court).strip() if court else re.sub(r"^\d+\s*-\s*", "", self.chemin.name)

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
    def manipulations(self) -> list[dict]:
        """Manipulations du cours : titre et matériel, dans l'ordre du document."""
        return self.métadonnées("<manipulation>", "cours")

    @cached_property
    def questions_de_colle(self) -> list[str]:
        return self.métadonnées("<question-de-colle>", "cours")

    @cached_property
    def DMs(self) -> list[dict[str, Path]]:
        """Énoncés et corrigés de DM déclarés dans infos.yml, chemins résolus.

        Chaque entrée est un dictionnaire `{"énoncé": ..., "corrigé": ...}`,
        le corrigé pouvant manquer.
        """
        return [
            {clé: self.chemin / valeur for clé, valeur in dm.items()}
            for dm in self.infos.get("DM") or []
        ]

    # -- Documents produits ----------------------------------------------

    @property
    def sortie(self) -> Path:
        return self.chemin / SORTIE

    def fichier(self, type_de_document: str, extension: str = "pdf") -> Path:
        """Où atterrit un document produit : `build/<type> - <titre court>.<ext>`.

        Le type vient en tête pour qu'un dossier de téléchargements regroupe
        les documents de même nature plutôt que ceux d'un même chapitre.
        """
        return self.sortie / f"{type_de_document} - {self.titre_court}.{extension}"

    def document(self, nom: str) -> Path | None:
        """Compile `<nom>.typ` vers `build/<nom>.pdf`. None si la source manque."""
        source = self.chemin / f"{nom}.typ"
        if not source.is_file():
            return None
        cible = self.fichier(nom)
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
            self.fichier("flashcards", "apkg"),
        )

    def DM(self) -> list[Path]:
        """Met les DM et leurs corrigés dans build/, sous le nommage commun.

        Les DM sont encore des PDF écrits à la main : une copie suffit. Quand
        ils passeront à typst, seul le corps de cette méthode changera — le
        reste de la chaîne (nommage, hook, site) n'a pas à le savoir.
        """
        produits = []
        for dm in self.DMs:
            for source in dm.values():
                if not source.is_file():
                    print(f"  DM absent   {source}")
                    continue
                cible = self.fichier(source.stem)
                cible.parent.mkdir(parents=True, exist_ok=True)
                copyfile(source, cible)
                produits.append(cible)
        return produits

    def _depuis_gabarit(self, gabarit: str, cible: Path, données: dict) -> Path:
        """Compile un gabarit de `gabarits/` avec des données en `--input`.

        Le JSON passe par la ligne de commande plutôt que par un fichier
        temporaire : ça évite d'avoir à élargir la racine typst au dépôt.
        """
        typst.compile_fichier(
            GABARITS / f"{gabarit}.typ",
            cible,
            entrées={"données": json.dumps(données, ensure_ascii=False)},
        )
        return cible

    def flashcards_imprimables(self) -> Path | None:
        """Les flashcards en A6, quatre par page, à imprimer en recto-verso.

        None s'il n'y a aucune carte dans le chapitre.
        """
        cartes = self.métadonnées("<flashcard>", "cours")
        if not cartes:
            return None
        return self._depuis_gabarit(
            "flashcards",
            self.fichier("flashcards"),
            {"titre": self.titre(inline=True), "cartes": cartes},
        )

    def liste_des_manipulations(self) -> Path:
        """La liste des manipulations du chapitre et le matériel à sortir."""
        return self._depuis_gabarit(
            "manipulations",
            self.fichier("manipulations"),
            {"titre": self.titre(inline=True), "manipulations": self.manipulations},
        )

    def poly_imprimable(self, quadrillage: bool = False) -> Path:
        """Le poly mis en forme pour l'impression.

        Par défaut, un fascicule A3 paysage : deux pages A4 par face, à
        imprimer en recto-verso (retournement sur le bord court) puis à plier.

        Avec `quadrillage`, l'autre mise en page : le poly A4 tel quel, avec
        une page quadrillée en regard de chaque page de cours pour écrire face
        au texte.
        """
        poly = self.poly()
        if poly is None:
            raise FileNotFoundError(f"{self.chemin}/poly.typ est introuvable")
        if quadrillage:
            return self._poly_quadrillé(poly)
        from .pdf import fascicule

        return fascicule(poly, self.fichier("poly-imprimable"))

    def _poly_quadrillé(self, poly: Path) -> Path:
        from tempfile import TemporaryDirectory

        from pypdf import PdfWriter

        s = self.signets
        cible = self.fichier("poly-quadrillé")

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
#show: init-document.with(titre: "{titre}", logotype: false)
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
