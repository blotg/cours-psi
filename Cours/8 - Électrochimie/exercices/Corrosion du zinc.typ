#import "@local/prepa:0.1.1": *
#let cpl(a, b) = [#ce(a)\/#ce(b)]

#show: exercice.with(titre: "Corrosion du zinc", difficulté: 3)

On considère $qty("1", "L")$ d'eau désaérée par barbotage d'argon (#ce("O2") dissous chassé), à $"pH" = 6.0$, sous $p = p^circ$ et $T = qty("298", "K")$. On y introduit une tôle en acier électro-zingué (acier recouvert de zinc). On admet $ce("[Zn^2+]") = qty("1e-6", "mol/L")$ (seuil de corrosion). Les pressions des gaz valent $qty("1", "bar")$.

Données : $E^circ(cpl("Zn^2+", "Zn")) = qty("-0.76", "V")$, $E^circ(cpl("Fe^2+", "Fe")) = qty("-0.44", "V")$, $E^circ(ce("O2/H2O")) = qty("1.23", "V")$. Surtensions cathodiques (à vide) de dégagement de #ce("H2") : $qty("-0.75", "V")$ sur #ce("Zn"), $qty("-0.25", "V")$ sur #ce("Fe"). On prend $(R T \/ cal(F)) ln 10 approx qty("0.06", "V")$.

#question(coups-de-pouce: (
  "Écrire la relation de Nernst pour chaque couple.",
))[
  À $"pH" = 6.0$, calculer les potentiels d'équilibre des couples #cpl("H+", "H2"), #ce("O2/H2O") et #cpl("Zn^2+", "Zn").
][
  $ E(cpl("H+", "H2")) &= 0 - 0.06 "pH" = qty("-0.36", "V") \
    E(ce("O2/H2O")) &= 1.23 - 0.06 "pH" = qty("0.87", "V") \
    E(cpl("Zn^2+", "Zn")) &= -0.76 + 0.03 log ce("[Zn^2+]") = -0.76 - 0.18 = qty("-0.94", "V") $
]

#question(coups-de-pouce: (
  "Faire une échelle de potentiels.",
))[
  Écrire la réaction qui peut #emph[a priori] être observée.
][
  L'eau étant désaérée, le seul oxydant disponible est #ce("H+") ($qty("-0.36", "V")$), situé au-dessus de #ce("Zn") ($qty("-0.94", "V")$) sur l'échelle :
  $ ce("Zn") + 2 ce("H+") -> ce("Zn^2+") + ce("H2") $
]

#question(coups-de-pouce: (
  "Combiner potentiel d'équilibre et surtension pour le potentiel de début de réaction.",
  "Dans quel domaine y a-t-il égalité des courants anodique et cathodique ?",
))[
  En fait, aucun dégagement gazeux n'est observé. L'expliquer en calculant le potentiel de début de dégagement gazeux. Tracer l'allure de la courbe $i$–$E$. Dans quel domaine se situe le potentiel de la tôle ?
][
  Sur le zinc, le dégagement de #ce("H2") ne débute qu'à
  $ E(cpl("H+", "H2")) + eta_c = -0.36 - 0.75 = qty("-1.11", "V") $
  L'oxydation du zinc débute quant à elle à $E(cpl("Zn^2+", "Zn")) = qty("-0.94", "V")$.

  Ces deux branches ne se recouvrent pas : l'oxydation exige $E > qty("-0.94", "V")$, la réduction de #ce("H+") exige $E < qty("-1.11", "V")$. Entre les deux, le courant est négligeable. La corrosion est donc quasi nulle : pas de dégagement gazeux. Le potentiel de la tôle se situe dans l'intervalle $[-1.11 ; -0.94]$ V, où $i approx 0$. (De plus, à $"pH" = 6$, #ce("H+") est très dilué : sa réduction est en outre limitée par un palier de diffusion très bas.)

  #figure(canvas({
    import cetz.draw: *
    line((-3.4, 0), (2, 0), mark: (end: "stealth")); content((2, 0), anchor: "west", $E$)
    line((0, -1.6), (0, 1.6), mark: (end: "stealth")); content((0, 1.6), anchor: "south", $i$)
    // Zn -> Zn2+ départ x = -0.9 (E=-0.94)
    line((-0.9, 0), (-0.5, 0.5), (0.4, 1.5), stroke: olive + 1.2pt)
    content((0.4, 1.2), anchor: "west", text(fill: olive, 0.8em)[Zn $->$ Zn$""^(2+)$])
    // H+ -> H2 départ x = -2.6 (E=-1.11)
    line((-2.6, 0), (-2.9, -0.6), (-3.3, -1.5), stroke: blue + 1.2pt)
    content((-3.3, -1.2), anchor: "east", text(fill: blue, 0.8em)[H$""^+ ->$ H$""_2$])
    // domaine tôle
    line((-2.6, -0.15), (-0.9, -0.15), stroke: (paint: red, thickness: 2pt))
    content((-1.75, -0.15), anchor: "north", text(fill: red, 0.75em)[tôle : $i approx 0$])
  }))
]

#question(coups-de-pouce: (
  "Relation de Nernst.",
))[
  La tôle est rayée, l'acier est mis à nu au fond de la rayure. Déterminer le potentiel du couple #cpl("Fe^2+", "Fe") (concentrations solubles $qty("1e-6", "mol/L")$).
][
  $ E(cpl("Fe^2+", "Fe")) = -0.44 + 0.03 log ce("[Fe^2+]") = -0.44 - 0.18 = qty("-0.62", "V") $
]

#question(coups-de-pouce: (
  "Superposer les courbes $i$–$E$ sur Fe et sur Zn.",
  "Quel unique potentiel vérifie l'égalité des courants anodique et cathodique ? Quelles réactions s'y produisent ?",
))[
  Représenter l'allure des courbes $i$–$E$ des couples #cpl("Fe^2+", "Fe"), #cpl("Zn^2+", "Zn") et du dégagement de #ce("H2") sur #ce("Fe") et sur #ce("Zn"). Écrire les réactions au voisinage de la rayure en identifiant anode et cathode. Expliquer pourquoi le zinc évite l'oxydation du fer.
][
  Fer et zinc étant électriquement reliés, ils se portent à un même potentiel mixte $E_m$ tel que le courant anodique total égale le courant cathodique total.

  Potentiels : $E(cpl("Zn^2+", "Zn")) = qty("-0.94", "V")$, $E(cpl("Fe^2+", "Fe")) = qty("-0.62", "V")$. Le dégagement de #ce("H2") débute à $qty("-1.11", "V")$ sur #ce("Zn") et à $-0.36 - 0.25 = qty("-0.61", "V")$ sur #ce("Fe").

  Le zinc, plus réducteur, s'oxyde préférentiellement : $ce("Zn") -> ce("Zn^2+") + 2 e^-$ (#strong[anode sacrificielle]). Les électrons libérés servent à la réduction $2 ce("H+") + 2 e^- -> ce("H2")$, qui se produit sur le fer (surtension de #ce("H2") plus faible sur #ce("Fe")) : le fer est la #strong[cathode]. Le potentiel mixte $E_m$ se cale entre $qty("-0.94", "V")$ et $qty("-0.62", "V")$ ; comme $E_m < E(cpl("Fe^2+", "Fe"))$, le fer #strong[ne peut pas s'oxyder] : il est protégé tant qu'il reste du zinc.
]
