#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Corde vibrante soumise à des frottements visqueux",
)


On étudie une corde vibrante, de longueur $L$, de masse linéique $mu$, attachée à ses deux extrémités. Elle est confondue avec l'axe $(O x)$ au repos. Elle est tendue sous une tension $T$ et est soumise à une force dissipative de frottement fluide : un élément de longueur $dd(x)$ de corde, dont le déplacement $y(x,t)$ est transversal suivant $ey$ est soumis à la force $-alpha pdv(y, t) dd(x) ey$.

#question(
    coups-de-pouce: (
        "Reprendre la démonstration de l'équation de d'Alembert du cours en rajoutant la force de frottement fluides."
    ),
)[
    Établir l'équation d'onde vérifiée par l'onde dans la corde. On introduira les coefficients $c=sqrt(T/mu)$ et $a=alpha/T$.
][
    Le théorème de la résultante cinétique appliqué à un élément de corde donne
    $
        mu dd(x) pdv(y, t, 2) ey= va(T_g)(x) + va(T_d)(x+dd(x)) - alpha pdv(y, t) dd(x) ey
    $
    La troisième li de Newton permet d'écrire $va(T_d)(x)=-va(T_g)(x) =: va(T)(x)$.

    En utilisant la relation de Taylor, on obtient
    $
        mu dd(x) pdv(y, t, 2) ey= -cancel(va(T)(x)) + cancel(va(T)(x)) + dd(x) pdv(va(T), x) - alpha pdv(y, t) dd(x) ey
    $
    En notant $theta$ l'angle formé par la corde avec l'horizontale, et en le supposant petit, on peut projeter
    $
        va(T) = T cos(theta) ex + T sin(theta) ey approx T ex + T theta(x, t) ey
    $
    La projection selon $ex$ de la relation précédente donne $pdv(T, x)=0$ (tension constante dans le corde), tandis que la projection selon $ey$ donne
    $
        mu pdv(y, t, 2) = T pdv(theta, x) - alpha pdv(y, t)
    $
    On peut enfin écrire $theta approx tan(theta) approx pdv(y, x)$ et on obtient finalement
    $
        pdv(y, x, 2) - 1/c^2 pdv(y, t, 2) - a pdv(y, t) = 0
    $
    avec $c=sqrt(T/mu)$ et $a=alpha/T$.
]

#question(
    coups-de-pouce: (
        "Introduire la forme proposée dans l'équation d'onde et séparer les variables."
    ),
)[
    On cherche une solution à variables séparées en $y(x,t)=f(x)g(t)$. À quelles équations différentielles les deux fonctions $f$ et $g$ obéissent-elles ?
][
    En remplaçant $y$ par $f(x)g(t)$ dans l'équation d'onde, on trouve
    $
        f''(x)g(t) - 1/c^2 f(x)g''(t) - a f(x)g'(t) = 0
    $
    En divisant par $f(x)g(t)$, on trouve
    $
        (f''(x))/f(x) = 1/c^2 (g''(t))/g(t) + a (g'(t))/g(t)
    $
    Le membre de gauche ne dépend que de $x$, tandis que le membre de droite ne dépend que de $t$. Ils sont donc égaux à une même constante, que l'on note $K$. On trouve ainsi les deux équations différentielles suivantes :
    $
        cases(
            f''(x) - K f(x) = 0,
            g''(t) + a c^2 g'(t) - c^2 K g(t) = 0
        )
    $
]

#question(
    coups-de-pouce: (
        "L'équation différentielle sur $f$ possède trois familles de solution. Parmi ces familles, quelle est la seule qui admet des solutions non nulles compatibles avec les conditions aux limites ?",
    ),
)[
    Quelles sont les familles de solutions de l'équation sur $f$. On répondra en distinguant 3 cas sur la valeur de $K$. Parmi ces familles, laquelle admet des solutions non nulles compatibles avec les conditions aux limites ?
][
    - Si $K>0$, les solutions sont de la forme $f(x)=A exp(sqrt(K) x) + B exp(-sqrt(K) x)$.
    Les conditions aux limites $f(0)=f(L)=0$ impliquent $A+B=0$ et $A exp(sqrt(K) L) + B exp(-sqrt(K) L)=0$, d'où $A=0$ et $B=0$. On a donc une solution nulle $f(x)=0$.
    - Si $K=0$, les solutions sont de la forme $f(x)=A x + B$.
    Les conditions aux limites $f(0)=f(L)=0$ impliquent $B=0$ et $A L + B=0$, d'où $A=0$. On a donc une solution nulle $f(x)=0$.
    - Si $K<0$, les solutions sont de la forme $f(x)=A sin(sqrt(-K) x) + B cos(sqrt(-K) x)$.
    Les conditions aux limites $f(0)=f(L)=0$ impliquent $B=0$ et $A sin(sqrt(-K) L)=0$, d'où $sqrt(-K) L = n pi$ avec $n in NN^*$.
]

#question(
    coups-de-pouce: (
        "Compte tenu de l'hypothèse de frottements faibles, quel est le signe du discriminant de l'équation différentielle sur $g$ ?"
    ),
)[
    Résoudre l'équation sur $g$. On se placera dans le cas de frottements faibles, et on précisera explicitement l'inégalité qu'implique cette hypothèse. On ne cherchera pas à expliciter les constantes.
][
    Le discriminant de l'équation sur $g$ est $Delta = a^2 c^4 + 4 c^2 K$. L'hypothèse de frottements faibles implique que les solutions sont proches de celles du cas sans frottement, c'est à dire que $a$ est petit devant les autres termes de l'équation. En particulier, on doit avoir $a^2 c^4 << 4 c^2 |K|$, ce qui implique que $Delta approx 4 c^2 K < 0$

    Les racines du polynôme caractéristique sont $r_(1,2) = -a c^2 / 2 plus.minus j sqrt(-4 c^2 K)$

    Les solutions de l'équation sur $g$ sont alors de la forme
    $
        g(t) = exp(-(a c^2)/2 t) (C cos(sqrt(-4c^2K) t) + D sin(sqrt(-4c^2K) t))
    $
]

#question(
    coups-de-pouce: (
        "La durée caractéristique d'amortissement apparait dans l'exponentielle."
    ),
)[
    En déduire la durée caractéristique d'amortissement des oscillations. Que devient l'énergie initialement contenue dans la vibration de la corde ?
][
    La durée caractéristique d'amortissement est $tau = 2/(a c^2)$. L'énergie initialement contenue dans la vibration de la corde est dissipée par les frottements visqueux, et est donc transformée en énergie thermique.
]
