#import "@local/prepa:0.1.1": *
#show: exercice.with(
    titre: "Impedance matching",
    difficulté: 2,
)

A voltage generator gives a sinusoidal voltage $e$ to the primary of a transformer through a resistor $R_1$.

#figure[
    #zap.circuit({
        import zap: *
        import cetz.draw: *

        transformateur("transfo", (0, 0))
        vsource("e", (-4, -1), (-4, 1), u: $e$)
        resistor("R1", "e.out", "transfo.P+", label: $R_1$, i: $i$)
        wire("e.in", "transfo.P-")
        resistor("R2", (3, 1), (3, -1), label: $R_2$)
        wire("R2.in", "transfo.S+", i: $i_2$)
        wire("transfo.S-", "R2.out")
        line((-1.5, -.9), (-1.5, 0.9), mark: (end: ">", fill: black), name: "v1", stroke: 0.6pt)
        content("v1.mid", $v_1$, anchor: "east", padding: 0.1)
        line((1.5, -.9), (1.5, 0.9), mark: (end: ">", fill: black), name: "v2", stroke: 0.6pt)
        content("v2.mid", $v_2$, anchor: "west", padding: 0.1)
    })
]

#question(
    coups-de-pouce: (
        "Quelle est la tension aux bornes de $R_2$ (en fonction de $R_1$, $R_2$, $m$ et $e$) ?",
        "Ramener le primaire au secondaire puis effectuer un pont diviseur de tension.",
    ),
)[
    At which condition on the transformation ratio $m$ is the power dissipated by the resistor $R_2$ maximal ?
][
    The circuit is equivalent to the following one (primary side brought to the secondary side):
    #figure[
        #zap.circuit({
            import zap: *
            import cetz.draw: *

            vsource("e", (-2, -2), (-2, 0), u: $m e$)
            resistor("R1", "e.out", (0, 0), label: $m^2 R_1$)
            resistor("R2", (0,-2), "R1.out", u:(content:$v_2$, anchor:"south"))
            wire("e.in", "R2.in", i: $i_2$)
        })
    ]
    $ v_2=m e R_2/(m^2 R_1 + R_2) $

    $ P = V_(2,"eff")^2/R_2 
    = (m e R_2/(m^2 R_1 + R_2))^2/R_2 = (m^2 E_"eff"^2 R_2)/(m^2 R_1 + R_2)^2 $

    $ pdv(P,m) = (2 m E_"eff"^2 R_2 (m^2 R_1 + R_2)^2 - m^2 E_"eff"^2 R_2 4 m (m^2R_1+R_2))/(m^2 R_1 + R_2)^4 $

    $ pdv(P,m) = 0 => 2 m E_"eff"^2 R_2 (m^2 R_1 + R_2)^2 = 4 m^3 E_"eff"^2 R_2 R_1 (m^2R_1+R_2) $

    $ (m^2 R_1 + R_2) = 2 m^2 R_1 $

    $ R_2 = m^2 R_1 $

    $ m = sqrt(R_2/R_1) $
]

