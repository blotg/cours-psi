#import "@local/prepa:0.1.1": *

#canvas({
  let block-circle = circle
  import cetz.draw: *
  
  // Coordonnées du point M
  let r = 1
  let t = 50deg
  let ph = 45deg
  let z = r * calc.cos(t)
  let x = r * calc.sin(t) * calc.cos(ph)
  let y = r * calc.sin(t) * calc.sin(ph)

  projection-cabinet()
  scale(4)

  // Axes de coordonnées
  line((0, 0, 0), (1, 0, 0), mark: (fill: black, end: ">>"))
  line((0, 0, 0), (0, 1, 0), mark: (fill: black, end: ">>"))
  line((0, 0, 0), (0, 0, 1), mark: (fill: black, end: ">>"))
  
  // Point M
  let M = (x, y, z)
  content((x,y,z), [#block-circle(radius: 2pt, fill: black)])
  content((x,y,z), anchor: "south-west", padding: 0.1, [$M$])

  line(M, (0, 0, 0), stroke: (dash: "dashed"), name:"r")
  content("r.mid", anchor: "north-west", padding: 0.1, [$r$])

  line(M, (x, y, 0), stroke: (dash: "dashed"))
  line((), (0,0,0), stroke: (dash: "dashed"))

  on-xy(z: 0, {
    arc((0.4,0), radius: 0.4, start: 0deg, stop: ph, mark: (fill: black, end: ">>"), name: "phi")
    content("phi.mid", $phi$, anchor: "north-east", padding: 0.1)
  })

  rotate(z:ph)
  on-xz(y: 0, {
    arc((0,0.4), radius: 0.4, start: 90deg, delta: -t, mark: (fill: black, end: ">>"), name: "theta")
    content("theta.mid", $theta$, anchor: "south-west", padding: 0.1)
  })
})