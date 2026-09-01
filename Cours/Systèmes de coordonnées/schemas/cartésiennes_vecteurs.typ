#import "@preview/cetz:0.4.2": canvas, draw
#import "@local/prepa:0.1.1": *

#canvas({
  import draw: *
  
  // Coordonnées du point M
  let x = 0.8
  let y = 0.8
  let z = 0.8

  let scale = 4
  set-transform(((-scale*calc.sqrt(1/8),scale,0,0),(scale*calc.sqrt(1/8),0,-scale,0),(0,0,0,0),(0,0,0,0)))

  // Axes de coordonnées
  line((0, 0, 0), (1, 0, 0), mark: (fill: black, end: ">>"))

  line((0, 0, 0), (0, 1, 0), mark: (fill: black, end: ">>"))

  line((0, 0, 0), (0, 0, 1), mark: (fill: black, end: ">>"))
  
  // Point M
  let M = (x, y, z)
  on-yz(x:x,{
    circle((y,z), radius: 0.02, fill: black)
    content((y,z), anchor: "south-west", padding: 0.1, [$M$])}
  )
  line(M, (x+0.4, y, z), mark: (fill: black, end: ">>"))
  content((), anchor: "north-east", padding: 0.1, [$va(e_x)$])

  line(M, (x, y+0.4, z), mark: (fill: black, end: ">>"))
  content((), anchor: "north-east", padding: 0.1, [$va(e_y)$])

  line(M, (x, y, z+0.4), mark: (fill: black, end: ">>"))
  content((), anchor: "north-east", padding: 0.1, [$va(e_z)$])
})