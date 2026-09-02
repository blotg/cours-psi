#import "@local/prepa:0.1.1": *

#show: exercice.with(titre: "Champ de gravitation d'une planète", difficulté: 2, numérique: true)

La masse volumique d'une planète de rayon $R = qty("6400", "km")$ varie avec la distance $r$ au centre selon $mu(r) = mu_0 (1 - a (r/R)^2)$. La masse volumique moyenne de la planète vaut $mu_"moy" = m_"planète" \/ V_"planète" = qty("5.52e3", "kg/m^3")$ et celle des roches superficielles vaut $mu(R) = qty("2.67e3", "kg/m^3")$.

#question(coups-de-pouce: (
  "La masse volumique moyenne et celle des roches superficielles donnent deux équations.",
  "Exprimer la masse totale comme une intégrale de $mu(r)$ sur la boule.",
))[
  Calculer numériquement $mu_0$ et $a$.
][
  En surface : $mu(R) = mu_0 (1 - a)$.

  Masse totale : $ m = integral_0^R mu(r) 4 pi r^2 dif r = 4 pi mu_0 (R^3/3 - a R^3/5) = 4 pi mu_0 R^3 (1/3 - a/5) $
  d'où $ mu_"moy" = m/((4\/3) pi R^3) = mu_0 (1 - 3a/5) $

  Le rapport des deux relations élimine $mu_0$ :
  $ (1 - 3a/5)/(1 - a) = mu_"moy"/mu(R) = 5.52/2.67 approx 2.07 quad => quad a approx 0.73 $
  puis $ mu_0 = mu(R)/(1 - a) approx (2.67 times 10^3)/(0.27) approx qty("9.8e3", "kg/m^3") $
]

#question(coups-de-pouce: (
  "Effectuer les quatre étapes : invariances, symétries, choix de la surface de Gauss, théorème de Gauss gravitationnel.",
))[
  Établir l'expression du champ de gravitation créé par la planète dans tout l'espace.
][
  Par symétrie sphérique, $va(g) = g(r) va(e_r)$. Surface de Gauss : sphère de rayon $r$. Le théorème de Gauss gravitationnel donne $g(r) times 4 pi r^2 = - 4 pi cal(G) M_"int"$.

  #strong[Pour $r >= R$ :] $M_"int" = m = mu_"moy" (4/3) pi R^3$, d'où
  $ va(g) = - (cal(G) m)/r^2 va(e_r) = - (4 pi cal(G) mu_"moy" R^3)/(3 r^2) va(e_r) $

  #strong[Pour $r <= R$ :] $ M_"int"(r) = integral_0^r mu_0 (1 - a s^2/R^2) 4 pi s^2 dif s = 4 pi mu_0 (r^3/3 - (a r^5)/(5 R^2)) $
  d'où
  $ va(g) = - 4 pi cal(G) mu_0 (r/3 - (a r^3)/(5 R^2)) va(e_r) $
]

#question(coups-de-pouce: (
  "Dériver $g(r)$ par rapport à $r$ pour trouver son extrémum.",
))[
  Pour quel rayon le champ de gravitation est-il maximal à l'intérieur de la planète ? L'exprimer en fonction de $R$.
][
  Pour $r <= R$, $norm(va(g)) = 4 pi cal(G) mu_0 (r/3 - (a r^3)/(5 R^2))$. Sa dérivée s'annule pour
  $ 1/3 - (3 a r^2)/(5 R^2) = 0 quad => quad r_"max" = R sqrt(5/(9 a)) approx 0.87 R $
  (La dérivée seconde est négative : c'est bien un maximum.) Le champ de gravitation est donc plus intense à mi-profondeur des roches qu'en surface.
]
