#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Clignotant de voiture",
    ouvert: true,
)

#question(coups-de-pouce: (
    "Un oscillateur à relaxation ou sinusoïdal sera-t-il le plus adapté ?",
    "À quelle fréquence doit fonctionner le clignotant ?",
))[
    Concevoir le circuit de commande d'un clignotant de voiture. Les valeurs des composants seront explicitées. Aucune attention ne sera portée à la puissance ni aux éventuelles saturation de courant car un circuit de puissance placé en aval sera chargé d'adapter la puissance aux ampoules. On supposera la voiture équipée d'ampoules LED ne laissant passer le courant que dans un sens.
][
    Un clignotant de voiture doit être allumé ou éteint sans entre deux, on part donc sur un oscillateur à relaxation, par exemple celui vu en cours avec un intégrateur et un comparateur à hystérésis.

    #let R1 = 10e3
    #let R2 = 22e3
    #let C = 10e-6
    #let R = 66e3
    #let T = 4 * R1 / R2 * R * C
    La période de clignotement est de l'ordre de #qty("1", "s"). Il faut choisir les valeurs de composants pour avoir $T = 4R_1/R_2 R C approx qty("1", "s")$ avec $R_1 > R_2$ pour avoir des oscillations. On peut par exemple choisir $R_1 = qty("10", "kO")$, $R_2 = qty("22", "kO")$, $C = qty("10", "uF")$ et $R = qty("66", "kO")$ ce qui donne une période de clignotement de
    $
        T approx #qty(scientifique(T, 2), "s")
    $

    #figure(
        zap.circuit({
            import zap: *
            import draw: *
            opamp("ALI", (0, 0), invert: true)
            resistor("R2", (-2, 1.5), (2, 1.5), label: qty("22", "kO"))
            resistor("R1", (rel: (-1, 0), to: "ALI.plus"), (rel: (-2.5, 0)), label: qty("10", "kO"))
            frame("G1", (rel: (-.5, -.5), to: "ALI.minus"))
            swire("G1", "ALI.minus", axis: "y")
            swire("ALI.out", "R2.out")
            swire("R2.in", "ALI.plus", axis: "y")

            opamp("ALI2", (-7, 0))
            resistor("R", (rel: (-1, 0), to: "ALI2.minus"), (rel: (-3, 0)), label: qty("66", "kO"))
            capacitor("C", (-9, 2), (-5, 2), label: qty("10", "uF"))
            frame("G2", (rel: (-.5, -.5), to: "ALI2.plus"))
            swire("G2", "ALI2.plus", axis: "y")
            swire("ALI2.out", "C.out")
            swire("C.in", "ALI2.minus", axis: "y")

            swire("ALI2.out", "R1.out")
            swire("R2.out", (rel: (0, 2)), "R.out")

            wire((2,0), (rel:(1,0)))

            content((3,0), $u(t)$, anchor: "west", padding: .4em)
        }),
    )

    La tension de sortie $u(t)$ est une tension créneau variant entre #qty("-15", "V") et #qty("15", "V") avec une période de #qty(scientifique(T, 2), "s"). On peut l'envoyer aux ampoules LED avec un circuit de puissance placé en aval, les LED ne s'allumant que la moitié du temps.
]
