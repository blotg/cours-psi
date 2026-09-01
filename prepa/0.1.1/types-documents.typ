#let init-document(titre: "", doc) = {
    set document(title: titre)
    set text(font: "New Computer Modern", lang: "fr")
    show raw: set text(font: "New Computer Modern Mono")
    import "format.typ": numérote-code
    show raw.where(block: true): numérote-code
    set par(justify: true)
    set text(size: 11pt)
    set page(
        paper: "a4",
        margin: (x: 1cm, top: 1cm, bottom: 2cm),
        numbering: "1",
        footer-descent: 50%,
    )
    show link: underline
    import "lib.typ": *
    set-round(mode: "figures")
    show: styles-blocs
    doc
}

#let checkbox = text(font: "D050000L", "o")

#let lien-cahier-entrainement(numéro-exo, classe: "PSI") = {
    numéro-exo = str(numéro-exo)
    if classe == "PSI" {
        return (
            "https://raw.githubusercontent.com/colasbd/colasbd.github.io/master/cde-2/CdE_PC_2_PSI.pdf#counterForSheet."
                + numéro-exo.split(".").first()
        )
    } else if classe == "PCSI" {
        return (
            "https://raw.githubusercontent.com/colasbd/colasbd.github.io/master/cde/cahier_d_entrainement_PC_1.2.4.pdf#counterForSheet."
                + numéro-exo.split(".").first()
        )
    } else {
        return ""
    }
}

#let full-poly(infos: (:), doc) = {
    let titre = infos.at("titre", default: "")
    let révisions-sup = infos.at("révisions-sup", default: ())
    let cahier-entrainement = infos.at("cahier-entrainement", default: ())
    let cahier-entrainement-sup = infos.at("cahier-entrainement-sup", default: ())
    let DM = infos.at("DM", default: ())
    show: init-document.with(titre: titre)
    state("racine").update("full-poly")
    show <compétences>: it => {
        set list(marker: checkbox)
        [= Compétences]
        it
        if query(<question-de-colle>).len() > 0 {
            [= Questions de cours des interrogations orales]
            for q in query(<question-de-colle>) {
                [
                    #import "symboles.typ" as symboles
                    - #eval(q.value, mode: "markup", scope: dictionary(symboles))
                ]
            }
        }
        if cahier-entrainement != none and cahier-entrainement.len() > 0 {
            [= Entrainements]
            grid(
                columns: 10,
                row-gutter: 1em,
                column-gutter: 1fr,
                ..cahier-entrainement.map(
                    ex => [
                        #checkbox #link(lien-cahier-entrainement(ex, classe: "PSI"), [#ex])
                    ],
                )
            )
        }
        if query(<titre-exercice>).len() > 0 {
            [= Exercices]
            context {
                let exercices = query(<titre-exercice>)
                grid(
                    columns: 6,
                    row-gutter: 1em,
                    column-gutter: 1fr,
                    ..exercices
                        .enumerate(start: 1)
                        .map(
                            ((i, exo)) => [
                                #checkbox #link(exo.location(), [Exercice #i])
                            ],
                        )
                )
            }
        }
        if DM != none and DM.len() > 0 {
            [= Devoirs maison]
            grid(
                columns: 5,
                row-gutter: 1em,
                column-gutter: 1fr,
                ..DM
                    .enumerate(start: 1)
                    .map(
                        ((i, d)) => [
                            #checkbox DM #i
                        ],
                    )
            )
        }
        if révisions-sup != none and révisions-sup.len() > 0 {
            [= Révisions de PCSI]
            grid(
                columns: 5,
                row-gutter: 1em,
                column-gutter: 1fr,
                ..révisions-sup.map(
                    ex => [
                        #checkbox #ex
                    ],
                )
            )
        }
        if cahier-entrainement-sup != none and cahier-entrainement-sup.len() > 0 {
            [= Entrainements de PCSI]
            grid(
                columns: 15,
                row-gutter: 1em,
                column-gutter: 1fr,
                ..cahier-entrainement-sup.map(
                    ex => [
                        #checkbox #link(lien-cahier-entrainement(ex, classe: "PCSI"), [#ex])
                    ],
                )
            )
        }
    }
    show <cours>: it => {
        show <titre>: it => {}
        set heading(offset: 1, numbering: (first, ..other) => numbering("1.", ..other))
        it
    }
    show <méthodes>: it => {
        if it != [] {
            [= Méthodes]
            counter(heading).update(0)
            set heading(offset: 1, numbering: (first, ..other) => numbering("1.", ..other))
            it
            pagebreak()
        }
    }
    show <TD>: it => {
        [= Exercices]
        counter(heading).update(0)
        set heading(offset: 1, numbering: (first, ..other) => numbering("1.", ..other))
        show <correction>: it => {}
        it
    }
    context [#metadata(here().page()) <première-page>]
    align(center, text(17pt)[*#titre*])
    doc
    context [#metadata(here().page()) <dernière-page>]
}

#let TD(infos: (:), avec-corrigé: true, doc) = {
    let titre = infos.at("titre", default: "")
    let révisions-sup = infos.at("révisions-sup", default: ())
    let cahier-entrainement = infos.at("cahier-entrainement", default: ())
    let cahier-entrainement-sup = infos.at("cahier-entrainement-sup", default: ())
    context if state("racine").get() != "full-poly" {
        set heading(numbering: "1.")
        show: init-document.with(titre: titre)
        [*#align(center, text(17pt)[#titre TD])* <titre>]
        show <correction>: it => if avec-corrigé { it } else {}
        doc
    } else {
        doc
    }
}

#let cours(infos: (:), doc) = {
    let titre = infos.at("titre", default: "")
    let révisions-sup = infos.at("révisions-sup", default: ())
    let cahier-entrainement = infos.at("cahier-entrainement", default: ())
    let cahier-entrainement-sup = infos.at("cahier-entrainement-sup", default: ())
    show: init-document.with(titre: titre)
    show: it => {
        set heading(offset: 1, numbering: (first, ..other) => numbering("1.", ..other))
        it
    }
    [*#align(center, text(17pt)[#titre])* <titre>]
    text(size: 17pt, [*Résumé du cours*])
    context [#metadata(here().page()) <première-page-cours>]
    doc
    context [#metadata(here().page()) <dernière-page-cours>]
}

#let programme-de-colle(date: datetime.today(), doc) = {
    show: init-document.with(titre: "Programme de colle")
    [*#align(center, text(17pt)[Programme de colle de la semaine du #date.display("[day]/[month]/[year]")])* <titre>]
    doc
}

#let TP(numéro: none, titre: none, date: datetime.today(), doc) = {
    let titre-doc = "TP"
    if numéro != none {
        titre-doc = titre-doc + [ #numéro]
    }
    if titre != none {
        titre-doc = titre-doc + [ #sym.dash #titre]
    }
    show: init-document.with(titre: titre)
    show: it => {
        set heading(numbering: "1.")
        it
    }
    if "élève" in sys.inputs [
        #set align(right)
        *#sys.inputs.at("élève")*
        #if "binôme" in sys.inputs [
            (avec #sys.inputs.at("binôme"))
        ]
    ]

    [*#align(center, text(17pt)[#titre-doc])* <titre>]
    doc
}

#let évaluation-TP(doc) = {
    set document(title: "Évaluation des TP")
    set text(font: "New Computer Modern", lang: "fr")
    show raw: set text(font: "New Computer Modern Mono")
    set par(justify: true)
    set text(size: 10pt)
    set page(
        paper: "a5",
        margin: (x: 1cm, top: 1cm, bottom: 1cm),
        numbering: none,
    )
    show link: underline
    show heading: set text(size: 12pt)
    align(center, text(size: 15pt, [*Évaluation du compte-rendu*]))
    doc
}
