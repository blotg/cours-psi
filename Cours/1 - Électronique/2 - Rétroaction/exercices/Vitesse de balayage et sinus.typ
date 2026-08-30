#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Effet de la vitesse de balayage sur un signal sinusoïdal",
    numérique: true,
    difficulté: 1,
)

On s'intéresse ici à un montage suiveur dont l'entrée est sinusoïdale. Si la fréquence de la sinusoïde est trop élevée, la vitesse de balayage de l'ALI va déformer le signal. On cherche à simuler numériquement la forme du signal de sortie obtenu.

Le signal d'entrée noté $e(t) = A sin(2 pi f t)$ avec $A = qty("10", "V")$ et $f=qty("300", "kHz")$ est envoyé à l'entrée du montage suiveur.

#question(
    coups-de-pouce: (
        "Quelle valeur maximale peut atteindre la dérivée de la tension de sortie si elle suit parfaitement l'entrée ?",
        "Que représente la vitesse de balayage de l'ALI ?",
    )
)[
    Quelle valeur minimale doit avoir la vitesse de balayage pour que le signal de sortie ne soit pas déformé ?
][
    Si le signal de sortie n'est pas déformé, il est égal au signal d'entrée et sa dérivée vaut
    $
        s'(t) = e'(t) = 2 pi f A cos(2 pi f t)
    $
    #let f = 300e3
    #let A = 10
    #let dv = 2 * calc.pi * f * A
    Sa valeur maximale est donc $2 pi f A = #qty(scientifique(dv, 2), "V/s")$, la vitesse de balayage doit être au moins égale à cette valeur pour ne pas avoir de déformation.
]

L'ALI simulé a une vitesse de balayage de #qty("14", "V/us").

#question(
    coups-de-pouce: (
        "La période d'échantillonnage est le temps entre deux instants consécutifs.",
        "La fonction `sin` de la bibliothèque `numpy` peut s'appliquer directement à un tableau et renvoie alors un tableau.",
    )
)[
    Compléter le code suivant pour mettre en place les variables nécessaires à la simulation.
    ```python
    import numpy as np
    f = 300e3        # fréquence du signal d'entrée (Hz)
    SR = 14e6        # vitesse de balayage de l'ALI (V/s)
    N = 20000        # nombre de points de la simulation
    n_périodes = 4   # nombre de périodes du signal à simuler
    A = 10           # amplitude du signal d'entrée (V)

    T = ...        # période du signal d'entrée (s)
    t = np.linspace(0, n_périodes * T, N) # tableau des instants de la simulation (s)
    dt = ... # période d'échantillonnage de la simulation (s)

    e = ... # signal d'entrée (V)
    ```
][
    ```python
    import numpy as np
    f = 300e3        # fréquence du signal d'entrée (Hz)
    SR = 14e6        # vitesse de balayage de l'ALI (V/s)
    N = 20000        # nombre de points de la simulation
    n_périodes = 4   # nombre de périodes du signal à simuler
    A = 10           # amplitude du signal d'entrée (V)

    T = 1 / f        # période du signal d'entrée (s)
    t = np.linspace(0, n_périodes * T, N) # tableau des instants de la simulation (s)
    dt = t[1] - t[0] # période d'échantillonnage de la simulation (s)

    e = A * np.sin(2 * np.pi * f * t) # signal d'entrée (V)
    ```
]

Le principe de la simulation est le suivant :
à chaque instant, on calcule la dérivée qu'aurait la sortie si elle suivait parfaitement l'entrée.
- Si cette dérivée ne dépasse pas la vitesse de balayage, aucun problème, la sortie suit l'entrée.
- Si cette dérivée dépasse la vitesse de balayage (resp. est plus petite que l'opposé de la vitesse de balayage), la sortie ne peut pas suivre l'entrée. La sortie augmente (resp. diminue) linéairement à la vitesse de balayage.

#question()[
    Compléter le code suivant pour simuler l'évolution de la tension de sortie de l'ALI.
    ```python
    s = [e[0]] # initialisation : la sortie est initialement égale à l'entrée
    for i in ...: # on parcourt tous les instants de la simulation
        if abs(s[i-1] - e[i]) / dt < SR: # la vitesse de balayage n'est pas dépassée
            s.append(...)
        elif e[i] > s[i-1]: # la sortie doit croitre
            s.append(...)
        else: # la sortie doit décroitre
            s.append(...)
    ```
][
    ```python
    s = [e[0]] # initialisation : la sortie est initialement égale à l'entrée
    for i in range(1, N):
        if abs(s[i-1] - e[i]) / dt < SR: # la vitesse de balayage n'est pas dépassée
            s.append(e[i])
        elif e[i] > s[i-1]: # la sortie doit croitre
            s.append(s[i-1] + SR*dt)
        else: # la sortie doit décroitre
            s.append(s[i-1] - SR*dt)
    ```
]

Les instructions suivantes permettent de tracer les signaux d'entrée et de sortie simulés.

```python
import matplotlib.pyplot as plt
plt.plot(t,e, label='Entrée')
plt.plot(t,s, label='Sortie')
plt.xlabel('Temps (s)')
plt.ylabel('Tensions (V)')
plt.title('Effet de la vitesse de balayage sur un signal sinusoïdal')
plt.legend()
plt.grid()
plt.show()
```

#question()[
    Le résultat de la simulation est-il conforme à votre réponse à la première question ?
][
    La sortie diffère effectivement de l'entrée, ce qui est attendu car la vitesse de balayage de l'ALI est inférieure à la valeur minimale calculée à la première question. Le signal de sortie est donc déformé par rapport au signal d'entrée.
]