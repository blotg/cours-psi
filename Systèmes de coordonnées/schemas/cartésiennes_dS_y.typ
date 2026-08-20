#import "@preview/cetz:0.4.2": canvas, draw
#import "@local/prepa:0.1.0": *

#canvas({
  import draw: *
  
  // Coordonnées du point M
  let x = 0.8
  let y = 0.8
  let z = 0.8
  let dx = 0.3
  let dy = 0.3
  let dz = 0.3

  let scale = 4
  set-transform(((-scale*calc.sqrt(1/8),scale,0,0),(scale*calc.sqrt(1/8),0,-scale,0),(0,0,0,0),(0,0,0,0)))

  // Axes de coordonnées
  line((0, 0, 0), (1, 0, 0), mark: (fill: black, end: ">>"))
  line((0, 0, 0), (0, 1, 0), mark: (fill: black, end: ">>"))
  line((0, 0, 0), (0, 0, 1), mark: (fill: black, end: ">>"))
  
  line((x, y, z), (x+dx, y, z), (x+dx, y, z+dz), (x, y, z+dz), close: true)
  content((x+dx,y,z+dz/2), anchor: "east", padding: 0.1, $dd(z)$)
  content((x+dx/2,y,z), anchor: "north-west", padding: 0.1, $dd(x)$)

  line( (x+dx/2,y,z+dz/2), (rel: (0,0.3,0)), mark: (fill: black, end: ">>"))
  content((), anchor: "south", padding: 0.1, $va(dd(S))$)
})
