#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Calories d'un shot de vodka",
    ouvert: true,
)

#add-unit("cal", "cal", "upright(\"cal\")")

Lorsqu'il est ingéré, l'éthanol contenu dans les boissons alcoolisées est très bien métabolisé par l'organisme en dioxyde de carbone et en eau, apportant quasiment toute son énergie à l'organisme.

#question(
    coups-de-pouce: (
        "Quelle masse d'alcool contient le shot ?",
        "Quelle quantité de matière d'alcool cela représente-t-il ?",
        "Quelle est l'énergie libérée par la combustion de cette quantité d'alcool ?",
        "Quelle masse de sucre libérerait cette énergie ?",
    )
)[
    Combien de kilocalories (#unit("kcal")) sont apportées par un shot de vodka de 3 cL contenant 40 % en volume d'éthanol ? À combien de carreaux de sucre de #qty("4", "g") cela correspond-il ?
][
    Un shot de vodka de 3 cL contient $0.40 times #qty("3", "cL") = #qty(scientifique(0.4 * 3, 2), "cL")$ d'éthanol pur.

    #let m = 3e-2 * 1e-3 * 0.4 * 0.789 * 1e3
    La masse d'éthanol contenue dans le shot est donc de $m = mu_"éthanol" V = d mu_"eau" V = #qty(scientifique(m, 2), "kg")$.

    La quantité de matière d'éthanol contenue dans le shot est donc
    #let n = m / 46.0e-3
    $
      n = m/M = #qty(scientifique(n, 2), "mol")
    $

    La chaleur apportée par le shot est donc
    #let Q = n * 1367e3
    $
      Q = - n Delta_r H^circ = #qty(scientifique(Q,2), "J") = #qty(scientifique(Q / 4184, 2), "kcal")
    $

    Cette énergie est autant que celle apportée par une masse de sucre
    #let m_sucre = Q / (4.0e3 * 4184)
    $
      m_"sucre" = Q / (Delta_"comb" H^circ ("sucre")) = #qty(scientifique(m_sucre, 2), "kg")
    $

    Ce qui correspond à $m_"sucre" \/ #qty("4", "g") approx #num(scientifique(m_sucre / 4e-3, 1))$ carreaux de sucre.
]

*Données*
- Densité de l'éthanol : #num("0.789")
- Enthalpie standard de combustion de l'éthanol : $standard(Delta_r H) = qty("-1367", "kJ/mol")$
- Masse molaire de l'éthanol : #qty("46.0", "g/mol")
- Enthalpie de combustion du sucre : #qty("4.0", "kcal/g")
- $qty("1", "cal") = qty("4.184", "J")$
