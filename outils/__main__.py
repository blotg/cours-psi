"""Ligne de commande des outils : python3 -m outils <commande> [...]"""

import argparse
import sys
from datetime import date
from pathlib import Path


def _pour_chaque(dossiers, étapes) -> int:
    """Applique des étapes à chaque chapitre, en rapportant sans s'arrêter.

    Les étapes partagent le même objet `Chapitre`, donc la même requête
    `typst query` sur le cours : l'interroger coûte plus que tout le reste.
    """
    from .chapitre import Chapitre

    code = 0
    for dossier in dossiers:
        chapitre = Chapitre(dossier)
        for nom, produire in étapes:
            try:
                produits = produire(chapitre)
            except Exception as e:  # noqa: BLE001 - on rapporte et on continue
                print(f"  {nom:<13} {dossier} : {e}", file=sys.stderr)
                code = 1
                continue
            if not produits:
                print(f"  {nom:<13} {dossier} : rien à produire")
            for fichier in produits:
                print(f"  {nom:<13} {fichier}")
    return code


#: Les documents qu'un chapitre tire de son cours, hors compilation directe.
ÉTAPES = (
    ("DM", lambda c: c.DM()),
    ("flashcards", lambda c: [p for p in (c.flashcards(), c.flashcards_imprimables()) if p]),
    ("manipulations", lambda c: [c.liste_des_manipulations()]),
    ("imprimable", lambda c: [c.poly_imprimable()]),
)


def _étapes(*noms):
    return lambda args: _pour_chaque(args.chapitres, [e for e in ÉTAPES if e[0] in noms])


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

    p = sous.add_parser("build", help="tout ce qu'un chapitre tire de son cours")
    p.add_argument("chapitres", nargs="+", type=Path)
    p.set_defaults(fonction=_étapes("DM", "flashcards", "manipulations", "imprimable"))

    p = sous.add_parser("flashcards", help="paquet Anki et planche à découper")
    p.add_argument("chapitres", nargs="+", type=Path)
    p.set_defaults(fonction=_étapes("flashcards"))

    p = sous.add_parser("manipulations", help="liste des manipulations et du matériel")
    p.add_argument("chapitres", nargs="+", type=Path)
    p.set_defaults(fonction=_étapes("manipulations"))

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
