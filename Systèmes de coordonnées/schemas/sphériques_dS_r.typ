#import "@local/prepa:0.1.0": *

#canvas({
  let block-circle = circle
  import draw: *
  
  // Coordonnées du point M
  let r = 0.8
  let t = 32deg
  let ph = 35deg
  let dt = 40deg
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
      arc((90deg-t,r), radius:r, start:90deg-t, delta: -dt, )
      line((90deg-t,r), (0,0), stroke:dotted)
      line((90deg-t - dt,r), (0,0), stroke:dotted)
    })
  })
  group({
    rotate(z: ph)
    on-xy(z:r * calc.cos(t+dt), {
      arc((r*calc.sin(t+dt),0), radius: r*calc.sin(t+dt), start:0deg, delta: dph)
    })
    on-xz(y:0, {
      line((90deg-t,r), (0,0), stroke:dotted+(paint:purple), name:"r")
      content("r.mid", anchor: "west", padding:0.1, text(purple,$r$))
      line((90deg-t - dt,r), (0,0), stroke:dotted)
      arc((90deg,0.4), radius:0.4, start:90deg, delta:-t, mark:(end: ">>", fill: black), name:"theta")
      arc((90deg-t,r), radius:r, start:90deg-t, delta: -dt, name:"l2", stroke: blue.darken(20%))
      content("l2.mid", anchor: "south-west", padding:0.1, text(blue.darken(20%),$r dd(theta)$))
      content("theta.mid", anchor: "south-west", padding:0.1, $theta$)
      arc((90deg-t,0.3), radius:0.3, start:90deg-t, delta:-dt, mark:(end: ">>", fill: black), name:"dtheta")
      content("dtheta.mid", anchor: "south-west", padding:0.1, $dd(theta)$)
    })
    on-xy(z:(r) * calc.cos(t), {
      arc((r*calc.sin(t),0), radius: r*calc.sin(t), start:0deg, delta: dt, stroke: red.darken(20%), name:"l1")
      line((), (0,0), stroke:dotted)
      line((r*calc.sin(t),0), (0,0), stroke:dotted)
      arc((0.5*calc.sin(t),0), radius: 0.5*calc.sin(t), start:0deg, delta: dt, mark:(end: ">>", fill: black), name:"r")
      content("r.mid", anchor: "south-east", padding:0.1, $dd(phi)$)
      content("l1.mid", anchor: "south-west", padding:0.3, text(red.darken(20%),$r sin(theta) dd(phi)$))
    })
  })
  line((
      r * calc.sin(t+dt/2) * calc.cos(ph+dph/2),
      r * calc.sin(t+dt/2) * calc.sin(ph+dph/2),
      r * calc.cos(t+dt/2)
    ),(rel: (
      0.5*calc.sin(t+dt/2) * calc.cos(ph+dph/2),
      0.5*calc.sin(t+dt/2) * calc.sin(ph+dph/2),
      0.5*calc.cos(t+dt/2)
    )), mark: (fill: black, end: ">>"))
    content( (), anchor: "west", padding:0.1, $va(dd(S))$ )
})