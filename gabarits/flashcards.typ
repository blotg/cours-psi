// Flashcards d'un chapitre, prêtes à imprimer et à découper.
//
// Quatre cartes par page A4 (grille 2 × 2, format A6). Les rectos d'un groupe
// de quatre occupent une page, leurs versos la suivante : en impression
// recto-verso avec retournement sur le **bord long**, chaque verso retombe
// derrière son recto. C'est pourquoi la page des versos est en miroir
// horizontal — la carte en haut à gauche du recto a son verso en haut à
// droite.
//
// Alimenté par `outils flashcards --imprimable`, qui passe en `--input
// données` le JSON produit par `typst query <flashcard>` sur le cours :
//
//     {"titre": "...", "cartes": [{"recto": "...", "verso": "..."}]}

#import "@local/prepa:0.1.1": *

#let données = json(bytes(sys.inputs.données))
#let cartes = données.at("cartes", default: ())

#let _largeur = 105mm
#let _hauteur = 148.5mm

// Ordre des cases sur la page des versos : miroir horizontal de 0 1 / 2 3.
#let _miroir = (1, 0, 3, 2)

#show: init-document.with(titre: "Flashcards — " + données.titre, logotype: false)

// Pas de pied de page : il tomberait au travers des cartes. La mention de
// licence n'a pas de sens ici, les cartes sont découpées.
#set page(paper: "a4", margin: 0pt, numbering: none, footer: none)
#set text(size: 11pt)
#set par(justify: false)

#let _marge = 9mm

// Réduit le contenu pour qu'il tienne dans la carte.
//
// Deux débordements possibles, qui n'appellent pas le même remède :
// un paragraphe trop long déborde en hauteur (il se replie déjà en largeur),
// un schéma trop large déborde en largeur (il ne se replie pas). On les
// distingue en mesurant la hauteur à deux largeurs de mise en page : elle
// change pour du texte, pas pour un schéma.
#let _ajusté(contenu, dl, dh) = context {
    let replié = measure(box(width: dl, contenu)).height
    let déplié = measure(box(width: 10 * dl, contenu)).height
    let f = if replié == déplié { calc.min(1.0, dl / measure(contenu).width) } else { 1.0 }

    // Élargir la mise en page réduit la hauteur : on descend par paliers
    // jusqu'à ce que ça tienne, sans boucler indéfiniment.
    let n = 0
    while n < 20 and measure(box(width: dl / f, contenu)).height * f > dh {
        f = f * 0.92
        n = n + 1
    }
    scale(box(width: dl / f, contenu), x: f * 100%, y: f * 100%, reflow: true)
}

#let case(contenu) = box(
    width: _largeur,
    height: _hauteur,
    // Repère de découpe, assez pâle pour ne pas salir la carte.
    stroke: (paint: luma(75%), thickness: 0.3pt, dash: "dashed"),
    inset: _marge,
)[
    #set align(center + horizon)
    #if contenu != none {
        _ajusté(contenu, _largeur - 2 * _marge, _hauteur - 2 * _marge)
    }
]

#let feuille(groupe, face) = grid(
    columns: (_largeur, _largeur),
    rows: (_hauteur, _hauteur),
    ..range(4).map(i => {
        let j = if face == "verso" { _miroir.at(i) } else { i }
        case(if j < groupe.len() { rendu-carte(groupe.at(j).at(face)) })
    })
)

#if cartes.len() == 0 [
    #set page(margin: 2cm)
    #align(center + horizon, emph[Aucune flashcard dans ce chapitre.])
] else {
    for (n, groupe) in cartes.chunks(4).enumerate() {
        if n > 0 { pagebreak() }
        feuille(groupe, "recto")
        pagebreak()
        feuille(groupe, "verso")
    }
}
