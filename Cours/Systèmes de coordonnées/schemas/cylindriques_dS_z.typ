#import "@preview/cetz:0.4.2": canvas, draw
#import "@local/prepa:0.1.1": *

#canvas({
  let block-circle = circle
  import cetz.draw: *
  
  // Coordonnées du point M
  let r = 0.8
  let thet = 45deg
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
  
  on-xy(z: z, {
    arc((thet,r+dr), radius: r+dr, start: thet, delta: dthet)
    arc((thet,r), radius: r, start: thet, delta: dthet, name:"rdthet", )
    content("rdthet.mid", $r dd(theta)$, anchor:"north-west", padding: 0.1)
    line((thet,r), (thet, r+dr))
    line((thet+dthet,r), (thet+dthet, r+dr), name:"dr")
    content("dr.mid", $dd(r)$, anchor:"south", padding: 0.1)
    line((thet,r), (thet,0), stroke: (dash: "dashed"), name:"r")
    line((thet,0), (thet+dthet, r), stroke: (dash: "dashed"))
    content("r.mid", $r$, anchor:"north-east", padding: 0.1)
    arc((thet,0.4), radius: 0.4, start: thet, delta: dthet, mark: (fill: black, end: ">>"), name:"dthet")
    content("dthet.mid", $dd(theta)$, anchor:"north-west", padding: 0.1)
  })
  line(((r+dr/2)*calc.cos(thet+dthet/2), (r+dr/2)*calc.sin(thet+dthet/2), z), (rel: (0,0,0.5)), mark: (fill: black, end: ">>"), name:"dz")
  content((), $va(dd(S))$, anchor:"south", padding: 0.1)
})