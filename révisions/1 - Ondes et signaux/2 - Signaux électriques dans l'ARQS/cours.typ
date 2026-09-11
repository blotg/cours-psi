#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)

= Courant, tension, ARQS

#flashcard(
    recto: "Condition d'application de l'ARQS",
    verso: "La taille $L$ du circuit doit être très petite devant la longueur d'onde : $L << c\\/f$. Le signal se propage alors d'un bout à l'autre du circuit en un temps négligeable devant la période.",
)
#flashcard(
    recto: "Courant comme un débit de charge",
    verso: "$ i = dv(q,t) $",
)
#flashcard(
    recto: "Loi des nœuds",
    verso: "La loi des nœuds traduit la conservation de la charge : la somme des intensités entrantes est égale à la somme des sortantes.",
)
#flashcard(
    recto: "Loi des mailles",
    verso: "La somme algébrique des tensions le long d'une maille orientée est nulle.",
)

= Dipôles

#flashcard(
    recto: "Relation courant-tension pour un résistor",
    verso: "Loi d'ohm : $u = R i$ en *convention récepteur*.",
)
#flashcard(
    recto: "Relation courant-tension pour un condensateur",
    verso: "$i = C dv(u,t)$ en *convention récepteur*.",
)
#flashcard(
    recto: "Relation courant-tension pour une bobine",
    verso: "$u = L dv(i,t)$ en *convention récepteur*.",
)
#flashcard(
    recto: "Unité de la résistance et valeurs usuelles",
    verso: "L'unité de la résistance est l'ohm ($Omega$). Les valeurs usuelles vont du #unit(\"O\") à plusieurs #unit(\"MO\").",
)
#flashcard(
    recto: "Unité de la capacité et valeurs usuelles",
    verso: "L'unité de la capacité est le farad ($F$). Les valeurs usuelles vont du #unit(\"pF\") au#unit(\"mF\").",
)
#flashcard(
    recto: "Unité de l'inductance et valeurs usuelles",
    verso: "L'unité de l'inductance est le henry ($H$). Les valeurs usuelles vont du #unit(\"mH\") à quelques #unit(\"H\").",
)
#flashcard(
    recto: "Énergie stockée dans un condensateur",
    verso: "$ E_C = 1/2 C u^2 $",
)
#flashcard(
    recto: "Énergie stockée dans une bobine",
    verso: "$ E_L = 1/2 L i^2 $.",
)
#flashcard(
    recto: "Puissance dissipée par effet Joule dans un résistor",
    verso: "$ P = R i^2 = u^2/R $",
)
#flashcard(
    recto: "Modèle de Thévenin",
    verso: "Une source réelle se modélise par une source idéale de tension $e$ en série avec sa résistance interne $r$.",
)

#question-de-colle(
    "Écrire les relations courant-tension des trois dipôles linéaires en précisant les conventions. Établir l'expression de l'énergie stockée dans un condensateur puis dans une bobine.",
)

= Associations et modèles

#flashcard(
    recto: "Associations de résistances en série",
    verso: "$ R_\"éq\" = R_1 + R_2 $",
)
#flashcard(
    recto: "Associations de résistances en parallèle",
    verso: "$ 1/R_\"éq\" = 1/R_1 + 1/R_2 $",
)
#flashcard(
    recto: "Pont diviseur de tension",
    verso: "Si les deux résistances sont en série (traversées par le même courant) : $ u_1 = R_1/(R_1+R_2) u $",
)
#flashcard(
    recto: "Pont diviseur de courant",
    verso: "Si les deux résistances en parallèle (même tension aux bornes) : $ i_1 = R_2/(R_1+R_2) i $",
)

#question-de-colle(
    "Démontrer l'expression de la résistance équivalente pour des résistances en série puis établir la relation du pont diviseur de tension.",
)
#question-de-colle(
    "Démontrer l'expression de la résistance équivalente pour des résistances en parallèle puis établir la relation du pont diviseur de courant.",
)
