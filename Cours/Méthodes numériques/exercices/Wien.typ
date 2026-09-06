#import "@local/prepa:0.1.1": *


#exercice(
  titre: "Oscillateur de Wien",
  numérique: true
)[
  Pour rappel, un oscillateur de Wien est constitué d'un montage amplificateur non-inverseur et d'un filtre de Wien.

  On note
- $u(t)$ la tension en entrée de l'amplificateur non-inverseur (et donc en sortie du filtre de Wien)
- $v(t)$ la tension en sortie de l'amplificateur non-inverseur (et donc en entrée du filtre de Wien)

Les fonctions de transfert du filtre de Wien et de l'amplificateur non-inverseur sont respectivement données par :

$ H_"ANI" (p) = (V(p))/(U(p)) = (1+(R_2)/(R_1))/(1+(1+(R_2)/(R_1))(tau)/(A_0)p) $

$ H_"Wien" (p) = (U(p))/(V(p)) = (1/3)/(1+1/3(1/(R C p)+ R C p)) $

On pose $w=dv(u,t)$. On cherche à mettre le problème sous la forme d'un problème d'Euler de la forme $dv(va(Y),t) = F(t,va(Y) )$ avec $va(Y)=vec(u,v,w)$.

#question(coups-de-pouce: (
  "Transformer les deux fonctions de transfert en équations différentielles dans le domaine temporel.",
  "Multiplier par $p$ et simplifier les fractions de sorte à ne plus avoir $p$ au dénominateur.",
  "À partir de $H_\"ANI\"$, on peut obtenir $dv(v,t)$. À partir de $H_\"Wien\"$, on peut obtenir $dv(w,t)$."
))[
  Exprimer les dérivées de $u$, $v$ et $w$ uniquement en fonction de $u$, $v$, $w$, $R$, $C$, $R_1$, $R_2$, $A_0$ et $tau$.
][
  $ dv(u,t) = w $
  $ dv(v,t) = A_0/tau u - 1/((1+R_2/R_1)tau/A_0) v $
  $ dv(w,t) = (-1/(R^2C^2)+1/(R C) A_0/tau) u - 1/(R C) 1/((1+R_2/R_1) tau/A_0) v - 3/(R C) w $
]

Les questions suivantes se font en ligne, sur Capytale : #link("https://capytale2.ac-paris.fr/web/c/2253-2586522", "2253-2586522")

Avec Python, on représente le vecteur $va(Y)$ par un array numpy à 3 éléments.

#question(coups-de-pouce: (
  "On peut décomposer les éléments de `Y` par `Y[0]`, `Y[1]` et `Y[2]`.",
  "Utiliser les résultats de la question précédente pour écrire la fonction `F`.",
))[
    Écrire une fonction Python qui prend en entrée Y et renvoie sa dérivée. On pourra supposer les variables $R$, $C$, $R_1$, $R_2$, $A_0$ et $tau$ déjà définies.
][
  ```python
import numpy as np
def F(t, Y):
  u,v,w = Y
  return np.array([
        w,
        A0/tau * u - 1/((1+R2/R1)*tau/A0) * v,
        (-1/(R*C)**2+1/(R*C)*A0/tau) * u - 1/(R*C)/((1+R2/R1)*tau/A0) * v - 3/(R*C) * w
    ])
  ```
]

Dans un premier temps, on utilise la fonction ```python scipy.integrate.solve_ivp``` qui résout numériquement des équations différentielles mises sous la forme d'un problème d'Euler. Cette fonction utilise des variantes de la méthode d'Euler la rendant plus précise.

La fonction solve_ivp prend en argument
- la fonction `F` définie précédemment
- le couple $(t_i, t_f)$ correspondant à l'intervalle de temps sur lequel
  on souhaite résoudre l'équation différentielle
- le tableau $va(Y)(t_i)$ correspondant aux conditions initiales

La fonction `solve_ivp` renvoie un objet. Si on le stocke dans la variable `solution`,
- ```python solution.t``` contient les temps
- ```python solution.y``` contient les valeurs successives de $va(Y)$ à ces temps

#question(coups-de-pouce: (
  "Dans quelle plage de valeurs sont les résistances utilisées en TP ?",
  "Quelle est la condition de démarrage des oscillations vue en cours ?"
))[
  Définir et affecter les variables $R=qty("1","kO")$, $C=qty("10","nF")$, $R_1$, $R_2$, $A_0=num("100000")$ et $tau=qty("0.01","s")$ avec des valeurs vraisemblables satisfaisant la condition de démarrage des oscillations.
][
  La condition de démarrage vue en cours est $1 + R_2/R_1 > 3$, soit $R_2 > 2 R_1$. Il faut la prendre avec une marge : la bande passante finie de l'ALI atténue légèrement le gain à $omega_0$, ce qui relève le seuil (ici à $R_2 approx qty("2002", "O")$).
  ```python
R = 1000 # Ohm
C = 10E-9 # F
R1 = 1000 # Ohm
R2 = 2100 # Ohm, soit un gain de 3,1 : au-dessus du seuil avec de la marge
A0 = 1E5
tau = 0.01 # s
Vsat = 15 # V, tension de saturation de l'ALI
  ```
]

#question(coups-de-pouce: ())[
  Définir `Y0` avec de très petites valeurs pour $u$, $v$ et $w$ ($num("0.0001")$ par exemple).
][
  ```python
Y0 = np.array([0.0001, 0.0001, 0.0001])
  ```
]

#question(coups-de-pouce: (
  "Quelle relation relie la période des oscillations à $R$ et $C$ lorsque la condition d'existence d'oscillations sinusoïdales est satisfaite ?",
))[
    Définir tf pour observer une dizaine d'oscillations.
][
  $T=(2 pi) /omega = 2 pi R C$
  ```python
tf = 10 * 2 * np.pi * R * C
  ```
]

#question(coups-de-pouce: (
  "`solution.y[0]` correspond à $u$ et `solution.y[1]` à $v$.",
))[
    Tracer $u$ et $v$ en fonction du temps.
][
  ```python
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp

solution = solve_ivp(F, (0,tf), Y0)
plt.plot(solution.t, solution.y[0], label='u(t)')
plt.plot(solution.t, solution.y[1], label='v(t)')
plt.xlabel('Temps (s)')
plt.ylabel('Tension (V)')
plt.legend()
plt.show()
  ```
]

#question(coups-de-pouce: (
  "Changer les valeurs de $R_1$ et $R_2$ et lancer la simulation. Vérifier que des oscillations apparaissent seulement si la condition de démarrage des oscillations vue en cours est vérifiée.",
))[
  Vérifier la condition de démarrage des oscillations.
][
  Le filtre de Wien atténue d'un facteur $3$ à $omega_0 = 1\/(R C)$ : les oscillations démarrent si l'amplificateur compense au moins cette atténuation, soit $1 + R_2\/R_1 > 3$, c'est-à-dire $R_2 > 2 R_1 = qty("2000", "O")$.

  En relançant la simulation à $R_1$ fixé :
  - $R_2 = qty("1900", "O")$ (gain $2{,}9$) : l'amplitude décroit, l'oscillateur ne démarre pas ;
  - $R_2 = qty("2100", "O")$ (gain $3{,}1$) : l'amplitude croit exponentiellement.

  Le seuil observé est en fait très légèrement supérieur à $qty("2000", "O")$ : à $omega_0$, la bande passante finie de l'ALI abaisse le gain de $1+R_2\/R_1$ à $(1+R_2\/R_1)\/sqrt(1+(omega_0 (1+R_2\/R_1) tau\/A_0)^2)$. Avec les valeurs choisies, le gain de $3{,}000$ obtenu à $R_2 = qty("2000", "O")$ ne suffit pas tout à fait et l'amplitude décroit encore ; il faut $R_2 gt.tilde qty("2002", "O")$.
]

#question(coups-de-pouce: (
  "Il faut que la condition d'oscillation soit satisfaite.",
  "Mesurer la période des oscillations sur le graphe. Est-ce compatible avec la pulsation vue en cours ?"
))[
  Vérifier la valeur de la période des oscillations.
][
  Le filtre de Wien n'a un déphasage nul qu'à $omega_0 = 1\/(R C)$ : c'est la seule pulsation à laquelle la condition de bouclage peut être satisfaite. La période attendue vaut donc
  $ T = (2 pi)/omega_0 = 2 pi R C = 2 pi times 1000 times 10 dot 10^(-9) = #qty("63", "us") $
  soit une fréquence de $#qty("16", "kHz")$. On la retrouve sur le graphe en mesurant l'écart entre deux maximums successifs.
]

Dans la suite, on souhaite se passer de la fonction `solve_ivp` et implémenter nous-même la méthode d'Euler.

On note $Y_i=Y(i dot Delta t)$ où $Delta t$ est la durée entre deux échantillons (période d'échantillonnage).

#question(coups-de-pouce: (
  "Utiliser la définition de $Y_(i+1)$ puis la relation de Taylor à l'ordre 1.",
))[
  Dans le cas général, exprimer $Y_(i+1)$ en fonction de $Y_i$, de $i$, $Delta t$ et de la fonction $F$.
][
  $Y_(i+1) = Y_i + Delta t dot F(i dot Delta t, Y_i)$
]

#question(coups-de-pouce: ())[
  Implémenter la méthode d'Euler pour simuler l'évolution des tensions pour un oscillateur de Wien. $Delta t$ sera choisi de sorte qu'il y ait environ $200$ échantillons par période.
][
  Le schéma d'Euler explicite n'est stable que si $Delta t$ est petit devant la plus courte constante de temps du système. Ici la plus rapide n'est pas la période d'oscillation mais le pôle de l'ALI, $A_0 \/ ((1+R_2\/R_1) tau)$ : à $50$ échantillons par période la simulation diverge. Il en faut environ $120$ au minimum, d'où le choix de $200$.
  ```python
Delta_t = (2 * np.pi * R * C) / 200
N = int(tf / Delta_t)
t = np.zeros(N)
Y = np.zeros((N,3))
t[0] = 0
Y[0] = Y0
for i in range(1,N):
    Y[i] = Y[i-1] + Delta_t * F(t[i-1], Y[i-1])
    t[i] = t[i-1] + Delta_t
```
]

#question(coups-de-pouce: ())[
  Adapter le code précédent pour prendre en compte la saturation de l'ALI.
][
  Il ne suffit pas d'écrêter $v$ après chaque pas : l'expression de $dv(w,t)$ a été obtenue en y *substituant* $dv(v,t)$ du régime linéaire, et cette substitution n'est plus valable dès que l'ALI sature. Il faut calculer $dv(v,t)$ d'abord — nul quand la sortie est bloquée — puis l'injecter dans $dv(w,t)$.

  Il faut aussi simuler plus longtemps : partant de $qty("1e-4", "V")$, il faut une quarantaine de périodes pour atteindre la saturation.
  ```python
def F_sat(t, Y):
  u,v,w = Y
  dv = A0/tau * u - 1/((1+R2/R1)*tau/A0) * v
  if (v >= Vsat and dv > 0) or (v <= -Vsat and dv < 0):
      dv = 0 # la sortie de l'ALI est bloquée, elle ne varie plus
  return np.array([w, dv, -u/(R*C)**2 - 3/(R*C) * w + dv/(R*C)])

tf = 60 * 2 * np.pi * R * C
Delta_t = (2 * np.pi * R * C) / 200
N = int(tf / Delta_t)
t = np.zeros(N)
Y = np.zeros((N,3))
t[0] = 0
Y[0] = Y0
for i in range(1,N):
    Y[i] = Y[i-1] + Delta_t * F_sat(t[i-1], Y[i-1])
    Y[i][1] = min(max(Y[i][1], -Vsat), Vsat)
    t[i] = t[i-1] + Delta_t
```
  En régime établi, $v$ est un signal carré à $plus.minus V_"sat"$ et $u$, filtré par le pont de Wien, reste quasi sinusoïdal d'amplitude $approx qty("5.5", "V")$.
]

]