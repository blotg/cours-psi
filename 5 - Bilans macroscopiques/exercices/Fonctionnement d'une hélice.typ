#import "@local/prepa:0.1.0": *

#show: exercice.with(
    titre: "Fonctionnement d'une hélice",
)

Une hélice animée d'un mouvement de rotation uniforme autour de l'axe $(O x)$ est plongée dans un fluide parfait et homogène, de masse volumique $rho$. L'étude est faite dans le référentiel galiléen $cal(R)$ lié à l'axe de l'hélice. Dans ce référentiel, l'écoulement est stationnaire et incompressible. On néglige l'influence de la pesanteur.

On considère un tube de courant possédant la symétrie de révolution autour de l'axe $(O x)$ et s'appuyant sur les pales de l'hélice. À partir de ce tube de courant, on définit la surface fermée constituée de la surface latérale du tube de courant, $S_"lat"$ et des sections droites $S_1$ en amont et $S_2$ en aval. La pression à l'extérieur de ce tube de courant est uniforme et égale à $P_a$.

#figure(
    canvas({
        import draw: *
        bezier((5, 0), (5, 1), (4.85, 0), (4.85, 1))
        bezier((5, 0), (5, 1), (5.15, 0), (5.15, 1))
        bezier((5, 0), (5, -1), (4.85, 0), (4.85, -1))
        bezier((5, 0), (5, -1), (5.15, 0), (5.15, -1))
        bezier((0, 1.5), (5, 1), (2, 1.5), (3, 1))
        bezier((5, 1), (10, .5), (7, 1), (8, .5))
        bezier((0, -1.5), (5, -1), (2, -1.5), (3, -1))
        bezier((5, -1), (10, -.5), (7, -1), (8, -.5))
        line((0, 1.5), (0, -1.5), stroke: (dash: "dashed"))
        content((), $S_1$, anchor: "north", padding: .4em)
        line((10, 0.5), (10, -.5), stroke: (dash: "dashed"))
        content((), $S_2$, anchor: "north", padding: .4em)
        line((4.5, 1), (4.5, -1), stroke: (dash: "dashed"))
        content((), $S$, anchor: "north", padding: .4em)
        line((5.5, 1), (5.5, -1), stroke: (dash: "dashed"))
        content((), $S'$, anchor: "north", padding: .4em)
        line((0, 0), (rel: (.5, 0)), mark: (end: ">>", fill: black))
        content((), $va(v_1)$, anchor: "south", padding: .4em)
        line((5.5, 0), (rel: (1, 0)), mark: (end: ">>", fill: black))
        content((), $va(v')$, anchor: "south", padding: .4em)
        line((10, 0), (rel: (1.5, 0)), mark: (end: ">>", fill: black))
        content((), $va(v_2)$, anchor: "south", padding: .4em)
        content((0, 1), $P_a$, anchor: "east", padding: .6em)
        content((10, .5), $P_a$, anchor: "west", padding: .6em)
        content((7, 1.5), $P_a$)
        content((4.5, .5), $P$, anchor: "east", padding: .6em)
        content((5.5, .5), $P'$, anchor: "west", padding: .6em)
    }),
)

Sur la surface $S_1$, la vitesse est uniforme et égale à $v_1 ex$, sur $S_2$, elle vaut $v_2 ex$.

Au voisinage de l'hélice, on considère deux sections $S$ et $S'$ d'aire identique :
- en amont, sur $S$, la vitesse est $v ex$ et la pression est $P$
- en aval, sur $S'$, la vitesse est $v' ex$ et la pression est $P'$

Entre $S$ et $S'$, l'écoulement est perturbé, il existe une discontinuité de pression de part et d'autre de l'hélice.

#question[
    En utilisant le théorème de Bernoulli, exprimer la pression $P$ en fonction de $P_a$, $rho$, $v_1$ et $v$. Faire de même pour $P'$ en fonction de $P_a$, $rho$, $v_2$ et $v'$.
][
    L'écoulement est parfait, stationnaire, incompressible et homogène, on peut donc appliquer le théorème de Bernoulli entre $S_1$ et $S$ puis entre $S'$ et $S_2$. Les effets de la pesanteur étant négligés, on trouve :
    $
        cases(
            P = P_a + 1/2 rho (v_1^2 - v^2),
            P' = P_a + 1/2 rho (v_2^2 - v'^2)
        )
    $
]

#question(
    coups-de-pouce: (
        "Quelles sont les trois forces s'appliquant sur le système ?",
        "Les 3 forces sont les deux forces de pression et la force $\vv{F}$.",
        "Justifier que le débit volumique se conserve. En déduire une relation entre $v$ et $v'$.",
    ),
)[
    On note $va(F)$ la résultante des forces exercées par l'hélice sur le fluide. En appliquant le théorème de la résultante cinétique sur un système bien choisi, exprimer $va(F)$ en fonction de $S$, $P$ et $P'$, puis en fonction de $rho$, $S$, $v_1$ et $v_2$.
][
    On note
    - $Sigma^0$ le système ouvert délimité par les surfaces $S$ et $S'$
    - $delta Sigma_1$ le fluide traversant la surface $S$ entre $t$ et $t + dd(t)$
    - $delta Sigma_2$ le fluide traversant la surface $S'$ entre $t$ et $t + dd(t)$
    - $Sigma^*$ le système fermé défini à $t$ par $Sigma^*(t) = Sigma^0(t) union delta Sigma_1$.
    À l'instant $t+dd(t)$, le système $Sigma^*(t+dd(t)) = Sigma^0(t+dd(t)) union delta Sigma_2$.

    #figure(
        canvas({
            import draw: *
            bezier((5, 0), (5, 1), (4.85, 0), (4.85, 1))
            bezier((5, 0), (5, 1), (5.15, 0), (5.15, 1))
            bezier((5, 0), (5, -1), (4.85, 0), (4.85, -1))
            bezier((5, 0), (5, -1), (5.15, 0), (5.15, -1))
            bezier((0, 1.5), (5, 1), (2, 1.5), (3, 1))
            bezier((5, 1), (10, .5), (7, 1), (8, .5))
            bezier((0, -1.5), (5, -1), (2, -1.5), (3, -1))
            bezier((5, -1), (10, -.5), (7, -1), (8, -.5))
            line((0, 1.5), (0, -1.5), stroke: (dash: "dashed"))
            line((10, 0.5), (10, -.5), stroke: (dash: "dashed"))
            line((4.5, 1), (4.5, -1), stroke: (dash: "dashed"))
            line((5.5, 1), (5.5, -1), stroke: (dash: "dashed"))
            rect((4.5, -1), (5.5, 1), fill: black.transparentize(75%), stroke: none)
            rect((4.5, -1), (4.3, 1), fill: hachure(4pt), stroke: none)
            rect((5.5, -1), (5.7, 1), fill: hachure(4pt), stroke: none)
            content((5, 1), $Sigma^*$, anchor: "south", padding: .4em)
            content((4.4, -1), $delta Sigma_1$, anchor: "north", padding: .4em)
            content((5.6, -1), $delta Sigma_2$, anchor: "north", padding: .4em)
        }),
    )

    $Sigma^*$ est un système fermé, on peut appliquer le théorème de la résultante cinétique (autrement dit, faire un bilan de quantité de mouvement) :
    $
        va(F) + va(F_p) = dv(va(p^*), t) = (va(p^*)(t + dd(t)) - va(p^*)(t) )/ dd(t)
        = ( va(p_0)(t+dd(t)) + delta m_2 va(v') - va(p_0)(t) - delta m_1 va(v))/ dd(t)
    $
    Or le régime est stationnaire, donc $va(p_0)(t + dd(t)) = va(p_0)(t)$ et $delta m_1 = delta m_2 =: delta m$, d'où
    $
        va(F) + va(F_p) = (delta m)/dd(t) (va(v') - va(v))\
        va(F) + P S ex - P' S ex = D_m (v' - v) ex
    $
    Or en régime stationnaire et pour un écoulement incompressible, le débit volumique se conserve, donc $v S = v' S$, d'où $v = v'$. On en déduit finalement
    $
        va(F) = S (P' - P) ex = 1/2 rho S (v_2^2 - v_1^2) ex
    $
]

#question(
    coups-de-pouce: (
        "Justifier que la résultante des forces de pression est nulle."
    ),
)[
    En effectuant un bilan de quantité de mouvement cette fois-ci sur le volume compris entre $S_1$ et $S_2$, établir l'expression de $va(F)$ en fonction de $S$, $rho$, $v$, $v_1$ et $v_2$.
][
    On procède de la même manière que précédemment, en considérant cette fois le système ouvert délimité par les sections $S_1$ et $S_2$. On trouve :
    $
        va(F) = D_m (v_2 - v_1) ex = rho v S (v_2 - v_1) ex
    $
]

#question[
    En égalisant les expressions obtenues dans les deux questions précédentes, donner une relation simple entre $v$, $v_1$ et $v_2$.
][
    En égalisant les deux expressions de $va(F)$, on trouve
    $
        1/2 rho S (v_2^2 - v_1^2) = rho v S (v_2 - v_1)
    $
    soit finalement
    $
        v = (v_1 + v_2)/2
    $
]

#question(
    coups-de-pouce: (
        "Définir un système fermé à partir du système ouvert délimité par $S_1$ et $S_2$."
    ),
)[
    En appliquant le théorème de la puissance cinétique à un système fermé construit à partir du système ouvert délimité par $S_1$ et $S_2$, déterminer la puissance $cal(P)$ fournie par l'hélice au fluide. Donner le résultat en fonction du débit massique $D_m$, $v_1$ et $v_2$ puis en fonction de $va(F)$ et $va(v)$.
][
    On note
    - $Sigma^0$ le système ouvert délimité par les surfaces $S_1$ et $S_2$
    - $delta Sigma_1$ le fluide traversant la surface $S_1$ entre $t$ et $t + dd(t)$
    - $delta Sigma_2$ le fluide traversant la surface $S_2$ entre $t$ et $t + dd(t)$
    - $Sigma^*$ le système fermé défini à $t$ par $Sigma^*(t) = Sigma^0(t) union delta Sigma_1$.
    À l'instant $t+dd(t)$, le système $Sigma^*(t+dd(t)) = Sigma^0(t+dd(t)) union delta Sigma_2$.

    Le TPC donne :
    $
        cal(P) = dd(E_c^*)/dd(t) = (E_c^*(t + dd(t)) - E_c^*(t))/dd(t)
        = ( E_c^0(t + dd(t)) + 1/2 delta m_2 v_2^2 - E_c^0(t) - 1/2 delta m_1 v_1^2)/dd(t)
    $
    Or le régime est stationnaire, donc $E_c^0(t + dd(t)) = E_c^0(t)$ et $delta m_1 = delta m_2 =: delta m$, d'où
    $
        cal(P) = (delta m)/dd(t) (1/2 v_2^2 - 1/2 v_1^2) = D_m (1/2 v_2^2 - 1/2 v_1^2)
    $
    On peut alors remplacer $F = 1/2 rho S (v_2^2 - v_1^2)$ d'où $(v_2^2/2 - v_1^2/2) = F/(rho S)$ :
    $
        cal(P) = D_m F/(rho S) = (rho v S)/(rho S) F = v F = va(F) dot va(v)
    $
]

#question(
    coups-de-pouce: (
        "Justifier que $S_2<S_1$.",
    ),
)[
    Si $v_2> v_1$, commenter le signe de $cal(P)$ et justifier l'allure du tube de courant représenté sur le schéma.
][
    Si $v_2>v_1$, alors $cal(P) > 0$. Cela signifie que l'hélice fournit de l'énergie au fluide.

    Comme le débit volumique se conserve, on a $v_1 S_1 = v_2 S_2$, donc $S_2 = (v_1/v_2) S_1 < S_1$. Le tube de courant se resserre donc entre $S_1$ et $S_2$.
]
