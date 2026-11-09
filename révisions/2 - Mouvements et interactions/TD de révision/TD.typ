#import "@local/prepa:0.1.1": *

// Une fiche à photocopier en recto verso : les énoncés au recto, leurs
// corrigés au verso. L'élève cherche, puis retourne la feuille.
//
// Les exercices s'écrivent comme ceux des chapitres, le corrigé sous chaque
// question : ils restent réutilisables tels quels dans un TD. C'est ici qu'ils
// sont séparés. Au recto, chaque corrigé est tu et laisse à sa place une
// métadonnée — exercice, question, contenu — que le verso rassemble.
//
// Ce dossier n'a ni cours.typ ni poly.typ : ni le hook pre-commit ni les
// outils ne le prennent pour un chapitre. Il se compile à la main :
//     typst compile TD.typ "build/TD de révision - Mécanique.pdf"

#show: init-document.with(titre: "TD de révision de mécanique de PCSI")
#set heading(numbering: "1.")

#show <correction>: it => context [#metadata((
    exercice: counter(heading).get().first(),
    question: numQuestion.get().first(),
    corps: it.body,
)) <corrigé-au-verso>]

#titre-document[TD de révision de mécanique de PCSI]

#include "exercices/Transfert d'orbite.typ"
#include "exercices/Chute d'une échelle.typ"

#pagebreak()

// Le verso est plus dense que le recto : un corps plus petit l'y fait tenir.
#set text(size: 10pt)
#show heading: set text(size: 12pt)
#show heading: set block(above: 1em, below: 0.6em)
#show math.equation.where(block: true): set block(above: 0.55em, below: 0.55em)

#context {
    let corrigés = query(<corrigé-au-verso>).map(m => m.value)
    for (i, titre) in query(<titre-exercice>).enumerate(start: 1) {
        let siens = corrigés.filter(c => c.exercice == i)
        heading(numbering: none, outlined: false)[Corrigé #i -- #titre.body]
        for c in siens {
            // Un exercice à une seule question — un problème ouvert — n'a
            // pas de numéro de question au recto : pas davantage au verso.
            if siens.len() > 1 [*#c.question#sym.slash* ]
            c.corps
            parbreak()
        }
    }
}
