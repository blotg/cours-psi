#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Stabilité en mécanique",
)

On étudie un point matériel dont l'énergie potentielle dépend de la position $x$ selon la loi $E_p (x) = alpha x^2$.

#question(
    coup-de-pouce: (
        "Quelques formes d'énergie potentielle sont à connaitre. Laquelle est quadratique (c'es-à-dire fait apparaitre un carré) ?",
        "Les énergies potentielles à connaitre sont l'énergie potentielle de pesanteur, l'énergie potentielle élastique et l'énergie potentielle électrostatique.",
    ),
)[
    Proposer une situation physique correspondant à cette loi d'énergie potentielle.
][
    L'énergie potentielle élastique d'un ressort est $E_p = 1/2 k (l - l_0)^2$. En notant l'allongement $x=l - l_0$ et $alpha= 1/2 k$, on retrouve la loi donnée.
]

#question(
    coup-de-pouce: (
        "Utiliser un théorème énergétique.",
        "Utiliser le théorème de la puissance mécanique."
    )
)[
    Établir l'équation différentielle vérifiée par la position $x(t)$ du point matériel.
][
    L'énergie mécanique est
    $
        E_m = E_c + E_p = 1/2 m dot(x)^2 + alpha x^2
    $
    Le théorème de la puissance mécanique appliqué au point matériel donne
    $
        dv(E_m, t) = 0
    $
    $
        m dot(x) dot.double(x) + 2 alpha x dot(x) = 0
    $
    soit, en simplifiant
    $
        m dot.double(x) + 2 alpha x = 0
    $
]

#question()[
    À quelle condition sur le paramètre $alpha$ le point matériel a-il un mouvement stable ?
][
    Le système est stable si tous les coefficients de l'équation différentielle (d'ordre 2) sont positifs. Ici, le coefficient de $x$ est $2 alpha$. Ainsi, le mouvement est stable si $alpha > 0$.
]
