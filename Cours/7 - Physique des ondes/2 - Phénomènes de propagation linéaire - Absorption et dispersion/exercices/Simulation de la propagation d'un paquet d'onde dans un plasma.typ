#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Simulation de la propagation d'un paquet d'onde dans un plasma",
    numérique: true,
    difficulté: 1
)

On s'intéresse à la propagation d'un paquet d'onde $s(x,t)$ dans un milieu pouvant être dispersif.

Le paquet d'onde est connu en $x=0$ :
$
    s(0,t)=f(t,0,Delta t) cos(omega t)
$
où $f(t,0,Delta t)$ est la fonction gaussienne centrée en $0$ et d'extension temporelle $Delta t$.

Pour déterminer comment le paquet d'onde se propage, on le décompose grâce au théorème de Fourier et on étudie la propagation de chaque signal monochromatique composant le paquet d'onde.

#question()[
    Compléter le code ci-dessous pour définir `s_x0` avec $s(0,t)$.
    ```python
      import numpy as np

      Deltat = 0.4 # extension temporelle (s)
      t = np.linspace(-2,10,1000) # temps pour lesquels on calcul s (s)

      def gaussienne(x, mu, sig): # Définition d'une gaussienne de x. sigma est la largeur à mi-hauteur et mu la position du centre.
          return 1. / (np.sqrt(2. * np.pi) * sig) * np.exp(-np.power((x - mu) / sig, 2.) / 2)

      s_x0 = ... # onde s(x=0,t) en x=0
    ```
][
    ```python
    s_x0 = np.cos(2*np.pi*2*t)*gaussienne(t,0,Deltat) # onde s(x=0,t) en x=0
    ```
]

#question()[
    Tracer l'onde en $x=0$ en fonction de $t$.
][
    ```python
    import matplotlib.pyplot as plt

    plt.figure(1)
    plt.clf()
    plt.plot(t,s_x0)
    plt.xlabel("temps (s)")
    plt.title("Signal en x=0")
    plt.show()
    ```
]

La décomposition spectrale consiste à décomposer un signal comme une somme de signaux monochromatiques
$
    s(x=0,t)=sum_i underline(A_i)e^(j omega_i t)
$

On peut calculer le spectre du paquet d'onde pour obtenir la liste des $underline(A_i)$ grâce à la fonction #link("https://numpy.org/doc/stable/reference/generated/numpy.fft.rfft.html", `rfft`).

#question()[
    Calculer le spectre de $s(x=0,t)$ et tracer $|underline(A)|$ en fonction de la fréquence en complétant le code ci-dessous.
    ```python
    from numpy.fft import rfft, irfft, rfftfreq

    frequences = rfftfreq(len(t), t[1]-t[0]) # calcul des fréquences de la transformée de Fourier (Hz)
    pulsations = ... # pulsations (rad/s)
    spectre_x0 = ... # spectre de s(x=0,t) (c'est-à-dire liste des A_i)

    plt.figure()
    plt.clf()
    plt.plot(...)
    plt.xlabel(...)
    plt.title("spectre de s en x=0")
    plt.show()
    ```
][
    ```python
    from numpy.fft import rfft, irfft, rfftfreq

    frequences = rfftfreq(len(t), t[1]-t[0]) # calcul des fréquences de la transformée de Fourier (Hz)
    pulsations = 2*np.pi*frequences # pulsations (rad/s)
    spectre_x0 = rfft(s_x0) # spectre de s (c'est-à-dire liste des A_i)

    plt.figure()
    plt.clf()
    plt.plot(frequences, np.abs(spectre_x0))
    plt.xlabel("fréquence (Hz)")
    plt.title("spectre de s en x=0")
    plt.show()
    ```
]

#question()[
    En faisant varier `Deltat`, quel est l'effet de l'extension temporelle du paquet d'onde sur son spectre ?

    On utiliser `Deltat = 0.4` dans toute la suite.
][
    Plus l'extension temporelle du paquet d'onde est grande, plus son spectre est concentré autour de la pulsation centrale. Inversement, plus l'extension temporelle est petite, plus le spectre est large et contient des fréquences éloignées de la pulsation centrale.
]

#question(
    coups-de-pouce: (
        "Comment s'écrit de manière générale une OPPH ?"
    )
)[
    Si une onde OPPH s'écrit $underline(A_i)e^(j omega_i t)$ en $x=0$, comment s'écrit-elle après avoir parcouru une distance $x$ dans le milieu ?
][
    Après avoir parcouru une distance $x$ dans le milieu, l'onde monochromatique s'écrit
    $
        underline(A_i) e^(j( omega_i t-k_i x)) = underline(A_i)e^(j omega_i t) e^(-j k_i x)
    $
]

La fonction #link("https://numpy.org/doc/stable/reference/generated/numpy.fft.irfft.html", `irfft`) permet de réaliser l'opération inverse à la transformée de Fourier : elle calcule le signal à partir de son spectre.

#question()[
    Compléter le code ci-dessous.
    ```python
    j = 1j
    c = 1

    def rd(omega): # relation de dispersion : calcule k(omega) et le renvoie
        c = 1 # célérité
        ##########################
        # D'Alembert
        # return ...
        ##########################
        # Plasma
        omega_p = 2*np.pi # pulsation plasma
        if omega > omega_p:
            return ...
        else:
            return 0 # pour des raisons de stabilité dépassant le programme, on laisse 0 pour ce cas-ci
        #########################

    x = 3 # position où calculer l'onde
    k = np.array(...) # nombres d'onde complexes calculés grâce à la relation de dispersion
    spectre_x = ... # spectre de $s$ en $x$
    s_x = ... # calcul de s(x,t) à l'abscisse x
    ```
][
    ```python
    j = 1j

    c = 1

    def rd(omega): # relation de dispersion : calcule k(omega) et le renvoie
        c = 1 # célérité
        ##########################
        # D'Alembert
        # return pulsations/c 
        ##########################
        # Plasma
        omega_p = 2*np.pi # pulsation plasma
        if omega > omega_p:
            return omega/c*np.sqrt(1-omega_p**2/omega**2)
        else:
            return 0 # pour des raisons de stabilité dépassant largement le programme, on laisse 0 pour ce cas-ci
        #########################

    x = 3 # position où calculer l'onde
    k = np.array([rd(omega) for omega in pulsations]) # nombres d'onde complexes calculés grâce à la relation de dispersion
    spectre_x = spectre_x0 * np.exp(-j*k*x) # spectre de $s$ en $x$
    s_x = irfft(spectre_x) # calcul de s(x,t) à l'abscisse x
    ```
]

#question()[
    Tracer l'onde après propagation sur une longueur $x=3 m$ pour une onde vérifiant l'équation de d'Alembert puis dans un plasma. Vérifier l'existence d'un étalement du paquet d'onde pour l'onde dans un plasma. Est-ce que les hautes fréquences ou les basses fréquences se propagent plus vite ?
][
    ```python
    plt.figure(3)
    plt.clf()
    plt.plot(t,s_x)
    plt.xlabel("temps (s)")
    plt.title(f"Signal en x={x} m")
    plt.show()
    ```
   Le paquet d'onde est plus large en $x$ qu'en $x=0$.

    On observe que les basses fréquences arrivent plus vite que les hautes fréquences (elles sont là plus tôt à une abscisse fixée).
]

On souhaite maintenant visualiser la propagation de l'onde en traçant $s(x,t)$ en fonction de $x$ à $t$ fixé. Pour cela, il faut calculer $s$ pour un grand nombre de $x$ en utilisant la même méthode que précédemment.

#question()[
    Compléter le code ci-dessous puis tracer $s(x,t)$ en fonction de $x$ pour différents temps de sorte à visualiser la propagation de l'onde. Quelles fréquences sont plus rapides (hautes ou basses) ? Est-ce cohérent avec votre réponse précédente ?

    ```python
    x = np.linspace(-3,6,1000) # abscisses auxquelles l'onde sera calculée

    s = np.zeros((len(x),len(t))) # s est un array à 2 dimentions dont les lignes correspondent à une position et les colonnes à un instant

    s[0,:] = ...
    for i in range(1,len(x)):
        s[i,:] = ...
        
        
    plt.figure(4)
    plt.clf()
    i = 500 # à changer pour changer l'instant auquel l'onde est tracée
    plt.plot(x,s[:,i])
    plt.xlabel(...)
    plt.title(f"signal à t={t[i]} s")
    plt.show()
    ```
][
    ```python
    x = np.linspace(-3,6,1000) # abscisses auxquelles l'onde sera calculée

    s = np.zeros((len(x),len(t))) # s est un array à 2 dimentions dont les lignes correspondent à une position et les colonnes à un instant

    s[0,:] = s_x0 # la première ligne correspond à l'abscisse 0
    for i in range(1,len(x)):
        s[i,:] = irfft(spectre_x0 * np.exp(-j*k*x[i]))
        
        
    plt.figure(4)
    plt.clf()
    i = 500 # à changer pour changer l'instant auquel l'onde est tracée
    plt.plot(x,s[:,i])
    plt.xlabel("position (m)")
    plt.title(f"signal à t={t[i]} s")
    plt.show()
    ```
   On remarque qu'à $t$ fixé, les basses fréquences sont à une abscisse plus grande donc se sont propagées plus vite que les hautes fréquences.
]

Afin de visualiser la propagation de l'onde d'une façon plus commode, on peut animer l'évolution de l'onde.

```python
import matplotlib.animation as animation

fig = plt.figure(5) # initialise la figure
plt.clf()
line, = plt.plot(x, s[:,0])

def animate(i):
    line.set_data(t, s[:,i])
    return line,

ani = animation.FuncAnimation(fig, animate, frames=1000, interval=10, blit=True, repeat=False)
plt.show()
```
