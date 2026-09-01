#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Couplage thermocinétique",
    numérique: true,
    difficulté: 1,
)

Le peroxyde de ditertiobutyle (DTBP) est utilisé comme amorceur radicalaire lors des réactions de polymérisation. Il se décompose selon la réaction chimique
$
    #import "@preview/whalogen:0.3.0": ce as ce2
    #ce2("(CH3)3COOC(CH3)3 -> 2 (CH3)3CO^.")
$

Cette décomposition est exothermique avec une enthalpie de réaction  $Delta_r H^circ = qty("-150", "kJ/mol")$.
Elle a une loi de vitesse d'ordre 1 avec une constante de vitesse $k$ qui suit la loi d'Arrhenius $k = A exp(-E_a / (R T))$.

On observe ainsi un couplage thermocinétique : la réaction dégage de la chaleur, ce qui augmente la température du système, ce qui accélère la réaction. On cherche à modéliser ce couplage dans un réacteur continu parfaitement agité (RPAC) de volume $V = qty("520", "mL")$.

On se place dans l'approximation d'Ellingham.

La réaction est maintenue à une température $T$ identique à la température d'entrée grâce à un échangeur thermique dans lequel circule un fluide caloporteur à la température $T_0$. La puissance thermique fournie par le réacteur au fluide caloporteur est donnée par la loi de Newton : $P_"th" = h S (T - T_0)$.



#question(
    coups-de-pouce: (
        "La démonstration a été faite en cours dans le cas général.",
        "L'énoncé indique que la transformation est isotherme.",
    ),
)[
    Montrer que $P_"th"$ vérifie l'équation
    $
        P_"th" = - D_v X [ce("DTBP")]_e Delta_r H^circ
    $
][
    Il s'agit de la démonstration du cours, dans le cas particulier où $T_e = T_s$. La puissance $P_"th"$ étant *fournie*, elle est comptée négativement. Ici $nu_ce("DTBP") = -1$
]

#question(
    coups-de-pouce: (
        "Faire un bilan de matière sur #ce(\"DTBP\").",
        "Exprimer la concentration de #ce(\"DTBP\") à la sortie du réacteur en fonction du taux de conversion $X$ et de la concentration à l'entrée.",
    ),
)[
    Montrer que le taux de conversion $X$ s'écrit
    $
        X = (k tau)/(1 + k tau)
    $
    où $tau = V / D_v$ est le temps de passage dans le réacteur.
][
    Le bilan de matière dans un RPAC en régime stationnaire s'écrit
    $
        D_V ([ce("DTBP")]_e - [ce("DTBP")]_s) + R_ce("DTBP") V = 0
    $
    avec $[ce("DTBP")]_s = (1-X)[ce("DTBP")]_e$ et $R_ce("DTBP") = -r = - k [ce("DTBP")]_s$ car la réaction est d'ordre 1 de constante de vitesse $k$. On en déduit
    $
        D_v X [ce("DTBP")]_e = k (1 - X) [ce("DTBP")]_e V
    $
    d'où
    $
        X = k (1-X) V / D_v = k (1-X) tau
    $
    $
        X (1 + k tau) = k tau
    $
    d'où le résultat
    $
        X = (k tau)/(1 + k tau)
    $
]

#question(
    coups-de-pouce: (),
)[
    Écrire une fonction Python `X(T, tau)` qui calcule le taux de conversion en fonction de la température $T$ du réacteur et du temps de passage `tau`, en utilisant les données numériques suivantes :
    - $A = qty("1e15", "/s")$
    - $E_a = qty("157e3", "J/mol")$
    - $R = qty("8.314", "J/K/mol")$
    Tracer la fonction $X(T)$ pour $T$ variant de #qty("250", "K") à #qty("600", "K") avec un temps de passage fixé à #qty("600", "s").
][
    ```python
    import numpy as np

    def X(T, tau):
        A = 1e15  # /s
        E_a = 157e3  # J/mol
        R = 8.314  # J/K/mol

        k = A * np.exp(-E_a / (R * T))
        return (k * tau) / (1 + k * tau)

    T = np.linspace(250, 600, 100)  # K
    import matplotlib.pyplot as plt
    plt.plot(T, X(T, 600))
    plt.xlabel("Température (K)")
    plt.ylabel("Taux de conversion X")
    plt.show()
    ```
]

#question(
    coups-de-pouce: (
        "Les deux expressions de $P_\"th\"$ doivent être égales au point de fonctionnement.",
        "Pour discuter la stabilité, imaginer ce qui se passerait si la température augmentait légèrement."
    )
)[
    Tracer en fonction de $T$ les deux expressions de $P_"th"$ à l'aide de Python pour $tau = qty("1200", "s")$ puis pour $tau = qty("800", "s")$.
    Combien de points de fonctionnement a-t-on dans chacun des cas ? Discuter la stabilité de ces points de fonctionnement dans le dernier cas $tau = qty("800", "s")$.
][
    ```python
    def P1(T):
        return h * S * ( T - T0 )

    def P2(T, tau):
        Dv = V / tau
        return -Dv * X(T, tau) * c0 * DrH

    plt.plot(T, P1(T), label="Puissance échangée avec l'extérieur")
    plt.plot(T, P2(T, 1200), label="Puissance thermique fournie par le réacteur")
    plt.xlabel("Température (K)")
    plt.ylabel("Puissance (W)")
    plt.legend()
    plt.show()
    ```
    Pour $tau = qty("1200", "s")$, il y a un seul point pour lequel ces puissances sont égales, donc un seul point de fonctionnement possible.

    Pour $tau = qty("800", "s")$, il y a trois points d'intersection, donc trois points de fonctionnement possibles.

    On s'intéresse pour commencer au point de fonctionnement à basse température. Si la température augmente légèrement, la puissance fournie au circuit de refroidissement augmente et la puissance fournie par la réaction n'augment quasiment pas. Ainsi la température diminue de nouveau : ce point est stable.

    Pour le point de fonctionnement intermédiaire, si la température augmente légèrement, la puissance fournie au circuit de refroidissement augmente un peu mais la puissance fournie par la réaction augmente beaucoup plus. Ainsi la température continue d'augmenter : ce point est instable.

    Pour le point de fonctionnement à haute température, si la température augmente légèrement, la puissance fournie au circuit de refroidissement augmente et la puissance fournie par la réaction n'augmente quasiment pas. Ainsi la température diminue de nouveau : ce point est stable.
]
