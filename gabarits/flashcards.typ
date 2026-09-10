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
//     {"titre": "...", "titre-court": "...",
//      "cartes": [{"recto": "...", "verso": "..."}]}

#import "@local/prepa:0.1.1": *

#let données = json(bytes(sys.inputs.données))
#let cartes = données.at("cartes", default: ())
#let _titre-court = données.at("titre-court", default: données.at("titre", default: ""))

#let _largeur = 105mm
#let _hauteur = 148.5mm

// Hauteur du bandeau de tête, prise sur la carte : la zone de contenu perd
// d'autant.
#let _bandeau-hauteur = 11mm

// Ordre des cases sur la page des versos : miroir horizontal de 0 1 / 2 3.
#let _miroir = (1, 0, 3, 2)

// La planche est une grille pleine page : ni marge, ni numéro, ni pied — il
// tomberait au travers des cartes, et la mention de licence n'a pas de sens
// sur des cartes découpées. Le message du cas vide, lui, est un document
// ordinaire. Tout se décide ici : redéfinir la page après coup ouvrirait une
// page blanche.
#let vide = cartes.len() == 0

#show: init-document.with(
    titre: "Flashcards — " + données.titre,
    logotype: vide,
    marge: if vide { 2cm } else { 0pt },
    numérotation: none,
    pied: if vide { auto } else { none },
)
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

// Bandeau de tête, sur les deux faces : une carte découpée finit seule sur un
// coin de table, et rien d'autre ne dit alors de quel chapitre elle vient.
//
// Il porte le titre COURT (« Électronique 2 »). Le titre complet n'y tiendrait
// pas : « Transformations de la matière : aspects thermodynamiques et
// cinétiques 2 : Deuxième principe… » couvre trois lignes sur 105 mm de large.
//
// Le numéro à droite ne sert pas à apparier recto et verso — l'impression s'en
// charge — mais à remettre un paquet en ordre, et à voir d'un coup d'œil qu'une
// planche est sortie complète.
#let bandeau(numéro) = block(
    width: 100%,
    height: _bandeau-hauteur,
    fill: luma(93%),
    stroke: (bottom: 0.4pt + luma(70%)),
    inset: (x: _marge),
)[
    #set align(horizon)
    #set par(justify: false)
    #grid(
        columns: (1fr, auto),
        column-gutter: 0.6em,
        align: (left + horizon, right + horizon),
        text(size: 9pt, fill: luma(20%), smallcaps(markup(_titre-court))),
        text(size: 8pt, fill: luma(55%))[#numéro],
    )
]

#let case(contenu, numéro: none) = box(
    width: _largeur,
    height: _hauteur,
    // Repère de découpe, assez pâle pour ne pas salir la carte.
    stroke: (paint: luma(75%), thickness: 0.3pt, dash: "dashed"),
    inset: 0pt,
)[
    // Une case vide — la fin d'une planche incomplète — reste vierge : elle
    // part à la poubelle, un bandeau n'y ferait que du bruit.
    #if contenu != none {
        bandeau(numéro)
        block(width: 100%, height: _hauteur - _bandeau-hauteur, inset: _marge)[
            #set align(center + horizon)
            #_ajusté(contenu, _largeur - 2 * _marge, _hauteur - _bandeau-hauteur - 2 * _marge)
        ]
    }
]

// `début` est le rang de la première carte du groupe : le numéro imprimé est
// celui de la carte dans tout le paquet, et il suit la carte au miroir du verso.
#let feuille(groupe, face, début) = grid(
    columns: (_largeur, _largeur),
    rows: (_hauteur, _hauteur),
    ..range(4).map(i => {
        let j = if face == "verso" { _miroir.at(i) } else { i }
        if j < groupe.len() {
            case(rendu-carte(groupe.at(j).at(face)), numéro: début + j + 1)
        } else {
            case(none)
        }
    })
)

#if vide [
    #align(center + horizon, emph[Aucune flashcard dans ce chapitre.])
] else {
    for (n, groupe) in cartes.chunks(4).enumerate() {
        if n > 0 { pagebreak() }
        feuille(groupe, "recto", n * 4)
        pagebreak()
        feuille(groupe, "verso", n * 4)
    }
}
