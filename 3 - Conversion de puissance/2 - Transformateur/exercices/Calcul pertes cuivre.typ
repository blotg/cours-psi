#import "@local/prepa:0.1.0": *
#show: exercice.with(
    titre: "Types de pertes",
    ouvert: true,
)

Un extrait de l'emballage d'un transformateur est reproduit ci-dessous. Ce type de transformateur est utilisé pour alimenter des lampes (modélisables par des résistors) à partir du réseau électrique domestique.

#figure(image("../images/transformateur lumière.png", width: 12cm))

La notation "Pno" indique la puissance absorbée par le transformateur lorsqu'il n'alimente aucune charge (c'est-à-dire lorsque le secondaire est en circuit ouvert).

#question(
    coups-de-pouce: (
        "Les pertes fer dépendent-elles du courant dans le secondaire ?",
        "Calculer la puissance reçue par le primaire en utilisant les tensions et courants efficaces ainsi que le facteur de puissance.",
        "Calculer la puissance fournie par le secondaire en utilisant les tensions et courants efficaces.",
        "Les pertes totales sont la différence entre la puissance reçue par le primaire et la puissance fournie par le secondaire.",
    ),
)[
    Calculer les pertes cuivres et les pertes fer du transformateur lorsqu'il alimente une charge de puissance maximale.
][
    Les pertes fer ne dépendent pas du courant dans le secondaire. Elles sont donc égales à la puissance absorbée par le transformateur en circuit ouvert : #qty("0.47", "W").

    #let U1eff = 230
    #let I1eff = 0.26
    #let cos-phi1 = 0.99
    En charge maximale, la puissance reçue par le primaire est $U_(1 "eff") I_(1 "eff") cos(phi) = 230 times 0.26 times 0.99 = #qty(scientifique(U1eff*I1eff*cos-phi1,2),"W")$

    #let U2eff = 11.5
    #let I2eff = 4.9
    La charge étant purement résistive, la puissance fournie par le secondaire est $U_(2 "eff") I_(2 "eff")  = #qty(scientifique(U2eff*I2eff,2),"W")$

    Les pertes totales dans le transformateur sont donc $U_(1 "eff") I_(1 "eff") cos(phi)-U_(2 "eff") I_(2 "eff") approx #qty(scientifique(U1eff*I1eff*cos-phi1 - U2eff*I2eff,1),"W")$

    Les pertes cuivres sont donc $P_"cuivre" = P_"pertes totales"-P_"fer" approx #qty(scientifique(U1eff*I1eff*cos-phi1 - U2eff*I2eff - 0.47,1),"W")$. Les pertes sont majoritairement sous forme de pertes cuivres.

    Le rendement du transformateur en charge maximale est donc $eta = (U_(2 "eff") I_(2 "eff"))/(U_(1 "eff") I_(1 "eff") cos(phi)) approx #qty(scientifique((U2eff*I2eff)/(U1eff*I1eff*cos-phi1),1),"")$.
]
