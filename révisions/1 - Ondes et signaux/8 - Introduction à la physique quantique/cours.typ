#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Dualité onde-particule

#flashcard(
    recto: "Relation de Planck-Einstein",
    verso: "$ E = h nu = h c/lambda $ avec $E$ l'énergie d'un photon, $nu$ sa fréquence, $lambda$ sa longueur d'onde et $c$ la célérité de la lumière dans le vide.",
)
#flashcard(
    recto: "Relation de de Broglie",
    verso: "$ lambda = h/p $ : à toute particule de quantité de mouvement $p$ est associée une longueur d'onde $lambda$.",
)

#question-de-colle(
    "Donner les relations de Planck-Einstein et de de Broglie en précisant le nom et l'unité de chaque grandeur. Estimer la longueur d'onde de de Broglie d'un électron de quelques électronvolts et la comparer à une distance interatomique.",
)

= Inégalité de Heisenberg

#flashcard(
    recto: "Inégalité de Heisenberg spatiale",
    verso: "$ Delta p Delta x >= hbar $ On ne peut pas connaitre simultanément et avec une précision arbitraire la position et la quantité de mouvement.",
)
