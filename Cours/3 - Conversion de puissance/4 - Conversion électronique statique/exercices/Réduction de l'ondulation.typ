#import "@local/prepa:0.1.0": *

#show: exercice.with(
    titre: "Réduction de l'ondulation.",
    ouvert: true,
)

On commande un moteur à courant continu d'inductance propre #qty("10", "mH") et de résistance négligeable à l'aide d'un hacheur constitué d'un cellule élémentaire de commutation. La tension d'alimentation est #qty("12", "V"). La période de la commande est #qty("1", "ms").
#let Lmoteur = 10e-3
#let T = 1e-3
#let E = 12

#question(
    coups-de-pouce: (
        "Exprimer l'ondulation du courant en fonction de l'inductance totale, de la période, de la tension d'alimentation et du rapport cyclique.",
        "Pour quel rapport cyclique l'ondulation est-elle maximale ?",
        "Quelle est l'inductance équivalente à deux inductances en séries ?",
    ),
)[
    Quelle inductance de lissage faut-il ajouter en sortie du hacheur pour que l'ondulation du courant ne dépasse jamais #qty("100", "mA") ?
][
    #let ondulation-max = 100e-3
    On note $E'$ la force contre-électromotrice du moteur. et $alpha$ le rapport cyclique. On considère le transistor fermée entre $0$ et $alpha T$ et ouvert entre $alpha T$ et $T$, la loi des mailles donne
    $
        u_L = cases(
            E-E' " si " 0 < t < alpha T,
            -E' " si " alpha T < t < T,
        )
    $
    soit
    $
        i = cases(
            A+(E-E')/L t " si " 0 < t < alpha T,
            B - E'/L t " si " alpha T < t < T,
        )
    $
    En utilisant la pente sur la partie $(0, alpha T)$ on obtient
    $ Delta i = (E-E')/L alpha T $

    En notant $u$ la tension totale en sorte, la loi des mailles s'écrit également $ u = L dv(i, t)+E' = cases(
        E " si " 0 < t < alpha T,
        0 " si " alpha T < t < T,
    ) $
    soit, en valeur moyenne :
    $ alpha E = E' $
    En remplaçant, on obtient alors
    $ Delta i = E alpha(1-alpha)/L T $
    Cette ondulation est maximale pour $alpha = 0.5$ où elle vaut
    $ Delta i_"max" = E/(4 L) T $
    L'inductance totale doit donc être égale au moins à
    $ L = E/(4 Delta i) T $

    #let L = E / (4 * ondulation-max) * T
    #let Lajout = L - Lmoteur
    L'impédance à ajouter est donc $ L_"ajout" = E alpha(1-alpha)/(Delta i) T - L_"moteur" = #qty(scientifique(Lajout, 2), "H") $

    Remarque : on a utilisé le fait que deux impédances en série s'additionnent. Pour le montrer, on peut écrire la loi des mailles :
    $ u_L = u_(L 1) + u_(L 2) = L_1 dv(i, t) + L_2 dv(i, t) = (L_1 + L_2) dv(i, t) $
]
