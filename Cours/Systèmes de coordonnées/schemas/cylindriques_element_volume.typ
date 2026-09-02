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
  
  on-xy(z: z+dz, {
    arc((thet,r+dr), radius: r+dr, start: thet, delta: dthet)
    arc((thet,r), radius: r, start: thet, delta: dthet, name:"rdthet", stroke:red.darken(30%))
    content("rdthet.mid", text(red.darken(30%))[$r dd(theta)$], anchor:"north-west", padding: 0.1)
    line((thet,r), (thet, r+dr))
    line((thet+dthet,r), (thet+dthet, r+dr), name:"dr", stroke:blue)
    content("dr.mid", text(blue)[$dd(r)$], anchor:"south", padding: 0.1)
    line((thet,r), (thet,0), stroke: (dash: "dashed"), name:"r")
    line((thet,0), (thet+dthet, r), stroke: (dash: "dashed"))
    content("r.mid", $r$, anchor:"north-east", padding: 0.1)
    arc((thet,0.4), radius: 0.4, start: thet, delta: dthet, mark: (fill: black, end: ">>"), name:"dthet")
    content("dthet.mid", $dd(theta)$, anchor:"north-west", padding: 0.1)
  })
  on-xy(z: z, {
    arc((thet,r+dr), radius: r+dr, start: thet, delta: dthet)
    arc((thet,r), radius: r, start: thet, delta: dthet, stroke: (dash: "dashed"))
    line((thet,r), (thet, r+dr))
    line((thet+dthet,r), (thet+dthet, r+dr), stroke: (dash: "dashed"))
    // line((thet,r), (thet,0), stroke: (dash: "dashed"))
    // line((thet,0), (thet+dthet, r), stroke: (dash: "dashed"), name:"r")
    // content("r.mid", $r$, anchor:"south-west", padding: 0.1)
  })
  line((r*calc.cos(thet),r*calc.sin(thet),z), (r*calc.cos(thet),r*calc.sin(thet),z+dz))
  line(((r+dr)*calc.cos(thet),(r+dr)*calc.sin(thet),z), ((r+dr)*calc.cos(thet),(r+dr)*calc.sin(thet),z+dz))
  line((r*calc.cos(thet+dthet),r*calc.sin(thet+dthet),z), (r*calc.cos(thet+dthet),r*calc.sin(thet+dthet),z+dz), stroke: (dash: "dashed"))
  line(((r+dr)*calc.cos(thet+dthet),(r+dr)*calc.sin(thet+dthet),z), ((r+dr)*calc.cos(thet+dthet),(r+dr)*calc.sin(thet+dthet),z+dz), name:"dz", stroke:green.darken(30%))
  content("dz.mid", text(green.darken(30%))[$dd(z)$], anchor:"west", padding: 0.1)
})