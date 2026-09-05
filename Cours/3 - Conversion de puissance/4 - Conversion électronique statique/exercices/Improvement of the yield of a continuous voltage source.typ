#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Improvement of the yield of a continuous voltage source",
)
// QUESTION 2 NE MARCHE PAS À REVOIR
#grid(
    columns: (1fr, 1fr),
    figure(
        zap.circuit({
            import zap: *
            vsource("e", (0, 0), (0, 2.5), u: $E$)
            switch("K", (0, 5), (3, 5))
            resistor("R", (3, 0), (3, 5), label: $R$)
            resistor("r", (0, 2.5), (0, 5), label: $r$)
            wire((0, 0), (3, 0))
            wire((3, 5), (3, 5))
        }),
        caption: [(a)],
        numbering: none,
    ),
    figure(
        zap.circuit({
            import zap: *
            vsource("e", (0, 0), (0, 2.5), u: $E$)
            switch("K", (2.5, 5), (5, 5))
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

We want to deliver electric power from a voltage source of electromotive force $e$ to a resistor $R$. We use a commandable switch $K$ that works periodically (closed between $n T$ and $n T+alpha T$).

The values of the components are $r=#qty("5", "O")$, $R=#qty("10", "O")$, $E=#qty("12", "V")$, $alpha=#num("0.5")$, $T=#qty("1", "us")$ and $C=#qty("100", "uF")$.

#question(
    coups-de-pouce: (),
)[
    For the circuit (a), ascertain the power received by the resistor $R$ and delivered by the generator on each part of the period. Deduce and calculate the yield of the device.
][
    / Between $0$ and $alpha T$: $u_R = R/(R+r)E$ so
    $ p_R = u_R^2/R = R/(R+r)^2 E^2 $
    $ p_e =  E^2/(R+r) $
    / Between $alpha T$ and $T$: $u_R = 0$ so $p_R = 0$
    The mean power received by the resistor is therefore $P_R = alpha R/(R+r)^2 E^2$, and the mean power delivered by the source is $P_e = alpha E^2/(R+r)$.
    
    The yield is therefore $eta = P_R/P_e = R/(R+r) approx #num(scientifique(2/3,1))$.
]

#question(
    coups-de-pouce: (),
)[
    For the circuit (b), explain why the voltage $u$ can be considered constant and ascertain its expression. Calculate the yield for the device.
][
    #let C = 100e-6
    #let T = 1e-6
    #let r = 5
    / Between $0$ and $alpha T$: $i_c = C dv(u,t) = (E-u)/r$. Let's compare two terms :
    $ abs(C dv(u,t))/abs(-u/r) tilde (C r)/T approx #num(scientifique(C*r/T,2)) >>1 $
]
