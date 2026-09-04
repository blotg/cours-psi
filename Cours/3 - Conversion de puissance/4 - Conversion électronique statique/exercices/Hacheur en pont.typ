#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Hacheur en pont",
)

#figure(
    zap.circuit({
        import zap: *
        vsource("E", (0, -2.5), (0, 2.5), u: $E$, i: $i_e$)
        switch("S1", (2, 2.5), (2, 0), label: $K_1$, i: $i_1$)
        switch("S4", (2, -2.5), (2, 0), label: $K_4$, i: $i_4$)
        switch("S2", (5, 0), (5, 2.5), label: $K_2$, i: $i_2$)
        switch("S3", (5, 0), (5, -2.5), label: $K_3$, i: $i_3$)
        isource("I", (2, 0), (5, 0), i: $I$, u: (content: $u$, anchor: "south-west"))
        wire((0, 2.5), (5, 2.5))
        wire((0, -2.5), (5, -2.5))
    }),
)

La source d'entrée présente une tension $E>0$ constante, celle de sortie est parcouru par un courant d'intensité $I>0$ constant. $i_e$, $u$, $i_1$, $i_2$, $i_3$ et $i_4$ dépendent du temps.


#question(
    coups-de-pouce: (
        "Pour dresser la liste des états sans en oublier, on peut s'inspirer du comptage en binaire.",
        "La source de tension de doit pas être court-circuitée. La source de courant ne doit pas être en circuit ouvert.",
        "Pour que de la puissance soit transférée entre l'entrée et la sortie, il faut que les deux sources soient dans la même maille.",
    ),
)[
    Dresser la liste de tous les états pour les interrupteurs. Préciser les états autorisés. Dans la suite, on ne s'intéresse qu'aux états qui permettent un transfert de puissance entre l'entrée et la sortie. Quels sont-ils ?
][
    Les états des interrupteurs sont listés dans le tableau ci-dessous.
    #{
        show table.cell: it => {
            if it.y in (7, 8, 10, 12, 14, 15, 16) {
                strike(it, stroke: (dash: "dotted", thickness: 1pt))
            } else if it.y in (1, 2, 3, 5, 7, 9, 10) {
                strike(it)
            } else {
                it
            }
        }
        figure(
            table(
                columns: (auto,) * 4,
                align: center,
                $K_1$, $K_2$, $K_3$, $K_4$,
                "Ouvert", "Ouvert", "Ouvert", "Ouvert",
                "Ouvert", "Ouvert", "Ouvert", "Fermé",
                "Ouvert", "Ouvert", "Fermé", "Ouvert",
                "Ouvert", "Ouvert", "Fermé", "Fermé",
                "Ouvert", "Fermé", "Ouvert", "Ouvert",
                "Ouvert", "Fermé", "Ouvert", "Fermé",
                "Ouvert", "Fermé", "Fermé", "Ouvert",
                "Ouvert", "Fermé", "Fermé", "Fermé",
                "Fermé", "Ouvert", "Ouvert", "Ouvert",
                "Fermé", "Ouvert", "Ouvert", "Fermé",
                "Fermé", "Ouvert", "Fermé", "Ouvert",
                "Fermé", "Ouvert", "Fermé", "Fermé",
                "Fermé", "Fermé", "Ouvert", "Ouvert",
                "Fermé", "Fermé", "Ouvert", "Fermé",
                "Fermé", "Fermé", "Fermé", "Ouvert",
                "Fermé", "Fermé", "Fermé", "Fermé",
            ),
        )
    }
    Si $K_1$ et $K_4$ sont fermés simultanément, la source de tension est court-circuitée. De même si $K_2$ et $K_3$ sont fermés simultanément. Les états correspondants sont barrés en pointillés.

    Si $K_1$ et $K_4$ sont ouverts simultanément, la source de courant est en circuit ouvert. De même si $K_2$ et $K_3$ sont ouverts simultanément. Les états correspondants sont barrés en trait plein.

    Les état autorisés sont donc
    #figure(
        table(
            columns: (auto,) * 4,
            align: center,
            $K_1$, $K_2$, $K_3$, $K_4$,
            "Ouvert", "Ouvert", "Fermé", "Fermé",
            "Ouvert", "Fermé", "Ouvert", "Fermé",
            "Fermé", "Ouvert", "Fermé", "Ouvert",
            "Fermé", "Fermé", "Ouvert", "Ouvert",
        ),
    )
    Si $K_1$ et $K_2$ sont fermés et $K_3$ et $K_4$ sont ouverts, $i_e=0$ et $u=0$. La puissance reçue et la puissance délivrée sont nulles. Idem si $K_1$ et $K_2$ sont ouverts et $K_3$ et $K_4$ sont fermés. Ces deux états ne permettent pas de transférer de la puissance entre l'entrée et la sortie. Ils ne sont donc pas retenus.

    Les deux états retenus sont donc
    #figure(
        table(
            columns: (auto,) * 4,
            align: center,
            $K_1$, $K_2$, $K_3$, $K_4$,
            "Ouvert", "Fermé", "Ouvert", "Fermé",
            "Fermé", "Ouvert", "Fermé", "Ouvert",
        ),
    )
]

#question(
    coups-de-pouce: (
        "Tracer les caractéristiques des 4 interrupteurs et placer dessus les deux points de fonctionnements correspondant aux deux états retenus.",
        "Pour chacun des deux états retenus, indiquer le signe de la tension et du courant pour chaque interrupteur. On veillera à placer les tensions en convention récepteur.",
    ),
)[
    En étudiant les contraintes qui pèsent sur les interrupteurs, préciser quels interrupteurs choisir.
][
    Dans le premier état retenu :
    #figure(
        zap.circuit({
            import zap: *
            vsource("E", (0, -2.5), (0, 2.5), u: $E$, i: $i_e$)
            switch("S1", (2, 2.5), (2, 0), label: $K_1$, i: $i_1$, u: (content: $u_1$, anchor: "south-west"))
            switch(
                "S4",
                (2, -2.5),
                (2, 0),
                label: $K_4$,
                i: $i_4$,
                u: (content: $u_4$, anchor: "south-west"),
                closed: true,
            )
            switch(
                "S2",
                (5, 0),
                (5, 2.5),
                label: $K_2$,
                i: $i_2$,
                u: (content: $u_2$, anchor: "south-west"),
                closed: true,
            )
            switch("S3", (5, 0), (5, -2.5), label: $K_3$, i: $i_3$, u: (content: $u_3$, anchor: "south-west"))
            isource("I", (2, 0), (5, 0), i: $I$, u: (content: $u$, anchor: "south-west"))
            wire((0, 2.5), (5, 2.5))
            wire((0, -2.5), (5, -2.5))
        }),
    )
    $u_1 = E>0$ et $i_1=0$ #h(1fr) $u_2=0$ et $i_2=I>0$ #h(1fr) $u_3=E>0$ et $i_3=0$ #h(1fr) $u_4=0$ et $i_4=I>0$.

    Dans le second état retenu :
    #figure(
        zap.circuit({
            import zap: *
            vsource("E", (0, -2.5), (0, 2.5), u: $E$, i: $i_e$)
            switch(
                "S1",
                (2, 2.5),
                (2, 0),
                label: $K_1$,
                i: $i_1$,
                u: (content: $u_1$, anchor: "south-west"),
                closed: true,
            )
            switch(
                "S4",
                (2, -2.5),
                (2, 0),
                label: $K_4$,
                i: $i_4$,
                u: (content: $u_4$, anchor: "south-west"),
                closed: false,
            )
            switch(
                "S2",
                (5, 0),
                (5, 2.5),
                label: $K_2$,
                i: $i_2$,
                u: (content: $u_2$, anchor: "south-west"),
                closed: false,
            )
            switch(
                "S3",
                (5, 0),
                (5, -2.5),
                label: $K_3$,
                i: $i_3$,
                u: (content: $u_3$, anchor: "south-west"),
                closed: true,
            )
            isource("I", (2, 0), (5, 0), i: $I$, u: (content: $u$, anchor: "south-west"))
            wire((0, 2.5), (5, 2.5))
            wire((0, -2.5), (5, -2.5))
        }),
    )
    $u_1 = 0$ et $i_1=I>0$ #h(1fr) $u_2=-E<0$ et $i_2=0$ #h(1fr) $u_3=0$ et $i_3=I>0$ #h(1fr) $u_4=-E<0$ et $i_4=0$.

    On représente les points de fonctionnement sur les caractéristiques des interrupteurs.
    #grid(
        columns: (1fr, 1fr, 1fr, 1fr),
        figure(
            canvas({
                import cetz.draw: *
                line((-1, 0), (1, 0), mark: (end: ">>", fill: black))
                content((), $u_1$, anchor: "north", padding: 0.4em)
                line((0, -1), (0, 1), mark: (end: ">>", fill: black))
                content((), $i_1$, anchor: "east", padding: 0.4em)
                circle((0, 0.5), radius: 0.07, fill: black)
                circle((0.5, 0), radius: 0.07, fill: black)
            }),
        ),
        figure(
            canvas({
                import cetz.draw: *
                line((-1, 0), (1, 0), mark: (end: ">>", fill: black))
                content((), $u_2$, anchor: "north", padding: 0.4em)
                line((0, -1), (0, 1), mark: (end: ">>", fill: black))
                content((), $i_2$, anchor: "east", padding: 0.4em)
                circle((0, 0.5), radius: 0.07, fill: black)
                circle((-0.5, 0), radius: 0.07, fill: black)
            }),
        ),
        figure(
            canvas({
                import cetz.draw: *
                line((-1, 0), (1, 0), mark: (end: ">>", fill: black))
                content((), $u_3$, anchor: "north", padding: 0.4em)
                line((0, -1), (0, 1), mark: (end: ">>", fill: black))
                content((), $i_3$, anchor: "east", padding: 0.4em)
                circle((0, 0.5), radius: 0.07, fill: black)
                circle((0.5, 0), radius: 0.07, fill: black)
            }),
        ),
        figure(
            canvas({
                import cetz.draw: *
                line((-1, 0), (1, 0), mark: (end: ">>", fill: black))
                content((), $u_4$, anchor: "north", padding: 0.4em)
                line((0, -1), (0, 1), mark: (end: ">>", fill: black))
                content((), $i_4$, anchor: "east", padding: 0.4em)
                circle((0, 0.5), radius: 0.07, fill: black)
                circle((-0.5, 0), radius: 0.07, fill: black)
            }),
        ),
    )
    On reconnait la caractéristique d'un transistor pour $K_1$ et $K_3$ et d'une diode en convention directe pour $K_2$ et $K_4$.
]

#question(
    coups-de-pouce: (),
)[
    Le hacheur fonctionne de manière périodique. Les interrupteurs commandés sont fermés sur $[0,alpha T[$ et ouverts sur $[alpha T, T[$. Comment nomme-t-on $alpha$.
][
    $alpha$ est le rapport cyclique.
]

#question(
    coups-de-pouce: (
        "Quels sont les ensembles de valeurs que peuvent prendre $U$ et $I_e$ ?",
    ),
)[
    Tracer les formes d'onde de l'intensité $i_e$ du courant en entrée et de la tension $u$ en sortie. En déduire les valeurs moyennes $I_e$ et $U$ de $i_e$ et $u$. Quelle est la particularité de ce hacheur.
][
    Les interrupteurs commandés sont les transistors $K_1$ et $K_3$.
    / Entre 0 et $alpha T$: $i_e=I$ et $u = E$.
    / Entre 0 et $alpha T$: $i_e=-I$ et $u = -E$.
    On obtient les chronogrammes suivants.
    #grid(
        columns: (1fr, 1fr),
        figure(canvas({
            import cetz.draw: *
            plot.plot(
                axis-style: "school-book",
                x-label: $t$,
                y-label: $u$,
                x-ticks: ((0.3, $alpha T$), (1, $T$)),
                y-ticks: ((-0.7, $-E$), (0.7, $E$)),
                x-tick-step: none,
                y-tick-step: none,
                size: (6, 3),
                {
                    plot.add(((0, 0.7), (0.3, 0.7), (0.3, -0.7), (1, -0.7), (1, 0.7), (1.3, 0.7), (1.3, -0.7)))
                },
            )
        })),
        figure(canvas({
            import cetz.draw: *
            plot.plot(
                axis-style: "school-book",
                x-label: $t$,
                y-label: $i_e$,
                x-ticks: ((0.3, $alpha T$), (1, $T$)),
                y-ticks: ((-0.7, $I$), (0.7, $I$)),
                x-tick-step: none,
                y-tick-step: none,
                size: (6, 3),
                {
                    plot.add(((0, 0.7), (0.3, 0.7), (0.3, -0.7), (1, -0.7), (1, 0.7), (1.3, 0.7), (1.3, -0.7)))
                },
            )
        })),
    )
    $ U = mean(u) = cal(A)/T = (E alpha T - E(1-alpha)T)/T = (2 alpha - 1)E $
    $ I_e = mean(i_e) = cal(A)/T = (I alpha T - I(1-alpha)T)/T = (2 alpha - 1)I $
    La particularité de ce hacheur est que la tension et le courant moyens peuvent être positifs ou négatifs selon la valeur de $alpha$.
]

#question(
    coups-de-pouce: (),
)[
    Exprimer les puissances délivrées par la source d'entrée et absorbée par celle de sortie. En déduire le rendement du hacheur.
][
    La puissance délivrée par la source d'entrée est
    $ P_e = mean(E i_e) = E mean(i_e) = E (2 alpha -1) I $
    La puissance absorbée par la source de sortie est
    $ P_s = mean(u I) = mean(u) I = (2 alpha -1) E I $
    Le rendement du hacheur est donc
    $ eta = P_s/P_e = 1 $
]
