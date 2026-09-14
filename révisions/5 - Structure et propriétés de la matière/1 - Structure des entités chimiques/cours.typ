#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Classification périodique

#flashcard(
    recto: [Électrons de valence],
    verso: [Ce sont les électrons de la couche de nombre quantique principal $n$ le plus élevé, ainsi que ceux sur les couches $(n - 1)$d et $(n - 2)$f si celles-ci ne sont pas remplies.],
)
#flashcard(
    recto: [Définition de l'électronégativité],
    verso: [Aptitude d'un atome à attirer les électrons d'une liaison. Elle croît de la gauche vers la droite d'une période et du bas vers le haut d'une colonne.],
)

#question-de-colle(
    [Le colleur donne le nom d'un élément d'une des trois premières lignes de la classification périodique des éléments et un entier $n in [19,54]$. Pour cet élément et l'élément de numéro atomique $n$, déterminer la configuration électronique, le nombre d'électrons de valence, la position dans la classification périodique et le nom du groupe si pertinent.],
)

= Liaisons et schémas de Lewis

#flashcard(
    recto: [Ordre de grandeur d'une liaison covalente],
    verso: [Longueur de l'ordre de #quan[100 pm].],
)

= Géométrie des molécules

#flashcard(
    recto: [Méthode VSEPR],
    verso: [_Valence Shell Electron Pair Repulsion_ : Les doublets (liant ou non) de la couche de valence de l'atome central se repoussent et se placent le plus loin possible les uns des autres.],
)

