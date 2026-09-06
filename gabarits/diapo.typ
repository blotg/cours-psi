// Diaporama des questions de début de cours d'un chapitre.
//
// Une question par diapo, sous forme de QCM ; la dernière diapo porte le
// corrigé, toutes les réponses ensemble.
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

#let données = json(bytes(sys.inputs.données))
#let questions = données.at("questions", default: ())

#let _gris = luma(45%)
#let _pâle = luma(70%)

// -- Tirage déterministe ---------------------------------------------------

// Hachage polynomial du texte de la question (même procédé que `entourage`
// dans le paquet) : pas d'aléa d'horloge, la compilation reste reproductible.
#let _graine(texte) = {
    let n = 7
    for octet in array(bytes(texte)) {
        n = calc.rem(n * 31 + octet, 2147483647)
    }
    n
}

// Fisher-Yates piloté par un générateur congruentiel linéaire. Les constantes
// sont celles de `glibc` ; le produit reste très en deçà de la capacité d'un
// entier typst (64 bits).
//
// On tire l'indice des bits de POIDS FORT : dans un générateur congruentiel de
// module une puissance de deux, le bit de poids faible a une période de 2, et
// `calc.rem(n, 2)` sur une question à deux réponses ne mélangerait rien.
#let _mélange(liste, graine) = {
    let restant = liste
    let n = graine
    let tiré = ()
    while restant.len() > 0 {
        n = calc.rem(n * 1103515245 + 12345, 2147483648)
        let i = calc.rem(int(n / 65536), restant.len())
        tiré.push(restant.at(i))
        let _ = restant.remove(i)
    }
    tiré
}

#let _lettre(i) = str.from-unicode(str.to-unicode("A") + i)

// Pour chaque question : les réponses dans l'ordre d'affichage, et la lettre
// qui porte la bonne (celle d'indice 0 dans la source).
#let _tirées = questions.map(q => {
    let réponses = q.at("réponses", default: ())
    let ordre = _mélange(range(réponses.len()), _graine(q.at("énoncé", default: "")))
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

// Un `set align(horizon)` ne centrerait pas : le contenu d'une page s'écoule
// depuis le haut. Ce sont les deux ressorts qui répartissent le blanc.
#let _diapo(contenu) = {
    v(1fr)
    block(width: 100%, contenu)
    v(1fr)
}

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

#for (i, q) in _tirées.enumerate() {
    pagebreak()
    _diapo[
        #text(size: 15pt, fill: _pâle)[Question #(i + 1) / #_tirées.len()]
        #v(0.2em)
        #block(width: 100%, below: 1.2em, text(size: 24pt, weight: "bold", markup(q.énoncé)))
        #grid(
            columns: (auto, 1fr),
            column-gutter: 0.7em,
            row-gutter: 0.8em,
            ..q.réponses
                .enumerate()
                .map(((j, r)) => (text(fill: _gris, weight: "bold")[#_lettre(j).], markup(r)))
                .flatten()
        )
    ]
}

// -- Diapo de corrigé ------------------------------------------------------

#if _tirées.len() > 0 {
    pagebreak()
    _diapo[
        #set align(center + horizon)
        #text(size: 26pt, weight: "bold")[Réponses]
        #v(1em)
        // Au plus six colonnes, et jamais plus de colonnes que de questions :
        // une grille de deux entrées ne s'étale pas sur toute la largeur.
        #let colonnes = calc.min(6, _tirées.len())
        #grid(
            columns: colonnes,
            column-gutter: 1.6em,
            row-gutter: 1em,
            .._tirées
                .enumerate()
                .map(((i, q)) => box(inset: (x: 0.5em, y: 0.35em), radius: 3pt, fill: luma(93%))[
                    #text(fill: _gris)[#(i + 1)] #h(0.35em) #text(weight: "bold", size: 24pt, q.bonne)
                ])
        )
    ]
}
