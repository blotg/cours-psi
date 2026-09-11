// Propositions pour le format des blocs `lien` — document de travail.
//
// Contrainte posée : garder le texte du lien, le QR code et le lien cliquable,
// mais prendre moins de place que l'actuel.
//
// Rien ici n'est branché sur le cours : c'est un banc d'essai. La variante
// retenue ira remplacer `lien()` dans `prepa/0.1.1/blocks.typ`.
//
//     typst compile essais/liens/propositions.typ

#import "@local/prepa:0.1.1": *
#import "@preview/tiaoma:0.3.0": qrcode

#show: init-document.with(titre: "Format des liens — propositions")

#let _gris = luma(35%)
#let _pâle = luma(60%)

// Les deux extrêmes du corpus : un lien court et le plus long du cours.
#let COURT = "https://youtu.be/eD7LdS6bfOQ"
#let LONG = "https://upload.wikimedia.org/wikipedia/commons/c/c1/Wave_packet_%28no_dispersion%29.gif"

// =========================================================================
//  Les variantes
// =========================================================================

// 0. L'actuel, pour comparaison : bloc centré de 5 cm, QR à sa taille propre
//    (~3 cm), URL en 6 pt dessous.
#let lien-actuel(url) = align(center, block(width: 5cm)[
    #link(url, qrcode(url))
    #text(size: 6pt, url)
])

// 1. Ligne — QR de 11 mm à gauche, URL à côté, le tout sur une ligne.
#let lien-ligne(url) = block(above: 0.7em, below: 0.7em, grid(
    columns: (auto, 1fr),
    column-gutter: 0.7em,
    align: (top, horizon),
    link(url, qrcode(url, height: 11mm)),
    link(url, text(size: 7.5pt, fill: _gris, url)),
))

// 2. Ligne encadrée — la même, posée dans un liseré pleine largeur : le lien
//    se repère au feuilletage sans peser plus lourd.
#let lien-encadré(url) = block(
    above: 0.7em,
    below: 0.7em,
    width: 100%,
    radius: 3pt,
    stroke: 0.5pt + luma(75%),
    fill: luma(97%),
    inset: (x: 0.6em, y: 0.45em),
    grid(
        columns: (auto, 1fr),
        column-gutter: 0.7em,
        align: (top, horizon),
        link(url, qrcode(url, height: 10mm)),
        link(url, text(size: 7.5pt, fill: _gris, url)),
    ),
)

// 3. Inline — le QR descend à la taille d'une lettre haute et reste dans le
//    fil du texte. Encombrement vertical nul : la ligne s'écarte à peine.
#let lien-inline(url) = [#box(baseline: 30%, link(url, qrcode(url, height: 5.5mm)))#h(0.3em)#link(
    url,
    text(size: 7pt, fill: _gris, url),
)]

// 4. Compact centré — la disposition d'aujourd'hui, resserrée : QR de 13 mm et
//    URL à côté plutôt que dessous, l'ensemble centré et large de 9 cm.
#let lien-compact(url) = align(center, block(width: 11cm, grid(
    // `auto` et non `1fr` : sur un lien court, une colonne souple écarterait le
    // QR de son URL de toute la largeur du bloc.
    columns: (auto, auto),
    column-gutter: 0.7em,
    align: (top, horizon),
    link(url, qrcode(url, height: 13mm)),
    box(width: 8cm, link(url, text(size: 7.5pt, fill: _gris, url))),
)))

// =========================================================================
//  Présentation
// =========================================================================

#let VARIANTES = (
    ("0 — actuel", lien-actuel, [Bloc centré de 5 cm : QR à sa taille native, URL en 6 pt dessous. C'est le point de comparaison.]),
    ("1 — ligne", lien-ligne, [QR de 11 mm à gauche, URL à côté. Dans le flux, aligné sur la marge comme un paragraphe.]),
    ("2 — ligne encadrée", lien-encadré, [La même, dans un liseré pleine largeur : se repère au feuilletage, coûte deux filets de plus.]),
    ("3 — inline", lien-inline, [QR à hauteur de lettre, dans le fil du texte. Le moins encombrant ; le QR devient petit à scanner.]),
    ("4 — compact centré", lien-compact, [La disposition actuelle resserrée : QR à côté de l'URL plutôt qu'au-dessus.]),
)

#let TEXTE = [Le paragraphe qui précède sert à voir ce que la variante prend dans la colonne. Il est là pour ça, et pour rien d'autre.]

#titre-document[Format des liens — propositions]

#align(center, text(fill: _gris)[
    Garder le texte du lien, le QR code et le lien cliquable, en prenant moins de place.
])
#v(1em)

Chaque variante est montrée deux fois : avec le lien le plus court du cours
(#raw(COURT)) et avec le plus long (une image Wikimedia, #COURT.len() contre
#LONG.len() caractères). La hauteur annoncée est celle du bloc mesurée par
typst, lien long — c'est elle qui décide.

#v(0.5em)

// Idée écartée : poser le QR dans la marge, hors du flux. Les marges du poly
// font 1 cm (cf. `init-document`) : le QR y toucherait le bord de la feuille,
// et la plupart des imprimantes le rogneraient.
#block(
    width: 100%,
    inset: (x: 0.8em, y: 0.5em),
    radius: 3pt,
    fill: luma(95%),
    text(size: 9pt, fill: _gris)[
        *Écartée d'avance :* le QR dans la marge. Les marges du poly font 1 cm ;
        le code y toucherait le bord de la feuille et sortirait rogné à
        l'impression.
    ],
)

#for (nom, fonction, note) in VARIANTES {
    block(sticky: true, above: 1.6em, below: 0.6em)[
        #text(size: 12.5pt, weight: "bold", nom)
        #v(-0.5em)
        #line(length: 100%, stroke: 0.5pt + luma(80%))
    ]
    block(below: 0.8em, text(size: 9.5pt, fill: _gris, note))

    context {
        let h = measure(block(width: 16cm, fonction(LONG))).height
        block(below: 0.6em, text(size: 8.5pt, fill: _pâle)[
            hauteur (lien long) : #calc.round(h.mm(), digits: 1) mm
        ])
    }

    block(below: 0.3em, text(size: 8.5pt, fill: _pâle, smallcaps[lien court]))
    TEXTE
    fonction(COURT)
    TEXTE

    v(0.8em)
    block(below: 0.3em, text(size: 8.5pt, fill: _pâle, smallcaps[lien long]))
    TEXTE
    fonction(LONG)
    TEXTE
}

// =========================================================================
//  Lisibilité : à quelle taille le QR se scanne-t-il encore ?
// =========================================================================
//
// C'est la seule question qui tranche vraiment entre les variantes, et elle ne
// se règle pas au jugé : plus l'URL est longue, plus le QR porte de modules, et
// plus il faut de millimètres pour que chacun reste imprimable. Le lien long du
// cours en porte assez pour que 6 mm ne suffisent plus.
//
// À vérifier au téléphone, sur la planche IMPRIMÉE — pas à l'écran, où tout
// passe.

#pagebreak()

#block(sticky: true, above: 0pt, below: 0.6em)[
    #text(size: 12.5pt, weight: "bold")[Jusqu'où peut-on descendre ?]
    #v(-0.5em)
    #line(length: 100%, stroke: 0.5pt + luma(80%))
]

Le même lien long, aux tailles des variantes ci-dessus. À scanner *sur la
feuille imprimée*, pas à l'écran : c'est l'impression qui décide, et c'est elle
qui manque quand un QR ne passe pas.

#v(0.8em)

#grid(
    columns: (1fr,) * 5,
    column-gutter: 0.5em,
    align: center + bottom,
    ..(5.5mm, 8mm, 10mm, 11mm, 13mm).map(t => link(LONG, qrcode(LONG, height: t)))
)
#v(0.4em)
#grid(
    columns: (1fr,) * 5,
    column-gutter: 0.5em,
    align: center + top,
    ..(
        [5,5 mm #linebreak() #text(fill: _pâle)[variante 3]],
        [8 mm],
        [10 mm #linebreak() #text(fill: _pâle)[variante 2]],
        [11 mm #linebreak() #text(fill: _pâle)[variante 1]],
        [13 mm #linebreak() #text(fill: _pâle)[variante 4]],
    ).map(l => text(size: 8.5pt, fill: _gris, l))
)

#v(1.2em)

Et le lien court, pour situer : à nombre de modules plus faible, chaque module
occupe plus de place, donc il se scanne encore là où le long ne passe plus.

#v(0.8em)

#grid(
    columns: (1fr,) * 5,
    column-gutter: 0.5em,
    align: center + bottom,
    ..(5.5mm, 8mm, 10mm, 11mm, 13mm).map(t => link(COURT, qrcode(COURT, height: t)))
)
