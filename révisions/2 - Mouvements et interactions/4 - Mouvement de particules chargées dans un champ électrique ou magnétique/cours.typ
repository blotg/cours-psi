#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Force de Lorentz

#flashcard(
    recto: "Force de Lorentz",
    verso: "$ va(F) = q (va(E) + va(v) and va(B)) $",
)
#flashcard(
    recto: "Travail de la partie magnétique de la force de Lorentz",
    verso: "$ W = integral q (va(v) and va(B)) dot va(dd(l)) = integral q (va(v) and va(B)) dot va(v) dd(t) = 0 $
    La force est toujours orthogonale à la vitesse, donc elle ne travaille pas.",
)

#question-de-colle(
    "Donner l'expression de la force de Lorentz. Déterminer le travail de la partie magnétique de cette force. Comparer en ordre de grandeur le poids à la force de Lorentz pour un exemple à préciser.",
)

= Mouvements

#question-de-colle(
    "Pour un porteur de charge dans un champ électrique uniforme, exprimer son accélération et déterminer sa trajectoire.",
)
#question-de-colle(
    "Un électron est lâché sans vitesse initiale à l'électrode négative d'un condensateur plan. Par un raisonnement énergétique, déterminer sa vitesse à l'arrivée à l'électrode positive. Effectuer l'application numérique pour une différence de potentiel de #qty(\"1\",\"kV\") entre les électrodes.",
)
#question-de-colle(
    "Pour une particule chargée dans un champ magnétostatique uniforme, lancée avec une vitesse initiale perpendiculaire au champ,  déterminer le rayon de la trajectoire et le sens du parcours en admettant qu'elle est circulaire.",
)
