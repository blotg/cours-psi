#import "@local/prepa:0.1.0": *

#show: exercice.with(
    titre: "Distribution d'eau potable",
)

Un château d'eau de hauteur $h = qty("25", "m")$, alimente un village en eau potable. On suppose l'écoulement incompressible et homogène.

#let mv = 1e3
#let g = 9.81
#let S = 1e-4
#let h = 25
#let L = 100
#let viscosité = 1e-3

#figure(
    canvas({
        import draw: *
        line(
            (9, 0.1),
            (9, -0.1),
            (-0.6, -0.1),
            (-0.6, 3),
            (rel: (135deg, 1.5)),
            (rel: (45deg, 1.5), to: (0.6, 3)),
            (0.6, 3),
            (0.6, 0.1),
            fill: black.lighten(70%),
            stroke: none,
        )
        line((9, 0.1), (0.6, 0.1), (0.6, 3), (rel: (45deg, 2)))
        line((9, -0.1), (-0.6, -0.1), (-0.6, 3), (rel: (135deg, 2)))
        line((2, 0.1), (2, 3 + 1.5 / calc.sqrt(2)), mark: (symbol: ">>", fill: black), name: "h")
        content("h.mid", $h$, anchor: "west", padding: .4em)
        line((9, -.5), (0.6, -.5), mark: (symbol: ">>", fill: black), name: "L")
        content("L.mid", $L$, anchor: "north", padding: .4em)
    }),
)

#question(
    coups-de-pouce: (
        "Résoudre l'équation fondamentale de l'hydrostatique pour un fluide incompressible.",
    ),
)[
    Quelle pression $P_e$ qui peut être attendue au pied du château d'eau, en admettant que le débit de l'eau dans la canalisation soit suffisamment faible pour ne pas impacter la pression ?
][
    L'équation fondamentale de l'hydrostatique pour un fluide incompressible s'écrit :
    $ dv(P, z) = - rho g $
    $ P(z) = - rho g z + "cte" $
    En $z=h$, on a $P(h) = P_a$ donc $"cte" = P_a + rho g h$. Ainsi,
    $ P(z) = P_a + rho g (h - z) $
    En $z=0$, on a donc :
    $ P_e = P_a + rho g h $
]

#question(
    coups-de-pouce: (
        "Utiliser la loi de Hagen-Poiseuille."
    ),
)[
    Soit une conduite de longueur $L = qty("100", "m")$ et de section $S = qty("1", "cm^2")$ partant du pied de ce château d'eau. L'autre extrémité est à l'air libre. Quel débit peut-on attendre, en supposant _a priori_ l'écoulement laminaire ? Calculer la vitesse débitante $U$.
][

    #let U = mv * g * h * S / (8 * calc.pi * viscosité * L)
    La loi de Hagen-Poiseuille s'écrit :
    $ D_V = (pi R^4)/(8 eta L) Delta P $
    Ici, $Delta P = P_e - P_a = rho g h$ et $S = pi R^2$ d'où $R^4 = S^2/pi^2$, ainsi
    $ D_V = (S^2)/(8 pi eta L) rho g h $
    Le débit volumique est relié à la vitesse débitante par la relation $D_V = U S$, donc :
    $ U = D_V/S = (S rho g h)/(8 pi eta L) = #qty(scientifique(U, 1), "m/s") $
]

#question[
    Calculer le nombre de Reynolds pour cet écoulement. La modélisation précédente est-elle correcte ?
][
    #let Re = (S * mv * g * h * 2 * calc.sqrt(S / calc.pi) * mv) / (8 * calc.pi * viscosité * L * viscosité)
    Le diamètre de la conduite est tel que $S = pi (D/2)^2$, d'où $D = 2 sqrt(S/pi)$
    $ R_e = (U D)/(nu) = (S rho g h 2 sqrt(S/pi) mu)/(8 pi eta L eta) = #num(scientifique(Re, 1)) $

    $R_e > 2000$, l'écoulement n'est donc pas laminaire, la modélisation précédente n'est pas correcte.
]

#question(
    coups-de-pouce: (
        "La vitesse intervient dans le nombre de Reynolds mais aussi dans le coefficient de perte de charge.",
        "Raisonner à nombre de Reynolds fixé.",
    ),
)[
    En utilisant le diagramme de Moody, dire si la vitesse débitante sera plus ou moins importante que celle calculée plus haut.
][
    À nombre de Reynolds fixé, le coefficient de perte de charge est systématiquement plus grand en régime turbulent qu'en régime laminaire. Ainsi, la vitesse débitante sera plus faible que celle calculée précédemment.
]
