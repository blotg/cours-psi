#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Premier principe

#flashcard(
    recto: "Premier principe de la thermodynamique",
    verso: "Pour un système *fermé*, il existe une fonction d'état $U$ appelée énergie interne telle que $ Delta U + Delta E_c = W + Q $.",
)

= Enthalpie

#flashcard(
    recto: "Enthalpie",
    verso: "$ H = U + P V $ Elle est construite à partir de fonctions d'état, c'est donc elle aussi une fonction d'état.",
)
#flashcard(
    recto: "Variation d'enthalpie pour une transformation monobare",
    verso: "$ Delta H = Q $",
)
#flashcard(
    recto: "Deuxième loi de Joule",
    verso: "L'enthalpie d'un gaz parfait ne dépend que de la température.",
)
#flashcard(
    recto: "Capacité thermique à pression constante",
    verso: "$ C_P = lr(pdv(H, T)\\))_P $",
)
#flashcard(
    recto: "Relation de Mayer",
    verso: "Pour un gaz parfait, $ C_P - C_V = n R $",
)
#flashcard(
    recto: "Coefficient de Laplace",
    verso: "$ gamma = C_P / C_V $",
)
#flashcard(
    recto: "Capacités thermiques à volume constant et à pression constante pour un gaz parfait",
    verso: "$ C_V = (n R)/(gamma-1) $$ C_P = (gamma n R)/(gamma-1) $",
)

#question-de-colle(
    "Énoncer la relation de Mayer et en déduire les expressions de $C_V$ et $C_P$ en fonction de $gamma$, $n$ et $R$.",
)

= Changements d'état

#flashcard(
    recto: "Enthalpie de changement d'état",
    verso: "$ Delta h_(1 -> 2)(T) $C'est l'enthalpie massique reçue lors du passage de la phase 1 à la phase 2, à température et pression d'équilibre. Elle est positive pour fusion, vaporisation et sublimation.",
)

