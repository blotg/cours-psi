#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Improving the efficiency of a DC voltage source",
)
#grid(
    columns: (1fr, 1fr),
    figure(
        circuit({
            import zap: *
            vsource("e", (0, 0), (0, 2.5), u: $E$)
            switch("K", (0, 5), (3, 5), label: $K$)
            resistor("R", (3, 0), (3, 5), label: $R$)
            resistor("r", (0, 2.5), (0, 5), label: $r$)
            wire((0, 0), (3, 0))
        }),
        caption: [(a)],
        numbering: none,
    ),
    figure(
        circuit({
            import zap: *
            vsource("e", (0, 0), (0, 2.5), u: $E$)
            switch("K", (2.5, 5), (5, 5), label: $K$)
            resistor("R", (5, 0), (5, 5), label: $R$)
            resistor("r", (0, 2.5), (0, 5), label: $r$)
            capacitor("C", (2.5, 0), (2.5, 5), label: $C$, u: (content: $u$, anchor: "south"))
            wire((0, 0), (5, 0))
            wire((2.5, 5), (0, 5))
        }),
        numbering: none,
        caption: [(b)],
    ),
)

We want to deliver electric power from a DC voltage source of electromotive force $E$ and internal resistance $r$ to a resistor $R$. We use a controlled switch $K$ that works periodically (closed between $n T$ and $n T+alpha T$, open the rest of the time).

The values of the components are $r=#quan[5 Ω]$, $R=#quan[10 Ω]$, $E=#quan[12 V]$, $alpha=#num("0.5")$, $T=#quan[1 us]$ and $C=#quan[100 uF]$.

#question(
    coups-de-pouce: (
        "When the switch is closed, $r$ and $R$ are in series. What is the current when it is open?",
        "The efficiency is the ratio of the mean power received by $R$ to the mean power delivered by the source.",
    ),
)[
    For the circuit (a), determine the power received by the resistor $R$ and the power delivered by the source during each part of the period. Deduce the efficiency of the device and calculate it.
][
    / Between $0$ and $alpha T$: the switch is closed, $u_R = R/(R+r)E$ so
    $ p_R = u_R^2/R = R/(R+r)^2 E^2 $
    $ p_E =  E^2/(R+r) $
    / Between $alpha T$ and $T$: the switch is open, there is no current so $p_R = 0$ and $p_E = 0$.
    The mean power received by the resistor is therefore $P_R = alpha R/(R+r)^2 E^2$, and the mean power delivered by the source is $P_E = alpha E^2/(R+r)$.

    The efficiency is therefore $ eta = P_R/P_E = R/(R+r) approx #quan[67 %] $
]

#question(
    coups-de-pouce: (
        "Compare the period $T$ with the time constants $r C$ and $R C$.",
        "Apply Kirchhoff's current law at the upper terminal of the capacitor, when the switch is closed and when it is open.",
        "In a periodic steady state, what is the mean value of the current through a capacitor?",
        "The source delivers the current that flows through $r$.",
    ),
)[
    For the circuit (b), explain why the voltage $u$ can be considered constant and determine its expression. Calculate the efficiency of the device.
][
    #let C = 100e-6
    #let T = 1e-6
    #let r = 5
    #let R = 10
    #let E = 12
    #let α = 0.5
    Let $i_C = C dv(u, t)$ be the current through the capacitor. Kirchhoff's current law gives
    $
        i_C = cases(
            (E-u)/r - u/R " if " 0 < t < alpha T " (switch closed)",
            (E-u)/r " if " alpha T < t < T " (switch open)",
        )
    $
    In both cases $abs(i_C)$ is at most of the order of $E \/ r$, so the variation of $u$ during one period is at most of the order of
    $ Delta u tilde E/r T/C quad "that is" quad (Delta u)/E tilde T/(r C) = #num(T/(r*C), chiffres: 1) << 1 $
    (likewise, $T \/ (R C) = #num(T/(R*C), chiffres: 1) << 1$). The capacitor does not have enough time to charge or discharge noticeably during one period: $u$ can be considered constant.

    In a periodic steady state, the mean value of $i_C = C dv(u, t)$ is zero. With $u$ constant,
    $ mean(i_C) = (E-u)/r - alpha u/R = 0 quad "so" quad u = R/(R + alpha r) E = #qty(R/(R + α*r)*E, "V", chiffres: 2) $

    The resistor $R$ receives the power $u^2 \/ R$ between $0$ and $alpha T$ only, so $P_R = alpha u^2 \/ R$. The source delivers at all times the current $(E-u) \/ r = alpha u \/ R$, so $P_E = E (E-u) \/ r = alpha E u \/ R$. The efficiency is therefore
    $ eta = P_R/P_E = u/E = R/(R + alpha r) = #quan[80 %] $
    It is higher than with the circuit (a): thanks to the capacitor, the source delivers a smaller current, but continuously, and the Joule losses in $r$ are reduced.
]
