#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Simulation d'un moteur à courant continu",
    numérique: true,
    difficulté: 2,
    capytale: "d022-13145357",
)

On étudie le moteur à courant continu Maxon RE 40, d'une puissance de #quan[150 W]. Son constructeur#footnote[#link("https://www.maxongroup.com/maxon/view/product/148867")] donne la constante de couplage $Phi_0 = #quan[30.2 mWb]$, la résistance de l'induit $R = #quan[0.299 Ω]$, son inductance $L = #quan[0.082 mH]$ et le moment d'inertie du rotor $J = #quan[1.42e-5 kg m^2]$.

Le moteur est alimenté sous une tension constante $U = #quan[24 V]$. Il entraine une charge qui exerce sur le rotor un couple résistant de moment $-Gamma_r$. On néglige les frottements, les pertes fer et le moment d'inertie de la charge. On note $i(t)$ l'intensité du courant dans l'induit et $Omega(t)$ la vitesse angulaire du rotor.

#let Phi0 = 30.2e-3
#let R = 0.299
#let L = 0.082e-3
#let J = 1.42e-5
#let U = 24
#let Gn = 0.177

#question(
    coups-de-pouce: (
        "Pour l'équation électrique, écrire la loi des mailles dans le schéma équivalent de l'induit.",
        "Pour l'équation mécanique, appliquer le théorème du moment cinétique au rotor.",
        "Utiliser les relations $E_\"cém\" = Phi_0 Omega$ et $Gamma_\"ém\" = Phi_0 i$.",
    ),
)[
    Établir les deux équations différentielles couplées vérifiées par $i(t)$ et $Omega(t)$.
][
    La loi des mailles dans le schéma équivalent de l'induit, en convention récepteur, s'écrit $U = R i + L dv(i, t) + E_"cém"$ avec $E_"cém" = Phi_0 Omega$. Le théorème du moment cinétique appliqué au rotor s'écrit $J dv(Omega, t) = Gamma_"ém" - Gamma_r$ avec $Gamma_"ém" = Phi_0 i$. D'où
    $
        cases(
            dv(i, t) = (U - R i - Phi_0 Omega) / L,
            dv(Omega, t) = (Phi_0 i - Gamma_r) / J,
        )
    $
]

#question(
    coups-de-pouce: (
        "En régime permanent, les dérivées sont nulles.",
    ),
)[
    Exprimer l'intensité $i_oo$ et la vitesse angulaire $Omega_oo$ en régime permanent. Calculer leurs valeurs à vide ($Gamma_r = 0$), puis pour le couple nominal du moteur, $Gamma_r = #quan[177 mN m]$. Le constructeur annonce #quan[7580 tr/min] à vide et, au couple nominal, #quan[6940 tr/min] pour un courant de #quan[6 A] : commenter.
][
    En régime permanent, les dérivées sont nulles : $Phi_0 i_oo = Gamma_r$ et $U = R i_oo + Phi_0 Omega_oo$, donc
    $
        i_oo = Gamma_r / Phi_0 quad "et" quad Omega_oo = U / Phi_0 - (R Gamma_r) / Phi_0^2
    $
    À vide, $i_oo = 0$ et $Omega_oo = U / Phi_0 = #qty(U / Phi0, "rad/s", chiffres: 3)$, soit #quan[7.59e3 tr/min].

    Au couple nominal, $i_oo = #qty(Gn / Phi0, "A", chiffres: 3)$ et $Omega_oo = #qty(U / Phi0 - R * Gn / calc.pow(Phi0, 2), "rad/s", chiffres: 3)$, soit #quan[7.03e3 tr/min].

    Le modèle redonne la vitesse à vide du constructeur. En charge, le moteur réel tourne un peu moins vite et consomme un peu plus de courant que prévu : les frottements, négligés ici, s'ajoutent au couple résistant. Le constructeur indique d'ailleurs un courant à vide de #quan[137 mA], qui serait nul sans frottements.
]

#question(
    coups-de-pouce: (
        "La méthode d'Euler explicite approche la dérivée par un taux d'accroissement : $dv(i, t) approx (i_(k+1) - i_k) / (Delta t)$.",
        "Les deux dérivées se calculent avec les valeurs $i_k$ et $Omega_k$ de l'instant $t_k$.",
    ),
)[
    On résout ces équations par la méthode d'Euler explicite, avec un pas de temps $Delta t$. Le moteur est initialement à l'arrêt et le courant est nul. Le couple résistant peut dépendre du temps : c'est une fonction `Gamma_r(t)`. Compléter le code suivant.

    ```python
    import numpy as np
    import matplotlib.pyplot as plt

    Phi0 = 30.2e-3  # Wb
    R = 0.299       # ohm
    L = 0.082e-3    # H
    J = 1.42e-5     # kg.m^2
    U = 24          # V

    def simule(Gamma_r, duree, dt):
        """Renvoie les tableaux t, i et Omega."""
        N = round(duree / dt)
        t = dt * np.arange(N + 1)
        i = np.zeros(N + 1)
        Omega = np.zeros(N + 1)
        for k in range(N):
            i[k + 1] = ...
            Omega[k + 1] = ...
        return t, i, Omega
    ```
][
    ```python
    def simule(Gamma_r, duree, dt):
        """Renvoie les tableaux t, i et Omega."""
        N = round(duree / dt)
        t = dt * np.arange(N + 1)
        i = np.zeros(N + 1)
        Omega = np.zeros(N + 1)
        for k in range(N):
            i[k + 1] = i[k] + dt * (U - R * i[k] - Phi0 * Omega[k]) / L
            Omega[k + 1] = Omega[k] + dt * (Phi0 * i[k] - Gamma_r(t[k])) / J
        return t, i, Omega
    ```
]

#question(
    coups-de-pouce: (
        "Le couple résistant nul s'écrit `lambda t: 0`.",
        "Le maximum d'un tableau `i` s'obtient avec `i.max()`.",
        "Que vaudrait le courant si le rotor restait immobile ?",
    ),
)[
    Simuler le démarrage à vide pendant #quan[40 ms] avec $Delta t = #quan[10 us]$. Tracer $i(t)$ et $Omega(t)$. Relever le courant maximal et le comparer à $U\/R$ et au courant nominal de #quan[6 A].
][
    ```python
    t, i, Omega = simule(lambda t: 0, 40e-3, 1e-5)

    fig, (haut, bas) = plt.subplots(2, 1, sharex=True)
    haut.plot(1e3 * t, i)
    haut.set_ylabel('i (A)')
    bas.plot(1e3 * t, Omega)
    bas.set_ylabel('Omega (rad/s)')
    bas.set_xlabel('t (ms)')
    plt.show()
    print(i.max())
    ```
    Le courant monte en moins d'une milliseconde jusqu'à #quan[71 A], puis redescend vers zéro pendant que le rotor prend de la vitesse : la force contre-électromotrice $Phi_0 Omega$ s'oppose de plus en plus à la tension d'alimentation. La vitesse tend vers $U\/Phi_0 = #quan[795 rad/s]$, comme prévu.

    Le courant maximal est un peu inférieur à $U\/R = #qty(U / R, "A", chiffres: 2)$, valeur qu'il atteindrait si le rotor restait immobile : l'inductance retarde la montée du courant, et le rotor a déjà commencé à tourner quand le courant est maximal. Ce courant de démarrage vaut plus de dix fois le courant nominal : c'est pourquoi il est souvent nécessaire de le limiter.
]

#question(
    coups-de-pouce: (
        "Comparer le pas de temps aux deux constantes de temps du système, $L\/R$ et $J R\/Phi_0^2$.",
    ),
)[
    Reprendre la simulation avec $Delta t = #quan[1 ms]$. Commenter.
][
    ```python
    t, i, Omega = simule(lambda t: 0, 40e-3, 1e-3)
    print(i[:5])
    ```
    Le courant change de signe à chaque pas et son amplitude augmente sans cesse : #quan[293 A] puis #quan[-482 A] puis #quan[1339 A]... La méthode d'Euler diverge.

    Le système a deux constantes de temps : la constante de temps électrique $L\/R = #qty(L / R, "s", chiffres: 2)$ et la constante de temps mécanique $J R\/Phi_0^2 = #qty(J * R / calc.pow(Phi0, 2), "s", chiffres: 2)$. Le pas de temps doit être petit devant la plus courte des deux, même si l'on ne s'intéresse qu'à la mise en vitesse, qui est bien plus lente.
]

#question(
    coups-de-pouce: (
        "Le couple résistant s'écrit `lambda t: 0.177 if t >= 40e-3 else 0`.",
        "La constante de temps est la durée au bout de laquelle la vitesse a parcouru 63 % de sa variation totale.",
    ),
)[
    Le moteur tourne à vide. À l'instant $t = #quan[40 ms]$, on lui applique brutalement le couple nominal : $Gamma_r$ passe de 0 à #quan[177 mN m]. Simuler le fonctionnement pendant #quan[80 ms] avec $Delta t = #quan[10 us]$ et tracer $i(t)$ et $Omega(t)$. Vérifier les valeurs finales. Estimer la constante de temps de la baisse de vitesse et la comparer à $J R\/Phi_0^2$.
][
    ```python
    def charge(t):
        return 0.177 if t >= 40e-3 else 0

    t, i, Omega = simule(charge, 80e-3, 1e-5)
    print(i[-1], Omega[-1])
    ```
    Le tracé se fait comme à la question 4. Quand la charge est appliquée, le rotor ralentit, la force contre-électromotrice diminue et le courant augmente jusqu'à ce que le couple électromagnétique compense le couple résistant. La simulation donne en fin de calcul $i = #quan[5.86 A]$ et $Omega = #quan[737 rad/s]$, les valeurs de la question 2.

    La vitesse parcourt 63 % de sa baisse en #quan[4.4 ms], valeur proche de $J R\/Phi_0^2 = #qty(J * R / calc.pow(Phi0, 2), "s", chiffres: 2)$. Le constructeur donne une constante de temps mécanique de #quan[4.67 ms].
]

#question(
    coups-de-pouce: (
        "Quel est le signe de $Omega_oo$ d'après la question 2 ?",
        "Un frein peut-il faire tourner le rotor ?",
    ),
)[
    Le couple de démarrage du moteur vaut $Phi_0 U\/R = #qty(Phi0 * U / R, "N m", chiffres: 3)$. Que donne la simulation pour un couple résistant constant $Gamma_r = #quan[3 N m]$ ? Ce résultat est-il réaliste si la charge est un frein ? Et si c'est une masse suspendue à un câble enroulé sur l'arbre ?
][
    ```python
    t, i, Omega = simule(lambda t: 3, 80e-3, 1e-5)
    print(i[-1], Omega[-1])
    ```
    La simulation donne $Omega = #quan[-189 rad/s]$ et $i = #quan[99 A]$ : le rotor tourne à l'envers.

    Si la charge est un frein, ce résultat n'est pas réaliste : un frein s'oppose au mouvement, il ne peut pas entrainer le rotor. Le couple de démarrage étant inférieur au couple résistant, le moteur reste à l'arrêt, parcouru par le courant $U\/R = #qty(U / R, "A", chiffres: 2)$, qui le détruirait rapidement. Il faudrait modifier le code pour que le couple résistant change de signe avec $Omega$ et qu'il ne dépasse pas le couple électromagnétique à l'arrêt.

    Si la charge est une masse suspendue, le résultat est réaliste : le poids garde le même sens quel que soit le mouvement, la masse descend et entraine le rotor à l'envers. La force contre-électromotrice est alors négative et s'ajoute à la tension d'alimentation : le courant dépasse $U\/R$.
]
