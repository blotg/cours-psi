#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Vitesse de réaction

#flashcard(recto: "Vitesse volumique de réaction", verso: "$v = 1/V (dif xi)/(dif t)$, en $m o l dot L^(-1) dot s^(-1)$. À volume constant, $v = 1/nu_i (dif c_i)/(dif t)$.")
#flashcard(recto: "Ordre d'une réaction", verso: "La réaction admet un ordre si $v = k product c_i^(p_i)$. L'ordre global est $sum p_i$ ; $k$ est la constante cinétique, dont l'unité dépend de l'ordre.")

#question-de-colle("Définir la vitesse volumique de réaction et la relier aux vitesses de disparition des réactifs et d'apparition des produits. Définir l'ordre d'une réaction et la constante cinétique.")

= Lois de vitesse intégrées

#flashcard(recto: "Réaction d'ordre 0", verso: "$c(t) = c_0 - k t$ : décroissance affine, $t_(1\\/2) = c_0\\/(2k)$ dépend de la concentration initiale.")
#flashcard(recto: "Réaction d'ordre 1", verso: "$c(t) = c_0 e^(-k t)$ : $ln c$ est affine en $t$, et $t_(1\\/2) = (ln 2)\\/k$ ne dépend pas de la concentration initiale.")
#flashcard(recto: "Réaction d'ordre 2", verso: "$1/c(t) = 1/c_0 + k t$ : $1\\/c$ est affine en $t$, et $t_(1\\/2) = 1\\/(k c_0)$.")
#flashcard(recto: "Dégénérescence de l'ordre", verso: "En mettant tous les réactifs sauf un en large excès, leurs concentrations restent quasi constantes : on se ramène à un ordre apparent et on détermine l'ordre partiel du réactif restant.")

#question-de-colle("Établir la loi de vitesse intégrée d'une réaction d'ordre 1, exprimer son temps de demi-réaction et proposer une méthode graphique pour vérifier l'ordre à partir de mesures de concentration.")
#question-de-colle("Mêmes questions pour une réaction d'ordre 2. Expliquer la méthode de dégénérescence de l'ordre.")

= Influence de la température

#flashcard(recto: "Loi d'Arrhenius", verso: "$k(T) = A e^(-E_a\\/(R T))$, où $E_a$ est l'énergie d'activation en $J dot m o l^(-1)$. Tracer $ln k$ en fonction de $1\\/T$ donne une droite de pente $-E_a\\/R$.")

#question-de-colle("Énoncer la loi d'Arrhenius et proposer une méthode pour déterminer l'énergie d'activation d'une réaction à partir de mesures de la constante cinétique à différentes températures.")
