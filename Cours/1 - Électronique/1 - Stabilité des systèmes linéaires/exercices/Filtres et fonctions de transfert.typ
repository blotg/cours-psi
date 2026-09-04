#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Filtres et fonctions de transfert",
)

#question(
    coups-de-pouce: (
        "Proposer un circuit avec un résistor et un condensateur et un autre avec un résistor et une bobine.",
        "Utiliser les équivalents haute et basse fréquence pour savoir comment les agencer.",
    ),
)[
    Proposer deux circuits électroniques différents réalisant un filtre passe-haut du premier ordre.
][
    On propose un premier circuit composé d'un condensateur et d'un résistor.

    #figure(zap.circuit({
        import zap: *
        import cetz.draw: *

        capacitor("C", (0, 0), (3, 0), label: $C$)
        resistor("R", (3, 0), (3, -3), label: (content: $R$, anchor: "south"))
        wire((3, -3), (0, -3))
        line((0, -2.9), (0, -0.1), mark: (end: ">", fill: black), name: "e")
        content("e", $e(t)$, anchor: "east", padding: .2em)
        line((3.6, -2.9), (3.6, -0.1), mark: (end: ">", fill: black), name: "s")
        content("s", $s(t)$, anchor: "west", padding: .2em)
    }))

    On vérifie en étudiant les équivalents haute et basse fréquence que ce circuit est bien un filtre passe-haut.

    / En haute fréquence: le condensateur se comporte comme un court-circuit et le signal de sortie est donc égal au signal d'entrée.

    / En basse fréquence: le condensateur se comporte comme un circuit ouvert, aucun courant ne parcourt le résistor et la tension à ses bornes $R times i$ est donc nulle.

    #columns(2)[
        *Haute fréquence*
        #figure(zap.circuit({
            import zap: *
            import cetz.draw: *

            wire((0, 0), (3, 0))
            resistor("R", (3, 0), (3, -3), label: (content: $R$, anchor: "south"))
            wire((3, -3), (0, -3))
            line((0, -2.9), (0, -0.1), mark: (end: ">", fill: black), name: "e")
            content("e", $e(t)$, anchor: "east", padding: .2em)
            line((3.6, -2.9), (3.6, -0.1), mark: (end: ">", fill: black), name: "s")
            content("s", $s(t) = e(t)$, anchor: "west", padding: .2em)
        }))

        #colbreak()
        *Basse fréquence*
        #figure(zap.circuit({
            import zap: *
            import cetz.draw: *

            switch("C", (0, 0), (3, 0))
            resistor("R", (3, 0), (3, -3), label: (content: $R$, anchor: "south"))
            wire((3, -3), (0, -3))
            line((0, -2.9), (0, -0.1), mark: (end: ">", fill: black), name: "e")
            content("e", $e(t)$, anchor: "east", padding: .2em)
            line((3.6, -2.9), (3.6, -0.1), mark: (end: ">", fill: black), name: "s")
            content("s", $s(t) = 0$, anchor: "west", padding: .2em)
        }))
    ]

    On propose un second circuit composé d'une bobine et d'un résistor.

    #figure(zap.circuit({
        import zap: *
        import cetz.draw: *

        resistor("R", (0, 0), (3, 0), label: $R$)
        inductor("L", (3, 0), (3, -3), label: (content: $L$, anchor: "south"))
        wire((3, -3), (0, -3))
        line((0, -2.9), (0, -0.1), mark: (end: ">", fill: black), name: "e")
        content("e", $e(t)$, anchor: "east", padding: .2em)
        line((3.6, -2.9), (3.6, -0.1), mark: (end: ">", fill: black), name: "s")
        content("s", $s(t)$, anchor: "west", padding: .2em)
    }))

    On vérifie en étudiant les équivalents haute et basse fréquence que ce circuit est bien un filtre passe-haut.
    / En haute fréquence: la bobine se comporte comme un interrupteur ouvert, aucun courant ne parcourt le résistor et la tension à ses bornes $R times i$ est donc nulle. Il en resulte que le signal de sortie est égal à celui d'entrée.
    / En basse fréquence: la bobine se comporte comme un fil, la tension à ses bornes (c'est-à-dire la tension de sortie) est nulle.

    #columns(2)[
        *Haute fréquence*
        #figure(zap.circuit({
            import zap: *
            import cetz.draw: *

            resistor("R", (0, 0), (3, 0), label: $R$)
            switch("L", (3, 0), (3, -3), label: (content: $L$, anchor: "south"))
            wire((3, -3), (0, -3))
            line((0, -2.9), (0, -0.1), mark: (end: ">", fill: black), name: "e")
            content("e", $e(t)$, anchor: "east", padding: .2em)
            line((3.6, -2.9), (3.6, -0.1), mark: (end: ">", fill: black), name: "s")
            content("s", $s(t)=e(t)$, anchor: "west", padding: .2em)
        }))

        #colbreak()
        *Basse fréquence*
        #figure(zap.circuit({
            import zap: *
            import cetz.draw: *

            resistor("R", (0, 0), (3, 0), label: $R$)
            wire((3, 0), (3, -3))
            wire((3, -3), (0, -3))
            line((0, -2.9), (0, -0.1), mark: (end: ">", fill: black), name: "e")
            content("e", $e(t)$, anchor: "east", padding: .2em)
            line((3.6, -2.9), (3.6, -0.1), mark: (end: ">", fill: black), name: "s")
            content("s", $s(t) = 0$, anchor: "west", padding: .2em)
        }))
    ]

]

#question(
    coups-de-pouce: (
        "Utiliser la forme canonique (connue) de la fonction de transfert d'un filtre passe-bas d'ordre 1.",
        "Utiliser l'analyse dimensionnelle pour écrire une expression homogène.",
    ),
)[
    Donner (sans les redémontrer) les fonctions de transfert des ces deux circuits.
][
    Les fonctions de transfert sont
    $
        underline(H)(j omega) = (j omega R C) / (1 + j omega R C) text(" pour le circuit RC, et")
    $
    $
        underline(H)(j omega) = (j omega L / R) / (1 + j omega L / R) text(" pour le circuit RL.")
    $
]

#question()[
    Ces deux circuits sont-ils stables ?
][
    Les dénominateurs de fonctions de transfert ne comportent que des coefficients positifs, donc les deux circuits sont stables.

    *Remarque :* les circuits passifs sont toujours stables.
]
