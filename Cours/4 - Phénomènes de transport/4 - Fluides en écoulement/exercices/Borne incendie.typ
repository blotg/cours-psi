#import "@local/prepa:0.1.0": *

#show: exercice.with(
    titre: "Poteau d'incendie",
    ouvert: true,
    difficulté: 2
)

#grid(
    columns: (1fr, 2fr),
    figure(
        image("/images/poteau incendie.jpg", height: 5cm),
    ),
    figure(
        image("/images/citerne souple incendie.jpg", height: 5cm),
    ),
)

Les poteaux d'incendie doivent pouvoir délivrer un débit de #qty("30", "m^3/h") minimum sous une pression dynamique de #qty("1", "bar") minimum.

Un chateau d'eau de #qty("20", "m") de haut alimente un village en eau par une conduite en fonte de diamètre intérieur #qty("200", "mm") et de longueur #qty("3", "km") puis par une conduite en fonte de diamètre intérieur #qty("150", "mm") et de longueur #qty("2", "km").

On pourra utiliser le diagramme de Moody du cours.

#question(
    coups-de-pouce: (
        "Calculer le nombre de Reynolds dans chacune des deux conduites.",
        "À l'aide du diagramme de Moody, calculer le coefficient de perte de charge dans chacune des deux conduites.",
        "Calculer la chute de pression dans chacune des deux conduites.",
        "Quelle relation relie la chute de pression totale aux chutes de pression dans chacune des deux conduites."
    ),
)[
    Les poteaux d'incendie sont-ils aux normes ou est-il nécessaire d'installer des bassins de stockage supplémentaires dans le village ?
][
    Dans la première conduite, le nombre de Reynolds est :
    #let Dv = 30 / 3600
    #let mv = 1000
    #let visc = 1e-3
    #let D1 = 0.2
    #let Re1 = 4 * Dv * mv / (visc * calc.pi * D1)
    $
        R_e_1 = (U D)/nu = (D_V/S D mu)/eta = (D_V D mu)/(eta pi D^2/4) = (4 D_V mu)/(eta pi D) = #num(scientifique(Re1, 2))
    $
    Le coefficient de perte de charge peut être lu sur le diagramme de Moody (rugosité relative de $qty("0.15", "mm")/qty("200", "mm") = num(#scientifique(0.15 / 200, 1))$) : #num("0.02").
    La perte de charge dans la première conduite est donc :
    #let xi1 = 0.02
    #let L1 = 3e3
    #let DP1 = 8 * xi1 * mv * calc.pow(Dv, 2) * L1 / (calc.pow(D1, 5) * calc.pow(calc.pi, 2))
    $
        Delta P_1 = (xi1 rho v^2 L)/(2 D)
        = (xi1 rho (D_V/S)^2 L)/(2 D)
        = (xi1 rho ((4 D_V)/(pi D^2))^2 L)/(2 D)
        = (8 xi1 rho D_V^2 L)/(D^5 pi^2)
        = #qty(scientifique(DP1, 1), "Pa")
    $

    Dans la seconde conduite, le nombre de Reynolds est :
    #let D2 = 0.15
    #let Re2 = 4 * Dv * mv / (visc * calc.pi * D2)
    $
        R_e_2 = #num(scientifique(Re2, 2))
    $
    Le coefficient de perte de charge peut être lu sur le diagramme de Moody (rugosité relative de $qty("0.15", "mm")/qty("150", "mm") = num(#scientifique(0.15 / 150, 1))$) : #num("0.02").
    La perte de charge dans la seconde conduite est donc :
    #let xi2 = 0.02
    #let L2 = 2e3
    #let DP2 = 8 * xi2 * mv * calc.pow(Dv, 2) * L2 / (calc.pow(D2, 5) * calc.pow(calc.pi, 2))
    $
        Delta P_2 = #qty(scientifique(DP2, 1), "Pa")
    $
    La perte de charge totale est $Delta P_1 + Delta P_2 = #qty(scientifique(DP1 + DP2, 1), "Pa")$

    La pression en bas du chateau d'eau est :
    #let P0 = 1e5
    #let g = 9.81
    #let h = 20
    #let Pc = P0 + mv * g * h
    $
      P_"chateau" = P_0 + rho g h = #qty(scientifique(Pc,2), "Pa")
    $
    En tenant compte de la perte de charge, la pression disponible au niveau des poteaux d'incendie est donc :
    $
      P_"poteau" = P_"chateau" - (Delta P_1 + Delta P_2) = #qty(scientifique(Pc - (DP1 + DP2), 1), "Pa") > #qty("1", "bar")
    $
    Les poteaux d'incendie sont donc aux normes.
]
