#import "@local/prepa:0.1.0": *

#show: exercice.with(
    titre: "Dépôt de nickel",
)

En aéronautique, on envisage de fabriquer des ailes d’avion en matériau composite. Pour éviter toute détérioration à la traversée des zones très orageuses, il est nécessaire que celui-ci soit un conducteur électrique. Un des procédés à l’étude consiste à réaliser un dépôt de nickel par décomposition thermique du nickel carbonyle, suivant la réaction d’équation :
$ ce("Ni(CO)4 (g) = Ni (s) + 4 CO (g)") $

On appelle $alpha = xi/xi_"max"$ le coefficient de dissociation du nickel carbonyle gazeux à l’équilibre, aussi le taux d’avancement de la réaction.

#let DrH = -111e3 * 4 + 602e3
#let DrS = 30 + 198 * 4 - 409
#question(
    coups-de-pouce: "Utiliser la loi de Hess.",
)[
    Calculer l’enthalpie standard de réaction $Delta_r H^0$ et l’entropie standard de réaction  $Delta_r S^0$ à #qty("298", "K"). Commenter leur signe.
][
    D'après la loi de Hess,
    $
        Delta_r H^circ = Delta_f H^circ (ce("Ni (s)")) + 4 Delta_f H^circ (ce("CO (g)")) - Delta_f H^circ (ce("Ni(CO)4 (g)"))
        = #qty(scientifique(DrH, 2), "J/mol")
    $
    car $Delta_f H^circ (ce("Ni (s)")) = 0$ car c'est un corps simple dans son état standard.

    $Delta_r H^circ > 0$ donc la réaction est endothermique.

    De même,
    $
        Delta_r S^circ = S^circ_m (ce("Ni (s)")) + 4 S^circ_m (ce("CO (g)")) - S^circ_m (ce("Ni(CO)4 (g)"))
        = #qty(scientifique(DrS, 2), "J/K/mol")
    $

    $Delta_r S^circ > 0$ donc l'entropie augmente au cours de la réaction, ce qui est cohérent avec le fait que la quantité de matière de gaz (état de la matière désordonné) augmente.
]

#question(
    coups-de-pouce: "Quelle est la définition de l'enthalpie libre ? En déduire une relation entre $Delta_r G^circ$, $Delta_r H^circ$, $Delta_r S^circ$ et $T$.",
)[
    Exprimer l'enthalpie libre standard de réaction en fonction de l'enthalpie standard de réaction, de l'entropie standard de réaction et de la température.
][
    $G = H - T S$
    D'où, en dérivant par rapport à l'avancement et en se plaçant dans les conditions standards
    $
        Delta_r G^circ = Delta_r H^circ - T Delta_r S^circ
    $
]

#question(
    coups-de-pouce: (
        "Faire un tableau d'avancement.",
        "Écrire la loi de Guldberg et Waage.",
        "Quelle relation existe-t-il entre la constante d'équilibre et l'enthalpie libre de réaction ?",
        "L'activité d'un gaz est égal à sa pression partielle divisé par la pression standard.",
        "La pression partielle est la pression du gaz multiplié par la fraction molaire $P_i=P n_i / n_\"tot,gaz\"$",
    ),
)[
    Établir une relation entre $alpha$, la constante d'équilibre $K^circ (T)$ et la pression totale $P$.
][
    En effectuant un tableau d'avancement, on trouve les expressions des quantités de matière à l'équilibre
    #table(
        columns: 6,
        align: (left,) + (center,) * 5,
        stroke: none,
        [], ce("Ni(CO)4 (g)"), ce("->"), ce("Ni (s)"), ce("+"), ce("4 CO (g)"),
        table.hline(),
        [État initial], $n$, [], $0$, [ ], $0$,
        table.hline(),
        [État final], $n-xi$, [], $xi$, [ ], $4 xi$,
    )
    L'avancement final vaut $xi_"max" = n$, donc $xi = alpha n$. Les quantités de matière à l'équilibre s'écrivent donc
    #table(
        columns: 7,
        align: (left,) + (center,) * 6,
        stroke: none,
        [], ce("Ni(CO)4 (g)"), ce("->"), ce("Ni (s)"), ce("+"), ce("4 CO (g)"), [Total des gaz],
        table.hline(),
        [État final], $n(1-alpha)$, [], $n alpha$, [ ], $4 n alpha$, $n (1 + 3 alpha)$,
    )

    La loi de Guldberg et Waage s'écrit
    $
        K^circ (T) = (a_ce("Ni (s)") a_ce("CO (g)")^4) /a_ce("Ni(CO)4 (g)")
        = P_ce("CO")^4 / (P_ce("Ni(CO)4") (P^circ)^3)
        = ( ((4 n alpha) / (n (1 + 3 alpha)) )^4 ) / ( (n (1 - alpha)) / (n (1 + 3 alpha)) ) (P/P^circ)^3
        = ((4 alpha) / (1 + 3 alpha) )^4 (1 +3 alpha) / (1 - alpha) (P/P^circ)^3
    $
]

#question()[
    À quelle température doit-on opérer pour avoir un coefficient de dissociation $alpha = #num("0,05")$ sous la pression totale $P = qty("1", "bar")$ ?
    Même question pour $alpha = #num("0,95")$.

    Comparer ces valeurs au regard du signe de l'enthalpie de réaction.
][
    On a
    $
        Delta_r G^circ = - R T ln(K^circ (T))
    $
    d'où
    $
        Delta_r H^circ - T Delta_r S^circ = - R T ln(((4 alpha) / (1 + 3 alpha) )^4 (1 +3 alpha) / (1 - alpha) (P/P^circ)^3)
    $
    En isolant $T$, on trouve
    $
        T = (Delta_r H^circ) / (Delta_r S^circ - R ln(((4 alpha) / (1 + 3 alpha) )^4 (1 +3 alpha) / (1 - alpha) (P/P^circ)^3))
    $
    #let R = 8.314
    #let a = 0.05
    #let T1 = DrH / (DrS - R * calc.ln(calc.pow((4 * a) / (1 + 3 * a), 4) * (1 + 3 * a) / (1 - a)))
    Pour $alpha = #num("0,05")$, on trouve $T approx #qty(scientifique(T1, 2), "K")$.

    #let a = 0.95
    #let T2 = DrH / (DrS - R * calc.ln(calc.pow((4 * a) / (1 + 3 * a), 4) * (1 + 3 * a) / (1 - a)))
    Pour $alpha = #num("0,95")$, on trouve $T approx #qty(scientifique(T2, 2), "K")$.

    La réaction est endothermique, son équilibre est donc déplacé dans le sens direct en augmentant la température, ce qui est cohérent avec le fait que le coefficient de dissociation augmente avec la température.
]

* Données à #qty("298", "K")*
#table(
    columns: 4,
    align: (left,) + (center,) * 3,
    [Espèces chimiques], ce("Ni(CO)_4(g)"), ce("Ni(s)"), ce("CO(g)"),
    [$Delta_f H^circ$ (#unit("kJ/mol"))], num("-602"), [], num("-111"),
    [$S^circ_m$ (#unit("J/K/mol"))], num("409"), num("30"), num("198"),
)
