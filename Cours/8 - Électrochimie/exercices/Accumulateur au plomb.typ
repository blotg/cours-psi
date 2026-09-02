#import "@local/prepa:0.1.1": *
#let cpl(a, b) = [#ce(a)\/#ce(b)]

#show: exercice.with(titre: "Accumulateur au plomb", difficulté: 2)

Les accumulateurs au plomb équipent encore beaucoup de véhicules. Électrodes : plomb et oxyde de plomb #ce("PbO2(s)") ; électrolyte : acide sulfurique (#ce("H+ + HSO4^-")). Schéma : $ce("Pb(s) | PbSO4(s) | H+ + HSO4^- | PbSO4(s) | PbO2(s)")$.

Réactions de décharge :
- $ce("PbO2(s) + 3 H+ + HSO4^- + 2 e^- -> PbSO4(s) + 2 H2O")$, $E^circ_1 = qty("1.70", "V")$
- $ce("Pb(s) + HSO4^- -> PbSO4(s) + H+ + 2 e^-")$, $E^circ_2 = qty("-0.36", "V")$

Données : $"p"K_(a 1)(ce("H2SO4")/ce("HSO4^-")) = -3$ ; $"p"K_(a 2)(ce("HSO4^-")/ce("SO4^2-")) = 1.9$ ; $M(ce("O")) = qty("16.0", "g/mol")$ ; $M(ce("S")) = qty("32.1", "g/mol")$ ; $cal(F) = qty("9.65e4", "C/mol")$. Caractéristiques de la batterie : tension à vide $qty("12", "V")$, capacité $qty("100", "A h")$.

#question(coups-de-pouce: (
  "L'acide sulfurique est-il un acide fort dans l'eau (pKa1 = -3) ?",
  "Relation de Nernst pour chaque électrode.",
))[
  L'électrolyte est obtenu en introduisant #ce("H2SO4") à $c_0 = qty("1", "mol/L")$. Placer les domaines de #ce("H2SO4"), #ce("HSO4^-"), #ce("SO4^2-") sur un axe de pH. Conclure sur $ce("[H+]")$ et $ce("[HSO4^-]")$ à l'équilibre. En déduire la tension à vide d'une cellule.
][
  $"p"K_(a 1) = -3 < 0$ : #ce("H2SO4") est un acide fort, entièrement dissocié : $ce("H2SO4") -> ce("H+") + ce("HSO4^-")$. Il n'en reste pas en solution. Sur l'axe de pH : #ce("HSO4^-") prédomine pour $"pH" < 1.9$, #ce("SO4^2-") pour $"pH" > 1.9$ (#ce("H2SO4") inexistant).

  Avec $c_0 = qty("1", "mol/L")$ : $ce("[H+]") approx qty("1", "mol/L")$ ($"pH" approx 0 < 1.9$), donc la seconde acidité n'a quasiment pas lieu : $ce("[HSO4^-]") approx qty("1", "mol/L")$.

  Tension à vide $e = E_+ - E_-$ :
  $ E(ce("PbO2/PbSO4")) &= E^circ_1 + 0.03 log(ce("[H+]")^3 ce("[HSO4^-]")) = qty("1.70", "V") \
    E(ce("PbSO4/Pb")) &= E^circ_2 + 0.03 log(ce("[H+]") \/ ce("[HSO4^-]")) = qty("-0.36", "V") \
    e &= 1.70 - (-0.36) = qty("2.06", "V") approx qty("2", "V") $
]

#question(coups-de-pouce: (
  "Combiner les deux demi-équations.",
))[
  Écrire la réaction de fonctionnement (décharge).
][
  En additionnant les deux demi-équations :
  $ ce("PbO2(s)") + ce("Pb(s)") + 2 ce("H+") + 2 ce("HSO4^-") -> 2 ce("PbSO4(s)") + 2 ce("H2O") $
]

#question(coups-de-pouce: (
  "Tension à vide d'une cellule ?",
  "Cellules en série : le même courant les traverse toutes.",
))[
  De combien de cellules en série la batterie est-elle constituée ? Quelle est la capacité de chacune ?
][
  Une cellule délivre $qty("2.06", "V")$ ; la batterie $qty("12", "V")$ : $12 \/ 2.06 approx 5.8$, soit #strong[6 cellules en série].

  Les cellules étant en série, le même courant les traverse : chaque cellule a la même capacité que la batterie, soit $qty("100", "A h")$.
]

#question(coups-de-pouce: (
  "Intégrer la relation entre vitesse de réaction et courant.",
))[
  Calculer, lors d'une décharge complète, la masse de #ce("HSO4^-") consommée et celle d'eau formée.
][
  Par cellule, $Q = qty("100", "A h") = qty("3.6e5", "C")$, soit $n_e = Q \/ cal(F) = 3.6 times 10^5 \/ 9.65 times 10^4 approx qty("3.7", "mol")$ d'électrons.

  La réaction consomme $2 ce("HSO4^-")$ et forme $2 ce("H2O")$ pour $2 e^-$ : $n(ce("HSO4^-")) = n(ce("H2O")) approx qty("3.7", "mol")$ par cellule.

  Pour la batterie (6 cellules) : $n approx qty("22.4", "mol")$. Avec $M(ce("HSO4^-")) = 1 + 32.1 + 4 times 16 = qty("97.1", "g/mol")$ :
  $ m(ce("HSO4^-")) approx 22.4 times 97.1 approx qty("2.2", "kg"), quad m(ce("H2O")) approx 22.4 times 18 approx qty("0.40", "kg") $
]
