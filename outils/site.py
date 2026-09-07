"""Site statique du cours, produit par `typst compile --format html`.

Une page par document : l'accueil, un sommaire et un cours par chapitre, une
page par exercice, une page par TP. Rien n'est réécrit en HTML à la main — les
pages de contenu sont les sources typst du cours compilées vers une autre
cible, les pages de liens viennent du gabarit `gabarits/site-liens.typ`.

Le seul post-traitement est l'insertion, dans le `<head>` que typst produit, du
lien vers la feuille de style : typst n'expose pas encore ce `<head>`.
"""

import json
import re
import unicodedata
from pathlib import Path
from shutil import copyfile

from . import typst
from .chapitre import GABARITS, Chapitre, chapitres

#: Dossier produit, ignoré par git (cf. .gitignore) et publié par le hook pre-push.
SORTIE = "site"

#: Racine du dépôt : les `#include` des pages s'y résolvent.
RACINE = Path(__file__).resolve().parent.parent


def adresse(texte: str) -> str:
    """Un nom de fichier sûr dans une URL, tiré d'un titre.

    « Étude de fonctions de transfert » donne « etude-de-fonctions-de-transfert ».
    """
    sans_accent = "".join(
        c for c in unicodedata.normalize("NFD", texte.lower()) if unicodedata.category(c) != "Mn"
    )
    return re.sub(r"-+", "-", re.sub(r"[^a-z0-9]+", "-", sans_accent)).strip("-") or "page"


def _chaine(valeur: str) -> str:
    """Une chaîne littérale typst."""
    return '"' + valeur.replace("\\", "\\\\").replace('"', '\\"') + '"'


def _fil(entrées) -> str:
    """Le fil d'Ariane, en littéral typst : une suite de (texte, url ou none)."""
    morceaux = [f"({_chaine(t)}, {_chaine(u) if u else 'none'})" for t, u in entrées]
    # La virgule finale est indispensable : sans elle, typst lit un couple seul
    # comme une simple parenthèse et non comme un tableau d'une entrée.
    return "(" + ", ".join(morceaux) + ("," if morceaux else "") + ")"


def _titre_exercice(source: Path) -> str:
    """Le `titre:` de l'appel à `exercice()`, à défaut le nom du fichier."""
    motif = r'#show:\s*exercice\.with\(\s*(?:.*?\s)?titre:\s*"((?:[^"\\]|\\.)*)"'
    trouvé = re.search(motif, source.read_text(encoding="utf-8"), re.S)
    return trouvé.group(1).replace('\\"', '"') if trouvé else source.stem


class Site:
    def __init__(self, sortie: Path | str = SORTIE):
        self.sortie = Path(sortie)
        self.produits: list[Path] = []

    # -- Une page ---------------------------------------------------------

    def _style(self, cible: Path, profondeur: int) -> None:
        """Accroche la feuille de style au <head> que typst vient d'écrire."""
        lien = "../" * profondeur + "styles.css"
        html = cible.read_text(encoding="utf-8")
        html = html.replace("</head>", f'<link rel="stylesheet" href="{lien}"></head>', 1)
        cible.write_text(html, encoding="utf-8")
        self.produits.append(cible)

    def page_contenu(
        self,
        chemin: str,
        source: Path,
        titre: str,
        fil,
        profondeur: int,
        corrigés: bool = False,
    ) -> Path:
        """Une page qui compile un document du cours (cours, exercice, TP).

        Le document est `#include`d par son chemin absolu : dans une source lue
        sur l'entrée standard, il se résout sur la racine passée à `--root`.
        """
        inclus = "/" + source.resolve().relative_to(RACINE).as_posix()
        cible = self.sortie / chemin
        typst.compile_source(
            f'#import "/gabarits/site.typ": *\n'
            f"#show: page-site.with(\n"
            f"    titre: {_chaine(titre)},\n"
            f"    fil: {_fil(fil)},\n"
            f"    corrigés: {'true' if corrigés else 'false'},\n"
            f")\n"
            f"#include {_chaine(inclus)}\n",
            cible,
            html=True,
            racine=RACINE,
        )
        self._style(cible, profondeur)
        return cible

    def page_liens(self, chemin: str, données: dict, profondeur: int) -> Path:
        """Une page qui n'est qu'un titre et des listes de liens."""
        cible = self.sortie / chemin
        typst.compile_fichier(
            GABARITS / "site-liens.typ",
            cible,
            entrées={"données": json.dumps(données, ensure_ascii=False)},
            html=True,
        )
        self._style(cible, profondeur)
        return cible

    # -- Lecture des sources ----------------------------------------------

    @staticmethod
    def exercices(chapitre: Chapitre) -> list[tuple[Path, str]]:
        """Les exercices d'un chapitre, dans l'ordre du TD.

        On lit les `#include` du TD plutôt que le contenu du dossier : c'est le
        TD qui fixe l'ordre, et un exercice mis en commentaire — parce qu'il est
        faux ou en chantier — ne doit pas se retrouver sur le site.
        """
        td = chapitre.chemin / "TD.typ"
        if not td.is_file():
            return []
        trouvés = []
        for ligne in td.read_text(encoding="utf-8").splitlines():
            trouvé = re.match(r'\s*#include\s+"(exercices/[^"]+\.typ)"', ligne)
            if trouvé:
                source = chapitre.chemin / trouvé.group(1)
                if source.is_file():
                    trouvés.append((source, _titre_exercice(source)))
        return trouvés

    # -- Construction ------------------------------------------------------

    def construit(self) -> list[Path]:
        self.sortie.mkdir(parents=True, exist_ok=True)
        copyfile(GABARITS / "site.css", self.sortie / "styles.css")
        self.produits.append(self.sortie / "styles.css")
        # Sans ce fichier, GitHub Pages fait passer le site par Jekyll, qui
        # ignore tout chemin commençant par un souligné et réécrit le reste.
        (self.sortie / ".nojekyll").write_text("", encoding="utf-8")

        chapitres_liens = []
        for chapitre in chapitres(RACINE / "Cours"):
            dossier = adresse(chapitre.titre_court)
            chapitres_liens.append({
                "texte": chapitre.titre(inline=True),
                "url": f"{dossier}/index.html",
            })
            self._chapitre(chapitre, dossier)

        tp_liens = []
        for tp in sorted((RACINE / "TP").glob("*/TP.typ")):
            nom = re.sub(r"^\d+\s*-\s*", "", tp.parent.name)
            fichier = f"tp/{adresse(nom)}.html"
            tp_liens.append({"texte": nom, "url": fichier})
            self.page_contenu(
                fichier, tp, nom, [("Accueil", "../index.html"), (nom, None)], profondeur=1
            )

        self.page_liens(
            "index.html",
            {
                "titre": "Cours de PSI",
                "fil": [],
                "sections": [
                    {"titre": "Chapitres", "liens": chapitres_liens},
                    {"titre": "Travaux pratiques", "liens": tp_liens},
                ],
            },
            profondeur=0,
        )
        return self.produits

    def _chapitre(self, chapitre: Chapitre, dossier: str) -> None:
        titre = chapitre.titre(inline=True)
        base = [("Accueil", "../index.html"), (titre, "index.html")]
        documents, exercices = [], []

        if (chapitre.chemin / "cours.typ").is_file():
            self.page_contenu(
                f"{dossier}/cours.html",
                chapitre.chemin / "cours.typ",
                f"{titre} — cours",
                base + [("Cours", None)],
                profondeur=1,
            )
            documents.append({"texte": "Cours", "url": "cours.html"})

        for source, titre_exo in self.exercices(chapitre):
            fichier = f"{adresse(titre_exo)}.html"
            self.page_contenu(
                f"{dossier}/{fichier}",
                source,
                f"{titre_exo} — {titre}",
                base + [(titre_exo, None)],
                profondeur=1,
            )
            exercices.append({"texte": titre_exo, "url": fichier})

        self.page_liens(
            f"{dossier}/index.html",
            {
                "titre": titre,
                "fil": [["Accueil", "../index.html"], [titre, None]],
                "sections": [
                    {"titre": "", "liens": documents},
                    {"titre": "Exercices", "liens": exercices},
                ],
            },
            profondeur=1,
        )


def construit(sortie: Path | str = SORTIE) -> list[Path]:
    return Site(sortie).construit()
