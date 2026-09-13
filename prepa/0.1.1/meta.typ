
// Une flashcard ou une question de colle s'écrit en bloc de contenu :
//
//     #flashcard(recto: [Débit volumique], verso: [$ D_V = integral.double_S va(v) dot va(dd(S)) $])
//     #question-de-colle[Établir l'équation locale de conservation de la masse.]
//
// La forme en chaine, `recto: "…"`, reste acceptée : elle est évaluée en markup
// avec le scope des chaines, d'un seul tenant — et non ligne à ligne comme le
// fait `markup()`, qui couperait un schéma écrit sur plusieurs lignes.
//
// Dans les deux cas la métadonnée porte du content. `typst query` le sérialise
// avec perte — une formule `pdv(f, t)` n'y est plus qu'un `context` vide — :
// les outils ne relisent donc pas les cartes par là, mais en incluant le cours
// dans le document qui les rend (cf. `cours-en-annexe`).
#let _contenu(x) = if type(x) == str {
    import "helper-functions.typ": scope-des-chaines
    eval(x, mode: "markup", scope: scope-des-chaines)
} else { x }

#let flashcard(recto: [], verso: []) = {
    [#metadata((recto: _contenu(recto), verso: _contenu(verso))) <flashcard>]
}

#let question-de-colle(question) = {
    [#metadata(_contenu(question)) <question-de-colle>]
}

// Inclut des cours à la suite d'un document pour en lire les flashcards et les
// questions de colle : la planche à découper, les listes de questions de colle.
//
//     #show: cours-en-annexe.with(include "/Cours/…/cours.typ")
//
// Les cours sont composés après le document, sur leurs propres pages : query()
// y trouve leurs métadonnées, et l'outil ne garde que les pages du document
// (`typst compile --pages`). Le repère <fin-du-document> porte le numéro de la
// dernière d'entre elles. Il est posé en tête de l'annexe et non en fin de
// document : sur une page pleine, un repère de fin tomberait déjà sur la
// suivante.
//
// Pas de boîte masquée pour s'épargner ces pages : ce qui s'en échappe ne se
// maîtrise pas. Les notes de bas de page des cours remontaient au pied de la
// page hôte — elles décalaient toute la planche d'Électronique 3 —, et les
// retirer au niveau de la page faisait perdre trente-cinq questions à la liste
// des questions de colle.
//
// À compiler avec `--input inclus=1` : c'est ce qui dit à `cours()` de ne pas
// mettre la page en place (cf. `inclus-dans-le-poly`).
//
// Chaque cours est précédé d'un repère <cours-en-annexe>, dont `par-cours` se
// sert pour rendre à chacun ce qui vient de lui.
#let cours-en-annexe(..cours, doc) = {
    assert(
        sys.inputs.at("inclus", default: "") != "",
        message: "cours-en-annexe : compiler avec --input inclus=1",
    )
    doc
    pagebreak(weak: true)
    context [#metadata(here().page() - 1) <fin-du-document>]
    for (i, c) in cours.pos().enumerate() {
        [#metadata(i) <cours-en-annexe>]
        c
    }
}

// Les valeurs des métadonnées `étiquette`, cours en annexe par cours en annexe,
// dans l'ordre où les cours ont été donnés. Appelle query() : à placer dans un
// `context`.
#let par-cours(étiquette) = {
    let repères = query(<cours-en-annexe>)
    repères
        .enumerate()
        .map(((i, repère)) => {
            let sélecteur = selector(étiquette).after(repère.location())
            if i + 1 < repères.len() {
                sélecteur = sélecteur.before(repères.at(i + 1).location())
            }
            query(sélecteur).map(m => m.value)
        })
}

// Question de début de cours : un QCM d'une poignée de réponses, posé en
// ouverture de séance pour réveiller le cours précédent.
//
// N'imprime rien : le poly n'en montre pas trace. Elle n'alimente, par ses
// métadonnées, que le diaporama produit par `outils diapo`. La **première
// réponse est la bonne** — l'ordre d'affichage est tiré au sort à la
// génération du diaporama, comme pour l'export QCMCam.
#let question-de-début-de-cours(énoncé, réponses) = {
    import "helper-functions.typ": scope-des-chaines
    assert(
        type(réponses) == array and réponses.len() >= 2,
        message: "question-de-début-de-cours(« " + énoncé + " ») : il faut au moins deux réponses",
    )
    // Même validation que les flashcards : on évalue à la compilation du cours
    // pour qu'une formule fautive se voie ici, et non trois documents plus loin.
    let _ = eval(énoncé, mode: "markup", scope: scope-des-chaines)
    for réponse in réponses {
        let _ = eval(réponse, mode: "markup", scope: scope-des-chaines)
    }
    [#metadata((énoncé: énoncé, réponses: réponses)) <question-de-début-de-cours>]
}
