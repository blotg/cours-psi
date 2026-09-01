#import "@local/prepa:0.1.1": *
#show: exercice.with(
    titre: "Rendement à puissance réduite",
    ouvert: true,
    difficulté: 3,
)

Un extrait de l'emballage d'un transformateur est reproduit ci-dessous. Ce type de transformateur est utilisé pour alimenter des lampes (modélisables par des résistors) à partir du réseau électrique domestique.

#figure(image("../images/transformateur lumière.png", width: 12cm))

La notation "Pno" indique la puissance absorbée par le transformateur lorsqu'il n'alimente aucune charge (c'est-à-dire lorsque le secondaire est en circuit ouvert).

#question(
    coups-de-pouce: (
        "Que valent les pertes fer ?",
        "Calculer les pertes à puissance maximale à partir des tensions et courants au primaire et au secondaire. En déduire les pertes cuivres à puissance maximale.",
        "Calculer la résistance équivalente des fils du transformateur (vu au primaire ou au secondaire).",
        "Que vaut le courant au secondaire pour une charge de #qty(\"20\", \"W\") ? En déduire les pertes cuivre.",
    ),
)[
    Quel serait le rendement du transformateur s'il alimente une charge de #qty("20", "W") ?
][
    Les pertes fer ne dépendent pas du courant dans le secondaire. Elles sont donc égales à la puissance absorbée par le transformateur en circuit ouvert : $P_"fer" = #qty("0.47", "W")$.

    #let U1eff = 230
    #let I1effmax = 0.26
    #let cos-phi1 = 0.99
    En charge maximale, la puissance reçue par le primaire est $U_(1 "eff") I_(1 "eff max") cos(phi)$

    #let U2eff = 11.5
    #let I2effmax = 4.9
    La charge étant purement résistive, la puissance maximale fournie par le secondaire est $U_(2 "eff") I_(2 "eff max")$

    Les pertes totales dans le transformateur sont donc $U_(1 "eff") I_(1 "eff max") cos(phi)-U_(2 "eff") I_(2 "eff max")$

    #let Pfer = 0.47
    #let Pcumax = U1eff*I1effmax*cos-phi1 - U2eff*I2effmax - Pfer
    Les pertes cuivres sont donc $P_"cuivre max" = P_"pertes totales max"-P_"fer" approx #qty(scientifique(Pcumax,1),"W")$.

    #let R = Pcumax / calc.pow(I1effmax, 2)
    Notons $R$ la résistance équivalente des fils du transformateur vu du primaire. On a alors $P_"cuivre" = I_(1 "eff")^2 R$ d'où $R = P_"cuivre"/I_(1 "eff")^2$. En particulier, à la puissance max : $R = P_"cuivre max"/I_(1 "eff max")^2$.

    Pour une puissance de sortie de $P=#qty("20", "W")$, le courant de sortie est $I_(2" eff") = P/U_(2 "eff")$, les pertes cuivres sont donc $P_"cuivre" = R I_(1" eff")^2 = R (I_(2" eff") m)^2 = R((P m)/(U_(2 "eff")))^2$.

    Les pertes totales sont donc $P_"pertes totales" = P_"cuivre" + P_"fer" = P_"cuivre max"/I_(1 "eff max")^2 ((m P)/(U_(2 "eff")))^2 + P_"fer"$.

    #let P = 20
    #let m = 11.5/230
    #let I2eff = P/U2eff
    #let I1eff = I2eff*m
    #let Pcu = R * calc.pow(I1eff, 2)
    #let rendement = P/(P + Pcu + Pfer)
    Finalement, le rendement du transformateur est
    $
        eta & = P/(P + P_"pertes totales") \
            & = P/(P + P_"cuivre max"/I_(1 "eff max")^2 ((m P)/(U_(2 "eff")))^2 + P_"fer")
            & approx #qty(scientifique(rendement*100,1),"%")
    $
]
