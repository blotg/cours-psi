#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Récupérateur de chaleur sur eaux grises",
    numérique: true,
)

Les eaux usées issues d'une douche ou d'un bain contiennent une quantité importante de chaleur qui est généralement perdue dans les canalisations d'évacuation. Un récupérateur de chaleur sur eaux grises permet de récupérer une partie de cette chaleur pour préchauffer l'eau froide entrant dans le chauffe-eau, réduisant ainsi la consommation énergétique globale.

#grid(
    columns: (1fr, 2fr),
    align: horizon,
    figure(image("../images/canalisation echangeur eau.jpg", width: 100%)),
    figure(canvas({
        import cetz.draw: *
        rect((0.01, -0.15), (7.99, 1.65), fill: hachure(7pt), stroke: none)
        rect((0, 0), (8, 1.5), fill: white, stroke: none)
        line((0, 0), (8, 0))
        line((0, 1.5), (8, 1.5))
        line((0, 0.75), (8, 0.75))
        line((5.5, 0.75 / 2), (rel: (1, 0)), mark: (end: ">>", fill: black))
        line((6.5, 1.5 * 3 / 4), (rel: (+-1, 0)), mark: (end: ">>", fill: black))
        content((0, 0.75 / 2), $T_(p,e)$, anchor: "east", padding: .4em)
        content((0, 1.5 * 3 / 4), $T_(g,s)$, anchor: "east", padding: .4em)
        content((8, 0.75 / 2), $T_(p,s)$, anchor: "west", padding: .4em)
        content((8, 1.5 * 3 / 4), $T_(g,e)$, anchor: "west", padding: .4em)
        content((3, 0.75 / 2), [eau potable])
        content((3, 1.5 * 3 / 4), [eaux grises])
        line((-1, -1), (9, -1), mark: (end: ">>", fill: black))
        content((), $x$, anchor: "west", padding: .4em)
        line((0, -.9), (0, -1.1))
        content((), $0$, anchor: "north", padding: .4em)
        line((8, -.9), (8, -1.1))
        content((), $L$, anchor: "north", padding: .4em)
    })),
)

L'eau potable circule à contre-courant des eaux grises dans un échangeur thermique. On note $T_(p,e)$ et $T_(p,s)$ les températures d'entrée et de sortie de l'eau potable, et $T_(g,e)$ et $T_(g,s)$ celles des eaux grises. On suppose que les débits massiques sont constants et notés $D_p$ pour l'eau potable et $D_g$ pour les eaux grises. On note également $c$ la capacité thermique massique de l'eau.

L'échangeur est horizontal, son extérieur est calorifugé et on suppose l'eau incompressible.

La largeur de la conduite, dans sa dimension n'apparaissant pas sur le schéma, est notée $l$. Sa longueur est $L$. On note $e$ l'épaisseur des parois (constituée essentiellement de béton) de l'échangeur, et $lambda$ la conductivité thermique du matériau constituant l'échangeur.

#question(
    coups-de-pouce: (
        "Attention, pour les eaux grises, l'eau rentre en $x+dd(x)$ et sort en $x$.",
        "Utiliser le PPI dans sa version en puissance.",
    ),
)[
    En effectuant un bilan d'énergie sur une section élémentaire $dd(x)$ de l'échangeur, montrer que les températures $T_p(x)$ et $T_g(x)$ de l'eau potable et des eaux grises vérifient le système d'équations différentielles suivant :
    $
        cases(
            D_p c dv(T_p, x) = (delta P_x)/dd(x),
            D_g c dv(T_g, x) = (delta P_x)/dd(x),
        )
    $
    où $delta P_x$ est la puissance fournie par les eaux grises à l'eau potable sur la section $dd(x)$.
][
    On applique le PPI sur la section élémentaire $dd(x)$ pour chaque fluide. Pour l'eau potable, on a
    $
        D_p (h_p (x + dd(x)) - h_p (x)) = delta P_x\
        D_p c (T_p (x+dd(x)) - T_p (x)) = D_p c dv(T_p, x) dd(x) = delta P_x\
        D_p c dv(T_p, x) = (delta P_x)/dd(x)
    $
    de même, pour les eaux grises,
    $
        D_g (h_g (x) - h_g (x+dd(x))) = -delta P_x\
        D_g c dv(T_g, x) = (delta P_x)/dd(x)
    $
]

On souhaite exprimer $delta P_x$ en fonction des températures $T_p(x)$ et $T_g(x)$. À chaque interface solide/liquide, la loi de Newton donne lieu à une résistance thermique $1/(h dd(S))$.

#question(
    coups-de-pouce: (
        "Il y a deux interfaces solide/liquide, ce qui fera trois résistances thermiques en tout.",
        "Les résistances sont-elles en série ou en parallèle ?",
    ),
)[
    Exprimer la résistance thermique totale entre les deux fluides sur la section $dd(x)$ en fonction de $h$, $dd(S)$, de la conductivité thermique $lambda$ du matériau constituant l'échangeur et de son épaisseur $e$. En déduire l'expression de $delta P_x$ en fonction de $T_p(x)$, $T_g(x)$, $dd(S)$ et de $K = l/(2/h + e/lambda)$.
][
    La résistance thermique totale $R_"th"$ entre les deux fluides est la somme des résistances thermiques aux interfaces solide/liquide et de la résistance thermique à travers le matériau de l'échangeur (elles sont en série) :
    $
        R_"th" = 1/(h dd(S)) + e/(lambda dd(S)) + 1/(h dd(S)) = (2/h + e/lambda) / dd(S)
    $
    La puissance échangée $delta P_x$ est reliée à la différence de température entre les deux fluides par la relation
    $
        delta P_x = (T_g (x) - T_p (x)) / R_"th" = (T_g (x) - T_p (x)) (l dd(x)) / (2/h + e/lambda) = (T_g (x) - T_p (x)) K dd(x)
    $
]

#question()[
    Mettre le problème sous la forme d'un problème d'Euler portant sur $va(Y) = vec(T_g, T_p)$.
][
    En remplaçant $delta P_x$ dans le système d'équations différentielles, on obtient
    $
        cases(
            dv(T_p, x) = K / (D_p c) (T_g (x) - T_p (x)),
            dv(T_g, x) = K / (D_g c) (T_g (x) - T_p (x)),
        )
    $
    On a bien exprimé les dérivées de $T_p$ et $T_g$ en fonction de $T_p$ et $T_g$.
]

#question(
    coups-de-pouce: (
        "La conductivité du béton a été vue en cours.",
    ),
)[
    Compléter le code suivant.
    ```python
    h = 20 # W/m²/K
    l = 20e-2 # m
    L = 100 # m
    e = 5e-2 # m
    conductivité = ... # W/m/K
    K = l/(2/h + e/conductivité)
    Dg = 1e-2 # kg/s
    Dp = 1.2e-2 # kg/s
    c = 4180 # J/kg/K

    def dYdx(x,Y): # si Y = [Tg, Tp], la fonction retourne [dTg/dx, dTp/dx]
        ...
    ```
][
    ```python
    conductivité = 1 # W/m/K

    def dYdx(x,Y): # si Y = [Tg, Tp], la fonction retourne [dTg/dx, dTp/dx]
        Tg, Tp = Y
        return [K/(Dg*c)*(Tg - Tp), K/(Dp*c)*(Tg - Tp)]
    ```
]

#question()[
    On suppose que l'eau potable entre à #qty("10", "Celsius") et que les eaux grises entrent à #qty("25", "Celsius"). Compléter la fonction suivante qui doit renvoyer [0,0] lorsque les conditions aux limites sont satisfaites.
    ```python
    def conditionsLimites(Y0, YL): # Si Y0 = [Tg(0), Tp(0)] et YL = [Tg(L), Tp(L)], la fonction retourne
                                   # [0,0] si et seulement si les conditions aux limites sont vérifiées.
            ...
    ```
][
    ```python
    def conditionsLimites(Y0, YL):
        Tgs, Tpe = Y0
        Tge, Tps = YL
        return [Tpe - 10, Tge - 25]
    ```
]

Pour résoudre le problème, on utilise la fonction `solve_bvp` de la bibliothèque `scipy.integrate` :
```python
import numpy as np
from scipy.integrate import solve_bvp
x = np.linspace(0, L, 100) # points d'évaluation
solution = solve_bvp(dYdx, conditionsLimites, x, np.array([[25]*100, [10]*100])) # résolution numérique
# extraction des grandeurs recherchées
x = solution.x
Tg = solution.y[0]
Tp = solution.y[1]
```

#question()[
    Tracer les profils de température $T_p(x)$ et $T_g(x)$ le long de l'échangeur.
][
    On utilise le code suivant pour tracer les profils de température :
    ```python
    import matplotlib.pyplot as plt

    plt.plot(x, Tp, label="Température de l'eau potable $T_p(x)$")
    plt.plot(x, Tg, label="Température des eaux grises $T_g(x)$")
    plt.xlabel("Position le long de l'échangeur $x$ (m)")
    plt.ylabel("Température (°C)")
    plt.title("Profils de température dans l'échangeur de chaleur")
    plt.legend()
    plt.grid()
    plt.show()
    ```
]

#question(
    coups-de-pouce: "On peut appliquer le PPI sur la conduite d'eau potable en entier.",
)[
    Quelle énergie ce système permet-il d'économiser sur une journée de fonctionnement, par rapport à un système sans récupérateur de chaleur ? Cette énergie sera exprimée en #unit("J") puis en #unit("kW h")
][
    La puissance récupérée par l'eau potable est
    $
        P = D_p c (T_(p,s) - T_(p,e))
    $
    L'énergie économisée sur une journée ($Delta t = 24 times 3600 = #qty(str(24 * 3600), "s")$) est donc
    $
        E = P Delta t = D_p c (T_(p,s) - T_(p,e)) Delta t
    $
    En utilisant Python, on calcule cette énergie :
    ```python
    Delta_t = 24 * 3600 # s
    E = Dp * c * (Tp[-1] - Tp[0]) * Delta_t # J
    print(f"Énergie économisée sur une journée : {E} J = {E / 1000 / 3600} kW h")
    ```
]
