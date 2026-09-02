#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Montage intégrateur",
)

On considère le montage suivant, appelé montage intégrateur. L'ALI est supposé idéal.

#figure(
    zap.circuit({
        import zap: *
        import cetz.draw: *
        opamp("ALI", (0, 0))
        capacitor("C", (0, 1.7), label: $C$)
        resistor("R", (rel: (-1.5, 0), to: "ALI.minus"), label: $R$)
        swire("ALI.minus", (rel: (-0.5, 0)), "C.west", axis: "y")
        swire("ALI.out", (rel: (0.5, 0)), "C.east", axis: "y")
        wire("ALI.minus", "R.east")
        wire("R.west", (rel: (-0.5, 0)))
        wire("ALI.out", (rel: (1, 0)))
        content((rel: (-0.5, 0), to: "R.west"), anchor: "east", padding: .4em, $V_e$)
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
    La rétroaction négative suggère un fonctionnement stable de l'ALI.
]

#question(
    coups-de-pouce: (
        "Passer en notations complexes et utiliser l'impédance du condensateur.",
        "Utiliser le pont diviseur de tension pour relier l'entrée du montage, l'entrée différentielle et la sortie.",
    ),
)[
    Exprimer la fonction de transfert du montage.
][
    En complexe, le condensateur a pour impédance $Z_C = 1/(j omega C)$. Comme le courant d'entrée de l'ALI est nul, le pont diviseur de tension permet d'écrire
    $
        underline(V_-) - underline(V_e) = R / (R + Z_C) (underline(V_s) - underline(V_e))
    $
    Or l'ALI est idéal *et en fonctionnement stable* donc $underline(V_- = 0)$, d'où
    $
        underline(V_e) (-1 + R / (R + Z_C)) = R / (R + Z_C) underline(V_s)
    $
    $
        (-Z_C)/(R + Z_C) underline(V_e) = R / (R + Z_C) underline(V_s)
    $
    $
        underline(H)(j omega) = underline(V_s) / underline(V_e) = -Z_C / R = -1/(j omega R C)
    $
]

#question(
    coups-de-pouce: (
        "Pas besoin d'utiliser des équivalents haute et basse fréquence car la fonction de transfert est suffisamment simple.",
    ),
)[
    Tracer le diagramme de Bode.
][
    $
        G_"dB" = 20 log|underline(H)| = 20 log(1/(R C omega)) = - 20 log(omega/omega_0)
    $
    avec $omega_0 = 1/(R C)$
    Le diagramme de Bode est donc une droite de pente #qty("-20", "dB") par décade.

    Le gain est nul lorsque $omega = omega_0$, ce qui correspond donc à l'intersection de la droite avec l'axe des abscisses.

    #figure(
        canvas({
            plot.plot(
                size: (12, 8),
                axis-style: "school-book",
                x-tick-step: none,
                y-tick-step: none,
                x-ticks: ((1, $omega_0$),),
                y-ticks: (),
                x-label: [$omega$ (échelle log)],
                y-label: $G_"dB"$,
                {
                    let f1(x) = -20 * x + 20
                    plot.add(f1, domain: (-1, 3))
                },
            )
        }),
    )
]

#question(
    coups-de-pouce: (
        "Exprimer la tension de sortie en fonction de l'entrée dans le domaine de Laplace ou fréquentiel puis passer en temporel."
    ),
)[
    À partir de la fonction de transfert, déterminer l'équation différentielle vérifiée par la tension de sortie et la tension d'entrée. Justifier le nom du montage.
][
    En passant en temporel l'équation $j omega underline(V_s) = -1/(R C) underline(V_e)$, on obtient
    $
        dv(v_s, t) = -1/(R C) v_e
    $
    qu'on peut réécrire
    $
        v_s = -1/(R C) integral_0^t v_e (x) dd(x)
    $
]
