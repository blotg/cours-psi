#import "@local/prepa:0.1.1": *

#exercice(
  titre: "Mutual inductance between a wire and a frame",
)[

#figure[
  #canvas({
    import cetz.draw: *
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

We study an infinite electric wire and a conductive frame. The two objects are coplanar. The bottom of the frame is at a distance $d$ from the wire.

#question(coups-de-pouce: (
  "Although the mutual inductance is a \"geometric\" property, it can be useful to introduce the current flowing in one of the conductors.",
  "You can either determine the magnetic field created by the frame and then its flux through the wire, or determine the magnetic field created by the wire and then its flux through the frame. One of these two options is easier.",
  "Determine the magnetic field created by the wire in all space. What is its flux through the frame?",
  "Which relation links the mutual flux and the mutual inductance?"
))[
  Determine the mutual inductance between the two circuits.
][
  *Magnetic field created by the wire*

  The current distribution is invariant under translation along the wire axis and under rotation around this axis. According to Curie's principle, the same applies to the magnetostatic field $va(B)$. Consequently, $va(B)=va(B)(r)$.

  The current distribution is symmetric with respect to the plane passing through point $M$ and perpendicular to $va(e_theta)$ (the plane $(M,va(e_r), va(e_z))$). Consequently, $va(B)(M)$ is directed along $va(e_theta)$.

  The chosen Amperian loop is a circle of radius $r$ centered on the wire axis and oriented along $+va(e_theta)$.

  Ampère's theorem reads:
  $ integral.cont va(B)(M).va(dd(l)) = 2 pi r B(r) = mu_0 I $

  The magnetic field created by the wire at a distance $r$ from its axis is given by:
  $ va(B)(r) = (mu_0 I)/(2 pi r)va(e_theta) $
  
  *Flux of the magnetic field through the frame*
  
  The magnetic flux of the magnetic field created by the wire through the frame is given by:
  $ Phi_("wire" arrow "frame") = integral.double_S va(B).va(dd(S)) = integral_(d)^(d+a) B(r) dd(r) integral_0^b dd(z) = (mu_0 I b)/(2 pi) ln((d+a)/d) $
  
  *Mutual inductance*
  
  The mutual inductance between the wire and the frame is given by:
  $ M = Phi_("wire" arrow "frame")/I = (mu_0 b)/(2 pi) ln((d+a)/d) $
]

]
