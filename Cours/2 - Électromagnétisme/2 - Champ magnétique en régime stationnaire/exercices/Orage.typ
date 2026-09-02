#import "@local/prepa:0.1.1": *

#show: exercice.with(titre: "Orage", difficulté: 1)

Au cours d'un orage, un éclair peut être assimilé à un conduit cylindrique rectiligne de rayon $a = qty("10", "cm")$ parcouru par un courant $I = qty("1e5", "A")$ de densité volumique de courant uniforme. On suppose dans un premier temps le courant ascendant et on néglige les effets de bord. On se place en coordonnées cylindriques d'axe $(O z)$ celui du conduit.

#question(coups-de-pouce: (
  "Quelle est la direction de la vitesse des électrons ? Celle du champ magnétique créé par le courant ?",
))[
  Faire un schéma et expliquer pourquoi les électrons de ce courant sont soumis à une force magnétique de Lorentz. Quel est son sens ?
][
  Les électrons sont des particules chargées en mouvement dans le champ magnétique créé par le courant : ils subissent la partie magnétique de la force de Lorentz $va(f) = (-e) va(v) and va(B)$.

  #figure(canvas({
    import cetz.draw: *
    // conduit
    line((-0.6, -2), (-0.6, 2), stroke: gray)
    line((0.6, -2), (0.6, 2), stroke: gray)
    content((0.6, 2), anchor: "south", padding: 0.2em, text(fill: gray)[$a$])
    // courant / densité de courant
    line((0, -1.6), (0, 1.6), mark: (end: "stealth"), stroke: red + 1pt)
    content((0, 1.6), anchor: "west", padding: 0.3em, text(fill: red)[$va(j)$])
    // vitesse des électrons
    line((0.28, 0.8), (0.28, -0.4), mark: (end: "stealth"), stroke: blue)
    content((0.28, -0.4), anchor: "west", padding: 0.2em, text(fill: blue)[$va(v)$])
    // champ orthoradial
    arc((1.4, 0), start: -35deg, stop: 35deg, radius: 1.4, mark: (end: "stealth"))
    content((1.55, 0.9), text[$va(B)$])
    // force
    line((0.45, -1.2), (-0.15, -1.2), mark: (end: "stealth"), stroke: olive + 1pt)
    content((-0.15, -1.2), anchor: "east", padding: 0.2em, text(fill: olive)[$va(f)$])
  }))

  Le courant est ascendant donc $va(j) = j va(e_z)$ avec $j > 0$, et la vitesse des électrons est selon $-va(e_z)$. Le champ créé par le fil est orthoradial, $va(B) = B(r) va(e_theta)$ avec $B(r) > 0$. La force sur un électron est
  $ va(f) = (-e)(-v va(e_z)) and (B va(e_theta)) = e v B (va(e_z) and va(e_theta)) = - e v B va(e_r) $
  Elle est dirigée vers l'axe du conduit : le courant tend à se resserrer (effet de pincement magnétique).
]

#question(coups-de-pouce: (
  "Relier le courant total à $va(j)$, uniforme sur la section du conduit.",
))[
  Exprimer le vecteur densité volumique de courant $va(j)$.
][
  $va(j)$ est uniforme et dirigé selon $va(e_z)$. Le courant total est le flux de $va(j)$ à travers une section :
  $ I = integral.double va(j) dot va(dif S) = j pi a^2 quad => quad va(j) = I/(pi a^2) va(e_z) $
]

#question(coups-de-pouce: (
  "Effectuer les quatre étapes : invariances, symétries, choix du contour d'Ampère, théorème d'Ampère.",
  "On ne demande $va(B)$ qu'au bord du conduit, en $r = a$.",
))[
  Déterminer $va(B)$ au niveau du bord du conduit, puis exprimer la norme de la force magnétique par unité de volume subie par les charges, en fonction de $I$ et $a$.
][
  #strong[Invariances.] La distribution de courant est invariante par rotation d'angle $theta$ et par translation selon $z$ : $va(B)$ ne dépend que de $r$.

  #strong[Symétries.] Pour un point $M$, le plan $(M, va(e_r), va(e_z))$ est un plan de symétrie de la distribution de courant : $va(B)(M)$ lui est orthogonal, donc $va(B) = B(r) va(e_theta)$.

  #strong[Contour d'Ampère.] On choisit le cercle $cal(C)$ de rayon $r = a$, d'axe $(O z)$, orienté selon $va(e_theta)$.

  #strong[Théorème d'Ampère.] $ integral.cont_(cal(C)) va(B) dot va(dif l) = 2 pi a B(a) = mu_0 I_"enlacé" = mu_0 I $
  d'où, au bord du conduit,
  $ va(B)(a) = (mu_0 I)/(2 pi a) va(e_theta) $

  La force volumique subie par les porteurs est $va(f)_"vol" = va(j) and va(B)$ (force de Laplace volumique). Au bord :
  $ va(f)_"vol" = I/(pi a^2) va(e_z) and (mu_0 I)/(2 pi a) va(e_theta) = - (mu_0 I^2)/(2 pi^2 a^3) va(e_r) $
  soit une norme $ norm(va(f)_"vol") = (mu_0 I^2)/(2 pi^2 a^3) $
]

#question(coups-de-pouce: (
  "Quel serait alors le sens de $va(v)$ ? Celui de $va(B)$ ?",
))[
  Le sens de la force change-t-il si le courant est descendant ?
][
  Non. Si le courant est descendant, $va(j)$ change de sens (donc $va(B)$ aussi) et la vitesse des électrons change également de sens. La force $va(j) and va(B)$, quadratique en le courant, est inchangée : elle reste dirigée vers l'axe. L'effet de pincement ne dépend pas du sens du courant.
]

#question(coups-de-pouce: (
  "Relier le poids volumique à la masse volumique de l'air, environ 1,2 kg·m⁻³.",
  "Que se passe-t-il quand un gaz est brutalement soumis à une force très intense ?",
))[
  Faire l'application numérique de cette force volumique et la comparer au poids volumique de l'air. Pourquoi les éclairs causent-ils le tonnerre#footnote[L'éclair est le résultat visible du passage du courant ; le tonnerre est le son produit.] ?
][
  $ norm(va(f)_"vol") = (mu_0 I^2)/(2 pi^2 a^3) = (4 pi times 10^(-7) times (10^5)^2)/(2 pi^2 times (0.1)^3) approx qty("6e5", "N/m^3") $
  Le poids volumique de l'air vaut $rho_"air" g approx 1.2 times 9.8 approx qty("12", "N/m^3")$, soit environ $50 000$ fois moins.

  La force de pincement comprime donc très violemment le gaz du canal ionisé, qui est en outre porté à très haute température par effet Joule. Cette compression brutale suivie d'une détente engendre une onde de choc dans l'air : c'est le tonnerre.
]
