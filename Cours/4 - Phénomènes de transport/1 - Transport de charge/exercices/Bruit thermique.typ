#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Bruit thermique",
    numérique: true,
    difficulté: 2,
)

Le bruit thermique, ou bruit de Johnson-Nyquist, est un phénomène physique qui se manifeste par des fluctuations aléatoires des grandeurs électriques dans un conducteur en raison de l'agitation des porteurs de charge (électrons).

Pour le modéliser, on s'intéresse à des électrons dans un conducteur soumis à un champ électrique $va(E) = E ex$. On suppose que les électrons se déplacent dans la seule direction $ex$.

#question(
    coups-de-pouce: (
        "Reprendre le cours sur le modèle de Drude.",
    ),
)[
    Que représente $tau$ ?
][
    $tau$ est le temps moyen entre deux collisions successives d'un électron dans le conducteur.
]

#question(
    coups-de-pouce: (
        "Une seule force agit sur l'électron entre deux collisions. Laquelle ?",
        "Écrire la loi de la quantité de mouvement en l'absence de choc.",
    ),
)[
    En l'absence de choc, écrire l'équation différentielle vérifiée par la vitesse $v(t)$ de l'électron.
][
    La loi de la quantité de mouvement donne $m dv(v, t) = -e E$, d'où
    $ dv(v, t) = -e E / m $
]

#question(
    coups-de-pouce: (
        "La fonction `np.linspace(a, b, N)` crée un array numpy de `N` valeurs régulièrement espacées entre `a` et `b`. On peut s'en servir pour créer le array `t`.",
        "La fonction `np.zeros(N)` crée un array numpy de `N` valeurs nulles. On peut s'en servir pour initialiser le array des vitesses.",
        "Utiliser la relation de Taylor pour exprimer $v(t+dd(t))$ en fonction de $v(t)$ et $dv(v,t)$. En déduire une relation entre `v[i+1]` et `v[i]`.",
    ),
)[
    On souhaite simuler l'évolution de la vitesse de l'électron grâce à la méthode d'Euler. Compléter le code suivant qui calcule la vitesse de l'électron au cours du temps en l'absence de choc.

    #show raw.where(block: true): numérote-code
    ```python
    import numpy as np

    N = 1000 # nombre de pas de temps

    E = 100 # champ électrique en V/m
    e = ... # charge de l'électron en C
    m = ... # masse de l'électron en kg
    l = 1e-2 # longueur du conducteur en m

    T = 1e-12 # temps total de la simulation en s
    dt = ... # pas de temps en s
    t = ... # array numpy contenant tous les temps de la simulation

    def V():
        v = ... # initialisation du array des vitesses par des vitesses nulles
        for i in range(N-1):
            v[i+1] = ... # calcul de la vitesse à l'instant t[i+1] en fonction de la vitesse à
                         # l'instant t[i] grâce à la méthode d'Euler
        return v
    ```
][
    #show raw.where(block: true): numérote-code
    ```python
    import numpy as np

    N = 1000 # nombre de pas de temps

    E = 100 # champ électrique en V/m
    e = 1.6e-19 # charge de l'électron en C
    m = 9.11e-31 # masse de l'électron en kg
    l = 1e-2 # longueur du conducteur en m

    T = 1e-12 # temps total de la simulation en s
    dt = T / N # pas de temps en s
    t = np.linspace(0, T, N) # array numpy contenant tous les temps de la simulation

    def V():
        v = np.zeros(N) # initialisation du array des vitesses par des vitesses nulles
        for i in range(N-1):
            v[i+1] = v[i] + (-e * E / m) * dt # calcul de la vitesse à l'instant t[i+1] en fonction de la vitesse à
                                              # l'instant t[i] grâce à la méthode d'Euler
        return v
    ```
]

Entre $t$ et $t+dd(t)$, l'électron a une probabilité $dd(t)/tau$ de subir une collision. Lors d'une collision, l'électron repart avec une vitesse aléatoire suivant une distribution gaussienne de moyenne nulle et d'écart-type $v_0$.

#question(
    coups-de-pouce: (
        "Quelle est la probabilité que l'instruction `random() < dt/tau:` renvoie `True` ?",
    ),
)[
    On modifie la fonction `V()` définie précédemment pour prendre en compte les collisions :
    #show raw.where(block: true): numérote-code
    ```python
    from random import random, gauss

    tau = 1e-14 # temps moyen entre deux collisions en s
    v0 = 1 # écart-type de la distribution des vitesses après choc en m/s

    def V():
        v = ... # initialisation du array des vitesses par des vitesses nulles
        for i in range(N-1):
            if random() < dt/tau: # l'électron subit une collision
                v[i+1] = gauss(0, v0) # l'électron subit une collision et repart avec une vitesse aléatoire de
                                      # moyenne nulle et d'écart-type v0
            else: # l'électron ne subit pas de collision
                v[i+1] = ... # calcul de la vitesse à l'instant t[i+1] en fonction de la vitesse à
                            # l'instant t[i] grâce à la méthode d'Euler
        return v
    ```
    Sachant que la fonction `random()` renvoie un nombre aléatoire uniformément distribué entre 0 et 1, expliquer la ligne 8.
][
    La probabilité que l'instruction `random() < dt/tau:` soit vraie est égale à $dd(t)/tau$, ce qui correspond à la probabilité que l'électron subisse une collision entre $t$ et $t+dd(t)$.
]

#question(
    coups-de-pouce: (
        "Quel est le lien entre le vecteur densité de courant $va(j)$ et la vitesse $v$ d'un électron ?",
        "À quelle densité particulaire $n$ correspond un seul électron dans un conducteur de longueur $l$ et de section $S$ ?",
    ),
)[
    Justifier que le courant traversant le conducteur s'exprime comme
    $ I(t) = -e/l sum_(i "électrons") v_i $
][
    Si on considère un seul électron, sa "densité particulaire" est $n=1/V = 1/(l S)$
    $ I = S sum j = S sum 1/(l S) (-e) v_i = -e/l sum v_i $
]


#question(
    coups-de-pouce: (),
)[
    Compléter le code précédent pour qu'il simule le courant traversant le conducteur en fonction du temps pour $N_e = 1000$ électrons. Tracer le graphe $I(t)$.
    #show raw.where(block: true): numérote-code
    ```python
    import matplotlib.pyplot as plt

    Ne = 1000 # nombre d'électrons

    I = np.zeros(N) # initialisation du array des courants par des courants nuls

    for j in range(Ne):
        v = V() # calcul de la vitesse de l'électron j
        I += ... # ajout de la contribution de l'électron j au courant total

    ```
][
    #show raw.where(block: true): numérote-code
    ```python
    import matplotlib.pyplot as plt

    Ne = 1000 # nombre d'électrons

    I = np.zeros(N) # initialisation du array des courants par des courants nuls

    for j in range(Ne):
        v = V() # calcul de la vitesse de l'électron j
        I += -e/l * v # ajout de la contribution de l'électron j au courant total

    plt.plot(t, I)
    plt.xlabel("Temps (s)")
    plt.ylabel("Courant (A)")
    plt.title("Courant traversant le conducteur en fonction du temps")
    plt.show()
    ```
]

#question(
    coups-de-pouce: (),
)[
    Graphiquement, estimer un ordre de grandeur de la durée du régime transitoire.
][
    Le régime transitoire dure environ #qty("3e-14", "s").
]

Le coefficient de variation, aussi appelé écart-type relatif est défini par $C V = sigma/mu$ où $sigma$ est l'écart-type et $mu$ la moyenne.

#question(
    coups-de-pouce: (
        "Quel lien existe-t-il entre un instant $t$ et l'indice `i` correspondant ?",
        "On peut utiliser le _slincing_ : `I[i:]` renvoie un array numpy contenant les valeurs de `I` à partir de l'indice `i` jusqu'à la fin.",
    ),
)[
    Calculer le coefficient de variation du courant en régime permanent. L'écart-type peut être calculé avec `np.std()` et la moyenne avec `np.mean()`.
][
    #show raw.where(block: true): numérote-code
    ```python
    i = int(3e-14 / dt) # indice correspondant à la fin du régime transitoire
    CV = np.std(I[i:]) / np.mean(I[i:])
    print("Coefficient de variation du courant en régime permanent :", CV)
    ```
]
