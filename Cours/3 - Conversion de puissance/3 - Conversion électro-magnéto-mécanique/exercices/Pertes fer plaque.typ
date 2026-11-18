#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Pertes fer",
    ouvert: true,
    difficulté: 3
)

La plaque signalétique d'un moteur à courant continu indique les caractéristiques suivantes :

#figure(
    image("../images/plaque MCC.jpg"),
)

La résistance de l'induit vaut $R = #quan[0.60 Ω]$.

#question(
    coups-de-pouce: (
        "Quelles sont les pertes cuivre dans les conditions nominales ? Ne pas oublier l'inducteur.",
        "Faire un bilan de puissance sur l'induit.",
        "Les pertes mécaniques et les pertes fer ne peuvent pas être distinguées par ce bilan.",
    ),
)[
    Montrer que les pertes fer sont négligeables devant les pertes cuivre dans les conditions nominales.
][
    #let Pméca = 36.3e3
    #let I = 95.5
    #let U = 440
    #let Ue = 360
    #let Ie = 3
    #let R = 0.60
    #let PcuInduit = R * calc.pow(I, 2)
    #let Pcu = PcuInduit + Ue * Ie
    #let Pfe = U * I - Pméca - PcuInduit
    Les pertes cuivre sont celles de l'induit et de l'inducteur, qui est à excitation séparée :
    $ P_ce("Cu") = R I^2 + U_e I_e = #qty(PcuInduit, "W", chiffres: 2) + #qty(Ue * Ie, "W", chiffres: 2) = #qty(Pcu, "W", chiffres: 2) $

    Un bilan de puissance sur l'induit donne $U I = P_"mécanique" + R I^2 + P_ce("Fe") + P_"frottements"$, soit
    $ P_ce("Fe") + P_"frottements" = U I - P_"mécanique" - R I^2 = #qty(Pfe, "W", chiffres: 2) $

    Les pertes fer, qui sont au plus de cet ordre, représentent donc au plus #qty(100 * Pfe / Pcu, "%", chiffres: 1) des pertes cuivre : elles sont négligeables.
]
