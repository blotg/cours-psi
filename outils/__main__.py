"""Ligne de commande des outils : python3 -m outils <commande> [...]"""

import argparse
import sys
from datetime import date
from pathlib import Path


def _pour_chaque(dossiers, étapes, processus: int | None = None) -> int:
    """Applique des étapes à chaque chapitre, en rapportant sans s'arrêter.

    `étapes` donne, pour un chapitre, la liste des (nom, fonction) à lui
    appliquer : toutes ne valent pas pour tous (cf. `ÉTAPES_RÉVISION`).

    Les étapes d'un même chapitre restent en file : elles partagent son objet
    `Chapitre`, donc la même requête `typst query` sur le cours — l'interroger
    coûte plus que tout le reste. Les chapitres, eux, sont indépendants et
    passent de front : une modif sous prepa/ les remet tous sur la liste.
    """
    import os
    from concurrent.futures import ThreadPoolExecutor

    from .chapitre import Chapitre

    def un_chapitre(dossier):
        """Les sorties sont mises de côté : à plusieurs chapitres de front,
        les imprimer au fil de l'eau les entrelacerait."""
        chapitre = Chapitre(dossier)
        lignes, erreurs = [], []
        for nom, produire in étapes(chapitre):
            try:
                produits = produire(chapitre)
            except Exception as e:  # noqa: BLE001 - on rapporte et on continue
                erreurs.append(f"  {nom:<13} {dossier} : {e}")
                continue
            if not produits:
                lignes.append(f"  {nom:<13} {dossier} : rien à produire")
            lignes += [f"  {nom:<13} {fichier}" for fichier in produits]
        return lignes, erreurs

    dossiers = list(dossiers)
    fronts = max(1, processus or min(8, os.cpu_count() or 1))
    if fronts == 1 or len(dossiers) == 1:
        résultats = [un_chapitre(d) for d in dossiers]
    else:
        with ThreadPoolExecutor(max_workers=fronts) as pool:
            résultats = list(pool.map(un_chapitre, dossiers))

    code = 0
    for lignes, erreurs in résultats:
        for ligne in lignes:
            print(ligne)
        for erreur in erreurs:
            print(erreur, file=sys.stderr)
            code = 1
    return code


def _notebooks(chapitre) -> list:
    from .notebook import notebooks

    return notebooks(chapitre)


#: Les documents qu'un chapitre tire de son cours, hors compilation directe.
ÉTAPES = (
    ("DM", lambda c: c.DM()),
    ("flashcards", lambda c: [p for p in (c.flashcards(), c.flashcards_imprimables()) if p]),
    ("manipulations", lambda c: [c.liste_des_manipulations()]),
    ("diapo", lambda c: [p for p in (c.diapo(),) if p]),
    ("imprimable", lambda c: [c.poly_imprimable()]),
    ("notebooks", _notebooks),
)


#: Ce que `build` tire d'un chapitre de révision : ses flashcards, rien
#: d'autre. Il n'a ni DM, ni manipulation, ni question de début de cours, et
#: son poly se réduit à la page de garde — pas de quoi en faire un fascicule.
ÉTAPES_RÉVISION = ("flashcards",)


def _étapes(*noms):
    choisies = [e for e in ÉTAPES if e[0] in noms]
    return lambda args: _pour_chaque(
        args.chapitres,
        lambda chapitre: choisies,
        processus=getattr(args, "processus", None),
    )


def _build(args) -> int:
    """Tout ce qu'un chapitre tire de son cours — ses flashcards seules, pour
    un chapitre de révision. C'est ce qu'appelle le hook pre-commit."""
    return _pour_chaque(
        args.chapitres,
        lambda chapitre: [e for e in ÉTAPES if not chapitre.révision or e[0] in ÉTAPES_RÉVISION],
        processus=args.processus,
    )


def _imprimable(args) -> int:
    from .chapitre import Chapitre

    code = 0
    for dossier in args.chapitres:
        try:
            print(f"  imprimable  {Chapitre(dossier).poly_imprimable(quadrillage=args.quadrillage)}")
        except Exception as e:  # noqa: BLE001
            print(f"  imprimable  {dossier} : {e}", file=sys.stderr)
            code = 1
    return code


def _sujet_et_dossier(chemin: Path) -> tuple[Path, Path]:
    """Le fichier du sujet et le dossier du TP, qui porte le numéro.

    Le dossier du TP est accepté aussi bien que le « TP.typ » qu'il
    contient : les autres sous-commandes prennent des dossiers.

    `absolute` plutôt que `resolve` : lancé depuis le dossier du TP, le
    parent de « TP.typ » serait « . », sans nom ; et suivre un lien
    symbolique pourrait tomber sur un dossier autrement nommé.
    """
    if chemin.is_dir():
        return chemin / "TP.typ", chemin.absolute()
    return chemin, chemin.absolute().parent


def _numéro_du_dossier(dossier: Path) -> int | None:
    """« TP/12 - Filtre de Wien » donne 12 ; None sans nombre en tête."""
    import re

    trouvé = re.match(r"\d+", dossier.name)
    return int(trouvé.group()) if trouvé else None


def _tp(args) -> int:
    from .tp import TP

    sujet, dossier = _sujet_et_dossier(args.sujet)
    # Les binômes ne tiennent qu'au CSV et au numéro : les afficher n'exige pas
    # que le sujet soit écrit, seulement que son dossier porte le bon numéro.
    if not sujet.is_file() and not args.binômes:
        print(f"  tp  {sujet} : sujet introuvable", file=sys.stderr)
        return 2
    numéro = args.numéro if args.numéro is not None else _numéro_du_dossier(dossier)
    if numéro is None:
        print(
            f"  tp  {dossier.name} : ce dossier ne commence pas par un nombre, "
            "passer --numéro",
            file=sys.stderr,
        )
        return 2
    tp = TP(sujet=sujet, élèves=args.élèves, numéro=numéro)
    for binôme in tp.binômes():
        print(f"Copie {binôme.numéro_copie:02d} (groupe {binôme.groupe}) : {binôme}")
    if args.binômes:
        return 0
    print(f"\nSujet          : {tp.simple()}")
    print(f"Prêt à imprimer: {tp.génère()}")
    return 0


def _colles(args) -> int:
    from .chapitre import Chapitre
    from .programme_de_colle import génère

    chapitres = [Chapitre(d) for d in args.chapitres]
    print(génère(args.racine, date.fromisoformat(args.semaine), chapitres))
    return 0


def _questions_de_colle(args) -> int:
    from .chapitre import RACINE_COURS, RACINE_RÉVISIONS, Chapitre
    from .questions_de_colle import SORTIE, SORTIE_RÉVISIONS, génère

    racine, sortie = (RACINE_RÉVISIONS, SORTIE_RÉVISIONS) if args.révisions else (RACINE_COURS, SORTIE)
    # Sans chapitre nommé, tous ceux du dossier : c'est l'usage courant, le
    # document n'ayant d'intérêt que complet.
    liste = [Chapitre(d) for d in args.chapitres] if args.chapitres else None
    print(f"  questions     {génère(args.sortie or sortie, racine=racine, liste=liste)}")
    return 0


def _site(args) -> int:
    from .site import construit

    from .site import PROCESSUS

    for fichier in construit(args.sortie, processus=args.processus or PROCESSUS):
        if args.verbeux:
            print(f"  {fichier}")
    return 0


def _cibles_capytale(chemins: list[Path]) -> list[tuple[Path, list[Path] | None]]:
    """(chapitre, exercices) pour chaque chemin donné.

    Un dossier est un chapitre, dont on prend tous les exercices numériques
    du TD (None) ; un fichier est un exercice, pris tel quel, même hors TD :
    on l'a nommé.
    """
    cibles: dict[Path, list[Path] | None] = {}
    for chemin in chemins:
        if chemin.is_dir():
            cibles[chemin] = None
        else:
            # <chapitre>/exercices/<exercice>.typ
            chapitre = chemin.parent.parent
            if cibles.get(chapitre, []) is not None:
                cibles.setdefault(chapitre, []).append(chemin)
    return list(cibles.items())


def _capytale(args) -> int:
    import traceback
    from concurrent.futures import ThreadPoolExecutor

    from . import notebook
    from .capytale import Capytale, ErreurCapytale, envoie_chapitre
    from .chapitre import Chapitre

    capytale = Capytale(simulation=args.simulation, indexer=args.indexer)

    def un(cible):
        dossier, exercices = cible
        chapitre = Chapitre(dossier)
        try:
            if not args.depuis_build:
                for exercice in exercices if exercices is not None else notebook.exercices(chapitre):
                    notebook.écrit(chapitre, exercice)
            return [f"  capytale      {ligne}" for ligne in envoie_chapitre(capytale, chapitre, exercices)], []
        except (ErreurCapytale, notebook.ErreurNotebook) as e:
            return [], [f"  capytale      {dossier} : {e}"]
        except Exception:  # noqa: BLE001 - imprévue : toute la trace, pour savoir d'où
            return [], [f"  capytale      {dossier} :\n{traceback.format_exc()}"]

    with ThreadPoolExecutor(max_workers=args.processus or 4) as pool:
        résultats = list(pool.map(un, _cibles_capytale(args.chemins)))
    code = 0
    for lignes, erreurs in résultats:
        for ligne in lignes:
            print(ligne)
        for erreur in erreurs:
            print(erreur, file=sys.stderr)
            code = 1
    return code


def _qcm(args) -> int:
    from .qcm_cam import depuis_yaml

    for fichier in depuis_yaml(args.source, args.destination):
        print(fichier)
    return 0


def _option_processus(p) -> None:
    """Le nombre de chapitres (ou de pages) menés de front.

    Le défaut se résout à l'exécution, pas ici : les imports de ce fichier
    restent paresseux pour que la CLI démarre vite.
    """
    p.add_argument(
        "--processus",
        type=int,
        help="travaux menés de front (défaut : 8, ou le nombre de cœurs)",
    )


def main(argv: list[str] | None = None) -> int:
    parseur = argparse.ArgumentParser(prog="python3 -m outils", description=__doc__)
    sous = parseur.add_subparsers(dest="commande", required=True)

    p = sous.add_parser("build", help="tout ce qu'un chapitre tire de son cours")
    p.add_argument("chapitres", nargs="+", type=Path)
    _option_processus(p)
    p.set_defaults(fonction=_build)

    p = sous.add_parser("flashcards", help="paquet Anki et planche à découper")
    p.add_argument("chapitres", nargs="+", type=Path)
    p.set_defaults(fonction=_étapes("flashcards"))

    p = sous.add_parser("manipulations", help="liste des manipulations et du matériel")
    p.add_argument("chapitres", nargs="+", type=Path)
    p.set_defaults(fonction=_étapes("manipulations"))

    p = sous.add_parser("diapo", help="diaporama des questions de début de cours")
    p.add_argument("chapitres", nargs="+", type=Path)
    p.set_defaults(fonction=_étapes("diapo"))

    p = sous.add_parser("notebooks", help="notebooks Jupyter des exercices numériques du TD")
    p.add_argument("chapitres", nargs="+", type=Path)
    p.set_defaults(fonction=_étapes("notebooks"))

    p = sous.add_parser(
        "capytale",
        help="notebooks des exercices numériques, créés ou mis à jour sur Capytale",
    )
    p.add_argument(
        "chemins",
        nargs="+",
        type=Path,
        help="chapitres (tous les exercices numériques de leur TD) ou fichiers d'exercices",
    )
    p.add_argument(
        "-n",
        "--simulation",
        action="store_true",
        help="dire ce qui serait envoyé, sans rien envoyer ni écrire",
    )
    p.add_argument(
        "--indexer",
        action="store_true",
        help="ajouter à l'index de git un exercice dont on vient d'écrire le code (hook pre-commit)",
    )
    p.add_argument(
        "--depuis-build",
        action="store_true",
        help="envoyer les notebooks déjà dans build/, sans les refaire",
    )
    _option_processus(p)
    p.set_defaults(fonction=_capytale)

    p = sous.add_parser("imprimable", help="poly en fascicule A3, prêt à imprimer")
    p.add_argument("chapitres", nargs="+", type=Path)
    p.add_argument(
        "--quadrillage",
        action="store_true",
        help="au lieu du fascicule : poly A4 avec une page quadrillée "
        "en regard de chaque page de cours",
    )
    p.set_defaults(fonction=_imprimable)

    p = sous.add_parser("dm", help="copie les DM et leurs corrigés dans build/")
    p.add_argument("chapitres", nargs="+", type=Path)
    p.set_defaults(fonction=_étapes("DM"))

    p = sous.add_parser("tp", help="fascicules de TP personnalisés par binôme")
    p.add_argument("sujet", type=Path, help="le « TP.typ », ou le dossier qui le contient")
    p.add_argument("élèves", type=Path, help="CSV « Prénom, Nom, Groupe »")
    p.add_argument(
        "--numéro",
        type=int,
        help="numéro du TP, graine du tirage (défaut : le nombre qui ouvre le nom du dossier du sujet)",
    )
    p.add_argument(
        "-b",
        "--binômes",
        action="store_true",
        help="afficher les binômes tirés au sort, sans compiler de document",
    )
    p.set_defaults(fonction=_tp)

    p = sous.add_parser("colles", help="programme de colle de la semaine")
    p.add_argument("racine", type=Path, help="dossier où créer <AA.MM.JJ>/")
    p.add_argument("semaine", help="date du lundi, AAAA-MM-JJ")
    p.add_argument("chapitres", nargs="+", type=Path)
    p.set_defaults(fonction=_colles)

    p = sous.add_parser(
        "questions-de-colle",
        help="toutes les questions de colle de l'année, en un document",
    )
    p.add_argument(
        "chapitres",
        nargs="*",
        type=Path,
        help="à défaut, tous les chapitres de Cours/, ou de révisions/ avec -r "
        "(ordre lexicographique)",
    )
    p.add_argument(
        "-r",
        "--révisions",
        action="store_true",
        help="les révisions de PCSI plutôt que Cours/ "
        "(sortie : « révisions/build/questions de colle.pdf »)",
    )
    p.add_argument(
        "--sortie",
        type=Path,
        help="PDF produit (défaut : « Cours/build/questions de colle.pdf »)",
    )
    p.set_defaults(fonction=_questions_de_colle)

    p = sous.add_parser("site", help="site statique du cours (HTML)")
    p.add_argument("--sortie", type=Path, default=Path("site"))
    _option_processus(p)
    p.add_argument("-v", "--verbeux", action="store_true", help="lister chaque fichier produit")
    p.set_defaults(fonction=_site)

    p = sous.add_parser("qcm", help="questions QCMCam depuis un YAML")
    p.add_argument("source", type=Path)
    p.add_argument("destination", type=Path)
    p.set_defaults(fonction=_qcm)

    args = parseur.parse_args(argv)
    return args.fonction(args)


if __name__ == "__main__":
    sys.exit(main())
