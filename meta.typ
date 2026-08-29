
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
