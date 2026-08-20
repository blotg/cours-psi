#import "@local/prepa:0.1.0": *

#exercice(
    titre: "Permanent magnet",
)[

    #figure[
        #canvas({
            import draw: *
            line((0, 0.3), (0, 1.5))
            arc((), start: 0deg, stop: 90deg, radius: 0.5)
            line((), (-1.5, 2))
            arc((), start: 90deg, stop: 180deg, radius: 0.5)
            line((), (-2, -1.5))
            arc((), start: 180deg, stop: 270deg, radius: 0.5)
            line((), (-0.5, -2))
            arc((), start: 270deg, stop: 360deg, radius: 0.5)
            line((), (0, -0.3))
            line((1, 0.3), (1, 2))
            arc((), start: 0deg, stop: 90deg, radius: 1)
            line((), (-2, 3))
            arc((), start: 90deg, stop: 180deg, radius: 1)
            line((), (-3, -2))
            arc((), start: 180deg, stop: 270deg, radius: 1)
            line((), (0, -3))
            arc((), start: 270deg, stop: 360deg, radius: 1)
            line((), (1, -0.3))
            line((0, 0.3), (1, 0.3))
            line((0, -0.3), (1, -0.3))
            rect((0.5, -2.5), (-2.5, 2.5), radius: 0.75, stroke: (dash: "dashed"))
            line((-2, 1), (-3, 1))
            line((-2, -1), (-3, -1))
            line((1.2, 0.3), (1.2, -0.3), mark: (symbol: ">>", fill: black), name: "e")
            content("e", $g$, anchor: "west", padding: 0.2)
            line((-3.2, 1), (-3.2, -1), mark: (symbol: ">>", fill: black), name: "a")
            content("a", $m$, anchor: "east", padding: 0.2)
            content((-1, 2.5), $cal(C)$, anchor: "south", padding: 0.1)
        })
    ]

    #let m = 10e-2
    #let g = 1e-3
    We study a magnetic circuit which section $S$ is constant composed of
    - a magnet of length $m=qty("10", "cm")$ described by its hysteresis cycle given below ;
    - electrical steel#footnote["fer doux" in French] of length $l_e$ considered linear, homogenous, isotropic, transparent, of infinite magnetic permeability ;
    - an air gap of length $g=qty("1", "mm")$.

    #figure[
        #image("hysteresis.png", height: 13cm)
    ]

    We suppose the fields to be unidimensional, we neglect any field leak and any side effect.

    #question(coups-de-pouce: (
        "Le cycle d'hystérésis doit-il être fin ou épais ?",
    ))[
        How does the hysteresis cycle needs to be for a good permanent magnet ? Should a soft or hard material be used ?
    ][
        A good permanent magnet needs to have a wide hysteresis cycle, in order to keep a high remanent magnetization. A hard magnetic material is thus needed.
    ]

    #question(coups-de-pouce: (
        "Relier $B$ et $H$ dans le matériau doux. Que vaut la perméabilité magnétique du matériau doux ?",
    ))[
        Show that the vector $va(H)$ is null in the electrical steel.
    ][
        In the electrical steel, which is a soft magnetic material, we have $va(H_e) = va(B_e)/(mu_0 mu_r)$ with $mu_r >> 1$ thus $va(H_e) approx va(0)$.
    ]

    #question(coups-de-pouce: (
        "Utiliser la conservation du flux de $va(B)$ sur une petite surface à cheval sur l'interface.",
    ))[
        Show that the magnetic field is the same in the air gap, the permanent magnet and the soft magnetic material.
    ][
        By applying the conservation of the flux of $va(B)$ on a small surface straddling the interface between two media, we have :
        $ va(B_g) dot va(dd(S)) = va(B_e) dot va(dd(S)) $ thus $ B_g = B_e $
        We can apply the same reasoning at the interface between the permanent magnet and the electrical steel to get $ B_m = B_e $
    ]

    #question(coups-de-pouce: (
        "Quel est le courant enlacé par la ligne de champ moyenne ?",
    ))[
        By applying Ampère's theorem on a mean field line, find a relation between $B_m$ and $H_m$ in the magnet.
    ][
        By applying Ampère's theorem on a mean field line, we have :
        $ integral.cont va(H) dot va(dd(l)) = 0 = m H_m + H_g g + H_e l_e $
        But we have seen that $va(H_e) = va(0)$ thus $m H_m + g H_g = 0$ i.e. $ H_m = - (g/m) H_g $

        In the air gap, we have $H_g = B_g/mu_0 = B_m/mu_0$ so finally :
        $ B_m = - (m mu_0)/g H_m $
    ]

    #question(coups-de-pouce: (
        "La relation de la question précédente est une fonction linéaire. La représenter graphiquement sur le cycle d'hystérésis.",
    ))[
        Deduce graphically les values of $B_m$ and $H_m$. How many solutions are there ?
    ][
        #let mu0 = 4 * calc.pi * 1e-7
        #let pente = -m * mu0 / g
        On trace la droite de pente $-(m mu_0)/g = qty(#scientifique(pente, 1), "")$ sur la courbe. Elle coupe le cycle d"hystérésis en deux points de coordonnées opposées : $B_m= plus.minus qty("0.05", "T")$ et $H_m = plus.minus qty("4e1", "A/m")$.
    ]

    #question(coups-de-pouce: (
        "Lire graphiquement les intersections entre le cycle d'hystérésis et la droite tracée précédemment.",
    ))[
        What are the values of $B_e$ and $H_e$ in the air gap ?
    ][
        $ B_g = B_m $
        $ H_g = -m/g H_m = plus.minus qty("4e3", "A/m") $
    ]

]
