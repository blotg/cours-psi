#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Compensateur de puissance réactive",
    difficulté: 1,
    ouvert: true,
)

#let P = 2000
#let cos-phi = 0.8

En France, le réseau électrique a une tension efficace de #qty("230", "V") et une fréquence de #qty("50", "Hz"). En Corée du Sud, la tension efficace est de #qty("220", "V") et la fréquence de #qty("60", "Hz").

Un appareil modélisé par une bobine réelle consomme #qty(P, "W") et a un facteur de puissance de #num(scientifique(cos-phi, 2)) en France.

#question(
    coups-de-pouce: (
        "Calculer la résistance et l'inductance de l'appareil.",
        "Exprimer l'impédance de l'appareil en fonction de la résistance et de l'inductance. Comment s'écrit le facteur de puissance en fonction de ces grandeurs ?",
        "Exprimer l'admittance de l'appareil en fonction de la résistance et de l'inductance. Comment s'écrit la puissance consommée en fonction de ces grandeurs et de la tension efficace ?",
    ),
)[
    Quelle puissance consommera l'appareil en Corée du Sud si on le branche directement sur le réseau coréen ? Quel sera son facteur de puissance ?
][
    On commence par chercher la résistance et l'inductance de l'appareil.

    L'appareil a une impédance $underline(Z)=R+j L omega$ et une admittance $underline(Y)=1/underline(Z)=(R-j L omega)/(R^2+(L omega)^2)$. Son facteur de puissance est
    $ cos(phi) = Re(underline(Z))/(|Z|) = R/sqrt(R^2+(L omega)^2) $

    L'appareil consomme une puissance
    $
        P & = U_"eff"^2 Re(underline(Y)) \
          & = U_"eff"^2 R/(R^2+(L omega)^2) & = U_"eff"^2 (cos^2phi)/(R)
    $
    #let R = calc.pow(230, 2) / P * calc.pow(cos-phi, 2)
    D'où $R=U_"eff"^2/P cos^2phi = #qty(scientifique(R, 2), "O")$

    On a également $tan(phi) = Im(underline(Z))/Re(underline(Z)) = (L omega)/R$ d'où
    #let L = R / (2 * calc.pi * 50) * calc.tan(calc.acos(cos-phi))
    $
        L & = R/omega tan(phi) \
          & = R/omega tan(arccos(cos(phi))) & = #qty(scientifique(L, 2), "H")
    $

    On peut maintenant calculer le facteur de puissance en Corée
    #let cos-phi-2 = R / calc.sqrt(calc.pow(R, 2) + calc.pow((L * 2 * calc.pi * 60), 2))
    $
        cos(phi) & = R/sqrt(R^2+(L omega)^2) \
                 & = #num(scientifique(cos-phi-2, 2))
    $
    La puissance consommée est
    #let P2 = calc.pow(220, 2) * calc.pow(cos-phi-2, 2) / R
    $
        P & = U_"eff"^2 (cos^2phi)/(R) \
          & = #qty(scientifique(P2, 2), "W")
    $
]
