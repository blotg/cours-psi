#let grid-paper() = {
    let grid-color = rgb("#CCCCCC")
    let grid-spacing = 5mm
    let thickness = 0.5pt
    // Lignes verticales
    context for x in range(int(page.width / grid-spacing) + 1) {
        place(
            line(
                start: (x * grid-spacing, 0pt),
                end: (x * grid-spacing, page.height),
                stroke: (paint: grid-color, thickness: thickness),
            ),
        )
    }
    // Lignes horizontales
    context for y in range(int(page.height / grid-spacing) + 1) {
        place(
            line(
                start: (0pt, y * grid-spacing),
                end: (page.width, y * grid-spacing),
                stroke: (paint: grid-color, thickness: thickness),
            ),
        )
    }
}

#let grille(hauteur, largeur) = {
    let grid-color = rgb("#CCCCCC")
    let grid-spacing = 5mm
    let thickness = 0.5pt
    // Lignes verticales
    for x in range(int(largeur / grid-spacing) + 1) {
        place(
            top + left,
            dx: x * grid-spacing,
            [
                #line(
                    start: (0pt, 0pt),
                    end: (0pt, hauteur),
                    stroke: (paint: grid-color, thickness: thickness),
                )
            ],
        )
    }
    // Lignes horizontales
    for y in range(int(hauteur / grid-spacing) + 1) {
        place(
            top + left,
            dy: y * grid-spacing,
            line(
                start: (0pt, 0pt),
                end: (largeur, 0pt),
                stroke: (paint: grid-color, thickness: thickness),
            ),
        )
    }
}

#let numérote-code(it) = {
    set par(justify: false)
    grid(
        columns: (auto, auto),
        align: (right, left),
        column-gutter: 1em,
        block(for i in range(it.text.split("\n").len()) {
            text(str(i + 1), gray)
            linebreak()
        }),
        it,
    )
}

#let appendix(body) = {
    set heading(numbering: "A.1", supplement: [Annexe])
    counter(heading).update(0)
    show heading: it => {
        set align(center)
        [#smallcaps(it.supplement) #counter(heading).display() : #it.body]
    }
    body
}
