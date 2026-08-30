#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Taux de modulation",
    difficulté: 1,
)

La figure ci-dessous représente un signal modulé en amplitude $s_"AM" (t)$, dont le signal modulant est sinusoïdal.

#figure(
    canvas({
        plot.plot(
            size: (12, 5),
            // axis-style: "school-book",
            x-grid: true,
            y-grid: true,
            // x-tick-step: none,
            // y-tick-step: none,
            x-min: 0,
            x-max: 1,
            y-min: -2,
            y-max: 2,
            // x-ticks: ((0.1, $qty("100","ms")$), (1, $qty("1","s")$)),
            // y-ticks: ((0.3, $0.3$), (1.7, $1.7$)),
            x-label: [$t$ (ms)],
            y-label: [$s_"AM" (t)$ (V)],
            {
                plot.add(
                    t => calc.cos(2 * calc.pi * 40 * t) * (1 + 0.7 * calc.cos(2 * calc.pi * 2 * t)),
                    domain: (0, 1),
                    samples: 1000,
                    line: "spline",
                )
            },
        )
    }),
)

#question()[
    Quelle est la fréquence de la porteuse ?
][
    On compte $12$ oscillations rapides (la porteuse) sur une durée de #qty("0.3", "ms") : la fréquence de la porteuse vaut donc $f_p = 1/T_p = num("12")/num("0.3e-3") = #qty(scientifique(12 / 0.3e-3, 2), "Hz")$.
]

#question()[
    Quelle est la fréquence du signal modulant ?
][
    On compte $2$ oscillations lentes (l'enveloppe, donc la modulante) sur une durée de #qty("1", "ms") : la fréquence du signal modulant vaut donc $f_s = qty("2.0e3", "Hz")$.
]

#question(
    coups-de-pouce: (
        "Quelles sont les valeurs maximale et minimale de la modulante ?",
        "Comment les valeurs extrémales de la modulante sont-elles reliées au taux de modulation ?",
    ),
)[
    Mesurer le taux de modulation.
][
    Le signal modulé en amplitude s'écrit $s_"AM" (t)=(1+k A_s cos(2 pi f_s t)) A_p cos(2 pi f_p t)$.

    L'enveloppe $(1+k A_s cos(2 pi f_s t)) A_p$ a pour maximum $E_"max"=(1+k A_s) A_p = qty("1.7", "V")$ et pour minimum $E_"min"=(1- k A_s) A_p = qty("0.3", "V")$. Pour éliminer $A_p$ on effectue le rapport de ces deux valeurs :
    $
        (1+k A_s) / (1- k A_s) = E_"max" / E_"min"
    $
    $
        k A_s (E_"max" + E_"min") = E_"max" - E_"min"
    $
    Soit le taux de modulation
    $
        h = k A_s = (E_"max" - E_"min") / (E_"max" + E_"min") = (1.7 - 0.3) / (1.7 + 0.3) = 0.7
    $
]
