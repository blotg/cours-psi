#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "DC motor lifting a mass",
    difficulté: 2,
)

#figure(
    circuit({
        import zap: *
        import cetz.draw: *
        vsource("E0", (0, 0), (0, 2), u: $E_0$)
        resistor("r0", (0, 2), (0, 4), label: $r_0$)
        fil((0, 4), (2.5, 4), i: $i$)
        node("A", (2.5, 4), fill: true)
        node("B", (2.5, 0), fill: true)
        wire((2.5, 4), (3.5, 4))
        dcmotor("M", (3.5, 4), (3.5, 0))
        wire((3.5, 0), (0, 0))
        line((2.3, 0.3), (2.3, 3.7), mark: (end: ">>", fill: black), name: "U")
        content("U.mid", $U$, anchor: "east", padding: 3pt)
        // arbre, poulie, fil et masse
        line((4.05, 2), (6.2, 2), stroke: 1.2pt)
        circle((6.2, 2), radius: (0.45, 1.3))
        circle((6.2, 2), radius: 0.06, fill: black)
        content((6.42, 2.25), $a$)
        line((6.2, 2), (6.65, 2), stroke: (dash: "dashed"))
        line((6.65, 2), (6.65, 0.4))
        rect((6.15, 0), (7.15, 0.4), fill: luma(80%), name: "M")
        content((7.2, 0.6), $M$, anchor: "south-west")
        line((5.6, 0), (7.8, 0))
        rect((5.6, -0.25), (7.8, 0), fill: hachure(5pt), stroke: none)
    }),
)

A DC machine of coupling constant $Phi_0$, of internal resistance $r$ and of inductance $L$ is used to lift a mass $M$. The axis of the rotor is connected to a pulley of radius $a$. On the pulley is fixed a string on which the mass is attached. The machine is supplied by a generator of electromotive force $E_0$ and internal resistance $r_0$.

A friction torque $Gamma_f=-f Omega$ applies on the rotor. The moment of inertia of the system {rotor + pulley} is $J$. Hysteresis and eddy currents are neglected.

The mass is lifted at a constant speed $v_0$.

#question(
    coups-de-pouce: (
        "Write an electrical equation and a mechanical equation, and use the relations between the electrical and mechanical quantities of a DC machine.",
        "For the electrical equation, apply the mesh law to the equivalent circuit of the armature.",
        "For the mechanical equation, apply the theorem of angular momentum to the system {mass + string + pulley + rotor}.",
    ),
)[
    Determine the current $i$ and the electromotive force $E_0$ of the generator as a function of $M$, $g$, $a$, $Phi_0$, $f$, $r$, $r_0$ and $v_0$.
][
    Since the mass is lifted at a constant speed, all quantities are constant over time. The inductance $L$ will have no influence and is not represented on the electrical schematic.

    #figure(
        circuit({
            import zap: *
            import cetz.draw: *
            vsource("E0", (0, 0), (0, 2), u: $E_0$)
            resistor("r", (0, 2), (0, 4), label: $r_0$)
            fil((0, 4), (2, 4), i: $i$)
            resistor("r", (2, 4), (2, 2), label: $r$)
            vsource("E", (2, 0), (2, 2), u: $E$)
            wire((0, 0), (2, 0))
        }),
    )
    The electrical equation is obtained by applying the mesh law to the electrical circuit:
    $ E_0 = E + r i + r_0 i $

    Moreover $E=Phi_0 Omega$.

    The pulley of radius $a$ is linked to the rotor, so $v_0 = a Omega$, that is $Omega = v_0 / a$.

    The mechanical equation is obtained by applying the theorem of angular momentum to the system {pulley + rotor}, the string pulling with the weight $M g$ of the mass, which moves at constant speed:
    $ 0 = J dv(Omega, t) = Phi_0 i - f Omega - M g a $

    Hence the current:
    $ i = (M g a + f v_0 \/ a) / Phi_0 $
    and, from the electrical equation, the electromotive force of the generator:
    $ E_0 = (Phi_0 v_0) / a + (r + r_0) (M g a + f v_0 \/ a) / Phi_0 $
]
