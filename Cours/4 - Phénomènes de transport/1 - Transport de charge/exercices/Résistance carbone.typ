#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Résistance à film de carbone",
    ouvert: true,
    difficulté: 2,
)

Les résistances à film de carbone (qui sont celles utilisées en travaux pratiques) sont constituées d'un cylindre en céramique recouvert d'un film de graphite ($gamma = #qty("2e4", "S/m")$) de #qty("200", "um") d'épaisseur, découpé spirale. Le pas de la spirale est ajusté pour obtenir la résistance désirée.

#grid(
    columns: (1fr, 1fr),
    image("images/résistance carbone.jpg", width: 100%), image("images/résistance échelle.jpg", width: 100%),
)


#question(
    coups-de-pouce: (
        "Exprimer la résistance en fonction de la résistivité, de la longueur et de la section.",
        "Exprimer la longueur de la spirale en fonction du pas, du rayon et de la hauteur du cylindre.",
    ),
)[
    Quel pas la spirale doit-elle avoir pour obtenir une résistance de #qty("1", "kO") ?
][
    #let r = 4e-3
    #let h = 16e-3
    #let e = 200e-6
    #let gamma-gr = 2e4
    #let R = 1e3
    #let l = calc.sqrt((2 * calc.pi * r * h) / (e * R * gamma-gr))

    Le résistor a une longueur $h = #qty("16", "mm")$ et un raton $r = #qty("4", "mm")$.

    La spirale déroulée sera un parallélépipède de largeur $l$ et de longueur $L$. La surface reste la même une fois déroulée donc $e L = 2 pi r h$. On en déduit que $L = (2 pi r h)/l$.

    La résistance est $R = L/(e l gamma) = (2 pi r h)/(e l^2 gamma)$ d'où
    $ l = sqrt((2 pi r h)/(e R gamma)) = #qty(scientifique(l, 1), "m") $
]
