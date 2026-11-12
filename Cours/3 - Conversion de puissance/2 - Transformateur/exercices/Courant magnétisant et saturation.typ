#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Courant magnétisant et saturation d'un transformateur",
    numérique: true,
    difficulté: 1,
)

On étudie un transformateur torique #quan[230 V] / #quan[12 V] de #quan[100 V A], du type de ceux qui alimentent un éclairage basse tension. Son circuit magnétique est un tore de section $S = #quan[6 cm^2]$ et de longueur moyenne $l = #quan[20 cm]$ constitué d'acier au silicium, sur lequel sont enroulées $N_1 = 1000$ spires au primaire et $N_2 = 52$ spires au secondaire. Le primaire est branché sur le réseau : $v_1(t) = V_1 sqrt(2) cos(omega t)$, avec $V_1 = #quan[230 V]$ et $f = #quan[50 Hz]$. Le secondaire alimente une résistance $R$.

#figure[
    #circuit({
        import zap: *
        import cetz.draw: *

        transformateur("transfo", (0, 0))
        vsource("e", (-3, -1), (-3, 1), u: $v_1$)
        fil("e.out", "transfo.P+", i: $i_1$)
        wire("e.in", "transfo.P-")
        resistor("R", (3, 1), (3, -1), label: $R$)
        fil("R.in", "transfo.S+", i: $i_2$)
        wire("transfo.S-", "R.out")
        line((1.5, -.9), (1.5, 0.9), mark: (end: ">", fill: black), name: "v2", stroke: 0.6pt)
        content("v2.mid", $v_2$, anchor: "west", padding: 0.1)
    })
]

On garde toutes les hypothèses du transformateur idéal sauf une : la perméabilité du matériau ferromagnétique est finie. Les enroulements n'ont donc pas de résistance, il n'y a ni hystérésis ni courants de Foucault, les lignes de champ sont parfaitement canalisées et le champ magnétique $B$ est uniforme dans le tore. On note $H$ l'excitation magnétique dans le tore. Les courants $i_1$ et $i_2$ entrent tous deux par les bornes homologues.

On utilisera le début de programme suivant.

```python
import numpy as np
import matplotlib.pyplot as plt

mu0 = 4e-7 * np.pi       # perméabilité du vide (H/m)
f = 50                   # fréquence (Hz)
omega = 2 * np.pi * f    # pulsation (rad/s)
N1, N2 = 1000, 52        # nombres de spires
S = 6e-4                 # section du tore (m²)
l = 0.20                 # longueur moyenne du tore (m)
mu_r = 5000              # perméabilité relative
V1eff = 230              # tension efficace au primaire (V)

t = np.arange(0, 2 / f, 1e-5)   # deux périodes
```

#let V1 = 230
#let N1 = 1000
#let Surf = 6e-4
#let omega = 2 * calc.pi * 50
#let mur = 5000
#let mu0 = 4 * calc.pi * 1e-7
#let long = 0.20

#question(coups-de-pouce: (
    "Appliquer la loi de Faraday à chacun des enroulements : le flux à travers un enroulement de $N$ spires est $N B S$.",
    "La valeur moyenne de $B$ est nulle en régime permanent.",
))[
    Exprimer $v_1$ et $v_2$ en fonction de $dv(B, t)$. En déduire $B(t)$ et son amplitude $B_"max"$, que l'on calculera. La loi de transformation des tensions est-elle toujours vérifiée ?
][
    D'après la loi de Faraday, $v_1 = N_1 S dv(B, t)$ et $v_2 = N_2 S dv(B, t)$. La tension imposée par le réseau impose donc le champ magnétique, quel que soit le matériau :
    $ B(t) = B_"max" sin(omega t) quad "avec" quad B_"max" = (V_1 sqrt(2))/(N_1 S omega) $

    ```python
    m = N2 / N1
    Bmax = np.sqrt(2) * V1eff / (N1 * S * omega)
    print(Bmax)
    ```
    On trouve $B_"max" approx #qty(calc.sqrt(2) * V1 / (N1 * Surf * omega), "T", chiffres: 3)$. Le rapport $v_2 / v_1 = N_2 / N_1 = m$ ne dépend pas de la perméabilité : la loi de transformation des tensions reste vérifiée, elle ne repose que sur la canalisation des lignes de champ.
]

#question(coups-de-pouce: (
    "Appliquer le théorème d'Ampère sur une ligne de champ moyenne du tore.",
    "Dans un matériau linéaire, $B = mu_0 mu_r H$.",
))[
    Montrer que $H l = N_1 i_1 + N_2 i_2$.

    Dans cette question et la suivante, la résistance est débranchée : le transformateur fonctionne _à vide_. Le matériau est supposé linéaire, de perméabilité relative $mu_r = 5000$. Exprimer le courant $i_1$, appelé courant magnétisant. Calculer et tracer $v_1(t)$ et $i_1(t)$. Quelle est l'amplitude du courant à vide ?
][
    Le théorème d'Ampère sur une ligne de champ moyenne, orientée dans le sens imposé par les bornes homologues, donne $H l = N_1 i_1 + N_2 i_2$. À vide, $i_2 = 0$, d'où
    $ i_1 = (H l)/N_1 = (B l)/(mu_0 mu_r N_1) $

    ```python
    v1 = np.sqrt(2) * V1eff * np.cos(omega * t)
    B = Bmax * np.sin(omega * t)
    H = B / (mu0 * mu_r)
    i1 = H * l / N1

    plt.figure("Tension")
    plt.xlabel("t (s)")
    plt.ylabel("v1 (V)")
    plt.plot(t, v1)

    plt.figure("Courant")
    plt.plot(t, i1, "r")
    plt.xlabel("t (s)")
    plt.ylabel("i1 (A)")
    plt.show()
    print(np.max(i1))
    ```

    Le courant à vide est sinusoïdal, d'amplitude #quan[55 mA] environ (#quan[39 mA] efficaces), et en retard de $pi / 2$ sur la tension : à vide, le transformateur se comporte comme une bobine d'inductance $L = mu_0 mu_r N_1^2 S / l approx #qty(mu0 * mur * N1 * N1 * Surf / long, "H", chiffres: 2)$.
]

#question(coups-de-pouce: (
    "La puissance moyenne est la moyenne de $p_1(t) = v_1(t) i_1$(t) sur une période.",
))[
    Calculer la puissance moyenne reçue par le primaire à vide. Justifier le résultat. L'énergie électromagnétique stockée dans le transformateur est-elle nulle ?

    #cheatsheet-python("np.mean")
][
    ```python
    print(np.mean(v1 * i1))
    ```

    La puissance moyenne est nulle (aux erreurs d'arrondi près) : la tension et le courant sont en quadrature, $P_1 = V_1 I_1 cos(pi / 2) = 0$. Le transformateur ne consomme rien à vide, ce qui est normal puisqu'on a négligé toutes les pertes.

    En revanche, la puissance instantanée $p_1(t)$ n'est pas nulle : pendant un quart de période, le transformateur reçoit de l'énergie, qu'il stocke sous forme d'énergie magnétique dans le tore, puis il la rend au réseau le quart de période suivant. Avec une perméabilité infinie, $H$ serait nul, ainsi que la densité d'énergie magnétique $B H / 2$ : c'est l'hypothèse de perméabilité infinie qui garantit l'absence de stockage d'énergie dans le transformateur idéal.
]

#question(coups-de-pouce: (
    "Avec l'orientation choisie, la résistance est en convention générateur pour $i_2$.",
    "Exprimer $i_1$ à partir du théorème d'Ampère.",
))[
    On branche au secondaire une résistance $R = #quan[1.5 Ω]$. Exprimer $i_2$ puis $i_1$. Tracer $v_1$ et $v_2$ sur un premier graphique, $i_1$ et $i_2$ sur un second. Calculer les puissances moyennes reçue par le primaire et fournie à la résistance. Commenter.
][
    $v_2 = m v_1$ et la résistance est en convention générateur, donc $i_2 = -v_2 / R$. Le champ magnétique n'a pas changé, puisqu'il est imposé par $v_1$, et le théorème d'Ampère donne
    $ i_1 = (H l)/N_1 - m i_2 = (B l)/(mu_0 mu_r N_1) + (m^2 v_1)/R $

    ```python
    R = 1.5
    v2 = m * v1
    i2 = -v2 / R
    i1 = (H * l - N2 * i2) / N1

    plt.figure("Tensions")
    plt.clf()
    plt.plot(t, v1, label="v1")
    plt.plot(t, v2, label="v2")
    plt.ylabel("tension (V)")
    plt.legend()

    plt.figure("Courants")
    plt.clf()
    plt.plot(t, i1, label="i1")
    plt.plot(t, i2, label="i2")
    plt.xlabel("t (s)")
    plt.ylabel("courant (A)")
    plt.legend()
    plt.show()

    print(np.mean(v1 * i1), np.mean(-v2 * i2))
    ```

    Les deux puissances valent #quan[95 W] : toute la puissance reçue par le primaire est fournie à la résistance. Le courant magnétisant ne change rien au bilan, puisqu'il ne transporte aucune puissance en moyenne.
]

#question(coups-de-pouce: (
    "Tracer $i_1$ et $-m i_2$ sur le même graphique.",
    "Comparer l'amplitude de $i_1 + m i_2$ à celle de $i_1$.",
))[
    La loi de transformation des courants est-elle vérifiée ? À quelle condition le serait-elle ?
][
    ```python
    plt.figure()
    plt.plot(t, i1, label="i1")
    plt.plot(t, -m * i2, label="-m i2")
    plt.legend()
    plt.show()
    print(np.max(np.abs(i1 + m * i2)), np.max(np.abs(i1)))
    ```

    Les deux courbes sont presque superposées : $i_1 = -m i_2 + i_"vide"$, où le courant magnétisant $i_"vide"$, d'amplitude #quan[55 mA], est petit devant le courant ramené du secondaire, d'amplitude #quan[0.59 A]. La loi de transformation des courants est donc vérifiée à 10 % près ; elle le serait exactement si le courant magnétisant était nul, c'est-à-dire pour une perméabilité infinie. Elle est d'autant mieux vérifiée que le courant au secondaire est important.
]

Le matériau n'est en réalité linéaire que tant que son aimantation n'atteint pas l'aimantation à saturation $M_"sat" = #quan[1.6e6 A/m]$. On modélise l'aimantation par une fonction linéaire $M = chi H$ hors saturation (où $chi = mu_r - 1$ est la susceptibilité magnétique du matériau) et $M = plus.minus M_"sat"$ en saturation.

#question(coups-de-pouce: (
    "Utiliser la définition de l'excitation magnétique : $H = B slash mu_0 - M$.",
))[
    Écrire les fonctions `M(H)` et `B(H)` qui renvoient l'aimantation et le champ magnétique pour une excitation `H` donnée. Tracer $M(H)$ et $B(H)$ pour $H$ compris entre #quan[-2000 A/m] et #quan[2000 A/m]. À partir de quelle valeur de $B$ le matériau est-il saturé ?
][
    ```python
    chi = mu_r - 1
    Msat = 1.6e6

    def M(H):
        if abs(chi * H) < Msat:
            return chi * H
        elif chi * H >= Msat:
            return Msat
        else:
            return -Msat

    def B(H):
        return mu0 * (H + M(H))

    H_tab = np.linspace(-2000, 2000, 1001)
    M_tab = [M(H) for H in H_tab]
    B_tab = [B(H) for H in H_tab]
    plt.figure("Cycle d'hystérésis M(H)")
    plt.clf()
    plt.plot(H_tab, M_tab)
    plt.xlabel("H (A/m)")
    plt.ylabel("M (A/m)")

    plt.figure("Cycle d'hystérésis B(H)")
    plt.clf()
    plt.plot(H_tab, B_tab)
    plt.xlabel("H (A/m)")
    plt.ylabel("B (T)")
    plt.show()
    print(B(Msat / chi))
    ```

    Le matériau sature pour $H = M_"sat" / chi approx #quan[320 A/m]$, soit $B_"sat" = mu_0 (M_"sat" / chi + M_"sat") approx #quan[2.01 T]$. Au-delà, $B = mu_0 (H + M_"sat")$ ne croît plus qu'avec la pente $mu_0$, #num(5000) fois plus faible : augmenter $B$ demande une excitation, donc un courant, énorme.
]

#question()[
    Exprimer l'excitation en fonction du champ magnétique. Définir une fonction `H(B)` qui renvoie l'excitation correspondant au champ magnétique `B`.
][
    La frontière entre la zone linéaire et la zone de saturation est pour $H_"lim" = M_"sat" / chi$, soit $B_"lim" = mu_0 (M_"sat" / chi + M_"sat")$.

    On a $H = B/mu_0 - M$ avec $M = chi H$ hors saturation et $M = plus.minus M_"sat"$ en saturation, soit
    $
    H = cases(
        B / (mu_0 (1 + chi)) " si " -B_"lim" <= B <= B_"lim",
        B / mu_0 - M_"sat" " si " B >= B_"lim",
        B / mu_0 + M_"sat" " si " B <= -B_"lim"
    )
    $
    La fonction Python s'écrit donc
    ```python
    def H(B):
        Blim = mu0 * (Msat / chi + Msat)
        if -Blim <= B <= Blim:
            return B / (mu0 * (1 + chi))
        elif B >= Blim:
            return B / mu0 - Msat
        else:
            return B / mu0 + Msat
    ```
]

#question(coups-de-pouce: (
    "Le champ magnétique est imposé par la tension $v_1$ : il faut calculer $H$ connaissant $B$.",
))[
    Écrire une fonction `courants(V1eff)` qui renvoie les tableaux `v1`, `v2`, `i1` et `i2` lorsque le primaire est alimenté sous la tension efficace `V1eff`, la résistance $R$ étant branchée au secondaire.
][
    ```python

    def courants(V1eff):
        v1 = np.sqrt(2) * V1eff * np.cos(omega * t)
        v2 = m * v1
        Btab = np.sqrt(2) * V1eff / (N1 * S * omega) * np.sin(omega * t)
        Htab = np.array([H(b) for b in Btab])
        i2 = -v2 / R
        i1 = (Htab * l - N2 * i2) / N1
        return v1, v2, i1, i2
    ```
]

#question(coups-de-pouce: (
    "Calculer $B_\"max\"$ pour chaque tension et le comparer à $B_\"sat\"$.",
    "Les courants sont-ils toujours sinusoïdaux ? À quels instants le courant $i_1$ s'écarte-t-il de $-m i_2$ ?",
))[
    La tension du réseau peut s'écarter de 10 % de sa valeur nominale, et monter jusqu'à #quan[253 V] ; une surtension passagère peut la porter au-delà. Tracer $v_1$, $v_2$, $i_1$ et $-m i_2$ pour $V_1 = #quan[230 V]$, #quan[253 V] et #quan[270 V]. La loi de transformation des courants est-elle vérifiée ? Les puissances moyennes reçue au primaire et fournie à la résistance sont-elles encore égales ?
][
    ```python
    for V1eff in [230, 253, 270]:
        v1, v2, i1, i2 = courants(V1eff)
        plt.figure("Tensions et courants pour une tension primaire de " + str(V1eff) + " Veff")
        plt.subplot(2, 1, 1)
        plt.plot(t, v1, label="v1")
        plt.plot(t, v2, label="v2")
        plt.legend()
        plt.subplot(2, 1, 2)
        plt.plot(t, i1, label="i1")
        plt.plot(t, -m * i2, label="-m i2")
        plt.legend()
        print(V1eff, np.mean(v1 * i1), np.mean(-v2 * i2))
    plt.show()
    ```

    À #quan[230 V] et #quan[253 V], $B_"max"$ vaut #quan[1.73 T] et #quan[1.90 T] : le matériau ne sature jamais et les courbes sont celles du matériau linéaire. La loi de transformation des courants est vérifiée au courant magnétisant près.

    À #quan[270 V], $B_"max" approx #quan[2.03 T]$ dépasse $B_"sat"$ : au voisinage des maximums de $abs(B)$, donc des annulations de $v_1$, le courant $i_1$ présente des pics d'environ #quan[2.4 A], quatre fois plus grands que le courant utile. La loi de transformation des courants est alors complètement fausse pendant ces pics. Les tensions $v_1$, $v_2$ et le courant $i_2$ restent sinusoïdaux : seul le primaire « voit » la saturation.

    Les deux puissances moyennes restent égales (#quan[131 W]) : sans hystérésis, $H$ est une fonction de $B$ et l'aire du cycle $B(H)$ est nulle, si bien que le courant magnétisant, même déformé, ne transporte aucune puissance en moyenne. Les pics de courant augmentent en revanche les pertes cuivre d'un transformateur réel, et perturbent le réseau.

    C'est pourquoi le nombre de spires du primaire est choisi assez grand pour que le circuit magnétique ne sature pas sous la tension maximale du réseau, puisque $B_"max"$ est inversement proportionnel à $N_1$.
]
