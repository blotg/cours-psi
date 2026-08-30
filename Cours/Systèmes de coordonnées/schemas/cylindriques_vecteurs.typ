#import "@preview/cetz:0.4.2": canvas, draw
#import "@local/prepa:0.1.0": *

#canvas({
  let block-circle = circle
  import draw: *
  
  // Coordonnées du point M
  let r = 1
  let thet = 55deg
  let z = 0.8
  let x = r * calc.cos(thet)
  let y = r * calc.sin(thet)

  let scale = 4
  set-transform(((-scale*calc.sqrt(1/8),scale,0,0),(scale*calc.sqrt(1/8),0,-scale,0),(0,0,0,0),(0,0,0,0)))

  // Axes de coordonnées
  line((0, 0, 0), (1, 0, 0), mark: (fill: black, end: ">>"))
  line((0, 0, 0), (0, 1, 0), mark: (fill: black, end: ">>"))
  line((0, 0, 0), (0, 0, 1), mark: (fill: black, end: ">>"))
  
  // Point M
  let M = (x, y, z)
  content(M, [#block-circle(radius: 2pt, fill: black)])
  content(M, anchor: "north-east", padding: 0.1, [$M$])

  line(M, (rel: (0, 0, 0.4)), mark: (fill: black, end: ">>"))
  content((), anchor: "east", padding: 0.1, [$va(e_z)$])

  line(M, (rel: (0.4*calc.cos(thet), 0.4*calc.sin(thet), 0)), mark: (fill: black, end: ">>"))
  content((), anchor: "north", padding: 0.1, [$va(e_r)$])

  line(M, (rel: (-0.4*calc.sin(thet), 0.4*calc.cos(thet), 0)), mark: (fill: black, end: ">>"))
  content((), anchor: "north-west", padding: 0.1, [$va(e_theta)$])

  line(M, (0, 0, z), stroke: (dash: "dashed"))
  content((), anchor: "east", padding: 0.1, [$z$])

  line(M, (x, y, 0), stroke: (dash: "dashed"))
  line((), (0,0,0), stroke: (dash: "dashed"), name:"r")
  content("r.mid", $r$, anchor: "south-west", padding: 0.1)

  on-xy(z: 0, {
    arc((0.4,0), radius: 0.4, start: 0deg, stop: thet, mark: (fill: black, end: ">>"), name: "theta")
    content("theta.mid", $theta$, anchor: "north-east", padding: 0.1)
  })
})