#import "@local/prepa:0.1.1": *

#show: TP.with(
    titre: "Oscillateur de Wien",
)

#préparatoire()[
    Lire l'énoncé du TP et ses annexes et effectuer l'@application-condition-oscillations et l'@application-protocole-démarrage-oscillations.
]

#matériel(
    groupe: (
        "Oscilloscope",
        "Platine d'essai et fils de connexion",
        "Résistances et condensateurs disponibles dans la salle de TP",
        "Boite à décades de résistance",
        [2 ALI et 1 alimentation symétrique $plus.minus #quan[15 V]$],
        "Multimètre de poche"
    ),
)

= Introduction

L'objectif de ce TP est de réaliser et d'étudier un oscillateur de Wien.

= Réalisation et étude préliminaire

Le montage amplificateur non-inverseur sera réalisé avec des condensateur de #quan[100 nF] et des résistances de #zi.kohm("10"), sauf $R_2$ qui sera réalisée par une boite à décade.

#application()[
    A quelle condition s'attend-on à observer des oscillations quasi-sinusoïdales ? Quelle fréquence ont-elle dans ce cas ?

    Les deux réponses seront munies d'une incertitude. Les boites à décade ont une incertitude-type de #quan[5 %].
]<application-condition-oscillations>

#manipulation()[
    Réaliser l'oscillateur de Wien sur une platine d'essai.

    Pour vérifier que le montage est fonctionnel, régler $R_2 = #zi.kohm("22")$, et vérifier que des oscillations apparaissent.
]

= Démarrage des oscillations

En fonction des valeurs de $R_2$, l'oscillateur de Wien peut osciller ou non. Dans cette partie, on cherche la valeur limite de $R_2$ pour laquelle les oscillations commencent.

#application()[
    Rédiger un protocole permettant de mesurer aussi précisément que possible la valeur de $R_2$ pour laquelle les oscillations commencent.
]<application-protocole-démarrage-oscillations>

#manipulation()[
    Mettre en œuvre le protocole. Cette valeur est-elle compatible avec la condition théorique pour l'apparition des oscillations ?
]<manip-démarrage-oscillations>

#évaluation(
    barème: (
        ([Le compte-rendu donne envie d'être lu.], 2),
        ([Il y a un protocole étape par étape qu'un technicien\ pourrait suivre sans prendre d'initiative.], 2),
        ([Les calculs effectués sont détaillés (formules et valeurs).], 2),
        ([Les incertitudes sont prises en considération d'une façon\ ou d'une autre.], 2),
        ([Une conclusion est apportée.], 2),
    ),
)[
    Le cahier de TP sera rendu à la fin de la séance et le compte-rendu *de la @manip-démarrage-oscillations* évalué *par les pairs*.
]

= Fréquence des oscillations quasi-sinusoïdales

Lorsque la condition de démarrage des oscillations est tout juste vérifiée, des oscillations quasi-sinusoïdales peuvent être observées. Leur fréquence dépend des paramètres $R$ et $C$ du filtre de Wien.

#manipulation()[
    Se placer dans des conditions où les oscillations sont quasi-sinusoïdales et mesurer leur fréquence.

    Cette fréquence est-elle compatible avec la fréquence théorique prévue pour les oscillations quasi-sinusoïdales ?
]

= Richesse spectrale

Lorsque $R_2$ dépasse la condition de démarrage des oscillations est dépassée, le signal généré par l'oscillateur de Wien s'éloigne de plus en plus d'une sinusoïde.

#manipulation()[
    Observer le spectre des deux signaux à l'aide de l'oscilloscope. Quelle influence a $R_2$ sur les spectres ? Lequel des deux signaux présente des harmoniques les plus marquées ?
]

#show: appendix

= Tracé de spectre avec l'oscilloscope

Les oscilloscopes numériques utilisés en TP permettent de calculer le spectre des signaux mesurés. Pour cela, il faut accéder au menu math et, dans "opération", sélectionner "FFT" pour afficher le spectre du signal. Les options permettent de choisir une échelle linéaire (et non logarithmique), plus proche des spectres tracés en cours.

Pour zoomer sur le spectre, on peut soit paramétrer le calcul du spectre pour n'en afficher qu'une partie, soit augmenter la durée par carreaux#footnote[Le nombre de points acquis par l'oscilloscope étant constant, augmenter la durée d'acquisition diminue la fréquence d'échantillonnage. Sur le spectre, $f_e/2$ est la fréquence maximale représentable qui se retrouve à droite de l'écran dans les réglages par défaut.] en dézoomant l'axe du temps.
