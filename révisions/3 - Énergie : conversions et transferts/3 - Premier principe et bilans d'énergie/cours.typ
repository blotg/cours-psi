#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Premier principe

#flashcard(recto: "Premier principe de la thermodynamique", verso: "Pour un système fermé : $Delta U + Delta E_c = W + Q$. L'énergie interne est une fonction d'état, $W$ et $Q$ sont des termes d'échange qui dépendent du chemin.")
#flashcard(recto: "Statut des termes du premier principe", verso: "$Delta U$ ne dépend que des états initial et final ; $W$ et $Q$ dépendent du chemin suivi. Seule leur somme est indépendante du chemin.")

#question-de-colle("Énoncer le premier principe de la thermodynamique, d'abord en version complète puis en version purement thermodynamique, en précisant les hypothèses, le nom et l'unité de chaque grandeur.")

= Enthalpie

#flashcard(recto: "Enthalpie", verso: "$H = U + P V$. Pour une transformation monobare avec équilibre mécanique aux états extrêmes, $Delta H = Q_P$.")
#flashcard(recto: "Deuxième loi de Joule", verso: "L'enthalpie d'un gaz parfait ne dépend que de la température.")
#flashcard(recto: "Capacité thermique à pression constante", verso: "$C_P = (pdv(H, T))_P$. Pour l'eau liquide, $c approx 4,18$ $k J dot K^(-1) dot k g^(-1)$.")
#flashcard(recto: "Relation de Mayer", verso: "$C_P - C_V = n R$ pour un gaz parfait ; avec $gamma = C_P\\/C_V$, $C_V = (n R)/(gamma-1)$ et $C_P = (gamma n R)/(gamma-1)$.")

#question-de-colle("Définir l'enthalpie et donner la formulation du premier principe faisant intervenir cette fonction d'état, en précisant les hypothèses.")
#question-de-colle("Établir la relation de Mayer pour un gaz parfait et en déduire les expressions de $C_V$ et $C_P$ en fonction de $gamma$ et $n R$.")

= Changements d'état

#flashcard(recto: "Enthalpie de changement d'état", verso: "$Delta h_(1 -> 2)(T)$ : enthalpie massique reçue lors du passage de la phase 1 à la phase 2, à température et pression d'équilibre. Elle est positive pour fusion, vaporisation et sublimation.")

#question-de-colle("Réaliser un bilan énergétique pour un système siège d'une transition de phase, en exploitant l'extensivité de l'enthalpie. Application : calorimétrie de la fusion de la glace.")
