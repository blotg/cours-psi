#import "@preview/cetz:0.5.2": draw
#import "@preview/cetz:0.5.2"
#import "@preview/cetz-plot:0.1.4": chart, plot
#import "@preview/zap:0.6.0"

#let canvas(..args) = {
    [#cetz.canvas(..args); <canvas>]
}

#let projection-cabinet() = {
    draw.set-transform(((-calc.sqrt(1 / 8), 1, 0, 0), (calc.sqrt(1 / 8), 0, -1, 0), (0, 0, 0, 0), (0, 0, 0, 1)))
}

#let projection-de-face() = {
    draw.set-transform(((0, 1, 0, 0), (calc.sqrt(1 / 8), 0, -1, 0), (0, 0, 0, 0), (0, 0, 0, 1)))
}


// #let ampermeter(name, node, ..params) = {
//     import "@preview/zap:0.6.0": component, interface

//     // Custom styling properties
//     let custom-style = (
//         radius: 0.53,
//     )
//     let draw(ctx, position, style) = {
//         interface(
//             (-custom-style.radius, -custom-style.radius),
//             (custom-style.radius, custom-style.radius),
//             io: position.len() < 2,
//         )
//         cetz.draw.circle((0, 0), radius: custom-style.radius, fill: white, ..style)
//         cetz.draw.content((), "A")
//     }
//     component("ampermeter", name, node, draw: draw, ..params)
// }

// #let voltmeter(name, node, ..params) = {
//     import "@preview/zap:0.6.0": component, interface

//     // Custom styling properties
//     let custom-style = (
//         radius: 0.53,
//     )
//     let draw(ctx, position, style) = {
//         interface(
//             (-custom-style.radius, -custom-style.radius),
//             (custom-style.radius, custom-style.radius),
//             io: position.len() < 2,
//         )
//         cetz.draw.circle((0, 0), radius: custom-style.radius, fill: white, ..style)
//         cetz.draw.content((), "V")
//     }
//     component("voltmeter", name, node, draw: draw, ..params)
// }

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
#let hachure(taille, décalage: 90%) = modpattern((taille, taille))[
    #move(dx: décalage, line(start: (0%, 100%), end: (100%, 0%)))
]
