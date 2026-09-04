#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Redresseur triphasé",
    numérique: true,
    difficulté: 1,
)

On s'intéresse à un redresseur triphasé représenté ci-dessous.

#figure(
    zap.circuit({
        import zap: *

        node("ground", (-4, 0))
        vsource("V1", (-4, 0), (-4, 2.5), u: $u_1$)
        vsource("V2", (-4, 0), (rel: (-30deg, 2.5)), u: $u_2$)
        vsource("V3", (-4, 0), (rel: (-150deg, 2.5)), u: $u_3$)
        frame("g",(-4,0))


        diode("D1", (2, 0), (2, 2.5), label: $D_0$)
        diode("D2", (3.5, 0), (3.5, 2.5), label: $D_1$)
        diode("D3", (5, 0), (5, 2.5), label: $D_2$)
        diode("D4", (2, -2.5), (2, 0), label: $D_3$)
        diode("D5", (3.5, -2.5), (3.5, 0), label: $D_4$)
        diode("D6", (5, -2.5), (5, 0), label: $D_5$)
        wire((2, 2.5), (7, 2.5))
        wire((2, -2.5), (7, -2.5))

        isource("U", (7, -2.5), (7, 2.5), u: $v$)
        node("load+", (7, 2.5), label: $V_+$)
        node("load+", (7, -2.5), label: (content: $V_-$, anchor: "south"))

        node("n1", (2, 0.5))
        wire((2, 0.5), (0, 0.5), (0, 2.5), (-4, 2.5))
        node("n2", (3.5, 0))
        zwire((3.5, 0), (0, 0), (rel: (-30deg, 2.5), to: (-4, 0)))
        node("n3", (5, -0.5))
        swire((5, -0.5), (0, -2.5), (rel: (-150deg, 2.5), to: (-4, 0)))
    }),
)

#question(
    coups-de-pouce: (
        "Justifier que parmi les diodes $D_0$, $D_2$ et $D_3$, au moins une est passante.",
        "Quelles sont les caractéristiques des diodes bloquées ? Que peut-on dire de la tension à leurs bornes ?",
    )
)[
    Justifier que $V_+ = max(u_1, u_2, u_3)$.
][
    On s'intéresse au trois diodes $D_0$, $D_2$ et $D_3$. Au moins une de ces diodes est passante, sinon la source de courant est en circuit ouvert.

    Pour les diodes bloquées, la tension à leur bornes, en convention direct, est négative (d'après leur caractéristique), ce qui signifie que pour ces diodes bloquées, $V_+ >= u_...$. Pour la diode passante, $V_+ = u_...$. Ainsi, $V_+$ est égal à la tension maximale des trois tensions d'entrée.
]

On peut montrer de la même manière que $V_- = min(u_1, u_2, u_3)$.

En pratique, les tensions $u_1$, $u_2$ et $u_3$ sont des tensions sinusoïdales déphasées de $2 pi/3$ les unes par rapport aux autres, de valeur efficace $U$ :
$
u_1(t) &= sqrt(2) U sin(omega t)\
u_2(t) &= sqrt(2) U sin(omega t - 2pi/3)\
u_3(t) &= sqrt(2) U sin(omega t - 4pi/3)
$

#question(
    coups-de-pouce: ()
)[
    Définir une fonction Python `v(t)` qui calcule la tension de sortie $v(t)$ en fonction du temps $t$, de la pulsation $omega$ et de la valeur efficace $U$.
][
    La tension $v(t) = V_+ - V_-$ est donc la différence entre la tension maximale et la tension minimale parmi les trois tensions d'entrée.

    ```python
    from math import sqrt, sin, pi
    def v(t):
        u1 = sqrt(2) * U * sin(omega * t)
        u2 = sqrt(2) * U * sin(omega * t - 2 * pi / 3)
        u3 = sqrt(2) * U * sin(omega * t - 4 * pi / 3)
        V_plus = max(u1, u2, u3)
        V_moins = min(u1, u2, u3)
        return V_plus - V_moins
    ```
]

#question(
    coups-de-pouce: ()
)[
    Tracer avec Python la forme d'onde de la tension de sortie $v(t)$ sur une période pour $U = qty("230","V")$ et $f = qty("50","Hz")$.
][
    La pulsation est donnée par $omega = 2pi f$.

    On peut utiliser la bibliothèque `matplotlib` pour tracer la forme d'onde.

    ```python
    import numpy as np
    import matplotlib.pyplot as plt

    U = 230  # Valeur efficace en volts
    f = 50   # Fréquence en hertz
    omega = 2 * np.pi * f

    t = np.linspace(0, 1/f, 1000)  # Temps sur une période
    v_t = [v(ti) for ti in t]

    plt.plot(t, v_t)
    plt.title("Tension de sortie v(t) du redresseur triphasé")
    plt.xlabel("Temps (s)")
    plt.ylabel("Tension v(t) (V)")
    plt.grid()
    plt.show()
    ```
]

#question(
    coups-de-pouce: ()
)[
    Écrire une série d'instructions qui calculent la valeur efficace de la tension de sortie $v(t)$. On pourra utiliser la fonction `quad` de la bibliothèque `scipy.integrate` qui prend en argument une fonction et les deux bornes d'intégration et qui retourne un couple dont le premier élément est la valeur de l'intégrale définie.
][
    La valeur efficace $V_"eff"$ est donnée par :
    $
    V_"eff" = sqrt((1/T) integral_0^T v(t)^2 dd(t))
    $

    On peut utiliser des méthodes numériques pour effectuer ces intégrations.

    ```python
    from scipy.integrate import quad

    T = 1 / f  # Période

    def v_squared(t):
        return v(t)**2

    V_eff_squared, _ = quad(v_squared, 0, T)
    V_eff = sqrt(V_eff_squared / T)

    print("Valeur efficace : ", V_eff, " V")
    ```
]