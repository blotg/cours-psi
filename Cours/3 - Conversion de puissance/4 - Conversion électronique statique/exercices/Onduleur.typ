#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Onduleur alimentant une charge inductive",
    numérique: true,
    difficulté: 1,
)

On s'intéresse à un onduleur alimentant une charge inductive avec $R=#qty("10", "O")$, $L=#qty("100", "mH")$ et $E = #qty("100", "V")$

#figure(
    zap.circuit({
        import zap: *
        vsource("E", (0, -2.5), (0, 2.5), u: $E$, i: $i_e$)
        switch("S1", (2, 2.5), (2, 0), label: $K_1$, i: $i_1$)
        switch("S4", (2, -2.5), (2, 0), label: $K_4$, i: $i_4$)
        switch("S2", (7, 0), (7, 2.5), label: $K_2$, i: $i_2$)
        switch("S3", (7, 0), (7, -2.5), label: $K_3$, i: $i_3$)
        resistor("R", (2, 0), (4.5, 0), i: $i(t)$)
        inductor("L", (4.5, 0), (7, 0), variant: "ieee")
        wire((0, 2.5), (7, 2.5))
        wire((0, -2.5), (7, -2.5))
    }),
)

#question(
    coups-de-pouce: (
        "Lister les états possibles des interrupteurs.",
        "Utiliser les règles d'interconnexions des sources.",
        "Pourquoi $K_1$ et $K_4$ ne peuvent pas être fermés simultanément ? Même question pour $K_2$ et $K_3$.",
        "Pourquoi $K_1$ et $K_4$ ne peuvent pas être ouverts simultanément ? Même question pour $K_2$ et $K_3$.",
    ),
)[
    Quels sont les états autorisés pour les interrupteurs $K_1$, $K_2$, $K_3$ et $K_4$ ? Lesquels permettent de transférer de l'énergie de la source vers la charge ?
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
    Si $K_1$ et $K_2$ sont fermés et $K_3$ et $K_4$ sont ouverts, $i_e=0$ et $u=0$. La puissance reçue et la puissance délivrée sont nulle. Idem si $K_1$ et $K_2$ sont ouverts et $K_3$ et $K_4$ sont fermés. Ces deux états ne permettent pas de transférer de la puissance entre l'entrée et la sortie. Ils ne sont donc pas retenus.

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
        "Écrire la loi des mailles.",
        "Il peut être pratique de reproduire le schéma avec les interrupteurs dans l'état considéré.",
    ),
)[
    On se place entre $t_1$ et $t_2$, avec $K_1$ et $K_3$ fermés et $K_2$ et $K_4$ ouverts. Quelle est l'équation différentielle vérifiée par le courant $i(t)$ dans la charge ? Quelle est sa solution ? On l'exprimera en fonction de $i(t_1)$.
][
    La loi des mailles s'écrit $E = R i + L dv(i, t)$, soit
    $ dv(i, t) + R/L i = E/L $
    Ses solutions sont de la forme $i(t) = A e^(-R/L t) + E/R$. Or $i(t_1) = A e^(-R/L t_1) + E/R$ d'où
    $ i(t) = (i(t_1) - E/R) e^(-R/L (t - t_1)) + E/R $
]

#question(
    coups-de-pouce: (),
)[
    On se place entre $t_2$ et $t_3$, avec $K_1$ et $K_3$ ouverts et $K_2$ et $K_4$ fermés. Quelle est l'équation différentielle vérifiée par le courant $i(t)$ dans la charge ? Quelle est sa solution ? On l'exprimera en fonction de $i(t_2)$.
][
    La loi des mailles s'écrit $-E = R i + L dv(i, t)$, soit
    $ dv(i, t) + R/L i = E/L $
    Ses solutions sont de la forme $i(t) = B e^(-R/L t) - E/R$. Or $i(t_2) = B e^(-R/L t_2) - E/R$ d'où
    $ i(t) = (i(t_2) + E/R) e^(-R/L (t - t_2)) - E/R $
]

Les interrupteurs $K_1$ et $K_4$ sont fermés entre $t=n T$ et $t=n T + alpha(t) T_"MLI"$, tandis que les interrupteurs $K_2$ et $K_3$ sont fermés entre $t=n T_"MLI" + alpha(t) T_"MLI"$ et $t=(n+1)T_"MLI"$, avec $ alpha(t) = (1 + cos((2 pi)/T t) ) / 2 $

On prendra $T = #qty("1", "s")$ et $T_"MLI" = #qty("10", "ms")$.

#question(
    coups-de-pouce: (
        "Quel est le rôle d'un onduleur ?",
    ),
)[
    Expliquer les raisons de ce choix de commande.
][
    Le rôle d'un onduleur est de fournir un courant alternatif en sortie. Le rapport cyclique est variable entre $0$ et $1$ de façon sinusoïdale pour obtenir un courant de sortie sinusoïdale.

    La période $T_"MLI"$ est petite devant la période $T$ du signal de sortie pour que le courant de sortie soit le plus proche possible d'un signal sinusoïdal.
]

#question(
    coups-de-pouce: (),
)[
    On souhaite réaliser une simulation numérique du courant de sortie $i(t)$ sur une période $T$. Compléter le code suivant.
    #show raw.where(block: true): it => {
        set par(justify: false)
        grid(
            columns: (auto, auto),
            align: (right, left),
            column-gutter: 1em,
            block(for i in range(it.text.split("\n").len()) {
                text(str(i + 1), gray)
                linebreak()
            }),
            it,
        )
    }
    ```python
    import numpy as np
    R = ...
    L = ...
    E = ... # tension de la source de tension
    T = ... # période du signal
    T_MLI = ... # période de la MLI
    dt = T_MLI/500 # pas de temps de la simulation (500 points par période de MLI)
    temps = ... # array de tous les temps
    alpha = ( 1 + np.cos(2*np.pi*temps/T) ) / 2 # rapport cyclique
    i_s = ... # initialisation du courant de sortie par un array de zéros
    for i in range(1, int(T/dt)-int(T_MLI/dt), int(T_MLI/dt)):
        i1 = i
        i2 = i+int(alpha[i]*T_MLI/dt)
        i3 = i+int(T_MLI/dt)
        i_s[i1:i2] = ... # première partie de "période"
        i_s[i2:i3] = ... # seconde partie de "période"
    ```
][
    ```python
    import numpy as np
    R = 10
    L = 100e-3
    E = 100 # tension de la source de tension
    T = 1 # période du signal
    T_MLI = 10e-3 # période de la MLI
    dt = T_MLI/500 # pas de temps de la simulation (500 points par période de MLI)
    temps = np.arange(0, T, dt) # array de tous les temps
    alpha = ( 1 + np.cos(2*np.pi*temps/T) ) / 2 # rapport cyclique
    i_s = np.zeros(len(temps)) # initialisation du courant de sortie par un array de zéros
    for i in range(1, int(T/dt)-int(T_MLI/dt), int(T_MLI/dt)):
        i1 = i
        i2 = i+int(alpha[i]*T_MLI/dt)
        i3 = i+int(T_MLI/dt)
        i_s[i1:i2] = (i_s[i_1-1] - E/R) * np.exp(-R/L * (temps[i1:i2] - temps[i1])) + E/R # première partie de "période"
        i_s[i2:i3] = (i_s[i2-1] + E/R) * np.exp(-R/L * (temps[i2:i3] - temps[i2])) - E/R # seconde partie de "période"
    ```
]

#question(
    coups-de-pouce: (
        "Que représentent `i1`, `i2` et `i3` ?",
    ),
)[
    Expliquer les lignes 12 à 15.
][
    `i` désigne le début de la période de la MLI. Ces débuts sont séparés de `int(T_MLI/dt)`.

    - `i1` est le début de la période de la MLI. C'est l'indice du moment auquel $K_1$ et $K_3$ se ferment et $K_2$ et $K_4$ s'ouvrent.
    - `i2` est la fin de la première partie de la période de la MLI, c'est-à-dire le moment où les interrupteurs $K_1$ et $K_3$ s'ouvrent et $K_2$ et $K_4$ se ferment. Il dépend du rapport cyclique `alpha[i]`.
    - `i3` est la fin de la période de la MLI, c'est-à-dire le moment où les interrupteurs $K_2$ et $K_4$ s'ouvrent et $K_2$ et $K_4$ se ferment.
]

#question(
    coups-de-pouce: (),
)[
    Tracer le courant de sortie $i_s$ en fonction du temps.
][
    ```python
    import matplotlib.pyplot as plt
    plt.clf()
    plt.title("Courant en sortie d'un onduleur avec MLI")
    plt.plot(temps, i_s, label = "$i_s(t)$ (A)")
    plt.legend()
    plt.xlabel("Temps (s)")
    plt.ylabel("Courant (A)")
    plt.show()
    ```
]

#question(
    coups-de-pouce: (
        "Quel signe peut avoir le courant $i_1$ ?",
        "Le courant dans un interrupteur peut-il changer de signe ? Même question pour une diode.",
    ),
)[
    Est-il possible de choisir des diodes ou des transistors pour les interrupteurs $K_1$, $K_2$, $K_3$ et $K_4$ ?
][
    Le courant dans les interrupteurs peut être positif ou négatif. Ni la diode ni le transistor ne permet ceci.
]
