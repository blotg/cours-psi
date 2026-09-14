#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Normes électriques",
    difficulté: 2,
    explique: true,
)

Les normes électriques contraignent les longueurs et sections des câbles en fonction de l'usage qui en est fait. Le tableau ci-dessous donne les longueurs maximales recommandées pour des câbles en cuivre, en fonction de la puissance maximale soutirée pour une tension de #quan[230 V].

La norme prévoit une chute de tension maximale de #quan[3 %].

#figure(
    table(
        columns: (auto,) * 7,
        align: center+horizon,
        table.header(
            bdiagbox[Section][Puissance Max],
            quan[529 W],
            quan[1058 W],
            quan[1564 W],
            quan[2070 W],
            quan[2645 W],
            quan[3105 W],
        ),

        quan[0.75 mm^2],
        quan[50 m],
        quan[25 m],
        quan[17 m],
        quan[12 m],
        quan[10 m],
        quan[8 m],

        quan[1 mm^2],
        quan[67 m],
        quan[33 m],
        quan[22 m],
        quan[17 m],
        quan[13 m],
        quan[11 m],

        quan[1.5 mm^2],
        quan[100 m],
        quan[50 m],
        quan[33 m],
        quan[25 m],
        quan[20 m],
        quan[17 m],

        quan[2.5 mm^2],
        quan[167 m],
        quan[84 m],
        quan[57 m],
        quan[43 m],
        quan[34 m],
        quan[29 m],

        quan[4 mm^2],
        quan[265 m],
        quan[135 m],
        quan[90 m],
        quan[68 m],
        quan[54 m],
        quan[45 m],

        quan[6 mm^2],
        quan[395 m],
        quan[200 m],
        quan[130 m],
        quan[100 m],
        quan[80 m],
        quan[66 m],
    ),
)

#question(
    coups-de-pouce: (),
)[
    Expliquer d'où vient ce tableau.
][
    Quand on fait passer un courant dans un câble, il y a une chute de tension due à la résistance du câble.

    La résistance d'un câble est d'autant plus grande que sa section est petite (un gros câble laisse mieux passer le courant) et que sa longueur est grande (plus le courant a de distance à parcourir, plus il y a de pertes).

    La chute de tension dans le câble est d'autant plus grande que la puissance soutirée est grande (car le courant électrique sera plus grand) et que la résistance du câble est grande (un câble bon conducteur aura moins de pertes).

    La longueur du câble si on ne veut pas une chute de tension trop grande est donc limitée par deux facteurs :
    - la puissance soutirée : plus elle est grande, plus la longueur doit être petite pour limiter les pertes.
    - la section du câble : plus elle est faible, plus la résistance est grande et plus il y aura de pertes.
]
