#import "@local/prepa:0.1.1": *

// Un peu nul ... A retravailler ou abandonner


#show: exercice.with(
    titre: "Conception d'un Thérémine",
    ouvert: true,
    difficulté: 3,
)

Un Thérémine est un instrument de musique électronique produisant un son dont la fréquence dépend de la distance entre l'instrument et la main du joueur.

Les Thérémines analogiques sont constitués de deux oscillateurs identiques. La capacité d'un des oscillateurs est reliée à une antenne et voit donc sa valeur changer faiblement (variation de l'ordre de #qty("10", "pF")) lorsque la main s'approche. Les signaux des deux oscillateurs sont combinés pour produire un signal sonore dont la fréquence change entre $0$ et #qty("2", "kHz") en fonction de la position de la main.

#question()[
    Proposer un montage permettant de réaliser un Thérémine comportant des ALI, résistors, condensateurs et multiplieur. Les valeurs des résistances et capacités seront portées sur le schéma du montage et seront choisies parmi les valeurs réalistes utilisables en TP.
][
    On reprend le principe étudié dans l'exercice « Thérémine » : deux oscillateurs à relaxation identiques, l'un des deux ayant sa capacité modifiée par une antenne, dont les sorties sont envoyées dans un multiplieur puis dans un filtre passe-bas pour isoler la fréquence de battement.

    #figure(
        canvas({
            import cetz.draw: *
            set-style(stroke: .5pt)

            rect((0, 3), (5, 6), name: "O1")
            content("O1", align(center, [Oscillateur à relaxation \ $R_a$, $R_b$, $R$, $C_1$]))
            rect((0, -1), (5, 2), name: "O2")
            content("O2", align(center, [Oscillateur à relaxation \ $R_a$, $R_b$, $R$, $C_1$ + antenne]))

            circle((7.5, 2.5), radius: .6, name: "M")
            content("M", $times$)
            line("O1.east", (rel: (.6, 0)), "M.west", mark: (end: ">>", fill: black))
            line("O2.east", (rel: (.6, 0)), "M.west", mark: (end: ">>", fill: black))

            rect((9, 1.5), (12.5, 3.5), name: "F")
            content("F", align(center, [Filtre RC \ passe-bas]))
            line("M.east", "F.west", mark: (end: ">>", fill: black))

            line("F.east", (rel: (2, 0)), mark: (end: ">>", fill: black))
            content((rel: (2, 0), to: "F.east"), [vers \ haut-parleur], anchor: "west", padding: .3em)
        }),
    )

    On choisit, comme dans l'exercice « Thérémine », $R_a=qty("1","kO")$, $R_b=qty("2","kO")$ et $R=qty("100","kO")$ pour les deux oscillateurs, ainsi que $C_1 approx qty("160","pF")$ (valeur réaliste, bien qu'un peu faible, obtenue à l'exercice « Thérémine » pour une variation de fréquence de sortie entre $0$ et #qty("2", "kHz")). Le filtre passe-bas final doit avoir une fréquence de coupure grande devant #qty("2", "kHz") (pour ne pas couper le signal utile) mais petite devant la fréquence des oscillateurs eux-mêmes (plusieurs dizaines de kHz), par exemple $R'=qty("1","kO")$ et $C'=qty("10","nF")$ ($f_c approx qty("16","kHz")$).
]
