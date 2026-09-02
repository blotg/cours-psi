#import "@local/prepa:0.1.1": *
#let cpl(a, b) = [#ce(a)\/#ce(b)]

#show: exercice.with(titre: "Pile au lithium", difficulté: 2)

Les piles au lithium équipent de nombreux appareils. Borne positive en #ce("MnO2"), borne négative en lithium ; électrolyte : un sel de lithium (#ce("LiPF6")) dans un solvant organique, concentré en #ce("Li+"). Le compartiment cathodique contient des ions #ce("H+"). Couples : #ce("MnO2(s)/MnO(OH)(s)") et #cpl("Li+", "Li(s)").

Données : $E^circ(cpl("Li+", "Li")) = qty("-3.0", "V")$, $E^circ(ce("MnO2/MnO(OH)")) = qty("1.0", "V")$ ; masse de l'électrode de lithium $qty("2.0", "g")$, $M(ce("Li")) = qty("6.9", "g/mol")$ ; courant débité $I = qty("0.1", "mA")$ ; $qty("1", "A h") = qty("3600", "C")$.

#question(coups-de-pouce: (
  "L'électrode de lithium est-elle borne $+$ ou $-$ ? Pour une pile, anode ou cathode ?",
  "Que se passe-t-il si on met du lithium solide en présence d'eau ?",
))[
  Écrire les réactions à chaque électrode (en précisant leur nature), puis la réaction globale. Exprimer la force électromotrice théorique initiale en fonction des activités de #ce("H+") et #ce("Li+"). Pourquoi l'électrolyte n'est-il pas aqueux ?
][
  - #strong[Électrode de lithium] (borne $-$, anode) : $ce("Li") -> ce("Li+") + e^-$ (oxydation).
  - #strong[Électrode de #ce("MnO2")] (borne $+$, cathode) : $ce("MnO2") + ce("H+") + e^- -> ce("MnO(OH)")$ (réduction).

  Réaction globale ($n = 1$) : $ce("Li") + ce("MnO2") + ce("H+") -> ce("Li+") + ce("MnO(OH)")$.

  Force électromotrice :
  $ e = E_+ - E_- = (1.0 + 0.06 log a(ce("H+"))) - (-3.0 + 0.06 log a(ce("Li+"))) = 4.0 + 0.06 log (a(ce("H+")))/(a(ce("Li+"))) $

  L'électrolyte n'est pas aqueux car $E^circ(cpl("Li+", "Li")) = qty("-3.0", "V")$ est très inférieur au potentiel de #ce("H2O/H2") : le lithium réagirait violemment avec l'eau ($2 ce("Li") + 2 ce("H2O") -> 2 ce("Li+") + 2 ce("HO^-") + ce("H2")$).
]

#question(coups-de-pouce: (
  "Relier masse, masse molaire et quantité de matière.",
))[
  Déterminer la quantité de matière de #ce("Li") disponible, la quantité $n_e$ d'électrons transférables (#ce("Li") limitant), et la quantité d'électricité $Q$ (en C puis en A·h).
][
  $ n(ce("Li")) = 2.0 \/ 6.9 approx qty("0.29", "mol") $
  Chaque #ce("Li") libère un électron : $n_e = qty("0.29", "mol")$.
  $ Q = n_e cal(F) = 0.29 times 96500 approx qty("2.8e4", "C") = qty("7.8", "A h") $
]

#question[
  Exprimer la capacité massique $C_m$ (quantité d'électricité par kilogramme de lithium). La comparer à celle de piles au #ce("Cd") ($480$), au #ce("Zn") ($500$) ou à l'#ce("Ag") ($820$), en A·h·kg⁻¹.
][
  $ C_m = Q \/ m(ce("Li")) = 7.8 \/ (2.0 times 10^(-3)) approx qty("3900", "A h/kg") $
  C'est bien plus élevé que pour #ce("Cd"), #ce("Zn") ou #ce("Ag") : le lithium est très léger ($M = qty("6.9", "g/mol")$) et cède un électron par atome, d'où la grande densité d'énergie des piles au lithium.
]

#question[
  Calculer l'autonomie de la pile (en années).
][
  $ t = Q \/ I = (2.8 times 10^4) \/ (1 times 10^(-4)) = qty("2.8e8", "s") approx qty("8.9", "an") $
]
