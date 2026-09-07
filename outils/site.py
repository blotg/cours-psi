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

#: Les deux pages de second niveau, vers lesquelles l'accueil aiguille. Les TP
#: ont déjà leur dossier, l'index y prend donc sa place ; les chapitres, eux,
#: ont chacun le leur à la racine, et leur index reste une page.
CHAPITRES_INDEX = "chapitres.html"
TP_INDEX = "tp/index.html"

#: Ce qu'un chapitre offre au téléchargement : (type de document, extension,
#: intitulé du lien, mention de format). Les fichiers viennent de `build/`,
#: rempli par `outils build` (donc par le hook pre-commit) ; ceux qui manquent
#: sont simplement signalés et omis.
TÉLÉCHARGEMENTS = (
    ("poly", "pdf", "Poly du chapitre", "PDF"),
    ("flashcards", "pdf", "Flashcards à découper", "PDF"),
    ("flashcards", "apkg", "Flashcards pour Anki", "paquet Anki"),
)


#: Ce qu'un drapeau d'`exercice()` montre dans la liste : l'emoji que porte
#: déjà le titre de l'exercice, et sa glose pour l'infobulle. Même ordre que
#: dans le titre, pour qu'on retrouve la même chose des deux côtés.
DRAPEAUX_EXERCICE = (
    ("explique", "💬", "à expliquer avec des mots simples"),
    ("ouvert", "🤔", "problème ouvert"),
    ("numérique", "🖥️", "exercice numérique"),
)

#: L'étoile de difficulté, la même que `exercice()` imprime.
ÉTOILE = "★"


def adresse(texte: str) -> str:
    """Un nom de fichier sûr dans une URL, tiré d'un titre.

    « Étude de fonctions de transfert » donne « etude-de-fonctions-de-transfert ».
    """
    sans_accent = "".join(
        c for c in unicodedata.normalize("NFD", texte.lower()) if unicodedata.category(c) != "Mn"
    )
    return re.sub(r"-+", "-", re.sub(r"[^a-z0-9]+", "-", sans_accent)).strip("-") or "page"


def _poids(fichier: Path) -> str:
    """Le poids d'un fichier, en français et sans fausse précision."""
    octets = fichier.stat().st_size
    if octets >= 1024 * 1024:
        return f"{octets / 1048576:.1f}".replace(".", ",") + " Mo"
    return f"{max(1, round(octets / 1024))} ko"


def _pluriel(n: int, mot: str, pluriel: str | None = None) -> str:
    """« 27 chapitres », « 1 TP »."""
    return f"{n} {mot if n < 2 else (pluriel or mot + 's')}"


def _sans_préfixe(nom: str) -> str:
    """« 4 - Phénomènes de transport » donne « Phénomènes de transport »."""
    return re.sub(r"^\d+\s*-\s*", "", nom)


def _préfixe(nom: str) -> str:
    """Le numéro de classement d'un dossier, s'il en porte un."""
    trouvé = re.match(r"^(\d+)\s*-\s*", nom)
    return trouvé.group(1) if trouvé else ""


def _chaine(valeur: str) -> str:
    """Une chaîne littérale typst."""
    return '"' + valeur.replace("\\", "\\\\").replace('"', '\\"') + '"'


def _fil(entrées) -> str:
    """Le fil d'Ariane, en littéral typst : une suite de (texte, url ou none)."""
    morceaux = [f"({_chaine(t)}, {_chaine(u) if u else 'none'})" for t, u in entrées]
    # La virgule finale est indispensable : sans elle, typst lit un couple seul
    # comme une simple parenthèse et non comme un tableau d'une entrée.
    return "(" + ", ".join(morceaux) + ("," if morceaux else "") + ")"


def _arguments_exercice(texte: str) -> str:
    """Le texte des arguments de `#show: exercice.with(…)`.

    Un compteur de parenthèses, mais qui saute les chaines : un titre peut
    contenir une parenthèse, et le décompte naïf s'arrêtait dessus.
    """
    début = re.search(r"#show:\s*exercice\.with\(", texte)
    if not début:
        return ""
    i, profondeur, dans_chaine, échappe = début.end(), 1, False, False
    while i < len(texte) and profondeur:
        c = texte[i]
        if échappe:
            échappe = False
        elif dans_chaine:
            if c == "\\":
                échappe = True
            elif c == '"':
                dans_chaine = False
        elif c == '"':
            dans_chaine = True
        elif c == "(":
            profondeur += 1
        elif c == ")":
            profondeur -= 1
        i += 1
    return texte[début.end() : i - 1]


def _infos_exercice(source: Path) -> dict:
    """Titre, type et difficulté d'un exercice, lus dans sa source.

    De quoi afficher dans la liste ce que le titre de l'exercice montre déjà —
    l'emoji du type, les étoiles de difficulté — sans avoir à ouvrir la page.
    """
    arguments = _arguments_exercice(source.read_text(encoding="utf-8"))
    titre = re.search(r'titre:\s*"((?:[^"\\]|\\.)*)"', arguments)
    # Les drapeaux se cherchent hors des chaines : un titre qui contiendrait
    # « ouvert: » ne doit pas passer pour un problème ouvert.
    hors_chaines = re.sub(r'"(?:[^"\\]|\\.)*"', '""', arguments)
    difficulté = re.search(r"difficulté:\s*(\d+)", hors_chaines)

    emojis, gloses = "", []
    for nom, emoji, glose in DRAPEAUX_EXERCICE:
        if re.search(nom + r":\s*true", hors_chaines):
            emojis += emoji
            gloses.append(glose)
    étoiles = ÉTOILE * int(difficulté.group(1) if difficulté else 0)
    if étoiles:
        gloses.append(f"difficulté {len(étoiles)}")

    return {
        "titre": titre.group(1).replace('\\"', '"') if titre else source.stem,
        "détail": " ".join(x for x in (emojis, étoiles) if x),
        "infobulle": " · ".join(gloses),
    }


class Site:
    def __init__(self, sortie: Path | str = SORTIE):
        self.sortie = Path(sortie)
        self.produits: list[Path] = []
        self.absents: list[Path] = []

    # -- Une page ---------------------------------------------------------

    def _style(self, cible: Path, profondeur: int) -> None:
        """Accroche la feuille de style au <head> que typst vient d'écrire."""
        lien = "../" * profondeur + "styles.css"
        html = cible.read_text(encoding="utf-8")
        html = html.replace("</head>", f'<link rel="stylesheet" href="{lien}"></head>', 1)
        # typst écrit `lang="en"` en dur. La langue commande la coupure des mots
        # et le rendu de certains symboles : elle doit dire le vrai.
        html = html.replace('<html lang="en">', '<html lang="fr">', 1)
        cible.write_text(html, encoding="utf-8")
        self.produits.append(cible)

    def page_contenu(
        self,
        chemin: str,
        source: Path,
        titre: str,
        fil,
        profondeur: int,
        corrigés: bool = True,
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

    def fichier_joint(self, source: Path, dossier: str) -> str | None:
        """Recopie un document produit (poly, flashcards…) dans le site.

        Renvoie l'adresse relative au dossier du chapitre, ou None si le
        document n'a pas été construit.
        """
        if not source.is_file():
            self.absents.append(source)
            return None
        nom = adresse(source.stem) + source.suffix
        cible = self.sortie / dossier / nom
        cible.parent.mkdir(parents=True, exist_ok=True)
        copyfile(source, cible)
        self.produits.append(cible)
        return nom

    # -- Lecture des sources ----------------------------------------------

    @staticmethod
    def exercices(chapitre: Chapitre) -> list[tuple[Path, dict]]:
        """Les exercices d'un chapitre, dans l'ordre du TD, avec leurs infos.

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
                    trouvés.append((source, _infos_exercice(source)))
        return trouvés

    @staticmethod
    def rangement(chapitre: Chapitre) -> tuple[str, str, str]:
        """(thème, numéro dans le thème, titre propre) d'un chapitre.

        Le thème est le dossier de premier niveau sous `Cours/` : c'est le
        classement que le dépôt tient déjà. Un chapitre posé directement là
        — « 8 - Électrochimie » — est à lui seul son thème.

        Le titre d'un chapitre tient sur deux lignes dans infos.yml : le thème
        et son numéro d'abord, le titre propre ensuite. C'est le second qu'on
        affiche sous l'intitulé du thème, pour ne pas répéter celui-ci.
        """
        parties = chapitre.chemin.resolve().relative_to(RACINE / "Cours").parts
        thème = _sans_préfixe(parties[0])
        numéro = _préfixe(parties[1]) if len(parties) > 1 else ""
        lignes = [l.strip() for l in chapitre.titre().split("\n") if l.strip()]
        return thème, numéro, lignes[-1] if len(lignes) > 1 else lignes[0]

    # -- Construction ------------------------------------------------------

    def construit(self) -> list[Path]:
        self.sortie.mkdir(parents=True, exist_ok=True)
        copyfile(GABARITS / "site.css", self.sortie / "styles.css")
        self.produits.append(self.sortie / "styles.css")
        # Sans ce fichier, GitHub Pages fait passer le site par Jekyll, qui
        # ignore tout chemin commençant par un souligné et réécrit le reste.
        (self.sortie / ".nojekyll").write_text("", encoding="utf-8")

        # Un thème par section, dans l'ordre des dossiers — qui est celui du
        # programme. `dict` conserve l'ordre d'insertion.
        thèmes: dict[str, list[dict]] = {}
        for chapitre in chapitres(RACINE / "Cours"):
            dossier = adresse(chapitre.titre_court)
            thème, numéro, titre = self.rangement(chapitre)
            thèmes.setdefault(thème, []).append({
                "texte": titre,
                "url": f"{dossier}/index.html",
                "marque": numéro,
            })
            self._chapitre(chapitre, dossier)
        nombre_de_chapitres = sum(len(liens) for liens in thèmes.values())

        tp_liens = []
        for tp in sorted((RACINE / "TP").glob("*/TP.typ")):
            nom = _sans_préfixe(tp.parent.name)
            fichier = f"tp/{adresse(nom)}.html"
            tp_liens.append({"texte": nom, "url": fichier, "marque": _préfixe(tp.parent.name)})
            self.page_contenu(
                fichier,
                tp,
                nom,
                [("Accueil", "../index.html"), ("Travaux pratiques", "index.html"), (nom, None)],
                profondeur=1,
            )

        self.page_liens(
            CHAPITRES_INDEX,
            {
                "titre": "Chapitres",
                "fil": [["Accueil", "index.html"], ["Chapitres", None]],
                "sections": [_section(thème, liens) for thème, liens in thèmes.items()],
            },
            profondeur=0,
        )
        self.page_liens(
            TP_INDEX,
            {
                "titre": "Travaux pratiques",
                "fil": [["Accueil", "../index.html"], ["Travaux pratiques", None]],
                # Les liens des TP sont relatifs à la racine : sur leur propre
                # index, qui vit dans tp/, ils deviennent voisins.
                "sections": [{"titre": "", "liens": [
                    dict(l, url=l["url"].removeprefix("tp/")) for l in tp_liens
                ]}],
            },
            profondeur=1,
        )
        # L'accueil ne fait que départager les deux : le cours d'un côté, la
        # paillasse de l'autre. Le détail des chapitres tient sur sa page.
        self.page_liens(
            "index.html",
            {
                "titre": "Cours de PSI",
                "fil": [],
                "sections": [{"titre": "", "liens": [
                    {
                        "texte": "Chapitres",
                        "url": CHAPITRES_INDEX,
                        "détail": _pluriel(nombre_de_chapitres, "chapitre"),
                    },
                    {
                        "texte": "Travaux pratiques",
                        "url": TP_INDEX,
                        "détail": _pluriel(len(tp_liens), "TP", pluriel="TP"),
                    },
                ]}],
            },
            profondeur=0,
        )
        return self.produits

    def _chapitre(self, chapitre: Chapitre, dossier: str) -> None:
        titre = chapitre.titre(inline=True)
        base = [
            ("Accueil", "../index.html"),
            ("Chapitres", f"../{CHAPITRES_INDEX}"),
            (titre, "index.html"),
        ]
        documents, exercices = [], []

        if (chapitre.chemin / "cours.typ").is_file():
            self.page_contenu(
                f"{dossier}/cours.html",
                chapitre.chemin / "cours.typ",
                f"{titre} — cours",
                base + [("Cours", None)],
                profondeur=1,
            )
            documents.append({"texte": "Cours", "url": "cours.html", "détail": "à lire en ligne"})

        for type_de_document, extension, intitulé, mention in TÉLÉCHARGEMENTS:
            source = chapitre.fichier(type_de_document, extension)
            nom = self.fichier_joint(source, dossier)
            if nom:
                documents.append({
                    "texte": intitulé,
                    "url": nom,
                    "détail": f"{mention} · {_poids(source)}",
                })

        for source, infos in self.exercices(chapitre):
            fichier = f"{adresse(infos['titre'])}.html"
            self.page_contenu(
                f"{dossier}/{fichier}",
                source,
                f"{infos['titre']} — {titre}",
                base + [(infos["titre"], None)],
                profondeur=1,
            )
            exercices.append({
                "texte": infos["titre"],
                "url": fichier,
                # Le type et la difficulté, tels que le titre de l'exercice les
                # montre : on les lit dans la liste sans avoir à ouvrir la page.
                "détail": infos["détail"],
                "infobulle": infos["infobulle"],
            })

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


def _section(thème: str, liens: list[dict]) -> dict:
    """Une section de l'accueil : un thème et ses chapitres.

    Un thème qui tient en un seul chapitre du même nom — « Électrochimie » —
    n'a rien à lister : sa liste ne ferait que répéter son intitulé. Le titre
    de section devient alors le lien.
    """
    if len(liens) == 1 and liens[0]["texte"] == thème:
        return {"titre": thème, "url": liens[0]["url"]}
    return {"titre": thème, "liens": liens}


def construit(sortie: Path | str = SORTIE) -> list[Path]:
    site = Site(sortie)
    produits = site.construit()
    # Un document peut manquer pour deux raisons : le chapitre n'a jamais été
    # construit, ou il n'a rien à produire (Ondes 3 n'a aucune flashcard). On
    # signale sans prescrire : c'est `outils build` qui remplit `build/`.
    for absent in site.absents:
        print(f"  sans lien      {absent.parent.parent.name} : pas de « {absent.name} » dans build/")
    return produits
