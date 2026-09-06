#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Solubility of calcite",
)

We consider the reaction #ce("CaCO3(s) = Ca^2+(aq) + CO3^2-(aq)").

#let DrG = -(-1128.8e3) + (-553.5e3) + (-527.9e3)
#question(
    coups-de-pouce: "Use the standard Gibbs free energies of formation.",
)[
    Calculate the standard Gibbs free energy change of reaction for the dissolution of calcite.
][
    Hess's law states that
    $
        Delta_r G^circ = - Delta_f G^circ (ce("CaCO3(s)")) + Delta_f G^circ (ce("Ca^2+")) + Delta_f G^circ (ce("CO3^2-"))\
        = #qty(scientifique(DrG, 4), "J/mol")
    $
]

#let K = calc.exp(-DrG / (8.314 * 298))
#question(
    coups-de-pouce: (
        "What is a solubility product?",
        "How is the equilibrium constant related to the Gibbs free energy of reaction?",
    ),
)[
    Deduce the solubility product of calcite at room temperature.
][
    The solubility product is given by
    $
        K^circ = exp(- (Delta_r G^circ) / (R T))\
        = #num(scientifique(K, 2))
    $
]

*Data at $T=#qty("298", "K")$*

The chemical species are solutes in water.

#table(
    columns: 4,
    align: (left,) + (center,) * 3,
    [Chemical species], ce("CaCO3(s)"), ce("Ca^2+(aq)"), ce("CO3^2-(aq)"),
    [$Delta_f G^circ$ (#unit("kJ/mol"))], num("-1128.8"), num("-553.5"), num("-527.9"),
)
