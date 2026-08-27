#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Modulation d'amplitude",
)

// Allure (non symétrique, plus réaliste qu'une simple bosse) d'un spectre de type "signal audio",
// nulle en u=0 et u=1 : un mélange d'harmoniques impaires et paires casse la symétrie en u=1/2.
#let audio-shape(u) = calc.max(
    0,
    1.2*calc.sin(calc.pi * u) + 0.5 * calc.sin(2 * calc.pi * u) - 0.4 * calc.sin(4 * calc.pi * u),
)

On cherche à transmettre un signal audio par ondes électromagnétiques.

#question()[
    À quelle plage de fréquences correspond le domaine audible ?
][
    Le domaine audible correspond à $f in [qty("20", "Hz"); qty("20", "kHz")]$.
]

Pour émettre et recevoir une onde électromagnétique, il est nécessaire d'avoir une antenne dont la taille est une demi longueur d'onde.

#question(
    coups-de-pouce: (
        "L'onde transmise est-elle une onde électromagnétique ou une onde sonore ? Quelle est la célérité d'une telle onde ?",
        "Quelles sont les fréquences comprises dans un signal audio ?",
    ),
)[
    Calculer la taille de l'antenne qui serait nécessaire sans modulation.
][
    Ces fréquences correspondent à des longueurs d'onde
    $
        lambda = c/f = (3 times 10^8)/20 approx qty("15000", "km") "(pour " qty("20", "Hz") ")"
    $
    $
        lambda = (3 times 10^8)/(20 times 10^3) approx qty("15", "km") "(pour " qty("20", "kHz") ")"
    $
    Il faudrait donc une antenne de #qty("15000", "km") !
]

On module le signal $v_e (t)$ (appelé signal modulant) en amplitude avec la porteuse $v_p (t) = A_p cos(2 pi f_p t)$ avant de l'émettre. La modulation peut se schématiser ainsi :

#figure(
    canvas({
        import draw: *
        set-style(stroke: .5pt)
        rect((0, -1), (3.4, 1), name: "M")
        content("M", align(center, [Multiplieur \ $(s=k times e_1 times e_2)$]))
        rect((6, -1.6), (9.4, 0.4), name: "S")
        content("S", align(center, [Sommateur \ $(s=e_1+e_2)$]))

        line((-2.5, .6), (0, .6), mark: (end: ">>", fill: black))
        content((-2.5, .6), $v_e (t)$, anchor: "east", padding: .4em)
        line((-2.5, -.6), (0, -.6), mark: (end: ">>", fill: black))
        content((-2.5, -.6), $v_p (t)$, anchor: "east", padding: .4em)
        circle((-1.5, -.6), radius: .05, fill: black)

        line("M.east", ("M.east" ,"-|", "S.west"), mark: (end: ">>", fill: black))
        line((-1.5, -.6), (-1.5, -1.3), (6, -1.3), mark: (end: ">>", fill: black))

        line((9.4, -.6), (11.5, -.6), mark: (end: ">>", fill: black))
        content((11.5, -.6), $v_s (t)$, anchor: "west", padding: .4em)
    }),
)

Pour démoduler correctement le signal, il ne faut pas que son enveloppe s'annule.

#question()[
    Exprimer $v_s (t)$ en fonction de $v_e (t)$ et $v_p (t)$.
][
    D'après le schéma, $v_s$ est la somme de $v_p$ et du produit de $v_e$ et $v_p$ (multiplié par $k$) :
    $
        v_s (t) = v_p (t) + k v_e (t) v_p (t)
    $
]

#question(
    coups-de-pouce: (
        "Tracer l'allure du signal modulé en fonction du temps.",
        "Que valent le maximum et le minimum de l'enveloppe du signal modulé ?",
    ),
)[
    Dans le cas où $v_e (t)$ est sinusoïdal ($v_e (t) = A_e cos(2 pi f_e t)$), quelle valeur faut-il choisir pour $k$ ?
][
    $
        v_s (t) = A_p cos(2 pi f_p t) + k A_p cos(2 pi f_p t) A_e cos(2 pi f_e t) = A_p cos(2 pi f_p t) [1+k A_e cos(2 pi f_e t)]
    $
    Deux cas se présentent, selon que $k A_e$ est inférieur ou supérieur à $1$ :

    #figure(
        grid(
            columns: 2,
            column-gutter: 1em,
            canvas({
                draw.set-style(axes: (shared-zero: false))
                plot.plot(
                    size: (6, 3.2),
                    axis-style: "school-book",
                    x-tick-step: none,
                    y-tick-step: none,
                    x-min: 0,
                    x-max: 2,
                    y-min: -1.6,
                    y-max: 1.6,
                    y-ticks: ((0.7, $1-k A_e$), (1.3, $1+k A_e$)),
                    x-label: $t$,
                    {
                        plot.add(
                            t => calc.cos(2 * calc.pi * 20 * t) * (1 + 0.3 * calc.cos(2 * calc.pi * t)),
                            domain: (0, 2),
                            samples: 1600,
                        )
                        plot.add(
                            t => 1 + 0.3 * calc.cos(2 * calc.pi * t),
                            domain: (0, 2),
                            samples: 400,
                            style: (stroke: red),
                        )
                    },
                )
            }),
            canvas({
                draw.set-style(axes: (shared-zero: false))
                plot.plot(
                    size: (6, 3.2),
                    axis-style: "school-book",
                    x-tick-step: none,
                    y-tick-step: none,
                    x-min: 0,
                    x-max: 2,
                    y-min: -2.6,
                    y-max: 2.6,
                    y-ticks: ((-0.3, $1-k A_e$), (2.3, $1+k A_e$)),
                    x-label: $t$,
                    {
                        plot.add(
                            t => calc.cos(2 * calc.pi * 20 * t) * (1 + 1.3 * calc.cos(2 * calc.pi * t)),
                            domain: (0, 2),
                            samples: 1600,
                        )
                        plot.add(
                            t => 1 + 1.3 * calc.cos(2 * calc.pi * t),
                            domain: (0, 2),
                            samples: 400,
                            style: (stroke: red),
                        )
                    },
                )
            }),
        ),
        caption: [À gauche $k A_e<1$ (signal non surmodulé), à droite $k A_e>1$ (signal surmodulé).],
    )

    Si $k A_e<1$, la modulante $1+k A_e cos(2 pi f_e t)$ est toujours positive : elle est bien égale à l'enveloppe du signal modulé, qui ne s'annule jamais. Si $k A_e > 1$, la modulante peut devenir négative : l'enveloppe réelle du signal (toujours positive) ne coïncide plus avec la modulante, et le signal est surmodulé.

    On peut donc démoduler le signal de façon non ambigüe si $k < 1/A_e$.
]

#question(
    coups-de-pouce: (
        "Linéariser l'expression de $v_s (t)$. Chaque terme de la somme correspond à un « pic » sur le spectre.",
    ),
)[
    Toujours pour $v_e$ sinusoïdal, tracer le spectre du signal modulé $v_s (t)$ dans ce cas particulier.
][
    En linéarisant le produit de cosinus,
    $
        v_s (t) = A_p cos(2 pi f_p t) + (k A_e A_p)/2 [cos(2 pi (f_p+f_e) t) + cos(2 pi (f_p - f_e) t)]
    $
    Le spectre de $v_s$ comporte donc 3 raies : une raie à $f_p$ d'amplitude $A_p$, et deux raies latérales à $f_p - f_e$ et $f_p+f_e$, d'amplitude $(k A_e A_p)/2$.

    #figure(
        canvas({
            plot.plot(
                size: (8, 4),
                axis-style: "left",
                x-tick-step: none,
                y-tick-step: none,
                x-min: 0,
                x-max: 6,
                y-min: 0,
                y-max: 3,
                x-label: $f$,
                y-label: [Amplitude],
                {
                    plot.annotate(resize: false, {
                        import draw: *
                        line((3, 0), (3, 2.5), mark: (end: ">>", fill: red), stroke: red)
                        line((1.7, 0), (1.7, 1), mark: (end: ">>", fill: red), stroke: red)
                        line((4.3, 0), (4.3, 1), mark: (end: ">>", fill: red), stroke: red)
                        content((0, 2.5), $A_p$, anchor: "east", padding: .2em)
                        content((0, 1), $(k A_e A_p)/2$, anchor: "east", padding: .2em)
                        content((1.7, 0), $f_p - f_e$, anchor: "north", padding: .2em)
                        content((3, 0), $f_p$, anchor: "north", padding: .2em)
                        content((4.3, 0), $f_p + f_e$, anchor: "north", padding: .2em)
                    })
                },
            )
        }),
    )
]

#question(
    coups-de-pouce: (
        "Quelles sont les fréquences comprises dans un signal audio ?",
    ),
)[
    On suppose maintenant que $v_e (t)$ est un signal audio. Tracer un spectre possible de $v_e$. Tracer alors le spectre de $v_s$ en prenant $f_p = qty("520", "kHz")$.
][
    Le spectre de $v_e$ occupe la bande audio, entre #qty("20", "Hz") et #qty("20", "kHz") :

    #figure(
        canvas({
            plot.plot(
                size: (6, 2.5),
                axis-style: "left",
                x-tick-step: none,
                y-tick-step: none,
                x-min: 0,
                x-max: 6,
                y-min: 0,
                y-max: 2,
                x-label: $f "(kHz)"$,
                {
                    plot.add(
                        f => audio-shape((f - 0.5) / 4),
                        domain: (0.5, 4.5),
                        samples: 200,
                        style: (stroke: red),
                    )
                    plot.annotate(resize: false, {
                        import draw: *
                        content((0.5, 0), num("20"), anchor: "north", padding: .2em)
                        content((4.5, 0), num("20000"), anchor: "north", padding: .2em)
                    })
                },
            )
        }),
        caption: [Spectre (schématique) du signal audio $v_e$.],
    )

    Le spectre de $v_s$ comporte alors, en plus de la raie à $f_p=qty("520","kHz")$, deux bandes latérales, images du spectre de $v_e$, entre #qty("500", "kHz") et #qty("520", "kHz") d'une part, et entre #qty("520", "kHz") et #qty("540", "kHz") d'autre part :

    #figure(
        canvas({
            plot.plot(
                size: (10, 3),
                axis-style: "left",
                x-tick-step: none,
                y-tick-step: none,
                x-min: 0,
                x-max: 6,
                y-min: 0,
                y-max: 3,
                x-label: $f "(kHz)"$,
                {
                    // bande latérale basse : image inversée en fréquence du spectre de v_e
                    plot.add(
                        f => audio-shape((3 - f) / 2),
                        domain: (1, 3),
                        samples: 200,
                        style: (stroke: red),
                    )
                    // bande latérale haute : copie directe du spectre de v_e
                    plot.add(
                        f => audio-shape((f - 3) / 2),
                        domain: (3, 5),
                        samples: 200,
                        style: (stroke: red),
                    )
                    plot.annotate(resize: false, {
                        import draw: *
                        line((3, 0), (3, 2.5), mark: (end: ">>", fill: red), stroke: red)
                        content((0, 2.5), $A_p$, anchor: "east", padding: .2em)
                        content((1, 0), $500$, anchor: "north", padding: .2em)
                        content((3, 0), $520$, anchor: "north", padding: .2em)
                        content((5, 0), $540$, anchor: "north", padding: .2em)
                    })
                },
            )
        }),
        caption: [Spectre de $v_s$ : la porteuse à #qty("520", "kHz") entourée des deux bandes latérales.],
    )
]

#question(
    coups-de-pouce: (
        "À partir de la question précédente, quel « espace » prend un canal ?",
    ),
)[
    Les ondes moyennes s'étendent de #qty("520", "kHz") à #qty("1620", "kHz"). Combien de canaux audio peuvent être émis sur cette bande ?
][
    Le spectre de $v_s$ occupe #qty("40", "kHz") (deux fois la largeur #qty("20", "kHz") de la bande audio). Dans la bande $[520;1620]$ kHz, on peut donc faire tenir
    $
        (1620-520)/40 approx 27 "canaux"
    $
]