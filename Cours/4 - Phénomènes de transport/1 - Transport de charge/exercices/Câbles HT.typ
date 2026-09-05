#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Choix du métal d'une ligne haute tension",
    ouvert: true,
)

Les câbles haute tension ont une résistance linéique de l'ordre de #qty("0.1", "O/km"). On cherche à faire en sorte que ces câbles soient les plus légers possible afin de réduire les coûts des pylônes.

#figure(
    table(
        columns: (auto, auto, auto),
        [Matériau], [Conductivité (#unit("S/m"))], [Masse volumique (#unit("kg/m^3"))],
        [Cuivre], num("6e7"), num("8.96e3"),
        [Aluminium], num("3.8e7"), num("2.7e3"),
        [Graphite], num("2e4"), num("2.25e3"),
    ),
)

#question(
    coups-de-pouce: (
        "Calculer la section nécessaire pour chaque matériau afin d'obtenir la résistance linéique souhaitée.",
        "En déduire la masse linéique pour chaque matériau.",
    ),
)[
    Parmi les matériaux listés, quel est le plus approprié ?
][
    La résistance linéique s'écrit
    $ R_l = R/l = (l/(gamma S))/l = 1/(gamma S) $
    d'où $ S = 1/(gamma R_l) $

    La masse linéique est donc
    $ mu = m/l = (rho S l)/l = rho S = rho/(gamma R_l) $

    Le calcul de la masse linéique pour chaque matériau donne :
    #figure(
        table(
            columns: (auto, auto),
            [Matériau], [Masse linéique (#unit("kg/m"))],
            [Cuivre], num(scientifique(8.96e3 / (6e7 * 0.1e-3), 1)),
            [Aluminium], num(scientifique(2.7e3 / (3.8e7 * 0.1e-3), 1)),
            [Graphite], num(scientifique(2.25e3 / (2e4 * 0.1e-3), 1)),
        ),
    )
    Le matériau le plus léger est l'aluminium.
]

