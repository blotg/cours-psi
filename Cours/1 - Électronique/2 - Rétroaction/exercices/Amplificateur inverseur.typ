#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Montage amplificateur inverseur",
)

On considère le montage suivant, appelé montage amplificateur inverseur. L'ALI est supposé idéal.

#figure(
    zap.circuit({
        import zap: *
        import cetz.draw: *
        opamp("ALI", (0, 0))
        resistor("R2", (0, 1.7), label: $R_2$)
        resistor("R1", (rel: (-1.5, 0), to: "ALI.minus"), label: $R_1$)
        swire("ALI.minus", (rel: (-0.5, 0)), "R2.west", axis: "y")
        swire("ALI.out", (rel: (0.5, 0)), "R2.east", axis: "y")
        wire("ALI.minus", "R1.east")
        wire("R1.west", (rel: (-0.5, 0)))
        wire("ALI.out", (rel: (1, 0)))
        content((rel: (-0.5, 0), to: "R1.west"), anchor: "east", padding: .4em, $V_e$)
        frame("G", (rel: (-0.5, -0.7), to: "ALI.west"))
        swire("G", "ALI.plus", axis: "y")
        content((rel: (1, 0), to: "ALI.out"), anchor: "west", padding: .4em, $V_s$)
    }),
)

#question(
    coups-de-pouce: (
        "Y a-t-il une rétroaction ? Est-elle positive ou négative ?",
    ),
)[
    L'ALI a-t-il un fonctionnement stable ou instable ?
][
    La rétroaction négative suggère un fonctionnement stable.
]

#question(
    coups-de-pouce: (
        "Que peut-on dire de l'entrée différentielle si le montage est stable ?",
        "Utiliser le pont diviseur de tension pour relier l'entrée du montage, l'entrée différentielle et la sortie.",
        "Exprimer la tension de sortie en fonction de la tension d'entrée.",
    ),
)[
    Exprimer la fonction de transfert du montage. Justifier le nom du montage.
][
    La loi du pont diviseur de tension s'écrit
    $
        V_- - V_e = R_1 / (R_1+R_2) (V_s - V_e)
    $
    Or $V_- = V_+ = 0$ car l'ALI est idéal *et en fonctionnement stable*. On a donc
    $
      V_e (-1 + R_1 / (R_1 + R_2)) = V_s R_1 / (R_1 + R_2)
    $
    $
      V_e (-R_1 - R_2 + R_1) / (R_1 + R_2) = V_s R_1 / (R_1 + R_2)
    $
    $
      -R_2 V_e = R_1 V_s
    $
    $
        V_s / V_e = - R_2 / R_1
    $
    D'où la fonction de transfert
    $
      underline(H)(j omega) = underline(V_s) / underline(V_e) = - R_2 / R_1
    $
    La tension de sortie est proportionnelle à la tension d'entrée, ce qui permet de l'*amplifier*. Comme ce coefficient est négatif, le montage est dit *inverseur*.
]

#question(
    coups-de-pouce: (
        "Exprimer la tension aux bornes de R1 en fonction de l'entrée du montage.",
        "Utiliser la loi d'Ohm dans la résistance R1.",
    ),
)[
    Exprimer l'impédance d'entrée du montage.
][
    La tension aux bornes de $R_1$ est $V_e - V_- = V_e - 0 = V_e$. La loi d'Ohm dans la résistance $R_1$ s'écrit donc
    $
        I_e = V_e / R_1
    $
    On peut en déduire l'impédance d'entrée du montage
    $
        underline(Z_e) = underline(V_e) / underline(I_e) = R_1
    $
]
