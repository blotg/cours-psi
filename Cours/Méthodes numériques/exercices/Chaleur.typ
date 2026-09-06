#import "@local/prepa:0.1.1": *

#exercice(
  titre: "Propagation de la chaleur",
  numérique: true
)[
On cherche à modéliser l'évolution de la température dans un barreau cylindrique en aluminium ($D=qty("99e-6","m^2/s")$) de longueur $l=qty("10","cm")$. L'évolution de la température est donnée par l'équation de diffusion $pdv(T,t)=D pdv(T,x,2)$.

On discrétise spatialement la barre en prenant $N_x=20$ points.

Le code Python pourra être saisi directement sur Capytale : #link("https://capytale2.ac-paris.fr/web/c/1285-5360170", "1285-5360170")

#question(coups-de-pouce: (
  "Quelle relation relie le pas spatial $Delta x$, la longueur de la barre $l$ et le nombre de points $N_x$ ?",
))[
  Sachant que le schéma d'Euler est stable ssi $2D (Delta t)/(Delta x^2)<1$, quel pas temporel maximal peut-on choisir ? On choisira dans toute la suite $Delta t = #qty("0.1", "s")$. Compléter le code suivant.
```python
D = 99e-6
l = 10e-2
N_x = 20
Delta_x = ... # pas spatial
Delta_t = 0.1 # pas temporel
```
][
  Les $N_x$ points sont régulièrement répartis de $x=0$ à $x=l$ : ils délimitent $N_x - 1$ intervalles, donc
  #let Delta-x = 10e-2 / 19
  $ Delta x = l/(N_x - 1) = (10 dot 10^(-2))/19 = #qty(scientifique(Delta-x, 2), "m") $

  #let Delta-t = calc.pow(Delta-x, 2) / (2 * 99e-6)
  $ Delta t < (Delta x)^2/(2 D) = #qty(scientifique(Delta-t, 2), "s") $
  Le pas $Delta t = #qty("0.1", "s")$ proposé convient donc.
```python
Delta_x = l/(N_x - 1) # pas spatial
```
]

#question(coups-de-pouce: (
  "Quelle relation relie le pas temporel $Delta t$, la durée totale de la simulation et le nombre de pas temporels $N_t$ ?",
  "La fonction `np.zeros((a,b))` permet de créer une matrice de `a` lignes et `b` colonnes initialisée à zéro.",
))[
  La température dans le barreau à chaque instant sera stockée dans une matrice de sorte que $T_(i,j)=T(i dot Delta t, j dot Delta x)$. On souhaite simuler l'évolution de la température durant 4 minutes. Combien de lignes doit comporter la matrice ? Combien de colonnes ?  Compléter le code suivant.
```python
import numpy as np
T = np.zeros((...,...))
```
][
  Il faut $N_t = (4 times 60)/0.1 = 2400$ lignes et $N_x = 20$ colonnes.
```python
import numpy as np
N_t = int((4 * 60) / Delta_t)
T = np.zeros((N_t,N_x))
```
]

#question(coups-de-pouce: (
  "À quel endroit de la matrice $T_(i,j)$ correspond la température initiale de la barre ?",
  "On peut utiliser le \"slicing\" de Python pour sélectionner des sous-parties d'une matrice : `T[i,:]` sélectionne la `i`-ième ligne de T.",
))[
  On initialise la simulation en supposant la température égale à #qty("298", "K") dans le barreau au début. Compléter le code suivant.
```python
T[...] = 298 # Température initiale de la barre
```
][
```python
T[0, :] = 298 # Température initiale de la barre
```
]

#question(coups-de-pouce: (
  "À quel endroit de la matrice $T_(i,j)$ correspondent l'abscisse $x=0$ ? et l'abscisse $x=l$ ?",
  "On peut utiliser le \"slicing\" de Python pour sélectionner des sous-parties d'une matrice : `T[:,j]` sélectionne la `j`-ième colonne de T.",
))[
  L'extrémité gauche du barreau ($x=0$) est maintenue à une température de #qty("350","K") tandis que son extrémité droite ($x=qty("10","cm")$) est maintenue à #qty("298","K"). Compléter le code suivant.
```python
T[...] = 350 # Température de la barre en x=0
T[...] = 298 # Température de la barre en x=10cm
```
][
```python
T[:,0] = 350 # Température de la barre en x=0
T[:,-1] = 298 # Température de la barre en x=10cm
```
]

#question(coups-de-pouce: (
  "La démonstration a été vue en cours.",
))[
  Montrer que l'équation de diffusion peut donner lieu à un schéma d'Euler $ T_(i+1,j)=D (Delta t)/(Delta x^2) T_(i,j+1) + D (Delta t)/(Delta x^2) T_(i,j-1) + (1-2D (Delta t)/(Delta x^2))T_(i,j)$. Compléter le code suivant.
```python
for i in range(len(T)-1):
    for j in range(1, N_x-1):
        T[i+1,j] = ...
```
][
  Démo faite en cours.
```python
for i in range(len(T)-1):
    for j in range(1, N_x-1):
        T[i+1,j] = D * (Delta_t/(Delta_x**2)) * (T[i,j+1] + T[i,j-1]) + (1 - 2*D * (Delta_t/(Delta_x**2))) * T[i,j]
```
]

#question()[
  Expliquer le choix des bornes des deux boucles du code précédent.
][
  La boucle sur `i` remplit la ligne `i+1` à chaque tour : elle doit donc s'arrêter à l'avant-dernière ligne, sinon `T[i+1]` sortirait de la matrice. C'est ce que donne `range(len(T)-1)`.

  La boucle sur `j` utilise les voisins `T[i,j-1]` et `T[i,j+1]` : elle ne peut pas traiter la première ni la dernière colonne, qui n'ont qu'un seul voisin. Ces deux colonnes sont précisément celles des extrémités du barreau, dont la température est imposée par les conditions aux limites (#qty("350", "K") et #qty("298", "K")) : il ne faut surtout pas les recalculer.
]

#question(coups-de-pouce: (
  "Où dans la matrice T se trouve le profil de température à l'instant $t = #qty(\"15\", \"s\")$ ?",
  "Pour générer les abscisses de la courbe, on peut utiliser la fonction `np.linspace(a,b,n)` pour créer un tableau de `n` valeurs régulièrement espacées entre `a` et `b`.",
))[
  Tracer sur le même graphe le profil de température dans la barre au bout de #qty("15","s"), #qty("30","s"), #qty("1","min"), #qty("2","min") et #qty("4","min").
][
  ```python
import matplotlib.pyplot as plt
x = np.linspace(0, l, N_x)
for t in [15, 30, 60, 120, 240]: # en secondes
    i = int(t / Delta_t)
    plt.plot(x, T[i, :], label=f't={t}s')
plt.xlabel('Position le long de la barre (m)')
plt.ylabel('Température (K)')
plt.legend()
plt.show()
  ```
]

#question(coups-de-pouce: (
  "Où dans la matrice T se trouve le profil de température à l'abscisse $x=l/2$ ?",
  "L'abscisse de la courbe est le temps : il y a une valeur par ligne de `T`, espacées de $Delta t$.",
))[
  Tracer la température du point central de la barre en fonction du temps.
][
  ```python
import matplotlib.pyplot as plt
j = N_x // 2
t = np.arange(N_t) * Delta_t # les instants simulés, un par ligne de T
plt.plot(t, T[:, j])
plt.xlabel('Temps (s)')
plt.ylabel('Température au centre de la barre (K)')
plt.show()
  ```
]
]