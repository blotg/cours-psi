#import "exercice.typ":*

#exercice(
  titre: "Bobine torique",
  difficulté:0,
  numérique: false
)[
Une bobine est constituée par un fil conducteur bobiné en spires jointives sur un tore circulaire à section carrée de côté $a$, de rayon moyen $R$. On désigne par $n$ le nombre total de spires et par $I$ le courant qui les parcourt. On note $(O_z)$ son axe de symétrie.

On s'intéresse au champ magnétique à l'intérieur du tore.

#question[
  Faire un schéma du système.
][
  #canvas({
    import draw: *
    line( (-1,0.5), (-1,1), (-2,1), (-2,0), (-1,0), (-1,0.6), mark:(end:"straight"))
    content( () , anchor: "west", padding:.2em, text($I$) )
    content( (-2, 0.5), anchor: "east", padding:.2em, text($a$) )
    content( (-1.5, 0), anchor: "north", padding:.2em, text($a$) )
    line( (1,0.5), (1,1), (2,1), (2,0), (1,0), (1,0.6), mark:(end:"straight"))
    content( () , anchor: "east", padding:.2em, text($I$) )
    line( (0,-1), (0,2) , stroke: (dash: "dashed"))
    line( (0,1.5), (1.5,1.5), mark: (end: "stealth") )
    content( (0.75, 1.5), anchor: "south", padding:.2em, text($R$) )
  })
  #canvas({
    import draw: *
    ortho(x:25deg, y:0deg, z:0deg, {
      on-xz(y: 0, {
        arc( (2,0), start: 0deg, delta: 180deg,radius:2 )
        arc( (2,0), start: 0deg, delta: -180deg,radius:2, stroke: (dash: "dashed") )
        circle( (0,0), radius:1, stroke: (dash: "dashed"))
      })
      on-xz(y: 1, {
        circle( (0,0), radius:1 )
        circle( (0,0), radius:2 )
      })
      line( (1,1,0), (2,1,0), (2,0,0))
      line( (1,1,0), (1,0,0), (2,0,0), stroke: (dash: "dashed"))
      line( (-1,1,0), (-2,1,0), (-2,0,0))
      line( (-1,1,0), (-1,0,0), (-2,0,0), stroke: (dash: "dashed"))
    })
  })
]

#question[
  Montrer que le champ magnétique qui règne en un point $M(r,z)$ quelconque à l'intérieur du tore peut s'exprimer sous la forme  $B=(mu_0 n I)/(2 pi r)$.
][
  La distribution de courant est invariante par rotation selon $theta$ donc, d'après le principe de Curie, il en va de même pour $arrow(B)$ : $arrow(B)(r,z)$

  Soit $M$ un point de l'espace. $(M,arrow(e)_r, arrow(e)_z)$ est un plan de symétrie de la distribution de courant donc $arrow(B)$ lui est orthogonal. Donc $arrow(B)=B arrow(e)_theta$.

  On choisit comme contour d'Ampère un cercle de rayon $r$ centré sur l'axe $O z$ orienté selon $arrow(e)_theta$.
  #canvas({
    import draw: *
    line( (-1,0.5), (-1,1), (-2,1), (-2,0), (-1,0), (-1,0.6), mark:(end:"straight"))
    line( (1,0.5), (1,1), (2,1), (2,0), (1,0), (1,0.6), mark:(end:"straight"))
    content( () , anchor: "east", padding:.2em, text($I$) )
    line( (0,-1), (0,2) , stroke: (dash: "dashed"))
    ortho(x:25deg, y:0deg, z:0deg, {
      on-xz(y: 0.5, {
        circle( (0,0), radius:1.5 )
        arc( (110deg,1.5), radius:1.5, start:110deg, delta:90deg, mark:(start: "stealth"))
      })
    })
  })
  Le théorème d'Ampère donne $B=(mu_0 I_"enlacé")/(2 pi r)$ avec $I_"enlacé" = cases( n I "à l'intérieur du tore", 0 "à l'extérieur")$

  D'où à l'intérieur du tore : $ arrow(B) = (mu_0 n I)/(2 pi r) arrow(e)_theta $
]

#question[
  Déterminer le flux $Phi$ du champ magnétique à travers la surface d'*une* spire dont la normale est orientée dans le sens du champ.
][
  $Phi_(1 "spire") = integral_0^a dif z integral_(R-a/2)^(R+a/2) dif r B(r) = (a mu_0 n I)/(2 pi) ln (R+a/2)/(R-a/2)$
]

]