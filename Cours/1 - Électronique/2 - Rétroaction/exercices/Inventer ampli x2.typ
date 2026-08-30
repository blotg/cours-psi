#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Conception d'un amplificateur",
    ouvert: true,
)

#question()[
    Proposer un montage permettant de doubler la tension de sortie d'un GBF. Les valeurs des composants choisis seront précisées.
][
    On peut choisir l'amplificateur non-inverseur. Pour avoir un gain de 2, les résistances doivent être égales.

    L'impédance d'entrée de l'amplificateur non-inverseur est infinie, donc très grande devant l'impédance de sortie du GBF (#qty("50","O") habituellement) quelles que soient les valeurs des résistances choisies.

    On peut par exemple choisir des résistances de #qty("10","kO") pour $R_1$ et $R_2$.

    #figure(
    zap.circuit({
        import zap: *
        import draw: *
        opamp("ALI", (0, 0), invert: true)
        resistor("R2", (0, -2), label: qty("10","kO"))
        resistor("R1", (-1.5, -2), (-1.5,-4), label: qty("10","kO"))
        swire("ALI.minus", (-1.5,-2), "R2.west")
        swire("ALI.out", (rel: (0.5, 0)), "R2.east", axis: "y")
        wire("ALI.plus", (rel: (-1, 0)))
        wire("ALI.out", (rel: (1, 0)))
        content((rel: (-1, 0), to: "ALI.plus"), anchor: "east", padding: .4em, $V_e$)
        frame("G", "R1.out")
        content((rel: (1, 0), to: "ALI.out"), anchor: "west", padding: .4em, $V_s$)
    }),
)
]