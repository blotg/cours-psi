// Fiche de notation d'un TP, à remplir à la main pendant la séance : une
// ligne par binôme — un élève seul a la sienne —, la consigne et les critères
// de l'évaluation que sa copie a reçue, une case par critère et le total. Une
// page par groupe : deux groupes tiennent sur une feuille A4 recto-verso.
//
// Alimenté par `outils tp` et `outils notation`, qui passent en
// `--input données` :
//
//     {"titre": "Filtre de Wien", "numéro": 2, "sujet": "/TP/2 - …/TP.typ",
//      "groupes": [{"nom": "1", "binômes": [{"copie": 0, "membres": ["…", "…"]}]}]}
//
// Les binômes sont tirés au sort par l'outil (`TP.binômes`), dans l'ordre des
// copies. Les critères, eux, n'y sont pas : ils portent du content — une
// formule, `$f_0$`, un renvoi à une manipulation —, que `typst query` ne
// restitue qu'avec perte ; les consignes aussi. Le sujet
// est donc inclus à la suite de la fiche (cf. `cours-en-annexe`) et ses
// évaluations lues sur place, d'où `--root` à la racine du dépôt,
// `--input inclus=1` et `--pages`. Quelle évaluation revient à quelle copie :
// la règle de rotation du sujet lui-même, `copie-évaluée`.

#import "@local/prepa:0.1.1": *

#let données = json(bytes(sys.inputs.données))
#let _titre = [TP #données.numéro — #données.titre]

// Ni logotype ni pied : c'est une feuille de travail, pas un document distribué,
// et la place revient aux lignes.
#show: init-document.with(
    titre: "Notation — TP " + str(données.numéro) + " — " + données.titre,
    logotype: false,
    marge: 1cm,
    numérotation: none,
    pied: none,
)
#show: cours-en-annexe.with(include données.sujet)
#set text(size: 10pt)
#set par(justify: false)

#let _gris = luma(40%)
#let _filet-fin = 0.4pt + luma(60%)

// Hauteur d'une case où écrire une note.
#let _case = 12mm

// Les retours à la ligne du sujet sont faits pour sa colonne de barème, pas
// pour ces cases.
#let _critère(critère) = {
    show linebreak: [ ]
    text(size: 8pt, critère)
}

// Rappel de la consigne, en retrait des critères : c'est le sujet qui parle.
#let _consigne(reçues) = {
    set text(size: 8pt, fill: luma(25%), style: "italic")
    set par(spacing: 0.5em)
    set list(spacing: 0.3em)
    reçues.map(e => e.consigne).join(parbreak())
}

#let _sur(points) = text(size: 8pt, fill: _gris)[\/ #points]

#let _total(critères) = if critères != () {
    align(bottom + right, text(fill: _gris)[\/ *#critères.map(c => c.at(1)).sum()*])
}

#let _noms(binôme) = table.cell(align: horizon, text(size: 9pt, binôme.membres.join(linebreak())))

// Les évaluations qu'une copie a reçues : une seule en général, plus celles
// qui échappent à la rotation. Leurs critères se mettent bout à bout.
#let _reçues(copie, évaluations, total) = if total == 0 { () } else {
    évaluations.filter(e => copie-évaluée(copie, e.début, e.nombre, total, rotation: e.rotation))
}
#let _critères(reçues) = reçues.map(e => e.barème).fold((), (a, b) => a + b)

// Tout le groupe a reçu la même évaluation : consigne et critères passent en
// tête du tableau, une fois pour toutes, et chaque ligne n'a plus que ses cases.
#let _grille-commune(binômes, reçues) = {
    let critères = _critères(reçues)
    table(
        columns: (44mm, ..(1fr,) * critères.len(), 14mm),
        stroke: 0.5pt,
        inset: 5pt,
        table.header(
            table.cell(colspan: critères.len() + 2, _consigne(reçues)),
            [], ..critères.map(((critère, _)) => _critère(critère)), [],
        ),
        ..binômes
            .map(b => (
                _noms(b),
                ..critères.map(((_, points)) => block(
                    width: 100%,
                    height: _case - 10pt,
                    align(bottom + right, _sur(points)),
                )),
                _total(critères),
            ))
            .flatten(),
    )
}

// Les évaluations tournent d'un binôme à l'autre : chaque ligne porte sa
// propre consigne et ses propres critères, une case sous chacun.
#let _grille-par-binôme(binômes, reçues-de) = table(
    columns: (44mm, 1fr, 14mm),
    stroke: 0.5pt,
    inset: 5pt,
    ..binômes
        .map(b => {
            let reçues = reçues-de(b)
            let critères = _critères(reçues)
            (
                _noms(b),
                table.cell(inset: 0pt, grid(
                    columns: (1fr,) * calc.max(1, critères.len()),
                    rows: (auto, auto, _case),
                    inset: (x: 4pt, y: 3pt),
                    stroke: (x, y) => (left: if x > 0 { _filet-fin }, top: if y > 0 { _filet-fin }),
                    grid.cell(colspan: calc.max(1, critères.len()), _consigne(reçues)),
                    ..if critères == () {
                        (text(size: 8pt, fill: _gris, emph[sans barème]),)
                    } else {
                        (
                            ..critères.map(((critère, _)) => _critère(critère)),
                            ..critères.map(((_, points)) => align(bottom + right, _sur(points))),
                        )
                    },
                )),
                _total(critères),
            )
        })
        .flatten(),
)

#context {
    let évaluations = query(<évaluation>).map(m => m.value)
    let total = i-évaluation.final().first()
    let reçues = b => _reçues(b.copie, évaluations, total)
    for (i, groupe) in données.groupes.enumerate() {
        if i > 0 { pagebreak() }
        grid(
            columns: (1fr, auto),
            text(size: 12pt, strong(_titre)), text(size: 12pt)[Groupe #groupe.nom],
        )
        v(0.4em)
        let binômes = groupe.binômes
        // Une évaluation se reconnait à son premier créneau.
        let communes = binômes.map(b => reçues(b).map(e => e.début)).dedup().len() == 1
        if communes and _critères(reçues(binômes.first())) != () {
            _grille-commune(binômes, reçues(binômes.first()))
        } else {
            _grille-par-binôme(binômes, reçues)
        }
    }
}
