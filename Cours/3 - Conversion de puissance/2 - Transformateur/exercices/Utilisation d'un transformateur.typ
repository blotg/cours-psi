#import "@local/prepa:0.1.1": *
#show: exercice.with(
    titre: "Utilisation d'un transformateur",
)

#figure[
    #zap.circuit({
        import zap: *
        import draw: *

        transformateur("transfo", (0, 0), borne-homologue-secondaire-inversée: true)
        vsource("e", (-5, -1), (-5, 1), u: $e$)
        resistor("R1", (-2, -1), (-2, 1), label: (content: $R_1$, anchor: "south"), u: $v_1$)
        resistor("R0", "e.out", "R1.out", label: $R_0$)
        wire("R0.out", "transfo.P+", i: $i_1$)
        wire("e.in", "transfo.P-")
        resistor("R2", (3, 1), (3, -1), label: $R_2$)
        wire("R2.in", "transfo.S+", i: $i_2$)
        wire("transfo.S-", "R2.out")
        line((1.5, -.9), (1.5, 0.9), mark: (end: ">", fill: black), name: "v2", stroke: 0.6pt)
        content("v2.mid", $v_2$, anchor: "west", padding: 0.1)
    })
]

#question(
    coups-de-pouce: (
        "Ramener le secondaire au primaire.",
        "Associer les deux résistances $R_2/m^2$ et $R_1$ en parallèle puis faire un pont diviseur de tension.",
    ),
)[
    Exprimer $v_1$ en fonction de $e$, $R_0$, $R_1$, $R_2$ et $m$.
][
    Si on ramène le secondaire au primaire, on obtient :

    #figure[
        #zap.circuit({
            import zap: *
            import draw: *

            vsource("e", (-5, -1), (-5, 1), u: $e$)
            resistor("R1", (-2, -1), (-2, 1), label: (content: $R_1$, anchor: "south"), u: $v_1$)
            resistor("R0", "e.out", "R1.out", label: $R_0$)
            resistor("R2", (0, 1), (0, -1), label: $R_2/m^2$)
            wire("R0.out", "R2.in", i: $i_1$)
            wire("e.in", "R2.out")
        })
    ]
    On note $R_"éq" = (R_1 R_2/m^2)/(R_1 + R_2/m^2) = (R_1 R_2)/(m^2 R_1 + R_2)$ la résistance équivalente du parallèle entre $R_1$ et $R_2/m^2$.

    Le pont diviseur de tension donne alors :
    $
        v_1 & = e R_"éq"/(R_0 + R_"éq") \
            & = e (R_1 R_2)/(m^2 R_1 + R_2)/(R_0 +(R_1 R_2)/(m^2 R_1 + R_2)) \
            & = e (R_1R_2)/((m^2R_1+R_2)R_0 + R_1R_2)
    $
]

#question(
    coups-de-pouce: (
        "Que vaut la tension $v_2$ ?",
        "Utiliser la loi d'Ohm.",
    ),
)[
    En déduire $i_2$ en fonction de $e$, $R_0$, $R_1$, $R_2$ et $m$.
][
    $ v_2 = m v_1 = m e (R_1R_2)/((m^2R_1+R_2)R_0 + R_1R_2) $

    Or, la loi d'Ohm au secondaire donne :
    $ i_2 = -v_2 / R_2 = (-m e R_1)/((m^2R_1+R_2)R_0 + R_1R_2) $
]

#let Eeff = 2
#let R1 = 1e2
#let R2 = 1e2
#let R0 = 1e2
#let m = 10

#question()[
    Application numérique : que vaut la valeur efficace de $i_2$ dans le cas où $R_0 = #qty(scientifique(R0, 1), "O")$, $R_1 = #qty(scientifique(R1, 1), "O")$, $R_2 = #qty(scientifique(R2, 1), "O")$, $e = #qty(scientifique(Eeff, 1), "V") _"eff"$ et $m = #num(scientifique(m, 1))$ ?
][
    #let I2eff = (m * Eeff * R1) / ((calc.pow(m, 2) * R1 + R2) * R0 + R1 * R2)
    $ I_(2,"eff") = (m E_"eff" R_1)/((m^2R_1+R_2)R_0 + R_1R_2) = #qty(scientifique(I2eff, 1), "A") $
]
