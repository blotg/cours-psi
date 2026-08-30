#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Hartley oscillator",
    difficulté: 1,
)

First, we will study the electronic filter below, named Hartley filter.

#figure(
    zap.circuit({
        import zap: *
        import draw: *
        set-style(padding: .4em)
        resistor("R", (-3, 0), (0, 0), label: $R$)
        content("R.in", $e$, anchor: "east", padding: .4em)
        content("R.out", $A$, anchor: "south", padding: .3em)
        capacitor("C", "R.out", (rel: (0, -3)), label: $C$)
        frame("G1", "C.out")
        inductor("L1", "R.out", (rel: (3, 0)), label: $L$, variant: "ieee")
        content("L1.out", $s$, anchor: "south-west", padding: .3em)
        inductor("L2", "L1.out", (rel: (0, -3)), label: $L$, variant: "ieee")
        frame("G2", "L2.out")
    }),
)

#question(
    coups-de-pouce: (
        "Si la relation des nœuds en tension n'est pas connue, appliquer la loi des nœuds et remplacer chaque courant en faisant apparaitre une tension grâce à la loi d'Ohm (en complexes) dans $R$, $L$ et $C$.",
    ),
)[
    Using Kirchhoff's nodal rule in $A$, express its potential $V_A (p)$ as a function of the voltages $e$ and $s$.
][
    #figure(
        zap.circuit({
            import zap: *
            import draw: *
            set-style(padding: .4em)
            resistor("R", (-3, 0), (0, 0), label: $R$, i: $i_R$)
            content("R.in", $e$, anchor: "east", padding: .4em)
            content("R.out", $A$, anchor: "south", padding: .3em)
            capacitor("C", "R.out", (rel: (0, -3)), label: $C$, i: $i_C$)
            frame("G1", "C.out")
            inductor("L1", "R.out", (rel: (3, 0)), label: $L$, variant: "ieee", i: $i_L$)
            content("L1.out", $s$, anchor: "south-west", padding: .3em)
            inductor("L2", "L1.out", (rel: (0, -3)), label: $L$, variant: "ieee")
            frame("G2", "L2.out")
        }),
    )
    La loi des nœuds en $A$ donne
    $
        i_R - i_C - i_L = 0
    $
    $
        (E(p)-V_A (p))/R - C p V_A (p) - (V_A (p)- S(p))/(L p) = 0
    $
    soit, en isolant $V_A$,
    $
        V_A (p) (-1/R -C p - 1 / (L p)) = - E(p)/R - S(p)/(L p)
    $
    $
      V_A (p) = (E(p)/R + S(p)/(L p)) / (1/R + C p + 1/(L p)) = 
        (L p E(p) + R S(p)) / (R L C p^2 + L p + R)
    $
]

#question(
    coups-de-pouce: (
        "Ascertain $s$ as a function of the potential in $A$ thanks to the voltage divider law."
    ),
)[
    Determine the transfer function of the Hartley filter.
][
    Les deux inductances $L$ sont parcourues par le même courant (aucun courant ne sort par la sortie $s$) : elles forment un pont diviseur de tension entre $A$ et la masse, la sortie $s$ étant prise à leur point milieu :
    $
        S(p) = (L p)/(L p+L p) V_A (p) = (V_A (p))/2 quad arrow.double quad V_A (p) = 2 S(p)
    $
    En reportant dans la relation de la question précédente,
    $
      2 S(p) (R L C p^2 + L p + R) = L p E(p) + R S(p)
    $
    $
      S(p) (2 R L C p^2 + 2 L p + 2 R - R) = L p E(p)
    $
    d'où la fonction de transfert du filtre de Hartley
    $
        H(p) = S(p)/E(p) = (L p)/(R+2L p+2R L C p^2)
    $
]

The complete Hartley oscillator's electrical schema is shown below.

#figure(
    zap.circuit({
        import zap: *
        import draw: *
        set-style(padding: .4em)
        opamp("ALI", (0, 0), invert: true)
        resistor("R1", (-1.5, -1.5), (-1.5, -4), label: $R_1$)
        resistor("R2", (-1.5, -1.5), (1.5, -1.5), label: (content: $R_2$, anchor: "south"))
        swire("ALI.minus", (-1.5, -1.5))
        swire("ALI.out", (1.5, -1.5))
        frame("G3", "R1.out")
        content((1.5, 0), $e$, anchor: "south", padding: .3em)
        resistor("Rf", (1.5, 0), (rel: (3, 0)), label: $R$)
        content("Rf.out", $A$, anchor: "south", padding: .3em)
        capacitor("Cf", "Rf.out", (rel: (0, -4)), label: $C$)
        frame("G4", "Cf.out")
        inductor("Lf1", "Rf.out", (rel: (3, 0)), label: $L$, variant: "ieee")
        content("Lf1.out", $s$, anchor: "west", padding: .3em)
        inductor("Lf2", "Lf1.out", (rel: (0, -4)), label: (content: $L$, anchor: "north"), variant: "ieee")
        frame("G5", "Lf2.out")
        swire("Lf1.out", (-1.5, 2), "ALI.plus", axis: "y")
    }),
)

#question(
    coups-de-pouce: (
        "Pour reconnaitre le montage à ALI, celui-ci est-il stable ou instable ? L'entrée est-elle \"côté\" borne inverseuse ou non-inverseuse ?",
    ),
)[
    Which operational amplifier assembly can be recognized? Give its transfer function without any demonstration.
][
    L'ALI est bouclé sur son entrée inverseuse par $R_1$ et $R_2$ (rétroaction négative), et l'entrée $s$ du montage arrive sur l'entrée non-inverseuse : on reconnait un *montage amplificateur non-inverseur*, de fonction de transfert (sortie $e$, entrée $s$)
    $
        G(p) = E(p)/S(p) = 1+R_2/R_1
    $
]

#question(
    coups-de-pouce: (
        "Obtenir une équation différentielle portant sur $s$ ou sur $e$.",
        "Transformer la fonction de transfert du filtre de Hartley en une équation différentielle sur $s$ et $e$. Remplacer l'un des deux en utilisant la relation entrée-sortie d'un amplificateur non-inverseur.",
        "Les solutions de l'équation différentielle doivent-elles converger ou diverger pour que les oscillations démarrent.",
    ),
)[
    Under which condition do the oscillations *start*?
][
    En reprenant $S(p) (R+2L p+2R L C p^2) = L p E(p)$ (filtre de Hartley) et $E(p)=(1+R_2/R_1)S(p)$ (amplificateur non-inverseur),
    $
        S(p) (R+2L p+2R L C p^2) = L p(1+R_2/R_1) S(p)
    $
    $
        S(p) (R+[2L-L(1+R_2/R_1)]p+2R L C p^2) = 0
    $
    $
        S(p) (R+L(1-R_2/R_1)p+2R L C p^2) = 0
    $
    ce qui donne, en passant dans le domaine temporel,
    $
        2R L C dv(s, t, 2) + L(1-R_2/R_1) dv(s, t) + R s = 0
    $
    Les oscillations démarrent si ce système bouclé est instable, c'est-à-dire si le coefficient de $dv(s, t)$ est négatif :
    $
        1-R_2/R_1 < 0 arrow.double R_2 > R_1
    $
]

#question(
    coups-de-pouce: (
        "En partant de la fonction de transfert du filtre de Hartley, éliminer $E$ et $S$.",
        "Éliminer les fractions de l'équation ainsi obtenue et en prendre partie réelle et partie imaginaire.",
    ),
)[
    How sinusoidal oscillations can be obtained? What will be their frequency?
][
    Des oscillations sinusoïdales entretenues correspondent au cas limite (marginalement stable) de l'équation différentielle précédente, soit $p=j omega$ dans
    $
        R+L(1-R_2/R_1)j omega-2R L C omega^2 = 0
    $
    En séparant partie réelle et partie imaginaire,
    $
        cases(
            "partie réelle :" quad & R-2R L C omega^2 = 0,
            "partie imaginaire :" quad & L(1-R_2/R_1) omega = 0,
        )
    $
    La partie imaginaire donne (pour $omega eq.not 0$) la condition
    $
        R_2 = R_1
    $
    (cas limite de la question précédente), et la partie réelle donne la pulsation des oscillations
    $
        omega_0 = 1/sqrt(2 L C)
    $
    soit une fréquence $f_0 = omega_0/(2 pi) = 1/(2 pi sqrt(2 L C))$.
]

#question(
    coups-de-pouce: (
        "Quelles sont les amplitudes de $e$ et $s$ ?",
        "Qu'est-ce qui limite l'amplitude des oscillations ?",
    ),
)[
    What is the amplitude of $e$? What is the one of $s$?
][
    La tension $e$ est la tension de sortie de l'ALI : son amplitude est limitée par la saturation de l'ALI, elle vaut $V_"sat"$.

    À la pulsation $omega_0$, la partie réelle du dénominateur de $H$ est nulle (question précédente), il reste
    $
        H(j omega_0) = (L j omega_0)/(2L j omega_0) = 1/2
    $
    L'amplitude de $s$ vaut donc
    $
        hat(s) = 1/2 V_"sat"
    $
]

#question(
    coups-de-pouce: (
        "Est-ce l'amplificateur non-inverseur ou le filtre de Hartley qui \"purifie\" le spectre de son entrée ?",
    ),
)[
    Which voltage will be the most sinusoidal?
][
    La tension $e$ est la sortie saturée de l'ALI, dont le spectre est riche en harmoniques. La tension $s$ est la sortie du filtre de Hartley, un filtre passe-bande qui atténue les harmoniques autour de la fréquence centrale. C'est donc $s$ qui est la tension la plus sinusoïdale.
]
