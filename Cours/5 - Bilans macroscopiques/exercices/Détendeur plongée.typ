#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Détendeur de plongée",
)

Un détendeur de plongée est un dispositif qui permet de réduire la pression de l'air comprimé contenu dans une bouteille de plongée (#qty("200", "bar")) avant qu'il n'arrive au plongeur.

Cette détente est faire de façon adiabatique au travers d'un étranglement étroit sans pièce mobile.

L'écoulement de l'air dans le détendeur est stationnaire, lent et horizontal

#figure(
    image("../images/P-h-air.png", width: 100%),
    caption: [Diagramme (P,h) de l'air.],
    placement: auto,
)

#question(
    coups-de-pouce: "Utiliser le premier principe industriel.",
)[
    Montrer que la détente de l'air dans le détendeur est isentropique.
][
    D'après le premier principe industriel,
    $
        Delta (h+e_c+e_p) = w_u + q
    $
    - l'écoulement est lent donc $e_c approx 0$
    - l'écoulement est horizontal donc $Delta e_p approx 0$
    - la détente est adiabatique donc $q = 0$
    - il n'y a pas de travail utile (pas de pièce mobile) donc $w_u = 0$

    On en déduit que $Delta h = 0$ donc la détente est isenthalpique.
]

#question(
    coups-de-pouce: (
        "Placer l'état initial sur le diagramme (P,h)",
        "Quelle est l'allure d'une isenthalpe sur le diagramme (P,h) ?",
    ),
)[
    Déterminer une plage de température pour l'air à la sortie du détendeur si la température initiale est de #qty("20", "Celsius").
][
    On place le point initial sur l'isotherme #qty("20", "Celsius") du diagramme (P,h) à la pression #qty("200", "bar"). On suit l'isenthalpe (verticale sur un diagramme $(P,h)$) vers le bas jusqu'à la pression de sortie (environ #qty("1", "bar")). On se trouve entre les isothermes #qty("0", "Celsius") et #qty("-20", "Celsius"), donc
    $
        T_s in [#qty("0", "Celsius"), #qty("-20", "Celsius")]
    $
]

#question()[
    L'air peut-il être considéré comme un gaz parfait dans ces conditions ?
][
    Pour un gaz parfait, l'enthalpie ne dépend que de la température, donc une transformation isenthalpique est aussi isotherme. Or ici, la température diminue fortement lors de la détente, donc l'air ne peut pas être considéré comme un gaz parfait dans ces conditions.
]

Ce n'est pas confortable pour un plongeur de respirer un air si froid. Pour paler ce problème, la détente est en réalité réalisée en trois étapes :
- détente isenthalpique dans un premier détendeur au niveau de la bouteille pour atteindre une pression de #qty("10", "bar"),
- réchauffage isobare de l'air jusqu'à #qty("20", "Celsius") par échange avec l'eau
- détente adiabatique dans un second détendeur jusqu'à la pression ambiante au niveau du masque du plongeur.

Toutes les étapes sont faites de façon stationnaires, lentes et horizontales.

#question[
    Représenter la transformation globale sur le diagramme $(P,h)$. Estimer la température de l'air à la sortie du second détendeur.
][
    Le point de départ est le même que précédemment : le point de l'isotherme #qty("20", "Celsius") à la pression #qty("200", "bar"). On descend verticalement jusqu'à la pression #qty("10", "bar") (première détente isenthalpique), puis on se déplace horizontalement vers la droite  jusqu'à l'isotherme #qty("20", "Celsius") (réchauffage isobare), enfin on descend verticalement jusqu'à la pression ambiante (seconde détente isenthalpique).

    A la pression finale, les isotherme sont régulièrement espacées, on peut lire directement la température de l'air à la sortie du second détendeur : elle est d'environ #qty("18", "Celsius").
]

Un plongeur respire en moyenne #qty("15", "L/min") d'air à la pression ambiante au niveau de son masque.

#let Dm = 1 / 0.8 * 15 / 1e3 / 60
#question[
    Quel est la masse volumique de l'air arrivant au plongeur ? Calculer le débit massique d'air dans le système de détente.
][
    L'isochore la plus proche du point final sur le diagramme $(P,h)$ correspond à un volume masse d'environ #qty("0.8", "m^3/kg"), soit une masse molaire de
    $
        mu approx 1/0.8 approx #qty(scientifique(1 / 0.8, 2), "kg/m^3")
    $
    $
        D_m = mu D_v = #qty(scientifique(Dm, 1), "kg/s")
    $
]

#question[
    Calculer la puissance échangée avec l'eau lors du réchauffage (2e étape).
][
    Lors du réchauffage, la variation d'enthalpie massique est lue à environ #qty("30", "kJ/kg").
    
    Le PPI s'écrit
    $
        P_"th" = D_m Delta h = #qty(scientifique(30e3*Dm,1), "W")
    $
]

#question[
    Le diamètre intérieur des tuyaux du détendeur est de #qty("1", "cm"). Calculer la vitesse débitante de l'air à la sortie de la bouteille (avant le premier détendeur).
][
    En sortie de bouteille, on lit sur le diagramme $(P,h)$ un volume massique d'environ #qty("0.004", "m^3/kg"), soit une masse volumique de
    $
        mu approx 1 / 0.004 = #qty(scientifique(1 / 0.004, 1), "kg/m^3")
    $

    La vitesse débitante est
    $
        v = D_m / (mu pi d^2/4) = #qty(scientifique(Dm /(1/0.004 * calc.pi * calc.pow(0.01/2, 2)), 1), "m/s")
    $
]