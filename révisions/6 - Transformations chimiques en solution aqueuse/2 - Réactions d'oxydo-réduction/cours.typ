#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Oxydants, réducteurs, potentiel

#flashcard(
    recto: "Oxydant et réducteur",
    verso: "Un oxydant capte des électrons, un réducteur en cède. Une réaction d'oxydo-réduction est un transfert d'électrons entre deux couples.",
)
#flashcard(
    recto: "Formule de Nernst",
    verso: "$E = E^circ + (0,06)/n log (product a_(\"ox\"))/(product a_(\"red\"))$ à $25$ °C, où $n$ est le nombre d'électrons échangés.",
)
#flashcard(
    recto: "Prévision du sens d'une réaction",
    verso: "L'oxydant du couple de potentiel le plus élevé réagit avec le réducteur du couple de potentiel le plus bas : c'est la règle du gamma.",
)

#question-de-colle(
    "Établir la relation entre la constante d'équilibre d'une réaction d'oxydo-réduction et les potentiels standard des deux couples, à partir de la formule de Nernst.",
)

= Piles

#flashcard(
    recto: "Constitution d'une pile",
    verso: "Deux demi-piles reliées par un pont salin. L'anode est le siège de l'oxydation (pôle $-$), la cathode celui de la réduction (pôle $+$).",
)
#flashcard(
    recto: "Force électromotrice d'une pile",
    verso: "$e = E_(+) - E_(-)$, différence des potentiels d'électrode calculés par la formule de Nernst. La pile est usée quand $e = 0$, c'est-à-dire à l'équilibre chimique.",
)

#question-de-colle(
    "Décrire la constitution d'une pile Daniell, écrire les demi-équations aux électrodes et l'équation de fonctionnement, et exprimer sa force électromotrice.",
)

= Diagrammes potentiel-pH

#flashcard(
    recto: "Conventions de tracé",
    verso: "On se donne une concentration de tracé pour les espèces dissoutes et une convention de frontière (égalité des concentrations, ou de l'élément réparti). Les frontières verticales sont acide-base, les autres d'oxydo-réduction.",
)
#flashcard(
    recto: "Domaine de stabilité de l'eau",
    verso: "Il est délimité par les couples $O_2\\/H_2 O$ et $H_2 O\\/H_2$. Une espèce dont le domaine est disjoint de celui de l'eau réagit avec elle — parfois lentement.",
)

#question-de-colle(
    "Lire un diagramme potentiel-pH fourni : attribuer les domaines aux espèces, justifier la pente des frontières, et prévoir la stabilité d'une espèce dans l'eau.",
)
#question-de-colle(
    "Superposer le diagramme potentiel-pH de l'eau à celui d'un élément et en déduire les réactions susceptibles de se produire. Commenter l'écart entre prévision thermodynamique et observation cinétique.",
)
