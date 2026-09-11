#import "@preview/physica:0.9.8": *
#import "@preview/typsium:0.3.2": ce
// #import "@preview/whalogen:0.3.0": ce

#let div = math.class(
    "unary",
    "div ",
)

// Le va() de physica applique math.italic sans condition : $va("grad ")$ sort
// « grad » en italique, alors que div, défini par une simple chaine, sort en
// romain. On force donc le romain, et on met l'espace hors de l'accent pour que
// la flèche ne déborde pas du mot.
#let grad = math.class(
    "unary",
    $arrow(upright("grad")) thin$,
)

#let rot = math.class(
    "unary",
    $arrow(upright("rot")) thin$,
)

#let mean(val) = {
    math.lr({
        math.chevron.l
        val
        math.chevron.r
    })
}

// `scientifique(x, n)` a disparu : elle fabriquait à la main la chaine
// « 3.1e-3 » que `num`/`qty` recevaient ensuite. C'est désormais zero qui met
// en forme, et l'appel dit ce qu'il veut : `qty(x, "T", chiffres: 2)`
// (cf. `types-documents.typ`).


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