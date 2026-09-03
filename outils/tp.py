"""Génération des fascicules de TP personnalisés, prêts à imprimer.

À partir d'un sujet de TP écrit en Typst (fonction ``TP`` du paquet
``@local/prepa``) et d'une liste d'élèves au format CSV (colonnes
« Prénom, Nom, Groupe »), ce module :

- forme des binômes **aléatoires mais déterministes** (la graine est le numéro
  du TP) au sein de chaque groupe ; un élève peut rester seul si son groupe est
  en effectif impair ;
- compile le sujet pour chaque élève en lui passant les entrées Typst
  ``élève``, ``numéro-copie`` et, si l'élève n'est pas seul, ``binôme`` ;
- impose chaque sujet A4 en fascicule (« booklet ») sur des feuilles A3 ;
- concatène tous les fascicules en un unique PDF prêt pour une impression
  recto-verso, en complétant si besoin par des pages blanches.

Voir :class:`TP` pour le point d'entrée.
"""

from dataclasses import dataclass
from os import makedirs
from os.path import dirname, join
from tempfile import TemporaryDirectory

from .chapitre import SORTIE
from .typst import compile_fichier


@dataclass
class Élève:
    prénom: str
    nom: str
    groupe: str

    @property
    def nom_complet(self) -> str:
        return f"{self.prénom} {self.nom}".strip()

    def __str__(self) -> str:
        return self.nom_complet


@dataclass
class Binôme:
    """Une équipe d'un ou deux élèves, identifiée par son numéro de copie.

    Les deux membres d'un binôme partagent le même ``numéro_copie`` : ils
    reçoivent donc la même variante du sujet (même bloc d'évaluation tiré au
    sort), seul le nom affiché en tête de copie change.
    """

    membres: list[Élève]
    numéro_copie: int

    @property
    def seul(self) -> bool:
        return len(self.membres) == 1

    @property
    def groupe(self) -> str:
        return self.membres[0].groupe

    def coéquipier(self, élève: Élève) -> Élève | None:
        for membre in self.membres:
            if membre is not élève:
                return membre
        return None

    def __str__(self) -> str:
        return " & ".join(m.nom_complet for m in self.membres)


def _clé_groupe(groupe: str):
    """Tri « naturel » des groupes : numérique si possible, alphabétique sinon."""
    return (0, int(groupe)) if groupe.strip().isdigit() else (1, groupe)


class TP:
    def __init__(self, sujet: str, élèves: str, numéro: int = 1):
        """
        Args:
            sujet: chemin du fichier ``.typ`` du sujet de TP.
            élèves: chemin du fichier ``.csv`` des élèves (« Prénom, Nom, Groupe »).
            numéro: numéro du TP. Sert de titre de document *et* de graine pour
                le tirage au sort des binômes (tirage reproductible).
        """
        self.sujet = sujet
        self.chemin_élèves = élèves
        self.numéro = numéro

    # -- Élèves et binômes ---------------------------------------------------

    def élèves(self) -> list[Élève]:
        if not hasattr(self, "_élèves"):
            from csv import DictReader

            with open(self.chemin_élèves, newline="", encoding="utf-8") as f:
                lignes = DictReader(f, skipinitialspace=True)
                self._élèves = [
                    Élève(l["Prénom"].strip(), l["Nom"].strip(), str(l["Groupe"]).strip())
                    for l in lignes
                    if l.get("Prénom", "").strip()
                ]
        return self._élèves

    def groupes(self) -> dict[str, list[Élève]]:
        """Élèves regroupés par groupe, dans l'ordre du fichier CSV."""
        groupes: dict[str, list[Élève]] = {}
        for élève in self.élèves():
            groupes.setdefault(élève.groupe, []).append(élève)
        return groupes

    def binômes(self) -> list[Binôme]:
        """Binômes tirés au sort, de façon déterministe (graine = ``numéro``).

        Les groupes sont traités dans l'ordre naturel de leur nom. Le
        ``numéro_copie`` est attribué séquentiellement (0, 1, 2, …) sur
        l'ensemble des binômes ainsi formés, élève seul compris.
        """
        if not hasattr(self, "_binômes"):
            from random import Random

            tirage = Random(self.numéro)
            équipes: list[list[Élève]] = []
            for groupe in sorted(self.groupes(), key=_clé_groupe):
                membres = list(self.groupes()[groupe])
                tirage.shuffle(membres)
                for i in range(0, len(membres) - 1, 2):
                    équipes.append([membres[i], membres[i + 1]])
                if len(membres) % 2:
                    équipes.append([membres[-1]])
            self._binômes = [Binôme(m, i) for i, m in enumerate(équipes)]
        return self._binômes

    # -- Compilation et impression ----------------------------------------

    def simple(self, destination: str | None = None) -> str:
        """Compile le sujet sans personnalisation (ni ``élève`` ni ``numéro-copie``).

        C'est le PDF « de référence » du sujet. Par défaut il est écrit dans
        ``build/TP.pdf``, à côté des autres documents produits.
        """
        if destination is None:
            destination = join(dirname(self.sujet), SORTIE, "TP.pdf")
        compile_fichier(self.sujet, destination)
        return destination

    def compile_élève(self, binôme: Binôme, élève: Élève, destination: str) -> str:
        """Compile le sujet A4 personnalisé pour un élève d'un binôme."""
        entrées = {"élève": élève.nom_complet, "numéro-copie": binôme.numéro_copie}
        coéquipier = binôme.coéquipier(élève)
        if coéquipier is not None:
            entrées["binôme"] = coéquipier.nom_complet
        compile_fichier(self.sujet, destination, entrées=entrées)
        return destination

    def génère(self, destination: str | None = None) -> str:
        """Produit le PDF complet prêt à imprimer et renvoie son chemin.

        Args:
            destination: chemin du PDF final. Par défaut,
                ``<dossier du sujet>/build/TP - à imprimer.pdf``.

        Les fascicules individuels (A4 et A3) sont produits dans un dossier
        temporaire, supprimé en fin de traitement : seul le PDF final est
        écrit sur disque.
        """
        from pypdf import PdfReader, PdfWriter

        if destination is None:
            destination = join(dirname(self.sujet), SORTIE, "TP - à imprimer.pdf")

        final = PdfWriter()
        with TemporaryDirectory() as dossier:
            for binôme in self.binômes():
                for élève in binôme.membres:
                    nom = f"{binôme.numéro_copie:02d} - {élève.nom_complet}"
                    a4 = join(dossier, f"{nom} - A4.pdf")
                    a3 = join(dossier, f"{nom} - fascicule A3.pdf")

                    self.compile_élève(binôme, élève, a4)
                    fascicule(a4, a3)

                    faces = PdfReader(a3)
                    final.append(faces)
                    # Chaque fascicule compte un nombre pair de faces (2 par
                    # feuille A3) : chaque copie démarre donc sur une nouvelle
                    # feuille en recto-verso. Garde-fou au cas où :
                    if len(faces.pages) % 2:
                        boite = faces.pages[0].mediabox
                        final.add_blank_page(width=float(boite.width), height=float(boite.height))

        makedirs(dirname(destination) or ".", exist_ok=True)
        with open(destination, "wb") as f:
            final.write(f)
        return destination


def fascicule(source: str, destination: str) -> str:
    """Impose un PDF A4 portrait en fascicule sur des feuilles A3 paysage.

    Le nombre de pages du sujet est complété à un multiple de 4 par des pages
    blanches. Le PDF produit contient une face de feuille par page (recto puis
    verso de la feuille 1, recto puis verso de la feuille 2, …). Il est prêt
    pour une impression **recto-verso, retournement sur le bord court**, puis
    pliage au centre : les pages se lisent alors dans l'ordre 1, 2, 3, …
    """
    from pypdf import PdfReader, PdfWriter, Transformation

    lecteur = PdfReader(source)
    n = len(lecteur.pages)
    total = n + (-n) % 4  # arrondi au multiple de 4 supérieur

    gabarit = lecteur.pages[0]
    largeur = float(gabarit.mediabox.width)
    hauteur = float(gabarit.mediabox.height)

    def page(indice: int):
        """Page 1-indexée du sujet, ou ``None`` pour une page blanche."""
        if not 1 <= indice <= n:
            return None
        p = lecteur.pages[indice - 1]
        p.pop("/Annots", None)  # liens inutiles sur papier, et mal reportés à l'échelle
        return p

    écrivain = PdfWriter()
    for feuille in range(total // 4):
        recto = (total - 2 * feuille, 2 * feuille + 1)
        verso = (2 * feuille + 2, total - 2 * feuille - 1)
        for gauche, droite in (recto, verso):
            a3 = écrivain.add_blank_page(width=2 * largeur, height=hauteur)
            for décalage, indice in ((0.0, gauche), (largeur, droite)):
                p = page(indice)
                if p is None:
                    continue
                a3.merge_transformed_page(
                    p,
                    Transformation().translate(
                        décalage - float(p.mediabox.left), -float(p.mediabox.bottom)
                    ),
                )

    makedirs(dirname(destination) or ".", exist_ok=True)
    with open(destination, "wb") as f:
        écrivain.write(f)
    return destination
