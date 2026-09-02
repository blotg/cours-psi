#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Voilier au près",
    explique: true,
)

#figure(
    image("images/allures.svg", width: 5cm),
)

#question(
    coups-de-pouce: (
        "Faire un schéma en faisant apparaître les forces en présence sur le voilier.",
    )
)[
    Les voiliers sont capables de remonter au vent. Expliquer comment c'est possible.
][
    Un voilier a une voile en contact de l'air et une dérive, une quille ou la coque en contact avec l'eau.

    Quand une aile d'avion ou une voile de bateau est dans un écoulement d'air ou d'eau, elle est soumise à deux forces principales : la portance, perpendiculaire à la direction de l'écoulement, et la traînée, dans la direction de l'écoulement.

    Le voilier est soumis à quatre forces horizontales : les forces de portance et de traînée exercées par le vent sur la voile, et les forces de portance et de traînée exercées par l'eau sur la dérive.

    #figure(
        canvas({
            import cetz.draw: *
            scale(200%)
            group({
                rotate(45deg)
                bezier((0, 3), (.5, 0), (rel: (-45deg, 1), to: (0, 3)), (.5, 0.5))
                bezier((0, 3), (-.5, 0), (rel: (-135deg, 1), to: (0, 3)), (-.5, 0.5))
                line((-.5, 0), (.5, 0))
                bezier((0, .7), (0, .7), (rel: (80deg, 1.), to: (0, .7)), (rel: (100deg, 1), to: (0, .7)), fill: gray)
                bezier(
                    (0, 2),
                    (-.7, .5),
                    (rel: (-150deg, .5), to: (0, 2)),
                    (rel: (-260deg, .5), to: (-.7, .5)),
                    stroke: (thickness: 3pt),
                )
                line((0, 3), (rel: (110deg, .8)), mark: (end: ">>", fill: black))
                content((), "vitesse du voilier", anchor: "south", padding: .4em)
                line((0, 1.1), (rel: (110deg, -.5)), mark: (end: ">>", fill: black))
                content((), "trainée dérive", anchor: "west", padding: .4em)
                line((0, 1.1), (rel: (2000deg, -1)), mark: (end: ">>", fill: black))
                content((), "portance dérive", anchor: "west", padding: .4em)
            })
            line((-1.35, .6), (rel: (-1, 0)), mark: (end: ">>", fill: black))
            content((), "portance voile", anchor: "east", padding: .4em)
            line((-1.35, .6), (rel: (0, -.5)), mark: (end: ">>", fill: black))
            content((), "trainée voile", anchor: "east", padding: .4em)
        }),
    )

    Même si le vent pousse le voilier vers l'arrière, la portance de la dérive compense en partie cette force.
]
