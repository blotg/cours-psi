#import "@preview/cetz:0.5.2"
#import "@preview/cetz-plot:0.1.4": chart, plot
#import "@preview/zap:0.6.0"

#let canvas(..args) = {
    [#cetz.canvas(..args); <canvas>]
}

#let projection-cabinet() = {
    cetz.draw.set-transform(((-calc.sqrt(1 / 8), 1, 0, 0), (calc.sqrt(1 / 8), 0, -1, 0), (0, 0, 0, 0), (0, 0, 0, 1)))
}

#let projection-de-face() = {
    cetz.draw.set-transform(((0, 1, 0, 0), (calc.sqrt(1 / 8), 0, -1, 0), (0, 0, 0, 0), (0, 0, 0, 1)))
}

#let transformateur(
    name,
    node,
    borne-homologue-primaire-inversée: false,
    borne-homologue-secondaire-inversée: false,
    ..params,
) = {
    import "@preview/zap:0.6.0": symbol, interface

    // Custom styling properties
    let custom-style = (
        radius: 0.53,
        spacing: 0.6,
        height: 2,
    )
    let draw(ctx, position, style) = {
        let width = custom-style.height + custom-style.spacing
        cetz.draw.anchor("P+", (-width / 2, custom-style.height / 2))
        cetz.draw.anchor("P-", (-width / 2, -custom-style.height / 2))
        cetz.draw.anchor("S+", (width / 2, custom-style.height / 2))
        cetz.draw.anchor("S-", (width / 2, -custom-style.height / 2))
        interface(
            (-width / 2, -custom-style.height / 2),
            (width / 2, custom-style.height / 2),
            io: position.len() < 2,
        )
        cetz.draw.set-style(stroke: 0.5pt)
        cetz.draw.line(
            (-width / 2, -custom-style.height / 2),
            (rel: (45deg, custom-style.height / calc.sqrt(2) - custom-style.radius)),
        )
        cetz.draw.line(
            (-width / 2, custom-style.height / 2),
            (rel: (-45deg, custom-style.height / calc.sqrt(2) - custom-style.radius)),
        )
        cetz.draw.line(
            (width / 2, -custom-style.height / 2),
            (rel: (135deg, custom-style.height / calc.sqrt(2) - custom-style.radius)),
        )
        cetz.draw.line(
            (width / 2, custom-style.height / 2),
            (rel: (-135deg, custom-style.height / calc.sqrt(2) - custom-style.radius)),
        )
        cetz.draw.circle(
            (-custom-style.spacing / 2, 0),
            radius: custom-style.radius,
            ..style,
        )
        cetz.draw.circle(
            (custom-style.spacing / 2, 0),
            radius: custom-style.radius,
            ..style,
        )
        if borne-homologue-primaire-inversée {
            cetz.draw.circle(
                (rel: (-custom-style.spacing / 2, -0.2), to: (-135deg, custom-style.radius)),
                radius: 0.05,
                fill: black,
            )
        } else {
            cetz.draw.circle(
                (rel: (-custom-style.spacing / 2, 0.2), to: (135deg, custom-style.radius)),
                radius: 0.05,
                fill: black,
            )
        }
        if borne-homologue-secondaire-inversée {
            cetz.draw.circle(
                (rel: (custom-style.spacing / 2, -0.2), to: (-45deg, custom-style.radius)),
                radius: 0.05,
                fill: black,
            )
        } else {
            cetz.draw.circle(
                (rel: (custom-style.spacing / 2, 0.2), to: (45deg, custom-style.radius)),
                radius: 0.05,
                fill: black,
            )
        }
    }
    symbol("transformateur", name, node, draw: draw, ..params)
}

#let thyristor(name, node, ..params) = {
    import "@preview/zap:0.6.0": symbol, interface

    // Custom styling properties
    let custom-style = ()
    let draw(ctx, position, style) = {
        interface(
            (-0.5, -0.5),
            (0.5, 0.5),
            io: position.len() < 2,
        )
        zap.diode("D", (-0.5, 0), (0.5, 0))
        cetz.draw.line((0.23, 0.11), (rel: (45deg, 0.3)), stroke: 0.8pt)
    }
    symbol("thyristor", name, node, draw: draw, ..params)
}

#import "@preview/modpattern:0.2.0": modpattern
#let hachure(taille, décalage: 90%) = modpattern(size: (taille, taille))[
    #move(dx: décalage, line(start: (0%, 100%), end: (100%, 0%)))
]

// Fil de circuit avec décoration de courant.
//
// zap 0.6.0 plante sur `wire(..., i: …)` dès que le fil est aligné sur un axe :
// la décoration s'appuie sur un rectangle nommé « symbol » tracé entre line.50%
// et line.51%, donc plat — et un rectangle plat n'a pas d'ancre de bord (« does
// not have a border for anchor '0deg' »). `fil` retrace ce rectangle autour du
// milieu du fil. Sans `i:`, c'est exactement `zap.wire`.
#let fil(..params, i: none, name: none) = {
    if i == none { return zap.wire(name: name, ..params) }
    cetz.draw.group(name: name, {
        zap.wire(name: "fil", ..params)
        cetz.draw.anchor("in", "fil.in")
        cetz.draw.anchor("out", "fil.out")
        cetz.draw.hide(cetz.draw.rect(
            (rel: (-0.01, -0.01), to: ("fil.in", 50%, "fil.out")),
            (rel: (0.01, 0.01), to: ("fil.in", 50%, "fil.out")),
            name: "symbol",
        ))
        zap.current(i)
    })
}
