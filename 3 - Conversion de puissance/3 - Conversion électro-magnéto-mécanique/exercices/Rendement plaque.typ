#import "@local/prepa:0.1.0": *

#show: exercice.with(
    titre: "Rendement d'un moteur",
    ouvert: true,
)

La plaque signalétique d'un moteur à courant continu indique les caractéristiques suivantes :

#figure(
    image("../images/plaque MCC.jpg"),
)

#question(
    coups-de-pouce: (
        "Dans les conditions nominales, quelle est la puissance mécanique fournie par le moteur ? Quelle est la puissance électrique consommée ?",
        "La puissance électrique est consommée par l'induit et par l'inducteur."
    ),
)[
    Calculer le rendement du moteur lorsqu'il fonctionne à sa puissance nominale.
][
    Dans les conditions nominales, le moteur fournit une puissance mécanique de #qty("36.3", "kW").

    #let Pc = 440*95.5+360*3
    Dans les conditions nominales, le moteur absorbe une puissance électrique de $440 times 95.5 + 360 times 3 = #qty(scientifique(Pc,2), "W")$.

    Le rendement du moteur est donc
    $ eta = P_"utile"/P_"couteuse" = 36.3/43 = #scientifique(36.3e3/Pc,2) $
]
