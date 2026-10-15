#import "@local/prepa:0.1.1": *

#show: TP.with(
    titre: "Modulation d'amplitude",
)

#préparatoire()[
    Lire l'énoncé du TP et ses annexes et effectuer l'@application-multiplieur, l'@application-amplitudes, l'@application-filtres-démodulation et l'@application-détecteur.
]

#matériel(
    groupe: (
        [Oscilloscope et 2 GBF],
        [Platine d'essai et fils de connexion],
        [Résistors, condensateurs et diodes disponibles dans la salle de TP],
        [Diode],
        [2 multiplieurs et alimentation symétrique $plus.minus #quan[15 V]$],
        [Microphone et haut-parleur],
        [2 amplificateurs],
    ),
)

= Introduction

L'objectif de ce TP est de moduler un signal en amplitude puis de le démoduler avec deux techniques : démodulation synchrone et détection d'enveloppe. La modulation et la démodulation seront enfin appliquées à un signal sonore.

= Modulation d'un signal

Le signal à transmettre sera dans un premier temps un signal triangulaire de fréquence #quan[440 Hz]. La porteuse aura une fréquence de #quan[50 kHz].

Les multiplieurs utilisés en TP ont 5 entrées (qu'on peut mettre à $0$ si nécessaire) notées $x_1$, $x_2$, $y_1$, $y_2$ et $z$ et une sortie $s=k(x_1-x_2)(y_1-y_2)+z$ avec $k=#quan[0.1 /V]$.

#application()[
    À quoi relier (porteuse, signal à transmettre ou masse) les entrées du multiplieur pour que sa sortie soit un signal modulé en amplitude ?
]<application-multiplieur>

#application()[
    Choisir une amplitude pour le signal à transmettre de sorte à avoir un signal modulé qui ne soit pas surmodulé.

    Le multiplieur a une tension de saturation de #quan[13 V] environ. Choisir une amplitude pour la porteuse de façon à éviter la saturation.
]<application-amplitudes>

#évaluation(
    barème: (
        ([Connexions du multiplieur.], 4),
        ([Pas de surmodulation.], 3),
        ([Pas de saturation.], 3),
    ),
)[
    Réponses *écrites* à l'@application-multiplieur et l'@application-amplitudes.
]

#manipulation()[
    Réaliser le montage permettant la modulation en amplitude du signal triangulaire.

    Sur l'oscilloscope, observer le signal à transmettre, le signal modulé en amplitude et leur spectre (voir @annexe-spectre). Les fréquences présentes dans le spectre du signal modulé sont-elles conformes à ce qui est attendu ?
]

#évaluation(
    appel-prof: true,
    barème: (
        ([Échelles verticale et horizontale de l'oscilloscope.], 2),
        ([Trigger.], 3),
        ([Tracé du spectre lisible.], 2),
        ([Commentaire sur les fréquences présentes dans le spectre.], 3),
    ),
)[
    L'enseignant dérègle l'oscilloscope. Un membre du groupe règle l'oscilloscope pour observer les signaux en temporel, éventuellement complété par l'autre.

    L'autre élève règle l'oscilloscope pour observer le spectre des signaux et commente les fréquences présentes.
]

= Démodulation synchrone

La démodulation synchrone sera réalisée avec le second multiplieur suivi des filtres adéquats. Les deux filtres seront des filtres RC du premier ordre (voir @annexe-composants).

#application()[
    On ne tiendra compte que des 3 premières harmoniques $3$ du signal triangulaire. Proposer des montages (valeurs des composants incluses) pour les filtres. L'intensité du courant de saturation du multiplieur est du même ordre de grandeur que celle de l'ALI TL081.
]<application-filtres-démodulation>

#évaluation(
    barème: (
        ([Nature des filtres.], 2),
        ([Conditions sur la fréquence de coupure du filtre 1.], 2),
        ([Conditions sur la fréquence de coupure du filtre 2.], 2),
        ([Fréquences présentes dans le spectre.], 2),
        ([Plage des résistances.], 1),
        ([Adaptation d'impédance.], 1),
    ),
)[
    Réponses *écrites* à l'@application-filtres-démodulation.
]

#manipulation()[
    Réaliser la démodulation synchrone.

    Observer le spectre des signaux en sortie du multiplieur et des filtres placés après. Sont-ils conformes aux prévisions ? Le signal démodulé est-il fidèle au signal à transmettre ?
]

= Démodulation par détection d'enveloppe

La détection d'enveloppe utilise le montage ci-dessous, appelé détecteur d'enveloppe, branché directement à la sortie du multiplieur de modulation. Lorsque $1/f >> R C >> 1/f_p$, le signal $u(t)$ suit l'enveloppe du signal modulé.

#figure(
    circuit({
        import zap: *
        import cetz.draw: *
        set-style(padding: .4em)
        diode("D", (0, 0), (2.2, 0), label: $D$, variant: "ieee")
        resistor("R", "D.out", (rel: (0, -2.5)), label: (content: $R$, anchor: "south"))
        capacitor("C", (rel: (2, 0), to: "D.out"), (rel: (0, -2.5)), label: (content: $C$, anchor: "south"))
        wire("D.out", "C.in")
        wire("R.out", "C.out")
        frame("G", "R.out")
        content("D.in", $s_"AM" (t)$, anchor: "east", padding: .3em)
        content("C.in", $u(t)$, anchor: "west", padding: .3em)
    }),
    caption: [Détecteur d'enveloppe.],
)

#application()[
    Proposer des valeurs de $R$ et $C$.

    Quelle opération reste-t-il à effectuer sur $u$ pour retrouver le signal à transmettre ? Proposer un montage (avec la valeur des composants) permettant de réaliser cette opération.
]<application-détecteur>

#évaluation(
    barème: (
        ([Choix de $R C$.], 3),
        ([Opération à effectuer sur $u$.], 3),
        ([Montage après le détecteur d'enveloppe.], 2),
        ([Valeur des composants du montage après le détecteur d'enveloppe.], 2),
    ),
)[
    Réponses *écrites* à l'@application-détecteur.
]

#manipulation()[
    Réaliser le détecteur d'enveloppe et observer simultanément le signal modulé et le signal démodulé.
]


= Essais avec un signal sonore réel

Le signal à transmettre est désormais le signal délivré par le microphone.

#manipulation()[
    Remplacer le GBF qui délivrait le signal triangulaire par le microphone. Brancher l'amplificateur et le haut-parleur à la sortie du montage effectuant la démodulation. En fonction du microphone choisi, une pré-amplification, entre le microphone et le montage de modulation, peut être nécessaire.
]


#show: appendix

= Tracé de spectre avec l'oscilloscope<annexe-spectre>

Les oscilloscopes numériques utilisés en TP permettent de calculer le spectre des signaux mesurés. Pour cela, il faut accéder au menu math et, dans "opération", sélectionner "FFT" pour afficher le spectre du signal. Les options permettent de choisir une échelle linéaire (et non logarithmique), plus proche des spectres tracés en cours.

Pour zoomer sur le spectre, on peut soit paramétrer le calcul du spectre pour n'en afficher qu'une partie, soit augmenter la durée par carreaux#footnote[Le nombre de points acquis par l'oscilloscope étant constant, augmenter la durée d'acquisition diminue la fréquence d'échantillonnage. Sur le spectre, $f_e/2$ est la fréquence maximale représentable qui se retrouve à droite de l'écran dans les réglages par défaut.] en dézoomant l'axe du temps.

= Composants disponibles dans la salle de TP<annexe-composants>

#grid(
    columns: 2,
    column-gutter: 2em,
    figure(
        {
            let L = (4.7, 10., 12., 22., 33.)
            let résistances = ()

            for i in range(5) {
                for n in L {
                    résistances.push(n * calc.pow(10, i))
                }
            }

            import "@preview/zero:0.7.0": *
            table(
                columns: 5,
                ..for n in résistances {
                    ([#num(n)],)
                }
            )
        },
        caption: [Résistances des résistors disponibles dans la salle de TP (en #unit("O"))],
    ),
    figure(
        table(
            columns: 5,
            quan[100 pF], quan[400 pF], quan[1 nF], quan[2.2 nF], quan[4.7 nF],
            quan[10 nF], quan[22 nF], quan[100 nF], quan[220 nF], quan[470 nF],
        ),
        caption: [Capacités des condensateurs disponibles dans la salle de TP],
    ),
)
