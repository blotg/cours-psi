#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Montage dérivateur",
)

On s'intéresse au montage suivant, appelé montage dérivateur. L'ALI est supposé idéal.

#figure(
    zap.circuit({
        import zap: *
        import cetz.draw: *
        opamp("ALI", (0, 0))
        resistor("R", (0, 1.7), label: $R$)
        capacitor("C", (rel: (-1.5, 0), to: "ALI.minus"), label: $C$)
        swire("ALI.minus", (rel: (-0.5, 0)), "R.west", axis: "y")
        swire("ALI.out", (rel: (0.5, 0)), "R.east", axis: "y")
        wire("ALI.minus", "C.east")
        wire("C.west", (rel: (-0.5, 0)))
        wire("ALI.out", (rel: (1, 0)))
        content((rel: (-0.5, 0), to: "C.west"), anchor: "east", padding: .4em, $V_e$)
        frame("G", (rel: (-0.5, -0.7), to: "ALI.west"))
        swire("G", "ALI.plus", axis: "y")
        content((rel: (1, 0), to: "ALI.out"), anchor: "west", padding: .4em, $V_s$)
    }),
)


#question(
    coups-de-pouce: "Y a-t-il une rétroaction ? Est-elle positive ou négative ?",
)[
    L'ALI a-t-il un fonctionnement stable ou instable ?
][
    La présence d'une rétroaction négative suggère un fonctionnement stable.
]

#question(
    coups-de-pouce: (
        "Passer en notations complexes et utiliser l'impédance du condensateur.",
        "Utiliser le pont diviseur de tension pour relier l'entrée du montage, l'entrée différentielle et la sortie.",
    ),
)[
    Exprimer la fonction de transfert du montage.
][
    Comme le courant d'entrée de l'ALI est nul, on peut appliquer la loi du pont diviseur de tensions en complexes, qui donne
    $
        underline(V_-) - underline(V_e) = (1/(j C omega)) / (1/(j C omega) + R) (underline(V_s) - underline(V_e)) = 1/(1+j R C omega) (underline(V_s) - underline(V_e))
    $
    Or *le montage est stable* et l'ALI idéal, donc $underline(V_-) = underline(V_+) = 0$
    $
        (-1 + 1/(1+j R C omega)) underline(V_e) = 1/(1+j R C omega) underline(V_s)
    $
    $
        (-1-j R C omega + 1)/(1+j R C omega) underline(V_e) = 1/(1+j R C omega) underline(V_s)
    $
    $
        -j R C omega underline(V_e) = underline(V_s)
    $
    $
        underline(H)(j omega) = underline(V_s)/underline(V_e) = - j R C omega
    $
]

#question(
    coups-de-pouce: "Pas besoin d'utiliser des équivalents haute et basse fréquence car la fonction de transfert est suffisamment simple.",
)[
    Tracer le diagramme de Bode.
][
    $
      G_"dB" = 20 log|underline(H)| = 20 log(R C omega)
    $

    Le diagramme de Bode est donc une droite de pente #qty("20","dB") par décade.

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
                    let f1(x) = 20 * x - 20
                    plot.add(f1, domain: (-1, 3))
                },
            )
        }),
    )
]

#question(
    coups-de-pouce: "Passer en temporel la fonction de transfer du montage."
)[
    À partir de la fonction de transfert, déterminer l'équation différentielle vérifiée par la tension de sortie et la tension d'entrée. Justifier le nom du montage.
][
    $
      underline(V_s) = - j R C omega underline(V_e)
    $
    En repassant en réels, on obtient
    $
      V_s(t) = - R C dv(V_e,t)
    $
    La tension de sortie est proportionnelle à la dérivée de la tension d'entrée, d'où le nom du montage.
]