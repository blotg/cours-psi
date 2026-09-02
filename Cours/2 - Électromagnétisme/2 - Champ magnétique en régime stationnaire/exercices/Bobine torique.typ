#import "@local/prepa:0.1.1": *

#show: exercice.with(titre: "Bobine torique", difficulté: 1)

Une bobine est constituée d'un fil conducteur bobiné en spires jointives sur un tore circulaire à section carrée de côté $a$ et de rayon moyen $R$. On désigne par $n$ le nombre total de spires et par $I$ le courant qui les parcourt. On note $(O z)$ l'axe de symétrie du tore. On s'intéresse au champ magnétique à l'intérieur du tore et on repère un point $M(r, z)$ en coordonnées cylindriques.

#question[
  Faire un schéma du système.
][
  #figure(canvas({
    import cetz.draw: *
    // vue en coupe dans un plan méridien
    rect((1.4, -0.6), (2.6, 0.6))
    rect((-2.6, -0.6), (-1.4, 0.6))
    line((0, -1.4), (0, 1.4), stroke: (dash: "dashed"))
    content((0, 1.4), anchor: "south", padding: 0.2em, $z$)
    line((0, 0), (2, 0), stroke: (paint: gray))
    content((1, 0), anchor: "north", padding: 0.2em, text(fill: gray)[$R$])
    content((2.6, 0.6), anchor: "south-west", padding: 0.15em, text(fill: gray)[$a$])
    // spires schématisées
    for x in (1.5, 1.7, 1.9, 2.1, 2.3, 2.5) {
      line((x, -0.75), (x, 0.75), stroke: 0.5pt + olive)
    }
    content((2, 1.0), anchor: "south", text(fill: olive)[$I$])
    // contour d'Ampère
    circle((0, 0), radius: 1.0, stroke: (paint: blue, dash: "dashed"))
    content((0.75, 0.75), text(fill: blue)[$cal(C)$])
  }))
]

#question(coups-de-pouce: (
  "Effectuer les quatre étapes : invariances, symétries, choix du contour d'Ampère, théorème d'Ampère.",
))[
  Montrer que le champ magnétique en un point $M(r, z)$ à l'intérieur du tore se met sous la forme $B = (mu_0 n I)/(2 pi r)$.
][
  #strong[Invariances.] La distribution de courant est (quasi) invariante par rotation d'angle $theta$ ($n gt.double 1$) : $va(B)$ ne dépend que de $r$ et $z$.

  #strong[Symétries.] Pour un point $M$, le plan $(M, va(e_r), va(e_z))$ est plan de symétrie de la distribution de courant : $va(B)(M)$ lui est orthogonal, donc $va(B) = B(r, z) va(e_theta)$.

  #strong[Contour d'Ampère.] On choisit le cercle $cal(C)$ d'axe $(O z)$, de rayon $r$, passant par $M$ et orienté selon $va(e_theta)$.

  #strong[Théorème d'Ampère.]
  $ integral.cont_(cal(C)) va(B) dot va(dif l) = 2 pi r B(r, z) = mu_0 I_"enlacé" $
  Le contour enlace les $n$ spires, chacune parcourue par $I$ : $I_"enlacé" = n I$ à l'intérieur du tore (et $0$ à l'extérieur). Donc $B$ ne dépend pas de $z$ et
  $ va(B) = (mu_0 n I)/(2 pi r) va(e_theta) $
]

#question(coups-de-pouce: (
  "Sur quelles variables intégrer, et entre quelles bornes ?",
  "Un élément de surface orienté selon $va(e_theta)$ s'écrit $dif r dif z$.",
))[
  Déterminer le flux $Phi$ du champ magnétique à travers la surface d'#emph[une] spire, dont la normale est orientée dans le sens du champ.
][
  Une spire est un carré de côté $a$ situé dans un plan méridien, entre $r = R - a/2$ et $r = R + a/2$ et entre deux cotes distantes de $a$. Sa normale est $va(e_theta)$, donc $va(dif S) = dif r dif z va(e_theta)$ :
  $
    Phi = integral.double va(B) dot va(dif S)
    = integral_0^a dif z integral_(R - a/2)^(R + a/2) (mu_0 n I)/(2 pi r) dif r
    = (mu_0 n I a)/(2 pi) ln((R + a/2)/(R - a/2))
  $
]
