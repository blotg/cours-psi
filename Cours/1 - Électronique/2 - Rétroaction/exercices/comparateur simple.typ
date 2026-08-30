#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Montage comparateur simple",
)

On s'intéresse au montage suivant, appelé montage comparateur simple. L'ALI est supposé idéal.

#figure(
    zap.circuit({
        import zap: *
        import draw: *
        set-style(content: (padding: .4em))
        opamp("ALI", (0, 0), invert: true)
        vsource("V", (rel: (-1, 0), to: "ALI.minus"), (rel: (0, -2)), u: (content: $V_0$, anchor: "south-west"))
        frame("G", (rel: (-1, -2), to: "ALI.minus"))
        wire("ALI.minus", "V.in")
        wire("ALI.plus", (rel: (-1, 0)))
        content((rel: (-1, 0), to: "ALI.plus"), $V_e$, anchor: "east")
        wire("ALI.out", (rel: (1, 0)))
        content((rel: (1, 0), to: "ALI.out"), $V_s$, anchor: "west")
    }),
)

#question(
    coups-de-pouce: "Y a-t-il une rétroaction ?",
)[
    L'ALI a-t-il un fonctionnement stable ou instable ?
][
    L'absence de rétroaction implique un fonctionnement instable.
]

#question(
    coups-de-pouce: (
        "A quelle condition sur l'entrée différentielle la sortie est-elle égale à $V_\"sat\"$ ? à $-V_\"sat\"$ ?",
        "A quelle condition sur l'entrée $V_e$ la sortie est-elle égale à $V_\"sat\"$ ? à $-V_\"sat\"$ ?",
    ),
)[
    Dresser la caractéristique $(V_s, V_e)$ du montage. Justifier le nom du montage.
][
    Puisque le montage est instable, la sortie vaut soit $V_"sat"$ (si $epsilon > 0$), soit $-V_"sat"$ (si $epsilon <0$). On étudie alors le signe de $epsilon$.

    $
        epsilon = V_e - V_0
    $

    On a donc

    $
        cases(
            V_e > V_0 arrow.double epsilon > 0 arrow.double V_s = V_"sat",
            V_e < V_0 arrow.double epsilon < 0 arrow.double V_s = -V_"sat",
        )
    $
    ce qui donne la caractéristique suivante

    #figure(
        canvas({
            plot.plot(
                size: (12, 8),
                axis-style: "school-book",
                x-tick-step: none,
                y-tick-step: none,
                x-ticks: ((2, $V_0$),),
                y-ticks: ((-15, $-V_"sat"$), (15, $V_"sat"$)),
                x-label: $V_e$,
                y-label: $V_s$,
                {
                    let f1(x) = {
                        if x > 2 {
                            return 15
                        } else {
                            return -15
                        }
                    }
                    plot.add(f1, domain: (-5, 5), samples: 1000)
                },
            )
        }),
    )
]

#question(
    coups-de-pouce: (
        "Quel est le courant d'entrée de l'ALI ?",
    ),
)[
    Quelle est l'impédance d'entrée du montage.
][
    Le courant d'entrée de l'ALI est nul.

    $
        Z_e = V_e/I_e = infinity
    $
    L'impédance d'entrée du comparateur simple est infinie.
]
