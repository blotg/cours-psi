#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Champ magnétique

#flashcard(
    recto: "Ordres de grandeur de champs magnétiques",
    verso: "Champ terrestre : quelques dizaines de #unit(\"uT\"). Aimant usuel : #qty(\"10\",\"mT\") à #qty(\"1\",\"T\"). IRM : #qty(\"1\",\"T\").",
)
#flashcard(
    recto: "Moment magnétique d'une boucle de courant",
    verso: "$ va(m) = i va(S) $ en #unit(\"Am^2\"), orienté par la règle de la main droite à partir du sens du courant.",
)

#question-de-colle(
    "Tracer l'allure des cartes de champ magnétique d'un aimant droit, d'une spire circulaire et d'une bobine longue. Donner l'expression du moment magnétique de la boucle de courant.",
)

= Forces de Laplace

#flashcard(
    recto: "Force de Laplace élémentaire",
    verso: "$ va(dd(F)) = i va(dd(l)) and va(B) $",
)
#flashcard(
    recto: "Couple subi par une spire dans un champ uniforme",
    verso: "$va(Gamma) = va(m) and va(B)$ : la spire tend à aligner son moment magnétique sur le champ.",
)

#question-de-colle(
    "Pour les rails de Laplace (barre mobile horizontale posée sur des rails horizontaux parallèles plongés dans un champ magnétique uniforme vertical), établir l'expression de la résultante des forces de Laplace sur la barre, en déduire l'équation du mouvement et la résoudre.",
)
#question-de-colle(
    "Sur l'exemple d'une spire rectangulaire parcourue par un courant et placée dans un champ uniforme orthogonal à son axe de rotation, montrer que les forces de Laplace forment un couple dont le moment s'écrit $va(Gamma) = va(m) and va(B)$, et que la puissance des actions de Laplace s'écrit $P = Gamma omega$.",
)

= Lois de l'induction

#flashcard(
    recto: "Loi de Faraday",
    verso: "$ e = - dv(Phi,t) $ avec $e$ en #unit(\"V\") en convention générateur et $Phi$ le flux du champ magnétique à travers le circuit orienté dans le sens de la main droite, en $unit(\"Wb\")=unit(\"T m^2\")$.",
)
#flashcard(
    recto: "Loi de Lenz",
    verso: "Les conséquences de l'induction s'opposent à la cause qui leur a donné naissance.",
)
#flashcard(
    recto: "Inductance propre",
    verso: "$ Phi_\"propre\" = L i $ avec $L$ en #unit(\"H\")",
)
#flashcard(
    recto: "Inductance mutuelle",
    verso: "$ Phi_\"bobine 1\" = M i_\"bobine 2\" $ avec $M$ en #unit(\"H\")",
)
#flashcard(
    recto: "Inductance mutuelle en influence totale",
    verso: "$ M_\"max\" = sqrt(L_1 L_2) $",
)

#question-de-colle(
    "Définir le flux d'un champ magnétique à travers un circuit et citer la loi de Faraday. À partir de cette loi, montrer la loi tension-courant d'une bobine $e = -L dv(i,t)$.",
)

= Conversion de puissance

#flashcard(
    recto: "Loi des tensions du transformateur idéal",
    verso: "$ u_2/u_1 = n_2/n_1 $",
)
