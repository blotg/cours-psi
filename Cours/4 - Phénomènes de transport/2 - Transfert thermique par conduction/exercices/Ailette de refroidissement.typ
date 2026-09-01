#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Ailette de refroidissement",
    difficulté: 1,
    numérique: true,
)

La performance des puces électroniques utilisées dans les ordinateurs décroit avec leur température. Afin de dissiper une puissance élevée en limitant la température du composant, on installe un dissipateur de chaleur. Ce dissipateur est muni d'ailettes de refroidissement. On étudie une de ces ailettes.

Une ailette de refroidissement en aluminium de conductivité thermique $lambda=qty("205", "W/m/K")$ est fixée en $x=0$ à un corps dont la température $T_0=qty("70", "Celsius")$ est constante est avec lequel le contact thermique est parfait. Elle baigne dans l'air ambiant de température $T_a=qty("20", "Celsius")$. L'ailette est en forme de parallélépipède, d'épaisseur $e=qty("1", "mm")$, de largeur $a=qty("5", "cm")$ et de longueur $l=qty("10", "cm")$.

On émet les hypothèses suivantes :
- le régime étudié est stationnaire
- la température d'un point de l'ailette n'est fonction que de $x$
- $a >> e$
- la puissance cédée à l'air extérieur par un élément de surface latérale $dd(S)$ (échanges conducto-convectifs) obéit à la loi de Newton : $delta P=h(T(x)-T_a)dd(S)$ avec $h=qty("10", "W/m^2/K")$.

#figure(
    canvas({
        import draw: *
        let x = 1
        let y = 6
        let z = 0.3
        let ya = 3
        let yb = 4
        projection-cabinet()
        line((x, 0, -z), (x, y, -z), (x, y, z), (x, 0, z), close: true)
        line((-x, 0, z), (-x, 0, -z), (-x, y, -z), stroke: (dash: "dashed"))
        line((-x, y, -z), (-x, y, z), (-x, 0, z))
        line((x, 0, z), (-x, 0, z))
        line((x, y, z), (-x, y, z))
        line((x, y, -z), (-x, y, -z))
        line((x, 0, -z), (-x, 0, -z), stroke: (dash: "dashed"))
        line((x, ya, -z), (x, ya, z), (-x, ya, z))
        line((-x, ya, z), (-x, ya, -z), (x, ya, -z), stroke: (dash: "dashed"))
        line((x, yb, -z), (x, yb, z), (-x, yb, z))
        line((-x, yb, z), (-x, yb, -z), (x, yb, -z), stroke: (dash: "dashed"))
        line((x, ya, -z), (x, yb, -z), (x, yb, z), (x, ya, z), fill: black.transparentize(50%))
        line((x, ya, z), (x, yb, z), (-x, yb, z), (-x, ya, z), fill: black.transparentize(50%))
        content((-x, (ya + yb) / 2, z), $dd(S)$, anchor: "south", padding: .4em)
        line((0, y + 1, -z), (rel: (-1, 0, 0)), mark: (end: ">>", fill: black))
        content((), $ey$, anchor: "south-west")
        line((0, y + 1, -z), (rel: (0, 1, 0)), mark: (end: ">>", fill: black))
        content((), $ex$, anchor: "west", padding: .2em)
        line((0, y + 1, -z), (rel: (0, 0, 1)), mark: (end: ">>", fill: black))
        content((), $ez$, anchor: "south", padding: .2em)
        line((x, 0, -z - 0.5), (x, y + 1, -z - 0.5), mark: (end: ">>", fill: black))
        content((), $x$, anchor: "west", padding: .2em)
        line((x, 0, -z - 0.4), (rel: (0, 0, -0.2)), anchor: "below")
        content((), $0$, anchor: "north", padding: .2em)
        line((x, ya, -z - 0.4), (rel: (0, 0, -0.2)), anchor: "below")
        content((), $x$, anchor: "north", padding: .2em)
        line((x, yb, -z - 0.4), (rel: (0, 0, -0.2)), anchor: "below")
        content((), $x+dd(x)$, anchor: "north", padding: .2em)
        line((x, y, -z - 0.4), (rel: (0, 0, -0.2)), content: $x=0$, anchor: "below")
        content((), $l$, anchor: "north", padding: .2em)
        line((x, -0.3, -z), (x, -0.3, z), mark: (symbol: ">>", fill: black), name: "e")
        content("e.mid", $e$, anchor: "east", padding: .5em)
        line((-x, -0.3, z), (x, -0.3, z), mark: (symbol: ">>", fill: black), name: "e")
        content("e.mid", $a$, anchor: "south-east", padding: .2em)
    }),
)

#question(
    coups-de-pouce: (
        "Faire un bilan d'énergie sur une tranche de longueur infinitésimale. Quels sont les 3 flux thermiques entrant dans cette tranche ?",
        "Dans une tranche infinitésimale d'ailette, de la puissance rentre par conduction en $x$ et en $x+dd(x)$ et par conducto-convection sur les 4 parois latérales.",
    ),
)[
    Montrer que l'équation différentielle vérifiée par $T(x)$ peut se mettre sous la forme $pdv(T, x, 2)-(T(x)-T_a)/L^2=0$ où on exprimera $L$ en fonction de $lambda$, $h$ et $e$. Calculer la valeur numérique de $L$.
][
    On applique le premier principe de la thermodynamique à une tranche d'ailette de longueur $dd(x)$ :
    $
        0 & = delta^2 Q = j_Q(x) e a dd(t) - j_Q(x+dd(x)) e a dd(t) - delta P dd(t) \
          & = -pdv(j_Q, x) e a dd(x) dd(t) - h (T(x)-T_a) 2 (e + a) dd(x) dd(t) \
          & = lambda pdv(T, x, 2) e a dd(x) dd(t) - h (T(x)-T_a) 2 (e + a) dd(x) dd(t)
    $
    d'où
    $
        pdv(T, x, 2) - (T(x)-T_a) (2 (e + a) h) / (lambda e a) = 0
    $
    qu'on peut écrire sous la forme demandée en posant
    $ L = sqrt((lambda e a) / (2 (e + a) h)) approx sqrt((lambda e a) / (2 a h)) = sqrt((lambda e)/(2h)) $
]

#question(
    coups-de-pouce: (
        "Écrire la continuité du flux thermique en $x=l$.",
    ),
)[
    Justifier les deux conditions aux limites suivantes : $T(0)=T_0$ et $-lambda pdv(T, x)(x=l) = h(T(l)-T_a)$.
][
    Le contact thermique étant parfait en $x=0$, la température de l'ailette est égale à celle du corps : $T(0)=T_0$.

    En $x=l$, le flux thermique par conduction dans l'ailette est égal au flux thermique cédé à l'air par conducto-convection :
    $
        j_Q (x=l) = h (T(l)-T_a)\
        -lambda pdv(T, x)(x=l) = h (T(l)-T_a)
    $
]

Pour résoudre l'équation différentielle numériquement, on cherche à la mettre sous la forme d'un problème d'Euler $dv(va(Y), x) = va(F)(x,va(Y))$ où $va(Y) = vec(T, dv(T, x))$.

#question(
    coups-de-pouce: (
        "Résoudre l'équation différentielle et utiliser les conditions aux limites pour trouver les constantes.",
    ),
)[
    Expliciter la fonction $va(F)$.
][
    L'équation différentielle s'écrit sous la forme :
    $ dv(T, x, 2) = (T - T_a)/L^2 $
    On a donc
    $
        dv(va(Y), x) = dv(, x) vec(T, dv(T, x)) = vec(dv(T, x), dv(T, x, 2)) = vec(dv(T, x), (T - T_a)/L^2)
    $
    La fonction $va(F)$ est donc :
    $va(F) : (x, vec(u, v)) arrow.bar vec(v, (u - T_a)/L^2)$
]

#question(
    coups-de-pouce: (),
)[
    Compléter le code Python ci-dessous pour définir la fonction $va(F)$.
    ```python
    from scipy.integrate import solve_bvp, trapezoid
    import numpy as np
    import matplotlib.pyplot as plt

    N = 100
    lam = 200
    e = 1e-3
    h = 10
    a = 5e-2
    l = 10e-2
    Ta = 20
    T0 = 70
    L = np.sqrt( lam*e / (h*2) )

    def F(x, Y):
        return np.array( [..., ...] )
    ```
][
    ```python
    def F(x, Y):
        return np.array( [Y[1], (Y[0]-Ta)/L**2] )
    ```
]

Pour résoudre le problème aux limites, on utilise la fonction `solve_bvp` de la bibliothèque `scipy.integrate`. Cette fonction a besoin des conditions aux limites sous la forme d'une fonction `bc` (pour #underline("b")oundary #underline("c")onditions).

Cette fonction `bc(Y0, Yl)` prend en argument les valeurs de la solution aux deux extrémités du domaine (en $x=0$ et $x=l$) et doit retourner un tableau contenant les écarts par rapport aux conditions aux limites (lorsque les conditions aux limites sont satisfaites, `bc` doit retourner un tableau de zéros).

#question(
    coups-de-pouce: (),
)[
    Compléter le code Python ci-dessous pour définir la fonction `bc`.
    ```python
    def bc(Y0, Yl):
        return np.array( [..., ...] )
    ```
][
    ```python
    def bc(Y0, Yl):
        return np.array( [Y0[0]-T0, -lam*Yl[1]-h*(Yl[0]-Ta)] )
    ```
]

On peut maintenant résoudre le problème aux limites en utilisant la fonction `solve_bvp`.

#question(
    coups-de-pouce: (),
)[
    Compléter le code Python ci-dessous pour résoudre le problème aux limites.
    ```python
    x = ... # array numpy de N points régulièrement espacés entre 0 et l
    Y = ... # array numpy de 2 lignes et N colonnes, initialisée à une valeur constante (par exemple T0)

    res = solve_bvp(F, bc, x, Y) # résolution numérique du problème
    x = res.x # abscisses des points de la solution
    T = res.y[0] # températures aux points de la solution
    ```
][
    ```python
    x = np.linspace(0, l, N)
    Y = np.zeros((2, N)) + T0
    ```
]

#question(
    coups-de-pouce: (),
)[
    Tracer la température $T(x)$ le long de l'ailette.
][
    ```python
    plt.plot(x, T)
    plt.xlabel("x (m)")
    plt.ylabel("T (Celsius)")
    plt.title("Température le long de l'ailette")
    plt.grid()
    plt.show()
    ```
]

#question(
    coups-de-pouce: (),
)[
    Justifier que la puissance totale dissipée par l'ailette est donnée par
    $ P approx integral_(x=0)^L 2 a h(T(x)-T_a) dd(x) $
    Compléter le code Python ci-dessous pour calculer cette puissance. On utilisera la fonction `trapezoid` de la bibliothèque `scipy.integrate` pour effectuer l'intégration numérique. Cette fonction prend en argument un tableau de valeurs de la fonction à intégrer et un tableau des abscisses correspondantes.
    ```python
    P = trapezoid(..., x) # calcul de la puissance dissipée
    print(P)
    ```
][
    La puissance dissipée sur les surfaces avant et arrière (d'aire $l e$) sont négligeables devant celles dissipées sur les surfaces haute et basse (d'aire $l a$) car $a >> e$. Idem pour la surface de droite (d'aire $a e$).

    La puissance dissipée par l'ailette est donc donnée par
    $
        P approx integral_(x=0)^l delta P = integral_(x=0)^l 2 a h (T(x)-T_a) dd(x)
    $
    ```python
    P = trapezoid( 2*a*h*(T-Ta), x ) # calcul de la puissance dissipée
    ```
]

#question(
    coups-de-pouce: ()
)[
    On aurait pu aussi calculer la puissance dissipée par l'ailette en calculant
    $ P = -lambda a e dv(T,x)(x=0) $
    Expliquer pourquoi, puis compléter le code Python ci-dessous pour calculer cette puissance et vérifier qu'on retrouve le même résultat.
    ```python
    dT = ... # On récupère la dérivée de T en x=0 à partir de la solution numérique
    P2 = ... # calcul de la puissance dissipée
    print(P2)
    ```
][
    L'ailette étant en régime stationnaire, la puissance qui entre par conduction en $x=0$ est égale à la puissance dissipée par l'ailette.

    ```python
    dT = res.y[1] # On récupère la dérivée de T en x=0 à partir de la solution numérique
    P2 = -lam * a * e * dT[0] # calcul de la puissance dissipée
    ```
]
