#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Normes électriques",
    difficulté: 2,
    explique: true,
)

Les normes électriques contraignent les longueur et sections des câbles en fonction de l'usage qui en est fait. Le tableau ci-dessous donne les longueurs maximales recommandées pour des câbles en cuivre, en fonction de la puissance maximale soutirée pour une tension de #qty("230", "v").

La norme prévoir une chute de tension maximale de #qty("3", "%").

#figure(
    table(
        columns: (auto,) * 7,
        align: center+horizon,
        table.header(
            bdiagbox[Section][Puissance Max],
            qty("529", "W"),
            qty("1058", "W"),
            qty("1564", "W"),
            qty("2070", "W"),
            qty("2645", "W"),
            qty("3105", "W"),
        ),

        qty("0.75", "mm^2"),
        qty("50", "m"),
        qty("25", "m"),
        qty("17", "m"),
        qty("12", "m"),
        qty("10", "m"),
        qty("8", "m"),

        qty("1", "mm^2"),
        qty("67", "m"),
        qty("33", "m"),
        qty("22", "m"),
        qty("17", "m"),
        qty("13", "m"),
        qty("11", "m"),

        qty("1.5", "mm^2"),
        qty("100", "m"),
        qty("50", "m"),
        qty("33", "m"),
        qty("25", "m"),
        qty("20", "m"),
        qty("17", "m"),

        qty("2.5", "mm^2"),
        qty("167", "m"),
        qty("84", "m"),
        qty("57", "m"),
        qty("43", "m"),
        qty("34", "m"),
        qty("29", "m"),

        qty("4", "mm^2"),
        qty("265", "m"),
        qty("135", "m"),
        qty("90", "m"),
        qty("68", "m"),
        qty("54", "m"),
        qty("45", "m"),

        qty("6", "mm^2"),
        qty("395", "m"),
        qty("200", "m"),
        qty("130", "m"),
        qty("100", "m"),
        qty("80", "m"),
        qty("66", "m"),
    ),
)

#question(
    coups-de-pouce: (),
)[
    Expliquer d'où vient ce tableau.
][
    Quand on fait passer un courant dans un câble, il y a une chute de tension due à la résistance du câble.

    La résistance d'un câble de longueur est d'autant plus grande que sa section est petite (un gros câble laisse mieux passer le courant) et que sa longueur est grande (plus le courant a de distance à parcourir, plus il y a de pertes).

    La chute de tension dans le câble est d'autant plus grande que la puissance soutirée est grande (car le courant électrique sera plus grand) et que la résistance est faible (un cable bon conducteur aura moins de pertes).

    La longueur du cable si on ne veut pas une chute de tension trop grande est donc limitée par deux facteurs :
    - la puissance soutirée : plus elle est grande, plus la longueur doit être petite pour limiter les pertes.
    - la section du câble : plus elle est faible, plus la résistance est grande et plus il y aura de pertes.
]
