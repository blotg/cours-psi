#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Perte de charge dans un élargissement brusque",
    difficulté: 1,
)

On s'intéresse à une conduite présentant un élargissement brutal, comme le montre la figure ci-dessous. L'écoulement est homogène, incompressible et le régime est stationnaire.

#figure(
    canvas({
        import cetz.draw: *
        merge-path(
            {
                line((2, 1), (2, 2), (10, 2))
                bezier((10, 2), (2, 1), (6, 2), (4, 1))
            },
            fill: black.lighten(75%),
            stroke: none,
        )

        merge-path(
            {
                line((2, -1), (2, -2), (10, -2))
                bezier((10, -2), (2, -1), (6, -2), (4, -1))
            },
            fill: black.lighten(75%),
            stroke: none,
        )

        group({
            stroke(2pt)
            line((-1, 1), (2, 1), (2, 2), (10, 2))
            line((-1, -1), (2, -1), (2, -2), (10, -2))
        })

        stroke(.5pt)
        let mid-flèche = (end: ">>", fill: black, pos: 50%, shorten-to: none)
        line((-1, 1), (2, 1))
        bezier((2, 1), (10, 2), (4, 1), (6, 2), mark: mid-flèche)
        line((-1, .5), (2, .5))
        bezier((2, .5), (10, 1), (4, .5), (6, 1), mark: mid-flèche)
        line((-1, 0), (2, 0))
        line((2, 0), (10, 0), mark: mid-flèche)
        line((-1, -.5), (2, -.5))
        bezier((2, -.5), (10, -1), (4, -.5), (6, -1), mark: mid-flèche)
        line((-1, -1), (2, -1))
        bezier((2, -1), (10, -2), (4, -1), (6, -2), mark: mid-flèche)

        set-style(stroke: (dash: "dashed", thickness: 1pt))
        line((-1, -1), (-1, 1))
        content((), $S_1$, anchor: "south", padding: .4em)
        line((10, -2), (10, 2))
        content((), $S_2$, anchor: "south", padding: .4em)

        content((-1, 0), $P_1$, anchor: "east", padding: .6em)
        content((10, 0), $P_2$, anchor: "west", padding: .6em)
        content((3.2, 1.65), [eau morte])
    }),
)

On suppose l'écoulement turbulent. Les lignes de courant représentées sont des courbes moyennes. Pour simplifier les calculs, on considère le champ de vitesse uniforme dans la section d'entrée $S_1$.

Bien que le changement de section soit brutal, la section effective de l'écoulement varie lentement. Expérimentalement, on observe que l'écoulement devient quasiment uniforme au-delà d'une distance d'environ vingt fois le diamètre $d_2$ de la grande section.

On note $va(v)_1$ la vitesse en amont de l'écoulement et $va(v)_2$ la vitesse en aval.

La zone d'"eau morte" symbolisée sur le schéma par une zone grise est une zone de recirculation où il y a dissipation d'énergie mécanique. C'est elle qui est responsable de la perte de charge. La norme du champ des vitesses y est partout assez faible par rapport aux valeurs prises dans l'écoulement proprement dit. L'eau y est au repos sur une large épaisseur au contact des parois.

On néglige l'influence de la gravité.

#question(
    coups-de-pouce: (
        "Écrire la relation de Bernoulli entre la section gauche et l'élargissement.",
    ),
)[
    Expliquer pourquoi la pression vaut $P_1$ dans la partie gauche de la zone d'eau morte, au contact de l'élargissement vertical.
][
    On considère la ligne de courant la plus haute.
    #figure(
        canvas({
            import cetz.draw: *
            merge-path(
                {
                    line((2, 1), (2, 2), (10, 2))
                    bezier((10, 2), (2, 1), (6, 2), (4, 1))
                },
                fill: black.lighten(75%),
                stroke: none,
            )

            merge-path(
                {
                    line((2, -1), (2, -2), (10, -2))
                    bezier((10, -2), (2, -1), (6, -2), (4, -1))
                },
                fill: black.lighten(75%),
                stroke: none,
            )

            group({
                stroke(2pt)
                line((-1, 1), (2, 1), (2, 2), (10, 2))
                line((-1, -1), (2, -1), (2, -2), (10, -2))
            })

            stroke(.5pt)
            line((-1, .9), (2.2, .9), mark: (symbol: "o", fill: black))

            content((-1, 0.9), $A$, anchor: "north", padding: .4em)
            content((2.2, .9), $B$, anchor: "north", padding: .4em)
            content((-1, 0), $P_1$, anchor: "east", padding: .6em)
            content((3, 1.5), $P$)
        }),
    )
    En appliquant le théorème de Bernoulli entre les points $A$ et $B$, on obtient
    $ P_1 + 1/2 mu v_1^2 = P + 1/2 mu v_B^2 $
    Or, le débit volumique se conserve (écoulement incompressible et homogène) d'où $v_1 S_1 = v_B S_1$ donc $v_B = v_1$, ce qui donne $ P = P_1 $
    On peut de plus remarquer que cette pression $P$ est uniforme dans la zone d'eau morte car l'équation fondamentale de l'hydrostatique s'écrit
    $
        grad(P) = mu va(g) = va(0)
    $
    car les effets de la pesanteur sont négligés. On en déduit que $P = P_1$ dans toute la zone d'eau morte.
]

#question(
    coups-de-pouce: (
        "Représenter sur un schéma les forces de pression s'exerçant tout autour du système. Sur quelle surface s'exerce la pression $P_1$ ? Sur quelle surface s'exerce la pression $P_2$ ?"
    ),
)[
    Au moyen d'un bilan de quantité de mouvement sur un système fermé bien choisi, exprimer la chute de pression $P_1-P_2$ entre l'amont et l'aval en fonction de $mu$, $v_1$ et des sections.
][
    D'après la question précédente, la pression vaut $P_1$ dans toute la zone d'eau morte : la pression s'exerce donc bien sur toute la section $S_2$ de la face amont, et non sur la seule section $S_1$.

    On définit les systèmes suivants :
    - $Sigma^0$ le système ouvert délimité par les surfaces $S_1$ et $S_2$
    - $delta Sigma_1$ le système franchissant $S_1$ entre les temps $t$ et $t+dd(t)$
    - $delta Sigma_2$ le système franchissant $S_2$ entre les temps $t$ et $t+dd(t)$
    - le système fermé $Sigma^*$ composé à l'instant $t$ de $Sigma^0(t)union delta Sigma_1$
    $Sigma^*(t+dd(t))$ est donc composé, à l'instant $t+dd(t)$, de $Sigma^0(t+dd(t))union delta Sigma_2$.

    On applique le théorème de la quantité de mouvement au système fermé $Sigma^*$ entre les instants $t$ et $t+dd(t)$.
    $
        P_1 S_2 ex - P_2 S_2 ex = dd(va(p^*))/dd(t) = (va(p^*)(t+dd(t)) - va(p^*)(t))/dd(t) = (va(p^0)(t+dd(t)) - va(p^0)(t) + va(p)(delta Sigma_2) - va(p)(delta Sigma_1))/dd(t)\
        = (0 + v_2 delta m_2 ex - v_1 delta m_1 ex)/dd(t)
    $
    Or, en régime stationnaire, $delta m_1 = delta m_2 = D_m dd(t) = mu v_1 S_1 dd(t)$

    La conservation du débit volumique donne $v_1 S_1 = v_2 S_2$ donc $v_2 = S_1/S_2 v_1$.
    On en déduit
    $
        P_1 S_2 - P_2 S_2
        = v_1 S_1/S_2 mu v_1 S_1 - v_1 mu v_1 S_1
        = mu v_1^2 S_1 (S_1/S_2 - 1)
    $
    d'où
    $
        P_1 - P_2 = mu v_1^2 ((S_1/S_2)^2-S_1/S_2)
    $
]

#question[
    En déduire le coefficient de perte de charge singulière $zeta$ défini par $P_2 - P_1=zeta 1/2 mu v_1^2$. Effectuer l'application numérique pour $S_2 = 2 S_1$.
][
    #let x = 1/2
    #let pdc = 2*(-x*x + x)
    $
        zeta = (P_2-P_1)/(1/2 mu v_1^2)
        = 2 (S_1/S_2 - (S_1/S_2)^2) = #num(pdc)
    $
]
