#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Démodulation synchrone",
)

// Allure (non symétrique, plus réaliste qu'une simple bosse) d'un spectre de type "signal audio",
// nulle en u=0 et u=1 : un mélange d'harmoniques impaires et paires casse la symétrie en u=1/2.
#let audio-shape(u) = calc.max(
    0,
    1.2 * calc.sin(calc.pi * u) + 0.5 * calc.sin(2 * calc.pi * u) - 0.4 * calc.sin(4 * calc.pi * u),
)

#let spectre(x-max: 10, x-label: $f$, y-label: [], bumps: (), lignes: ()) = {
    canvas({
        plot.plot(
            size: (8, 2.6),
            axis-style: "left",
            x-tick-step: none,
            y-tick-step: none,
            x-min: 0,
            x-max: x-max,
            y-min: 0,
            y-max: 2.5,
            x-label: x-label,
            y-label: y-label,
            {
                for bump in bumps {
                    let f0 = bump.at(0)
                    let w = bump.at(1)
                    let h = bump.at(2)
                    // un 4e élément (booléen) marque une bande latérale "basse", image
                    // inversée en fréquence du spectre du signal (cf. bande latérale d'une AM)
                    let reversed = bump.len() > 3 and bump.at(3)
                    plot.add(
                        f => h * audio-shape(if reversed { (f0 + w / 2 - f) / w } else { (f - (f0 - w / 2)) / w }),
                        domain: (f0 - w / 2, f0 + w / 2),
                        samples: 150,
                        style: (stroke: red),
                    )
                }
                plot.annotate(resize: false, {
                    import cetz.draw: *
                    for (f, h, lbl) in lignes {
                        line((f, 0), (f, h), mark: (end: ">>", fill: black), stroke: red)
                        content((f, 0), lbl, anchor: "north", padding: .2em)
                    }
                })
            },
        )
    })
}

On souhaite démoduler un signal modulé en amplitude $s_"AM" (t)$ avec une porteuse $s_p (t)$ de fréquence #qty("200", "kHz"). Le spectre du signal original s'étend entre $0$ et #qty("10", "kHz"). On utilise pour cela le montage suivant.

#figure(
    canvas({
        import cetz.draw: *
        set-style(stroke: .5pt)
        rect((0, -1), (3.4, 1), name: "M")
        content("M", align(center, [Multiplieur \ $(s=k times e_1 times e_2)$]))
        rect((6, -.7), (9.4, .7), name: "S")
        content("S", align(center, [Filtre RC \ passe-bas]))

        line((-2.5, .6), (0, .6), mark: (end: ">>", fill: black))
        content((-2.5, .6), $s_"AM" (t)$, anchor: "east", padding: .3em)
        line((-2.5, -.6), (0, -.6), mark: (end: ">>", fill: black))
        content((-2.5, -.6), $s_p (t)$, anchor: "east", padding: .3em)

        line((3.4, 0), (6, 0), mark: (end: ">>", fill: black))
        content((4.7, 0), $s_i (t)$, anchor: "south", padding: .2em)

        line((9.4, 0), (11.5, 0), mark: (end: ">>", fill: black))
        content((11.5, 0), $s(t)$, anchor: "west", padding: .3em)
    }),
)

#question()[
    Représenter qualitativement les spectres de $s_"AM" (t)$, $s_p (t)$, $s_i (t)$ et $s(t)$.
][
    $s_p (t)$ est purement sinusoïdal : son spectre est une unique raie à $f_p=qty("200", "kHz")$.

    #spectre(lignes: ((5, 2, $f_p$),), x-max: 10)

    $s_"AM" (t) = A_p cos(2 pi f_p t)(1+k s(t))$ : son spectre comporte la raie à $f_p$, entourée de deux bandes latérales, images du spectre du signal $s$ (de largeur #qty("10", "kHz")) autour de $f_p$.

    #spectre(bumps: ((4, 2, 1, true), (6, 2, 1)), lignes: ((5, 2, $f_p$),), x-max: 10)

    En multipliant par $s_p (t)$, $s_i (t) = A_p^2 cos^2 (2 pi f_p t)(1+k s(t))$. Or $cos^2(2 pi f_p t) = (1+cos(4 pi f_p t))/2$, donc
    $
        s_i (t) = A_p^2/2 (1+k s(t)) + A_p^2/2 cos(4 pi f_p t) + (A_p^2 k)/2 s(t) cos(4 pi f_p t)
    $
    Le premier terme redonne le spectre de $s$ en bande de base (autour de $f=0$). Le deuxième terme est une raie à $2f_p$. Le troisième terme est, comme pour $s_"AM"$, une modulation d'amplitude de $s$ sur la porteuse $2f_p$ : il donne deux bandes latérales symétriques autour de $2f_p$, chacune deux fois moins haute que la copie en bande de base (le facteur $(A_p^2 k)/2$ du troisième terme se répartissant pour moitié entre les deux bandes latérales).

    #spectre(
        bumps: ((1, 2, 1), (9, 2, 0.5, true), (11, 2, 0.5)),
        lignes: ((10, 2, $2 f_p$), (0, 2, "")),
        x-max: 12,
    )

    Après filtrage passe-bas (qui élimine tout ce qui est autour de $2f_p$), il ne reste que le spectre de $s$ en bande de base :

    #spectre(bumps: ((1, 2, 1),), lignes: ((0, 2, ""),), x-max: 10)
]

#question(
    coups-de-pouce: (
        "Dans quelles plages de fréquence peut-on choisir $R$ et $C$ en TP ?",
        "Quelles relations (supérieur, inférieur, très petit devant ou très grand devant) doit vérifier la fréquence de coupure du filtre passe-bas ?",
    ),
)[
    Proposer des valeurs réalistes pour $R$ et $C$ afin que le signal démodulé $s(t)$ s'approche convenablement du signal modulant.
][
    Il faut que la fréquence de coupure du filtre passe-bas soit très grande devant #qty("10", "kHz") (pour ne pas couper le signal utile) et très petite devant $2 f_p = qty("400", "kHz")$ (pour éliminer la composante haute fréquence). On peut par exemple prendre $f_c=qty("16", "kHz")=1/(2 pi R C)$, avec $R=qty("1", "kO")$ et $C=qty("10", "nF")$.
]
