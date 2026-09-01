#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Simulation de la température dans le sol",
    numérique: true,
)

Dans le sol, la température vérifie une équation de diffusion de coefficient de diffusion $D approx qty("1e-6", "m^2/s")$. Les données à la surface sont acquises régulièrement par des stations météorologiques. Les données pour Quimper sont disponibles à l'adresse suivante : https://nuage03.apps.education.fr/index.php/s/LgXjiwkxJxcrZmz. Le temps est donné en secondes depuis le 1er janvier 1970 à 00:00:00 UTC. La température est donnée en degrés Celsius. Les mesures sont effectuées toutes les heures.

On peut importer les données dans Python grâce aux instructions suivantes
```python
import numpy as np
data = np.load("test.npy")
t = data[:,0] # temps en secondes
Tz0 = data[:,1] # température à la surface (en z=0) en degrés Celsius
```

#question()[
    Tracer la température à la surface en fonction du temps.
][
    ```python
    import matplotlib.pyplot as plt
    plt.figure("Température à la surface")
    plt.plot(t, Tz0)
    plt.show()
    ```
]

On souhaite simuler la température dans le sol sur une profondeur de #qty("10", "m") à l'aide de la méthode d'Euler explicite généralisée aux équations aux dérivées partielles.

La température à l'instant $t_i = t_0 + i Delta t$ à la profondeur $z_j = j Delta z$ est notée $T_(i,j)$. On choisit #num("101") points de profondeur.

#let D = 1e-6
#let dt = 3600
#let dz = 10 / 100

#question(
    coups-de-pouce: (
        "Considérons les valeurs (0,2,4). Combien y a-t-il de valeurs ? Quel pas sépare deux valeurs successives ? Quelle est l'étendue totale entre la première et la dernière valeur ? Quel lien relie le pas, l'étendue et le nombre de valeurs ?"
    )
)[
    Calculer le pas de profondeur $Delta z$. La condition de stabilité de la méthode d'Euler $2 D Delta t / Delta z^2 < 1$ est-elle vérifiée ?
][
    Le pas de profondeur est donné par $Delta z = 10 / 100 = #qty("0.1", "m")$.

    $
        2 D (Delta t) / (Delta z^2) = #num("1e-6") times #num("3600") / #num("0.1")^2 = #num(scientifique(2 * D * dt / calc.pow(dz, 2), 2)) < 1
    $
    La condition de stabilité est bien vérifiée.
]

#question(
    coups-de-pouce: (
        "Appliquer la formule de Taylor à l'ordre 2 à $T_(i,j+1)$ et $T_(i,j-1)$.",
        "Combiner les deux relations de Taylor pour exprimer $pdv(T,x,2)$.",
        "Si les indices ne correspondent pas à ce que l'on cherche, faire un changement d'indice pour trouver la relation demandée."
    )
)[
    Exprimer $T_(i,j)$ en fonction de $T_(i-1,j)$, $T_(i-1,j-1)$, $T_(i-1,j+1)$, D, $Delta x$ et $Delta t$ grâce à la méthode d'Euler explicite.
][
    L'équation de diffusion est de la forme $pdv(T, t) = D pdv(T, z, 2)$.
    $
        T_(i,j+1) = T(t_0, j Delta z) approx T_(i,j) + Delta z pdv(T,z) + (Delta z^2) / 2 pdv(T, z, 2)\
        T_(i,j-1) = T(t_0, j Delta z) approx T_(i,j) - Delta z pdv(T,z) + (Delta z^2) / 2 pdv(T, z, 2)
    $
    D'où
    $
      T_(i,j-1) + T_(i,j+1) approx 2 T_(i,j) + Delta z^2 pdv(T, z, 2)
    $
    Et donc
    $
      pdv(T, z, 2) approx (T_(i,j-1) + T_(i,j+1) - 2 T_(i,j)) / (Delta z^2)
    $
    Pour la dérivée temporelle, on a
    $
      T_(i+1,j) = T(t_0 + (i+1) Delta t, j Delta z) approx T_(i,j) + Delta t pdv(T, t)\
      approx T_(i,j) + Delta t D pdv(T,z,2)\
      approx T_(i,j) + (Delta t)/(Delta z^2) D (T_(i,j-1) + T_(i,j+1) - 2 T_(i,j))
    $
    L'énoncé demande $T_(i,j)$, on fait donc le changement d'indice $i -> i-1$ : 
    $
      T_(i,j)  approx T_(i-1,j) + (Delta t)/(Delta z^2) D (T_(i-1,j-1) + T_(i-1,j+1) - 2 T_(i-1,j))
    $
]

#question(
    coups-de-pouce: (
        "La température à la surface est contenue dans la variable `Tz0`."
    )
)[
    Compléter le code suivant implémentant la méthode d'Euler explicite pour simuler la température dans le sol.
    ```python
    Nx = ... # nombre de pas de profondeur
    L = 10 # longueur de la colonne de sol simulée (en m)
    x = np.linspace(..., ..., ...) # liste des profondeurs des points simulés (en m)

    T = np.zeros((Nt,Nx)) + Tz0[0] # initialisation de la matrice de température
    dt = 3600 # pas de temps (en s)
    dx = L/(Nx-1) # pas de profondeur (en m)
    D = 1e-6 # coefficient de diffusion (en m^2/s)
        
    for i in range(1, Nt):
        T[i,0] = ... # condition à la surface
        for j in range(1, Nx-1):
            T[i,j] = ... # schéma d'Euler explicite
        T[i,-1] = T[i,-2] # le dernier point n'a pas de voisin de droite, on ne peut pas appliquer
                          # le schéma d'Euler explicite, on reprend la température du point
                          # précédent (condition de Neumann)
    ```
][
    ```python
    Nx = 101
    L = 10
    x = np.linspace(0, L, Nx)

    T = np.zeros((Nt,Nx)) + Tz0[0]
    dt = 3600
    dx = L/(Nx-1)
    D = 1e-6
        
    for i in range(1, Nt):
        T[i,0] = Tz0[i]
        for j in range(1, Nx-1):
            T[i,j] = D * dt/dx**2 * T[i-1,j+1] + D * dt/dx**2 * T[i-1,j-1] + (1 - 2*D * dt/dx**2) *  T[i-1,j]
        T[i,-1] = T[i,-2]
    ```
]

#question(
    coups-de-pouce: (
        "Quel indice correspond à la profondeur de #qty(\"10\",\"cm\") ? De #qty(\"1\",\"m\") ? De #qty(\"10\",\"m\") ?",
        "On peut utiliser la notation `T[:,j]` pour accéder à toutes les lignes d'une colonne `j` et `T[i,:]` pour accéder à toutes les colonnes d'une ligne `i`."
    )
)[
    Tracer la température en fonction du temps pour des profondeurs de #qty("0","m"), #qty("10","cm"), #qty("1","m") et #qty("10","m").
][
    ```python
    for j in [0, 1, 10, 100]:
        plt.plot(t, T[:,j], label=f"z={x[j]:.2f} m")
    plt.legend()
    plt.show()
    ```
]

#question(
    coups-de-pouce: (
        "On peut commencer par écrire des instructions pour détecter s'il gène pour une profondeur $z_j$.",
        "On parcourt une colonne de `T`. Si tous les éléments sont positifs, alors il ne gèle jamais à cette profondeur. Sinon, il gèle au moins une fois à cette profondeur.",
    )
)[
    Écrire une suite d'instruction permettant de calculer à quelle profondeur minimale faut-il enterrer une conduite d'eau pour qu'elle ne subisse pas le gel. 
][
    ```python
    for j in range(Nx):
        gèle = False
        for i in range(Nt):
            if T[i,j] < 0:
                gèle = True # il gèle au moins une fois à la profondeur x[j]
                break # on passe au tour de boucle suivant
        if not gèle: # on a trouvé une profondeur où il ne gèle jamais
            break # on s'arrête, pas la peine d'étudier les profondeurs suivantes
    print(x[j])
    ```
]

#question()[
    Compléter le code ci-dessus pour animer la propagation de l'onde dans un plasma. La fonction `line.set_data` prend les mêmes arguments que la fonction `plot` : les abscisses et les ordonnées des points à tracer.

    ```python
    import matplotlib.animation as animation
    from datetime import datetime, timezone

    def formateDate(t): # met en forme le temps pour afficher la date et l'heure
        return datetime.fromtimestamp(t, tz=timezone.utc).strftime("%d/%m/%Y %H:%M")

    fig, ax = plt.subplots()
    plt.clf()
    ax = fig.add_subplot(111)
    line, = ax.plot(..., ...) # tracé du profil de température à l'instant initial t0
    
    ax.set_ylim(..., ...) # on choisit les limites de l'axe des ordonnées pour que la courbe soit bien visible
    ax.set_xlabel("Profondeur (m)")
    ax.set_ylabel("Température (°C)")
    title = ax.set_title("")

    def animate(i):
        line.set_data(..., ...)  # tracé du profil de température à l'instant initial ti
        title.set_text(formateDate(t[i]))
        return line, title

    ani = animation.FuncAnimation(fig, animate, frames=range(0,Nt,10), interval=10, blit=False, repeat=False)
    plt.show()
    ```
][
    ```python
    import matplotlib.animation as animation
    from datetime import datetime, timezone

    def formateDate(t): # met en forme le temps pour afficher la date et l'heure
        return datetime.fromtimestamp(t, tz=timezone.utc).strftime("%d/%m/%Y %H:%M")

    fig, ax = plt.subplots()
    plt.clf()
    ax = fig.add_subplot(111)
    line, = ax.plot(x, T[0,:])
    
    ax.set_ylim(np.min(T), np.max(T))
    ax.set_xlabel("Profondeur (m)")
    ax.set_ylabel("Température (°C)")
    title = ax.set_title("")

    def animate(i):
        line.set_data(x, T[i,:])
        title.set_text(formateDate(t[i]))
        return line, title

    ani = animation.FuncAnimation(fig, animate, frames=range(0,Nt,10), interval=10, blit=False, repeat=False)
    plt.show()
    ```
]