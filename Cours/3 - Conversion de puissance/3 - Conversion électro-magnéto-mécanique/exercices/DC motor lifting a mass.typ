#import "@local/prepa:0.1.0": *

#show: exercice.with(
    titre: "DC motor lifting a mass",
    difficulté: 2,
)

#figure(image("../figures/3.png", width: 8cm))

A DC machine of coupling constant $Phi_0$, of internal resistance $r$ and of inductance $L$ is used to lift a mass $M$. The axis of the rotor is connected to a pulley of radius $a$. On the pulley is fixed a string on which a mass is attached.

A friction couple $Gamma_f=-f Omega$ apply on the rotor. The moment of inertia of the system {rotor + pulley} is $J$. Hysteresis and Foucault currents are neglected.

The mass is lifted at a constant speed $v_0$.

#question(
    coups-de-pouce: (
        "Écrire une équation électrique et une équation mécanique et utiliser les relations entre grandeurs mécaniques et électriques pour une machine à courant continu.",
        "Pour l'équation électrique, écrire la loi des mailles dans le circuit électrique équivalent de l'induit.",
        "Pour l'équation mécanique, écrire le théorème du moment cinétique au système masse + cable + poulie + rotor.",
    ),
)[
    Ascertain the current $i$ and the voltage $E_0$ delivered by the generator as a function of $M$, $g$, $a$, $Phi_0$, $f$, $r$, $r_0$.
][
    Since the mass is lifted at a constant speed, every values are constant over time. The inductance $L$ will have no influence and is not represented on the electrical schematic.

    #figure(
        zap.circuit({
            import zap: *
            import draw: *
            vsource("E0", (0, 0), (0, 2), u: $E_0$)
            resistor("r", (0, 2), (0, 4), label: $r_0$)
            wire((0, 4), (2, 4), i: $i$)
            resistor("r", (2, 4), (2, 2))
            vsource("E", (2, 0), (2, 2), u: $E$)
            wire((0, 0), (2, 0))
        }),
    )
    The electrical equation is obtained by applying the mesh law to the electrical circuit:
    $ E_0 = E + r i + r_0 i $

    Moreover $E=Phi_0 Omega$.

    The pulley of radius $a$ is linked to the rotor, so $v_0 = a Omega$.

    The mechanical equation is obtained by applying the theorem of angular momentum to the system {pulley + rotor}:
    $ 0 = J dv(Omega, t) = Phi_0 i + -f Omega - M g a $

    From these equations, we obtain:
    $ i = (M g a Phi_0 + f E_0) / (f (r_0+r) + Phi_0^2) $
    $ E_0 = ((r+r_0) (M g a Phi_0 + f E_0))/(f(r_0+r)+Phi_0^2) + (Phi_0 v_0) / a $
]
