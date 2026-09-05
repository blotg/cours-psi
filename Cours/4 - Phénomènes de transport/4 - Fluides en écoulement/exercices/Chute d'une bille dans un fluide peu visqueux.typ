#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Chute d'une bille dans un fluide peu visqueux",
    numérique: true,
    difficulté: 1
)

On lâche sans vitesse initiale une bille sphérique de rayon $R$, de masse $m$, dans un fluide peu visqueux, de masse volumique $mu$ très faible devant celle de la bille, et de viscosité cinématique $nu$.

On suppose la pesanteur uniforme, et on note $va(v)(t) = -v(t) ez$ la vitesse de la bille, $v(t)$ désignant sa norme.

On suppose que le nombre de Reynolds est compris entre #num("2e3") et #num("2e5"). Dans ce cas, le coefficient de trainée d'une sphère est $C_x = #num("0.47")$.

#question(
    coups-de-pouce: (
        "Que vaut le maitre-couple pour une sphère de rayon $R$ ?",
    ),
)[
    Exprimer la force de frottement fluide sur la bille.
][
    $ va(F_x) = 1/2 mu pi R^2 C_x v^2 ez $
]

#question(
    coups-de-pouce: (
        "Faire le bilan des forces agissant sur la bille.",
    ),
)[
    Établir l'équation différentielle vérifiée par $v(t)$.
][
    Le théorème de la résultante cinétique appliqué à la bille et projeté sur $ez$ s'écrit
    $
        m dv(v, t) = -m g + 1/2 mu pi R^2 C_x v^2
    $
]

#question(
    coups-de-pouce: "Comment se simplifie l'équation différentielle en régime stationnaire ?",
)[
    Établir l'expression de la vitesse limite $v_"lim"$ atteinte par la bille.
][
    L'équation différentielle possède une solution particulière constante :
    $ 1/2 mu pi R^2 C_x v^2 = m g $
    $ v = sqrt((2 m g)/(mu pi R^2 C_x)) $
]

#question(
    coups-de-pouce: (
        "Isoler la dérivée de la vitesse dans l'équation différentielle.",
    ),
)[
    On cherche à résoudre numériquement l'équation différentielle pour obtenir $v(t)$.

    Compléter le code Python suivant pour simuler la chute de la bille.

    ```python
    from math import pi
    from scipy.integrate import solve_ivp
    R = 0.01  # rayon de la bille en m
    m = 0.1   # masse de la bille en kg
    mu = 1    # masse volumique du fluide en kg/m^3
    Cx = 0.47 # coefficient de trainée
    g = 9.81  # accélération due à la pesanteur en m/s^2

    def dvdt(t, v): # renvoie la dérivée de la vitesse
        ...

    v0 = 0  # vitesse initiale en m/s

    sol = solve_ivp(dvdt, (0,10), [v0])
    t = sol.t
    v = sol.y[0]
    ```
][
    ```python
    def dvdt(t, v):
        return (-m * g + 1/2 * mu * pi * R**2 * Cx * v**2) / m
    ```
]

#question[
    Tracer la vitesse de la bille en fonction du temps.
][
    ```python
    import numpy as np
    import matplotlib.pyplot as plt
    plt.plot(t, v)
    plt.xlabel('Temps (s)')
    plt.ylabel('Vitesse (m/s)')
    plt.title("Chute d'une bille dans un fluide peu visqueux")
    plt.show()
    ```
]

#question(
    coups-de-pouce: (
        "Que vaut le nombre de Reynolds aux premiers instants du mouvement ?",
    ),
)[
    Expliquer pourquoi la modélisation proposée pose problème aux premiers instants du mouvement.
][
    Au début de la chute, la vitesse est très faible, ce qui conduit à un nombre de Reynolds faible. Dans ce régime, le coefficient de frottement n'est pas constant.
]

#question(
    coups-de-pouce: (
        "On peut utiliser la compréhension de liste : `L[:,:]` par exemple pour prendre toutes les lignes et toutes les colonnes d'un tableau `L`.",
        "Rappeler l'expression du nombre de Reynolds en fonction de la vitesse.",
        "Rappeler l'expression de la force de trainée en fonction du coefficient de trainée.",
    ),
)[
    Des relevés expérimentaux du coefficient de trainée en fonction du nombre de Reynolds sont donnés dans un fichier téléchargeable à l'adresse suivante

    #lien("https://nuage03.apps.education.fr/index.php/s/APPGg6586cnHELy")

    Compléter le code Python suivant pour calculer la force de trainée à partir de ces données expérimentales.
    ```python
    import numpy as np

    data = np.loadtxt('Cx-Re.csv', delimiter=',', skiprows=1)

    Re_exp = ... # première colonne de data
    Cx_exp = ... # deuxième colonne de data

    eta = 1.85e-5  # viscosité dynamique de l'ai en Pa.s

    def Fx(v):
        Re = ...
        Cx = np.interp(Re, Re_exp, Cx_exp) # interpolation du coefficient de trainée à partir des données expérimentales
        return ...
    ```
][
    ```python
    Re_exp = data[:, 0]
    Cx_exp = data[:, 1]

    def Fx(v):
        Re = (2 * R * mu * v) / eta
        Cx = np.interp(Re, Re_exp, Cx_exp)
        return 1/2 * mu * pi * R**2 * Cx * v**2
    ```
]

#question(
    coups-de-pouce: (
        "Seule la fonction `dvdt` doit être modifiée pour prendre en compte la nouvelle expression de la force de trainée.",
    ),
)[
    Modifier le code de la question 4 pour prendre en compte cette nouvelle expression de la force de trainée, et tracer la vitesse de la bille en fonction du temps.
][
    ```python
    def dvdt(t, v):
        return (-m * g + Fx(v)) / m
    ```
    ```python
    import numpy as np
    import matplotlib.pyplot as plt
    plt.plot(t, v)
    plt.xlabel('Temps (s)')
    plt.ylabel('Vitesse (m/s)')
    plt.title("Chute d'une bille dans un fluide peu visqueux")
    plt.show()
    ```
]
