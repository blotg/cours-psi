#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Hachage à stockage inductif",
)

#figure(
    zap.circuit({
        import zap: *
        switch("k1", (0, 0), (3, 0), label: $K_1$)
        switch("k2", (3, 0), (6, 0), label: $K_2$)
        vsource("u", (0, -3), (0, 0), u: $U$, i: $i$)
        vsource("u_prime", (6, -3), (6, 0), u: (content: $U'$, anchor: "south-west"), i: $i'$)
        inductor("l", (3, 0), (3, -3), label: $L$, i: $i_L$, u: (content: $u_L$, anchor: "south-west"), variant: "ieee")
        wire((6, -3), (3, -3))
        wire((3, -3), (0, -3))
    }),
)

Dans le convertisseur ci-contre, l'entrée est la source de tension $U$ et la sortie est celle de tension $U'$. $U$ et $U'$ sont des composantes positives, alors que $i$, $i'$, $i_L$ et $u_L$ dépendent du temps ; toutefois l'intensité $i_L$ dans la bobine est toujours positive.

#question(
    coups-de-pouce: (
        "La bobine est-elle un dipole de type source de tension ou source de courant ?",
    ),
)[
    Montrer que la commande des deux interrupteurs doit être complémentaire (ni ouverts ni fermés tous les deux en même temps).
][
    Si les deux interrupteurs sont fermés simultanément, les sours de tensions sont en parallèle, chacune essayant d'imposer sa tension. Ce n'est pas un état possible.

    Si les deux interrupteurs sont ouverts simultanément, la bobine se retrouve en circuit ouvert. Or le courant dans une bobine ne peut pas être discontinu. On peut aussi justifier en disant que, la bobine étant un dipole de type source de courant, elle ne peut pas être en circuit ouvert.

    Les deux seuls états possibles sont donc : $K_1$ fermé et $K_2$ ouvert, ou $K_1$ ouvert et $K_2$ fermé. Les interrupteurs sont donc complémentaires.
]

#question(
    coups-de-pouce: (
        "Lorsque $K_1$ est ouvert, quel est le signe de $u_1$. Quand il est fermé, quel est le signe de $i_1$. Même question pour $K_2$.",
    ),
)[
    Identifier les interrupteurs à utiliser en traçant leur caractéristique courant-tension.
][
    On appelle $u_1$ et $u_2$ les tensions aux bornes de $K_1$ et $K_2$ respectivement, en convention récepteur.
    / Lorsque $K_1$ est fermé et $K_2$ est ouvert: $u_1 = 0$ ; $i=i_L>0$ ; $u_2 = -U -U' <0$ et $i_2=0$.
    / Lorsque $K_1$ est ouvert et $K_2$ est fermé: $u_1 = U + U'>0$ ; $i=0$ ; $u_2 = 0$ et $i_2=i_L>0$.

    On place ces points sur les caractéristiques des interrupteurs :
    #grid(
        columns: (1fr, 1fr),
        figure(
            canvas({
                import draw: *
                line((-1, 0), (1, 0), stroke: black, mark: (end: ">>", fill: black))
                content((), $u_1$, anchor: "north", padding: 0.4em)
                line((0, -1), (0, 1), stroke: black, mark: (end: ">>", fill: black))
                content((), $i_1$, anchor: "east", padding: 0.4em)
                circle((0, 0.5), radius: 0.07, fill: black)
                circle((0.5, 0), radius: 0.07, fill: black)
            }),
        ),
        figure(
            canvas({
                import draw: *
                line((-1, 0), (1, 0), stroke: black, mark: (end: ">>", fill: black))
                content((), $u_2$, anchor: "north", padding: 0.4em)
                line((0, -1), (0, 1), stroke: black, mark: (end: ">>", fill: black))
                content((), $i_2$, anchor: "east", padding: 0.4em)
                circle((0, 0.5), radius: 0.07, fill: black)
                circle((-0.5, 0), radius: 0.07, fill: black)
            }),
        ),
    )
    On reconnait la caractéristique d'un transistor pour $K_1$ et d'une diode en convension directe pour $K_2$.
]

Dans toute la suite, l'interrupteur commandé est fermé sur $[0,alpha T]$ et ouvert sur $[alpha T, T]$.

#question(
    coups-de-pouce: (
        "Écrire la tension aux bornes de la bobine comme une dérivée. Que vaut la moyenne d'une dérivée ?",
        "Exprimer la valeur moyenne de $u_L$ en fonction de $alpha$, $U$ et $U'$.",
    ),
)[
    Tracer la forme d'onde de la tension aux bornes de la bobine. En déduire une relation entre $U$, $U'$ et $alpha$.
][
    / Entre $0$ et $alpha T$: $u_L = U$ (car $K_1$ fermé, $K_2$ ouvert)
    / Entre $alpha T$ et $T$: $u_L = -U'$ (car $K_1$ ouvert, $K_2$ fermé)
    Le chronogramme de $i_L$ est donc :
    #figure(
        canvas({
            import cetz.draw: *
            plot.plot(
                axis-style: "school-book",
                x-label: $t$,
                y-label: $u_L$,
                x-ticks: ((0.3, $alpha T$), (1, $T$)),
                y-ticks: ((-0.3, $-U'$), (0.7, $U$)),
                x-tick-step: none,
                y-tick-step: none,
                size: (6, 3),
                {
                    plot.add(((0, 0.7), (0.3, 0.7), (0.3, -0.3), (1, -0.3), (1, 0.7), (1.3, 0.7), (1.3, -0.3)))
                },
            )
        }),
    )
    La tension moyenne aux bornes du bobines est nulle donc
    $ (alpha T U - (T-alpha T)U')/T = alpha U - (1-alpha) U' = 0 $
]

#question(
    coups-de-pouce: (
        "Déterminer l'équation différentielle vérifiée par $i_L$ entre $0$ et $alpha T$ et entre $alpha T$ et $T$.",
        "Résoudre cette équation différentielle sans cherche à exprimer la constante.",
        "Relier $i$ et $i'$ à $i_L$ entre $0$ et $alpha T$ et entre $alpha T$ et $T$.",
    ),
)[
    Tracer les formes d'ondes des courants dans la bobine $i_L$ et dans les sources d'entrée $i$ et de sortie $i'$. On ne cherchera pas à identifier les constantes.
][
    / Entre $0$ et $alpha T$: $u_L = L dv(i_L, t) = U$ donc $i_L = U/L t + "cte"$ ; $i = i_L$ et $i' = 0$.
    / Entre $alpha T$ et $T$: $u_L = L dv(i_L, t) = -U'$ donc $i_L = - U'/L t + "cte'"$ ; $i = 0$ et $i' = i_L$.
    Le chronogramme de $i_L$, $i$ et $i'$ est donc :
    #grid(
        columns: (1fr, 1fr, 1fr),
        figure(
            canvas({
                plot.plot(
                    axis-style: "school-book",
                    x-label: $t$,
                    y-label: $i_L$,
                    x-ticks: ((0.3, $alpha T$), (1, $T$)),
                    y-ticks: ((0.3, $I_"min"$), (1, $I_"max"$)),
                    x-tick-step: none,
                    y-tick-step: none,
                    y-min: 0,
                    size: (3, 2),
                    {
                        plot.add(((0, 0.3), (0.3, 1), (1, 0.3), (1.3, 1)))
                    },
                )
            }),
        ),
        figure(
            canvas({
                plot.plot(
                    axis-style: "school-book",
                    x-label: $t$,
                    y-label: $i$,
                    x-ticks: ((0.3, $alpha T$), (1, $T$)),
                    y-ticks: ((0.3, $I_"min"$), (1, $I_"max"$)),
                    x-tick-step: none,
                    y-tick-step: none,
                    y-min: 0,
                    size: (3, 2),
                    {
                        plot.add(((0, 0.3), (0.3, 1), (0.3, 0), (1, 0), (1, 0.3), (1.3, 1)))
                    },
                )
            }),
        ),
        figure(
            canvas({
                plot.plot(
                    axis-style: "school-book",
                    x-label: $t$,
                    y-label: $i_L$,
                    x-ticks: ((0.3, $alpha T$), (1, $T$)),
                    y-ticks: ((0.3, $I_"min"$), (1, $I_"max"$)),
                    x-tick-step: none,
                    y-tick-step: none,
                    y-min: 0,
                    size: (3, 2),
                    {
                        plot.add(((0, 0), (0.3, 0), (0.3, 1), (1, 0.3), (1, 0), (1.3, 0)))
                    },
                )
            }),
        ),
    )
]

#question(
    coups-de-pouce: (
        "Raisonner géométriquement sur les aires dans le chronogramme.",
    ),
)[
    Exprimer les valeurs moyennes $I$ et $I'$ des courants $i(t)$ et $i'(t)$ en fonction de la valeur moyenne $I_L$ du courant $i_L(t)$ dans la bobine.
][
    $
        I_L & = mean(i_L) & = cal(A)/T & = ((I_"max"+I_"min")T)/(2T) = (I_"max"+I_"min")/2 \
          I & = mean(i)   & = cal(A)/T & = ((I_"max"+I_"min")alpha T)/(2T) = alpha I_L \
         I' & = mean(i')  & = cal(A)/T & = ((I_"max"+I_"min")(T - alpha T))/(2T) = (1-alpha) I_L
    $
]

#question(
    coups-de-pouce: (),
)[
    En déduire l'expression du rapport $I'/I$ en fonction de $alpha$. Que dire du cas $alpha=1$ ?
][
    $ I'/I = (1-alpha)/alpha $
    Pour $alpha = 1$, on a $ I' = 0 $
]

#question(
    coups-de-pouce: (),
)[
    Dresser un bilan de puissance en exprimant la puissance moyenne cédée par la source de tension $U$, la puissance moyenne consommée par celle de tension $U'$ et le rendement.
][
    $ P = mean(U i(t)) = U mean(i(t)) = U I $
    $ P' = mean(U' i'(t)) = U' mean(i'(t)) = U' I' $
    or $U = (1-alpha)/alpha U'$ et $I' = (1-alpha)/alpha I$ donc
    $ eta = P'/P = 1 $

    C'est logique car on n'utilise que des dipoles ne consommant pas de puissance en moyenne (interrupteurs idéaux et bobine).
]

