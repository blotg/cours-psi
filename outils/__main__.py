"""Ligne de commande des outils : python3 -m outils <commande> [...]"""

import argparse
import sys
from datetime import date
from pathlib import Path


def _flashcards(args) -> int:
    from .chapitre import Chapitre

    code = 0
    for dossier in args.chapitres:
        chapitre = Chapitre(dossier)
        try:
            fichier = chapitre.flashcards()
        except Exception as e:  # noqa: BLE001 - on rapporte et on continue
            print(f"  flashcards  {dossier} : {e}", file=sys.stderr)
            code = 1
            continue
        if fichier is None:
            print(f"  flashcards  {dossier} : aucune flashcard")
        else:
            print(f"  flashcards  {fichier}")
    return code


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


def _dm(args) -> int:
    from .chapitre import Chapitre

    code = 0
    for dossier in args.chapitres:
        try:
            for fichier in Chapitre(dossier).DM():
                print(f"  DM          {fichier}")
        except Exception as e:  # noqa: BLE001
            print(f"  DM          {dossier} : {e}", file=sys.stderr)
            code = 1
    return code


def _tp(args) -> int:
    from .tp import TP

    tp = TP(sujet=args.sujet, élèves=args.élèves, numéro=args.numéro)
    for binôme in tp.binômes():
        print(f"Copie {binôme.numéro_copie:02d} (groupe {binôme.groupe}) : {binôme}")
    print(f"\nSujet          : {tp.simple()}")
    print(f"Prêt à imprimer: {tp.génère()}")
    return 0


def _colles(args) -> int:
    from .chapitre import Chapitre
    from .programme_de_colle import génère

    chapitres = [Chapitre(d) for d in args.chapitres]
    print(génère(args.racine, date.fromisoformat(args.semaine), chapitres))
    return 0


def _qcm(args) -> int:
    from .qcm_cam import depuis_yaml

    for fichier in depuis_yaml(args.source, args.destination):
        print(fichier)
    return 0


def main(argv: list[str] | None = None) -> int:
    parseur = argparse.ArgumentParser(prog="python3 -m outils", description=__doc__)
    sous = parseur.add_subparsers(dest="commande", required=True)

    p = sous.add_parser("flashcards", help="paquet Anki d'un ou plusieurs chapitres")
    p.add_argument("chapitres", nargs="+", type=Path)
    p.set_defaults(fonction=_flashcards)

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
    p.set_defaults(fonction=_dm)

    p = sous.add_parser("tp", help="fascicules de TP personnalisés par binôme")
    p.add_argument("sujet", type=Path)
    p.add_argument("élèves", type=Path, help="CSV « Prénom, Nom, Groupe »")
    p.add_argument("--numéro", type=int, default=1, help="numéro du TP (graine du tirage)")
    p.set_defaults(fonction=_tp)

    p = sous.add_parser("colles", help="programme de colle de la semaine")
    p.add_argument("racine", type=Path, help="dossier où créer <AA.MM.JJ>/")
    p.add_argument("semaine", help="date du lundi, AAAA-MM-JJ")
    p.add_argument("chapitres", nargs="+", type=Path)
    p.set_defaults(fonction=_colles)

    p = sous.add_parser("qcm", help="questions QCMCam depuis un YAML")
    p.add_argument("source", type=Path)
    p.add_argument("destination", type=Path)
    p.set_defaults(fonction=_qcm)

    args = parseur.parse_args(argv)
    return args.fonction(args)


if __name__ == "__main__":
    sys.exit(main())
