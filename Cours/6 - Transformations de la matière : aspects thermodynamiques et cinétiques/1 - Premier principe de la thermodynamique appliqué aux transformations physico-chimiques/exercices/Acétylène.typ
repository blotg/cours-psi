#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Combustion de l'acétylène",
    numérique: true,
)

L'acétylène #ce("C2H2") est un gaz très utilisé en soudure, notamment en raison de la température élevée de la flamme qu'il produit lorsqu'il brûle en présence d'oxygène.

#question(
    coups-de-pouce: (
        "Quelles sont les espèces produites par une combustion ?",
        "Une combustion produit du dioxyde de carbone et de l'eau.",
    ),
)[
    Écrire l'équation de la réaction de combustion complète de l'acétylène en présence de dioxygène. Les états physiques des espèces chimiques seront précisés et on prendra un coefficient stœchiométrique relatif égal à $-1$ pour l'acétylène.
][
    La réaction de combustion complète de l'acétylène s'écrit :
    $
        #ce("C2H2(g)") + 5\/2 #ce("O2(g)") #ce("->") 2 #ce("CO2(g)") + #ce("H2O(g)")
    $
]

#let DfH_H2O = -286e3 + 2257e3 * 18.0e-3
#question(
    coups-de-pouce: (
        "Écrire l'équation bilan de la vaporisation de l'eau. Quelle est son enthalpie standard de réaction ?",
    ),
)[
    Calculer l'enthalpie standard de formation de #ce("H2O(g)").
][
    La vaporisation de l'eau a pour équation bilan :
    $
        #ce("H2O(l) -> H2O(g)")
    $
    Son enthalpie standard de réaction est $Delta_r H^circ = L_"vap" M_ce("H2O")$. D'après la loi de Hess, elle s'écrit également $Delta_r H^circ = Delta_f H^circ (ce("H2O(g)")) - Delta_f H^circ (ce("H2O(l)"))$.

    On en déduit donc que
    $
        Delta_f H^circ (ce("H2O(g)")) = Delta_f H^circ (ce("H2O(l)")) + L_"vap" M_ce("H2O") = #qty(scientifique(DfH_H2O, 3), "J/mol")
    $
]

#let DrH = -2 * 394e3 + 1 * DfH_H2O - 227e3
#question(
    coups-de-pouce: (
        "Utiliser la loi de Hess pour exprimer l'enthalpie standard de la réaction de combustion de l'acétylène en fonction des enthalpies standard de formation des espèces chimiques impliquées.",
    ),
)[
    Calculer l'enthalpie standard de la réaction de combustion de l'acétylène.
][
    La loi de Hess permet d'écrire l'enthalpie standard de la réaction de combustion de l'acétylène comme
    $
        Delta_r H^circ = 2 Delta_f H^circ (ce("CO2(g)")) + 1 Delta_f H^circ (ce("H2O(g)")) - 1 Delta_f H^circ (ce("C2H2(g)")) - 5/2 Delta_f H^circ (ce("O2(g)"))\
        = #qty(scientifique(DrH, 3), "J/mol")
    $
    car l'enthalpie standard de formation du dioxygène est nulle (corps simple dans son état standard).
]

La capacité thermique molaire à pression constante de l'eau et du dioxyde de carbone changent beaucoup entre la température ambiante (prise à #qty("25", "Celsius")) et la température de flamme. Pour rendre de compte de cette variation, on introduit les polynômes NASA dont les coefficients ont été déterminés expérimentalement pour coller au mieux aux données expérimentales :
$
    c_(P,m) / R = a_0 T^(-2) + a_1 T^(-1) + a_2 + a_3 T + a_4 T^2 + a_5 T^3 + a_6 T^4
$

Les coefficients $a_i$ sont répertoriés dans les données à la fin de l'exercice.

#question(
    coups-de-pouce: (
        "Penser à utiliser une structure conditionnelle pour choisir les bons coefficients en fonction de la température.",
    ),
)[
    Définir les fonctions `cpm_CO2(T)` et `cpm_H2O(T)` qui renvoient la capacité thermique molaire à pression constante du dioxyde de carbone et de l'eau, respectivement, en fonction de la température $T$ (en Kelvin). On utilisera les polynômes NASA pour les calculer.
][
    ```python
    R = 8.314  # J/mol/K

    coefs_co2_basse = [4.94e4, -6.26e2, 5.30, 2.50e-3, -2.13e-7, -7.69e-10, 2.85e-13]
    coefs_co2_haute = [1.18e5, -1.79e3, 8.29, -9.22e-5, 4.86e-9, -1.89e-12, 6.33e-16]
    coefs_h2o_basse = [-3.95e4, 5.76e2, 9.32e-1, 7.22e-3, -7.34e-6, 4.96e-9, -1.34e-12]
    coefs_h2o_haute = [1.03e-6, -2.41e3, 4.65, 2.29e-3, -6.84e-7, 9.43e-11, -4.82e-15]

    def cpm_CO2(T):
        s = 0
        if T <=1000:
            for i in range(-2, 5):
                s += coefs_co2_basse[i + 2] * T**i
        else:
            for i in range(-2, 5):
                s += coefs_co2_haute[i + 2] * T**i
        return s*R

    def cpm_H2O(T):
        s = 0
        if T <=1000:
            for i in range(-2, 5):
                s += coefs_h2o_basse[i + 2] * T**i
        else:
            for i in range(-2, 5):
                s += coefs_h2o_haute[i + 2] * T**i
        return s*R
    ```
]

#question(
    coups-de-pouce: (),
)[
    On considère un mélange de dioxygène $n_1 unit("mol")$ de #ce("CO2") et $n_2 unit("mol")$ de #ce("H2O") passant de la température $T_i=#qty("25", "Celsius")$ à une température $T_f$. Écrire l'expression de la variation d'enthalpie $Delta H$ du mélange comme une intégrale faisant intervenir $c_(p,m)(ce("CO2"))(T)$, $c_(p,m)(ce("H2O"))(T)$, $n_1$ et $n_2$.
][
    La variation d'enthalpie du mélange s'écrit
    $
        Delta H = integral_(T_i)^(T_f) (n_1 c_(p,m)(ce("CO2(g)"))(T) + n_2 c_(P,m)(ce("H2O(g)"))(T)) dd(T)
    $
]

#question[
    En exhibant un cycle, montrer que la température de flamme $T_f$ d'un mélange de dioxygène et d'acétylène dans les proportions stœchiométriques vérifie l'équation
    $
        integral_(T_i)^(T_f) (2 c_(p,m)(ce("CO2(g)"))(T) + c_(P,m)(ce("H2O(g)"))(T)) dd(T) + Delta_r H^circ = 0
    $
][
    #figure(
        canvas({
            import cetz.draw: *
            content(
                (-2.5, 0),
                [
                    $n unit("mol")$ de #ce("C2H2(g)")\
                    $5/2 n unit("mol")$ de #ce("O2(g)")\
                    $T_i$, $P^circ$\
                    #h(1fr) état initial
                ],
                frame: "rect",
                padding: .5em,
                name: "A",
            )
            content(
                (2.5, 0),
                [
                    $2 n unit("mol")$ de #ce("CO2(g)")\
                    $n unit("mol")$ de #ce("H2O(g)")\
                    $T_f$, $P^circ$\
                    #h(1fr) état final
                ],
                frame: "rect",
                padding: .5em,
                name: "B",
            )
            content(
                (0, -4),
                [
                    $2 n unit("mol")$ de #ce("CO2(g)")\
                    $n unit("mol")$ de #ce("H2O(g)")\
                    $T_i$, $P^circ$\
                    #h(1fr) état intermédiaire fictif
                ],
                frame: "rect",
                padding: .5em,
                name: "C",
            )
            line("A", "B", mark: (end: ">>", fill: black), name: "AB")
            line("C", "B", mark: (end: ">>", fill: black), name: "CB")
            line("A", "C", mark: (end: ">>", fill: black), name: "AC")
            content("AB.mid", $Delta H^circ_1$, anchor: "south", padding: .4em)
            content("CB.mid", $Delta H^circ_3$, anchor: "north-west", padding: .2em)
            content("AC.mid", $Delta H^circ_2$, anchor: "north-east", padding: .2em)
        }),
    )

    La transformation de l'état initial à l'état final est adiabatique, donc $Delta H^circ_1 = 0$.

    La transformation de l'état initial à l'état intermédiaire fictif correspond à la combustion isotherme de l'acétylène, donc $Delta H^circ_2 = n Delta_r H^circ$.

    La transformation de l'état intermédiaire fictif à l'état final correspond au chauffage du mélange de #ce("CO2") et #ce("H2O") de la température $T_i$ à la température $T_f$, donc
    $
        Delta H^circ_3 = integral_(T_i)^(T_f) (2 n c_(p,m)(ce("CO2(g)"))(T) + n c_(P,m)(ce("H2O(g)"))(T)) dd(T)
    $

    L'enthalpie est une fonction d'état, sa variation ne dépend pas du chemin suivi. On en déduit que
    $
        Delta H^circ_1 = Delta H^circ_2 + Delta H^circ_3
    $
    $
        integral_(T_i)^(T_f) (2 n c_(p,m)(ce("CO2(g)"))(T) + n c_(P,m)(ce("H2O(g)"))(T)) dd(T) + n Delta_r H^circ = 0
    $
    soit, en simplifiant par $n$,
    $
        integral_(T_i)^(T_f) (2 c_(p,m)(ce("CO2(g)"))(T) + c_(P,m)(ce("H2O(g)"))(T)) dd(T) + Delta_r H^circ = 0
    $
]

On note $f$ la fonction définie par
$
    f(theta) = integral_(T_i)^(theta) (2 c_(p,m)(ce("CO2(g)"))(T) + c_(P,m)(ce("H2O(g)"))(T)) dd(theta) + Delta_r H^circ
$
On cherche à évaluer numériquement le zéro de cette fonction, qui correspond à la température de flamme.

#question[
    Exprimer $f'(theta)$.
][
    $
        f'(theta) = 2 c_(p,m)(ce("CO2(g)"))(theta) + c_(P,m)(ce("H2O(g)"))(theta)
    $
]

#question[
    Définir les fonctions Python `df(theta)` et `f(theta)` qui calculent respectivement $f'(theta)$ et $f(theta)$. On pourra utiliser la fonction `quad(f, a, b)` du module `scipy.integrate` qui renvoie un couple dont le premier élément est l'intégrale de la fonction `f` entre les bornes `a` et `b`.
][
    ```python
    from scipy.integrate import quad
    DrH = 2 * -394e3 + 1 * -286e3 - 1 * 227e3 - 5/2 * 0
    def df(theta):
        return 2 * cpm_CO2(theta) + cpm_H2O(theta)

    def f(theta):
        T_i = 25 + 273.15  # K
        intégrale, _ = quad(df, T_i, theta)
        return intégrale + DrH
    ```
]

#question()[
    En utilisant la méthode de Newton, déterminer une valeur approchée de la température de flamme $T_f$ du mélange acétylène/dioxygène. On arrêtera l'itération lorsque la différence entre deux estimations successives de la température sera inférieure à #qty("0.1", "K").
][
    ```python
    xk = 0
    xk1 = 1000
    while abs(xk1 - xk) >= 0.1:
        xk = xk1
        xk1 = xk - f(xk) / df(xk)
    print(f"Température de flamme approchée : {xk1} K")
    ```
]// L'AN donne n'importe quoi pour une raison encore non élucidée

*Données*

#table(
    columns: 5,
    align: (left,) + (center,) * 4,
    [espèce], ce("C2H2(g)"), ce("O2(g)"), ce("CO2(g)"), ce("H2O(l)"),
    [$Delta_f H^circ$ (#unit("kJ/mol"))], num("227"), [...], num("-394"), num("-286"),
)

Chaleur latente de vaporisation de l'eau : #qty("2257", "kJ/kg")

Masse molaire de l'eau : #qty("18.0", "g/mol")

Constante des gaz parfaits : $R = #qty("8.314", "J/mol/K")$

#{
    set text(size: 10pt)
    table(
        columns: 8,
        align: (left + horizon,) + (center + horizon,) * 7,
        table.header([], $a_0$, $a_1$, $a_2$, $a_3$, $a_4$, $a_5$, $a_6$),
        [#ce("CO2(g)")\ entre #qty("300", "K") et #qty("1000", "K")],
        num("4.94e4"),
        num("-6.26e2"),
        num("5.30"),
        num("2.50e-3"),
        num("-2.13e-7"),
        num("-7.69e-10"),
        num("2.85e-13"),

        [#ce("CO2(g)")\ entre #qty("1000", "K") et #qty("6000", "K")],
        num("1.18e5"),
        num("-1.79e3"),
        num("8.29"),
        num("-9.22e-5"),
        num("4.86e-9"),
        num("-1.89e-12"),
        num("6.33e-16"),

        [#ce("H2O(g)")\ entre #qty("300", "K") et #qty("1000", "K")],
        num("-3.95e4"),
        num("5.76e2"),
        num("9.32e-1"),
        num("7.22e-3"),
        num("-7.34e-6"),
        num("4.96e-9"),
        num("-1.34e-12"),

        [#ce("H2O(g)")\ entre #qty("1000", "K") et #qty("6000", "K")],
        num("1.03e-6"),
        num("-2.41e3"),
        num("4.65"),
        num("2.29e-3"),
        num("-6.84e-7"),
        num("9.43e-11"),
        num("-4.82e-15"),
    )
}

On pourra copier-coller les listes python suivantes pour ne pas avoir à recopier les coefficients manuellement :
```python
coefs_co2_basse = [4.94e4, -6.26e2, 5.30, 2.50e-3, -2.13e-7, -7.69e-10, 2.85e-13]
coefs_co2_haute = [1.18e5, -1.79e3, 8.29, -9.22e-5, 4.86e-9, -1.89e-12, 6.33e-16]
coefs_h2o_basse = [-3.95e4, 5.76e2, 9.32e-1, 7.22e-3, -7.34e-6, 4.96e-9, -1.34e-12]
coefs_h2o_haute = [1.03e-6, -2.41e3, 4.65, 2.29e-3, -6.84e-7, 9.43e-11, -4.82e-15]
```
