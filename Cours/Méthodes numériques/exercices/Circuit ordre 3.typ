#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Circuit électrique d'ordre 3",
    numérique: true,
    capytale: "afd4-11678457",
)

On s'intéresse au circuit électrique d'ordre 3 représenté ci-dessous.

#figure(
    circuit({
        import zap: *
        vsource("E", (0, 0), (0, 2), u: $E$)
        capacitor("C1", (0, 2), (2, 2), label: $C$)
        capacitor("C2", (2, 2), (4, 2), label: $C$)
        resistor("R", (4, 0), (4, 2), u: (content: $u$, anchor: "south"), label: $R$)
        inductor("L", (2, 0), (2, 2), variant: "ieee", label: $L$)
        wire((0, 0), (4, 0))
    }),
)

Les valeurs des composants sont $R=#qty("10","ohm")$, $L=#qty("1e-3","H")$ et $C=#qty("1e-6","F")$. La source de tension fournit une tension constante $E=#qty("10","V")$.

L'évolution de $u$ est régie par l'équation différentielle
$
    R L C^2 dv(u, t, 3) + 2 L C dv(u, t, 2) + R C dv(u, t) + u(t) = 0
$

On suppose que les conditions initiales sont $u(t=0) = 0$, $lr(dv(u,t)|)_(t=0) = #qty("3","V/s")$ et $lr(dv(u,t,2)|)_(t=0) = 0$. L'objectif de cet exercice est de déterminer l'évolution de $u(t)$ au cours du temps.

#question[
    On note $v(t)=dv(u, t)$ et $w(t)=dv(u, t, 2)$. Mettre le problème sous la forme d'un problème d'Euler en exprimant $dv(u, t)$, $dv(v, t)$ et $dv(w, t)$ en fonction de $u(t)$, $v(t)$ et $w(t)$.
][
    $
        cases(
            dv(u, t) = v,
            dv(v, t) = dv(u, t, 2) = w,
            dv(w, t) = dv(u, t, 3) = (-2 L C w(t) - R C v(t) - u(t)) / (R L C^2)
        )
    $
]

#question[
    On note  `Y np.array([u, v, w])`. Définir une fonction `dY_dt(Y,t)` qui retourne le tableau $dv(Y, t)$ en prenant comme entrée le temps $t$ et le tableau $Y$.
][
    ```python
    def dY_dt(Y, t):
        u, v, w = Y
        du_dt = v
        dv_dt = w
        dw_dt = (-2 * L * C * w - R * C * v - u) / (R * L * C**2)
        return np.array([du_dt, dv_dt, dw_dt])
    ```
]

#question[
    Écrire une suite d'instructions permettant de calculer l'évolution de $Y(t)$ entre $t=0$ et $t=#qty("1","ms")$ avec un pas de temps $Delta t=#qty("1","us")$ en utilisant la méthode d'Euler explicite.
][
    ```python
    # Définir les constantes
    R = 10  # ohm
    L = 1e-3  # H
    C = 1e-6  # F
    E = 10  # V

    # Conditions initiales
    u0 = 0  # V
    v0 = 3  # V/s
    w0 = 0  # V/s²
    Y0 = np.array([u0, v0, w0])

    # Paramètres de temps
    t_final = 1e-3  # s
    dt = 1e-6  # s

    # Listes pour stocker les résultats
    temps = [0]
    Y = [Y0]

    while temps[-1] < t_final:
        Y.append(Y[-1] + dY_dt(Y[-1], temps[-1]) * dt)
        temps.append(temps[-1] + dt)
    ```
]

#question[
    Tracer l'évolution de $u(t)$ au cours du temps.
][
    ```python
    import matplotlib.pyplot as plt

    u = [y[0] for y in Y]

    plt.plot(temps, u)
    plt.xlabel('Temps (s)')
    plt.ylabel('Tension u(t) (V)')
    plt.title('Évolution de la tension u(t) au cours du temps')
    plt.grid()
    plt.show()
    ```
]

La fonction `odeint(func, y0, t)`#footnote[Documentation complète disponible à l'adresse #link("https://docs.scipy.org/doc/scipy/reference/generated/scipy.integrate.odeint.html")] de la bibliothèque `scipy.integrate` permet de résoudre des problèmes d'Euler en appliquant des méthodes plus sophistiquées mais reposant sur le même principe. Elle prend en entrée
    - `func`: une fonction qui retourne la dérivée de l'état en fonction de l'état et du temps,
    - `y0`: l'état initial,
    - `t`: un tableau des instants où l'on souhaite connaître la solution.

#question[
    Reprendre la question 3 en utilisant la fonction `odeint` pour calculer l'évolution de $Y(t)$.
][
    ```python
    from scipy.integrate import odeint

    # Paramètres de temps
    t_final = 1e-3  # s
    dt = 1e-6  # s
    t = np.arange(0, t_final, dt)

    # Calcul de l'évolution de Y(t) avec odeint
    Y = odeint(dY_dt, Y0, t)
    ```
]
