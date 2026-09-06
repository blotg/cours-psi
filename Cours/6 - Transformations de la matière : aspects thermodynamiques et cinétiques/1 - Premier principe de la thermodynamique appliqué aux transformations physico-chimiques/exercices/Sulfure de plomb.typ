#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Température de flamme du sulfure de plomb",
)
On s’intéresse ici à la réaction de grillage du sulfure de plomb #ce("PbS(s)"). Il s’agit de la réaction de combustion de #ce("PbS(s)") (réaction avec #ce("O2(g)")) qui fournit #ce("PbO(s)") et #ce("SO2(g)"). La réaction est supposée totale.

#question(
    coups-de-pouce: "À quelle condition l'enthalpie standard de formation est-elle nulle ?",
)[
    Remplir les deux cases vides du tableau de données.
][
    Le dioxygène gazeux et le diazote gazeux sont des corps simples dans leur état standard, leur enthalpie de formation est donc nulle.
]

#question()[
    Écrire l’équation-bilan de cette réaction avec un coefficient stœchiométrique algébrique égal à $-1$ pour #ce("PbS(s)").
][
    L’équation-bilan de la réaction est :
    $
        #ce("PbS(s)") + 3\/2 #ce("O2(g)") #ce("->") #ce("PbO(s)") + #ce("SO2(g)")
    $
]

#let DrH = 100.4 - 217.9 - 296.9

#question(
    coups-de-pouce: "Utiliser la loi de Hess.",
)[
    Calculer l’enthalpie standard de réaction $standard(Delta_r H)$ à #qty("298", "K") pour la réaction écrite à la question précédente.
][
    La loi de Hess s'écrit
    $
        standard(Delta_r H) = sum nu_i standard(Delta_f H)(ce("X")_i)\
        = - standard(Delta_f H)(ce("PbS(s)")) - 3/2 standard(Delta_f H)(ce("O_2(g)")) + standard(Delta_f H)(ce("PbO(s)")) + standard(Delta_f H)(ce("SO2(g)"))
        = #qty(scientifique(DrH, 3), "kJ/mol")
    $
]

#question(
    coups-de-pouce: (
        "On imagine une transformation constituée d'une transformation chimique isotherme suivie d'une élévation de température sans transformation chimique dont les états initiaux et finaux sont les mêmes que la transformation étudiée.",
        "Que peut-on dire de la chaleur échangée lors de la transformation étudiée ? En déduire la variation d'enthalpie.",
        "Concernant la réaction chimique isotherme : relier la variation d'enthalpie à l'avancement.",
        "Concernant l'élévation de température sans réaction chimique : écrire la seconde loi de Joule.",
        "Relier les variations d'enthalpie sur les trois transformations.",
    ),
)[
    On part d’un mélange #ce("PbS(s) / O2(g)") dans les proportions stœchiométriques, à la température initiale $T_i = qty("298", "K")$. La réaction est menée de façon isobare adiabatique et les capacités thermiques sont supposées indépendantes de la température, calculer la température de flamme (température finale atteinte).
][
    On note $n$ la quantité initiale de #ce("PbS(s)"). Les réactifs ont été introduits dans les proportions stœchiométriques, donc la quantité initiale de #ce("O2(g)") est $3/2 n$. La réaction est totale donc les réactifs sont tous les deux entièrement consommés.

    On considère le cycle suivant
    #figure(
        canvas({
            import cetz.draw: *
            content(
                (-2.5, 0),
                [
                    $n unit("mol")$ de #ce("PbS(s)")\
                    $3/2 n unit("mol")$ de #ce("O2(g)")\
                    $T_i$, $P^circ$\
                    #h(1fr) état initial
                ],
                frame: "rect",
                padding: .5em,
                name: "A",
            )
            content(
                (2.5, 0),
                [
                    $n unit("mol")$ de #ce("PbO(s)")\
                    $n unit("mol")$ de #ce("SO2(g)")\
                    $T_f$, $P^circ$\
                    #h(1fr) état final
                ],
                frame: "rect",
                padding: .5em,
                name: "B",
            )
            content(
                (0, -4),
                [
                    $n unit("mol")$ de #ce("PbO(s)")\
                    $n unit("mol")$ de #ce("SO2(g)")\
                    $T_i$, $P^circ$\
                    #h(1fr) état intermédiaire fictif
                ],
                frame: "rect",
                padding: .5em,
                name: "C",
            )
            line("A", "B", mark: (end: ">>", fill: black), name: "AB")
            line("C", "B", mark: (end: ">>", fill: black), name: "CB")
            line("A", "C", mark: (end: ">>", fill: black), name: "AC")
            content("AB.mid", $Delta H^circ_1$, anchor: "south", padding: .4em)
            content("CB.mid", $Delta H^circ_3$, anchor: "north-west", padding: .2em)
            content("AC.mid", $Delta H^circ_2$, anchor: "north-east", padding: .2em)
        }),
    )

    La transformation entre l'état initial et l'état final est adiabatique, donc $Delta H_1^circ = 0$.

    La transformation entre l'état initial et l'état intermédiaire est une transformation chimique isotherme, donc $Delta H_2^circ = xi_f standard(Delta_r H) = n Delta_r H^circ$

    La transformation entre l'état intermédiaire et l'état final est une élévation de température sans transformation chimique. La seconde loi de Joule donne alors
    $
        Delta H_3^circ = integral_(T_i)^(T_f) (n c_(P,m)(ce("PbO(s)")) + n c_(P,m)(ce("SO2(g)"))) dd(T) = n (c_(P,m)(ce("PbO(s)")) + c_(P,m)(ce("SO2(g)"))) (T_f - T_i)
    $

    $H$ est une fonction d'état, on a donc $-Delta H_1^circ + Delta H_2^circ + Delta H_3^circ = 0$, soit
    $
        n Delta_r H^circ + n (c_(P,m)(ce("PbO(s)")) + c_(P,m)(ce("SO2(g)"))) (T_f - T_i) = 0
    $
    #let Ti = 298
    #let c_P_m_PbO = 45.8
    #let c_P_m_SO2 = 29.9
    #let Tf = Ti - DrH*1000 / (c_P_m_PbO + c_P_m_SO2)
    $
      T_f = T_i - (Delta_r H^circ)/(c_(P,m)(ce("PbO(s)")) + c_(P,m)(ce("SO2(g)")))
      = #qty(scientifique(Tf,3), "K")
    $
]

#question(
    coups-de-pouce: (
        "Dans l'air, combien y a-t-il de fois plus de diazote que de dioxygène ?",
        "Par rapport à la question précédente, quelles sont les grandeurs qui seront différentes ?",
    ),
)[
    Reprendre le calcul de la question précédente en supposant que le mélange initial est constitué d’air (#qty("80", "%") de diazote et #qty("20", "%") de dioxygène). La quantité d’air ajoutée est juste suffisante pour provoquer la disparition de la totalité de #ce("PbS(s)").
][
    On note $n$ la quantité initiale de #ce("PbS(s)"). Les réactifs ont été introduits dans les proportions stœchiométriques, donc la quantité initiale de #ce("O2(g)") est $3/2 n$. Dans l'air, il y a 4 fois plus de diazote que de dioxygène, donc la quantité initiale de #ce("N2(g)") est $6 n$.
    
    La réaction est totale donc les réactifs sont tous les deux entièrement consommés. Le diazote est une espèce spectatrice, sa quantité ne change pas au cours de la réaction.

    On considère le cycle suivant
    #figure(
        canvas({
            import cetz.draw: *
            content(
                (-2.5, 0),
                [
                    $n unit("mol")$ de #ce("PbS(s)")\
                    $3/2 n unit("mol")$ de #ce("O2(g)")\
                    $6 n unit("mol")$ de #ce("N2(g)")\
                    $T_i$, $P^circ$\
                    #h(1fr) état initial
                ],
                frame: "rect",
                padding: .5em,
                name: "A",
            )
            content(
                (2.5, 0),
                [
                    $n unit("mol")$ de #ce("PbO(s)")\
                    $n unit("mol")$ de #ce("SO2(g)")\
                    $6 n unit("mol")$ de #ce("N2(g)")\
                    $T_f$, $P^circ$\
                    #h(1fr) état final
                ],
                frame: "rect",
                padding: .5em,
                name: "B",
            )
            content(
                (0, -4),
                [
                    $n unit("mol")$ de #ce("PbO(s)")\
                    $n unit("mol")$ de #ce("SO2(g)")\
                    $6 n unit("mol")$ de #ce("N2(g)")\
                    $T_i$, $P^circ$\
                    #h(1fr) état intermédiaire fictif
                ],
                frame: "rect",
                padding: .5em,
                name: "C",
            )
            line("A", "B", mark: (end: ">>", fill: black), name: "AB")
            line("C", "B", mark: (end: ">>", fill: black), name: "CB")
            line("A", "C", mark: (end: ">>", fill: black), name: "AC")
            content("AB.mid", $Delta H^circ_1$, anchor: "south", padding: .4em)
            content("CB.mid", $Delta H^circ_3$, anchor: "north-west", padding: .2em)
            content("AC.mid", $Delta H^circ_2$, anchor: "north-east", padding: .2em)
        }),
    )

    La transformation entre l'état initial et l'état final est adiabatique, donc $Delta H_1^circ = 0$.

    La transformation entre l'état initial et l'état intermédiaire est une transformation chimique isotherme, donc $Delta H_2^circ = xi_f standard(Delta_r H) = n Delta_r H^circ$

    La transformation entre l'état intermédiaire et l'état final est une élévation de température sans transformation chimique. La seconde loi de Joule donne alors
    $
        Delta H_3^circ = integral_(T_i)^(T_f) (n c_(P,m)(ce("PbO(s)")) + n c_(P,m)(ce("SO2(g)")) + 6 n c_(P,m)(ce("N2(g)"))) dd(T)\
        = n (c_(P,m)(ce("PbO(s)")) + c_(P,m)(ce("SO2(g)")) + 6 c_(P,m)(ce("N2(g)"))) (T_f - T_i)
    $

    $H$ est une fonction d'état, on a donc $-Delta H_1^circ + Delta H_2^circ + Delta H_3^circ = 0$, soit
    $
        n Delta_r H^circ + n (c_(P,m)(ce("PbO(s)")) + c_(P,m)(ce("SO2(g)")) + 6 c_(P,m)(ce("N2(g)"))) (T_f - T_i) = 0
    $
    #let Ti = 298
    #let c_P_m_PbO = 45.8
    #let c_P_m_SO2 = 29.9
    #let c_P_m_N2 = 29.1
    #let Tf = Ti - DrH*1000 / (c_P_m_PbO + c_P_m_SO2 + 6 * c_P_m_N2)
    $
      T_f = T_i - (Delta_r H^circ)/(c_(P,m)(ce("PbO(s)")) + c_(P,m)(ce("SO2(g)")) + 6 c_(P,m)(ce("N2(g)")))
      = #qty(scientifique(Tf,3), "K")
    $
]

*Données*

#table(
    columns: 6,
    align: (left,) + (center,) * 5,
    [Espèce], ce("PbS(s)"), ce("O2(g)"), ce("N2(g)"), ce("PbO(s)"), ce("SO2(g)"),
    [$standard(C)_(P,m)$ (#unit("J/K/mol"))], num("49.5"), num("29.4"), num("29.1"), num("45.8"), num("29.9"),
    [$standard(Delta_f H)$ (#unit("kJ/mol"))], num("-100.4"), [...], [...], num("-217.9"), num("-296.9"),
)
