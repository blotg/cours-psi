#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Montage suiveur",
)

On considère le montage ci-dessous, appelé montage suiveur. L'ALI est supposé idéal.

#figure(
    zap.circuit({
        import zap: *
        import draw: *
        opamp("ALI", (0, 0))
        wire("ALI.plus", (rel: (-1, 0)), label: "$V_e$")
        swire("ALI.minus", (rel: (-0.5, 1)), (rel: (0.5, 0), to: "ALI.out"), "ALI.out", (rel: (1, 0)))
        content((rel: (-1, 0), to: "ALI.plus"), $V_e$, anchor: "east", padding: 0.4em)
        content((rel: (1, 0), to: "ALI.out"), $V_s$, anchor: "west", padding: 0.4em)
    }),
)

#question(
    coups-de-pouce: (
        "Y a-t-il une rétroaction ? Est-elle positive ou négative ?",
    ),
)[
    L'ALI a-t-il un fonctionnement stable ou instable ?
][
    La présence d'une rétroaction négative suggère un fonctionnement stable.
]

#question(
    coups-de-pouce: (
        "Que peut-on dire de la tension de sortie si le montage est stable ?",
        "Exprimer la tension de sortie en fonction de la tension d'entrée.",
    ),
)[
    Exprimer la fonction de transfert du montage. Justifier le nom du montage.
][
    Pour un ALI idéal *en fonctionnement stable*, l'entrée différentielle est nulle.
    $
        V_+ - V_- = 0
    $
    Or $V_+ = V_e$ et $V_- = V_s$, d'où
    $
        V_e - V_s = 0
    $
    $
        V_s = V_e
    $
    $
        underline(H)(j omega) = (underline(V_s)(j omega)) / (underline(V_e)(j omega)) = 1
    $
    La tension de sortie est toujours égale à la tension d'entrée, ce qui explique le nom de "suiveur" donné à ce montage.
]

#question(
    coups-de-pouce: (
        "Que vaut le courant d'entrée ?",
    ),
)[
    Exprimer l'impédance d'entrée du montage.
][
    Le courant d'entrée $i_+$ est nul, donc
    $
        underline(Z_e)(j omega) = (underline(V_e)(j omega)) / (underline(i_+)(j omega)) = infinity
    $
    Le montage suiveur a une impédance d'entrée infinie.
]
