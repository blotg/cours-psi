#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Vitesse de réaction

#flashcard(
    recto: [Vitesse volumique de réaction],
    verso: [$ v = 1/V dv(xi, t) $ en #unit("mol/L/s")],
)
#flashcard(
    recto: [Ordre d'une réaction],
    verso: [La réaction admet un ordre si $v = k product a_i^(alpha_i)$. L'ordre global est $sum alpha_i$ ; $k$ est la constante cinétique, dont l'unité dépend de l'ordre.],
)

#question-de-colle(
    [Définir la vitesse volumique de réaction et la relier aux vitesses de disparition des réactifs et d'apparition des produits. Définir l'ordre d'une réaction et la constante cinétique.],
)

= Lois de vitesse intégrées

#flashcard(
    recto: [Dégénérescence de l'ordre],
    verso: [En mettant tous les réactifs sauf un en large excès, leurs concentrations restent quasi constantes : on se ramène à un ordre apparent et on détermine l'ordre partiel du réactif restant.],
)

#question-de-colle(
    [Pour une réaction d'ordre 0, 1 ou 2 (au choix du colleur), établir la loi de vitesse, exprimer son temps de demi-réaction et proposer une méthode graphique pour vérifier si l'ordre est compatible avec des mesures de concentration.],
)

= Influence de la température

#flashcard(
    recto: [Loi d'Arrhenius],
    verso: [$ k(T) = A e^(-E_a/(R T)) $ où $E_a$ est l'énergie d'activation en #unit("J/mol").],
)

#question-de-colle(
    [Énoncer la loi d'Arrhenius et proposer une méthode pour déterminer l'énergie d'activation d'une réaction à partir de mesures de la constante cinétique à différentes températures.],
)
