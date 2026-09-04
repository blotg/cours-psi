#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Effet Hall",
)

On considère un conducteur ohmique parallélépipédique parcouru par un courant $I$ de vecteur densité de courant $va(j)$ uniforme et suivant $va(e_y)$. Ce conducteur est plongé dans un champ magnétique $va(B)$ uniforme, stationnaire et dirigé par $va(e_z)$.

#figure(
    canvas({
        import cetz.draw: *
        projection-cabinet()
        on-xy(z: 0.5, {
            rect((-1, 0), (1, 4))
        })
        on-xy(z: -0.5, {
            line((1, 0), (1, 4), (-1, 4))
            line((1, 0), (-1, 0), (-1, 4), stroke: (dash: "dashed"))
        })
        line((-1, 0, -0.5), (-1, 0, 0.5), stroke: (dash: "dashed"))
        line((-1, 4, -0.5), (-1, 4, 0.5))
        line((1, 0, -0.5), (1, 0, 0.5))
        line((1, 4, -0.5), (1, 4, 0.5))
        line((1, 0, -0.8), (1, 4, -0.8), mark: (symbol: ">>", fill: black))
        content((1, 2, -0.8), $l$, anchor: "north", padding: .4em)
        line((-1, 4.3, -0.5), (1, 4.3, -0.5), mark: (symbol: ">>", fill: black))
        content((0, 4.3, -0.5), $a$, anchor: "north-west", padding: .2em)
        line((-1, 4.3, -0.5), (-1, 4.3, 0.5), mark: (symbol: ">>", fill: black))
        content((-1, 4.3, 0), $b$, anchor: "west", padding: .2em)
        line((0, 2, 1.2), (rel: (0, 0, 1)), mark: (end: ">>", fill: black), name: "B")
        content("B.mid", $va(B)$, anchor: "west", padding: .4em)
        line((0, 1, 0), (rel: (0, 1, 0)), mark: (end: ">>", fill: black), name: "j")
        content("j.mid", $va(j)$, anchor: "south", padding: .4em)
        line((0, 7, 0), (rel: (1, 0, 0)), mark: (end: ">>", fill: black))
        content((), $x$, anchor: "north-east", padding: .2em)
        line((0, 7, 0), (rel: (0, 1, 0)), mark: (end: ">>", fill: black), name: "y")
        content((), $y$, anchor: "west", padding: .4em)
        line((0, 7, 0), (rel: (0, 0, 1)), mark: (end: ">>", fill: black), name: "z")
        content((), $z$, anchor: "south", padding: .4em)
    }),
)


#question(
    coups-de-pouce: (
        "Le poids peut être négligé. La composante magnétique et la composante électrique de la force de Lorentz sont toutes deux non-nulles.",
    ),
)[
    Faire un bilan des forces s'exerçant sur un électron du conducteur ohmique.
][
    - $(-e)va(E) + (-e)va(v) and va(B)$
    - $-m_e/tau va(v)$
    - poids (négligé)
]

#question(
    coups-de-pouce: (
        "Projeter le théorème de la quantité de mouvement suivant $ex$.",
    ),
)[
    En régime stationnaire, les lignes de courant sont suivant $ey$. En déduire une expression de la composante $E_x$ du champ électrique suivant $ex$ en fonction de la charge $e$ d'un porteur, de leur densité $n$, de $va(j)$ et de $va(B)$.
][
    Si les lignes de courants sont selon $ey$, comme $va(j)=rho_"mobile" va(v)$, la vitesse est selon $ey$ également.
    La seconde loi de Newton dans le référentiel du parallèlépipède s'écrit
    $
        m_e dv(va(v), t) = (-e)va(E) + (-e)va(v) and va(B) -m_e/tau va(v)
    $
    En projection sur $ex$, il reste
    $
        0 = -e E_x + (-e)v B
    $
    d'où $E_x = -v B$
    or $va(j) = n (-e) v$, soit $v = -1/(n e)j$, d'où
    $ E_x = 1/(n e)j B $
]

#question(
    coups-de-pouce: (
        "Relier la circulation du champ électrique à la différence de potentiel.",
    ),
)[
    En déduire la différence de potentiel existant entre les faces $x=-a/2$ et $x=a/2$. L'exprimer en fonction de $I$ et d'un paramètre qu'on notera $R_"Hall"$ et dont on donnera l'unité.
][
    On souhaite passer d'une relation locale à une relation globale. Comme $I=integral.double va(j) dot va(dd(S))$, on intègre selon $x$ et $z$ pour faire apparaitre $I$.
    $
        integral_(z=-b/2)^(b/2) integral_(x=-a/2)^(a/2) E_x dd(x) dd(z) &= integral_(z=-b/2)^(b/2) integral_(x=-a/2)^(a/2) 1/(n e) j B dd(x) dd(z) \
        b integral_(-a/2)^(a/2) -pdv(V, x) dd(x) &= B/(n e) integral.double j dd(S) \
        b (V(a/2) - V(-a/2)) &= B/(n e) I \
    $
    On en déduit la différence de potentiel
    $ U = V(a/2) - V(-a/2) = B I/(n e b) = R_"Hall" I $
    avec $ R_"Hall" = B/(n e b) $

    $R_"Hall"$ se mesure en #unit("T m^3 /A /s /m"), or l'équation de Maxwell-Faraday nous apprend que $#unit("T/s") = #unit("V/m^2")$. Donc l'unité de $R_"Hall"$ est
    $
      unit("V/m^2 m^2 /A") = unit("V/A") = unit("O")
    $
]

#question(
    coups-de-pouce: (),
)[
    L'épaisseur du conducteur vaut $b = qty("1", "mm")$.

    Évaluer la valeur de $R_"Hall"$ pour le champ magnétique terrestre dans le cas du cuivre ($M_ce("Cu")=qty("63.5", "g/mol")$ ; $mu_ce("Cu")=qty("8.96", "g/cm^3")$) *puis* d'un semi-conducteur de densité volumique de charges $n=qty("1.6e22", "/m^3")$. Est-il possible d'utiliser ce dispositif pour mesurer le champ magnétique terrestre dans les deux cas ?
][
    Le champ magnétique terrestre vaut environ $B = qty("5e-5", "T")$.

    #let mu-Cu = 9.96e3
    #let na = 6.02e23
    #let M-Cu = 63.5e-3
    #let n-Cu = mu-Cu * na / M-Cu
    #let B = 5e-5
    #let b = 1e-3
    #let e = 1.6e-19
    #let R-Cu = B/(n-Cu * e * b)
    Pour le cuivre, on calcule la densité volumique de charges
    $
        n_ce("Cu") = (mu Na) / M = #qty(scientifique(n-Cu,1),"/m^3")
    $
    d'où
    $
        R_("Hall", ce("Cu")) = B/(n e b) = qty(#scientifique(R-Cu,1),"O")
    $
    Ce qui est extrêmement faible et difficilement mesurable.

    Pour le semi-conducteur,
    #let n-SC = 1.6e22
    #let R-SC = B/(n-SC * e * b)
    $
         R_"Hall, semi-conducteur" = B/(n e b) = qty(#scientifique(R-SC,1),"O")
    $
    Ce qui est plus grand mais reste faible. Cependant, avec un courant suffisamment grand et un voltmètre assez sensible, il est possible de mesurer cette différence de potentiel.
]
