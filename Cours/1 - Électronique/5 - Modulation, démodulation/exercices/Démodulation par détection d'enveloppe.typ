#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Démodulation par détection d'enveloppe",
    numérique: true,
)

On souhaite démoduler un signal modulé en amplitude $e(t) = A_0 [1+m cos(2 pi f_s t)] cos(2 pi f_p t)$. On utilise pour cela le montage ci-dessous, appelé détecteur d'enveloppe.

#figure(
    zap.circuit({
        import zap: *
        import cetz.draw: *
        set-style(padding: .4em)
        diode("D", (0, 0), (2.2, 0), label: $D$, variant: "ieee")
        resistor("R", "D.out", (rel: (0, -2.5)), label: (content: $R$, anchor: "south"))
        capacitor("C", (rel: (2, 0), to: "D.out"), (rel: (0, -2.5)), label: (content: $C$, anchor: "south"))
        wire("D.out", "C.in")
        wire("R.out", "C.out")
        frame("G", "R.out")
        content("D.in", $e(t)$, anchor: "east", padding: .3em)
        content("C.in", $s(t)$, anchor: "west", padding: .3em)
    }),
)

#question(
    coups-de-pouce: (
        "Redessiner le schéma en remplaçant la diode par un fil.",
        "Quelle est la différence de potentiel aux bornes d'un fil ?",
    ),
)[
    Montrer que lorsque la diode est passante (c'est-à-dire qu'elle se comporte comme un fil) $s(t) = e(t)$.
][
    Lorsque la diode est passante, elle se comporte comme un simple fil : le point d'entrée $e(t)$ et le nœud de sortie sont directement reliés, sans qu'aucune différence de potentiel n'apparaisse à ses bornes. On a donc directement
    $
        s(t) = e(t)
    $
]

#question(
    coups-de-pouce: (
        "Redessiner le schéma en remplaçant la diode par un interrupteur ouvert.",
        "Introduire le courant passant dans le circuit.",
        "En utilisant la relation entre tension et courant pour un condensateur et la loi d'Ohm, obtenir l'équation différentielle demandée.",
    ),
)[
    Déterminer l'équation différentielle vérifiée par $s(t)$ lorsque la diode est bloquée (c'est-à-dire qu'elle se comporte comme un interrupteur ouvert).
][
    Lorsque la diode est bloquée, elle se comporte comme un interrupteur ouvert : aucun courant $i$ ne peut plus provenir de l'entrée $e(t)$. Le courant $i=0$ se répartit alors entre $R$ et $C$, en parallèle : $i=i_1+i_2=0$, donc $i_1=-i_2$, soit
    $
        s/R = -C dv(s, t)
    $
    $
        dv(s, t) + s/(R C) = 0
    $
    Le condensateur $C$, chargé lorsque la diode conduisait, se décharge alors dans $R$.
]

On utilise Python pour simuler l'évolution de $s(t)$ sur l'exemple d'un signal modulant sinusoïdal : $e(t) = cos(omega_p t) (1+k cos(omega_s t))$

#question(
    coups-de-pouce: (
        "La fonction `cos` de la bibliothèque `numpy` accepte en argument un tableau de valeurs et renvoie un tableau de valeurs cosinus correspondantes.",
    ),
)[
    Compléter le code ci-dessous pour tracer $e(t)$.
    ```python
    import numpy as np
    import matplotlib.pyplot as plt
    omega_p = 2*np.pi*200 # (rad/s) pulsation de la porteuse
    omega_s = 2*np.pi*1.5 # (rad/s) pulsation du signal
    k = 0.7 # taux de modulation

    t = np.linspace(0,1,2000) # temps (s)
    e = ... # signal modulé en amplitude

    plt.clf() #effacement de précédents tracés
    plt.plot(t, e, label="signal modulé")
    plt.legend()
    plt.show()
    ```
][
    ```python
    import numpy as np
    import matplotlib.pyplot as plt
    omega_p = 2*np.pi*200 # pulsation de la porteuse
    omega_s = 2*np.pi*1.5 # pulsation du signal
    k = 0.7 # taux de modulation

    t = np.linspace(0,1,2000) # temps (s)
    e = np.cos(omega_p*t) * (1+k*np.cos(omega_s*t)) # signal modulé en amplitude

    plt.clf() #effacement de précédents tracés
    plt.plot(t, e, label="signal modulé")
    plt.xlabel("temps (s)")
    plt.ylabel("tension (V)")
    plt.legend()
    plt.show()
    ```
]

Pour résoudre numériquement l'équation différentielle obtenue précédemment, on utilise la méthode d'Euler.

#question(
    coups-de-pouce: (
        "La relation de Taylor d'ordre 1 permet d'écrire $s(t + Delta t) approx s(t) + Delta t dv(s, t)$.",
    ),
)[
    Montrer que l'équation différentielle mène, une fois discrétisée, à la relation de récurrence
    $
        s_i = (1 - (Delta t)/(R C)) s_(i-1)
    $
    où $Delta t$ est le pas de temps et $s_i = s(i times Delta t)$.
][
    La relation de Taylor d'ordre 1 permet d'écrire
    $
        s(t + Delta t) approx s(t) + Delta t dv(s, t)
    $
    c'est-à-dire
    $
        s_(i+1) approx s_i + Delta t dv(s, t)
    $
    En remplaçant $dv(s, t)$ par l'équation différentielle obtenue précédemment, on obtient
    $
        s_(i+1) approx s_i - (Delta t)/(R C) s_i = (1 - (Delta t)/(R C)) s_i
    $
    En effectuant le changement d'indice $i -> i - 1$, on obtient la relation demandée
    $
        s_i = (1 - (Delta t)/(R C)) s_(i-1)
    $
]

#question(
    coups-de-pouce:(
        "Le pas de temps peut être calculé à partir du tableau des temps `t`.",
        "Que vaut $s$ lorsque la diode est passante ?",
    )
)[
    Compléter le code ci-dessous pour simuler l'évolution de $s(t)$.
    ```python
    Dt = ... # pas de temps (s)
    R = 40e3 # (Ohm) résistance
    C = 1e-6 # (F) capacité

    s = np.zeros(len(t)) # initialisation
    for i in range(1,len(t)):
        s[i] = ... # méthode d'Euler
        if s[i] < e[i]: # si e dépasse s, la diode devient passante
            ...
    ```
][

    ```python
    Dt = t[1] - t[0] # pas de temps (s)
    R = 40e3 # (Ohm) résistance
    C = 1e-6 # (F) capacité

    s = np.zeros(len(t)) # initialisation
    for i in range(1,len(t)):
        s[i] = (1- Dt/(R*C)) * s[i-1] # méthode d'Euler
        if s[i] < e[i]: # si e dépasse s, la diode devient passante
            s[i] = e[i]
    ```
]

#question(
    coups-de-pouce: (
        "On peut s'inspirer du code de la question 3."
    )
)[
    Écrire les instructions permettant de tracer $s$ et $e$ sur le même graphique.
][
    ```python
    plt.clf()
    plt.plot(t,e, label="signal modulé")
    plt.plot(t,s, label="signal démodulé")
    plt.xlabel("temps (s)")
    plt.ylabel("tension (V)")
    plt.legend()
    plt.show()
    ```
]

En fonctions de valeurs de $k$, le signal démodulé peut être plus ou moins fidèle au signal modulant.

#question(
    coups-de-pouce: (
        "Pour $k=0.8$, le signal est-il correctement démodulé ? Même question pour $k=1.2$.",
    )
)[
    En modifiant les valeurs de $k$ dans le programme, dans quelle plage de valeurs le signal démodulé $s(t)$ suit-il correctement l'enveloppe du signal modulé $e(t)$ ?
][
    Pour que le signal démodulé $s(t)$ suive correctement l'enveloppe du signal modulé $e(t)$, il faut que le taux de modulation $k$ soit inférieur à 1.
]

#question(
    coups-de-pouce:(
        "$R C$ est le temps caractéristique auquel la tension $s$ tend vers $0$.",
        "Que se passe-t-il si $R C$ est très petit ? A quoi faut-il le comparer ?",
        "Que se passe-t-il si $R C$ est très grand ? A quoi faut-il le comparer ?",
    )
)[
    Quelle#underline[s] condition#underline[s] doit vérifier le produit $R C$ pour que le signal démodulé $s(t)$ suive correctement l'enveloppe du signal modulé $e(t)$ ?
][
    Pour que le signal démodulé $s(t)$ suive correctement l'enveloppe du signal modulé $e(t)$, il faut que le produit $R C$ soit grand devant la période de la porteuse et petit devant la période du signal modulant.

    $
        (2 pi)/omega_s >> R C >> (2 pi)/omega_p
    $
    c'est-à-dire
    $
        omega_s << (2 pi)/(R C) << omega_p
    $
]
