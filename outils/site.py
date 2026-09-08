"""Site statique du cours, produit par `typst compile --format html`.

Une page par document : l'accueil, un sommaire et un cours par chapitre, une
page par exercice, une page par TP. Rien n'est réécrit en HTML à la main — les
pages de contenu sont les sources typst du cours compilées vers une autre
cible, les pages de liens viennent du gabarit `gabarits/site-liens.typ`.

Le seul post-traitement est l'insertion, dans le `<head>` que typst produit, du
lien vers la feuille de style : typst n'expose pas encore ce `<head>`.
"""

import hashlib
import json
import os
import re
import unicodedata
from concurrent.futures import ThreadPoolExecutor
from functools import partial
from pathlib import Path
from shutil import copyfile
from tempfile import TemporaryDirectory
from threading import Lock

from . import typst
from .chapitre import GABARITS, Chapitre, chapitres

#: Dossier produit, ignoré par git (cf. .gitignore) et publié par le hook pre-push.
SORTIE = "site"

#: Où l'on note ce qui a servi à fabriquer chaque page, pour ne recompiler que
#: ce qui a bougé. Hors de `site/`, qui part en entier sur gh-pages.
MANIFESTE = ".site-manifeste.json"

#: À changer dès que la fabrication d'une page change autrement que par ses
#: sources — la retouche du <head> dans `_style`, par exemple. Tout le site se
#: reconstruit alors, au lieu de garder des pages fabriquées à l'ancienne.
FORMAT_MANIFESTE = 1

#: Compilations menées de front. Une page ne tient pas douze cœurs occupés,
#: mais le gain plafonne vers huit : au-delà on ne fait que se marcher dessus.
PROCESSUS = min(8, os.cpu_count() or 1)

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


def _empreinte(chemin: str) -> list | None:
    """Taille et date d'un fichier — de quoi voir qu'il a bougé, sans le lire.

    Une page compte deux cents dépendances (les paquets typst surtout) : les
    hacher toutes coûterait plus cher que de recompiler.
    """
    try:
        état = os.stat(chemin)
    except OSError:
        return None
    return [état.st_size, état.st_mtime_ns]


def _condensé(*morceaux: str) -> str:
    """Le condensé d'une recette de page, pour la comparer d'une fois sur l'autre."""
    h = hashlib.sha256()
    h.update(str(FORMAT_MANIFESTE).encode())
    for m in morceaux:
        h.update(b"\x00")
        h.update(m.encode("utf-8"))
    return h.hexdigest()


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
    def __init__(self, sortie: Path | str = SORTIE, processus: int = PROCESSUS):
        self.sortie = Path(sortie)
        self.processus = max(1, processus)
        self.produits: list[Path] = []
        self.absents: list[Path] = []
        self.effacés: list[Path] = []
        self.recompilées = 0
        self._verrou = Lock()
        self._manifeste: dict[str, dict] = {}
        self._nouveau_manifeste: dict[str, dict] = {}

    # -- Ne refaire que ce qui a bougé -------------------------------------

    @property
    def _fichier_manifeste(self) -> Path:
        return self.sortie.parent / MANIFESTE

    def _charge_manifeste(self) -> None:
        try:
            self._manifeste = json.loads(self._fichier_manifeste.read_text(encoding="utf-8"))
        except (OSError, ValueError):
            self._manifeste = {}

    def _écrit_manifeste(self) -> None:
        self._fichier_manifeste.write_text(
            json.dumps(self._nouveau_manifeste, ensure_ascii=False), encoding="utf-8"
        )

    def _à_jour(self, chemin: str, recette: str) -> bool:
        """La page est-elle encore bonne ? Recette et dépendances inchangées."""
        note = self._manifeste.get(chemin)
        if note is None or note.get("recette") != recette:
            return False
        if not (self.sortie / chemin).is_file():
            return False
        return all(_empreinte(d) == e for d, e in note.get("deps", {}).items())

    def _note(self, chemin: str, recette: str, dépendances: list[str] | None) -> None:
        """Consigne ce qui a servi à la page — ou reprend la note d'avant."""
        if dépendances is None:
            note = self._manifeste.get(chemin, {"recette": recette, "deps": {}})
        else:
            # `<stdin>` n'est pas un fichier : la recette en tient déjà lieu.
            note = {
                "recette": recette,
                "deps": {d: _empreinte(d) for d in dépendances if d != "<stdin>"},
            }
        with self._verrou:
            self._nouveau_manifeste[chemin] = note

    def _retient(self, cible: Path) -> None:
        with self._verrou:
            self.produits.append(cible)

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
        recette = (
            f'#import "/gabarits/site.typ": *\n'
            f"#show: page-site.with(\n"
            f"    titre: {_chaine(titre)},\n"
            f"    fil: {_fil(fil)},\n"
            f"    corrigés: {'true' if corrigés else 'false'},\n"
            f")\n"
            f"#include {_chaine(inclus)}\n"
        )
        return self._page(chemin, profondeur, recette, lambda cible, deps: typst.compile_source(
            recette, cible, html=True, racine=RACINE, dépendances=deps
        ))

    def page_liens(self, chemin: str, données: dict, profondeur: int) -> Path:
        """Une page qui n'est qu'un titre et des listes de liens."""
        entrée = json.dumps(données, ensure_ascii=False)
        return self._page(chemin, profondeur, entrée, lambda cible, deps: typst.compile_fichier(
            GABARITS / "site-liens.typ",
            cible,
            entrées={"données": entrée},
            html=True,
            dépendances=deps,
        ))

    def _page(self, chemin: str, profondeur: int, recette: str, compile) -> Path:
        """Fabrique une page, sauf si elle est encore bonne.

        `recette` est ce qui la décrit hors fichiers — la source typst montée
        pour l'occasion, ou le JSON passé en `--input`. Les fichiers, eux, sont
        ceux que typst déclare avec `--make-deps`.
        """
        cible = self.sortie / chemin
        empreinte = _condensé(str(profondeur), recette)
        if self._à_jour(chemin, empreinte):
            self._note(chemin, empreinte, None)
            self._retient(cible)
            return cible
        # Le fichier de dépendances est jetable : il ne sert qu'ici, et il ne
        # doit surtout pas atterrir dans site/, qui part en entier sur gh-pages.
        with TemporaryDirectory() as tampon:
            deps = Path(tampon) / "deps.mk"
            compile(cible, deps)
            dépendances = typst.lit_dépendances(deps)
        self._style(cible, profondeur)
        self._note(chemin, empreinte, dépendances)
        self._retient(cible)
        with self._verrou:
            self.recompilées += 1
        return cible

    def _copie(self, source: Path, cible: Path) -> None:
        """Recopie un fichier, sauf s'il est déjà là, identique.

        Le dépôt est sur un partage réseau : recopier trente Mo de PDF à chaque
        construction se paie, alors que rien n'a bougé la plupart du temps.
        """
        cible.parent.mkdir(parents=True, exist_ok=True)
        if not cible.is_file() or _empreinte(str(source)) != self._manifeste.get(
            "@joints", {}
        ).get(str(cible)):
            copyfile(source, cible)
        with self._verrou:
            self._nouveau_manifeste.setdefault("@joints", {})[str(cible)] = _empreinte(str(source))
        self._retient(cible)

    def fichier_joint(self, source: Path, dossier: str) -> str | None:
        """Recopie un document produit (poly, flashcards…) dans le site.

        Renvoie l'adresse relative au dossier du chapitre, ou None si le
        document n'a pas été construit.
        """
        if not source.is_file():
            self.absents.append(source)
            return None
        nom = adresse(source.stem) + source.suffix
        self._copie(source, self.sortie / dossier / nom)
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

    def _exécute(self, tâches: list) -> None:
        """Mène les compilations de front — elles sont indépendantes.

        Une exception dans une tâche remonte ici : une page qui ne compile pas
        doit faire échouer la construction, pas passer inaperçue.
        """
        if self.processus == 1:
            for tâche in tâches:
                tâche()
            return
        with ThreadPoolExecutor(max_workers=self.processus) as pool:
            list(pool.map(lambda t: t(), tâches))

    def _nettoie(self) -> list[Path]:
        """Efface de site/ ce que cette construction n'a pas produit.

        Un exercice retiré du TD, un chapitre renommé : sans ce ménage leur
        page resterait publiée indéfiniment. La construction n'écrit plus tout
        à chaque fois, elle ne peut donc plus compter sur l'écrasement.
        """
        gardés = {p.resolve() for p in self.produits}
        effacés = []
        # Du plus profond vers la racine, pour qu'un dossier vidé se voie vide.
        for chemin in sorted(self.sortie.rglob("*"), key=lambda p: len(p.parts), reverse=True):
            if chemin.is_file() and chemin.resolve() not in gardés:
                chemin.unlink()
                effacés.append(chemin)
            elif chemin.is_dir() and not any(chemin.iterdir()):
                chemin.rmdir()
        return effacés

    def construit(self) -> list[Path]:
        self.sortie.mkdir(parents=True, exist_ok=True)
        self._charge_manifeste()
        self._copie(GABARITS / "site.css", self.sortie / "styles.css")
        # Sans ce fichier, GitHub Pages fait passer le site par Jekyll, qui
        # ignore tout chemin commençant par un souligné et réécrit le reste.
        nojekyll = self.sortie / ".nojekyll"
        if not nojekyll.is_file():
            nojekyll.write_text("", encoding="utf-8")
        self._retient(nojekyll)

        # Rien ne se compile dans cette phase : on ne fait que dresser la liste
        # des pages à fabriquer, pour les mener ensuite toutes de front.
        tâches: list = []

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
            tâches += self._chapitre(chapitre, dossier)
        nombre_de_chapitres = sum(len(liens) for liens in thèmes.values())

        tp_liens = []
        for tp in sorted((RACINE / "TP").glob("*/TP.typ")):
            nom = _sans_préfixe(tp.parent.name)
            fichier = f"tp/{adresse(nom)}.html"
            tp_liens.append({"texte": nom, "url": fichier, "marque": _préfixe(tp.parent.name)})
            tâches.append(partial(
                self.page_contenu,
                fichier,
                tp,
                nom,
                [("Accueil", "../index.html"), ("Travaux pratiques", "index.html"), (nom, None)],
                profondeur=1,
            ))

        tâches.append(partial(
            self.page_liens,
            CHAPITRES_INDEX,
            {
                "titre": "Chapitres",
                "fil": [["Accueil", "index.html"], ["Chapitres", None]],
                "sections": [_section(thème, liens) for thème, liens in thèmes.items()],
            },
            profondeur=0,
        ))
        tâches.append(partial(
            self.page_liens,
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
        ))
        # L'accueil ne fait que départager les deux : le cours d'un côté, la
        # paillasse de l'autre. Le détail des chapitres tient sur sa page.
        tâches.append(partial(
            self.page_liens,
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
        ))

        self._exécute(tâches)
        self.effacés = self._nettoie()
        self._écrit_manifeste()
        return self.produits

    def _chapitre(self, chapitre: Chapitre, dossier: str) -> list:
        titre = chapitre.titre(inline=True)
        base = [
            ("Accueil", "../index.html"),
            ("Chapitres", f"../{CHAPITRES_INDEX}"),
            (titre, "index.html"),
        ]
        tâches: list = []
        documents, exercices = [], []

        if (chapitre.chemin / "cours.typ").is_file():
            tâches.append(partial(
                self.page_contenu,
                f"{dossier}/cours.html",
                chapitre.chemin / "cours.typ",
                f"{titre} — cours",
                base + [("Cours", None)],
                profondeur=1,
            ))
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
            tâches.append(partial(
                self.page_contenu,
                f"{dossier}/{fichier}",
                source,
                f"{infos['titre']} — {titre}",
                base + [(infos["titre"], None)],
                profondeur=1,
            ))
            exercices.append({
                "texte": infos["titre"],
                "url": fichier,
                # Le type et la difficulté, tels que le titre de l'exercice les
                # montre : on les lit dans la liste sans avoir à ouvrir la page.
                "détail": infos["détail"],
                "infobulle": infos["infobulle"],
            })

        tâches.append(partial(
            self.page_liens,
            f"{dossier}/index.html",
            {
                "titre": titre,
                "fil": [
                    ["Accueil", "../index.html"],
                    ["Chapitres", f"../{CHAPITRES_INDEX}"],
                    [titre, None],
                ],
                "sections": [
                    {"titre": "", "liens": documents},
                    {"titre": "Exercices", "liens": exercices},
                ],
            },
            profondeur=1,
        ))
        return tâches


def _section(thème: str, liens: list[dict]) -> dict:
    """Une section de l'accueil : un thème et ses chapitres.

    Un thème qui tient en un seul chapitre du même nom — « Électrochimie » —
    n'a rien à lister : sa liste ne ferait que répéter son intitulé. Le titre
    de section devient alors le lien.
    """
    if len(liens) == 1 and liens[0]["texte"] == thème:
        return {"titre": thème, "url": liens[0]["url"]}
    return {"titre": thème, "liens": liens}


def construit(sortie: Path | str = SORTIE, processus: int = PROCESSUS) -> list[Path]:
    site = Site(sortie, processus=processus)
    produits = site.construit()
    # Un document peut manquer pour deux raisons : le chapitre n'a jamais été
    # construit, ou il n'a rien à produire (Ondes 3 n'a aucune flashcard). On
    # signale sans prescrire : c'est `outils build` qui remplit `build/`.
    for absent in site.absents:
        print(f"  sans lien      {absent.parent.parent.name} : pas de « {absent.name} » dans build/")
    for effacé in site.effacés:
        print(f"  retiré         {effacé}")
    pages = sum(1 for p in produits if p.suffix == ".html")
    print(
        f"  {site.recompilées} page(s) recompilée(s) sur {pages}, "
        f"{site.processus} de front"
    )
    return produits
