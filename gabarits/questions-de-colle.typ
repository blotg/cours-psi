// Toutes les questions de colle de l'année, chapitre par chapitre.
//
// Alimenté par `outils questions-de-colle`, qui passe en `--input données` les
// chapitres et le chemin de leur cours :
//
//     {"révisions": false, "chapitres": [{"titre": "...", "cours": "/Cours/.../cours.typ"}, ...]}
//
// `révisions` fait titrer le document « révisions de PCSI » plutôt que « PSI ».
//
// Les questions elles-mêmes n'y sont pas : elles portent du content, que `typst
// query` ne restitue qu'avec perte. Les cours sont donc tous inclus à la suite
// de la liste (cf. `cours-en-annexe`), et les questions lues sur place, cours
// par cours — d'où la compilation avec `--root` à la racine du dépôt et
// `--input inclus=1`, et `--pages` pour écarter les pages des cours.
//
// Les chapitres arrivent dans l'ordre où ils doivent sortir — celui du tri
// lexicographique des dossiers de `Cours/` — et ceux qui n'ont pas encore de
// question sont du lot : ils sortent signalés « à venir » plutôt qu'omis, pour
// qu'on voie du même coup ce qu'il reste à écrire.
//
// La numérotation est **continue d'un bout à l'autre** : chaque question porte
// un numéro qui l'identifie dans toute l'année, de quoi dire « révise 12 à 27 »
// sans avoir à nommer le chapitre. C'est la différence avec le programme de
// colle hebdomadaire, où elle repart à 1 à chaque chapitre.

#import "@local/prepa:0.1.1": *

#let données = json(bytes(sys.inputs.données))
#let chapitres = données.at("chapitres", default: ())
#let classe = if données.at("révisions", default: false) { "révisions de PCSI" } else { "PSI" }

#let _gris = luma(45%)
#let _pâle = luma(65%)

#show: init-document.with(titre: "Questions de colle — " + classe)
#show: cours-en-annexe.with(..chapitres.map(chapitre => include chapitre.cours))

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

// La classe sur sa propre ligne : à la suite, « révisions de PCSI » faisait
// déborder le titre et laissait « PCSI » seul sur la seconde.
#titre-document[Questions de cours à travailler prioritairement \ #classe]

#context {
    let questions = par-cours(<question-de-colle>)
    let total = questions.map(q => q.len()).sum(default: 0)

    // Le numéro de la première question de chaque chapitre. Un `fold` plutôt
    // qu'un compteur typst : les numéros servent ici à la mise en page (largeur
    // de la colonne), il faut les connaitre avant de composer la page.
    let départs = questions.fold((1,), (acc, q) => acc + (acc.last() + q.len(),))

    [
        #set text(fill: _gris)
        #set align(center)

        // #total questions de cours, posées en interrogation orale
        Chaque étudiant devra apporter ce document lors des interrogations orales.

        #set align(left)
        Les #total question de cours listées ici sont à travailler prioritairement. Elles sont fréquemment demandées à l'écrit comme à l'oral, même pour les concours plus sélectifs et elles servent de fondation sur lesquelles les exercices s'appuient. Leur maitrise est donc indispensable. À un apprentissage par cœur, fondamentalement inefficace, on préfèrera une compréhension fine.
    ]
    v(1.2em)

    // Colonne de numéros de largeur fixe : toutes les questions du document
    // s'alignent, quel que soit le chapitre et le nombre de chiffres.
    let largeur-numéro = if total >= 100 { 2.4em } else { 1.9em }

    for (i, chapitre) in chapitres.enumerate() {
        heading(level: 1, markup(chapitre.at("titre", default: "")))
        if questions.at(i).len() == 0 {
            block(inset: (left: largeur-numéro + 0.5em), text(fill: _pâle, style: "italic")[
                Aucune question
            ])
        } else {
            grid(
                columns: (largeur-numéro, 1fr),
                column-gutter: 0.5em,
                row-gutter: 0.7em,
                ..questions
                    .at(i)
                    .enumerate()
                    .map(((j, q)) => (
                        align(right + top, text(fill: _gris)[#(départs.at(i) + j).]),
                        q,
                    ))
                    .flatten()
            )
        }
    }
}
