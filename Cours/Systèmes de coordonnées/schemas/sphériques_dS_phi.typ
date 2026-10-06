#import "@local/prepa:0.1.1": *
#import "couleurs.typ": *

#canvas({
  let block-circle = circle
  import cetz.draw: *
  
  // Coordonnées du point M
  let r = 1.1
  let t = 50deg
  let ph = 35deg
  let dr = 0.5
  let dt = 20deg
  let z = r * calc.cos(t)
  let x = r * calc.sin(t) * calc.cos(ph)
  let y = r * calc.sin(t) * calc.sin(ph)

  projection-cabinet()
  scale(3.5)

  // Axes de coordonnées
  line((0, 0, 0), (1, 0, 0), mark: (fill: black, end: ">>"))
  line((0, 0, 0), (0, 1, 0), mark: (fill: black, end: ">>"))
  line((0, 0, 0), (0, 0, 1), mark: (fill: black, end: ">>"))

  let dotted= (dash:"dotted", thickness:0.5pt)  

  group({
    rotate(z: ph)
    on-xz(y:0, {
      arc((90deg-t,r+dr), radius:r+dr, start:90deg-t, delta: -dt, name:"y")
      line((90deg-t,r), (90deg-t,r+dr), stroke: vermillon, name:"l3")
      line((90deg-t - dt,r), (90deg-t - dt,r+dr))
      line((90deg-t,r), (0,0), stroke:dotted+(paint:vermillon), name:"r")
      content("r.mid", anchor: "south-east", padding:0.1, text(vermillon,$r$))
      line((90deg-t - dt,r), (0,0), stroke:dotted)
      arc((90deg,0.2), radius:0.2, start:90deg, delta:-t, mark:(end: ">>", fill: black), name:"theta")
      arc((90deg-t,r), radius:r, start:90deg-t, delta: -dt, name:"l2", stroke: bleu)
      content("l2.start", anchor: "east", padding:0.1, text(bleu,$r dd(theta)$))
      content("theta.mid", anchor: "south-west", padding:0.05, $theta$)
      arc((90deg-t,0.5), radius:0.5, start:90deg-t, delta:-dt, mark:(end: ">>", fill: black), name:"dtheta")
      content("dtheta.mid", anchor: "south-west", padding:0.1, $dd(theta)$)
      content("l3.mid", anchor: "east", padding:0.1, text(vermillon,$dd(r)$))
    })
    on-xy(z:(r+dr/2)*calc.cos(t+dt/2) ,{
      arc((0deg,(r+dr/2)*calc.sin(t+dt/2)), radius: (r+dr/2)*calc.sin(t+dt/2), start:0deg, delta: -ph, stroke: dotted)
      arc((0deg,(r+dr/2)*calc.sin(t+dt/2)), radius: (r+dr/2)*calc.sin(t+dt/2), start:0deg, delta: 90deg-ph, stroke: dotted)
      line(( (r+dr/2)*calc.sin(t+dt/2),0), (rel: (0,0.4)), stroke:(dash: "dashed"), name:"x")
      intersections("i", "x", "y")
      for-each-anchor("i", (name) => {
        line("i."+name, (rel: (0,0.4)), mark:(fill: black, end: ">>"))
        content((), anchor: "north-west", padding:0.1, $va(dd(S))$ )
      })
    })
  })
})