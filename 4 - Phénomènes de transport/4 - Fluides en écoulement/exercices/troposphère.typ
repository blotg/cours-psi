#import "@local/prepa:0.1.0": *

#show: exercice.with(
    titre: "Troposphère",
)

La troposphère est la partie inférieure de l'atmosphère, située sous #qty("11", "km") d'altitude. On note $(O z)$ l'axe vertical ascendant, dont l'origine est au niveau de la mer.

On suppose dans un premier temps que la température est uniforme dans la troposphère.

#question(
    coups-de-pouce: (
        "Relier la masse volumique à la pression grâce à l'équation d'état des gaz parfaits.",
        "Résoudre l'équation fondamentale de l'hydrostatique.",
    ),
)[
    Déterminer l'expression de la pression $P$ en fonction de l'altitude $z$, en fonction de la température $T$, de la masse molaire de l'air $M_"air"$, de la constante des gaz parfaits $R$ et de l'accélération de la pesanteur $g$. On note $P_0$ la pression au niveau de la mer.
][
    $P V = n R T$ et $n = m / M_"air"$ donnent $mu = P M_"air" / (R T)$.

    En remplaçant dans l'équation hydrostatique $dv(P, z) = -mu g$, on obtient l'équation différentielle
    $ dv(P, z) + (M_"air" g) / (R T) = 0 $

    En intégrant cette équation, on peut exprimer $P(z)$ en fonction de $z$ :
    $ P(z) = P_0 exp(- (M_"air" g z) / (R T)) $
]

#question(
    coups-de-pouce: (
        "On considère un cylindre de section $S$ et de hauteur $z$. Exprimer la masse contenue dans ce cylindre comme une intégrale.",
        "On souhaite montrer que la masse contenue dans un cylindre de hauteur #qty(\"10\", \"km\") est égale à #qty(\"70\", \"%\") de la masse contenue dans un cylindre de hauteur infinie.",
    ),
)[
    Montrer que #qty("70", "%") de la masse totale de l'air se situe en dessous de #qty("10", "km") dans ce modèle.
][
    La masse contenue dans un cylindre de section $S$ et de hauteur $h$ est donnée par l'intégrale
    $ m(h) = integral.triple_V mu dd(V) = S integral_0^h mu(z) dd(z) $

    En remplaçant $mu(z)$ par $P M_"air"/(R T)$, on obtient
    $
        m(h) = (S P_0 M_"air") / (R T) integral_0^h exp(- (M_"air" g z) / (R T)) dd(z) = (S P_0)/g (1- exp(-(M_"air" g h)/(R T)))
    $

    On veut montrer que $m(qty("10", "km")) = num("0.70") times m(infinity)$. On calcule le quotient :
    #let M-air = 29e-3
    #let g = 9.81
    #let R = 8.314
    #let T = 288
    #let q = 1 - calc.exp(-M-air * g * 10e3 / (R * T))
    $
        m(qty("10", "km")) / m(infinity) = 1 - exp(-(M_"air" g qty("10", "km"))/(R T)) approx #num(scientifique(q, 2))
    $
]

On renonce à l'hypothèse isotherme pour passer à une atmosphère adiabatique.

#question[
    Les capacités thermiques molaires de l'air sont $C_V=5/2 R$ et $C_P=7/2 R$. Exprimer la valeur du coefficient $gamma$.
][
    $ gamma = C_P / C_V = (7/2 R) / (5/2 R) = 7/5 = 1.4 $
]

#question(
    coups-de-pouce: (
        "Utiliser la loi de Laplace et l'équation d'état des gaz parfaits."
    ),
)[
    Montrer que le produit $T^x P^y$ est constant pour une transformation réversible et adiabatique d'un gaz parfait. Exprimer $x$ et $y$ en fonction de $gamma$.
][
    La loi de Laplace pour une transformation adiabatique réversible s'écrit $P V^gamma = "cte"$. En utilisant l'équation d'état des gaz parfaits $P V = n R T$, on peut exprimer le volume $V$ en fonction de $P$ et $T$ : $V = n R T / P$.

    En remplaçant cette expression dans la loi de Laplace, on obtient :
    $
        P (n R T / P)^gamma = "cte"
    $
    Ce qui se simplifie en :
    $
        P^(1-gamma) T^gamma = "cte"/(n R)^gamma = "cte'"
    $
    Ainsi, on a $x = gamma$ et $y = 1 - gamma$.
]

#question(
    coups-de-pouce: "Exprimer $T$ en fonction de $P$ et différentier l'expression obtenue.",
)[
    En déduire la relation reliant $dd(P)/P$ et $dd(T)/T$.
][
    À partir de la relation $T^gamma P^(1-gamma) = "cte"$, on peut exprimer $T$ en fonction de $P$ :
    $
        T = "cte" P^((gamma - 1)/gamma)
    $
    En différenciant cette expression, on obtient :
    $
        dd(T) = ((gamma - 1)/gamma) "cte" P^((gamma - 1)/gamma - 1) dd(P)
    $
    En divisant par $T$, on a :
    $
        dd(T)/T = ((gamma - 1)/gamma) dd(P)/P
    $
]

#question(
    coups-de-pouce: "Utiliser la question précédente et l'équation fondamentale de l'hydrostatique.",
)[
    Établir l'expression du gradient de température adiabatique $dv(T, z)$ en fonction de $gamma$, $M$, $g$ et $R$.
][
    En utilisant l'équation hydrostatique $dv(P, z) = -mu g$ et l'équation d'état des gaz parfaits pour exprimer $mu$ en fonction de $P$ et $T$, on a $dv(P, z) = - (P M_"air") / (R T) g$
    soit
    $
        dd(P)/P = - (M_"air" g)/(R T) dd(z)
    $
    En remplaçant $dd(P)/P$ dans la relation obtenue précédemment, on a :
    $
        dd(T)/T = -((gamma - 1)/gamma) (M_"air" g)/(R T) dd(z)
    $
    Ce qui donne le gradient de température adiabatique :
    $
        dv(T, z) = - ((gamma - 1)/gamma) (M_"air" g)/(R)
    $
]

#question()[
    Quelle température fait-il en haut de la troposphère dans ce modèle adiabatique ?
][
    En utilisant l'expression du gradient de température adiabatique, on peut déterminer la température à une altitude donnée.
    $
        T(z) = T_0 - ((gamma - 1)/gamma) (M_"air" g)/R z
    $
    En remplaçant les valeurs numériques et en prenant $T_0 = #qty("298","K")$ :
    #let gam = 1.4
    #let M-air = 29e-3
    #let g = 9.81
    #let R = 8.314
    #let T0 = 298
    #let z = 11e3
    #let Ttop = T0 - ((gam - 1)/gam) * (M-air * g) / R * z
    $
        T(qty("11", "km")) = #qty(scientifique(Ttop, 4), "K")
    $
]