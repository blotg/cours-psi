#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Tir cadré ?",
    difficulté: 1,
    numérique: true,
)

On étudie un tir au football. La vitesse initiale du ballon est de #qty("20", "m/s") selon l'axe $x$ (horizontal) et de #qty("12", "m/s") selon l'axe $z$ (vertical). Le ballon est sur le sol juste avant le tir.

Dans un premier temps, on ne prend en compte que la gravité.

#question(
    coups-de-pouce: (
        "Appliquer le théorème de la résultante cinétique au ballon."
    ),
)[
    Établir l'équation différentielle vérifiée par la vitesse $va(v)$ du ballon. Exprimer la dérivée de la vitesse.
][
    Le théorème de la résultante cinétique appliqué au ballon s'écrit
    $
        m dv(va(v), t) = m va(g)
    $
    soit
    $
        dv(va(v), t) = va(g)
    $
]

On résout numériquement l'équation différentielle en utilisant la fonction `solve_ivp` de la bibliothèque `scipy.integrate`.

#question(
    coups-de-pouce: (),
)[
    Compléter le code suivant.
    ```python
    from scipy.integrate import solve_ivp, trapezoid
    import numpy as np

    g = 9.81 # m/s^2
    rho = 1.2 # kg/m^3
    v0 = np.array([20, 0, 12]) # m/s

    def dv_dt(t, v):
        a = ... # accélération
        return a

    sol = solve_ivp(dv_dt, [0, 2], v0, max_step=0.01)

    t = sol.t
    vx = sol.y[0, :]
    vy = sol.y[1, :]
    vz = sol.y[2, :]
    ```
][
    ```python
    def dv_dt(t, v):
        a = - g * np.array([0,0,1])
        return a
    ```
]

Il est maintenant nécessaire de calculer la position du ballon en intégrant la vitesse en utilisant la méthode des rectangles.

#question(
    coups-de-pouce: (),
)[
    Compléter le code suivant. Attention, les temps calculés par la fonction `solve_ivp` ne sont pas forcément régulièrement espacés.
    ```python
    x = [0]
    y = [0]
    z = [0]

    for i in range(1, len(sol.t)):
        x.append(...)
        y.append(...)
        z.append(...)
    ```
][
    ```python
    for i in range(1, len(sol.t)):
        x.append(x[-1] + vx[i] * (t[i]-t[i-1]))
        y.append(y[-1] + vy[i] * (t[i]-t[i-1]))
        z.append(z[-1] + vz[i] * (t[i]-t[i-1]))
    ```
]

Pour vérifier si le tir est cadré, on trace la trajectoire du ballon grâce au code suivant.

```python
fig = plt.figure()
ax = fig.add_subplot(111, projection="3d")

ax.plot(x, y, z)

# Tracé des cages
x_cages = 14.5
y_cages = 0.3
l_cages = 7.32
h_cages = 2.44
ax.plot(
    [x_cages]*4,
    [y_cages, y_cages, y_cages + l_cages, y_cages + l_cages],
    [0, h_cages, h_cages, 0],
    color="orange")

# Mise en forme
ax.set_xlabel("x (m)")
ax.set_ylabel("y (m)")
ax.set_zlabel("z (m)")
ax.set_title("Trajectoire 3D")
ax.set_zlim(0, max(z)*1.1)

plt.tight_layout()
plt.show()
```

#question(
    coups-de-pouce: (
        "La trajectoire du ballon passe-t-elle par les cages ?"
    ),
)[
    Le tir est-il cadré ?
][
    Non, la trajectoire du ballon passe au-dessus des cages.
]

On prend maintenant en compte les frottements avec l'air. On donne les valeurs numériques suivantes :
$rho = #qty("1.2", "kg/m^3")$,
$C_x = #num("0.47")$,
$R = #qty("0.11", "m")$ et
$m = #qty("145", "g")$

#question(
    coups-de-pouce: (
        "Comment s'exprime la force de trainée ?"
    ),
)[
    Modifier la fonction `dv_dt` pour inclure la force de trainée.

    On pourra utiliser la fonction `np.linalg.norm(v)` pour calculer la norme du vecteur vitesse $v$.

    Le tir est-il maintenant cadré ?
][
    ```python
    rho = 1.2 # kg/m^3
    Cx = 0.47 # coefficient de trainée
    R = 0.11 # rayon m
    S = np.pi * R**2 # cross-sectional area
    m = 0.145 # masse kg

    def dv_dt(t, v):
        a = - g * np.array([0,0,1]) - 1/2 * rho * Cx * S / m * np.linalg.norm(v) * v
        return a
    ```
    Le tir n'est toujours pas cadré, il passe à coté des cages.
]

Le footballeur a mis de l'effet dans la balle en lui imprimant une rotation de $Omega = #qty("100", "tr/min")$ autour de l'axe $(O z)$. Cette rotation engendre une force de portance appelée force de Magnus et s'exprimant comme $1/2 C rho R^3 va(Omega) and va(v)$ avec $C approx #num(1)$.

#question(
    coups-de-pouce: (),
)[
    Modifier la fonction `dv_dt` pour inclure la force de Magnus.

    Le tir est-il maintenant cadré ?
][
    ```python
    Omega = np.array([0,0,100*2*np.pi/60])

    def dv_dt(t, v):
        a = - g * np.array([0,0,1]) - 1/2 * rho * Cx * S / m * np.linalg.norm(v) * v + 1/2 * rho * R**3 * np.cross(Omega,v) / m
        return a
    ```

    Oui, en prenant en compte toutes ces forces, le tir est cadré.
]