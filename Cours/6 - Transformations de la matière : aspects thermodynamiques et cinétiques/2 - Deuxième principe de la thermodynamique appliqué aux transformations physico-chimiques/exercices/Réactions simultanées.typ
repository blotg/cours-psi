#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Réactions simultanées",
    numérique: true,
)

On envisage la conversion du méthane par la vapeur d'eau à $T = #qty("900", "K")$, sous une pression totale $P_"tot"$, à partir d'un mélange initial contenant #qty("4.0", "mol") d'eau et #qty("1.0", "mol") de méthane. On doit envisager les deux équilibres chimiques suivants, dans lesquels les constituants sont des gaz parfaits :
$
    ce("CH4 (g) + H2O (g) &= CO (g) + 3 H2 (g)") #h(1.5cm) & K^circ_1 = num("1,306") \
                ce("CO (g) + H2O (g) &= CO2 (g) + H2 (g)") & K^circ_2 = num("2,204")
$

La phase gazeuse se comporte comme un mélange parfait de gaz parfaits.

#question(
    coups-de-pouce: (
        "Pour chaque espèce, quelle quantité de matière y avait-il initialement ? Quelle quantité de matière a été produite ou consommée par chaque réaction ?",
    ),
)[
    Exprimer, lorsque les deux équilibres chimiques sont atteints, la quantité de matière de chaque participant, en fonction de la quantité de matière initiale en méthane $n_0(ce("CH4"))$ et en eau $n_0(ce("H2O"))$ et de l'avancement $xi_1$ (respectivement $xi_2$ ) de la réaction (1) (resp. (2)).
][
    $ n_f (ce("CH4 (g)")) = n_0 (ce("CH4 (g)")) - xi_1 $
    $ n_f (ce("H2O (g)")) = n_0 (ce("H2O (g)")) - xi_1 - xi_2 $
    $ n_f (ce("CO (g)")) = xi_1 - xi_2 $
    $ n_f (ce("H2 (g)")) = 3 xi_1 + xi_2 $
    $ n_f (ce("CO2 (g)")) = xi_2 $
]

#question(
    coups-de-pouce: (
        "L'activité d'un gaz est égal à sa pression partielle divisé par la pression standard.",
        "La pression partielle est la pression du gaz multiplié par la fraction molaire $P_i=P_\"tot\" (n_i)/(n_\"tot,gaz\")$",
    ),
)[
    Exprimer les quotients réactionnels en fonction de la pression totale $P_"tot"$, de la pression standard $P^circ$, des quantités de matières initiales $n_0(ce("CH4"))$ et $n_0(ce("H2O"))$ et des avancements $xi_1$ et $xi_2$.
][
    $
        Q_1 = product a_i^(nu_i) = (P(ce("CO (g)")) P(ce("H2 (g)"))^3) / (P(ce("CH4 (g)")) P(ce("H2O (g)")) (P^circ)^2)
    $
    avec
    $
        P(ce("CH4 (g)")) = P_"tot" (n_0(ce("CH4 (g)")) - xi_1) / n_"tot,gaz"
        = P_"tot" (n_0(ce("CH4 (g)")) - xi_1) / (n_0(ce("CH4 (g)")) + n_0(ce("H2O (g)")) + 2 xi_1)
    $
    $
        P(ce("H2O (g)")) = P_"tot" (n_0(ce("H2O (g)")) - xi_1 - xi_2) / (n_0(ce("CH4 (g)")) + n_0(ce("H2O (g)")) + 2 xi_1)
    $
    $
        P(ce("CO (g)")) = P_"tot" (xi_1 - xi_2) / (n_0(ce("CH4 (g)")) + n_0(ce("H2O (g)")) + 2 xi_1)
    $
    $
        P(ce("H2 (g)")) = P_"tot" (3 xi_1 + xi_2) / (n_0(ce("CH4 (g)")) + n_0(ce("H2O (g)")) + 2 xi_1)
    $
    $
        P(ce("CO2 (g)")) = P_"tot" (xi_2) / (n_0(ce("CH4 (g)")) + n_0(ce("H2O (g)")) + 2 xi_1)
    $
    En remplaçant :
    $
        Q_1 = (P_"tot" / P^circ)^2 ((xi_1 - xi_2) (3 xi_1 + xi_2)^3) / ((n_0(ce("CH4 (g)")) - xi_1) (n_0(ce("H2O (g)")) - xi_1 - xi_2) (n_0(ce("CH4 (g)")) + n_0(ce("H2O (g)")) + 2 xi_1)^2)
    $
    On procède de même pour la réaction (2) :
    $
        Q_2 = (xi_2 (3 xi_1 + xi_2)) / ((xi_1 - xi_2) (n_0(ce("H2O (g)")) - xi_1 - xi_2) )
    $
]

On souhaite obtenir la composition du système à l'équilibre lorsque la pression $P_"tot"$ est égale à $P^circ = #qty("1", "bar")$.

#question(
    coups-de-pouce: "Utiliser la loi de Guldberg et Waage pour les deux réactions.",
)[
    Montrer que $xi_1$ et $xi_2$ satisfont le système d'équations
    #set text(size: 10pt)
    $
        cases(
            (xi_1 - xi_2) (3 xi_1 + xi_2)^3 - K_1^circ (n_0(ce("CH4 (g)")) - xi_1) (n_0(ce("H2O (g)")) - xi_1 - xi_2) (n_0(ce("CH4 (g)")) + n_0(ce("H2O (g)")) + 2 xi_1)^2 = 0,
            xi_2 (3 xi_1 + xi_2) - K_2 (xi_1 - xi_2) (n_0(ce("H2O (g)")) - xi_1 - xi_2) = 0
        )
    $
][
    À l'équilibre, la loi de Guldberg et Waage s'écrit pour chaque réaction
    $
        cases(
            K_1^circ = Q_1,
            K_2^circ = Q_2,
        )
    $
    En remplaçant les expressions de $Q_1$ et $Q_2$, on obtient le système d'équations demandé.
]

#question[
    La fonction `root(f, x0)` de la bibliothèque `scipy.optimize` permet de trouver numériquement la racine d'une fonction `f` en partant d'une valeur initiale `x0`. La fonction `f` peut prendre une liste en argument et retourner une liste de valeurs.
    `root(f, x0)` renvoie un objet dont l'attribut `x` contient la valeur de la racine trouvée. Compléter le code Python permettant de déterminer la valeur de $x_1$ et $xi_2$. On prendra comme valeurs initiales $xi_1 = 0$ et $xi_2 = 0$.

    ```python
    from scipy.optimize import root
    K1 = 1.306
    K2 = 2.204
    n0_H2O = 4.0
    n0_CH4 = 1.0
    def f(x): # fonction qui doit être nulle à l'équilibre
        xi1, xi2 = x
        return [..., ...]
    xi1, xi2 = root(f, x0 = [0, 0]).x # cherche les solutions de l'équation f(x) = [0,0]
    ```
][
    ```python
    def f(x):
        xi_1, xi_2 = x
        return [
            (xi_1-xi_2) * (3 * xi_1 + xi_2)**3 - K1 * (n0_H2O - xi_1 - xi_2) * (n0_CH4 - xi_1) * (n0_H2O + n0_CH4 + 2 * xi_1),
            xi_2 * (3 * xi_1 + xi_2) - K2 * (xi_1 - xi_2) * (n0_H2O - xi_1 - xi_2)
        ]
    ```
]

#question[
    Calculer et afficher avec Python les quantités de matière de chaque espèce à l'équilibre et la pression totale $P_"tot"$.
][
    ```python
    nf_CH4 = n0_CH4 - xi1
    nf_H2O = n0_H2O - xi1 - xi2
    nf_CO = xi1 - xi2
    nf_H2 = 3 * xi1 + xi2
    nf_CO2 = xi2
    print("Quantités de matière à l'équilibre :")
    print(f"CH4 : {nf_CH4} mol")
    print(f"H2O : {nf_H2O} mol")
    print(f"CO : {nf_CO} mol")
    print(f"H2 : {nf_H2} mol")
    print(f"CO2 : {nf_CO2} mol")
    ```
]
