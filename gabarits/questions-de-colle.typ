// Toutes les questions de colle de l'année, chapitre par chapitre.
//
// Alimenté par `outils questions-de-colle`, qui passe en `--input données` le
// JSON produit par `typst query <question-de-colle>` sur le cours de chaque
// chapitre :
//
//     {"chapitres": [{"titre": "...", "questions": ["...", ...]}, ...]}
//
// Les chapitres arrivent dans l'ordre où ils doivent sortir — celui du tri
// lexicographique des dossiers de `Cours/` — et ceux qui n'ont pas encore de
// question sont du lot, avec une liste vide : ils sortent signalés « à venir »
// plutôt qu'omis, pour qu'on voie du même coup ce qu'il reste à écrire.
//
// La numérotation est **continue d'un bout à l'autre** : chaque question porte
// un numéro qui l'identifie dans toute l'année, de quoi dire « révise 12 à 27 »
// sans avoir à nommer le chapitre. C'est la différence avec le programme de
// colle hebdomadaire, où elle repart à 1 à chaque chapitre.

#import "@local/prepa:0.1.1": *

#let données = json(bytes(sys.inputs.données))
#let chapitres = données.at("chapitres", default: ())

#let _gris = luma(45%)
#let _pâle = luma(65%)

#let _questions(chapitre) = chapitre.at("questions", default: ())

#let _total = chapitres.map(c => _questions(c).len()).sum(default: 0)

// Le numéro de la première question de chaque chapitre. Un `fold` plutôt qu'un
// compteur typst : les numéros servent ici à la mise en page (largeur de la
// colonne), il faut les connaitre avant de composer la page.
#let _départs = chapitres.fold((1,), (acc, c) => acc + (acc.last() + _questions(c).len(),))

#show: init-document.with(titre: "Questions de colle")

#set par(justify: true)

// Le titre du chapitre ne doit pas rester seul en bas de page, séparé de ses
// questions : `sticky` le fait descendre avec le bloc qui suit.
//
// La taille est posée en dur, plus petite que celle d'un titre de niveau 1 :
// à 1,4 em le titre de chapitre pesait autant que celui du document, juste
// au-dessus, et la hiérarchie se perdait.
//
// Et un titre n'est pas un paragraphe : sous le `justify` du corps, « Phénomènes
// de transport 2 : Transfert thermique par conduction » s'étirait sur deux
// lignes pleine largeur, coupé par une césure.
#show heading.where(level: 1): it => block(sticky: true, above: 1.6em, below: 0.9em, width: 100%)[
    #set par(justify: false)
    #set text(size: 12.5pt, weight: "bold", hyphenate: false)
    #it.body
    #v(-0.5em)
    #line(length: 100%, stroke: 0.5pt + luma(80%))
]

#titre-document[Questions de cours à travailler prioritairement]

#align(center, text(fill: _gris)[
    // #_total questions de cours, posées en interrogation orale
    Chaque étudiant devra apporter ce document lors des interrogations orales.

    Les #_total question de cours listées ici sont à travailler prioritairement. Elles sont fréquemment demandées à l'écrit comme à l'oral, même pour les concours plus sélectifs et elles servent de fondation sur lesquelles les exercices s'appuient. Leur maitrise est donc indispensable. À un apprentissage par cœur, fondamentalement inefficace, on préfèrera une compréhension fine.
])
#v(1.2em)

// Colonne de numéros de largeur fixe : toutes les questions du document
// s'alignent, quel que soit le chapitre et le nombre de chiffres.
#let _largeur-numéro = if _total >= 100 { 2.4em } else { 1.9em }

#for (i, chapitre) in chapitres.enumerate() {
    heading(level: 1, markup(chapitre.at("titre", default: "")))
    let questions = _questions(chapitre)
    if questions.len() == 0 {
        block(inset: (left: _largeur-numéro + 0.5em), text(fill: _pâle, style: "italic")[
            Aucune question pour l'instant.
        ])
    } else {
        grid(
            columns: (_largeur-numéro, 1fr),
            column-gutter: 0.5em,
            row-gutter: 0.7em,
            ..questions
                .enumerate()
                .map(((j, q)) => (
                    align(right + top, text(fill: _gris)[#(_départs.at(i) + j).]),
                    markup(q),
                ))
                .flatten()
        )
    }
}
