#import "@local/prepa:0.1.0": *

// TODO sûrement des erreurs de calculs

#show: exercice.with(titre: "Alternateur d'une centrale hydroélectrique")

Une machine turbine hydraulique est accouplé à une machine synchrone qui fonctionne en alternateur, le groupe turbine-alternateur fournit de l'énergie au réseau.

Les caractéristiques de la machine synchrone diphasée sont les suivantes :
- puissance apparente nominale#footnote[Les grandeurs nominales sont les grandeurs pour lesquelles la machine est conçue pour fonctionner de façon optimale.] $S_n=#qty("65", "MV A")$
- tension nominale aux bornes d'une phase $V_n=#qty("10", "kV")$
- fréquence des courants statoriques imposée par le réseau $f=qty("50", "Hz")$
- résistance d'une phase statorique $R=#qty("0.01", "O")$
- la fém à vide dépend du courant d'excitation selon la relation $E=k I_e$ avec $k=qty("290", "V/A")$
- courant de court-circuit $I_(c c) = 300 I_e$

#let k = 290
#let R = 0.01
#let Sn = 65e6
#let Vn = 10e3
#let In = Sn / Vn
#question(
    coups-de-pouce: (
        "Exprimer la puissance apparente nominale en fonction de la tension nominale et du courant nominal.",
    ),
)[
    Calculer l'intensité du courant d'induit nominal.
][
    $S_n = I_n V_n$ donc $ I_n = S_n / V_n = #qty(scientifique(In, 2), "A") $
]


#let X = calc.sqrt((calc.pow((k / 300), 2)) - calc.pow(R, 2))
#question(
    coups-de-pouce: (
        "Utiliser le courant de court-circuit.",
        "Représenter le circuit équivalent d'une phase en court-circuit.",
        "Représenter le diagramme de Fresnel associé à la loi des mailles pour un induit court-circuité.",
        "Utiliser le théorème de Pythagore.",
    ),
)[
    Calculer la résistance synchrone $X=L omega$ de chaque enroulement.
][
    En court-circuit, la loi des mailles s'écrit $underline(E) = R underline(I) + j L omega underline(I)$.

    #figure(
        canvas({
            import draw: *
            line((0, 0), (3, 0), mark: (end: ">>", fill: black), name: "RI")
            line((3, 0), (3, 2), mark: (end: ">>", fill: black), name: "jXI")
            line((0, 0), (3, 2), mark: (end: ">>", fill: black), name: "E")
            content("RI.mid", $R underline(I)$, anchor: "north", padding: 0.4em)
            content("jXI.mid", $j L omega underline(I)$, anchor: "west", padding: 0.4em)
            content("E.mid", $underline(E)$, anchor: "south-east", padding: 0.2em)
        }),
    )

    Sur le diagramme de Fresnel, on a donc $E^2 = (R I_(c c))^2 + (X I_(c c))^2$. On en déduit que
    $
        X = sqrt((E/I_(c c))^2 - R^2)
        = sqrt(((k I_e)/I_(c c))^2 - R^2)
    $
    Avec $I_(c c) = 300 I_e$, on obtient
    $X = sqrt((k/300)^2-R^2) = qty(#scientifique(X, 2), "O")$.
]

#question(
    coups-de-pouce: (),
)[
    Fonctionnement en charge. L'intensité du courant d'excitation vaut $I_e=qty("44", "A")$, la tension efficace aux bornes d'une phase est #qty("8.64", "kV") et le facteur de puissance du réseau vaut $cos(phi)=0.9$ arrière (charge inductive). Représenter le schéma électrique d'une phase en négligeant la résistance $R$.
][
    #figure(
        zap.circuit({
            import zap: *
            vsource("E", (0, 0), (0, 3), u: $underline(E)$)
            inductor("L", (0, 3), (3, 3), label: $L$, i: $underline(I)$, variant: "ieee")
            resistor(
                "Z",
                (3, 3),
                (3, 0),
                label: $underline(Z)$,
                u: (content: $underline(V)$, anchor: "south-west"),
                stroke: red,
            )
            wire((3, 0), (0, 0))
        }),
    )
    En noir : un circuit statorique de l'alternateur. En rouge : la charge.
]

#let E = k * 44
#let V = 8.64e3
#let angle = calc.acos(0.9)
#let I = calc.sqrt(
    (calc.sqrt(calc.pow(E, 2) - calc.pow(V * calc.cos(angle), 2)) - V * calc.sin(angle)) / X
)
#question(
    coups-de-pouce: (
        "Placer l'angle $phi$ sur le diagramme.",
        "Projeter $j X underline(X)$ verticalement et horizontalement.",
    ),
)[
    Représenter la loi des mailles sur un diagramme de Fresnel. Montrer que $(V cos(phi))^2+(V sin(phi)+I X)^2=E^2$. En déduire l'intensité efficace du courant dans une phase statorique.
][
    La loi des mailles s'écrit $underline(E) = underline(V) + j X underline(I)$.

    #figure(
        canvas({
            import draw: *
            line((0, 0), (4, 3), mark: (end: ">>", fill: black), name: "V")
            line((4, 3), (4, 6), mark: (end: ">>", fill: black), name: "jXI")
            line((0, 0), (4, 6), mark: (end: ">>", fill: black), name: "E")
            line((0, 0), (4, 0), (4, 3), stroke: (dash: "dashed"))
            line((0, 0), (2, 0), mark: (end: ">>", fill: red), name: "I", stroke: red)
            arc((1, 0), radius: 1, start: 0deg, stop: calc.atan(3 / 4), mark: (end: ">>", fill: black), name: "phi")
            content("V.mid", $underline(V)$, anchor: "north-west", padding: 0.2em)
            content("jXI.mid", $j X underline(I)$, anchor: "west", padding: 0.4em)
            content("E.mid", $underline(E)$, anchor: "south-east", padding: 0.2em)
            content("I.mid", [#set text(red); $underline(I)$], anchor: "north", padding: 0.4em)
            content("phi.mid", $phi$, anchor: "west", padding: 0.4em)
        }),
    )

    Le théorème de Pythagore donne la relation demandée
    $
        E^2 = (V cos(phi))^2 + (V sin(phi) + X I)^2
    $
    On en déduit, avec $phi = arccos(0.9)$,
    $
        I = sqrt((sqrt(E^2 - (V cos(phi))^2) - V sin(phi)) / X)
        = qty(#scientifique(I, 2), "A")
    $
]

#question(
    coups-de-pouce: (
        "Exprimer la puissance fournie au réseau par l'alternateur en fonction de $V$, $I$ et $cos(phi)$. Attention, on étudie un alternateur diphasé.",
        "Comment s'exprimer les pertes joules statoriques ?",
    ),
)[
    Calculer la puissance fournie au réseau et le rendement de l'alternateur sachant que l'ensemble des pertes mécaniques, ferromagnétiques et d'excitation valent $P_p=qty("2.4", "MW")$.
][
    La puissance fournie au réseau est $P_"utile" = 2V I cos(phi)$, le facteur 2 venant du fait que l'alternateur est diphasé.

    Le rendement s'écrit
    $
        eta &= P_"utile" / (P_"utile" + P_"Joule" + P_p)\
        &= (2 V I cos(phi)) / (2 V I cos(phi) + 2R I^2 + P_p)\
        &= #num(scientifique((2 * V * I * calc.cos(angle)) / (2 * V * I * calc.cos(angle) + 2*R * calc.pow(I, 2) + 2.4e6), 2))
    $
]
