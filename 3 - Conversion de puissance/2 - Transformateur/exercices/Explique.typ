#import "@local/prepa:0.1.0": *
#show: exercice.with(
    titre: "Poste de transformation",
    explique: true,
)

On trouve sur le bord des route des postes de transformation reliant des lignes électriques entre elles.

#figure(
    image("../images/poste source 2.jpg", width: 8cm)
)

#question(
    coups-de-pouce: ()
)[
    Qu'y a-t-il dans un poste de transformation et à quoi ça sert ?
][
    Les lignes électriques ne sont pas toutes aux mêmes tensions. Par exemple, les lignes à haute tension (#qty("400","kV")) sont utilisées pour le transport de l'électricité sur de longues distances, tandis que les lignes basse tension (#qty("230","V")) sont utilisées pour la distribution locale aux foyers et aux entreprises.

    Pour adapter la tension entre deux lignes, on utilise des *transformateurs*. Un transformateur est un cadre métallique sur lequel sont enroulés deux fils. Quand un courant pas dans un des fils, il crée un champ magnétique. Le champ magnétique est guidé par le cadre métallique jusqu'au second fil, où il crée un courant électrique. En jouant sur le nombre d'enroulement des fils autour du cadre métallique, on peut augmenter ou diminuer la tension.
]