#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Stabilité d'un système non linéaire, bifurcation fourche",
    numérique: true,
    difficulté: 1,
)

On étudie un système régi par l'équation différentielle
$
    dv(y, t) - y (r-y^2) = 0
$

#question(
    coups-de-pouce: (
        "Que vaut $dv(y,t)$ si $y(t)$ est stationnaire (c'est-à-dire indépendant du temps) ? Quelle équation sur $y$ obtient-on alors ?"
    ),
)[
    Quelles sont les solutions stationnaires de ce système ? On distinguera les cas en fonction du paramètre $r$.
][
    $y = 0$ est toujours une solution stationnaire.

    Si $r > 0$, alors $y = plus.minus sqrt(r)$ est également une solution stationnaire.
]

On résout maintenant numériquement le système pour observer le comportement des solutions en fonction du paramètre $r$ et de la condition initiale $y_0$.

#question(
    coups-de-pouce: (
        "Pour mettre sous la forme d'un problème d'Euler, il suffit d'isoler $dv(y,t)$ d'un côté de l'équation."
    ),
)[
    Mettre le système sous la forme d'un problème d'Euler, c'est-à-dire sous la forme $dv(y, t) = f(t,y)$ où $f$ est une fonction à préciser puis compléter le code ci-dessous.
    ```python
    from scipy.integrate import solve_ivp
    def f(t,y):
        return ... # à compléter
    ```
][
    $
        dv(y, t) = y (r-y^2)
    $
    La fonction $f$ est donc définie par $f : (t,y) arrow.r.bar y (r-y^2)$. Ici la fonction ne dépend en pratique pas de $t$.
]

Pour se familiariser avec la résolution numérique, on commence par résoudre le système pour $r = 1$ et $y_0 = 0.1$.

#question(
    coups-de-pouce: (
        "La fonction `plt.plot()` prend deux arguments : la liste des abscisses puis celle des ordonnées à tracer."
    ),
)[
    Compléter le code ci-dessous pour.
    ```python
    r = ...  # à compléter
    y0 = ... # à compléter
    sol = solve_ivp(f, [0,100], [y0]) # la fonction solve_ivp résout le système sur l'intervalle
                                      # de temps [0,100] avec la condition initiale y0
    t = sol.t    # on récupère les valeurs de temps calculées par solve_ivp
    y = sol.y[0] # et les valeurs de y correspondantes
    import matplotlib.pyplot as plt
    plt.plot(...) # Tracé de y en fonction de t
    plt.xlabel("t")
    plt.ylabel("y(t)")
    plt.title("Résolution du système pour r=1 et y0=0.1")
    plt.show()
    ```
][
    ```python
    r = 1  # à compléter
    y0 = 0.1 # à compléter
    sol = solve_ivp(f, [0,100], [y0]) # la fonction solve_ivp résout le système sur l'intervalle
                                      # de temps [0,100] avec la condition initiale y0
    t = sol.t    # on récupère les valeurs de temps calculées par solve_ivp
    y = sol.y[0] # et les valeurs de y correspondantes
    import matplotlib.pyplot as plt
    plt.plot(t,y) # Tracé de y en fonction de t
    plt.xlabel("t")
    plt.ylabel("y(t)")
    plt.title("Résolution du système pour r=1 et y0=0.1")
    plt.show()
    ```
]

#question()[
    En changeant les paramètres $r$ et $y_0$ (on essaiera des valeurs positives et négatives), qu'observe-t-on sur les limites atteintes par $y$ ?
][
    / Pour $r<=0$: quelle que soit la valeur de $y_0$, la solution converge vers $0$.
    / Pour $r>0$: si $y_0$ est positif, la solution converge vers $sqrt(r)$, si $y_0$ est négatif, la solution converge vers $-sqrt(r)$. A part avec $y_0 = 0$, aucune solution ne converge vers $0$, qui semble donc être une solution instable.
]

On souhaite maintenant explorer de façon plus exhaustive l'influence de $r$ sur la limite atteinte par $y$. On prendra #num("1000") valeurs pour $r$ réparties entre $-1$ et $1$. Pour chaque valeur de $r$, on résout le système pour une conditions initiales $y_0$ tirée aléatoirement entre $-10$ et $10$.

#question(
    coups-de-pouce: (
        "Pour générer la liste des valeurs de $r$, on peut utiliser la fonction `np.linspace` ou utiliser une comprehension de liste par exemple.",
        "S'inspirer du code fourni dans la question précédente récupérer les valeurs de $y$. Comment récupérer seulement la dernière valeur ?",
    ),
)[
    Compléter le code ci-dessous pour.
    ```python
    L_r = ...     # liste contenant les valeurs de r à tester
    L_limite = [] # liste qui contiendra les limites atteintes par y pour chaque valeur de r

    for r in L_r:
        y0 = np.random.uniform(-10,10) # tire une valeur aléatoire entre -10 et 10 pour la condition initiale
        sol = solve_ivp(f, [0, 100], [y0])
        limite = ... # dernière valeur de y calculée par solve_ivp (on suppose que la limite est atteinte)
        L_limite.append(limite)
    ```
][
    ```python
    L_r = np.linspace(-1,1,1000)# liste contenant les valeurs de r à tester
    L_limite = []               # liste qui contiendra les limites atteintes par y pour chaque valeur de r

    for r in L_r:
        y0 = np.random.uniform(-10,10) # tire une valeur aléatoire entre -10 et 10 pour la condition initiale
        sol = solve_ivp(f, [0, 100], [y0])
        limite = sol.y[0][-1] # dernière valeur de y calculée par solve_ivp (on suppose que la limite est atteinte)
        L_limite.append(limite)
    ```
]

#question(
    coups-de-pouce: (
        "Pour obtenir un nuage de points non reliés entre eux, on peut utiliser le style de tracé `'.'`.",
    ),
)[
    Tracer les limites atteintes par $y$ en fonction de $r$. On affichera le trace sous forme d'un nuage de points non reliés entre eux. Justifier le nom de "bifurcation fourche" donné à ce type de diagramme.
][
    ```python
    plt.plot(L_r, L_limite, ".")
    plt.xlabel("r")
    plt.ylabel("limite atteinte par y")
    plt.grid()
    plt.show()
    ```
    #figure(
        image("images/fourche.svg", height: 8cm),
    )
    La forme de la courbe ressemble à une fourche.
]
