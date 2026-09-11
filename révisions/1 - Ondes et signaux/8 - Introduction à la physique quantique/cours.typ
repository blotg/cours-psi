#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Dualité onde-particule

#flashcard(recto: "Relation de Planck-Einstein", verso: "$E = h nu = h c\\/lambda$, avec $h = 6,63 dot 10^(-34)$ $J dot s$.")
#flashcard(recto: "Relation de de Broglie", verso: "$lambda = h\\/p$ : à toute particule de quantité de mouvement $p$ est associée une longueur d'onde.")
#flashcard(recto: "Interprétation probabiliste", verso: "La figure d'interférences se construit coup par coup : l'intensité en un point donne la probabilité d'y détecter un quanton.")

#question-de-colle("Donner les relations de Planck-Einstein et de de Broglie en précisant le nom et l'unité de chaque grandeur. Estimer la longueur d'onde de de Broglie d'un électron de quelques électronvolts et la comparer à une distance interatomique.")

= Inégalité de Heisenberg

#flashcard(recto: "Inégalité de Heisenberg spatiale", verso: "$Delta p dot Delta x >= ℏ\\/2$ : on ne peut pas connaitre simultanément et avec une précision arbitraire la position et la quantité de mouvement.")

#question-de-colle("À l'aide d'une analogie avec la diffraction des ondes lumineuses, établir en ordre de grandeur l'inégalité $Delta p dot Delta x >= ℏ$.")

= Particule confinée

#flashcard(recto: "Niveaux d'énergie du puits infini à une dimension", verso: "$E_n = n^2 h^2/(8 m L^2)$ : l'énergie est quantifiée et l'énergie minimale n'est pas nulle.")

#question-de-colle("Modèle du puits de potentiel de profondeur infinie à une dimension : utiliser l'inégalité de Heisenberg spatiale pour mettre en évidence l'existence d'une énergie minimale non nulle pour la particule confinée.")
#question-de-colle("Modèle du puits de potentiel de profondeur infinie à une dimension : obtenir les niveaux d'énergie par analogie avec les modes propres d'une corde vibrante.")
