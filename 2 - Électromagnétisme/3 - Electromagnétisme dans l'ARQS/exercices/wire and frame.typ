#import "@local/prepa:0.1.0": *

#exercice(
  titre: "Mutual inductance between a wire and a frame",
)[

#figure[
  #canvas({
    import draw: *
    set-style(stroke: (thickness: 0.5pt))
    set-style(content: (padding: .1))
    line( (-2,-0.5), (4,-0.5) )
    rect( (0,0.5), (2,2) )
    line( (-0.2,0.5), (-0.2,2), name:"a", mark: (symbol: ">>", fill: black) )
    content( "a", $a$, anchor: "east" )
    line( (0,2.2), (2,2.2), name:"b", mark: (symbol:">>", fill:black))
    content( "b", $b$, anchor: "south" )
    line( (1,-0.5), (1,0.5), name:"d", mark: (symbol:">>", fill:black))
    content( "d", $d$, anchor: "west" )
  })
]

We study an infinite electric wire and a conductive frame. The two objects are coplanar. The bottom of the frame is at a distance $d$ of the wire.

#question(coups-de-pouce: (
  "Bien que l'inductance mutuelle soit une propriété \"géométrique\", il peut être utile d'introduire le courant passant dans un des conducteurs.",
  "Les deux possibilités sont de déterminer le champ magnétique créé par le cadre puis son flux sur le fil ou de déterminer le champ magnétique créé par le fil puis son flux sur le cadre. Une de ces deux options est plus facile.",
  "Déterminer le champ magnétique créé par le fil dans tout l'espace. Quel est son flux sur le cadre ?",
  "Quelle relation relie le flux mutuel et l'inductance mutuelle ?"
))[
  Ascertain the mutual inductance between the two circuits.
][
  *Magnetic field created by the wire*

  The curent distribution is invariant by translation along the wire axis and by rotation around this axis. According to Curie's principle, the same applies to the magnetostatic field $va(B)$. Consequently, $va(B)=va(B)(r)$.

  By symmetry, the wire is symmetric with respect to the plane passing through point $M$ and perpendicular to $va(e_theta)$ (the plane $(M,va(e_r), va(e_z))$). Consequently, $va(B)(M)$ is directed along $va(e_theta)$.

  The chosen Ampère's loop is a circle of radius $r$ centered on the wire axis and oriented along $+va(e_theta)$.

  Ampère's theorem writes :
  $ integral.cont va(B)(M).va(dif l) = 2 pi r B(r) = mu_0 I_"wire" $

  The magnetic field created by the wire at a distance $r$ of its axis is given by :
  $ va(B)(r) = (mu_0 I)/(2 pi r)va(e_theta) $
  
  *Flux of the magnetic field through the frame*
  
  The magnetic flux of the magnetic field created by the wire through the frame is given by :
  $ Phi_("wire" arrow "frame") = integral.double_S va(B).va(dif S) = integral_(d)^(d+a) B(r) dif r integral_0^b dif z = (mu_0 I b)/(2 pi) ln((d+a)/d) $
  
  *Mutual inductance*
  
  The mutual inductance between the wire and the frame is given by :
  $ M = Phi_("wire" arrow "frame")/I = (mu_0 L)/(2 pi) ln((d+a)/d) $
]

]
