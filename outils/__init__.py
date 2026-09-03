"""Outils de production des documents du cours de PSI.

Tout part des sources typst d'un chapitre ; tout ce qui est produit atterrit
dans son sous-dossier ``build/`` (ignoré par git).

    from outils.chapitre import Chapitre
    Chapitre("Cours/8 - Électrochimie").flashcards()

En ligne de commande :  python3 -m outils --aide
"""
