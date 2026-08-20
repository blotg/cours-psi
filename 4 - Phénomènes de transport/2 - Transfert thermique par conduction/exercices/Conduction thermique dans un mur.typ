#import "@local/prepa:0.1.0": *

#show: exercice.with(
    titre: "Conduction thermique dans un mur",
)

On s'intéresse à un mur de surface $S=qty("30", "m^2")$ qui sépare l'intérieur d'une maison de son extérieur. Le mur est constitué d'une épaisseur $e_p=#qty("30", "cm")$ de pierre de conductivité thermique $lambda_p=qty("2.2", "W/m/K")$ et d'une épaisseur $e_l=qty("15", "cm")$ de laine de verre de de conductivité thermique $lambda_l=qty("0.03", "W/m/K")$.

L'intérieur de la maison est à une température $T_i=qty("20", "Celsius")$ et l'extérieur à $T_e=qty("5", "Celsius")$. Pour un fluide en contact avec un solide, le vecteur densité de courant thermique $va(j)$ suit la loi de Newton : $va(j)=h(T_s-T_infinity) va(e)$ où $va(e)$ est un vecteur unitaire dirigé du solide vers le fluide, $h=qty("10", "W/m^2/K")$ pour l'air, $T_s$ la température du solide à sa surface et $T_infinity$ la température du fluide loin du solide. Le contact thermique entre la pierre et la laine de verre est parfait.

L'étude s'intéresse au régime stationnaire.

#figure(
    canvas({
        import draw: *
        line((-2, 1.5), (-2, -1.5))
        line((0, 1.5), (0, -1.5))
        line((2, 1.5), (2, -1.5))
        content((-1, 0), "Pierre")
        content((1, 0), [#set align(center); Laine de\ verre])
        content((-3, 0), [Air \ ($T_e$)])
        content((3, 0), [Air \ ($T_i$)])
        line((-2, -1.4), (0, -1.4), mark: (symbol: ">>", fill: black), name: "ep")
        line((2, -1.4), (0, -1.4), mark: (symbol: ">>", fill: black), name: "el")
        content("ep.mid", $e_p$, anchor: "north")
        content("el.mid", $e_l$, anchor: "north")
    }),
)

#question(
    coups-de-pouce: (
        "A quelle condition $\vv{j}$ est-il continu ?",
        "A quelle condition $T$ est-il continu ?",
    ),
)[
    Quelles sont les conditions aux limites vérifiées à chaque interface (par $T$ ou par $va(j)$) ?
][
    Le contact thermique entre la pierre et la laine de verre est parfait donc $T$ est continu à l'interface pierre/laine de verre.

    Le vecteur densité de courant thermique $va(j_Q)$ est continu à chaque interface.
]

#let S = 30
#let ep = 30e-2
#let el = 15e-2
#let lambda-p = 2.2
#let lambda-l = 0.03
#let Rp = ep / (lambda-p * S)
#let Rl = el / (lambda-l * S)
#question(
    coups-de-pouce: (
        "Appliquer la formule du cours reliant résistance thermique, épaisseur, surface et conductivité thermique.",
    ),
)[
    Calculer la résistance thermique associée à chaque partie du mur (en pierre et en laine de verre).
][
    La résistance thermique d'une couche plane de matériau est donnée par la formule $R_"th" = e/(lambda S)$ où $e$ est l'épaisseur, $lambda$ la conductivité thermique et $S$ la surface.

    Pour la pierre :
    $
        R_"th,pierre" = e_p/(lambda_p S) = qty(#scientifique(Rp, 2), "K/W")
    $

    Pour la laine de verre :
    $
        R_"th,laine" = e_l/(lambda_l S) = qty(#scientifique(Rl, 1), "K/W")
    $
]

#question(
    coups-de-pouce: (
        "Exprimer la différence de température en fonction du flux thermique pour la loi de Newton.",
    ),
)[
    Montrer que la loi de Newton peut donner lieu à une résistance thermique qu'on précisera.
][
    La loi de Newton s'écrit $va(j)=h(T_s-T_infinity) va(e)$. Le flux thermique s'écrit donc $Phi = S j = h S (T_s - T_infinity)$.

    On peut réécrire cette relation sous la forme $T_s - T_infinity = phi/(h S)$.

    On en déduit que la résistance thermique associée au transfert thermique entre le solide et le fluide est $R_"th,conv" = 1/(h S)$.
]

#let h = 10
#let Rconv = 1/(h*S)
#let Req = Rconv + Rp + Rl + Rconv
#question(
    coups-de-pouce: (
        "Le circuit comporte 4 résistances thermiques.",
    ),
)[
    Tracer le circuit équivalent et calculer la résistance équivalente.
][
    #figure(
        zap.circuit({
            import zap: *
            import draw: *
            resistor("Rc1", (0, 0), (2.5, 0), label: $R_"th,conv"$, i: (content: $Phi$, anchor: "north-west"))
            resistor("Rp", (2.5, 0), (5, 0), label: $R_"th,pierre"$)
            resistor("Rl", (5, 0), (7.5, 0), label: $R_"th,laine"$)
            resistor("Rc2", (7.5, 0), (10, 0), label: $R_"th,conv"$)
            line((0, -0.5), (10, -0.5), mark: (end: ">>", fill: black), name: "L")
            content("L.mid", $T_i - T_e$, anchor: "north", padding: .4em)
            content((0, 0), $T_e$, anchor: "east")
            content((10, 0), $T_i$, anchor: "west")
        }),
    )
    Les résistances thermiques sont en série. La résistance thermique équivalente est donc la somme des résistances thermiques :
    $
        R_"th,eq" = R_"th,conv" + R_"th,pierre" + R_"th,laine" + R_"th,conv" = qty(#scientifique(Req, 1), "K/W")
    $
]

#let Ti = 20
#let Te = 5
#question(
    coups-de-pouce: (
        "Calculer le flux total traversant le mur.",
        "Effectuer un bilan d'énergie sur l'intérieur de la maison pour montrer que la puissance fournie par le chauffage doit compenser exactement la puissance perdue par les murs.",
    ),
)[
    Si on suppose que les seules pertes thermiques de la pièce sont celles traversant le mur, quelle puissance doit fournir le radiateur de la pièce ?
][
    La puissance thermique perdue par le mur est donnée par la loi d'Ohm thermique : $Phi = (T_i - T_e)/R_"th,eq"$.

    On trouve : $
        Phi = qty(#scientifique((Ti - Te)/Req, 1), "W")
    $

    Pour maintenir la température intérieure constante, le radiateur doit fournir une puissance égale à cette puissance perdue. En effet, en régime stationnaire, le bilan d'énergie sur l'intérieur de la maison impose que la puissance fournie par le chauffage compense exactement la puissance perdue par les murs.
]
