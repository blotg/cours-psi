#import "@preview/physica:0.9.6": *
#import "@preview/typsium:0.3.2": ce
// #import "@preview/whalogen:0.3.0": ce
#import "@preview/unify:0.7.1": *

#let div = math.class(
    "unary",
    "div ",
)

#let grad = math.class(
    "unary",
    $va("grad ")$,
)

#let rot = math.class(
    "unary",
    $va("rot ")$,
)

#let rot = math.class(
    "unary",
    $va("rot ")$,
)

#let mean(val) = {
    math.lr({
        math.chevron.l
        val
        math.chevron.r
    })
}

#let scientifique(nombre, chiffres-significatifs) = {
    if nombre == 0 {
        return "0"
    }

    let exposant = int(calc.floor(calc.log(calc.abs(nombre), base: 10)))
    let mantisse = nombre / calc.pow(10.0, exposant)
    mantisse = calc.round(mantisse, digits: chiffres-significatifs - 1)
    let n = str(int(calc.round(mantisse, digits: 1)))
    if chiffres-significatifs > 1 {
        n += "."
    }
    for i in range(1, chiffres-significatifs) {
        n += str(int(calc.rem-euclid(mantisse * calc.pow(10, i), 10)))
    }
    if exposant == 0 {
        return str(n)
    } else {
        return str(n) + "e" + str(exposant)
    }
}


#let compétence-TP = text(font: "Noto Emoji", emoji.hands.raised)
#let compétence-numérique = text(font: "Noto Emoji", emoji.computer)

#let Na = $cal(N)_a$

#let ex = $va(e_x)$
#let ey = $va(e_y)$
#let ez = $va(e_z)$
#let er = $va(e_r)$
#let etheta = $va(e_theta)$
#let ephi = $va(e_phi)$

#let partdv(var) = $dv(var,t,d: upright("D"))$
#let standard(var) = $#var^circle.tiny$
#let circ = $circle.tiny$
#let pH = $upright("pH")$