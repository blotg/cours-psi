#import "@local/prepa:0.1.0": *

#show: exercice.with(
    titre: "Angle de Brewster",
    difficulté: 2,
)

On étudie une OPPH électromagnétique polarisée rectilignement qui arrive sur une interface entre deux milieux d'indices de réfraction $n_1$ et $n_2$. Cette onde incidente donne naissance à une OPPH réfléchie et une OPPH transmise.

#figure(
    canvas({
        import draw: *
        line((-3, 0), (3, 0), stroke: 2pt, mark: (end: ">>", fill: black))
        content((), $x$, anchor: "south", padding: .4em)
        content((-2.5, 0), $n_1$, anchor: "south", padding: .4em)
        content((-2.5, 0), $n_2$, anchor: "north", padding: .4em)
        line((0, -2), (0, 2), stroke: (dash: "dashed"), mark: (end: ">>", fill: black, stroke: (dash: none)))
        content((), $y$, anchor: "south", padding: .4em)
        let fleche = (end: "barbed", shorten-to: none, width: 10pt, length: 10pt)
        line((135deg, 3), (0, 0), mark: fleche + (pos: 0.4))
        line((45deg, 3), (0, 0), mark: fleche + (pos: 0.9, reverse: true))
        line((-70deg, 3), (0, 0), mark: fleche + (pos: 0.9, reverse: true))
        arc((90deg, 1), start: 90deg, stop: 135deg, mark: (end: ">>", fill: black), name: "theta_i")
        arc((90deg, 1), start: 90deg, stop: 45deg, mark: (end: ">>", fill: black), name: "theta_r")
        arc((-90deg, 1), start: -90deg, stop: -70deg, mark: (end: ">>", fill: black), name: "theta_t")
        content("theta_i.mid", $theta_i$, anchor: "south", padding: .2em)
        content("theta_r.mid", $theta_r$, anchor: "south", padding: .2em)
        content("theta_t.mid", $theta_t$, anchor: "north", padding: .4em)
        line((135deg, 2), (rel: (135deg - 90deg, 1)), mark: (end: ">", fill: black))
        content((), $va(E_i)$, anchor: "south", padding: .2em)
        line((45deg, 2), (rel: (45deg + 90deg, 1)), mark: (end: ">", fill: black))
        content((), $va(E_r)$, anchor: "south", padding: .2em)
        line((-70deg, 2), (rel: (-70deg + 90deg, 1)), mark: (end: ">", fill: black))
        content((), $va(E_t)$, anchor: "south", padding: .2em)
        content((0, 0), $O$, anchor: "north-east", padding: .4em)
    }),
)

À l'interface, la composante du champ électrique tangente à l'interface et la composante du champ magnétique normale à l'interface sont continues.

On note $underline(E_i)$, $underline(E_r)$ et $underline(E_t)$ les amplitudes complexes des champs électriques de l'onde incidente, réfléchie et transmise respectivement.

On suppose que les ondes incidente, réfléchie et transmise ont la même pulsation. On fait également l'hypothèse que les ondes sont polarisées dans le plan d'incidence.

#question()[
    Montrer que les amplitudes complexes vérifient
    $
        cases(
            cos(theta_i) underline(E_i) + cos(theta_r) underline(E_r) = cos(theta_t) underline(E_t),
            n_1 cos(theta_i) underline(E_i) - n_1 cos(theta_r) underline(E_r) = n_2 cos(theta_t) underline(E_t)
        )
    $
][
    La relation de structure donne
    $
        cases(
            underline(va(B_i)) = n_1/c underline(E_i) ey,
            underline(va(B_r)) = -n_1/c underline(E_r) ey,
            underline(va(B_t)) = n_2/c underline(E_t) ey
        )
    $
    Les relations de continuité donnent
    $
        cases(
            va(E_i) dot ex + va(E_r) dot ex = va(E_t) dot ex,
            va(B_i) dot ey - va(B_r) dot ey = va(B_t) dot ey
        )
    $
    Soit
    $
        cases(
            cos(theta_i) underline(E_i) + cos(theta_r) underline(E_r) = cos(theta_t) underline(E_t),
            n_1 cos(theta_i) underline(E_i) - n_1 cos(theta_r) underline(E_r) = n_2 cos(theta_t) underline(E_t)
        )
    $
]

#question()[
    En déduire l'expression de l'amplitude complexe des ondes réfléchie et transmise en fonction de l'amplitude complexe de l'onde incidente, des indices de réfraction et des angles d'incidence, de réflexion et de transmission.
][
    En résolvant le système d'équations, on trouve
    $
        cases(
            underline(E_r) = (n_2 cos(theta_i) - n_1 cos(theta_t)) / (n_2 cos(theta_r) + n_1 cos(theta_t)) underline(E_i),
            underline(E_t) = (n_1 cos(theta_i) + n_1 cos(theta_r)) / (n_2 cos(theta_r) + n_1 cos(theta_t)) underline(E_i)
        )
    $
]

Dans la suite, on s'intéresse à l'angle d'incidence pour lequel l'onde réfléchie est d'amplitude nulle. Cet angle est appelé angle de Brewster.

#question()[
    Montrer qu'à l'angle de Brewster, on a
    $
        cases(
            cos^2(theta_t) = (n_2/n_1)^2 cos^2(theta_i),
            sin^2(theta_t) = (n_1/n_2)^2 sin^2(theta_i)
        )
    $
][
    À l'angle de Brewster, on a $underline(E_r) = 0$, soit
    $
        n_2 cos(theta_i) - n_1 cos(theta_t) = 0
    $
    d'où
    $
        cos(theta_t) = (n_2/n_1) cos(theta_i)
    $
    L'autre relation s'obtient en utilisant la relation de Snell-Descartes :
    $
        sin(theta_t) = (n_1/n_2) sin(theta_i)
    $
]

#question()[
    En déduire que l'angle de Brewster vérifie la relation
    $
        sin^2(theta_i) = n_2^2 / (n_1^2 + n_2^2)
    $
][
    En sommant les deux équations de la question précédente, on trouve
    $
        1 = (n_2/n_1)^2 cos^2(theta_i) + (n_1/n_2)^2 sin^2(theta_i)
    $
    En utilisant $cos^2(theta_i) = 1 - sin^2(theta_i)$, on obtient
    $
        1 = (n_2/n_1)^2 (1 - sin^2(theta_i)) + (n_1/n_2)^2 sin^2(theta_i)\
        sin^2(theta_i) = n_2^2 / (n_1^2 + n_2^2)
    $
]

#question()[
    En déduire l'expression de l'angle de Brewster en fonction des indices de réfraction $n_1$ et $n_2$ :
    $
        theta_i = arctan(n_2/n_1)
    $
][
    On part de $sin(theta_i) = n_2/sqrt(n_1^2 + n_2^2)$. Cette relation peut s'interpréter géométriquement.
    #figure(
        canvas({
            import draw: *
            line((0, 0), (3, 0), (3, 2), (0, 0))
            content((1.5, 0), $n_1$, anchor: "north", padding: .4em)
            content((3, 1), $n_2$, anchor: "west", padding: .4em)
            content((1.5, 1), $sqrt(n_1^2 + n_2^2)$, anchor: "south-east", padding: .4em)
            arc((1, 0), start: 0deg, stop: 33deg, mark: (end: ">>", fill: black), name: "theta_i")
            content("theta_i.mid", $theta_i$, anchor: "west", padding: .4em)
        }),
    )
    Sur la même figure, on a également la relation $tan(theta_i) = n_2/n_1$, soit
    $
        theta_i = arctan(n_2/n_1)
    $
]

On envoie de la lumière non polarisée sur l'interface à un angle d'incidence égal à l'angle de Brewster.

#question()[
    Expliquer pourquoi la lumière réfléchie est polarisée rectilignement.
][
    La lumière non polarisée peut être vue comme la superposition de deux ondes électromagnétiques polarisées rectilignement, l'une dans le plan d'incidence et l'autre perpendiculaire au plan d'incidence. À l'angle de Brewster, l'onde polarisée dans le plan d'incidence est totalement transmise, tandis que l'onde polarisée perpendiculairement au plan d'incidence est partiellement réfléchie. Ainsi, la lumière réfléchie est polarisée rectilignement dans la direction perpendiculaire au plan d'incidence.
]

#figure(
    image("/images/Brewster.jpg", width: 18cm),
    caption: "Sur la photo de gauche, aucun filtre n'est présent sur l'objectif de l'appareil photo. Sur la photo de droite, un filtre polarisant est présent sur l'objectif de l'appareil photo."
)

#question()[
    Quelle est la direction du filtre polarisant sur la photo de droite ? Justifier votre réponse.
][
    Le plan d'incidence est horizontal.

    La composante de la lumière polarisée dans le plan d'incidence n'est pas réfléchie. La lumière réfléchie est donc polarisée perpendiculairement au plan d'incidence, c'est-à-dire verticalement.

    Le filtre polarisant coupe cette lumière réfléchie, il est donc orienté horizontalement.
]
