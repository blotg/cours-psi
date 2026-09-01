#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Couplage thermocinétique",
    ouvert: true,
)

On s'intéresse au métabolisme de l'éthanol ($M=qty("46","g/mol")$) par corps humain. L'éthanol est transformé en acétaldéhyde dans le fie par l'enzyme alcool déshydrogénase (ADH) selon la réaction suivante :

#figure(
    canvas({
        import draw: *
        content((-2.5, 0), ce("CH_3CH_2OH"), name: "E", padding: .3)
        content((2.5, 0), ce("CH_3CHO"), name: "A", padding: .3)
        line("E", "A", mark: (end: ">>", fill: black))
        content((-1, 1), ce("NAD+"), name: "NAD+", padding: .3)
        content((1, 1), ce("NADH"), name: "NADH", padding: .3)
        bezier((-0.8, 0.7), (0.8, 0.7), (0, -0.7), mark: (end: ">>", fill: black))
    }),
)

La cinétique de cette réaction est d'ordre $0$. Le foie est capable de métaboliser environ #qty("7", "g") d'éthanol par heure.

Le débit sanguin hépatique est d'environ #qty("1.5", "L/min").

#question(
    coups-de-pouce: (
        "Faire un bilan de matière d'éthanol dans le foie.",
        "Utiliser la définition du taux de conversion.",
        "Calcule la vitesse extensive de réaction à partir de la masse d'éthanol métabolisée par heure."
    )
)[
    Calculer le taux de conversion de l'éthanol pour une personne ayant un taux d'alcoolémie de #qty("0.2", "g/L") dans le sang entrant dans le foie (environ 1 verre d'alcool consommé).
][
    La conservation de l'éthanol s'écrit
    $
        F_(ce("CH_3CH_2OH"), s) - F_(ce("CH_3CH_2OH"), e) = - dv(xi, t)
    $
    Le taux de conversion s'écrit donc
    $
        X = (F_(ce("CH_3CH_2OH"), e) - F_(ce("CH_3CH_2OH"), s)) / F_(ce("CH_3CH_2OH"), e) = dv(xi, t) / F_(ce("CH_3CH_2OH"), e)\
        = dv(xi, t) / ([ce("CH_3CH_2OH")]_s D_V) \
        = (1/num("46") times #num("7") / #num("60")) / (#num("0.2") / num("46") times num("1.5"))
        = #num(scientifique(1/60*7/60/0.2/1.5*46, 1))
        = #qty(scientifique(1/60*7/60/0.2/1.5*46 * 100, 1), "%")
    $
    On a effectué l'application numérique en #unit("mol"), #unit("g"), #unit("L") et #unit("min").
]
