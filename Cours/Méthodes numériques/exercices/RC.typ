#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Circuit RC",
    numérique: true,
)

On cherche à modéliser la charge d'un condensateur dans un circuit RC série soumis à une tension continue $E$.

#figure(
    zap.circuit({
        import zap: *
        vsource("E", (0, 0), (0, 2), u: $E$)
        switch("K", (0, 2), (2, 2), label: $K$)
        resistor("R", (2, 2), (4, 2), label: $R$)
        capacitor("C", (4, 0), (4, 2), label: $C$, u: (content: $u$, anchor: "south"))
        wire((0, 0), (4, 0))
    }),
)

À $t=0$, l'interrupteur $K$ est fermé. Le condensateur est initialement déchargé.

#question(
    coups-de-pouce: "Écrire la loi des mailles. Comment tension et courant sont-ils liés pour le résistor et pour le condensateur ?"
)[
    Montrer que $u$ vérifie l'équation différentielle
    $
        dv(u, t) = -1/(R C) u + 1/(R C) E
    $
][
    La loi des mailles s'écrit $E = u_R + u$ avec $u_R = R i$ et $i = C dv(u, t)$. Donc
    $
        E = R C dv(u, t) + u
    $
]

#question(
    coups-de-pouce: (
        "L'énoncé précise que le condensateur est initialement déchargé.",
        "La tension aux bornes d'un condensateur est continue.",
    )
)[
    Que vaut $u(t=0^+)$ ?
][
    La tension aux bornes du condensateur est continue, de plus elle est nulle à $t=0^-$ (condensateur initialement déchargé). Donc $u(0^+) = 0$.
]

On souhaite résoudre numériquement cette équation différentielle à l'aide de la méthode d'Euler explicite. On note $u_i=u(i dot Delta t)$ la tension discrétisée.

#question(
    coups-de-pouce: "Utiliser la formule de Taylor à l'ordre 1 pour $u(t_i + Delta t)$."
)[
    Établir une relation de récurrence sur $u_i$.
][
    La relation de Taylor à l'ordre 1 donne
    $
        u_(i+1) = u(i dot Delta t + Delta t) = u(i dot Delta t) + Delta t dv(u, t) = u_i - Delta t (-1/(R C) u_i + 1/(R C) E)
    $
]

#question[
    Écrire une suite d'instructions permettant de calculer les valeurs successives de $u_i$. On prendra $R=qty("1", "kO")$, $C=qty("1", "uF")$, $E=qty("5", "V")$, $Delta t=qty("0.2", "ms")$ et on effectuera $25$ itérations.
][
    ```python
    R = 1e3
    C = 1e-6
    E = 5
    Delta_t = 0.2e-3

    N = 25
    u = [0]  # u(0) = 0 V

    for i in range(N):
        u.append(u[i] + Delta_t * (-1/(R * C) * u[i] + 1/(R * C) * E))
    ```
]

#question(
    coups-de-pouce: (
        "On peut utiliser la bibliothèque matplotlib.pyplot pour tracer des courbes en Python.",
        "La solution est de la forme $u(t) = A (1 - exp(-t/tau))$ où $A$ et $tau$ sont des constantes à déterminer.",
    )
)[
    Tracer l'évolution de $u$ en fonction du temps. Comparer avec la solution analytique que vous calculerez et tracerez également.
][
    La solution analytique est
    $
        u(t) = E (1 - exp(-t/(R C)))
    $

    ```python
    import numpy as np
    import matplotlib.pyplot as plt

    temps = [i * Delta_t for i in range(N + 1)]
    u_analytique = [E * (1 - np.exp(-t / (R * C))) for t in temps]

    plt.plot(temps, u, label='Numérique (Euler explicite)')
    plt.plot(temps, u_analytique, label='Analytique')
    plt.xlabel('Temps (s)')
    plt.ylabel('Tension u (V)')
    plt.legend()
    plt.show()
    ```
]

#question[
    Observer qualitativement l'effet de la valeur de $Delta t$ sur la précision de la solution numérique.
][
    Plus $Delta t$ est petit, plus la solution numérique est précise et proche de la solution analytique.
]