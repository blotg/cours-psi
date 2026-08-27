#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Summing amplifier",
)

In the previous exercise, we have seen the necessity for a summing system in order to realize an amplitude modulation. This system can be realized by the following assembly in which the operational amplifier is ideal.

#figure(
    zap.circuit({
        import zap: *
        import draw: *
        set-style(padding: .4em)
        opamp("ALI", (0, 0))
        resistor("R", (-1.5,1.5), (1.5,1.5), label: $R$)
        swire("ALI.minus", "R.in")
        swire("R.out", "ALI.out", axis: "y")
        wire("ALI.out", (rel: (1.2, 0)))
        content((rel: (1.2, 0), to: "ALI.out"), $v_s$, anchor: "west", padding: .3em)

        resistor(
            "R2",
            (rel: (-1, 0), to: "ALI.minus"),
            (rel: (-2.3, 0)),
            label: (content: $R_2$, anchor: "south"),
        )
        swire("ALI.minus", "R2.in")
        content("R2.out", $v_2$, anchor: "east", padding: .3em)

        resistor(
            "R1",
            (rel: (-1, 2), to: "ALI.minus"),
            (rel: (-2.3, 0)),
            label: (content: $R_1$, anchor: "south"),
        )
        swire("ALI.minus", (rel: (-1, 0)), (rel: (0, 2)), "R1.in")
        content("R1.out", $v_1$, anchor: "east", padding: .3em)

        frame("G", (-1.5, -1.5))
        swire("ALI.plus", "G")
    }),
)

#question(
    coups-de-pouce: (
        "Utiliser la loi des nœuds en termes de potentiels à l'entrée inverseuse de l'ALI.",
        "Écrire la loi des nœuds à l'entrée de l'ALI. Remplacer chacun des courants par son expression à partir de la loi d'Ohm.",
        "Quelle différence de potentiel y a-t-il aux bornes de chaque résistor (en fonction de $v_1$, $v_2$, $v_s$ et $V_-$) ?",
    ),
)[
    Ascertain the expression of $V_-$ as a function of $v_1$, $v_2$ and $v_s$.
][
    Kirchhoff's law at the inverting input node : $i_1+i_2+i+i_- = 0$.

    But $i_- approx 0$, so $i_1+i_2+i=0$, i.e.
    $
        1/R_1 (v_1-V_-) + 1/R_2 (v_2-V_-) + 1/R (v_s-V_-) = 0
    $
    $
        V_- (1/R_1+1/R_2+1/R) = v_1/R_1+v_2/R_2+v_s/R
    $
    $
        V_- = (v_1/R_1+v_2/R_2+v_s/R)/(1/R_1+1/R_2+1/R)
    $
]

#question(
    coups-de-pouce: (
        "Que peut-on dire de $V_-$ ?",
        "Le montage est-il stable ou instable ?",
        "Que vaut l'entrée différentielle de l'ALI ?",
    ),
)[
    Deduce an expression of $v_s$ as a function of $v_1$ and $v_2$.
][
    The op-amp is ideal and the feedback is negative, so it operates in the linear regime : $epsilon = 0$, hence $V_- = V_+ = 0$ (the non-inverting input is grounded).

    Injecting $V_-=0$ in the previous relation,
    $
        v_1/R_1+v_2/R_2+v_s/R = 0
    $
    $
        v_s = -R(v_1/R_1+v_2/R_2)
    $
]

#question()[
    Under which condition does $v_s=-(v_1+v_2)$ ?
][
    If $R=R_1=R_2$, then $v_s=-v_1-v_2$.
]

#question(
    coups-de-pouce: (
        "Parmi les montages vus, lequel a une fonction de transfert indépendante de $j omega$ et négative ?",
        "La fonction de transfert d'un amplificateur inverseur est $underline(H)(j omega) = -R_2/R_1$.",
    ),
)[
    The aim is to have $v_(s,2)=v_1+v_2$. Which transfer function needs to be placed after the previous system to obtain $v_(s,2)$ ? Suggest an electronic assembly that would have this transfer function.
][
    $
        H_2 = v_(s,2)/v_s = (v_1+v_2)/(-v_1-v_2) = -1
    $
    An inverting amplifier can have this transfer function :
    $
        H_2 = -R_3/R_4 arrow.double.r "if" R_3=R_4 arrow.double.r H_2=-1
    $

    #figure(
        zap.circuit({
            import zap: *
            import draw: *
            set-style(padding: .4em)
            opamp("ALI2", (0, 0))
            resistor(
                "R3",
                (-1.5,1.5),
                (1.5,1.5),
                label: $R_3 = qty("10","kO")$,
            )
            swire("ALI2.minus", "R3.in")
            swire("R3.out", (rel: (0, -1.5)), "ALI2.out")

            resistor(
                "R4",
                (rel: (-1, 0), to: "ALI2.minus"),
                (rel: (-2.3, 0)),
                label: (content: $R_4 = qty("10","kO")$, anchor: "south"),
            )
            swire("ALI2.minus", "R4.in")
            content("R4.out", $v_s$, anchor: "east", padding: .3em)

            wire("ALI2.plus", (rel: (-1, 0)))
            frame("G", (rel: (-1, 0), to: "ALI2.plus"))
            wire("ALI2.out", (rel: (1.2, 0)))
            content((rel: (1.2, 0), to: "ALI2.out"), $v_(s,2)$, anchor: "west", padding: .3em)
        }),
    )
]
