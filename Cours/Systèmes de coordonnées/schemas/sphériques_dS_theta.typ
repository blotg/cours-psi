#import "@local/prepa:0.1.1": *

#canvas({
  let block-circle = circle
  import draw: *
  
  // Coordonnées du point M
  let r = 0.8
  let t = 40deg
  let ph = 40deg
  let dr = 0.5
  let dph = 40deg
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
    rotate(z: ph+dph)
    on-xz(y:0, {
      line((90deg-t,r), (90deg-t,r+dr))
      line((90deg-t,r), (0,0), stroke:dotted)
    })
  })
  group({
    rotate(z: ph)
    on-xy(z:(r+dr) * calc.cos(t), {
      arc(((r+dr)*calc.sin(t),0), radius: (r+dr)*calc.sin(t), start:0deg, delta: dph)
    })
    on-xz(y:0, {
      line((90deg-t,r), (90deg-t,r+dr), stroke: green.darken(20%), name:"l3")
      line((90deg-t,r), (0,0), stroke:dotted+(paint:purple), name:"r")
      content("r.mid", anchor: "west", padding:0.1, text(purple,$r$))
      arc((90deg,0.4), radius:0.4, start:90deg, delta:-t, mark:(end: ">>", fill: black), name:"theta")
      content("theta.mid", anchor: "south-west", padding:0.05, $theta$)
      content("l3.mid", anchor: "west", padding:0.1, text(green.darken(20%),$dd(r)$))
    })
    on-xy(z:(r) * calc.cos(t), {
      arc((r*calc.sin(t),0), radius: r*calc.sin(t), start:0deg, delta: dph, stroke: red.darken(20%), name:"l1")
      line((), (0,0), stroke:dotted)
      line((r*calc.sin(t),0), (0,0), stroke:dotted)
      arc((0.35*calc.sin(t),0), radius: 0.35*calc.sin(t), start:0deg, delta: dph, mark:(end: ">>", fill: black), name:"r")
      content("r.mid", anchor: "south", padding:0.1, $dd(phi)$)
      content("l1.end", anchor: "west", padding:0.4, text(red.darken(20%),$r sin(theta) dd(phi)$))
    })
  })
  line((
      (r+dr/2) * calc.sin(t) * calc.cos(ph+dph/2),
      (r+dr/2) * calc.sin(t) * calc.sin(ph+dph/2),
      (r+dr/2) * calc.cos(t)
    ),(rel: (
      0.5*calc.cos(t) * calc.cos(ph+dph/2),
      0.5*calc.cos(t) * calc.sin(ph+dph/2),
      -0.5*calc.sin(t)
    )), mark: (fill: black, end: ">>"))
  content( (), anchor: "west", padding:0.1, $va(dd(S))$ )
})