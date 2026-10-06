#import "@local/prepa:0.1.1": *

#show: TP.with(
    titre: "Oscillateur à relaxation",
)

#préparatoire()[
    Lire l'énoncé du TP et effectuer l'@application-R1-R2.
]

#matériel(
    groupe: (
        [Oscilloscope],
        [Platine d'essai et fils de connexion],
        [Résistors disponibles dans la salle de TP],
        [Boite à décades de condensateurs],
        [ALI et alimentation symétrique $plus.minus #quan[15 V]$],
        [Interrupteurs à bouton-poussoir],
    ),
    classe: (
        [Amplificateur musical ou haut-parleur et amplificateur],
    ),
)

= Introduction

L'objectif de ce TP est de réaliser et d'étudier un oscillateur à relaxation. La période des oscillations sera vérifiée ainsi que l'amplitude des signaux. Un synthétiseur rudimentaire sera enfin réalisé en assemblant les oscillateurs des différents groupes.

= Oscillateur

Dans le montage de l'oscillateur à relaxation, l'intégrateur sera réalisé avec une résistance $R=#quan[10 kΩ]$ et une boite à décades de condensateurs.

#application()[
    Choisir des valeurs pour $R_1$ et $R_2$ compatibles avec les contraintes de l'ALI et permettant une oscillation de l'oscillateur à relaxation.

    Quelles amplitudes peut-on attendre pour les deux signaux de l'oscillateur à relaxation ? On précisera comment calculer l'incertitude associée à l'amplitude de la tension triangulaire, en supposant connues les incertitudes sur les résistances et sur la tension de saturation.
]<application-R1-R2>

#évaluation(
    barème: (
        ([Pas de saturation en courant.], 2),
        ([Condition d'oscillation.], 2),
        ([2 amplitudes.], 3),
        ([Propagation des incertitudes.], 3),
    ),
)[
    Choix de $R_1$ et $R_2$. Valeurs attendues des amplitudes.
]

#manipulation()[
    Réaliser l'oscillateur à relaxation sur une platine d'essai.

    Régler la boite à décades de condensateurs pour obtenir une fréquence de #quan[440 Hz]. Cette capacité est-elle cohérente avec la valeur attendue ?
]

#évaluation(
    appel-prof: true,
    barème: (
        ([Alimentation des ALI.], 1),
        ([Masses.], 2),
        ([Connexions.], 1),
        ([Capacité attendue.], 2),
        ([Incertitude.], 2),
        ([Conclusion.], 2),
    ),
)[
    L'enseignant vérifie les branchements. Le groupe présente sa réponse à la question.
]

#manipulation()[
    Quelles sont les formes des deux signaux ? En changeant la capacité, visualiser l'effet de la vitesse de balayage sur la forme des signaux.

    Mesurer les amplitudes des signaux de l'oscillateur à relaxation. Sont-elles compatibles avec les valeurs attendues ?
]
#évaluation(
    appel-prof: true,
    barème: (
        ([Formes des signaux.], 1),
        ([Mise en évidence de l'effet de la vitesse de balayage.], 2),
        ([Mesure des 2 amplitudes.], 1),
        ([Estimation des incertitudes expérimentales.], 2),
        ([Estimation des incertitudes sur les valeurs attendues.], 2),
        ([Conclusion.], 2),
    ),
)[
    Présenter les formes des signaux observés, les effets de la vitesse de balayage, les mesures des amplitudes et votre réponse à la dernière question.
]

= Réalisation d'un synthétiseur

Les oscillateurs réalisés par tous les groupes seront assemblés à la paillasse du professeur pour former un synthétiseur. Chaque oscillateur fera une note que le groupe devra régler en ajustant la valeur de $C$.

#manipulation[
    En concertation avec les autres groupes, choisir une note et accorder l'oscillateur à la bonne fréquence.

    Assembler les oscillateurs pour former le synthétiseur. La sortie formant un signal créneau sera envoyée à l'amplificateur à travers une résistance de #quan[10 kΩ] et un bouton-poussoir.
]

#show: appendix

= Correspondance note -- fréquence
#let correspondance = (
    ("Do3", "261.63"),
    ("Ré3", "293.66"),
    ("Mi3", "329.63"),
    ("Fa3", "349.23"),
    ("Sol3", "392.00"),
    ("La3", "440.00"),
    ("Si3", "493.88"),
    ("Do4", "523.25"),
)

#figure(
    table(
        columns: correspondance.len(),
        ..for (note, _) in correspondance {
            (note,)
        },
        ..for (_, freq) in correspondance {
            (zi.Hz(freq),)
        }
    ),
)
