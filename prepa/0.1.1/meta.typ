
#let flashcard(recto: "", verso: "") = {
    import "symboles.typ" as symboles
    let _ = eval(recto, mode: "markup", scope: dictionary(symboles))
    let _ = eval(verso, mode: "markup", scope: dictionary(symboles))
    [#metadata((recto: recto, verso: verso)) <flashcard>]
}

#let question-de-colle(question) = {
    import "symboles.typ" as symboles
    let _ = eval(question, mode: "markup", scope: dictionary(symboles))
    [#metadata(question) <question-de-colle>]
}

// Rend le recto ou le verso d'une flashcard. `flashcard` ne stocke que la
// source ; c'est ce même eval qui la valide à la compilation du cours. Exposé
// pour que les gabarits (hors du paquet) puissent en faire autant.
#let rendu-carte(source) = {
    import "symboles.typ" as symboles
    eval(source, mode: "markup", scope: dictionary(symboles))
}
