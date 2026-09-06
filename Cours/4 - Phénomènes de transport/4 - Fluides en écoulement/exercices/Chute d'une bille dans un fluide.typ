#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Chute d'une bille dans un fluide très visqueux",
)

On s'intéresse à une bille d'acier sphérique de rayon $R$, de masse $m$, de masse volumique $rho_"acier" = qty("7850", "kg/m^3")$, de vitesse $va(v)=-v ez$ lâchée sans vitesse initiale dans une éprouvette remplie de glycérine (de masse volumique $rho_"glycérine" = qty("1260", "kg/m^3")$ et de viscosité de l'ordre de $eta tilde qty("e0", "Pa s")$).

Le champ de pesanteur $va(g)$ est uniforme. On pose $g'=g(1 - rho_"glycérine"/rho_"acier")$. L'axe $(O z)$ est vertical ascendant.

L'éprouvette est de diamètre très supérieur à celui de la bille. La force de frottements visqueux exercée par le fluide sur la bille est $va(F) = -6 pi eta R va(v)$.

#let mv-acier = 7850
#let mv-glycerine = 1260
#let g = 9.81 * (1 - mv-glycerine / mv-acier)
#let viscosité = 1.26

#question(
    coups-de-pouce: (
        "Quelles sont les 3 forces qui s'exercent sur la bille ?",
        "Appliquer le théorème de la résultante cinétique à la bille.",
    ),
)[
    Déterminer l'équation différentielle vérifiée par la vitesse $v$ de la bille.
][
    Le théorème de la résultante cinétique appliqué à la bille s'écrit
    $
        m dv(va(v), t) = m va(g) + rho_"glycérine" V g ez - 6 pi eta R va(v)
    $
    Comme $va(v) = - v ez$, la projection sur $ez$ donne
    $
        - m dv(v, t) & = - m g + rho_"glycérine" V g + 6 pi eta R v \
                     & = - m g + rho_"glycérine" m/rho_"acier" g + 6 pi eta R v \
                     & = - m g' + 6 pi eta R v
    $
    Dans sa forme canonique, cette équation s'écrit
    $
        dv(v, t) + (6 pi eta R)/m v = g'
    $
]

#question[
    Calculer la durée caractéristique $tau$ associée à l'équation différentielle pour $R = qty("1.5", "mm")$.
][
    La durée caractéristique de l'équation différentielle est
    #let R = 1.5e-3
    #let tc = 2 * R * R * mv-acier / (9 * viscosité)
    $
        tau = m /(6 pi eta R) = (4/3 pi R^3 rho_"acier")/(6 pi eta R) = (2 R^2 rho_"acier")/(9 eta) = #qty(scientifique(tc, 1), "s")
    $
]

#question(
    coups-de-pouce: (
        "Quelle est la solution particulière de l'équation différentielle ?",
        "Exprimer la masse de la bille en fonction de $rho$ et de $R$.",
    ),
)[
    Exprimer la vitesse limite en fonction de $R$, $g'$, $rho_"acier"$ et $eta$.
][
    $ v_"lim" = (g' m)/(6 pi eta R) = (g' 4/3 pi R^3 rho_"acier")/(6 pi eta R) = (2g' R^2 rho_"acier")/(9 eta) $
]

#question(
    coups-de-pouce: (
        "En comparant #qty(\"1\",\"s\") et $tau$, dans quel régime se trouve-t-on ? Quelle est l'expression de la vitesse dans ce régime ?",
    ),
)[
    On mesure $v_qty("1", "s")$, la norme de la vitesse une seconde après avoir lâché la bille pour différentes tailles de bille. La courbe ci-dessous montre l'évolution de $v_qty("1", "s")$, en fonction de $R^2$. En déduire la valeur de la viscosité $eta$ de la glycérine.
][
    $qty("1", "s") >> tau$, la vitesse mesurée au bout de #qty("1", "s") est donc la vitesse limite $v_"lim" = (2g' R^2 rho_"acier")/(9 eta)$.

    Le point le plus à droite correspond à une bille de #qty("1.5","mm"). Pour les autres, le temps caractéristique est plus court encore que celui précédemment calculé.

    Les points expérimentaux sont alignés. La pente correspond à $(2 g' rho_"acier")/(9 eta)$.

    #figure(
        canvas({
            import plot: *
            let v1s(R2) = 2 * mv-acier * g / (9 * viscosité) * R2 * R2
            plot(
                size: (12, 8),
                x-label: [$R^2$ (#unit("mm^2"))],
                y-label: [$v_qty("1", "s")$ (#unit("m/s"))],
                x-min: 0,
                y-min: -0.004,
                x-max: calc.pow(1.6, 2),
                y-max: v1s(1.7e-3),
                x-tick-step: 1,
                x-minor-tick-step: 0.1,
                y-tick-step: 0.01,
                y-minor-tick-step: 0.002,
                {
                    let data = for i in range(1, 11) {
                        let R = i * 1.5/10
                        let rnd = calc.rem(calc.pi * 31*i, 1) - 0.5
                        let x = calc.pow(R, 2)
                        let y = v1s(R * 1e-3) + rnd * 0.004
                        ((x, y),)
                    }
                    for point in data {
                        add-errorbar(
                            point,
                            y-error: 0.002,
                            style: (stroke: black),
                            mark-style: (stroke: black, fill: gray),
                        )
                    }
                    add(domain: (0, calc.pow(1.6, 2)), x => v1s(calc.sqrt(x) * 1e-3))
                },
            )
        }),
    )
    #let p = 0.029/2.4e-6
    Une lecture graphique donne une pente de $p=qty("0.029", "m/s")/qty("2.4", "mm^2") = #qty(scientifique(p, 2), "/s/m")$.

    On a donc
    #let visc = 2 * g * mv-acier / (9 * p)
    $
        eta = (2 g' rho_"acier")/(9 p) = #qty(scientifique(visc, 2), "Pl")
    $
]
#figure(
        canvas({
            import plot: *
            let v1s(R2) = 2 * mv-acier * g / (9 * viscosité) * R2 * R2
            plot(
                size: (12, 8),
                x-label: [$R^2$ (#unit("mm^2"))],
                y-label: [$v_qty("1", "s")$ (#unit("m/s"))],
                x-min: 0,
                y-min: -0.004,
                x-max: calc.pow(1.6, 2),
                y-max: v1s(1.7e-3),
                x-tick-step: 1,
                x-minor-tick-step: 0.1,
                y-tick-step: 0.01,
                y-minor-tick-step: 0.002,
                {
                    let data = for i in range(1, 11) {
                        let R = i * 1.5/10
                        let rnd = calc.rem(calc.pi * 31*i, 1) - 0.5
                        let x = calc.pow(R, 2)
                        let y = v1s(R * 1e-3) + rnd * 0.004
                        ((x, y),)
                    }
                    for point in data {
                        add-errorbar(
                            point,
                            y-error: 0.002,
                            style: (stroke: black),
                            mark-style: (stroke: black, fill: gray),
                        )
                    }
                },
            )
        }),
    )
#question(
    coups-de-pouce: (
        "Le nombre de Reynolds croît-il ou décroit-il avec $R$ ?",
    ),
)[
    Calculer le nombre de Reynolds pour la plus grosse sphère. Est-il légitime de considérer des frottements fluides linéaires ?
][
    #let R = 1.5e-3
    #let v = 2 * mv-acier * g / (9 * viscosité) * R * R
    #let reynolds = v * 2 * R * mv-glycerine / viscosité
    La plus grosse bille ($R = #qty("1.5", "mm")$) atteint $v_"lim" = #qty(scientifique(v, 2), "m/s")$, d'où
    $ R_e = (v D)/nu = (2 v R rho_"glycérine")/eta = #num(scientifique(reynolds, 2)) $

    $R_e$ est d'autant plus grand que $R$ est grand. Il est très inférieur à $1$ pour la plus grande des billes, donc pour toutes les autres aussi. Il est donc légitime de considérer un modèle linéaire des frottements fluides.
]