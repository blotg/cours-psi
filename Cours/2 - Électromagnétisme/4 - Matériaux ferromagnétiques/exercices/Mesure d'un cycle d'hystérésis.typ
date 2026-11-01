#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Mesure d'un cycle d'hystérésis",
    numérique: true,
)

On veut tracer le cycle d'hystérésis du fer d'un transformateur démontable. Son circuit magnétique, sans entrefer, a une section $S = #quan[9 cm^2]$ et une longueur moyenne $l = #quan[30 cm]$. On suppose le champ magnétique $B$ et l'excitation magnétique $H$ uniformes dans le fer.

- L'enroulement primaire, de $N_1 = 250$ spires, est alimenté par une tension sinusoïdale de fréquence $f = #quan[50 Hz]$. Une résistance $R = #quan[2.0 Ω]$ placée en série permet de suivre l'intensité $i_1$ du courant qui le parcourt : on mesure la tension $u_R = R i_1$ à ses bornes.
- L'enroulement secondaire, de $N_2 = 50$ spires, est ouvert : on mesure la tension $u_2$ à ses bornes.

#figure(circuit({
    import zap: *
    import cetz.draw: *
    // circuit magnétique
    rect((0, 0), (5, 4), fill: luma(85%), stroke: none)
    rect((1, 1), (4, 3), fill: white, stroke: none)
    content((1.2, 2), $N_1$, anchor: "west")
    content((3.8, 2), $N_2$, anchor: "east")
    // spires des deux enroulements
    for k in range(10) {
        let y = 1.1 + k * 0.2
        line((-0.15, y), (1.15, y + 0.1), stroke: 1pt)
        line((3.85, y), (5.15, y + 0.1), stroke: 1pt)
    }
    // primaire
    fil((-0.15, 2.9), (-1.6, 2.9), i: $i_1$)
    resistor("R", (-3.6, 2.9), (-1.6, 2.9), label: (content: $R$, anchor: "south"), u: $u_R$)
    acvsource("e", (-4.2, 1.1), (-4.2, 2.9))
    wire((-3.6, 2.9), (-4.2, 2.9))
    wire((-4.2, 1.1), (-0.15, 1.1))
    // secondaire, ouvert
    wire((5.15, 3), (6, 3))
    wire((5.15, 1.2), (6, 1.2))
    circle((6, 3), radius: 0.06, fill: white)
    circle((6, 1.2), radius: 0.06, fill: white)
    line((6.3, 1.3), (6.3, 2.9), mark: (end: ">", fill: black), name: "u2")
    content("u2", $u_2$, anchor: "west", padding: 0.1)
}))

Un oscilloscope numérique enregistre $u_R$ et $u_2$ pendant quatre périodes, à raison de $1000$ points par période. La fonction `acquisition` ci-dessous simule ces relevés : il suffit d'exécuter la cellule, et l'on fera comme si les tableaux `t`, `uR` et `u2` sortaient de l'oscilloscope.

```python
import numpy as np
import matplotlib.pyplot as plt

def acquisition():
    """Simule les relevés de l'oscilloscope : instants t (s), tensions uR et u2 (V)."""
    alea = np.random.default_rng(1)
    t = np.arange(4000) * 2e-5
    x = 2 * np.pi * 50 * t + 1
    y = 1.5 * np.sin(x)
    uR = 0.0024 * (110 * np.arctanh(y / 1.56) + 80 * np.sign(np.cos(x)) * (1 - (y / 1.5)**4))
    uR = uR + alea.normal(0, 2e-3, t.size)
    u2 = 21.2 * np.cos(x) + 0.1 + alea.normal(0, 2e-2, t.size)
    return t, uR, u2

t, uR, u2 = acquisition()

N1, N2 = 250, 50  # nombres de spires
S, l = 9e-4, 0.30  # section (m^2) et longueur moyenne (m) du circuit magnétique
R, f = 2.0, 50  # résistance (ohm) et fréquence (Hz)
```

#question(coups-de-pouce: (
    "Appliquer le théorème d'Ampère sur la ligne de champ moyenne.",
    "Quelle est l'intensité du courant dans l'enroulement secondaire ?",
))[
    Exprimer l'excitation magnétique $H$ dans le fer en fonction de $u_R$.
][
    Le théorème d'Ampère appliqué sur la ligne de champ moyenne, de longueur $l$, s'écrit $H l = N_1 i_1 + N_2 i_2$. Le secondaire étant ouvert, $i_2 = 0$, donc
    $ H = (N_1 i_1)/l = (N_1 u_R)/(R l) $
]

#question(coups-de-pouce: (
    "Exprimer le flux du champ magnétique à travers les $N_2$ spires du secondaire.",
    "Utiliser la loi de Faraday. Le secondaire étant ouvert, aucun courant n'y circule.",
))[
    Justifier qu'au signe près, qui dépend des orientations choisies, $u_2 = N_2 S dv(B, t)$. On choisit les orientations pour que le signe soit positif.
][
    Le flux du champ magnétique à travers les $N_2$ spires du secondaire est $Phi_2 = N_2 B S$. D'après la loi de Faraday, il apparait une force électromotrice $e_2 = -dv(Phi_2, t) = -N_2 S dv(B, t)$. Le secondaire étant ouvert, aucun courant n'y circule : la résistance du bobinage ne provoque aucune chute de tension et $u_2 = plus.minus e_2$.
]

#question(coups-de-pouce: (
    "La tension $u_2$ est proportionnelle à $dv(B, t)$ : comment évolue $B$ au cours du temps ?",
    "$H$ est-elle proportionnelle à $B$ ?",
))[
    Tracer $u_R$ et $u_2$ en fonction du temps. L'intensité $i_1$ du courant est-elle sinusoïdale ? Pourquoi ?
][
    ```python
    plt.figure("Relevés")
    plt.plot(t, uR, label="u_R")
    plt.plot(t, u2 / 20, label="u_2 / 20")
    plt.xlabel("t (s)")
    plt.ylabel("tension (V)")
    plt.legend()
    plt.show()
    ```

    La tension $u_2$ est sinusoïdale, donc le champ magnétique $B$, dont la dérivée lui est proportionnelle, l'est aussi : c'est la tension sinusoïdale imposée au primaire qui fixe $B(t)$. L'intensité $i_1$, proportionnelle à $H$, n'est pas sinusoïdale : $H$ se déduit de $B$ par le cycle d'hystérésis, qui n'est pas linéaire (hystérésis et début de saturation).
]

#question(coups-de-pouce: (
    "La méthode des trapèzes consiste à approcher l'intégrale entre $t_(k-1)$ et $t_k$ par $(t_k - t_(k-1)) (y_(k-1) + y_k)/2$.",
    "Chaque valeur de la primitive s'obtient en ajoutant à la précédente l'aire d'un trapèze.",
))[
    Écrire une fonction `primitive(t, y)` qui renvoie le tableau des valeurs, aux instants `t`, de la primitive de `y` nulle à l'instant `t[0]`, calculée par la méthode des trapèzes. En déduire un tableau `B` des valeurs du champ magnétique, et le tracer en fonction du temps.
][
    ```python
    def primitive(t, y):
        F = np.zeros(len(y))
        for k in range(1, len(y)):
            F[k] = F[k - 1] + (t[k] - t[k - 1]) * (y[k] + y[k - 1]) / 2
        return F

    B = primitive(t, u2) / (N2 * S)

    plt.figure("Champ magnétique")
    plt.plot(t, B)
    plt.xlabel("t (s)")
    plt.ylabel("B (T)")
    plt.show()
    ```
]

#question(coups-de-pouce: (
    "Que vaut la valeur moyenne, sur un nombre entier de périodes, de la dérivée d'une fonction périodique ? Calculer la valeur moyenne de `u2`.",
    "La fonction `primitive` fixe arbitrairement la valeur de $B$ à l'instant initial. Que vaut la valeur moyenne de $B$ pour un cycle symétrique ?",
))[
    Le champ magnétique obtenu n'est pas périodique, et sa valeur moyenne n'est pas nulle. Expliquer ces deux défauts, puis les corriger.
][
    La valeur moyenne de `u2` vaut environ #quan[0.1 V], alors que celle de $dv(B, t)$ est nulle sur un nombre entier de périodes : l'oscilloscope ajoute un décalage constant à la tension mesurée. Intégré, ce décalage donne une dérive linéaire de $B$, de l'ordre de #quan[0.2 T] sur les quatre périodes. Puisque l'enregistrement dure exactement quatre périodes, on corrige ce défaut en retranchant à `u2` sa valeur moyenne.

    La primitive est nulle à l'instant initial, alors que $B(t_0)$ n'a aucune raison de l'être : il manque une constante d'intégration. Le cycle étant symétrique, $B$ est de valeur moyenne nulle : on retranche à `B` sa valeur moyenne.

    ```python
    B = primitive(t, u2 - np.mean(u2)) / (N2 * S)
    B = B - np.mean(B)
    ```

    Le champ magnétique oscille alors entre #quan[-1.5 T] et #quan[1.5 T].
]

#question(coups-de-pouce: (
    "Le champ rémanent est la valeur de $B$ aux instants où $H$ s'annule : repérer les indices `k` tels que `H[k]` et `H[k+1]` sont de signes opposés.",
    "La fonction `np.nonzero(c)` renvoie (dans un tuple) les indices des éléments vrais du tableau de booléens `c`.",
))[
    Tracer le cycle d'hystérésis $B(H)$. Déterminer numériquement le champ magnétique rémanent $B_r$ et l'excitation coercitive $H_c$. Le matériau est-il doux ou dur ?
][
    ```python
    H = N1 * uR / (R * l)

    plt.figure("Cycle d'hystérésis")
    plt.plot(H, B)
    plt.xlabel("H (A/m)")
    plt.ylabel("B (T)")
    plt.grid()
    plt.show()

    k = np.nonzero(H[:-1] * H[1:] < 0)[0]  # H change de signe entre k et k+1
    Br = np.mean(np.abs(B[k]))
    k = np.nonzero(B[:-1] * B[1:] < 0)[0]  # B change de signe entre k et k+1
    Hc = np.mean(np.abs(H[k]))
    ```

    On trouve $B_r approx #quan[0.89 T]$ et $H_c approx #quan[79 A/m]$. L'excitation coercitive est très faible, quatre ordres de grandeur en dessous de celle d'un aimant permanent (de l'ordre de #quan[1e6 A/m]) : le matériau est doux, comme il se doit pour un transformateur.
]

#question(coups-de-pouce: (
    "L'aire du cycle est l'intégrale de $H dd(B)$ sur un cycle. Une période contient $1000$ points.",
    "Utiliser la relation entre l'aire du cycle et la puissance moyenne dissipée par hystérésis.",
))[
    Calculer l'aire $cal(A)$ du cycle par la méthode des trapèzes, sur une période. En déduire la puissance moyenne dissipée par hystérésis dans le fer, et la puissance dissipée par kilogramme de fer (masse volumique du fer : $rho = #quan[7.9e3 kg/m^3]$). Les tôles de transformateur dissipent quelques watts par kilogramme : le résultat est-il vraisemblable ?
][
    ```python
    n = 1000  # nombre de points sur une période
    A = np.sum((H[1:n + 1] + H[:n]) / 2 * (B[1:n + 1] - B[:n]))
    V = S * l
    P = V * f * A
    P_kg = P / (7.9e3 * V)
    ```

    On trouve $cal(A) approx #quan[3.8e2 J/m^3]$, soit une puissance moyenne $mean(cal(P)_"hystérésis") = V f cal(A) approx #quan[5 W]$ pour #quan[2.1 kg] de fer : environ #quan[2.4 W/kg], ce qui est bien l'ordre de grandeur attendu.
]
