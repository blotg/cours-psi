#import "@local/prepa:0.1.0": *

#exercice(
  titre: "Inductance d'un câble coaxial",
)[

#figure[
  #canvas({
    import draw: *
    set-style(stroke: (thickness: 0.5pt))
    set-style(content: (padding: .1))
    line( (0,1), (8,1) )
    line( (0,2), (8,2) )
    line( (0,-1), (8,-1) )
    line( (0,-2), (8,-2) )
    line( (-1,0), (10,0), mark: (end: ">>", stroke: (dash: none), fill: black), stroke: (dash: "dashed"))
    content( (), $z$, anchor: "south")
    line( (2,1.2), (3,0), (2,-1.2), name:"I", stroke: (thickness: 1pt))
    content( "I.mid", $I$, anchor: "south-west")
    line( (2,2.4), (0,0), (2,-2.4), name: "-I", stroke: (thickness: 1pt))
    content( "-I.mid", $I$, anchor: "south-east")
    line( (-0.5,0), (-0.5,1), name:"a", mark: (symbol: ">>", fill: black))
    content( "a", $a$, anchor:"east")
    line( (-0.5,0), (-0.5,-2), name: "b", mark: (symbol: ">>", fill: black))
    content( "b", $b$, anchor:"east")
    content( (3,-1), $S$, anchor: "south" )
    content( (6,-1), $P$, anchor: "south" )
    content( (6,-2), $Q$, anchor: "north" )
    content( (3,-2), $R$, anchor: "north" )
    rect( (3,-1), (6,-2), stroke:(thickness: 2pt))
    scale(x: 50%)
      circle((16,0), radius: 1)
      circle((16,0), radius: 2)
  })
]

Un câble coaxial, considéré comme infiniment long et placé dans un milieu de perméabilité magnétique $mu_0$, est formé de deux armatures cylindriques de même axe $(O,z)$. L'armature intérieure (l'âme) est un cylindre *creux* de rayon $a$. L'armature extérieure (la gaine) est un cylindre *creux* de rayon $b$. Le courant continu d'intensité $I$ qui circule dans l'âme, dans le sens de $+va(e_z)$, revient avec la même intensité dans la gaine selon $-va(e_z)$. Ce câble constitue un circuit fermé.

À un point $M$ de l'espace, on associera les coordonnées cylindriques $(r, theta, z)$ et la base cylindrique directe $(va(e_r), va(e_theta), va(e_z))$.

#question(coups-de-pouce: (
  "Procéder par analyse des symétries et des invariances.",
))[
  Déterminer l'orientation du champ magnétique $va(B)(M)$ créé par ce câble ainsi que les variables dont il peut dépendre en un point $M$ quelconque de l'espace.
][
  *Analyse des invariances* La distribution des courants est invariante par translation selon l'axe $z$ du câble et par rotation autour de cet axe ($theta$). D'après le principe de Curie, il en va de même pour le champ magnétostatique $va(B)$. Par conséquent, $va(B)=va(B)(r)$.
  *Analyse des symétries* Le câble est symétrique par rapport au plan passant par $M$ et perpendiculaire à $va(e_theta)$ (le plan $(M,va(e_r), va(e_z))$). Par conséquent, $va(B)(M)$ est dirigé selon $va(e_theta)$.
]

#question(coups-de-pouce: (
  "Quel est le courant entouré par la courbe d'Ampère dans les deux cas ?",
))[
  Déterminer $va(B)(M)$ pour un point intérieur à l'âme ($r < a$), ou extérieur à la gaine ($b < r$).
][
  On choisit comme courbe d'Ampère un cercle de rayon $r$ centré sur l'axe du câble et orienté selon $+va(e_theta)$.
  
  Le théorème d'Ampère s'écrit :
  $ integral.cont va(B)(M).va(dd(l)) = 2 pi r B(r) = mu_0 I_"enlacé" $

  Pour $r < a$, le courant entouré est nul ($I_"enlacé"=0$) donc $B(r)=0$.

  Pour $b < r$, le courant entouré est nul également ($I_"enlacé"=I-I=0$) donc $B(r)=0$.
]

#question(coups-de-pouce: (
  "Appliquer le théorème d'Ampère.",
))[
  Exprimer le champ magnétostatique $va(B)(M)$ créé par ce câble en tout point $M$ situé à la distance $r$ de son axe, $a < r < b$.
][
  Dans ce cas, le courant entouré par la courbe d'Ampère est $I_"enlacé"=I$. On a donc $ va(B)=(mu_0 I)/(2 pi r) va(e_theta) $
]

#question(coups-de-pouce: (
  "Quelle est l'expression du $va(d S)$ correspondant en coordonnées cylindriques ?",
))[
  Déterminer le flux de $va(B)(M)$ à travers une surface rectangulaire $P Q R S$ correspondant à une longueur $l$ du câble, orientée dans le sens de $+va(e_theta)$.
][
  On choisit comme surface élémentaire $dif S = dif r dif z va(e_theta)$. Le flux s'écrit donc :
  $ Phi = integral.double_S va(B).va(dif S) = integral_(z=0)^(l) integral_(r=a)^(b) (mu_0 I)/(2 pi r) dif r dif z = (mu_0 I l)/(2 pi) ln(b/a) $
])

#question(coups-de-pouce: (
  "Rappeler la définition de l'inductance propre.",
))[
  Rappeler l'expression générale qui lie le flux de $va(B)(M)$ à l'inductance propre (ou coefficient d'auto-inductance) et en déduire l'inductance $L$ d'une longueur $l$ du câble en fonction de $mu_0$, $l$, $a$ et $b$.
][
  Le flux s'écrit $Phi = L I$. On en déduit donc :
  $ L = (mu_0 l)/(2 pi) ln(b/a) $
]

#let mu0 = 4 * calc.pi * 1e-7 // H/m
#let l = 1 // m
#let a = 1e-3 // m
#let b = 3e-3 // m

#question()[
  Effectuer l'application numérique pour un câble standard, où $l=qty(#scientifique(l,1),"m")$, $a=qty(#scientifique(a,1),"m")$ et $b=qty(#scientifique(b,1),"m")$.
][
  #let L = (mu0 * l) / (2 * calc.pi) * calc.log(b / a)
  On trouve $ L approx qty(#scientifique(L,1),"H/m") $
]

]
