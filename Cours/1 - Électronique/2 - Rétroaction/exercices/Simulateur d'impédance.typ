#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Simulateur d'impédance",
    difficulté: 2,
)

On s'intéresse au montage suivant. L'ALI est supposé idéal. Le montage est *supposé stable*.

#figure(
    zap.circuit({
        import zap: *
        import cetz.draw: *
        set-style(padding: .4em)
        opamp("ALI", (0, 0), invert: true)
        resistor("Rp2", (-1.5, -1.5), (-1.5, -4), label: $2R'$)
        resistor("Rp", (-1.5, -1.5), (1.5, -1.5), label: (content: $R'$, anchor: "south"))
        swire("ALI.minus", (-1.5, -1.5))
        swire("ALI.out", (1.5, -1.5))
        frame("G2", (-1.5, -4))
        resistor("R2", (-2.5, -1.5), (-2.5, -4), label: (content: $2R$, anchor: "south"))
        frame("G1", (-2.5, -4))
        capacitor("C", (rel: (-2, 0), to: "ALI.plus"), (rel: (-2, 0)), label: $C$)
        wire("ALI.plus", "C.in")
        swire("ALI.plus", "R2.in")
        resistor("R", (rel: (0, 1), to: "C.out"), ((), "-|", "Rp.out"), label: $R$)
        wire("R.out", "Rp.out")
        wire("R.in", "C.out")
        wire("C.out", (rel: (-1, 0)))
        wire("ALI.out", (rel: (1.5, 0)))
        content((rel: (-1, 0), to: "C.out"), $e$, anchor: "east")
        content((rel: (1.5, 0), to: "ALI.out"), $s$, anchor: "west")
    }),
)

#question(
    coups-de-pouce: (
        "Relier le potentiel de l'entrée inverseuse à la sortie. Relier le potentiel de l'entrée non-inverseuse à l'entrée.",
        "Relier le potentiel de l'entrée inverseuse à la sortie grâce à un pont diviseur de tension entre $R'$ et $2R'$. Relier le potentiel de l'entrée non-inverseuse à l'entrée grâce à un pont diviseur de tension entre $C$ et $2R$.",
        "Que vaut la différence de potentiel entre entrée inverseuse et entrée non inverseuse de l'ALI pour un montage stable ?",
    ),
)[
    Déterminer la fonction de transfert du montage.
][
    Comme le courant d'entrée de l'ALI est nul, on peut appliquer la loi du pont diviseur de tensions, qui donne
    $
        V_- = (2R')/(R'+2R') s = 2/3 s
    $
    Ou, en complexes :
    $
        underline(V_-) = 2/3 underline(s)
    $
    De la même manière, sur l'entrée non-inverseuse, on a
    $
        underline(V_+) = (2R)/(1/(j C omega)+2R) underline(e) = (2 j R C omega)/(1+2 j R C omega) underline(e)
    $
    Or *le montage est stable* et l'ALI idéal, donc $underline(V_-) = underline(V_+)$. On obtient donc
    $
        2/3 underline(s) = (2 j R C omega)/(1+2 j R C omega) underline(e)
    $
    $
        underline(H)(j omega) = underline(s)/underline(e) = (3 j R C omega)/(1+2 j R C omega)
    $
]

#question(
    coups-de-pouce: (
        "Déterminer le courant passant par R et par C.",
        "Utiliser la loi d'Ohm dans R et éliminer s pour relier courant dans R et entrée e.",
        "Utiliser la loi d'Ohm dans le dipôle formé par C et 2R pour relier le courant dans C et l'entrée e.",
        "Utiliser la loi des nœuds pour relier courant d'entrée et tension d'entrée.",
        "Mettre l'impédance d'entrée sous la forme r+jLw avec r et L à trouver.",
    ),
)[
    Déterminer l'impédance d'entrée du montage. Montrer que cette impédance est équivalente à une bobine réelle dont la résistance serait $R$ et l'inductance serait $2 R^2 C$.
][
    D'après la loi d'Ohm, le courant passant par R est
    $
        underline(i_R) = (underline(e) - underline(s))/R = 1/R ( underline(e) - (3 j R C omega)/(1+2 j R C omega) underline(e)) = 1/R (1 + 2 j R C omega - 3 j R C omega)/(1+2 j R C omega) underline(e) = 1/R (1 - j R C omega )/(1+2 j R C omega) underline(e)
    $
    Le condensateur $C$ et le résistor $2R$ sont en série (ils sont parcourus par le même courant car le courant entrant dans l'ALI est nul). Leur impédance équivalente est donc
    $
        underline(Z_"éq") = 1/(j C omega) + 2R
    $
    Le courant les traversant est donc
    $
        underline(i_C) = underline(e)/underline(Z_"éq") = underline(e)/(1/(j C omega) + 2R) = (j C omega)/(1+2 j R C omega) underline(e)
    $

    Ainsi, le courant d'entrée est
    $
        underline(i_e) = underline(i_R) + underline(i_C) = 1/R ( (1 - j R C omega)/(1+2 j R C omega) + (j R C omega)/(1+2 j R C omega)) underline(e) = 1/R 1/(1+2 j R C omega) underline(e)
    $
    Soit une impédance d'entrée
    $
        underline(Z_e)
        = underline(e)/underline(i_e)
        = R (1+2 j R C omega)
        = R + j 2 R^2 C omega
    $
    Ce dipôle est équivalent à une bobine réelle dont la résistance serait $R$ et l'inductance serait $2 R^2 C$
]
