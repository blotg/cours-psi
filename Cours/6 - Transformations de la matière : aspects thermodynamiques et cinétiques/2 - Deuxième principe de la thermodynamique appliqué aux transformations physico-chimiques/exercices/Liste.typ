#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Déplacement d'équilibre",
)

Pour chaque réaction, dire si elle est favorisée par une haute ou une basse température, et par une haute ou une basse pression. On se place dans l'approximation d'Ellingham.

#question()[
    La combustion du méthane $ce("C (s) + 1/2 O2 (g) -> CO (g)")$ qui est une réaction exothermique.
][
    La réaction est exothermique, elle est donc favorisée par une basse température.

    La quantité de matière de gaz augmente au cours de la réaction, elle est donc favorisée par une basse pression.
]

#question()[
    $ce("N2 (g) + 3 H2 (g) = 2 NH3 (g)")$ #h(1cm) ($Delta_f H^circ (#ce("NH3 (g)")) = #qty("-46", "kJ/mol")$)
][
    $Delta_r H^circ = 2 Delta_f H^circ (#ce("NH3 (g)")) - Delta_f H^circ (#ce("N2 (g)")) - 3 Delta_f H^circ (#ce("H2 (g)")) = #qty("-92", "kJ/mol")$ car #ce("N2 (g)") et #ce("H2 (g)") sont des corps simples dans leur état standard.

    La réaction est exothermique, elle est donc favorisée par une basse température.

    La quantité de matière de gaz diminue au cours de la réaction, elle est donc favorisée par une haute pression.
]

#question()[
    #ce("H2O (g) = H2O (l)")
][
    La réaction de condensation est exothermique, elle est donc favorisée par une basse température.

    La quantité de matière de gaz diminue au cours de la réaction, elle est donc favorisée par une haute pression.
]

#question()[
    #ce("CaCO3 (s) = CaO (s) + CO2 (g)") #h(1cm) ($Delta_r G^circ = #num("178301") - #num("160") T #unit("J/mol")$ si $T$ est en #unit("K"))
][
    Dans l'approximation d'Ellingham,
    $Delta_r G^circ = Delta_r H^circ - T Delta_r S^circ$, soit en identifiant
    $
      Delta_r H^circ = #qty("178301", "J/mol") > 0
    $
    La réaction est endothermique, elle est donc favorisée par une haute température.

    La quantité de matière de gaz augmente au cours de la réaction, elle est donc favorisée par une basse pression.
]
