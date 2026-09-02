#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Resistance of a holed cylinder",
)

We study a ohmic conductor which shape is described below in steady state#footnote["Steady state" means "régime stationnaire".]. $gamma$ represents the conductivity of the material, and $V_1$ and $V_2<V_1$ the electrical potentials inside and outside the tube respectively. $I$ is the total current and $va(j)$ the current density vector.

The potential $V$ is supposed to depend only of $r$.

#figure(
    canvas({
        import cetz.draw: *
        projection-de-face()
        on-xy(z: 0, {
            circle((0, 0), radius: 1)
            circle((0, 0), radius: 2)
            content((0, 1), $V_1$, anchor: "east", padding: 0.4em)
            content((0, 2), $V_2$, anchor: "west", padding: 0.4em)
        })
        on-xy(z: -2, {
            circle((0, 0), radius: 1, stroke: (dash: "dashed"))
            arc((0, -2), radius: 2, start: -90deg, stop: 90deg)
            arc((0, -2), radius: 2, start: -90deg, stop: -270deg, stroke: (dash: "dashed"))
        })
        line((0, -2, 0), (0, -2, -2))
        line((0, 2, 0), (0, 2, -2))
        line((0, -1, 0), (0, -1, -2), stroke: (dash: "dashed"))
        line((0, 1, 0), (0, 1, -2), stroke: (dash: "dashed"))
        line((0, 0, -3), (0, 0, 0), stroke: (dash: "dotted"))
        line((0, 0, 0), (0, 0, 1.5), mark: (end: ">>", fill: black))
        content((0, 0, 1.5), $z$, anchor: "south", padding: 0.4em)
        line((0, 0, -2.8), (0, -1, -2.8), mark: (symbol: ">>", fill: black))
        content((0, -0.5, -2.8), $R_1$, anchor: "north", padding: 0.4em)
        line((0, 0, -2.9), (0, 2, -2.9), mark: (symbol: ">>", fill: black))
        content((0, 1, -2.9), $R_2$, anchor: "north", padding: 0.4em)
        line((0, -2.2, -2), (0, -2.2, 0), mark: (symbol: ">>", fill: black))
        content((0, -2.2, -1), $l$, anchor: "east", padding: 0.4em)
    }),
)

#question(
    coups-de-pouce: (
        "Le courant va des potentiels les plus élevés vers les potentiels les moins élevés.",
    ),
)[
    In which direction is $va(j)$ oriented ?
][
    The current flows from the highest potential to the lowest potential, so $va(j)$ is oriented radially from the inside to the outside of the tube: $va(j)=j(r) va(e_r)$ with $j(r) >= 0$.
]

#question(
    coups-de-pouce: (
        "Laquelle des hypothèses de l'énoncé implique-t-elle que le régime est stationnaire ?",
        "Exprimer le courant à travers un cylindre de rayon $r$ et de hauteur $l$ en fonction de $j$, $l$ et $r$.",
    ),
)[
    Why is the flux of $va(j)$ conservative ? By applying this on a cylinders of any radius $r$, deduce that $va(j)=C/r va(e_r)$ where $C$ is a constant that you will express as a function of $I$ and $l$.
][
    The regime is stationary. Thus, by conservation of charge, the flux of $va(j)$ is conservative. Meaning that the flux of $va(j)$ through the inner cylinder of radius $R_1$ is equal to the flux through any cylinder of radius $r$ between $R_1$ and $R_2$ :
    $
        integral.double_S_1 va(j) dot va(dd(S))
        = integral.double_S_r va(j) dot va(dd(S))
        = integral.double_S_r j(r) va(e_r) dot dd(S) va(e_r)
        = j(r) integral.double_S_r dd(S)
        = j(r) 2 pi r l
    $
    The first term is independent of $r$ (and is in fact equal to $I$). Thus, we have :
    $
        j(r) = I / (2 pi r l) = C / r
    $
    with $C = I/(2 pi l)$.
]

#question(
    coups-de-pouce: (),
)[
    By integrating the previous expression between $R_1$ and $R_2$ and using Ohm's law, determine the resistance of the tube.
][
    By Ohm's law, we have :
    $
        va(j) = gamma va(E) = - gamma grad(V)
    $
    Thus :
    $
        j(r) = - gamma dv(V,r)
    $
    We have previously established that $j(r) = C/r$. Thus :
    $
        dv(V,r) = - (C / (gamma r))
    $
    By integrating this expression between $R_1$ and $R_2$, we obtain :
    $
        V_2 - V_1 = - C / gamma ln(R_2 / R_1)
    $
    Finally, the resistance of the tube is :
    $
        R = (V_1 - V_2) / I = C / (gamma I) ln(R_2 / R_1) = 1 / (2 pi l gamma) ln(R_2 / R_1)
    $
]
