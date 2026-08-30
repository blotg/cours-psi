#import "@local/prepa:0.1.0": *

#show: exercice.with(
    titre: "Paratonnerre",
    difficulté: 1,
)

Un paratonnerre est relié à une demi-boule métallique supposée parfaitement conductrice qui sert de contact entre le paratonnerre et le sol. Le sol a une conductivité $gamma=#qty("1e-2", "S/m")$. On se place en régime stationnaire.

#grid(
    columns: (50%, 50%),
    align: (center, center),
    image("/images/panneau.jpg", width: 100%),
    canvas({
        import draw: *
        rect((-3, 0), (3, -3), fill: black.lighten(80%), stroke: none)
        arc((-1.5, 0), radius: 1.5, start: -180deg, stop: 0deg, fill: black.lighten(50%))
        content((3, -3), [sol], anchor: "south-east", padding: .7em)
        content((0, 0), [paratonnerre], anchor: "north", padding: .7em)
        for i in range(1, 10) {
            line((-i * 19deg, 1.7), (-i * 19deg, 2.5), mark: (end: ">>", fill: black))
        }
        line((0, 0.2), (-1.5, 0.2), mark: (symbol: ">>", fill: black), name: "R")
        content("R.mid", $R$, anchor: "south", padding: .4em)
        content((-19deg, 2.1), $va(j)$, anchor: "south-west", padding: .4em)
    }),
)

#question(
    coups-de-pouce: (
        "Exprimer le courant passant dans une demi sphère dans le sol, de rayon $r$ en fonction de $r$ et $j$. Ce courant dépend-il de $r$ ?",
    ),
)[
    Justifier que $va(j)$ est à flux conservatif. En déduire la dépendance en $r$ de $va(j)$.
][
    L'énoncé précise que le regime est stationnaire. Dans ce cas, $va(j)$ est à flux conservatif.

    Le courant $I$ traversant une demi-sphère de rayon $r>R$ est donc le même quel que soit $r$ (il ne dépend pas de $r$).

    $
        I = integral.double_S_r va(j) dot va(dd(S)) = 2 pi r^2 j(r)
    $
    d'où
    $ j(r) = I/(2 pi r^2) $
]

#question(
    coups-de-pouce: (
        "Utiliser la loi d'Ohm locale.",
        "Déterminer la circulation du champ électrique entre $r$ et $+infinity$.",
    ),
)[
    En déduire l'expression de $V(r)$ en supposant que $V$ vaut $0$ à l'infini.
][
    La loi d'Ohm locale s'écrit $va(j) = gamma va(E)$ d'où
    $
        E(r) = j(r)/gamma = I/(2 pi gamma r^2)
    $

    La différence de potentiel entre $r$ et l'infini est
    $
        V(r) & = V(r) - V(+infinity) = integral_r^(+infinity) E(r) dd(r) \
             & = I/(2 pi gamma) integral_r^(+infinity) 1/r^2 dd(r) \
             & = I/(2 pi gamma) [-1/r]_r^(+infinity) \
             & = I/(2 pi gamma r)
    $
]

#question(
    coups-de-pouce: (
        "Que donne la relation précédente en prenant $r=R$ ?",
    ),
)[
    Exprimer le potentiel du paratonnerre en fonction du courant qui le parcourt et introduire la "résistance du sol".
][
    Le potentiel du paratonnerre est
    $ V(R) = I/(2 pi gamma R) = R_"sol" I $

    avec $ R_"sol" = 1/(2 pi gamma R) $
]

#let R-sol = 30
#let gamma-sol = 1e-2
#let R = 1 / (2 * calc.pi * gamma-sol * R-sol)
#question(
    coups-de-pouce: (),
)[
    Cette résistance ne doit pas dépasse #qty("30", "O"). Déterminer le rayon minimum de la demi-sphère.
][

    $ R=1/(2 pi gamma R_"sol") = #qty(scientifique(R, 2), "m") $
]

#let I = 300e3
#question(
    coup-de-pouce: (),
)[
    Pour un éclair, le courant peut atteindre #qty("300", "kA"). Tracer $V(r)$ et faire l'application numérique de $V(R)$ pour une résistance du sol de #qty("30", "O").
][
    #let R-sol = 30
    #let V-R = R-sol * I
    $ V(R) = R_"sol" I = #qty(scientifique(V-R, 2), "V") $

    #figure(
        canvas({
            import plot: *
            let V(r) = {
                return I / (2 * calc.pi * gamma-sol * r)
            }
            plot(
                size: (6, 4),
                x-min: 0,
                y-min: 0,
                y-max: V-R * 1.2,
                x-label: $r$,
                y-label: $V(r)$,
                y-ticks: ((0, $0$), (V-R, num(scientifique(V-R, 2)))),
                { add(domain: (R, 3), V) },
                y-tick-step: none,
                x-ticks: ((R, num(scientifique(R, 2))),),
                x-tick-step: none,
                axis-style: "school-book",
            )
        }),
    )
]

#question(
    coups-de-pouce: (
        "Calculer la différence de potentiel maximale admissible entre deux pieds d'un être humain.",
        "Quelle distance $d$ y a-t-il typiquement entre deux pieds.",
        "Dans le pire des cas, les pieds sont \"l'un derrière l'autre\" : leurs coordonnées $r$ sont séparées de $d$.",
    ),
)[
    Une personne qui n'a pas les deux pieds à la même distance de la demi-sphère peut avoir ses pieds à un potentiel différent. Sachant que la résistance entre ses pieds est de l'ordre #qty("5", "kO") et qu'un courant de #qty("25", "mA") à travers le corps peut être dangereux, calculer la distance minimum à laquelle un homme doit se tenir de la demi-sphère en cas d'orage. Comparer à la valeur proposée sur la photo et proposer une explication à l'éventuel écart.
][
    La différence de potentiel maximale admissible entre les deux pieds est
    #let R-corps = 5e3
    #let I-seuil = 25e-3
    #let V-max = R-corps * I-seuil
    $
        V_"max" = R_"corps" I_"seuil" = #qty(125, "V")
    $

    La distance typique entre les deux pieds est d'environ $d=#qty("0.3", "m")$.

    Dans le pire des cas, les pieds sont l'un derrière l'autre : leurs coordonnées $r$ sont séparées de $d$. On a donc
    $
        V(r) - V(r + d) & = I/(2 pi gamma) (1/r - 1/(r + d)) \
                        & = I/(2 pi gamma) (d/(r (r + d)))
    $
    En imposant que cette différence de potentiel soit inférieure à $V_"max"$, on trouve
    $
                                   r (r + d) & >= I d/(2 pi gamma V_"max") \
        r^2 + d r - I d/(2 pi gamma V_"max") & >= 0
    $

    Les racines sont
    $r = (-d plus.minus sqrt(d^2 + 4 I d/(2 pi gamma V_"max")))/2$
    La solution positive est 
    #let d = 0.3
    #let r-min = (-d + calc.sqrt(d*d + 4 * I * d / (2 * calc.pi * gamma-sol * V-max))) / 2
    $ r_"min" = (-d + sqrt(d^2 + 4 I d/(2 pi gamma V_"max")))/2 = #qty(scientifique(r-min, 2), "m") $

    Selon ce modèle, il faudrait se tenir à plus de #qty(scientifique(r-min, 2), "m") de la demi-sphère. Sur la photo, la distance est beaucoup plus faible. Cela peut s'expliquer par le fait que l'étude a été faite en régime stationnaire, ce qui n'est pas le cas pour un éclair.
]
