#import "@local/prepa:0.1.0": *

#show: exercice.with(
    titre: "Élaboration d'un ciment",
)

Ce problème s’intéresse à l’étude de quelques propriétés physico-chimiques du ciment et des bétons armés. Le clinker est le principal constituant d’un ciment, il est obtenu à partir d’un mélange de #qty("80", "%") de calcaire (#ce("CaCO3(s)")) et de #qty("20", "%") d’argile (silicoaluminates).

Le ciment est principalement utilisé pour fabriquer le béton qui est un mélange de ciment, sable, granulats et eau. Le béton forme après la "prise" une véritable roche artificielle. La "prise" est le phénomène de durcissement en présence d’eau.

Le ciment est modélisé par la seule espèce : #ce("[Ca3SiO5](s)"). La réaction à l’origine de la "prise" est simplifiée sous la forme suivante :
#math.equation(
    $ce("2 [Ca3SiO5](s) + 6 H2O(l) <=> [Ca3Si2O7, 3H2O](s) + 3 Ca(OH)2(s)")$,
    numbering: "(1)",
    block: true,
) <equation1>

L’hydroxyde de calcium #ce("Ca(OH)2(s)") est appelée _portlandite_. On mélange $m_1 = #qty("228,0", "g")$ de ciment et $m_2 = #qty("90,0", "g")$ d’eau liquide. On mélange rapidement dans un calorimètre et on place un dispositif de mesure de la température. On mesure une élévation de la température : $Delta theta = qty("15.0", "Celsius")$.

#let M_Ca3SiO5 = 3 * 40.0 + 28.0 + 5 * 16.0
#let M_H2O = 2 * 1.00 + 16.0
#let m1 = 228.0
#let m2 = 90.0
#question(
    coups-de-pouce: (
        "Calculer la masse molaire de #ce(\"Ca3SiO5\") et de #ce(\"H2O\").",
        "Quelle relation lie masse molaire, masse et quantité de matière ?",
    ),
)[
    Calculer numériquement les quantités de matière en ciment et en eau (notées $n_1$ et $n_2$) initialement introduites.
][
    La masse molaire de #ce("Ca3SiO5") est
    $
        M(ce("Ca3SiO5")) = 3 M(ce("Ca")) + M(ce("Si")) + 5 M(ce("O")) =
        #qty(scientifique(M_Ca3SiO5, 3), "g/mol")
    $

    Celle de l'eau est
    $
        M(ce("H2O")) = 2 M(ce("H")) + M(ce("O")) =
        #qty(scientifique(M_H2O, 3), "g/mol")
    $

    Les quantités de matière sont donc
    $
        n_1 = m_1 / M(ce("Ca3SiO5")) = #qty(scientifique(m1 / M_Ca3SiO5, 3), "mol")
    $
    $
        n_2 = m_2 / M(ce("H2O")) = #qty(scientifique(m2 / M_H2O, 3), "mol")
    $
]

#question(
    coups-de-pouce: (
        "Faire un tableau d'avancement.",
        "En supposant #ce(\"Ca3SiO5\") réactif limitant, que serait l'avancement ? Même question pour #ce(\"H2O\"). Quel est le réactif limitant ?",
        "Que vaut l'avancement final ?",
    ),
)[
    En supposant la réaction totale, indiquer quel est le réactif limitant et calculer les quantités de matière en chacune des espèces présentes en fin d’évolution.
][
    Le tableau d'avancement est le suivant :
    #figure({
        table(
            columns: 8,
            align: (left,) + (center,) * 7,
            stroke: none,
            [],
            ce("2 Ca3SiO5(s)"),
            ce("+"),
            ce("H2O(l)"),
            ce("->"),
            ce("[Ca3Si2O7, 3H2O](s)"),
            ce("+"),
            ce("3 Ca(OH)2(s)"),
            table.hline(),
            [État initial], table.vline(), $n_1$, [], $n_2$, [], $0$, [], $0$,
            table.hline(),
            [État final], $n_1 - 2 xi_f$, [], $n_2 - 6 xi_f$, [], $xi_f$, [], $3 xi_f$,
        )
    })
    - Si #ce("Ca3SiO5") est réactif limitant, on a $xi_f = n_1/2 = #qty(scientifique(m1 / M_Ca3SiO5 / 2, 3), "mol")$.
    - Si #ce("H2O") est réactif limitant, on a $xi_f = n_2 / 6 = #qty(scientifique(m2 / (6 * M_H2O), 3), "mol")$.

    Le réactif limitant est donc l'eau et l'avancement final est
    $xi_f = n_1 / 2 = #qty(scientifique(m1 / (2 * M_Ca3SiO5), 3), "mol")$

    À l'état final, les quantités de matière sont donc :
    - $0$ pour #ce("Ca3SiO5(s)")
    - $n_2 - 6 n_1/2 = n_2 - 3 n_1 = #qty(scientifique(m2 / M_H2O - 3 * m1 / M_Ca3SiO5, 3), "mol")$ pour #ce("H2O(l)")
    - $n_1/2 = #qty(scientifique(m1 / (2 * M_Ca3SiO5), 3), "mol")$ pour #ce("[Ca3Si2O7, 3H2O](s)")
    - $3 n_1/2 = #qty(scientifique(3 * m1 / (2 * M_Ca3SiO5), 3), "mol")$ pour #ce("Ca(OH)2(s)")
]

#question(
    coups-de-pouce: (
        "On imagine une transformation constitué d'une transformation chimique isotherme suivie d'une élévation de température sans transformation chimique dont les états initiaux et finaux sont les mêmes que la transformation étudiée.",
        "Que peut-on dire de la chaleur échangée lors de la transformation étudiée ? En déduire la variation d'enthalpie.",
        "Concernant la réaction chimique isotherme : relier la variation d'enthalpie à l'avancement.",
        "Concernant l'élévation de température sans réaction chimique : écrire la seconde loi de Joule.",
        "Relier les variations d'enthalpie sur les trois transformations.",
    ),
)[
    Le système constitué par le calorimètre et son contenu sont supposés en évolution adiabatique. Estimer la valeur de l’enthalpie standard de réaction $Delta_r H^0$ associée à l’équation-bilan (@equation1[]). On négligera la capacité thermique du calorimètre.
][
    On imagine le cycle suivant
    #figure(
        canvas({
            import draw: *
            content(
                (-3.5, 0),
                [
                    $n_1 unit("mol")$ de #ce("Ca3SiO5(s)")\
                    $n_2 unit("mol")$ de #ce("H2O(l)")\
                    $T_i$, $P^circ$\
                    #h(1fr) état initial
                ],
                frame: "rect",
                padding: .5em,
                name: "A",
            )
            content(
                (3.5, 0),
                [
                    $n_2 - 3 n_1 unit("mol")$ de #ce("H2O(s)")\
                    $n_1/2 unit("mol")$ de #ce("[Ca3Si2O7, 3H2O](s)")\
                    $3 n_1/2 unit("mol")$ de #ce("Ca(OH)2(s)")\
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
                    $n_2 - 3 n_1 unit("mol")$ de #ce("H2O(s)")\
                    $n_1/2 unit("mol")$ de #ce("[Ca3Si2O7, 3H2O](s)")\
                    $3 n_1/2 unit("mol")$ de #ce("Ca(OH)2(s)")\
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

    La transformation de l'état initial à l'état final est adiabatique, donc $Delta H_1^circ = Q = 0$.

    La transformation de l'état initial à l'état intermédiaire est une transformation chimique isotherme. On a donc
    $
        Delta H_2^circ = Delta_r H^0 xi_f = n_1/2 Delta_r H^0
    $

    La transformation de l'état intermédiaire à l'état final est une élévation de température sans transformation chimique. On applique la seconde loi de Joule :
    $
        Delta H_3^circ = integral_(T_i)^(T_f) sum_(i) n_i_(p,m,i) dd(T)\
        = Delta theta ((n_2-3 n_1) c_(P,m) (ce("H2O(l)")) + n_1/2 c_(P,m) (ce("[Ca3Si2O7, 3H2O](s)")) + 3 n_1/2 c_(P,m) (ce("Ca(OH)2(s)")))
    $

    L'enthalpie est une fonction d'état, sa variation est donc indépendante du chemin suivi. On a donc
    $
        Delta H_1^circ = Delta H_2^circ + Delta H_3^circ
    $
    soit
    $
        Delta_r H^0 = - (2 / n_1) Delta theta ((n_2-3 n_1) c_(P,m) (ce("H2O(l)")) + n_1/2 c_(P,m) (ce("[Ca3Si2O7, 3H2O](s)")) + 3 n_1/2 c_(P,m) (ce("Ca(OH)2(s)")))\
        = #qty(
            scientifique(
                - (2 / (m1 / M_Ca3SiO5)) * 15.0 * (
                    (m2 / M_H2O - 3 * m1 / M_Ca3SiO5) * 75 +
                    (m1 / (2 * M_Ca3SiO5)) * 340 +
                    3 * (m1 / (2 * M_Ca3SiO5)) * 80
                ),
                3
            ),
            "kJ/mol"
        )
    $
]

*Données*

#table(
    columns: 4,
    align: (left,) + (center,) * 3,
    [Espèce], ce("Ca(OH)2(s)"), ce("[Ca3Si2O7, 3 H2O](s)"), ce("H2O(l)"),
    [$C_(P,m)$ (#unit("J/K/mol"))], num("80"), num("340"), num("75"),
)

#table(
    columns: 5,
    [Atome], ce("H"), ce("O"), ce("Ca"), ce("Si"),
    [Masse molaire (#unit("g/mol"))], num("1.00"), num("16.0"), num("40.0"), num("28.0"),
)
