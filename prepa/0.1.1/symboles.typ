#import "@preview/physica:0.9.8": *
#import "@preview/typsium:0.3.2": ce
// #import "@preview/whalogen:0.3.0": ce
#import "@preview/unify:0.8.1": *

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

#let scientifique(nombre, chiffres-significatifs) = {
    // Avec 0, calc.round(mantisse, digits: -1) arrondirait la mantisse à la
    // dizaine : « 3,1e-3 » sortirait « 0e-3 » et « 7,5e0 » sortirait « 10e0 ».
    assert(
        chiffres-significatifs >= 1,
        message: "scientifique() : il faut au moins un chiffre significatif, reçu "
            + str(chiffres-significatifs),
    )
    if nombre == 0 {
        return "0"
    }

    // On travaille sur la valeur absolue : sur un négatif, int() tronque vers
    // zéro (−3,8 donne −3) alors que rem-euclid reste positif (−38 mod 10 = 2),
    // et les deux conventions se contredisaient : −380 sortait « −3,2e2 ».
    let signe = if nombre < 0 { "-" } else { "" }
    let x = calc.abs(nombre)

    let exposant = int(calc.floor(calc.log(x, base: 10)))
    let mantisse = calc.round(x / calc.pow(10.0, exposant), digits: chiffres-significatifs - 1)
    // L'arrondi peut porter la mantisse à 10 (9,96 à deux chiffres) : on
    // remonte alors l'exposant pour la ramener dans [1, 10[.
    if mantisse >= 10 {
        mantisse = mantisse / 10
        exposant += 1
    }

    // Les chiffres significatifs sont ceux de mantisse × 10^(c−1), qui compte
    // exactement c chiffres puisque la mantisse est dans [1, 10[.
    let chiffres = str(int(calc.round(mantisse * calc.pow(10, chiffres-significatifs - 1))))
    let n = if chiffres-significatifs > 1 {
        chiffres.slice(0, 1) + "." + chiffres.slice(1)
    } else {
        chiffres
    }

    return signe + n + if exposant == 0 { "" } else { "e" + str(exposant) }
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