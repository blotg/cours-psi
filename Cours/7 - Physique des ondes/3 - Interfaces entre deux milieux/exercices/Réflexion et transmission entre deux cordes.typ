#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Réflexion et transmission entre deux cordes",
    difficulté: 1
)

Deux cordes différentes sont reliées en $x=0$. Celle de gauche, numérotée 1, a une masse linéique $mu_1$ et celle de droite, numérotée 2, une masse linéique $mu_2$. Elles sont tendues sous une tension $T$.

Une onde se propage dans la corde 1. On observe qu'en $x=0$, elle donne naissance à une onde réfléchie sur la corde 1 et à une onde transmise sur la corde 2. On modélise ces trois ondes par :
$
    underline(y_i(x,t)) = y_(0,i) e^(j(omega_i t-k_i x))\
    underline(y_r(x,t)) = underline(y_(0,r)) e^(j(omega_r t+k_r x))\
    underline(y_t(x,t)) = underline(y_(0,t)) e^(j(omega_t t-k_t x))
$

#question(
    coups-de-pouce: (
        "Ces ondes sont-elles progressives ? stationnaires ? harmoniques ?"
    ),
)[
    Quelles sont les natures des 3 ondes ?
][
    Ce sont des ondes progressives harmoniques. Les ondes incidente et transmise se propagent dans le sens des $x$ croissants, tandis que l'onde réfléchie se propage dans le sens des $x$ décroissants.
]

#question(
    coups-de-pouce: (
        "Comment s'écrit l'onde totale dans la corde de gauche ? Dans la corde de droite ?",
        "L'onde totale est continue en $x=0$.",
    ),
)[
    Montrer que les trois pulsations temporelles sont identiques.
][
    L'onde dans la corde 1 est
    $
        underline(y_1)(x,t) = underline(y_i)(x,t) + underline(y_r)(x,t) = y_(0,i) e^(j(omega_i t-k_i x)) + underline(y_(0,r)) e^(j(omega_r t+k_r x))
    $
    et l'onde dans la corde 2 est
    $
        underline(y_2)(x,t) = underline(y_t)(x,t) = underline(y_(0,t)) e^(j(omega_t t-k_t x))
    $
    En $x=0$, les cordes sont reliées, on a donc
    $
        forall t quad underline(y_1)(0,t) = underline(y_2)(0,t) \
        forall t quad y_(0,i) e^(j omega_i t) + underline(y_(0,r)) e^(j omega_r t) = underline(y_(0,t)) e^(j omega_t t) \
        forall t quad y_(0,i) e^(j (omega_i - omega_t)t ) + underline(y_(0,r)) e^(j(omega_r - omega_t)t) = underline(y_(0,t))\
    $
    #[
        #set math.equation(numbering: "(1)")
        $
            forall t quad y_(0,i) e^(j (omega_i - omega_t)t ) = - underline(y_(0,r)) e^(j(omega_r - omega_t)t) + underline(y_(0,t))
        $ <eq1>
    ]
    Sur une copie on peut s'arrêter là et dire que le terme de gauche et le terme de droite sont deux fonctions harmoniques égales à tout temps donc elles ont même pulsation (et même phase, même amplitude). On trouve alors
    $
        cases(
            omega_i = omega_t,
            omega_r = omega_t
        )
    $
    D'où
    $
        omega_i = omega_r = omega_t
    $
    On peut le démontrer plus rigoureusement :
    $
        forall t quad y_(0,i) j(omega_i - omega_t) e^(j (omega_i - omega_t)t ) = - underline(y_(0,r)) j(omega_r - omega_t) e^(j(omega_r - omega_t)t)\
        forall t quad y_(0,i) (omega_i - omega_t) e^(j (omega_i - omega_t - omega_r + omega_t)t ) = - underline(y_(0,r)) (omega_r - omega_t) \
        forall t quad y_(0,i) (omega_i - omega_t) e^(j (omega_i - omega_r )t ) = - underline(y_(0,r)) (omega_r - omega_t) \
    $
    Le terme de droite ne dépend pas de $t$ donc celui de gauche non plus :
    $
        omega_i - omega_r = 0 quad "ou" quad omega_i - omega_t = 0
    $
    En utilisant l'équation (1), on trouve que dans les deux cas, $omega_i = omega_r = omega_t$.
]

#question(
    coups-de-pouce: (
        "Faire tendre $epsilon$ vers $0$ pour montrer la continuité de $va(T)$ en $0$.",
        "Projeter la continuité de $va(T)$ sur $ey$ pour relier les inclinaisons de la corde juste à gauche et juste à droite de la jonction.",
        "Relier les inclinaisons aux dérivées spatiales de $y_1$ et $y_2$ en $x=0$.",
    ),
)[
    En appliquant le théorème de la résultante cinétique sur une portion de corde de longueur $2 epsilon$ à la jonction, montrer que
    $
        forall t quad lr(pdv(y_1, x)|)_(x=0,t) = lr(pdv(y_2, x)|)_(x=0,t)
    $
    On notera $va(T_1)$ et $va(T_2)$ les tensions exercées de part et d'autre de la jonction.
][
    Le TRC s'écrit
    $
        (mu_1 epsilon + mu_2 epsilon) lr(pdv(y, t, 2)|)_(x=0,t) ey = -va(T_1)(x=-epsilon) + va(T_2)(x=epsilon)
    $
    En faisant tendre $epsilon$ vers $0$, on trouve
    $
        forall t quad va(0) = -va(T_1)(x=0^-,t) + va(T_2)(x=0^+,t)
    $
    La projection de cette égalité sur $ex$ donne $T_1 = T_2$, la tension est la même dans les deux cordes.

    La projection de cette égalité sur $ey$ donne
    $
        forall t quad 0 = -T alpha_1(x=0^-,t) + T alpha_2(x=0^+,t)
    $
    Soit
    $
        forall t quad alpha_1(x=0^-,t) = alpha_2(x=0^+,t)\
        forall t quad lr(pdv(y_1, x)|)_(x=0,t) = lr(pdv(y_2, x)|)_(x=0,t)
    $
]

#question(
    coups-de-pouce: (
        "Utiliser les 2 relations reliant $y_1$ et $y_2$ en $x=0$.",
        "Définir les coefficients de réflexion et de transmission en amplitude $r$ et $t$ par analogie avec les ondes sonores."
    ),
)[
    Définir puis établir les coefficients de réflexion et de transmission en amplitude $r$ et $t$, en fonction des célérités $c_1$ et $c_2$ dans les cordes.
][
    L'équation de la question précédente peut être réécrite
    $
        j k_1 y_(0,i) e^(j(omega t)) - j k_1 underline(y_(0,r)) e^(j(omega t)) = j k_2 underline(y_(0,t)) e^(j(omega t))\
        k_1 y_(0,i) - k_1 underline(y_(0,r)) = k_2 underline(y_(0,t))\
    $
    En combinant cette égalité avec (1), on obtient
    $
        cases(
            y_(0,i) + underline(y_(0,r)) = underline(y_(0,t)),
            k_1 y_(0,i) - k_1 underline(y_(0,r)) = k_2 underline(y_(0,t))
        )
    $
    D'où
    $
        cases(
            2 k_1 y_(0,i) = (k_1 + k_2) underline(y_(0,t)),
            (-k_2+k_1) y_(0,i) + (- k_2 - k_1) underline(y_(0,r)) = 0
        )
    $
    On en déduit les coefficients de réflexion et de transmission en amplitude
    $
        cases(
            r =: (underline(y_(0,r)))/(y_(0,i)) = (k_1 - k_2)/(k_1 + k_2),
            t =: (underline(y_(0,t)))/(y_(0,i)) = (2 k_1)/(k_1 + k_2)
        )
    $
    On peut les exprimer en fonction des célérités en utilisant les relations de dispersion $k_1 = omega/c_1$ et $k_2 = omega/c_2$ :
    $
        cases(
            r =: (1/c_1 - 1/c_2)/(1/c_1 + 1/c_2) = (c_2 - c_1)/(c_1 + c_2),
            t =: (2/c_1)/(1/c_1 + 1/c_2) = (2 c_2)/(c_1 + c_2)
        )
    $

]
