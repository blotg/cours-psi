#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Onduleur triphasé",
    numérique: true,
)

Les onduleurs triphasés sont utilisés pour alimenter des moteurs électriques à partir d'une source de tension continue. Ils peuvent par exemple être utilisés dans les voitures électriques où une batterie fournit l'énergie alimentant un moteur triphasé.

Un onduleur triphasé est représenté ci-dessous. Il est alimenté par une source de tension continue et alimente une source de courant triphasée.

#figure(
    zap.circuit({
        import zap: *
        vsource("U", (0, -2.5), (0, 2.5))
        switch("S1", (2, 2.5), (2, 0), label: $K_0$)
        switch("S1", (3.5, 2.5), (3.5, 0), label: $K_1$)
        switch("S1", (5, 2.5), (5, 0), label: $K_2$)
        switch("S1", (2, -2.5), (2, 0), label: $K_3$)
        switch("S1", (3.5, -2.5), (3.5, 0), label: $K_4$)
        switch("S1", (5, -2.5), (5, 0), label: $K_5$)

        wire((0, 2.5), (5, 2.5))
        wire((0, -2.5), (5, -2.5))

        isource("I1", (10, 0), (10, 2.5))
        isource("I2", (10, 0), (rel: (-30deg, 2.5)))
        isource("I3", (10, 0), (rel: (-150deg, 2.5)))

        node("n1", (2, 0.5))
        wire((2, 0.5), (7, 0.5), (7, 2.5), (10, 2.5))
        node("n2", (3.5, 0))
        zwire((3.5, 0), (5, 0), (rel: (-150deg, 2.5), to: (10, 0)))
        node("n3", (5, -0.5))
        swire((5, -0.5), (6, -2.5), (rel: (-30deg, 2.5), to: (10, 0)))
    }),
)

L'objectif de cet exercice est d'étudier la séquence de commutation des interrupteurs.

#question(
    coups-de-pouce: (
        "Combien y a-t-il d'états possibles pour 1 interrupteur ? Pour 2 ? Pour 3 ?",
    ),
)[
    Combien d'états y a-t-il au total pour les interrupteurs ?
][
    Il y a $2^6 = 64$ états possibles.
]

Comme il serait trop long de lister ces états à la main, on utilise Python pour le faire.

Les états seront listés en s'inspirant du comptage binaire :
#table(
    columns: (auto,) * 7,
    table.header([N°], $K_5$, $K_4$, $K_3$, $K_2$, $K_1$, $K_0$),
    $0$, [O], [O], [O], [O], [O], [O],
    $1$, [O], [O], [O], [O], [O], [F],
    $2$, [O], [O], [O], [O], [F], [O],
    $3$, [O], [O], [O], [O], [F], [F],
)

#question(
    coups-de-pouce: (),
)[
    Justifier que dans le $i$-ème état, l'interrupteur $K_0$ est ouvert si `i%2` vaut `0` et fermé sinon.
    Justifier que dans le $i$-ème état, l'interrupteur $K_1$ est ouvert si `i//2 % 2` vaut `0` et fermé sinon où `i//2` désigne le quotient de la division euclidienne de $i$ par 2.
][
    `i%2` donne le chiffre des unités en base 2 de $i$. Si ce chiffre est 0, l'interrupteur $K_0$ est ouvert, sinon il est fermé.
    `i//2 % 2` donne le chiffre des deuxièmes positions en base 2 de $i$. Si ce chiffre est 0, l'interrupteur $K_1$ est ouvert, sinon il est fermé.
]

#question(
    coups-de-pouce: (
        "On pourra tester la valeur de `i//2**k % 2` pour savoir si l'interrupteur $K_k$ est ouvert ou fermé.",
    ),
)[
    Écrire une fonction `état_K(i, k)` qui renvoie l'état de l'interrupteur $K_k$ dans le $i$-ème état.
][
    ```python
    def état_K(i, k):
        if i//2**k % 2 == 0:
            return "O"
        else:
            return "F"
    ```
]

#question(
    coups-de-pouce: (),
)[
    Écrire une fonction `état(i)` qui renvoie la liste des états des interrupteurs $K_5$ à $K_0$ dans le $i$-ème état.
][
    ```python
    def état(i):
        return [état_K(i, k) for k in range(5, -1, -1)]
    ```
]

#question(
    coups-de-pouce: (),
)[
    Écrire une suite d'instructions qui affiche les 64 états des interrupteurs.
][
    ```python
    for i in range(2**6):
        print(état(i))
    ```
]

#question(
    coups-de-pouce: (
        "Pour rappel, une source de tension ne doit pas être en court-circuit et une source de courant ne doit pas être en circuit ouvert.",
    ),
)[
    Les interrupteurs $K_0$ et $K_3$ peuvent-ils être simultanément ouverts ? Peuvent-ils être simultanément fermés ? Quels autres interrupteurs ont un fonctionnement complémentaire ?
][
    Si $K_0$ et $K_3$ sont ouverts simultanément, la source de courant du haut est en circuit ouvert.

    Si $K_0$ et $K_3$ sont fermés simultanément, la source de tension est en court-circuit.

    Les autres interrupteurs ayant un fonctionnement complémentaire sont $K_1$ et $K_4$, ainsi que $K_2$ et $K_5$.
]

#question(
    coups-de-pouce: (),
)[
    Reprendre les instructions affichant les états des interrupteurs et n'afficher que les états valides. Combien d'états reste-t-il ?
][
    ```python
    for i in range(2**6):
        e = état(i)
        if e[0] != e[3] and e[1] != e[4] and e[2] != e[5]:
            print(état(i))
    ```
    Il reste 8 états valides.
]

#question(
    coups-de-pouce: (
        "Dans deux des états valides, aucun courant ne circule dans la source de tension. Lesquels ?",
    ),
)[
    Parmi les états valides, quels sont les deux qui ne permettent pas de transférer de la puissance entre la source et les charges ?
][
    Les états OOOFFF et FFFOOO ne permettent pas de transférer de la puissance entre la source et les charges car dans ces deux cas, le courant dans la source est nul donc la puissance aussi.
]
