#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Oscillateur à résistance négative",
)

On considère le montage ci-dessous, appelé montage à résistance négative. On *suppose* l'ALI idéal en fonctionnement stable.

#figure(
    zap.circuit({
        import zap: *
        import draw: *
        set-style(padding: .4em)
        opamp("ALI", (0, 0), invert: true)
        resistor("R1a", (-1.5, -1.5), (-1.5, -4), label: $R_1$)
        resistor("R1b", (-1.5, -1.5), (1.5, -1.5), label: (content: $R_1$, anchor: "south"))
        swire("ALI.minus", (-1.5, -1.5))
        swire("ALI.out", (1.5, -1.5))
        frame("G1", "R1a.out")
        resistor("R", (-1.5, 1.5), (1.5, 1.5), label: (content: $R$, anchor: "north"))
        swire("ALI.plus", (-1.5, 1.5))
        swire("ALI.out", (1.5, 1.5))
        wire("ALI.plus", (rel: (-2, 0)))
        line(
            (rel: (-0.6, 0), to: "ALI.plus"),
            (rel: (-1.1, 0), to: "ALI.plus"),
            mark: (end: "<", fill: black),
        )
        content((rel: (-1, 0), to: "ALI.plus"), $i$, anchor: "south", padding: .3em)
        content((rel: (-2, 0), to: "ALI.plus"), $u$, anchor: "east")
    }),
)

#question(
    coups-de-pouce: (
        "Le montage est-il stable ? Que peut-on dire de l'entrée différentielle $epsilon$ ?",
        "À l'aide d'un pont diviseur de tension entre les résistances $R_1$ et d'une loi des mailles, relier l'entrée différentielle $epsilon$ à $u$ et la sortie de l'ALI.",
    ),
)[
    Déterminer une relation entre la tension $u$ et la tension de sortie de l'ALI.
][
    Le montage étant supposé stable et l'ALI idéal, $epsilon = V_+-V_- = 0$, soit $V_+=V_-$.

    L'entrée $V_-$ est le point milieu d'un pont diviseur de tension entre deux résistances égales $R_1$ (courant d'entrée de l'ALI négligeable) :
    $
        V_- = R_1/(R_1+R_1) V_s = V_s/2
    $
    L'entrée $V_+$ est reliée directement (par un simple fil) au nœud d'entrée où sont définis $u$ et $i$ : $V_+ = u$.

    La relation $V_+=V_-$ donne donc
    $
        u = V_s/2
    $
]

#question(
    coups-de-pouce: (
        "Écrire la loi d'Ohm dans la résistance $R$.",
        "Utiliser la fonction de transfert de la question précédente pour éliminer la tension de sortie de l'ALI dans la loi d'Ohm.",
    ),
)[
    En utilisant la loi d'Ohm, en déduire l'impédance d'entrée du montage $Z_e=underline(u)/underline(i)$.
][
    Le courant d'entrée de l'ALI étant négligeable, le courant $i$ qui arrive sur le nœud $V_+=u$ repart intégralement dans $R$ vers la sortie $V_s$. La loi d'Ohm dans $R$ donne alors
    $
        i = (u-V_s)/R
    $
    En utilisant $V_s=2u$ (question précédente),
    $
        i = (u-2u)/R = -u/R
    $
    L'impédance d'entrée du montage vaut donc
    $
        Z_e = u/i = -R
    $
    Ce montage se comporte donc, vu de son entrée, comme une résistance négative $-R$.
]

Ce montage, qui se comporte comme une « résistance négative », est placé dans le circuit suivant où $R=qty("10", "kO")$ et $r=qty("10", "kO")$.

#figure(
    zap.circuit({
        import zap: *
        import draw: *
        set-style(padding: .4em)
        wire((0, 0), (-1, 0))
        line((-0.7, 0), (-0.3, 0), mark: (end: ">", fill: black))
        content((-0.5, 0), $i$, anchor: "south", padding: .3em)
        resistor("r", (-1, 0), (-3, 0), label: (content:$r$, anchor: "south"))
        capacitor("C", (-3, 0), (-3, -2), label: (content:$C$, anchor: "south"))
        inductor("L", (-3, -2), (-3, -4), label: (content: $L$, anchor: "south"), variant: "ieee")
        wire((-3, -4), (0, -4))
        resistor("Ze", (0, -4), (0, 0), label: (content: $Z_e$, anchor: "south"))
        line((-1, -3.9), (-1, -0.1), mark: (end: ">", fill: black))
        content((-1, -2), $u$, anchor: "west", padding: .3em)
    }),
)

#question(
    coups-de-pouce: (
        "Appliquer la loi des mailles et utiliser les caractéristiques de différents composants.",
        "Dériver la loi des mailles et utiliser que $u_L=L dv(i,t)$, $i=C dv(u_C,t)$ et $u=Z_e i$.",
    ),
)[
    Déterminer une équation différentielle sur $i$.
][
    Le circuit est une maille unique parcourue par le courant $i$ : le résistor $r$, le condensateur $C$, la bobine $L$ et le dipôle de résistance négative $Z_e$ sont donc tous traversés par le même courant $i$.

    La loi des mailles s'écrit
    $
        r i + u_C + L dv(i, t) + Z_e i = 0
    $
    avec $i = C dv(u_C, t)$. En dérivant la loi des mailles par rapport au temps,
    $
        r dv(i, t) + dv(u_C, t) + L dv(i, t, 2) + Z_e dv(i, t) = 0
    $
    et en remplaçant $dv(u_C, t) = i/C$, puis en multipliant par $C$,
    $
        L C dv(i, t, 2) + (r+Z_e) C dv(i, t) + i = 0
    $
    Avec $Z_e=-R$ (question précédente),
    $
        L C dv(i, t, 2) + (r-R) C dv(i, t) + i = 0
    $
]

#question(
    coups-de-pouce: (
        "A quelle condition les solutions de l'équation différentielle précédente divergent-elles ?",
    ),
)[
    Sous quelles conditions sur la valeur de $R$ les oscillations démarrent-elles ?
][
    Les oscillations démarrent spontanément si le système est instable, c'est-à-dire si le coefficient de $dv(i, t)$ dans l'équation différentielle précédente est négatif :
    $
        (r-R)C < 0 arrow.double R > r
    $
    Il faut donc que la résistance négative $-R$ compense, en valeur absolue, plus que la résistance $r$ pour que les oscillations démarrent.
]
