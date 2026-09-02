#import "@local/prepa:0.1.1": *

#canvas({
  let block-circle = circle
  import cetz.draw: *
  
  // Coordonnées du point M
  let r = 0.8
  let t = 30deg
  let ph = 50deg
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
  content((x,y,z), anchor: "north-east", padding: 0.1, [$M$])

  line(M, (0, 0, 0), stroke: (dash: "dotted"))

  line(M, (rel: (0.5*x/r, 0.5*y/r, 0.5*z/r)), mark:(fill: black, end: ">>"))
  content((), anchor: "south-west", padding: 0.1, $va(e_r)$)

  group({
    rotate(z: ph)
    on-xy(z:z, {
      let rp = r*calc.sin(t)
      arc((rp,0), radius: rp, start:0deg, stop: 90deg - ph, stroke: (dash: "dotted"))
      arc((rp,0), radius: rp, start:0deg, stop: -ph, stroke: (dash: "dotted"))
      line((rp,0), (rel: (0,0.5)), mark:(fill: black, end: ">>"))
      content((), anchor: "west", padding: 0.1, $va(e_phi)$)
    })
    on-xz(y:0, {
      arc((90deg-t,r), radius:r, start:90deg-t, stop: 0deg, stroke: (dash: "dotted"))
      arc((90deg-t,r), radius:r, start:90deg-t, stop: 90deg, stroke: (dash: "dotted"))
      line((90deg-t,r), (rel: (-t,0.5)), mark:(fill: black, end: ">>"))
      content((), anchor: "north-west", padding: 0.1, $va(e_theta)$)
    })
  })

  // line(M, (rel: ()), mark:(fill: black, end: ">>"))
  // content((), anchor: "south-west", padding: 0.1, $va(e_theta)$)

  // line(M, (rel: (-0.5*y/r, 0.5*x/r, 0)), mark:(fill: black, end: ">>"))
  // content((), anchor: "west", padding: 0.1, $va(e_phi)$)
})