#import "@local/prepa:0.1.1": *

#canvas({
  let block-circle = circle
  import cetz.draw: *
  
  // Coordonnées du point M
  let r = 0.4
  let dr = 0.2

  projection-de-face()
  scale(5)

  // Axes de coordonnées

  content((0,0,0), block-circle(radius: 2pt, fill:black) )

  on-yz(x:0, {
    circle((0, 0), radius: r+dr)
    circle((0, 0), radius: r, stroke:(dash: "dashed"))
  })
  on-xy(z:0, {
    arc((0, r+dr), radius: r+dr, start:90deg, stop: -90deg)
    arc((0, r+dr), radius: r+dr, start:90deg, stop: 90deg+180deg, stroke:(dash: "dashed"))
    circle((0, 0), radius: r, stroke:(dash: "dashed"))
    line((0,0), (-30deg, r), mark:(end:">>", fill: black), name:"r")
    content("r", $r$, anchor: "south-east", padding: 0.1)
    line((0,0), (20deg, r+dr), mark:(end:">>", fill: black), name:"r+dr")
    content("r+dr", $r+dd(r)$, anchor: "south-west", padding: 0.1)
  })

})