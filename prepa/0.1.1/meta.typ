
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

// Question de début de cours : un QCM d'une poignée de réponses, posé en
// ouverture de séance pour réveiller le cours précédent.
//
// N'imprime rien : le poly n'en montre pas trace. Elle n'alimente, par ses
// métadonnées, que le diaporama produit par `outils diapo`. La **première
// réponse est la bonne** — l'ordre d'affichage est tiré au sort à la
// génération du diaporama, comme pour l'export QCMCam.
#let question-de-début-de-cours(énoncé, réponses) = {
    import "symboles.typ" as symboles
    assert(
        type(réponses) == array and réponses.len() >= 2,
        message: "question-de-début-de-cours(« " + énoncé + " ») : il faut au moins deux réponses",
    )
    // Même validation que les flashcards : on évalue à la compilation du cours
    // pour qu'une formule fautive se voie ici, et non trois documents plus loin.
    let _ = eval(énoncé, mode: "markup", scope: dictionary(symboles))
    for réponse in réponses {
        let _ = eval(réponse, mode: "markup", scope: dictionary(symboles))
    }
    [#metadata((énoncé: énoncé, réponses: réponses)) <question-de-début-de-cours>]
}
