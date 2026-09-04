#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Simulation numérique d'un oscillateur de Wien",
    numérique: true,
    difficulté: 1,
)

Dans cet exercice, on cherche à simuler numériquement l'évolution des tensions dans l'oscillateur de Wien à l'aide de la méthode d'Euler.

On note $s(t)$ la sortie de l'amplificateur non-inverseur et $v(t)$ la tension de sortie du filtre de Wien.

Les fonctions de transfert de l'amplificateur et du filtre sont respectivement :
$
    (S(p))/(V(p)) & = 1 + R_2/R_1 \
      V(p)/(S(p)) & = (1/3)/(1 + 1/3 (R C p + 1/(R C p)))
$

#question()[
    Montrer que la sortie $s(t)$ de l'amplificateur non-inverseur vérifie l'équation différentielle
    $
        dv(s, t, 2) +(2-R_2/R_1)/(R C) dv(s, t) + 1/(R C)^2 s(t) = 0
    $
][
    La première fonction de transfert donne simplement
    $
        s(t) = (1 + R_2/R_1) v(t)
    $

    La seconde peut se réécrire
    $
        (1 + 1/3 (R C p + 1/(R C p))) V(p) = 1/3 S(p)
    $
    soit, en multipliant par $3 R C p$
    $
        3 R C p V(p) + (R C p)^2 V(p) + V(p) = R C p S(p)
    $
    ce qui donne en temporel
    $
        3 R C dv(v, t) + (R C)^2 dv(v, t, 2) + v(t) = R C dv(s, t)
    $
]

La méthode d'Euler ne s'applique qu'à des équations différentielles du premier ordre. Il est alors nécessaire de transformer ces équations en équations d'ordre 1. Pour cela, on introduit $s_p = dv(s, t)$ et $v_p = dv(v, t)$.

#question(
    coups-de-pouce: 
    "Introduire $v_p$ et $s_p$ dans l'équation différentielle obtenue à la question précédente."
)[
    Montrer que les deux équations de la question précédente peuvent se réécrire sous la forme suivante :
    $
        cases(
            s = (1 + R_2/R_1) v(t),
            dv(s, t)= s_p (t),
            dv(v, t) = v_p (t),
            dv(v_p, t) = -3/(R C) v_p (t) - 1/(R C)^2 v(t) + 1/(R C) s_p (t)
        )
    $
][
    L'équation différentielle de la question précédente peut se réécrire
    $
      dv(v,t,2) = -3/(R C) dv(v,t) - 1/(R C)^2 v(t) + 1/(R C) dv(s,t)
    $
    soit, en remplaçant avec $v_p$ et $s_p$
    $
      dv(v_p, t) = -3/(R C) v_p (t) - 1/(R C)^2 v(t) + 1/(R C) s_p (t)
    $
    Les trois autres sont simplement des définitions de $s_p$ et $v_p$ et de la relation entre $s$ et $v$ vue à la question précédente.
]

Pour résoudre numériquement ces équations, la méthode d'Euler consiste à discrétiser le temps en intervalles de durée $Delta t$ et à approximer les dérivées par des différences finies (relation de Tailor).

On note $s_i = s(i times Delta)$ ; $v_i = v(i times Delta t)$ ; $s_(p,i) = s_p (i times Delta t)$ et $v_(p,i) = v_p (i times Delta t)$.

#question(
    coups-de-pouce:(
        "La relation de Taylor stipule que $s(t + Delta t) approx s(t) + Delta t dv(s, t)$.",
        "Transformer la relation de Taylor en relation de récurrence en utilisant la définition de $s_i$, $v_i$, $s_(p,i)$ et $v_(p,i)$."
    )
)[
    Montrer que $s_i$, $v_i$, $s_(p,i)$ et $v_(p,i)$ vérifient les relations de récurrence suivantes :
    $
        cases(
            s_(p,i) = (s_i - s_(i-1)) / (Delta t),
            v_(p,i) = v_(p,i-1) + Delta t (-3/(R C) v_(p,i-1) - 1/(R C)^2 v_(i-1) + 1/(R C) s_(p,i)),
            v_i = v_(i-1) + Delta t v_(p,i-1)
        )
    $
]

#question(
    coups-de-pouce: (
        "A quelle période oscille l'oscillateur de Wien lorsque la condition d'oscillation est satisfaite ?",
        "Utiliser les relations de récurrence obtenues à la question précédente."
    )
)[
    Compléter le code suivant permettant de simuler numériquement l'évolution des tensions dans l'oscillateur de Wien.
    ```python
    import numpy as np

    R1 = 1000# Ohm
    R2 = 2001# Ohm
    C = 1E-6# F
    R = 1000# Ohm

    T = ...# s période présumée

    Dt = T/100# s pas de temps
    tmax = 100*T# s durée de la simulation

    N = int(tmax//dt)# nombre de points de la simulation

    t = np.linspace(0,tmax, N)# tableau des temps
    v = np.zeros(N)# V tableau des tensions v
    vp = np.zeros(N)# V/s dérivée de v
    s = np.zeros(N)# V tableau des tensions s
    sp = np.zeros(N)# V/s dérivée de s

    v[0] = 0.1 # petite perturbation initiale

    for i in range(1,N):# Calcul de s et v au cours du temps grâce à la méthode d'Euler
        s[i] = (1+R2/R1)*v[i-1]
        sp[i] = ...
        vp[i] = ...
        v[i] = ...
    ```
][
    ```python
    import numpy as np

    R1 = 1000# Ohm
    R2 = 2001# Ohm
    C = 1E-6# F
    R = 1000# Ohm

    T = 2*np.pi*R*C# s période présumée

    Dt = T/100# s pas de temps
    tmax = 100*T# s durée de la simulation

    N = int(tmax//dt)# nombre de points de la simulation

    t = np.linspace(0,tmax, N)# tableau des temps
    v = np.zeros(N)# V tableau des tensions v
    vp = np.zeros(N)# V/s dérivée de v
    s = np.zeros(N)# V tableau des tensions s
    sp = np.zeros(N)# V/s dérivée de s

    v[0] = 0.1 # petite perturbation initiale

    for i in range(1,N):# Calcul de s et v au cours du temps grâce à la méthode d'Euler
        s[i] = (1+R2/R1)*v[i-1]
        sp[i] = (s[i] - s[i-1])/dt
        vp[i] = vp[i-1] + dt*(-3/(R*C)*vp[i-1] - 1/(R*C)**2*v[i-1] + 1/(R*C)*sp[i])
        v[i] = v[i-1] + dt*vp[i-1]
    ```
]

La saturation de l'amplificateur n'a pas encore été prise en compte. Une vérification doit être introduite entre les lignes 24 et 25 du code précédent pour s'assurer que la tension de sortie de l'amplificateur ne dépasse pas la tension de saturation $V_"sat"$.

#question(
    coups-de-pouce: (
        "La tension de sortie de l'amplificateur ne peut pas dépasser la tension de saturation $V_\"sat\"$. Si c'est le cas dans la simulation, il faut la ramener à $V_\"sat\"$.",
    )
)[
    Compléter les lignes à introduire entre les lignes 24 et 25 du code précédent pour prendre en compte la saturation de l'amplificateur.
    ```python
    if s[i] > Vsat :
        s[i] = ...
    elif s[i] < -Vsat :
        s[i] = ...
    ```
][
    ```python
    if s[i] > Vsat :
        s[i] = Vsat
    elif s[i] < -Vsat :
        s[i] = -Vsat
    ```
]

On souhaite maintenant visualiser les résultats de la simulation. Pour cela, on peut utiliser la bibliothèque matplotlib pour tracer les tensions $s(t)$ et $v(t)$ en fonction du temps.

#question()[
    Compléter le code suivant pour tracer les tensions $s(t)$ et $v(t)$ en fonction du temps.
    ```python
    import matplotlib.pyplot as plt

    plt.figure(1)
    plt.clf()
    plt.plot(..., label='s(t)')
    plt.plot(..., label='v(t)')
    plt.xlabel('Temps (s)')
    plt.ylabel('Tension (V)')
    plt.legend()
    plt.grid()
    plt.show()
    ```
][
    ```python
    import matplotlib.pyplot as plt

    plt.figure(1)
    plt.clf()
    plt.plot(t, s, label='s(t)')
    plt.plot(t, v, label='v(t)')
    plt.xlabel('Temps (s)')
    plt.ylabel('Tension (V)')
    plt.legend()
    plt.grid()
    plt.show()
    ```
]

En théorie, on s'attend à ce que la tension $v$ soit "plus sinusoïdale" que la tension $s$. Pour vérifier cela, on peut effectuer une transformée de Fourier sur les signaux simulés et comparer les spectres obtenus.

Le code suivant permet de calculer et de tracer les spectres des signaux $s(t)$ et $v(t)$.

```python
vTF = np.abs(np.fft.rfft(v)) # calcul du spectre de v
vTF = vTF/vTF.max() # normalisation du spectre pour pouvoir le comparer à celui de s
sTF = np.abs(np.fft.rfft(s)) # calcul du spectre de s
sTF = sTF/sTF.max() # normalisation
fréquences = np.fft.rfftfreq(N, dt) # calcul des fréquences associées aux spectres

plt.figure(2)
plt.clf()
plt.plot(fréquences, sTF, label="spectre de s")
plt.plot(fréquences, vTF, label="spectre de v")
plt.legend())
plt.xlabel("fréquence (Hz)")
plt.ylabel("spectre (sans unité)")
plt.show()
```

#question()[
    Parmi les deux signaux, lequel a des harmoniques les plus grandes ? Est-ce conforme à ce que l'on attendait ? Quel est l'impact de $1+R_2/R_1$ sur le spectre ?
][
    Le spectre de $s$ a des harmoniques plus grandes que celui de $v$. Cela est conforme à ce que l'on attendait, car la tension $v$ est filtrée par le filtre de Wien, ce qui réduit les harmoniques.
    
    Plus $1+R_2/R_1$ est grand, plus les harmoniques de $s$ et $v$ sont importantes et plus les signaux s'éloignent de sinusoïdes.
]
