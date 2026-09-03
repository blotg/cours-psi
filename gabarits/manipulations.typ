// Liste des manipulations d'un chapitre, pour préparer la paillasse.
//
// Alimenté par `outils manipulations`, qui passe en `--input données` le JSON
// produit par `typst query <manipulation>` sur le cours, augmenté du titre du
// chapitre :
//
//     {"titre": "...", "manipulations": [{"titre": "...", "matériel": [...]}]}

#import "@local/prepa:0.1.1": *

#let données = json(bytes(sys.inputs.données))
#let manipulations = données.at("manipulations", default: ())

// La page vient d'init-document et n'est surtout pas redéfinie ici : changer
// la marge après coup ouvre une nouvelle page, et le logotype resterait seul
// sur la première.
#show: init-document.with(titre: "Manipulations — " + données.titre)

#set par(justify: true)

#align(center)[
    #text(size: 1.4em, weight: "bold")[Manipulations]
    #linebreak()
    #text(size: 1.1em, fill: luma(35%))[#données.titre]
]
#v(1em)

#if manipulations.len() == 0 [
    #align(center, emph(text(fill: luma(35%))[Aucune manipulation dans ce chapitre.]))
] else [
    #table(
        columns: (auto, 1fr, 1.2fr),
        align: (right + top, left + top, left + top),
        stroke: (x, y) => if y == 0 { (bottom: 0.6pt) } else { (bottom: 0.3pt + luma(80%)) },
        inset: (x: 0.6em, y: 0.7em),
        table.header([], strong[Manipulation], strong[Matériel]),
        ..manipulations
            .enumerate()
            .map(((i, m)) => (
                [#(i + 1)],
                if m.titre == "" { emph(text(fill: luma(45%))[sans titre]) } else { m.titre },
                if m.at("matériel", default: ()).len() == 0 {
                    text(fill: luma(60%))[—]
                } else {
                    list(tight: true, ..m.matériel)
                },
            ))
            .flatten(),
    )

    // Récapitulatif : chaque référence une seule fois, dans l'ordre
    // d'apparition, pour sortir le matériel de l'armoire en une fois.
    #let tout = manipulations.map(m => m.at("matériel", default: ())).flatten().dedup()
    #if tout.len() > 0 [
        #v(1.5em)
        #strong[Matériel à sortir]
        #columns(2, list(tight: true, ..tout))
    ]
]
