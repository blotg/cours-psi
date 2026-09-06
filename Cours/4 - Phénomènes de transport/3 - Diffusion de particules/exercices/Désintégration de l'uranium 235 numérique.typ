#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Désintégration de l'uranium 235 : résolution numérique",
    difficulté: 1,
    numérique: true,
)

On étudie une boule de rayon $R$ constituée d'uranium 235.

L'uranium 235 n'a pas un noyau stable, celui-ci peut se fissionner en "captant" un neutron selon la réaction nucléaire

#ce[$""^235_92$U] + 1 neutron $->$ #ce("X") + #ce("Y") + $nu$ neutrons

où #ce("X") et #ce("Y") sont deux noyaux plus légers. La valeur moyenne de $nu$ est #num("2.5"). Le nombre de réactions par unité de temps et de volume vaut $n/tau$.

On se place en coordonnées sphériques, note $n(t,r)$ le nombre de neutrons par unité de volume et $va(j)(t,r)$ le vecteur densité de courant de neutrons.

On prend pour condition aux limites $forall t, n(t,r=R)=0$.

#question(
    coups-de-pouce: (
        "Combien de neutrons sont captés durant $dd(t)$ dans le volume considéré ? Combien sont émis ?",
    ),
)[
    En faisant un bilan de neutrons sur un volume mésoscopique, démontrer l'équation aux dérivées partielles vérifiée par $n$ :
    $
        pdv(n, t) = D/r^2 pdv(, r) (r^2 pdv(n, r)) + (nu-1)/tau n
    $
][
    On fait un bilan de neutrons sur une coquille sphérique de rayon intérieur $r$ et d'épaisseur $dd(r)$.
    $dd(N, 2) = delta^2 N$
    $
        dd(N, 2) = pdv(n, t) dd(V) dd(t)
    $
    À chaque fois que la réaction se produit, $nu$ neutrons sont émis et un neutron est capté, donc $nu-1$ neutrons supplémentaires apparaissent. Le nombre de réactions dans le volume élémentaire durant $dd(t)$ est $n/tau dd(V) dd(t)$. Donc
    $
        delta^2 N & = (nu-1)/tau n dd(V) dd(t) + (j(t,r) 4 pi r^2 - j(t,r+dd(r)) 4 pi (r+dd(r))^2) dd(t) \
                  & = (nu-1)/tau n dd(V) dd(t) - 4 pi pdv(, r) (r^2 j(t,r)) dd(r) dd(t) \
    $
    Or $dd(V) = 4 pi r^2 dd(r)$, donc en divisant par $dd(V) dd(t)$ on trouve l'équation
    $
        pdv(n, t) & = (nu-1)/tau n - 1/r^2 pdv(, r) (r^2 j(t,r)) \
    $
    La loi de Fick donne $va(j) = -D grad n = -D pdv(n, r) er$, avec $D$ la diffusivité des neutrons dans l'uranium 235. En remplaçant dans l'équation, on trouve
    $
        pdv(n, t) & = D/r^2 pdv(, r) (r^2 pdv(n, r)) + (nu-1)/tau n \
    $
]

#question(
    coups-de-pouce: (
        "Remplacer $n$ par $y/r$ dans l'équation obtenue précédemment.",
    ),
)[
    On pose $y(t,r) = r n(t,r)$. Montrer que $y$ vérifie l'équation de diffusion
    $
        pdv(y, t) = D pdv(y, r, 2) + (nu-1)/tau y
    $
][
    On remplace $n$ par $y/r$ dans l'équation précédente :
    $
        pdv(y/r, t) & = D/r^2 pdv(, r) (r^2 pdv(y/r, r)) + (nu-1)/tau y/r \
                    & = D/r^2 pdv(, r) (r pdv(y, r) - y) + (nu-1)/tau y/r \
                    & = D/r^2 (pdv(y, r) + r pdv(y, r, 2) - pdv(y, r)) + (nu-1)/tau y/r \
                    & = D/r pdv(y, r, 2) + (nu-1)/tau y/r \
    $
    En multipliant par $r$, on trouve l'équation
    $ pdv(y, t) = D pdv(y, r, 2) + (nu-1)/tau y $
]

#question(
    coups-de-pouce: (
        "La densité particulaire doit rester finie en $r=0$.",
    ),
)[
    Quelles sont les conditions aux limites vérifiées par $y$ en $r=0$ et $r=R$ ?
][
    En $r=0$, la densité particulaire doit rester finie, donc $y(t,0) = 0$.

    En $r=R$, on a la condition aux limites $n(t,R) = 0$, donc $y(t,R) = R n(t,R) = 0$.
]

Pour résoudre numériquement l'équation de diffusion, on discrétise l'espace avec un pas $dd(r)$ et le temps avec un pas $dd(t)$. On note $y_(i,j) = y(i dd(t), j dd(r))$.

#question(
    coups-de-pouce: (
        "Utiliser la relation de Taylor à l'ordre 2 pour approximer $y_(i,j+1)$ et $y_(i,j-1)$. De même, approximer $y_(i+1,j)$ à l'ordre 1.",
    ),
)[
    Établir le schéma d'Euler explicite pour résoudre numériquement l'équation de diffusion vérifiée par $y$ :
    $
        y_(i+1, j) = y_(i, j) + D dd(t)/dd(r)^2 (y_(i, j+1) - 2 y_(i, j) + y_(i, j-1)) + (nu-1)/tau dd(t) y_(i, j)
    $
][
    $y_(i,j+1) = y(i dd(t),j dd(r) + dd(r)) approx y(i dd(t), j dd(r)) + pdv(y, r) dd(r) + 1/2 pdv(y, r, 2) dd(r)^2$

    $y_(i,j-1) = y(i dd(t),j dd(r) - dd(r)) approx y(i dd(t), j dd(r)) - pdv(y, r) dd(r) + 1/2 pdv(y, r, 2) dd(r)^2$

    En additionnant, on trouve
    $y_(i,j+1) - 2y_(i,j) + y_(i,j-1) approx pdv(y, r, 2) dd(r)^2$

    De plus, $y_(i+1,j) = y(i dd(t) + dd(t), j dd(r)) approx y(i dd(t), j dd(r)) + pdv(y, t) dd(t) = y_(i,j) + pdv(y, t) dd(t)$, d'où $pdv(y, t) approx (y_(i+1,j) - y_(i,j))/dd(t)$.

    L'équation de diffusion s'écrit donc
    $
        (y_(i+1,j) - y_(i,j))/dd(t) & = D (y_(i,j+1) - 2 y_(i,j) + y_(i,j-1))/dd(r)^2 + (nu-1)/tau y_(i,j)
    $
    On peut isoler $y_(i+1,j)$ :
    $
        y_(i+1, j) & = y_(i, j) + D dd(t)/dd(r)^2 (y_(i, j+1) - 2 y_(i, j) + y_(i, j-1)) + (nu-1)/tau dd(t) y_(i, j) \
    $
]

#question(
    coups-de-pouce: (
        "On peut utiliser les fonctions np.linspace et np.zeros de la bibliothèque numpy.",
    ),
)[
    Compléter le code Python ci-dessous pour simuler la désintégration de l'uranium 235 dans la boule. On prendra comme condition initiale une densité de neutrons uniforme dans la boule égale à #qty("1e12", "/m^3") (sauf aux conditions aux limites où elle est nulle).
    #show raw.where(block: true): numérote-code
    ```python
    import numpy as np

    R = 0.2 # rayon de la boule en m
    nu = 2.5 # nombre moyen de neutrons émis par fission
    tau = 5.4e-9 # temps moyen entre deux fissions en s
    D = 2e5 # diffusivité des neutrons dans l'uranium 235 en m2/s

    Nx = 50 # nombre d'échantillons spatiaux
    Nt = 1000 # nombre d'échantillons temporels

    dx = ... # pas spatial
    dt = 0.5 * dx**2 / (2*D) # pas temporel (condition de stabilité)

    t = ... # array contenant tous les instants
    r = ... # array contenant toutes les positions

    y = ... # initialisation de la matrice avec des zéros
    y[0,1:-1] = ... # condition initiale : densité uniforme 

    for i in range(0, Nt-1):
        y[i+1, ...] = 0 # condition aux limites en r=0
        y[i+1, ...] = 0 # condition aux limites en r=R
        for j in range(1, Nx-1):
            # schéma d'Euler explicite
            y[i+1,j] = ...
    ```
][
    #show raw.where(block: true): numérote-code
    ```python
    dx = R / (Nx - 1) # pas spatial

    t = np.arange(Nt) * dt # array contenant tous les instants
    r = np.linspace(0, R, Nx) # array contenant toutes les positions

    y = np.zeros( (Nt,Nx) ) # initialisation de la matrice avec des zéros
    y[0,1:-1] = 1e12 * r[1:-1] # condition initiale : densité uniforme 

    for i in range(0, Nt-1):
        y[i+1, 0] = 0 # condition aux limites en r=0
        y[i+1, -1] = 0 # condition aux limites en r=R
        for j in range(1, Nx-1):
            # schéma d'Euler explicite
            y[i+1,j] = y[i,j] + D*dt/dx**2 * (y[i,j+1] - 2*y[i,j] + y[i,j-1]) + (nu-1)/tau * y[i,j] * dt
    ```
]

#question(
    coups-de-pouce: (
        "Utiliser la bibliothèque matplotlib pour tracer les graphiques demandés.",
        "Penser à calculer la densité de neutrons $n$ à partir de $y$ en utilisant la relation $n = y/r$.",
    ),
)[
    Tracer la densité de neutrons en fonction du rayon aux instants $t=0$, $t=t_"max"/4$, $t=t_"max"/2$, $t=3 t_"max"/4$ et $t=t_"max"$ où $t_"max"$ est le temps final de la simulation.
][
    On peut utiliser le code suivant pour tracer la densité de neutrons en fonction du rayon à différents instants :
    #show raw.where(block: true): numérote-code
    ```python
    n = np.zeros_like(y)
    n[:, 1:] = y[:, 1:] / r[1:] # calcul de la densité de neutrons (r[0] = 0)
    n[:, 0] = n[:, 1] # en r=0, n est finie : on prolonge par continuité

    import matplotlib.pyplot as plt
    plt.figure()
    plt.plot(r, n[0,:], label=f't={t[0]:.2e} s')
    plt.plot(r, n[Nt//4,:], label=f't={t[Nt//4]:.2e} s')
    plt.plot(r, n[Nt//2,:], label=f't={t[Nt//2]:.2e} s')
    plt.plot(r, n[3*Nt//4,:], label=f't={t[3*Nt//4]:.2e} s')
    plt.plot(r, n[-1,:], label=f't={t[-1]:.2e} s')
    plt.xlabel('Rayon r (m)')
    plt.ylabel('Densité de neutrons (m$^{-3}$)')
    plt.title("Évolution de la densité de neutrons dans la boule d'uranium 235")
    plt.legend()
    plt.show()
    ```
]

#question(
    coups-de-pouce: ()
)[
    Tracer l'évolution temporelle de la densité de neutrons en $r=R/2$.
][
    #show raw.where(block: true): numérote-code
    ```python
    plt.figure()
    plt.plot(t, n[:, Nx//2])
    plt.xlabel('Temps t (s)')
    plt.ylabel('Densité de neutrons (m$^{-3}$)')
    plt.title("Évolution temporelle de la densité de neutrons en r=R/2")
    plt.show()
    ```
]

#question(
    coups-de-pouce: (
        "Le profil initial n'est pas le mode fondamental : il commence par se déformer, ce qui masque la croissance ou la décroissance exponentielle. Il faut donc simuler assez longtemps.",
    )
)[
    Pour de petites valeurs de $R$, la densité de neutrons tend vers $0$ avec le temps. Pour de grandes valeurs de $R$, la densité de neutrons croît exponentiellement avec le temps. Déterminer la valeur critique de $R$ séparant ces deux comportements. On pourra procéder par essais successifs et on la déterminera à #qty("0.5", "cm") près.
][
    Avec $N_t = #num("1000")$, la simulation ne dure que quelques nanosecondes : le profil initial $y = n_0 r$ n'est pas le mode fondamental $sin(pi r\/R)$, il se déforme d'abord, et cette relaxation masque complètement la tendance exponentielle près du rayon critique. Il faut allonger la simulation, par exemple `Nt = 20000`.

    Pour $R = #qty("0.08", "m")$, la densité de neutrons tend vers $0$ avec le temps.

    Pour $R = #qty("0.09", "m")$, la densité de neutrons croît exponentiellement avec le temps.

    Le rayon critique est situé entre ces deux valeurs : $R_c = #qty("8.5+-0.5", "cm")$, en accord avec la valeur analytique $pi sqrt(D tau\/(nu-1)) = #qty("8.4", "cm")$.
]
