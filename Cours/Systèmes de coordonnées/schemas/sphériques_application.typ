#import "@preview/cetz:0.4.2": canvas, draw
#import "@local/prepa:0.1.1": *

#canvas({
  let block-circle = circle
  import cetz.draw: *
  
  // Coordonnées du point M
  let points = (
    (1, 60deg,60deg),
    (1, 60deg, -40deg),
    (1, 100deg, 60deg)
  )

  let scale = 4
  set-transform(((-scale*calc.sqrt(1/8),scale,0,0),(scale*calc.sqrt(1/8),0,-scale,0),(0,0,0,0),(0,0,0,0)))

  // Axes de coordonnées
  line((0, 0, 0), (1, 0, 0), mark: (fill: black, end: ">>"))

  line((0, 0, 0), (0, 1, 0), mark: (fill: black, end: ">>"))

  line((0, 0, 0), (0, 0, 1), mark: (fill: black, end: ">>"))
  
  // Point M
  for (i, (r,thet,ph)) in points.enumerate() {
    let x = r * calc.cos(ph) * calc.sin(thet)
    let z = r * calc.cos(thet)
    let y = r * calc.sin(thet) * calc.sin(ph)
    content((x,y,z), [#block-circle(radius: 2pt, fill: black)])
    content((x,y,z), anchor: "west", padding: 0.1, [$M_#(i+1)$])
    line((x, y, z), (0, 0, 0), stroke: (dash: "dotted"))
    line((x, y, z), (x, y, 0), (0,0,0), stroke: (dash: "dotted"))
  }
})