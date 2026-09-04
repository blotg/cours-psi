#import "@local/prepa:0.1.1": *

#show: cours.with(infos: yaml("infos.yml"))

#let grandeurs = (
    "s_p": (signification: "la porteuse", unité: unit("V")),
    "A_p": (signification: "l'amplitude de la porteuse", unité: unit("V")),
    "f_p": (signification: "la fréquence de la porteuse", unité: unit("Hz")),
    "phi_p": (signification: "la phase de la porteuse", unité: unit("rad")),
    "s_\"AM\"": (signification: "le signal modulé en amplitude", unité: unit("V")),
    "s": (signification: "le signal à transmettre", unité: unit("V")),
    "k": (signification: "un coefficient positif", unité: unit("/V")),
    "h": (signification: "le taux de modulation", unité: "sans unité"),
    "A_s": (signification: "l'amplitude du signal à transmettre", unité: unit("V")),
    "f_s": (signification: "la fréquence du signal à transmettre", unité: unit("Hz")),
    "f_\"max\"": (
        signification: "la fréquence maximale présente dans le spectre du signal à transmettre",
        unité: unit("Hz"),
    ),
)

#let figure-modulation(titre, f-modulé) = {
    let f-porteuse = 10
    let f-signal = 1
    let tmax = 2 / f-signal
    let modulante(t) = {
        if calc.rem(t, 1 / f-signal) < 1 / (2 * f-signal) { 1 } else { -1 }
    }
    figure(
        canvas({
            plot.plot(
                size: (7, 1.8),
                axis-style: "scientific",
                x-tick-step: none,
                y-tick-step: none,
                x-min: 0,
                x-max: tmax,
                y-min: -1.3,
                y-max: 1.3,
                x-label: [],
                y-label: [signal modulant],
                {
                    plot.add(modulante, domain: (0, tmax), samples: 800, style: (stroke: blue))
                },
            )
            cetz.draw.set-origin((0, -3.2))
            plot.plot(
                size: (7, 1.8),
                axis-style: "scientific",
                x-tick-step: none,
                y-tick-step: none,
                x-min: 0,
                x-max: tmax,
                y-min: -1.3,
                y-max: 1.3,
                x-label: [$t$],
                y-label: [signal modulé],
                {
                    plot.add(
                        t => f-modulé(t, modulante(t)),
                        domain: (0, tmax),
                        samples: 2000,
                        style: (stroke: red),
                    )
                },
            )
        }),
        caption: titre,
    )
}

= Le principe de la modulation
== Présentation
L'objectif de ce chapitre est de comprendre comment un signal peut être transmis sur un canal.

#exemple[Un son, des données numériques, … sont des signaux.]
#exemple[Un câble coaxial, une ligne bifilaire, des ondes électromagnétiques, … sont des canaux.]

La modulation permet de
- transporter plusieurs signaux sur un canal
- adapter la fréquence du signal pour qu'elle soit compatible avec le canal

La modulation consiste à combiner
- le signal qu'on souhaite transmettre
- un signal sinusoïdal dont la fréquence est adaptée au canal, appelé "porteuse"

== Les différents types de modulation

#encadré(
    titre: "Porteuse",
    grandeurs: sub-dictionary(grandeurs, ("s_p", "A_p", "f_p", "phi_p")),
)[
    $
        s_p (t) = A_p cos(2 pi f_p t + phi_p)
    $
]

Les trois types de modulation consistent à faire varier un de ces paramètres au cours du temps.

=== La modulation d'amplitude
La modulation d'amplitude consiste à faire varier l'amplitude de la porteuse : $A_p$ devient $A(t)$.
$
    s_"AM" (t) = A(t) cos(2 pi f_p t + phi_p)
$

#figure-modulation(
    [Signal modulé en amplitude.],
    (t, m) => (1 + 0.3 * m) * calc.cos(2 * calc.pi * 10 * t),
)

#exemple[La radio en mode grandes ondes (GO) utilise la modulation d'amplitude avec une porteuse entre #qty("150", "kHz") et #qty("300", "kHz").]

#flashcard(
    recto: "Application de la modulation d'amplitude.",
    verso: "Radio en mode grandes ondes (GO) avec une porteuse entre $qty(\"150\",\"kHz\")$ et $qty(\"300\",\"kHz\")$.",
)

=== La modulation de fréquence
La modulation de fréquence consiste à faire varier la fréquence de la porteuse : $f_p$ devient $f(t)$.
$
    s_"FM" (t) = A_p cos(2 pi f(t) t + phi_p)
$

#figure-modulation(
    [Signal modulé en fréquence.],
    (t, m) => calc.cos(2 * calc.pi * 10 * (1 + 0.3 * m) * t),
)

#exemple[La radio en mode FM utilise la modulation de fréquence avec une porteuse entre #qty("87", "MHz") et #qty("108", "MHz").]

#flashcard(
    recto: "Application de la modulation de fréquence.",
    verso: "Radio en mode FM avec une porteuse entre $qty(\"87\",\"MHz\")$ et $qty(\"108\",\"MHz\")$.",
)

=== La modulation de phase
La modulation de phase consiste à faire varier la phase de la porteuse : $phi_p$ devient $phi(t)$.
$
    s_"PM" (t) = A_p cos(2 pi f_p t + phi(t))
$

#figure-modulation(
    [Signal modulé en phase.],
    (t, m) => calc.cos(2 * calc.pi * 10 * t + 4 * (1 + 0.3 * m)),
)

#exemple[La téléphonie mobile utilise la modulation de phase avec une porteuse à environ #qty("900", "MHz").]

#flashcard(
    recto: "Application de la modulation de phase.",
    verso: "Téléphonie mobile avec une porteuse à environ $qty(\"900\",\"MHz\")$.",
)

#question-de-colle(
    "Citer les 3 types de modulation et, pour chacun, représenter le signal modulé, citer un exemple d'application et la fréquence associée.",
)

= Modulation d'amplitude
== Principe

#encadré(
    titre: "Signal modulé en amplitude",
    grandeurs: sub-dictionary(grandeurs, ("s_\"AM\"", "s_p", "s", "k")),
    connaitre: true,
)[
    $
        s_"AM" (t) = (1+k s(t)) s_p (t)
    $
    Le facteur $(1+k s(t))$ est appelé l'*enveloppe* (sans unité). Le signal $s(t)$ qui la fait varier est la *modulante*.
]

#flashcard(
    recto: "Forme d'un signal modulé en amplitude.",
    verso: "$s_\"AM\" (t) = (1+k s(t)) s_p (t)$",
)

#application[
    Quelle valeur maximale peut avoir $k$ pour que la modulante ne s'annule jamais ? On l'exprimera en fonction de $max(s(t))$. On supposera $s$ symétrique, c'est-à-dire que $max(s) = -min(s)$.
]

#encadré(
    titre: "Taux de modulation",
    grandeurs: sub-dictionary(grandeurs, ("h", "s", "k")),
    connaitre: true,
)[
    $
        h = k dot max(s)
    $
]

#flashcard(
    recto: "Taux de modulation.",
    verso: "$h = k dot max(s)$",
)

Pour que le signal modulé puisse être démodulé "correctement", le taux de modulation doit être inférieur à $1$. Lorsque le taux de modulation dépasse $1$, il y a *surmodulation*.

#figure(
    grid(
        columns: 3,
        column-gutter: .5em,
        canvas({
            plot.plot(
                size: (4, 3),
                axis-style: "school-book",
                x-tick-step: none,
                y-tick-step: none,
                x-min: 0,
                x-max: 2,
                y-min: -1.5,
                y-max: 1.5,
                x-label: $t$,
                {
                    plot.add(
                        t => calc.cos(2 * calc.pi * 20 * t) * (1 + 0.3 * calc.cos(2 * calc.pi * t)),
                        domain: (0, 2),
                        samples: 1600,
                    )
                },
            )
        }),
        canvas({
            plot.plot(
                size: (4, 3),
                axis-style: "school-book",
                x-tick-step: none,
                y-tick-step: none,
                x-min: 0,
                x-max: 2,
                y-min: -2.6,
                y-max: 2.6,
                x-label: $t$,
                {
                    plot.add(
                        t => calc.cos(2 * calc.pi * 20 * t) * (1 + 1 * calc.cos(2 * calc.pi * t)),
                        domain: (0, 2),
                        samples: 1600,
                    )
                },
            )
        }),
        canvas({
            plot.plot(
                size: (4, 3),
                axis-style: "school-book",
                x-tick-step: none,
                y-tick-step: none,
                x-min: 0,
                x-max: 2,
                y-min: -2.6,
                y-max: 2.6,
                x-label: $t$,
                {
                    plot.add(
                        t => calc.cos(2 * calc.pi * 20 * t) * (1 + 1.6 * calc.cos(2 * calc.pi * t)),
                        domain: (0, 2),
                        samples: 1600,
                    )
                },
            )
        }),
    ),
    caption: [Signaux modulés en amplitude avec différents taux de modulation $h=0.3$, $h=1$ et $h=1.6$ (surmodulation).],
)

La modulation en amplitude est la multiplication de deux signaux. La multiplication est une opération non linéaire qui modifie leur spectre.

== Point de vue spectral

#encadré(
    titre: "Spectre d'un signal sinusoïdal modulé en amplitude",
    grandeurs: sub-dictionary(grandeurs, ("A_p", "A_s", "k", "f_p", "f_s")),
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [$s(t)$ est un signal sinusoïdal],
        $f_p >> f_s$,
    ),
)[
    #schéma(hauteur: 4cm)
]

#encadré(
    titre: "Spectre d'un signal quelconque modulé en amplitude",
    grandeurs: sub-dictionary(grandeurs, ("A_p", "k", "f_p", "f_\"max\"")),
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        $f_p >> f_"max"$,
    ),
)[
    #schéma(hauteur: 4cm)
]

#flashcard(
    recto: "$cos(a) cos(b)$",
    verso: "$(cos(a+b)+cos(a-b))/2$",
)

La *largeur de bande* est la plage de fréquence occupée par le signal modulé.

#application[
    Combien peut-il y avoir de stations de radio en grandes ondes (GO) ? Et dans la bande FM ?
]

= Démodulation
== Principe

La démodulation est l'opération inverse de la modulation. La démodulation permet de retrouver le signal à transmettre à partir du signal modulé.

La démodulation ne peut pas être une opération linéaire : un filtre modifie l'amplitude de chaque composante spectrale, mais ne peut pas en *déplacer* la fréquence. Or il faut ramener le spectre situé autour de $f_p$ vers les basses fréquences. Seule une opération non linéaire, ici la multiplication, transpose le spectre.

== Démodulation synchrone

=== Première étape : multiplication par la porteuse

#encadré(
    titre: "Spectre du signal après multiplication par la porteuse",
    grandeurs: sub-dictionary(grandeurs, ("A_p", "k", "f_p", "f_s")),
    savoir-faire: true,
    hypothèses: (
        $f_p >> f_s$,
        "le signal à transmettre est sinusoïdal",
    ),
)[
    #schéma(hauteur: 3cm)
]

#question-de-colle(
    "Dans le cas d'un signal de départ sinusoïdal, déterminer et tracer le spectre du signal modulé en amplitude puis du produit du signal modulé et de la porteuse.",
)

=== Deuxième étape : filtrage passe-bas

#encadré(
    titre: "Spectre du signal après multiplication par la porteuse et filtrage passe-bas",
    grandeurs: sub-dictionary(grandeurs, ("A_p", "k", "f_p", "f_s")),
    savoir-faire: true,
    hypothèses: (
        $f_p >> f_s$,
        "le signal à transmettre est sinusoïdal",
    ),
)[
    #schéma(hauteur: 3cm)
]

#application[
    Quelle fréquence de coupure le filtre passe-bas peut-il avoir pour démoduler la radio en grandes ondes (GO) ?
]

=== Troisième étape : filtrage passe-haut

#encadré(
    titre: "Spectre du signal après démodulation",
    grandeurs: sub-dictionary(grandeurs, ("A_p", "k", "f_p", "f_\"max\"")),
    savoir-faire: true,
    hypothèses: (
        $f_p >> f_s$,
        "le signal à transmettre est sinusoïdal",
    ),
)[
    #schéma(hauteur: 3cm)
]

#application[
    Quelle fréquence de coupure le filtre passe-haut peut-il avoir pour démoduler la radio en grandes ondes (GO) ?
]

=== Schéma récapitulatif

#schéma(titre: "Démodulation synchrone", hauteur: 6cm)

#question-de-colle(
    "Pour un signal de départ sinusoïdal de fréquence $f$, représenter sur un schéma les différentes étapes de la démodulation synchrone en précisant les exigences sur les fréquences de coupure et en représentant leurs effets sur le spectre du signal.",
)

#question-de-colle(
    "Pour un signal de départ audio, représenter sur un schéma les différentes étapes de la démodulation synchrone en précisant les exigences sur les fréquences de coupure et en représentant leurs effets sur le spectre du signal.",
)
