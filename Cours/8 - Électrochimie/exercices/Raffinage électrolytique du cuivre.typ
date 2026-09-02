#import "@local/prepa:0.1.1": *
#let cpl(a, b) = [#ce(a)\/#ce(b)]

#show: exercice.with(titre: "Raffinage électrolytique du cuivre", difficulté: 2)

Une lame de cuivre plonge dans une solution de nitrate d'argent. Les courbes intensité-potentiel des couples en présence sont fournies.

#figure(image("../figures/4.png", width: 80%))

Données : $E^circ(cpl("Pb^2+", "Pb")) = qty("-0.13", "V")$, $E^circ(cpl("Cu^2+", "Cu")) = qty("0.34", "V")$, $E^circ(cpl("Ag+", "Ag")) = qty("0.80", "V")$, $E^circ(ce("O2/H2O")) = qty("1.23", "V")$.

#question(coups-de-pouce: (
  "Faire une échelle de potentiels : quelle réaction est la plus favorable ?",
  "Relier $Delta_r G^circ$ à $Delta E^circ$ et à $K^circ$. Que dire si $K^circ gt.double 1$ ?",
))[
  Écrire l'équation-bilan de la réaction. Déterminer sa constante d'équilibre à $qty("298", "K")$. Commenter.
][
  Sur l'échelle des potentiels, #ce("Ag+") (oxydant, $qty("0.80", "V")$) est au-dessus de #ce("Cu") (réducteur, $qty("0.34", "V")$) : #ce("Ag+") oxyde #ce("Cu").
  $ 2 ce("Ag+") + ce("Cu") -> 2 ce("Ag") + ce("Cu^2+") quad (n = 2) $
  $ Delta_r G^circ = - n cal(F) (E^circ(cpl("Ag+", "Ag")) - E^circ(cpl("Cu^2+", "Cu"))) = - 2 times 96500 times 0.46 approx qty("-89", "kJ/mol") $
  $ K^circ = exp(- (Delta_r G^circ) / (R T)) = 10^((n Delta E^circ) / 0.06) = 10^((2 times 0.46) / 0.06) approx 10^(15) $
  $K^circ gt.double 1$ : la réaction est quasi-totale. La lame de cuivre se recouvre spontanément d'argent.
]

#question(coups-de-pouce: (
  "Quel unique potentiel donne l'égalité des courants anodique et cathodique ? Permet-il un courant significatif ?",
))[
  À l'aide des courbes intensité-potentiel, prévoir si la réaction est rapide ou lente (un schéma est souhaité).
][
  Le système évolue au #strong[potentiel mixte] $E_m$ tel que $abs(i_"anodique") = abs(i_"cathodique")$, c'est-à-dire à l'intersection de la branche d'oxydation $ce("Cu") -> ce("Cu^2+")$ et de la branche de réduction $ce("Ag+") -> ce("Ag")$. Ces deux branches sont raides et sans surtension (couples rapides) : à $E_m$ (compris entre $qty("0.34", "V")$ et $qty("0.80", "V")$) le courant est notable. La réaction est donc #strong[rapide].

  #figure(canvas({
    import cetz.draw: *
    line((-1, 0), (5, 0), mark: (end: "stealth")); content((5, 0), anchor: "west", $E$)
    line((0, -1.6), (0, 1.6), mark: (end: "stealth")); content((0, 1.6), anchor: "south", $i$)
    // Cu -> Cu2+ (anodique) départ x=1.2
    line((1.2, 0), (1.6, 0.4), (2.4, 1.5), stroke: olive + 1.2pt)
    content((2.4, 1.2), anchor: "west", text(fill: olive, 0.8em)[Cu $->$ Cu$""^(2+)$])
    // Ag+ -> Ag (cathodique) départ x=3.2
    line((3.2, 0), (2.8, -0.4), (2.0, -1.5), stroke: blue + 1.2pt)
    content((2.0, -1.2), anchor: "east", text(fill: blue, 0.8em)[Ag$""^+ ->$ Ag])
    circle((2.2, 0), radius: 0.05, fill: red)
    content((2.2, 0), anchor: "south-west", padding: 0.2em, text(fill: red, 0.8em)[$E_m$])
  }))
]

Le raffinage électrolytique consiste à placer le cuivre impur (avec des particules de #ce("Pb") et #ce("Ag")) en anode dans une solution de sulfate de cuivre, et à déposer le cuivre pur sur une cathode support. $E_A$ est le potentiel de l'anode, $E_C$ celui de la cathode.

#figure(image("../figures/5.png", width: 80%))

#question(coups-de-pouce: (
  "$E_A$ permet-il l'oxydation de $ce(\"Pb\")$ ? de $ce(\"Cu\")$ ? de $ce(\"Ag\")$ ?",
  "Parmi les solutés produits, lesquels sont réductibles à $E_C$ ?",
))[
  Écrire la ou les réactions à l'anode, puis à la cathode.
][
  #strong[Anode] ($E_A$, entre $qty("0.34", "V")$ et $qty("0.80", "V")$) : sont oxydés les métaux dont $E^circ < E_A$, soit
  $ ce("Cu") -> ce("Cu^2+") + 2 e^- quad "et" quad ce("Pb") -> ce("Pb^2+") + 2 e^- $
  L'argent ($E^circ = qty("0.80", "V") > E_A$) n'est pas oxydé : il tombe au fond sous forme de #strong[boues anodiques].

  #strong[Cathode] ($E_C$, un peu en dessous de $qty("0.34", "V")$) : seul #ce("Cu^2+") est réduit,
  $ ce("Cu^2+") + 2 e^- -> ce("Cu") $
  #ce("Pb^2+") ($E^circ = qty("-0.13", "V") < E_C$) n'est pas réduit et reste en solution.
]

#question[
  Expliquer l'intérêt de cette méthode pour purifier le cuivre.
][
  L'argent, non oxydé, est récupéré séparément dans les boues anodiques (sous-produit valorisable). Le plomb, oxydé à l'anode mais non redéposé à la cathode, reste en solution. Le cuivre déposé à la cathode est donc débarrassé de ses deux impuretés : on obtient du cuivre très pur ($approx qty("99.99", "%")$).
]
