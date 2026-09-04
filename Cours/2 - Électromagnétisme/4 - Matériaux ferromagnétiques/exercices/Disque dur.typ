#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Le disque dur",
    explique: true,
)

#question(
    coups-de-pouce: (
        "Faire le lien entre l'hystérésis et la notion de mémoire du matériau.",
        "Faire le lien avec les aimants du quotidien (aimant de réfrigérateur, boussole...).",
    ),
)[
    Comment un disque dur fait-il pour stocker des données ?
][
    Il existe des matériaux qui peuvent être aimantés : lorsqu'ils sont soumis à un champ magnétique, ils restent aimantés même lorsqu'on retire le champ magnétique extérieur. Cet effet "mémoire" (l'état du matériau dépend de sont histoire) est appelé hystérésis.

    Un disque dur est constitué de plusieurs plateaux recouverts d'un matériau ferromagnétique. Une tête de lecture/écriture composée d'une bobine peut se déplacer au dessus de chaque plateau.

    En faisant passer du courant de la bobine de la tête de lecture, celle-ci produit un champ magnétique qui peut aimanter le plateau. En inversant le sens du courant, on inverse le sens de l'aimantation. On peut ainsi stocker un tout petit morceau d'information binaire (0 ou 1) en fonction du sens de l'aimantation locale du plateau.

    Les disques durs contiennent des centaines de milliards de ces zones capables de stocker de petits morceaux d'information, ce qui permet de stocker de grandes quantités de données numériques.
]
