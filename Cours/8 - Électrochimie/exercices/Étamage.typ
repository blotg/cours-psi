#import "@local/prepa:0.1.1": *
#let cpl(a, b) = [#ce(a)\/#ce(b)]

#show: exercice.with(titre: "Étamage", difficulté: 2)

L'étamage protège une tôle d'acier par une fine couche d'étain (fer-blanc des boites de conserve). Une expérience est menée à #qty("25", "dC") sur un échantillon de fer de surface $S = qty("240", "cm^2")$. L'électrolyte contient des ions #ce("Sn^2+") et de l'acide 4-hydroxybenzènesulfonique ; son pH est proche de $0$. L'étain intervient par le couple #cpl("Sn^2+", "Sn(s)").

#figure(canvas({
  import cetz.draw: *
  // cuve
  line((-2.4, 0), (-2.4, -3.2), (2.4, -3.2), (2.4, 0), stroke: 1pt)
  line((-2.4, -1), (2.4, -1), stroke: (paint: gray))
  // électrodes
  line((-1, -2.6), (-1, 1), stroke: 2pt)
  line((1, -2.6), (1, 1), stroke: 2pt)
  content((-1, 1), anchor: "south", padding: 0.15em, [Fe])
  content((1, 1), anchor: "south", padding: 0.15em, [Sn])
  // générateur
  line((-1, 1), (-1, 1.6), (-0.4, 1.6), stroke: 0.8pt)
  line((1, 1), (1, 1.6), (0.4, 1.6), stroke: 0.8pt)
  circle((0, 1.6), radius: 0.4, stroke: 0.8pt)
  content((0, 1.6), text(0.8em)[$~$])
}))

#question(coups-de-pouce: (
  "Quelle origine a-t-on choisie pour les potentiels en électrochimie ?",
))[
  Le potentiel standard du couple #cpl("H+", "H2(g)") n'est pas donné. Pourquoi ?
][
  Par convention, l'électrode standard à hydrogène sert d'origine des potentiels : $E^circ(cpl("H+", "H2")) = qty("0", "V")$ à toute température. Il est donc inutile de le préciser.
]

#question(coups-de-pouce: (
  "Dans quel sens se déplacent les électrons ? Quelle réaction a lieu à l'électrode où ils arrivent ? D'où partent-ils ?",
  "L'étamage dépose de l'étain sur le fer.",
))[
  Compléter le schéma : polarité du générateur, sens du courant, nature (anode / cathode) de chaque électrode.
][
  L'étamage dépose #ce("Sn") sur le fer : la réduction $ce("Sn^2+") + 2 e^- -> ce("Sn")$ a lieu sur le fer, qui est donc la #strong[cathode], reliée à la borne $-$ du générateur. L'électrode d'étain est l'#strong[anode] ($ce("Sn") -> ce("Sn^2+") + 2 e^-$), reliée à la borne $+$.

  Les électrons partent de la borne $-$, vont vers la cathode (Fe), reviennent de l'anode (Sn) vers la borne $+$. Le courant conventionnel circule en sens inverse : dans l'électrolyte, il va de l'anode (Sn) vers la cathode (Fe).
]

#question(coups-de-pouce: (
  "Quelle espèce de la solution peut produire un gaz par réduction ?",
))[
  Un petit dégagement gazeux est observé à l'électrode de fer. Quel est-il ?
][
  Le fer est la cathode : il s'y produit une réduction. La seule espèce réductible produisant un gaz est #ce("H+") (pH proche de $0$) : $2 ce("H+") + 2 e^- -> ce("H2")$. Le gaz est du #strong[dihydrogène].
]

#question(coups-de-pouce: (
  "Le fer réagit-il ?",
  "La courbe de l'étain a-t-elle un palier de diffusion ? Un surpotentiel ?",
))[
  La surtension cathodique de #cpl("H+", "H2") est $eta_c = qty("-0.40", "V")$ (identique sur Fe et Sn) ; le couple #cpl("Sn^2+", "Sn") est rapide. Écrire les échanges électroniques à chaque électrode et représenter les courbes intensité-potentiel correspondantes.
][
  - #strong[Cathode (Fe)] : $ce("Sn^2+") + 2 e^- -> ce("Sn")$ (souhaitée) et $2 ce("H+") + 2 e^- -> ce("H2")$ (parasite). Le fer ne réagit pas (il est protégé, c'est la cathode).
  - #strong[Anode (Sn)] : $ce("Sn") -> ce("Sn^2+") + 2 e^-$.

  Courbes $i$–$E$ : la branche de réduction de #ce("Sn^2+") part de $E^circ(cpl("Sn^2+", "Sn")) = qty("-0.14", "V")$ (couple rapide) et présente un palier de diffusion (#ce("Sn^2+") est un soluté). La branche d'oxydation de #ce("Sn") part aussi de $qty("-0.14", "V")$, sans palier (l'électrode elle-même est le réactif). Le dégagement de #ce("H2") débute vers $E_"eq"(cpl("H+", "H2")) + eta_c = 0 - 0.40 = qty("-0.40", "V")$, sans palier (#ce("H+") abondant à pH $0$).

  #figure(canvas({
    import cetz.draw: *
    line((-4, 0), (4, 0), mark: (end: "stealth"))
    content((4, 0), anchor: "west", padding: 0.2em, $E$)
    line((0, -2), (0, 2.4), mark: (end: "stealth"))
    content((0, 2.4), anchor: "south", $i$)
    // oxydation Sn (i>0) à partir de -0.14 (x = -0.7)
    line((-0.7, 0), (-0.4, 0.3), (0.2, 1.9), stroke: olive + 1.2pt)
    content((0.3, 1.6), anchor: "west", text(fill: olive)[Sn $->$ Sn$""^(2+)$])
    // réduction Sn (i<0) palier
    line((-0.7, 0), (-1.1, -0.5), (-1.6, -0.8), (-3.2, -0.85), stroke: olive + 1.2pt)
    content((-2.6, -0.85), anchor: "south", text(fill: olive, 0.85em)[Sn$""^(2+) ->$ Sn])
    // H+ -> H2 à partir de -0.40 (x = -2)
    line((-2, 0), (-2.4, -0.6), (-3, -1.9), stroke: blue + 1.2pt)
    content((-3, -1.7), anchor: "east", text(fill: blue, 0.85em)[H$""^+ ->$ H$""_2$])
  }))
]

#question(coups-de-pouce: (
  "Intégrer $i = - n cal(F) dv(xi, t)$.",
))[
  Exprimer puis calculer la masse maximale $m$ d'étain déposée, sachant que $i = qty("1.0", "A")$ et que l'électrolyse dure $qty("4", "min")$.
][
  Au mieux, tout le courant sert au dépôt d'étain. La charge est $Q = i thin t = 1.0 times 240 = qty("240", "C")$ (l'électrolyse dure $qty("4", "min") = qty("240", "s")$). Avec $n = 2$ :
  $ m = (Q)/(n cal(F)) M(ce("Sn")) = 240/(2 times 96500) times 118.7 approx qty("0.15", "g") $
]

#question[
  La masse mesurée est $qty("0.12", "g")$. Calculer le rendement faradique.
][
  $ rho_F = (0.12)/(0.15) approx 0.80 = qty("80", "%") $
  Les $qty("20", "%")$ manquants correspondent au courant ayant servi au dégagement de #ce("H2").
]
