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
