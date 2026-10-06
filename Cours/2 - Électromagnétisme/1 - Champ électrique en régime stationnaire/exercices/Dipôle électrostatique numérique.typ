#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Dipôle électrostatique : calcul numérique",
    difficulté: 0,
    numérique: true,
    capytale: "408f-12077872",
)

Un dipôle est constitué d'une charge $q = #quan[1 nC]$ au point $A$ de coordonnées $(a/2, 0, 0)$ et d'une charge $-q$ au point $A'$ de coordonnées $(-a/2, 0, 0)$, avec $a = #quan[1 cm]$. On souhaite calculer numériquement le potentiel puis le champ électriques créés par le dipôle dans tout l'espace, et les représenter.

#question(coups-de-pouce: (
    "Quelles sont les invariances de la distribution de charges ?",
    "Par quelle transformation peut-on amener un point $M$ quelconque de l'espace dans le plan $(O x y)$ ?",
))[
    Justifier qu'il suffit de connaitre le potentiel et le champ électriques dans le plan $(O x y)$ pour les connaitre dans tout l'espace.
][
    La distribution de charges est invariante par toute rotation autour de l'axe $(O x)$, qui porte les deux charges.

    Le plan $(O x y)$ contient les deux charges : c'est un plan de symétrie de la distribution, donc en tout point de ce plan, $va(E)$ est contenu dans le plan. Il suffit de calculer ses composantes $E_x$ et $E_y$.
]

#question(coups-de-pouce: (
    "Quel est le potentiel créé par une charge ponctuelle ?",
    "Quel théorème permet d'additionner les potentiels créés par les deux charges ?",
    "Exprimer les distances $d = A M$ et $d' = A' M$ en fonction de $x$, $y$ et $a$.",
))[
    En utilisant l'expression connue du potentiel créé par une charge ponctuelle, exprimer le potentiel $V(x, y)$ créé par le dipôle en un point $M(x, y, 0)$ du plan $(O x y)$, en fonction de $q$, $a$, $epsilon_0$, $x$ et $y$. On prend le potentiel nul à l'infini.
][
    Une charge ponctuelle $q_i$ crée à la distance $d_i$ le potentiel $q_i \/ (4 pi epsilon_0 d_i)$. D'après le théorème de superposition :
    $ V(x, y) = q/(4 pi epsilon_0) (1/d - 1/d') quad "avec" quad d = sqrt((x - a/2)^2 + y^2) quad "et" quad d' = sqrt((x + a/2)^2 + y^2) $
]

#question(coups-de-pouce: (
    "La racine carrée s'écrit `np.sqrt(...)` et le carré `**2`.",
))[
    Compléter la fonction `potentiel(x, y)`, qui renvoie le potentiel créé par le dipôle au point $(x, y)$ du plan $(O x y)$.
    ```python
    import numpy as np
    import matplotlib.pyplot as plt

    epsilon_0 = 8.85e-12  # permittivité du vide en F/m
    q = 1e-9              # charge en C
    a = 1e-2              # distance entre les charges en m

    def potentiel(x, y):
        """Potentiel créé par le dipôle au point (x, y) du plan (Oxy)."""
        d = ...        # distance AM
        d_prime = ...  # distance A'M
        return ...
    ```
][
    ```python
    def potentiel(x, y):
        d = np.sqrt((x - a / 2)**2 + y**2)
        d_prime = np.sqrt((x + a / 2)**2 + y**2)
        return q / (4 * np.pi * epsilon_0) * (1 / d - 1 / d_prime)
    ```
]

Pour représenter le potentiel, on le calcule aux points d'une grille du plan $(O x y)$. `X, Y = np.meshgrid(x, y)` construit cette grille à partir des tableaux `x` et `y` des abscisses et des ordonnées : `X` et `Y` sont deux tableaux à deux dimensions qui contiennent les coordonnées de tous les points de la grille. Les opérations de numpy s'appliquent aussi bien à des nombres qu'à des tableaux : `potentiel(X, Y)` renvoie directement le tableau des potentiels aux points de la grille.

La fonction `plt.contour(X, Y, V, levels=...)` trace les lignes de niveau du tableau `V`, c'est-à-dire ici les équipotentielles, pour les valeurs données par `levels`.

#question(coups-de-pouce: (
    "Une seule ligne est à compléter : la fonction `potentiel` accepte des tableaux.",
    "En un point du plan $x = 0$, comparer les distances $d$ et $d'$.",
))[
    Compléter le programme ci-dessous pour tracer les équipotentielles dans le plan $(O x y)$. Quelle équipotentielle sépare les deux charges ? Justifier sa valeur à l'aide de l'expression de $V$.
    ```python
    x = np.linspace(-2 * a, 2 * a, 300)
    X, Y = np.meshgrid(x, x)  # grille de 300 × 300 points
    V = ...  # potentiel aux points de la grille
    # équipotentielles de -1000 V à 1000 V, tous les 100 V ; coordonnées en mm
    plt.contour(X * 1e3, Y * 1e3, V, levels=np.linspace(-1000, 1000, 21), cmap='coolwarm')
    plt.colorbar(label="V (V)")
    plt.xlabel("x (mm)")
    plt.ylabel("y (mm)")
    plt.axis('scaled')
    plt.show()
    ```
][
    ```python
    V = potentiel(X, Y)
    ```
    Les équipotentielles entourent les charges : le potentiel est positif autour de $A$ (charge $q$) et négatif autour de $A'$ (charge $-q$). Le plan $x = 0$ sépare les deux charges : c'est l'équipotentielle $V = 0$. En effet, tout point de ce plan est à égale distance des deux charges : $d = d'$, donc $V = 0$.
]

Pour calculer le champ $va(E) = - grad V$, on approxime les dérivées partielles du potentiel par des différences finies, avec un pas $h$ très petit devant $a$.

#question(coups-de-pouce: (
    "Écrire la formule de Taylor à l'ordre 2 pour $V(x + h, y)$, puis pour $V(x - h, y)$.",
    "Soustraire les deux développements : les termes en $h^2$ se compensent.",
))[
    À l'aide de développements de Taylor de $V(x + h, y)$ et $V(x - h, y)$, établir l'approximation
    $ pdv(V, x)(x, y) approx (V(x + h, y) - V(x - h, y))/(2 h) $
    Donner l'approximation analogue de $pdv(V, y)$.
][
    La formule de Taylor à l'ordre 2 donne
    $
        V(x + h, y) & = V(x, y) + h pdv(V, x)(x, y) + h^2/2 pdv(V, x, 2)(x, y) + o(h^2) \
        V(x - h, y) & = V(x, y) - h pdv(V, x)(x, y) + h^2/2 pdv(V, x, 2)(x, y) + o(h^2)
    $
    En soustrayant ces deux relations, $V(x + h, y) - V(x - h, y) = 2 h pdv(V, x)(x, y) + o(h^2)$, d'où l'approximation demandée en divisant par $2 h$. De même :
    $ pdv(V, y)(x, y) approx (V(x, y + h) - V(x, y - h))/(2 h) $
]

#question(coups-de-pouce: (
    "En coordonnées cartésiennes, $va(E) = - grad V$ s'écrit $E_x = - pdv(V, x)$ et $E_y = - pdv(V, y)$.",
    "La fonction `potentiel` peut être appelée en n'importe quel point, par exemple `potentiel(x + h, y)`.",
    "En $O$, chacune des deux charges crée un champ de norme $q \/ (4 pi epsilon_0 (a\/2)^2)$. Quel est son sens ?",
))[
    Compléter la fonction `champ(x, y)`, qui renvoie les composantes du champ électrique au point $(x, y)$ du plan $(O x y)$. Calculer numériquement le champ en $O$ et le comparer à celui qu'on obtient en superposant les champs créés par les deux charges.
    ```python
    h = 1e-6  # pas de dérivation en m, très petit devant a

    def champ(x, y):
        """Composantes (Ex, Ey) du champ électrique au point (x, y) du plan (Oxy)."""
        Ex = ...
        Ey = ...
        return Ex, Ey

    print(champ(0, 0))
    ```
][
    ```python
    def champ(x, y):
        Ex = - (potentiel(x + h, y) - potentiel(x - h, y)) / (2 * h)
        Ey = - (potentiel(x, y + h) - potentiel(x, y - h)) / (2 * h)
        return Ex, Ey
    ```
    Le programme affiche $E_x approx #quan[-7.19e5 V/m]$ et $E_y = 0$.

    En $O$, la charge $q$ placée en $A$ crée un champ dirigé de $A$ vers $O$, selon $-va(e_x)$, et la charge $-q$ placée en $A'$ un champ dirigé de $O$ vers $A'$, lui aussi selon $-va(e_x)$. Les deux ont la même norme, donc
    $ va(E)(O) = - 2 q/(4 pi epsilon_0 (a\/2)^2) va(e_x) = - (2 q)/(pi epsilon_0 a^2) va(e_x) approx #quan[-7.19e5 V/m] va(e_x) $
    Le calcul numérique redonne bien ce résultat.
]

La fonction `plt.streamplot(X, Y, Ex, Ey)` trace les lignes de champ d'un champ de vecteurs plan dont on connait les composantes `Ex` et `Ey` aux points de la grille `X, Y`.

#question(coups-de-pouce: (
    "Comme `potentiel`, la fonction `champ` accepte des tableaux.",
    "Revoir le lien entre cartes de champ et cartes de potentiel établi dans le cours.",
))[
    Compléter le programme ci-dessous pour superposer les lignes de champ aux équipotentielles. D'où partent et où aboutissent les lignes de champ ? Comment sont-elles disposées par rapport aux équipotentielles ? Vers où pointe le champ ?
    ```python
    Ex, Ey = ...  # champ aux points de la grille
    plt.contour(X * 1e3, Y * 1e3, V, levels=np.linspace(-1000, 1000, 21), cmap='coolwarm')
    plt.streamplot(X * 1e3, Y * 1e3, Ex, Ey)
    plt.xlabel("x (mm)")
    plt.ylabel("y (mm)")
    plt.axis('scaled')
    plt.show()
    ```
][
    ```python
    Ex, Ey = champ(X, Y)
    ```
    Les lignes de champ partent de la charge positive $q$, en $A$, et aboutissent à la charge négative $-q$, en $A'$. Elles sont orthogonales aux équipotentielles, et le champ pointe vers les potentiels décroissants. Il est plus intense là où les équipotentielles sont resserrées, au voisinage des charges et entre elles.
]
