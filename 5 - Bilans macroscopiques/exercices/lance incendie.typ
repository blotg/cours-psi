#import "@local/prepa:0.1.0": *

#show: exercice.with(
    titre: "Lance incendie",
    ouvert: true,
)

Les lances incendie sont utilisées pour projeter de l'eau à haute vitesse afin d'éteindre les incendies. Elles sont souvent connectées à des hydrants ou des camions de pompiers. Leur débit peut atteindre plusieurs centaines de litres par minute et générer une poussée importante.

#lien("https://www.youtube.com/shorts/LPro3gg9WgM")

Le coefficient de frottement statique solide tissus/béton est approximativement $f = 0.5$.

#question()[
    Estimer un ordre de grandeur de la vitesse de l'eau en sortie de lance.
][
    La poussée s'exprime comme $F = D_m v$. Juste avant que le pompier ne commence à glisser, la poussée est équilibrée par la force de frottement statique maximale entre ses vêtements et le sol, soit $F_f = f m g$ où $m$ est la masse du pompier et $g$ l'intensité de la pesanteur.

    En égalant les deux expressions, on trouve :
    #let Dm = 300/60
    $
        v = (f m g)/(D_m) = (0.5 times 80 times 9.8)/(300/60) = #qty(scientifique(0.5 * 80 * 9.81 / Dm, 1), "m/s")
    $
]
