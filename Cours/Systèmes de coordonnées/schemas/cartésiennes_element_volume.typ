#import "@preview/cetz:0.4.2": canvas, draw
#import "@local/prepa:0.1.1": *

#canvas({
  import cetz.draw: *
  
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
  
  // Point M
  on-yz(x:x,{
    line((y, z+dz), (y,z), (y+dy,z), stroke: (dash: "dashed"))
    line((y, z+dz), (y+dy,z+dz), (y+dy,z))
    content((y+dy,z+dz), anchor: "south-west", padding: 0.1, $dd(V)$)
  })
  on-yz(x:x+dx,{
    rect((y,z), (y+dy,z+dz))
    content((y,z+dz/2), anchor: "north", padding: 0.1, [$dd(y)$])
    content((y+dy/2,z), anchor: "east", padding: 0.1, [$dd(z)$])
  })
  line((x, y, z), (x+dx, y, z), stroke: (dash: "dashed"))
  line((x, y+dy, z), (x+dx, y+dy, z), name:"dx")
  content("dx.mid", anchor: "west", padding: 0.1, [$dd(x)$])
  line((x, y, z+dz), (x+dx, y, z+dz))
  line((x, y+dy, z+dz), (x+dx, y+dy, z+dz))
})
