#import "exercice.typ":*
#import "@preview/lilaq:0.5.0" as lq
#import "@preview/tiptoe:0.3.1"

#exercice(
  titre: "Câble coaxial",
  difficulté: 1,
  numérique: true
)[
On considère un câble coaxial cylindrique de longueur supposée infinie, constitué d'un conducteur central plein de rayon $R_1$, parcouru par un courant uniforme d'intensité $I$ et d'un conducteur périphérique évidé, de rayon intérieur $R_2$, de rayon extérieur $R_3$ avec $R_1<R_2<R_3$ et parcouru par un courant uniforme également d'intensité $I$ mais circulant en sens inverse par rapport au courant du conducteur central.

On notera $arrow(e)_z$ le vecteur unitaire de l'axe commun des deux conducteurs. Soit un point $M$ à une distance $r$ de l'axe du câble.

#question[
  Montrer que le champ magnétique $arrow(B)$ créé au point $M$ est orienté selon $arrow(e)theta$.
][
  Soit $M$ un point de l'espace. $(M,arrow(e)_r, arrow(e)_z)$ est un plan de symétrie de la distribution de courant donc $arrow(B)$ lui est orthogonal. Donc $arrow(B)=B arrow(e)_theta$.
]

#question[
  Montrer qu'il peut se mettre sous la forme $arrow(B)=B(r)arrow(e)_theta$.
][
  La distribution de courant est invariante par rotation selon $theta$ et par translation selon $z$ donc, d'après le principe de Curie, il en va de même pour $arrow(B)$ : $arrow(B)(r)$.
]

#question[
  Préciser alors la forme des lignes de champ.
][
  Les lignes de champ sont des cercles centrés sur l'axe $O z$.
]

#question[
  Exprimer les densités de courant $arrow(j)_1$ et $arrow(j)_2$, respectivement dans le conducteur central et du conducteur périphérique en fonction des courants $I$ et $-I$ et des rayons $R_1$, $R_2$ et $R_3$.
][
  On choisit comme contour d'Ampère un cercle de rayon $r$ centré sur l'axe $O z$ orienté selon $arrow(e)_theta$.

  Le théorème d'Ampère donne $2 pi r B = mu_0 I_"enlacé"$ avec, pour $r>R_3$ $I_"enlacé"=I-I=0$, donc $arrow(B)=arrow(0)$.
]

#question[
  En appliquant le théorème d'Ampère à un contour $cal(C)$ que l'on précisera, donner l'expression de la composante $B(r)$ du champ magnétique créé au point $M$ en fonction de $mu_0$, $I$, $r$, $R_1$, $R_2$, et $R_3$ dans chacun des cas suivants : $r<R_1$ ; $R_1<r<R_2$ et $R_2<r<R_3$.
][
  $I=pi R_1^2 j_1$ donc $ arrow(j)_1=I/(pi R_1^2) arrow(e)_z $
$-I=(pi R_3^2-pi R_2^2) j_2$ donc $ arrow(j)_2=-I/(pi R_3^2-pi R_2^2) arrow(e)_z $
]

#question[
  Tracer l'allure du graphe de $B(r)$.
][
  - Pour $r<R_1$ : $I_"enlacé"=pi r^2 j_1 = I r^2/R_1^2$ donc $arrow(B) = (mu_0 I r)/(2 pi R_1^2) arrow(e)_theta$
  - Pour $R_1<r<R_2$ : $I_"enlacé"=I$ donc $arrow(B) = (mu_0 I)/(2 pi r) arrow(e)_theta$
  - Pour $R_2<r<R_3$ : $I_"enlacé"=I-(pi r^2 - pi R_2^2) j_2 = I (R_3^2 - r^2)/(R_3^2 - R_2^2)$ donc $arrow(B) = (mu_0 I (R_3^2 - r^2))/(2 pi r (R_3^2 - R_2^2)) arrow(e)_theta$
  Finalement, $ arrow(B)=cases(
    (mu_0 I r)/(2 pi R_1^2) arrow(e)_theta "pour" r < R_1,
    (mu_0 I)/(2 pi r) arrow(e)_theta "pour" R_1 < r < R_2,
    (mu_0 I (R_3^2 - r^2))/(2 pi r (R_3^2 - R_2^2)) arrow(e)_theta "pour" R_2 < r < R_3,
    arrow(0) "pour" r > R_3
  ) $


  #let R1 = 1
  #let R2 = 3
  #let R3 = 6
  #let B(r) = {
    let mu_0 = 1
    let pi = 3.14159
    let I = 1
    if r < R1 {(mu_0 * I * r) / (2 * pi * calc.pow(R1,2))}
    else if r < R2 {(mu_0 * I) / (2 * pi * r)}
    else if r < R3 {(mu_0 * I * (calc.pow(R3,2) - calc.pow(r,2))) / (2 * pi * r * (calc.pow(R3,2) - calc.pow(R2,2)))}
    else {0}
  }
  #let r = lq.linspace(0, 8, num: 100)
  #lq.diagram(
    xaxis: (
      position: 0,
      tip: tiptoe.stealth,
      ticks: (R1,R2,R3).zip(([$R_1$], [$R_2$], [$R_3$])),
      subticks: none
    ),
    yaxis: (
      position: 0,
      tip: tiptoe.stealth,
      ticks: none,
      subticks: none
    ),
    xlabel: [$r$],
    ylabel: [$B(r)$],
    lq.plot(r, r.map(B), mark:none, stroke: (thickness:2pt, paint:blue)),
  )
]
]