#import "@local/prepa:0.1.1": *

#exercice(
    titre: "Permanent magnet",
)[

    #figure[
        #canvas({
            import cetz.draw: *
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

    #let m = 1e-2
    #let g = 5e-3
    #let mu0 = 4 * calc.pi * 1e-7

    // Cycle d'un aimant NdFeB fritté : l'aimantation bascule d'un bloc au champ
    // coercitif HcJ ; ailleurs B varie linéairement, avec la perméabilité de
    // recul mu-rec. H en kA/m, B en T.
    #let Br = 1.2
    #let mu-rec = 1.05
    #let HcJ = 1100
    #let largeur = 40
    #let B-descendant(H) = Br * calc.tanh((H + HcJ) / largeur) + mu-rec * mu0 * H * 1e3
    #let B-montant(H) = -B-descendant(-H)

    // Point de fonctionnement : intersection de la droite B = -(m mu0 / g) H
    // avec la partie linéaire de la branche descendante.
    #let pente = -m * mu0 / g
    #let Hm = -Br / (mu0 * (mu-rec + m / g))
    #let Bm = pente * Hm

    #let cycle(droite: false) = canvas({
        plot.plot(
            size: (12, 10),
            axis-style: "school-book",
            x-min: -1400,
            x-max: 1400,
            y-min: -3,
            y-max: 3,
            x-tick-step: 500,
            x-minor-tick-step: 100,
            y-tick-step: 1,
            y-minor-tick-step: 0.2,
            x-grid: "both",
            y-grid: "both",
            x-label: [$H$ (#unit("kA/m"))],
            y-label: [$B$ (#unit("T"))],
            {
                let trait = (stroke: (paint: black, thickness: 1pt))
                plot.add(B-descendant, domain: (-1300, 1300), samples: 600, style: trait)
                plot.add(B-montant, domain: (-1300, 1300), samples: 600, style: trait)
                if droite {
                    plot.add(
                        H => pente * H * 1e3,
                        domain: (-1150, 1150),
                        style: (stroke: (paint: black, thickness: 0.8pt, dash: "dashed")),
                    )
                    plot.add(
                        ((Hm / 1e3, Bm), (-Hm / 1e3, -Bm)),
                        mark: "o",
                        mark-size: 0.15,
                        style: (stroke: none),
                        mark-style: (fill: black, stroke: black),
                    )
                }
            },
        )
    })

    We study a magnetic circuit of constant cross-section $S$, made of
    - a permanent magnet of length $m=#quan[1 cm]$, whose hysteresis loop is given below;
    - soft iron of length $l_e$, assumed linear, homogeneous and isotropic, with infinite magnetic permeability;
    - an air gap of length $g=#quan[5 mm]$.

    #figure(
        cycle(),
        caption: [Hysteresis loop of the magnet, made of sintered NdFeB.],
    )

    We assume the fields are one-dimensional and neglect flux leakage and edge effects.

    #question(coups-de-pouce: (
        "Should the hysteresis loop be narrow or wide?",
    ))[
        What should the hysteresis loop of a good permanent magnet look like? Should a soft or hard material be used?
    ][
        A good permanent magnet needs a wide hysteresis loop, in order to keep a high remanent magnetization. A hard magnetic material is thus needed. The loop given above, with a coercive field of about #quan[900 kA/m], is that of a hard material.
    ]

    #question(coups-de-pouce: (
        "Relate $B$ and $H$ in the soft iron. What is the magnetic permeability of the soft iron?",
    ))[
        Show that the vector $va(H)$ is zero in the soft iron.
    ][
        In the soft iron, which is a soft magnetic material, we have $va(H_e) = va(B_e)/(mu_0 mu_r)$ with $mu_r >> 1$ thus $va(H_e) approx va(0)$.
    ]

    #question(coups-de-pouce: (
        "Use the conservation of the flux of $va(B)$ through a small closed surface straddling the interface.",
    ))[
        Show that the magnetic field is the same in the air gap, the permanent magnet and the soft iron.
    ][
        By applying the conservation of the flux of $va(B)$ through a small closed surface straddling the interface between two media, we have:
        $ va(B_g) dot va(dd(S)) = va(B_e) dot va(dd(S)) $ thus $ B_g = B_e $
        We can apply the same reasoning at the interface between the permanent magnet and the soft iron to get $ B_m = B_e $
    ]

    #question(coups-de-pouce: (
        "What current is enclosed by the mean field line?",
    ))[
        By applying Ampère's theorem on a mean field line, find a relation between $B_m$ and $H_m$ in the magnet.
    ][
        By applying Ampère's theorem on a mean field line, we have:
        $ integral.cont va(H) dot va(dd(l)) = 0 = m H_m + H_g g + H_e l_e $
        But we have seen that $va(H_e) = va(0)$ thus $m H_m + g H_g = 0$ i.e. $ H_m = - (g/m) H_g $

        In the air gap, we have $H_g = B_g/mu_0 = B_m/mu_0$ so finally:
        $ B_m = - (m mu_0)/g H_m $
    ]

    #question(coups-de-pouce: (
        "The relation found in the previous question is linear: draw the corresponding line on the hysteresis loop.",
        "Read the coordinates of the intersections of the line and the hysteresis loop.",
    ))[
        Deduce graphically the values of $B_m$ and $H_m$. How many solutions are there?
    ][
        The relation $B_m = - (m mu_0)/g H_m$ is represented by the line of slope $-(m mu_0)/g = #qty(pente, "T m/A", chiffres: 2)$ going through the origin, that is to say through the point $(#quan[-1000 kA/m] ; #qty(pente * -1e6, "T", chiffres: 2, exponent: auto))$.

        #figure(cycle(droite: true))

        It intersects the hysteresis loop at two points with opposite coordinates: $B_m approx plus.minus #qty(Bm, "T", chiffres: 2, exponent: auto)$ and $H_m approx minus.plus #qty(-Hm / 1e3, "kA/m", chiffres: 2, exponent: auto)$. The magnet can be magnetized in either direction: the solution depends on its history.
    ]

    #question(coups-de-pouce: (
        "Use the result of question 3 and the relation between $B$ and $H$ in the air gap.",
    ))[
        What are the values of $B_g$ and $H_g$ in the air gap?
    ][
        $ B_g = B_m approx plus.minus #qty(Bm, "T", chiffres: 2, exponent: auto) $
        $ H_g = -m/g H_m = B_g/mu_0 approx plus.minus #qty(Bm / mu0, "A/m", chiffres: 2) $
    ]

]
