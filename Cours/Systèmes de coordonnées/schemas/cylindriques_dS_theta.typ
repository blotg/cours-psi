#import "@preview/cetz:0.4.2": canvas, draw
#import "@local/prepa:0.1.1": *

#canvas({
  let block-circle = circle
  import cetz.draw: *
  
  // Coordonnées du point M
  let r = 0.8
  let thet = 35deg
  let z = 0.45
  let x = r * calc.cos(thet)
  let y = r * calc.sin(thet)
  let dr = 0.6
  let dthet = 40deg
  let dz = 0.4

  set-transform(((-calc.sqrt(1/8),1,0,0),(calc.sqrt(1/8),0,-1,0),(0,0,0,0),(0,0,0,1)))// projection Cabinet
  scale(4)

  // Axes de coordonnées
  line((0, 0, 0), (1, 0, 0), mark: (fill: black, end: ">>"))
  line((0, 0, 0), (0, 1, 0), mark: (fill: black, end: ">>"))
  line((0, 0, 0), (0, 0, 1), mark: (fill: black, end: ">>"))

  let A = (r*calc.cos(thet), r*calc.sin(thet), z)
  let B = ((r+dr)*calc.cos(thet), (r+dr)*calc.sin(thet), z)
  let C = ((r+dr)*calc.cos(thet), (r+dr)*calc.sin(thet), z+dz)
  let D = (r*calc.cos(thet), r*calc.sin(thet), z+dz)
  line(C,D, name:"dr")
  line(A,D, name:"dz")
  
  content("dr.mid", $dd(r)$, anchor:"south-west", padding: 0.1)
  content("dz.mid", $dd(z)$, anchor:"east", padding: 0.1)
  intersections("i", {
    line(A,B,C,D, close: true)
    line(((r+dr/2)*calc.cos(thet), (r+dr/2)*calc.sin(thet), (z+dz/2)), (rel: (-0.2*calc.sin(thet),0.2*calc.cos(thet),0)), stroke:(dash: "dashed"))
  })
  for-each-anchor("i", (name) => {
    line("i."+name, (rel: (-0.2*calc.sin(thet),0.2*calc.cos(thet),0)), mark: (fill: black, end: ">>"))
    content((), $va(dd(S))$, anchor:"west", padding: 0.1)
  })
})