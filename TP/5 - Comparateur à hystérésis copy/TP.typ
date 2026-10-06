#import "@local/prepa:0.1.1": *

#show: TP.with(
    titre: "Comparateur à hystérésis",
)

#préparatoire()[
    Lire l'énoncé du TP et effectuer l'@application-R2 et l'@application-protocole.
]

#matériel(
    groupe: (
        "Oscilloscope et GBF",
        "Platine d'essai et fils de connexion",
        "Résistances disponibles dans la salle de TP",
        [ALI et alimentation symétrique $plus.minus #quan[15 V]$],
        [Thermistance],
        [Sonde différentielle],
    ),
)

= Introduction

L'objectif de ce TP est de réaliser et d'étudier un comparateur à hystérésis. On cherchera notamment à tracer son cycle d'hystérésis et à vérifier la valeur de la tension de commutation.

= Cycle d'hystérésis

Le montage comparateur à hystérésis positif sera réalisé avec une résistance de $R_1=#quan[1 kΩ]$.

#application()[
    Le GBF peut délivrer une amplitude maximale de #quan[20 V] crête à crête. Choisir une valeur de $R_2$ de sorte qu'une commutation du comparateur à hystérésis soit possible.
]<application-R2>

#application()[
    Concevoir un protocole permettant d'observer le cycle d'hystérésis sur l'oscilloscope en mode XY. Le réglage des appareils (forme d'onde, amplitude, fréquence, échelle verticale et horizontale de l'oscilloscope) doit être précisé.
]<application-protocole>

#évaluation(
    barème: (
        ([Le protocole donne envie d'être lu.], 2),
        ([Il y a un protocole étape par étape qu'un technicien\ pourrait suivre sans prendre d'initiative.], 3),
        ([Les réglages du GBF sont pertinents.], 3),
        ([Les réglages de l'oscilloscope sont pertinents.], 2),
    ),
)[
    Le protocole est évalué.
]

#manipulation()[
    Réaliser le comparateur à hystérésis sur une platine d'essai.

    Observer le cycle d'hystérésis sur l'oscilloscope.
]

#manipulation()[
    Mesurer la tension de saturation haute de l'ALI. Mesurer la tension de commutation haute du comparateur à hystérésis.

    La tension de commutation est-elle compatible avec la valeur attendue ?
]

#évaluation(
    appel-prof: true,
    barème: (
        ([Lecture sur l'oscilloscope.], 3),
        ([Incertitudes sur la valeur expérimentale.], 3),
        ([Incertitudes sur la mesure attendue.], 1),
        ([Le z-score est calculé.], 2),
        ([Conclusion.], 1),
    ),
)[
    Présenter votre mesure de la tension de commutation. 
]

= Impédance d'entrée

En mesurant la tension aux bornes de $R_1$ et en utilisant la loi d'Ohm, on peut avoir accès au courant rentrant dans le montage.

Rappel : pour mesurer une tension sans imposer de masse, il est possible d'utiliser par exemple une sonde différentielle.

#manipulation()[
    Calculer l'impédance d'entrée du montage. Est-elle compatible avec la valeur attendue ?
]

= Réalisation d'un thermostat

Une application courante du comparateur à hystérésis est la réalisation d'un thermostat : lorsque la température descend en dessous d'un seuil, le chauffage s'allume, et lorsqu'elle dépasse un autre seuil, le chauffage s'éteint.

On peut mesurer la température à l'aide d'une thermistance : un résistor dont la résistance varie en fonction de la température. En plaçant la thermistance dans un pont diviseur de tension, on obtient une tension dépendant de la température, qui peut être utilisée comme entrée du comparateur à hystérésis.

#manipulation()[
    Réaliser un pont diviseur de tension avec la thermistance entre les tensions #quan[15 V] et #quan[-15 V]. Choisir la valeur du second résistor de manière à obtenir une commutation du comparateur à hystérésis lorsqu'on fait chauffer la thermistance avec la main.
]


#show: appendix
