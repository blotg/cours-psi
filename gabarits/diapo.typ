// Diaporama des questions de début de cours d'un chapitre.
//
// Une question par diapo, sous forme de QCM ; puis le corrigé, qui reprend
// les mêmes diapos dans le même ordre, la bonne réponse en gras.
//
// Alimenté par `outils diapo`, qui passe en `--input données` le JSON produit
// par `typst query <question-de-début-de-cours>` sur le cours, augmenté du
// titre du chapitre :
//
//     {"titre": "...", "questions": [{"énoncé": "...", "réponses": [...]}]}
//
// La **première réponse est la bonne** dans la source ; l'ordre d'affichage
// est tiré au sort ici. Le tirage est déterministe — il ne dépend que du texte
// de la question — pour qu'une recompilation redonne la même diapo, et donc le
// même corrigé, que le fichier ait été régénéré ou non.

#import "@local/prepa:0.1.1": *
#import "@preview/suiji:0.4.0": gen-rng-f, shuffle-f

#let données = json(bytes(sys.inputs.données))
#let questions = données.at("questions", default: ())

#let _gris = luma(45%)
#let _pâle = luma(70%)

// -- Tirage déterministe ---------------------------------------------------

// L'ordre d'affichage des réponses est tiré au sort par suiji, à partir d'une
// graine qui ne dépend que du texte de la question (`graine-du-texte`, dans le
// paquet). Pas d'aléa d'horloge, donc : recompiler le diaporama redonne le même
// ordre, et donc le même corrigé, que le fichier ait bougé ou non.

#let _lettre(i) = str.from-unicode(str.to-unicode("A") + i)

// Pour chaque question : les réponses dans l'ordre d'affichage, et la lettre
// qui porte la bonne (celle d'indice 0 dans la source).
#let _tirées = questions.map(q => {
    let réponses = q.at("réponses", default: ())
    let (_, ordre) = shuffle-f(
        gen-rng-f(graine-du-texte(q.at("énoncé", default: ""))),
        range(réponses.len()),
    )
    (
        énoncé: q.at("énoncé", default: ""),
        réponses: ordre.map(i => réponses.at(i)),
        bonne: _lettre(ordre.position(i => i == 0)),
    )
})

// -- Mise en page ----------------------------------------------------------

#show: init-document.with(
    titre: "Questions de début de cours — " + données.titre.replace("\n", " : "),
    format: "presentation-16-9",
    marge: (x: 2cm, top: 1.6cm, bottom: 1.4cm),
    logotype: false,
    numérotation: none,
    // Le pied commun porte le logotype et la mention de licence, dimensionnés
    // pour une page A4 de poly. Sur un écran projeté, ce serait du bruit : on
    // ne garde que de quoi se repérer dans la série.
    pied: context {
        set text(size: 12pt, fill: _pâle)
        if counter(page).get().first() > 1 {
            grid(
                columns: (1fr, auto),
                align: (left + horizon, right + horizon),
                markup(données.titre.replace("\n", " : ")),
                counter(page).display("1"),
            )
        }
    },
)

#set text(size: 20pt)
#set par(justify: false, leading: 0.85em)

// En style « inline », typst tasse les fractions : sur un écran de deux mètres
// le dénominateur devient illisible. On force le style d'affichage — une diapo
// ne porte que quelques lignes, l'interligne peut se le permettre.
#show math.equation.where(block: false): math.display

// `layout` donne la place réellement disponible sur la page ; un bloc de cette
// hauteur exacte permet ensuite de centrer verticalement (le contenu d'une page
// s'écoule depuis le haut, un `set align(horizon)` seul ne centrerait rien).
//
// Une diapo qui déborde se couperait en deux pages : la numérotation des
// questions ne suivrait plus le corrigé, et la moitié des réponses passerait à
// l'écran suivant. On rétrécit donc le contenu jusqu'à ce qu'il tienne — quatre
// matrices 3 × 3 de dérivées partielles ne rentrent pas à pleine taille.
#let _diapo(contenu) = layout(dispo => {
    let facteur = 1.0
    while (
        facteur > 0.5
            and measure(box(width: dispo.width, text(size: facteur * 1em, contenu))).height > dispo.height
    ) {
        facteur -= 0.05
    }
    block(width: 100%, height: dispo.height, align(horizon, text(size: facteur * 1em, contenu)))
})

// -- Diapo de titre --------------------------------------------------------

#_diapo[
    #set align(center + horizon)
    #text(size: 34pt, weight: "bold", markup(données.titre))
    #v(0.6em)
    #text(size: 22pt, fill: _gris)[Questions de début de cours]
    #v(0.4em)
    #text(size: 18pt, fill: _pâle)[#questions.len() question#if questions.len() > 1 [s]]
]

// -- Une diapo par question ------------------------------------------------

// `strong` épaissit bien le texte d'une réponse, mais pas les symboles d'une
// formule : le gras des maths se demande à `math.bold`. Une réponse tout en
// maths — « $2 pi$ » — resterait sinon identique aux autres.
#let _gras(contenu) = {
    show math.equation: math.bold
    strong(contenu)
}

// Énoncé et réponses dans l'ordre tiré. Au corrigé, la même diapo revient à
// l'identique — l'énoncé reste sous les yeux pendant qu'on commente —, la
// bonne réponse seule passant en gras noir.
#let _qcm(i, q, corrigé: false) = [
    #text(size: 15pt, fill: _pâle)[#if corrigé [Réponse] else [Question] #(i + 1) / #_tirées.len()]
    #v(0.2em)
    #block(width: 100%, below: 1.2em, text(size: 24pt, weight: "bold", markup(q.énoncé)))
    #grid(
        columns: (auto, 1fr),
        column-gutter: 0.7em,
        row-gutter: 0.8em,
        ..q.réponses
            .enumerate()
            .map(((j, r)) => {
                let bonne = corrigé and _lettre(j) == q.bonne
                (
                    text(fill: if bonne { black } else { _gris }, weight: "bold")[#_lettre(j).],
                    if bonne { _gras(markup(r)) } else { markup(r) },
                )
            })
            .flatten()
    )
]

#for (i, q) in _tirées.enumerate() {
    pagebreak()
    _diapo(_qcm(i, q))
}

// -- Diapos de corrigé -----------------------------------------------------

#for (i, q) in _tirées.enumerate() {
    pagebreak()
    _diapo(_qcm(i, q, corrigé: true))
}
