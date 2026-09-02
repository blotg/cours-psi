#import "@local/prepa:0.1.1": *

#show: exercice.with(titre: "Câble coaxial", difficulté: 2, numérique: true)

On considère un câble coaxial cylindrique de longueur supposée infinie, constitué d'un conducteur central plein de rayon $R_1$ parcouru par un courant uniforme d'intensité $I$, et d'un conducteur périphérique évidé, de rayon intérieur $R_2$ et de rayon extérieur $R_3$ (avec $R_1 < R_2 < R_3$), parcouru par un courant uniforme d'intensité $I$ circulant en sens inverse. On note $va(e_z)$ le vecteur unitaire de l'axe commun et $M$ un point à la distance $r$ de l'axe.

#question[
  Montrer que le champ magnétique $va(B)$ créé au point $M$ est orthoradial.
][
  Pour un point $M$, le plan $(M, va(e_r), va(e_z))$ contient les courants et est plan de symétrie de la distribution : $va(B)(M)$ lui est orthogonal, donc $va(B) = B va(e_theta)$.
]

#question[
  Montrer qu'il se met sous la forme $va(B) = B(r) va(e_theta)$.
][
  La distribution de courant est invariante par rotation d'angle $theta$ et par translation selon $z$ : d'après le principe de Curie, $va(B)$ possède les mêmes invariances et ne dépend donc que de $r$. Avec la question précédente, $va(B) = B(r) va(e_theta)$.
]

#question(coups-de-pouce: (
  "Les lignes de champ sont en tout point colinéaires à $va(B)$.",
))[
  Préciser la forme des lignes de champ.
][
  $va(B)$ est orthoradial et ne dépend que de $r$ : les lignes de champ sont des cercles centrés sur l'axe $(O z)$ et situés dans des plans orthogonaux à l'axe.
]

#question(coups-de-pouce: (
  "Quel est le courant enlacé par un cercle de rayon $r > R_3$ ?",
))[
  Montrer que le champ magnétique créé au point $M$ est nul si $r > R_3$.
][
  On applique le théorème d'Ampère au cercle $cal(C)$ d'axe $(O z)$, de rayon $r$, orienté selon $va(e_theta)$ :
  $ 2 pi r B(r) = mu_0 I_"enlacé" $
  Pour $r > R_3$, le contour enlace les deux conducteurs : $I_"enlacé" = I + (-I) = 0$, donc $va(B) = va(0)$. À l'extérieur, le câble coaxial ne rayonne pas de champ magnétique.
]

#question(coups-de-pouce: (
  "Aire du disque de rayon $R_1$ ; aire de la couronne entre $R_2$ et $R_3$.",
))[
  Calculer les densités volumiques de courant $va(j)_1$ et $va(j)_2$ dans le conducteur central et dans le conducteur périphérique, en fonction de $I$, $R_1$, $R_2$ et $R_3$.
][
  Les densités sont uniformes et dirigées selon $va(e_z)$.

  Conducteur central : $I = j_1 pi R_1^2$, donc $ va(j)_1 = I/(pi R_1^2) va(e_z) $
  Conducteur périphérique : $-I = j_2 (pi R_3^2 - pi R_2^2)$, donc $ va(j)_2 = - I/(pi (R_3^2 - R_2^2)) va(e_z) $
]

#question(coups-de-pouce: (
  "Choisir le contour de sorte que $va(dif l)$ soit colinéaire à $va(B)$.",
))[
  En appliquant le théorème d'Ampère à un contour $cal(C)$ que l'on précisera, donner $B(r)$ pour $r < R_1$, pour $R_1 < r < R_2$ et pour $R_2 < r < R_3$.
][
  On garde le cercle $cal(C)$ de rayon $r$ orienté selon $va(e_theta)$ : $2 pi r B(r) = mu_0 I_"enlacé"$.

  #strong[$r < R_1$ :] $I_"enlacé" = j_1 pi r^2 = I r^2/R_1^2$, d'où
  $ va(B) = (mu_0 I r)/(2 pi R_1^2) va(e_theta) $

  #strong[$R_1 < r < R_2$ :] $I_"enlacé" = I$, d'où
  $ va(B) = (mu_0 I)/(2 pi r) va(e_theta) $

  #strong[$R_2 < r < R_3$ :] le contour enlace tout le courant central et une fraction du courant retour :
  $ I_"enlacé" = I - I/(pi (R_3^2 - R_2^2)) pi (r^2 - R_2^2) = I (R_3^2 - r^2)/(R_3^2 - R_2^2) $
  d'où
  $ va(B) = (mu_0 I (R_3^2 - r^2))/(2 pi r (R_3^2 - R_2^2)) va(e_theta) $
]

#question[
  Tracer l'allure du graphe de $B(r)$.
][
  $B$ croît linéairement de $0$ à $(mu_0 I)/(2 pi R_1)$ dans le conducteur central, décroît en $1/r$ entre $R_1$ et $R_2$, puis décroît jusqu'à $0$ en $r = R_3$ ; il est nul au-delà.

  #figure(canvas({
    import draw: *
    let R1 = 1.0
    let R2 = 2.6
    let R3 = 4.2
    let k = 1.0
    let B(r) = {
      if r < R1 { k * r / calc.pow(R1, 2) } else if r < R2 { k / r } else if r < R3 {
        k * (calc.pow(R3, 2) - calc.pow(r, 2)) / (r * (calc.pow(R3, 2) - calc.pow(R2, 2)))
      } else { 0 }
    }
    plot.plot(
      size: (8, 4),
      x-label: $r$,
      y-label: $B(r)$,
      x-tick-step: none,
      y-tick-step: none,
      x-ticks: ((R1, $R_1$), (R2, $R_2$), (R3, $R_3$)),
      axis-style: "left",
      {
        plot.add(domain: (0, 5.2), samples: 200, r => B(r), style: (stroke: blue + 1.5pt))
      },
    )
  }))
]
