#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Détermination d'une loi de vitesse",
    numérique: true,
)

La réaction de décomposition du dioxyde d'azote en phase gazeuse a pour équation
$ ce("2 NO2 -> O2 + 2 NO") $
On effectue cette réaction en réacteur ouvert parfaitement agité de volume constant à température constante. On obtient les résultats rassemblés dans le @tab-vitesse pour une concentration d'entrée en dioxyde d'azote de $[ce("NO2")]_e = qty("0.010", "mol/L")$.

#figure(
    table(
        columns: 6,
        align: (left,) + (center,) * 5,
        [$tau$ (#unit("min"))], num("430"), num("160"), num("43"), num("13"), num("2.6"),
        [$[ce("NO2")]_s$ (#unit("mmol/L"))], num("2.0"), num("3.0"), num("5.0"), num("7.0"), num("9.0"),
    ),
    caption: [Concentration de sortie en fonction du temps de passage.],
)<tab-vitesse>


#question(
    coups-de-pouce: (
        "Quel lien y a-t-il entre la quantité de matière de $ce(\"NO2\")$ et l'avancement $xi$ ? Entre la concentration $[ce(\"NO2\")]$ et l'avancement volumique $xi/V$ ?",
        "Faire un tableau d'avancement pour répondre au coup de pouce précédent.",
    ),
)[
    Quel est le lien entre $r_ce("NO2")$, la vitesse volumique d'apparition de $ce("NO2")$ et $r$, la vitesse volumique de réaction ?
][
    $r_ce("NO2") = nu_ce("NO2") r$ d'où
    $
        r = 1/nu_ce("NO2") r_ce("NO2") = -1/2 r_ce("NO2")
    $
]

#question(
    coups-de-pouce: (
        "Faire un bilan de matière sur un système fermé constitué à partir du système ouvert ${\"réacteur\"}$.",
        "Que signifie que la réaction est d'ordre 2 ?",
        "Comme la réaction a un unique réactif, son ordre partiel en #ce(\"NO2\") est l'ordre global.",
    ),
)[
    Montrer que pour une réaction d'ordre 2, on a
    $ln (([ce("NO2")]_e - [ce("NO2")]_s) / tau) = alpha ln[ce("NO2")]_s + B$.
    Que vaut $alpha$ pour une réaction d'ordre 2 ?
][
    On effectue un bilan de matière sur #ce("NO2") dans en régime permanent :
    $
      0 = F_(ce("NO2"),e) - F_(ce("NO2"),s) + V r_ce("NO2") = Q[ce("NO2")]_e - Q[ce("NO2")]_s + V r_ce("NO2")
    $
    Si on suppose la réaction d'ordre 2, c'est-à-dire $r = k [ce("NO2")]^2$ donc $r_ce("NO2") = -2 k [ce("NO2")]^2$, on obtient (on rappelle que la concentration en sortie est la concentration dans le réacteur pour un RPAC)
    $
        0 = Q[ce("NO2")]_e - Q[ce("NO2")]_s - 2 V k [ce("NO2")]_s^2
    $
    En remplaçant $V = tau Q$, on obtient
    $
        [ce("NO2")]_e - [ce("NO2")]_s = 2 tau k [ce("NO2")]_s^2
    $
    En prenant le logarithme de chaque membre, on obtient bien
    $
        ln (([ce("NO2")]_e - [ce("NO2")]_s) / tau) = ln(2 k) + 2 ln[ce("NO2")]_s
    $
    Donc pour une réaction d'ordre 2, $alpha = 2$.
]

#question(
    coups-de-pouce: (
        "Tracer $ln (([ce(\"NO2\")]_e - [ce(\"NO2\")]_s) / tau)$ en fonction de $ln [ce(\"NO2\")]_s)$. Faire une régression linéaire.",
        "Si le modèle d'une réaction d'ordre 2 est bien vérifié, que doit valoir $r^2$ ? Que doit valoir la pente ?",
    ),
)[
    Les résultats expérimentaux sont-ils compatibles avec une cinétique d'ordre 2 ? Calculer la constante de vitesse $k$ à la température de l'expérience.

    On pourra utiliser Python pour tracer la courbe et la fonction `polyfit(x,y,deg)` de la bibliothèque `numpy` qui calcule la régression linéaire de degré `deg` des ordonnées `y` en fonction des abscisses `x` et qui renvoie la liste des coefficients du polynôme ajusté, dans l'ordre décroissant des degrés.
][
    ```python
    import numpy as np
    import matplotlib.pyplot as plt
    tau = np.array([430, 160, 43, 13, 2.6]) * 60  # conversion en secondes
    C_s = np.array([2.0, 3.0, 5.0, 7.0, 9.0]) * 1e-3  # conversion en mol/L
    C_e = 0.010  # mol/L

    x = np.log(C_s)
    y = np.log((C_e - C_s) / tau)
    plt.plot(x, y, "+", label="Données expérimentales")

    coeffs = np.polyfit(x, y, deg=1)
    
    plt.plot(x, coeffs[0] * x + coeffs[1], "-", label="Régression linéaire")
    plt.xlabel("ln([NO2]_s)")
    plt.ylabel("ln(([NO2]_e - [NO2]_s) / tau)")
    plt.legend()
    plt.show()

    print("Pente : ", coeffs[0], " (valeur attendue : 2)")
    k = np.exp(coeffs[1]) / 2
    print("Constante de vitesse k : ", k, " L/mol/s")
    ```
]