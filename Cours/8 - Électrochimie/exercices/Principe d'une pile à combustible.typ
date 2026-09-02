#import "@local/prepa:0.1.1": *
#let cpl(a, b) = [#ce(a)\/#ce(b)]

#show: exercice.with(titre: "Principe d'une pile à combustible", difficulté: 2)

Modèle simple d'une pile à combustible : deux compartiments, chacun avec une électrode de platine plongée dans de l'acide phosphorique ($"pH" = 0$), séparés par une jonction électrolytique idéale. Le compartiment 1 est alimenté en #ce("H2"), le compartiment 2 en #ce("O2").

Données : $E^circ(ce("O2/H2O")) = qty("1.23", "V")$ à $qty("298", "K")$ ; $Delta_f H^circ(ce("H2O(l)")) = qty("-285.10", "kJ/mol")$ ; $S_m^circ$ : #ce("H2O(l)") $qty("69.96", "J/mol/K")$, #ce("H2(g)") $qty("130.46", "J/mol/K")$, #ce("O2(g)") $qty("204.82", "J/mol/K")$.

#question(coups-de-pouce: (
  "Écrire les demi-équations. L'anode est-elle siège d'une oxydation ou d'une réduction ?",
  "Les électrons sont attirés par quelle borne ?",
))[
  Expliquer le fonctionnement : nom et réaction de chaque électrode, polarité, sens du courant, sens de circulation des électrons.
][
  Couples : #ce("O2/H2O") ($qty("1.23", "V")$) et #cpl("H+", "H2") ($qty("0", "V")$). #ce("O2") est le meilleur oxydant, #ce("H2") le meilleur réducteur.

  - #strong[Compartiment 1] : $ce("H2") -> 2 ce("H+") + 2 e^-$ (oxydation) $=>$ #strong[anode], borne $-$.
  - #strong[Compartiment 2] : $ce("O2") + 4 ce("H+") + 4 e^- -> 2 ce("H2O")$ (réduction) $=>$ #strong[cathode], borne $+$.

  Dans le circuit extérieur, les électrons vont de l'anode ($-$) vers la cathode ($+$). Le courant conventionnel circule en sens inverse ; à l'intérieur, la conduction est assurée par la migration des ions #ce("H+") du compartiment 1 vers le compartiment 2.
]

#question(coups-de-pouce: (
  "L'électrolyte joue le rôle d'un pont salin.",
))[
  Quel est le rôle de l'électrolyte ? Écrire la réaction globale (coefficient $2$ pour l'eau).
][
  L'électrolyte assure la conduction ionique (il ferme le circuit, comme un pont salin) et empêche le mélange direct de #ce("H2") et #ce("O2"). Réaction globale :
  $ 2 ce("H2") + ce("O2") -> 2 ce("H2O") $
]

#question(coups-de-pouce: (
  "Loi de Hess pour $Delta_r H^circ$ et $Delta_r S^circ$ ; approximation d'Ellingham : indépendants de $T$.",
))[
  Dans l'approximation d'Ellingham, montrer que $Delta_r G^circ = - 570.2 + 0.326 thin T$ (en kJ/mol).
][
  Pour $2 ce("H2") + ce("O2") -> 2 ce("H2O(l)")$ :
  $ Delta_r H^circ &= 2 Delta_f H^circ(ce("H2O(l)")) = qty("-570.2", "kJ/mol") \
    Delta_r S^circ &= 2 times 69.96 - 2 times 130.46 - 204.82 = qty("-325.8", "J/mol/K") approx qty("-0.326", "kJ/mol/K") $
  Dans l'approximation d'Ellingham ($Delta_r H^circ$ et $Delta_r S^circ$ indépendants de $T$) :
  $ Delta_r G^circ = Delta_r H^circ - T Delta_r S^circ = - 570.2 + 0.326 thin T quad (upright("kJ/mol")) $
]

#question(coups-de-pouce: (
  "Exprimer le quotient réactionnel avec $p(ce(\"O2\"))$ et $p(ce(\"H2\"))$.",
  "Relier la f.é.m. à $Delta_r G$.",
))[
  Exprimer la force électromotrice (tension à vide) en fonction des potentiels standard, de $T$ et des pressions partielles $p(ce("O2"))$ et $p(ce("H2"))$.
][
  Avec $n = 4$ électrons échangés, $e = - Delta_r G \/ (n cal(F))$ et $Delta_r G = Delta_r G^circ + R T ln Q$ où $Q = (p^circ)^3 \/ (p(ce("H2"))^2 p(ce("O2")))$ (activité de l'eau liquide égale à $1$). D'où
  $ e = - (Delta_r G^circ)/(4 cal(F)) + (R T)/(4 cal(F)) ln (p(ce("H2"))^2 thin p(ce("O2")))/(p^circ)^3 $
  À $qty("298", "K")$ et pressions standard, $e^circ = - Delta_r G^circ \/ (4 cal(F)) approx qty("1.23", "V") = E^circ(ce("O2/H2O")) - E^circ(cpl("H+", "H2"))$.
]

#question[
  Pour $p(ce("O2")) = p(ce("H2")) = qty("1", "bar")$, calculer la force électromotrice à $T = qty("350", "K")$.
][
  Le terme logarithmique est nul :
  $ e = - (Delta_r G^circ (350))/(4 cal(F)) = (570200 - 0.326 times 350 times 1000)/(4 times 96500) approx qty("1.18", "V") $
]
