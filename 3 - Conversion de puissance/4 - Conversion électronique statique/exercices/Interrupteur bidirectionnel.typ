#import "@local/prepa:0.1.0": *

#show: exercice.with(
    titre: "Interrupteur bidirectionnel.",
)

On étudie un interrupteur bidirectionnel constitué d'une diode et d'un transistor tous deux considérés idéaux.

#figure(
    zap.circuit({
        import zap: *
        diode("D", (2, 0), (0, 0), i:(content: $i_D$, anchor: "west"), u:$u$)
        thyristor("Q", (0, 1), (2, 1), i:$i_T$)
        wire((0, 0), (0, 1))
        wire((2, 0), (2, 1))
        wire((-1, 0.5), (0, 0.5), i: $i$)
        wire((2, 0.5), (3, 0.5))
    }),
)

#question(
    coups-de-pouce: (
        "Refaire le schéma en prenant en compte le fait que le transistor est bloqué.",
    ),
)[
    Lorsque le transistor est bloqué, tracer la caractéristique de l'interrupteur bidirectionnel.
][
    Lorsque le transistor est bloqué, $i_T = 0$. L'interrupteur bidirectionnel se comporte comme une diode idéale en convention inverse. Sa caractéristique est donc :
    #figure(
            canvas({
                import draw: *
                line((-1, 0), (1, 0), mark: (end: ">>", fill: black))
                content((), $u$, anchor: "north", padding: 0.4em)
                line((0, -1), (0, 1), mark: (end: ">>", fill: black))
                content((), $i$, anchor: "east", padding: 0.4em)
                line( (-1,0), (0,0), (0,-1), stroke: (paint: red,thickness: 3pt))
            }),
        )
]

#question(
    coups-de-pouce: (
        "Quel valeurs peuvent prendre $i_T$ lorsque le transistor est passant ? Même question pour $i_D$.",
        "Quel valeurs peuvent prendre $u$ lorsque le transistor est passant ? Même question pour la diode.",
    ),
)[
    Lorsque le transistor est passant, tracer la caractéristique de l'interrupteur bidirectionnel.
][
    Lorsque le transistor est passant, un courant $i_T>=0$ peut y circuler. Un courant $i_D<=0$ peut également circuler dans la diode.
    
    La caractéristique d'un transistor passant impose $u>=0$, alors que celle d'une diode en convention inverse impose $u<=0$. Il s'ensuit que $u=0$.

    L'interrupteur bidirectionnel se comporte alors comme un fil. Sa caractéristique est donc :
    #figure(
            canvas({
                import draw: *
                line((-1, 0), (1, 0), mark: (end: ">>", fill: black))
                content((), $u$, anchor: "north", padding: 0.4em)
                line((0, -1), (0, 1), mark: (end: ">>", fill: black))
                content((), $i$, anchor: "east", padding: 0.4em)
                line( (0,0.7), (0,0), (0,-1), stroke: (paint: red,thickness: 3pt))
            }),
        )
]

#question(
    coups-de-pouce: ()
)[
    Justifier le nom d'interrupteur bidirectionnel.
][
    L'interrupteur bidirectionnel peut laisser passer un courant dans les deux sens (bidirectionnel) lorsqu'il est passant.
]