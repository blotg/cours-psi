#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Piège à neutrons",
    difficulté: 2,
    numérique: true,
    capytale: "4195-11915977",
)

Un piège à neutrons constitué de 6 fils rectilignes infinis, répartis aux sommets d'un hexagone régulier de rayon $a = #quan[1 cm]$ et parcourus par des courants de même intensité $I = #quan[200 A]$, est représenté ci-dessous. Les fils sont numérotés de $0$ à $5$.

#figure(canvas({
    import cetz.draw: *
    let R = 1.5
    // courant vers le lecteur (⊙) ou s'en éloignant (⊗)
    let sortant(p) = {
        circle(p, radius: 0.15, fill: white)
        circle(p, radius: 0.04, fill: black)
    }
    let entrant(p) = {
        circle(p, radius: 0.15, fill: white)
        let d = 0.15 / calc.sqrt(2)
        line((rel: (-d, -d), to: p), (rel: (2 * d, 2 * d)))
        line((rel: (-d, d), to: p), (rel: (2 * d, -2 * d)))
    }
    line((-2.4, 0), (2.4, 0), mark: (end: "stealth", fill: black))
    content((2.4, 0), anchor: "west", padding: 0.1, $x$)
    line((0, -2.1), (0, 2.1), mark: (end: "stealth", fill: black))
    content((0, 2.1), anchor: "south", padding: 0.1, $y$)
    content((0, 0), anchor: "north-west", padding: 0.1, $O$)
    // circle((0, 0), radius: R, stroke: (paint: gray, dash: "dashed"))
    // line(..range(6).map(k => (k * 60deg, R)), close: true, stroke: gray)
    line((0, 0), (120deg, R), stroke: gray, mark: (end: "stealth", fill: gray))
    content((120deg, R / 2), anchor: "north-east", padding: 0.1, text(fill: gray)[$a$])
    for k in range(6) {
        if calc.even(k) { sortant((k * 60deg, R)) } else { entrant((k * 60deg, R)) }
        content((k * 60deg + 15deg, R + 0.35), text(fill: olive, if calc.even(k) [$I$] else [$-I$]))
        content((k * 60deg - 15deg, R + 0.35), text(fill: gray)[#k])
    }
}))

Les fils pairs sont parcourus par un courant selon $ez$ tandis que les fils impairs sont parcourus par un courant dans le sens de $-ez$.

#question(coups-de-pouce: (
    "Commencer par un fil placé à l'origine $O$ et parcouru par un courant $I$ selon $ez$ : le théorème d'Ampère donne $B = (mu_0 I)/(2 pi r)$.",
    "Exprimer $er$ à l'aide de $va(O M)$, puis utiliser $etheta = ez and er$.",
    "Pour un fil placé en $(x_k, y_k)$, translater le repère pour ramener le fil à l'origine.",
    "Le courant du fil $k$ vaut $(-1)^k I$.",
))[
    On considère le fil numéro $k$, dont on note $x_k$ et $y_k$ les coordonnées.

    Montrer que les composantes cartésiennes du champ magnétique créé par ce fil en un point $M(x, y)$ sont
    $
        B_x = - (mu_0 (-1)^k I)/(2 pi) (y - y_k)/((x - x_k)^2 + (y - y_k)^2) quad "et" quad B_y = (mu_0 (-1)^k I)/(2 pi) (x - x_k)/((x - x_k)^2 + (y - y_k)^2)
    $
][
    Le champ magnétique créé par un fil à l'origine du repère parcouru par un courant $I$ s'écrit
    $
        va(B)=(mu_0 I)/(2 pi r) va(e_theta)
    $
    Le vecteur de base $etheta$ doit être exprimé dans la base $ex$, $ey$. On peut pour cela écrire que $etheta = ez and er$ avec $er = va(O M)/norm(va(O M)) = (x va(e_x) + y va(e_y)) / sqrt(x^2 + y^2)$, soit $etheta = - y / sqrt(x^2 + y^2) va(e_x) + x / sqrt(x^2 + y^2) va(e_y)$. On obtient le champ magnétique créé par un fil à l'origine du repère parcouru par un courant $I$ :
    $
        B_x = - (mu_0 I)/(2 pi) y/(x^2 + y^2) quad "et" quad B_y = (mu_0 I)/(2 pi) x/(x^2 + y^2)
    $
    Pour trouver le champ créé par le fil $k$, situé en $(x_k, y_k)$, il suffit de translater le repère pour placer le fil à l'origine, c'est-à-dire remplacer $x$ par $x - x_k$ et $y$ par $y - y_k$ dans les expressions précédentes, et de remplacer $I$ par le courant $(-1)^k I$ du fil $k$ :
    $
        B_x = - (mu_0 (-1)^k I)/(2 pi) (y - y_k)/((x - x_k)^2 + (y - y_k)^2) quad "et" quad B_y = (mu_0 (-1)^k I)/(2 pi) (x - x_k)/((x - x_k)^2 + (y - y_k)^2)
    $
]

#question(coups-de-pouce: (
    "Quel théorème permet d'additionner les champs créés par les six fils ?",
    "Les six fils sont régulièrement répartis sur un cercle de rayon $a$ : quel angle sépare deux fils voisins ?",
))[
    Justifier que les composantes du champ magnétique total en un point $M(x, y)$ s'écrivent
    $
        B_x = - (mu_0 I)/(2 pi) sum_(k=0)^5 (-1)^k (y - y_k)/((x - x_k)^2 + (y - y_k)^2) quad "et" quad B_y = (mu_0 I)/(2 pi) sum_(k=0)^5 (-1)^k (x - x_k)/((x - x_k)^2 + (y - y_k)^2)
    $
    Comment peut-on exprimer les coordonnées $(x_k, y_k)$ des six fils en fonction du rayon $a$ et de $k$ ?
][
    D'après le théorème de superposition, le champ magnétique total en un point $M(x, y)$ est la somme des champs créés par chacun des six fils.

    Deux fils voisins sont séparés d'un angle $2 pi \/ 6 = pi \/ 3$. Le fil $k$ est donc repéré par les coordonnées polaires $(a, k pi \/ 3)$, soit en coordonnées cartésiennes $(x_k, y_k) = (a cos(k pi \/ 3), a sin(k pi \/ 3))$.
]

#question(coups-de-pouce: (
    "Initialiser `Bx` et `By` à 0, puis leur ajouter la contribution de chaque fil dans une boucle `for k in range(6)`.",
    "Dans la boucle, calculer d'abord les coordonnées `xk` et `yk` du fil $k$.",
    "Les opérations de numpy s'appliquent aussi bien à des nombres qu'à des tableaux : écrire les formules comme pour des nombres.",
))[
    Compléter la fonction `champ(x, y)`, qui renvoie les composantes du champ magnétique total en un point $(x, y)$.
    ```python
    import numpy as np
    import matplotlib.pyplot as plt

    mu_0 = 4e-7 * np.pi  # perméabilité du vide en H/m
    a = 1e-2             # rayon de l'hexagone en m
    I = 200              # intensité en A

    def champ(x, y):
        """Composantes (Bx, By) du champ créé en (x, y) par les six fils."""
        ...
        return Bx, By
    ```
][
    ```python
    def champ(x, y):
        Bx, By = 0, 0
        for k in range(6):
            xk = a * np.cos(k * np.pi / 3)
            yk = a * np.sin(k * np.pi / 3)
            Bx += - (-1)**k * mu_0 * I / (2 * np.pi) * (y - yk) / ((x - xk)**2 + (y - yk)**2)
            By += (-1)**k * mu_0 * I / (2 * np.pi) * (x - xk) / ((x - xk)**2 + (y - yk)**2)
        return Bx, By
    ```
]

#question(coups-de-pouce: (
    "Le plan $(O x z)$ contient les fils 0 et 3. Est-ce un plan de symétrie ou d'antisymétrie de la distribution de courant ?",
    "Chercher un second plan du même type passant par $O$.",
))[
    Calculer numériquement le champ au centre $O$. Retrouver ce résultat par un argument de symétrie.
][
    ```python
    print(champ(0, 0))
    ```
    Le champ magnétique au centre $O$ est nul (aux erreurs d'arrondi près).

    Le plan contenant les fils 0 et 3 est un plan de symétrie de la distribution de courant, $va(B)(O)$ lui est orthogonal.

    On peut dire de même pour le plan contenant les fils 1 et 4 et le plan contenant les fils 2 et 5.

    La seule façon pour $va(B)(O)$ d'être orthogonal à ces trois plans de symétrie est d'être nul.
]

La fonction `plt.streamplot(X, Y, Bx, By)` trace les lignes de champ d'un champ de vecteurs plan dont on connait les composantes `Bx` et `By` aux points d'une grille `X, Y`. Une telle grille s'obtient avec `np.meshgrid`.

#question(coups-de-pouce: (
    "Autour de chaque fil, le sens des lignes de champ est donné par la règle de la main droite.",
    "Plus les lignes de champ sont serrées, plus le champ est intense.",
))[
    Compléter le programme ci-dessous pour tracer la carte des lignes de champ, puis la commenter.
    ```python
    x = np.linspace(-1.5 * a, 1.5 * a, 300)
    X, Y = np.meshgrid(x, x)  # grille de 300 × 300 points
    Bx, By = ...
    plt.streamplot(X, Y, Bx, By, density=2)
    plt.axis('equal')
    plt.show()
    ```
][
    ```python
    Bx, By = champ(X, Y)
    ```
    Près de chaque fil, on retrouve le champ créé par ce fil : les lignes de champ sont des cercles centrés sur le fil, parcourus dans le sens trigonométrique autour des fils pairs (courant $I$) et dans le sens horaire autour des fils impairs (courant $-I$).
    
    Au voisinage de $O$, les lignes de champ s'écartent les unes des autres : le champ y est faible, et il s'annule en $O$.
]

Les neutrons ($m = #quan[1.675e-27 kg]$) portent un moment magnétique $mu = #quan[9.7e-27 J/T]$. Placé dans un champ magnétique, un neutron possède l'énergie potentielle magnétique $E_"mag" = mu B$.

La fonction `plt.pcolormesh(X, Y, Z)` représente par des couleurs (carte de chaleur) les valeurs d'un tableau `Z` calculé aux points de la grille `X, Y`. La fonction `plt.colorbar()` affiche l'échelle des couleurs.

#question(coups-de-pouce: (
    "La norme du champ s'obtient avec `np.sqrt(Bx**2 + By**2)`.",
    "Les neutrons se déplacent vers les zones où leur énergie potentielle est la plus faible.",
    "Observer la forme des zones de même couleur autour de $O$.",
))[
    Compléter le programme ci-dessous pour tracer la carte de l'énergie potentielle magnétique $E_"mag"$ des neutrons. Où les neutrons ont-ils tendance à se placer ?
    ```python
    m = 1.675e-27  # masse du neutron en kg
    mu = 9.7e-27   # moment magnétique du neutron en J/T

    B = ...      # norme du champ aux points de la grille
    E_mag = ...  # énergie potentielle magnétique en J
    # coordonnées en mm ; vmax sature les couleurs près des fils, où E_mag diverge
    plt.pcolormesh(X * 1e3, Y * 1e3, E_mag, vmax=1.5e-28)
    plt.colorbar(label="E_mag (J)")
    plt.xlabel("x (mm)")
    plt.ylabel("y (mm)")
    plt.axis('scaled')
    plt.show()
    ```
][
    ```python
    B = np.sqrt(Bx**2 + By**2)
    E_mag = mu * B
    ```
    L'énergie potentielle magnétique est nulle en $O$ et croît quand on s'en éloigne, jusqu'aux fils. Poussés vers les faibles énergies potentielles, les neutrons ont tendance à se placer au voisinage de $O$.
]

On tient maintenant compte de la pesanteur. L'axe $(O y)$ est vertical et orienté vers le haut.

#question(coups-de-pouce: (
    "L'énergie potentielle de pesanteur s'écrit $m g y$ lorsque l'axe $(O y)$ est vertical ascendant.",
    "Comparer la carte à celle de la question précédente : où se trouve maintenant le creux d'énergie potentielle ?",
))[
    Exprimer l'énergie potentielle totale $E_p$ d'un neutron. Compléter le programme ci-dessous pour en tracer la carte, avec ses lignes de niveau (sur lesquelles $E_p$ est constante), puis la commenter.
    ```python
    g = 9.8  # accélération de la pesanteur en m/s²

    E_p = ...  # énergie potentielle totale en J
    plt.pcolormesh(X * 1e3, Y * 1e3, E_p, vmin=-5e-29, vmax=5e-29)
    plt.colorbar(label="E_p (J)")
    plt.contour(X * 1e3, Y * 1e3, E_p, levels=np.linspace(-5e-29, 5e-29, 21), colors='k', linewidths=0.5)
    plt.xlabel("x (mm)")
    plt.ylabel("y (mm)")
    plt.axis('scaled')
    plt.show()
    ```
][
    L'énergie potentielle totale est la somme des énergies potentielles magnétique et de pesanteur : $E_p = mu B + m g y$.
    ```python
    E_p = mu * B + m * g * Y
    ```
    La pesanteur fait croître $E_p$ vers le haut. Le creux d'énergie potentielle n'est plus en $O$ mais un peu en dessous, vers $y approx #quan[-3.6 mm]$ : les lignes de niveau s'y referment. Plus bas, entre les fils 4 et 5, $E_p$ diminue de nouveau : c'est par là que les neutrons pourraient s'échapper.
]

#question(coups-de-pouce: (
    "Une position d'équilibre stable correspond à un minimum local de l'énergie potentielle.",
    "Un minimum sur l'axe $x = 0$ est-il aussi un minimum selon $x$ ? S'aider de la carte de la question précédente.",
))[
    Compléter le programme ci-dessous pour tracer $E_p$ le long de l'axe vertical $x = 0$, pour $y$ entre $-a$ et $a$. Les neutrons ont-ils une position d'équilibre stable ? Le piège confine-t-il les neutrons ?
    ```python
    y = np.linspace(-a, a, 1000)
    Bx, By = champ(0, y)  # points de l'axe x = 0
    E_p = ...
    plt.plot(..., ...)
    plt.xlabel("y (mm)")
    plt.ylabel("E_p (J)")
    plt.grid()
    plt.show()
    ```
][
    ```python
    E_p = mu * np.sqrt(Bx**2 + By**2) + m * g * y
    plt.plot(y * 1e3, E_p)
    ```
    Le long de l'axe, $E_p$ présente un minimum local en $y approx #quan[-3.6 mm]$, suivi d'une barrière en $y approx #quan[-7.5 mm]$. Sur la carte, les lignes de niveau se referment autour de ce point : c'est aussi un minimum selon $x$. C'est donc une position d'équilibre stable : un neutron qui s'en écarte un peu dans le plan $(O x y)$ y est ramené, et le piège le confine dans ce plan. Les fils étant infinis, rien ne le retient en revanche selon $(O z)$.

    Ce n'est pas vrai pour toute intensité : pour $I = #quan[100 A]$, $E_p$ décroit continument quand on descend le long de l'axe. Il n'y a pas de minimum local, et les neutrons tombent entre les fils 4 et 5.
]
