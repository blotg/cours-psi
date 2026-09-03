// Pied de page commun à tous les documents : identité de l'établissement,
// licence du contenu, numéro de page.
//
// Le logo appartient au lycée : il identifie le document, il n'est pas couvert
// par la licence CC BY-NC qui s'applique au contenu (cf. LICENCE.md). D'où la
// séparation visuelle entre le bloc de gauche et la mention de licence.
#let pied-de-page = context {
    set text(size: 7.5pt, fill: luma(45%))
    // init-document souligne les liens ; dans un pied de page c'est du bruit.
    show underline: it => it.body
    // Colonnes latérales de même largeur : le numéro tombe au milieu de la
    // page, et non au milieu de ce qui reste entre les deux mentions.
    grid(
        columns: (1fr, auto, 1fr),
        align: (left + horizon, center + horizon, right + horizon),
        image("logos/Logo noir.svg", height: 8mm),
        // Un document sans numérotation (la fiche d'évaluation) garde un
        // pied de page, mais sans numéro.
        if page.numbering != none { counter(page).display() },
        link("https://creativecommons.org/licenses/by-nc/4.0/deed.fr")[CC BY-NC 4.0],
    )
}

// cours.typ et TD.typ se compilent seuls ou inclus dans le poly. Inclus,
// c'est le poly qui met le document en place : ils ne doivent alors poser ni
// page, ni titre, ni logotype. Ce garde l'évite en amont — plutôt que de
// laisser init-document s'appliquer deux fois et de masquer après coup ce qui
// en déborde, ce qui obligeait à tenir une liste d'étiquettes à jour.
#let inclus-dans-le-poly() = state("racine").get() == "full-poly"

// `logotype` : bandeau d'en-tête sur la première page. À couper pour les
// documents qui ne sont pas des feuilles de cours — la planche de
// flashcards, les pages quadrillées — où il tomberait au travers.
// C'est ICI, et nulle part ailleurs, que la page se règle.
//
// Un `set page` posé après coup par un document coupe la page dès qu'il change
// un réglage : le contenu repart alors sur une nouvelle feuille, en laissant
// la première à moitié vide. Le piège a coûté trois bugs — les deux sauts de
// page fantômes autour du résumé dans le poly, et la page blanche en tête de
// la liste des manipulations. D'où ces paramètres : un document qui veut une
// autre page la demande, il ne l'écrase pas.
#let init-document(
    titre: "",
    logotype: true,
    format: "a4",
    marge: (x: 1cm, top: 1cm, bottom: 2cm),
    numérotation: "1",
    fond: none,
    pied: auto, // auto : le pied commun ; none : aucun ; sinon, le contenu donné
    doc,
) = {
    set document(title: titre)
    set text(font: "New Computer Modern", lang: "fr")
    show raw: set text(font: "New Computer Modern Mono")
    import "format.typ": numérote-code
    show raw.where(block: true): numérote-code
    set par(justify: true)
    set text(size: 11pt)
    set page(
        paper: format,
        margin: marge,
        numbering: numérotation,
        background: fond,
        footer-descent: 40%,
        footer: if pied == auto { pied-de-page } else { pied },
    )
    show link: underline
    import "lib.typ": *
    set-round(mode: "figures")
    show: styles-blocs
    if logotype {
        let largeur = 30mm
        let hauteur = largeur * 592.873 / 969.344 // proportions du SVG
        let montée = 8mm // ce dont il déborde dans la marge haute (10 mm)

        // Le logotype est placé, donc hors du flux : il ne prend que la
        // hauteur explicitement réservée ci-dessous, et le titre remonte
        // d'autant. Les titres les plus longs occupent toute la largeur sur
        // deux lignes : le logotype ne peut pas se mettre à côté d'eux.
        block[
            #place(top + left, dy: -montée, image("logos/Logotype noir.svg", width: largeur))
            #v(hauteur - montée)
        ]
    }
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
        // Le résumé du cours est isolé entre deux sauts de page. C'était
        // jusqu'ici un effet de bord : cours.typ réappliquait init-document,
        // dont le `set page` coupait la page à l'entrée comme à la sortie de
        // sa portée. Le garde ayant supprimé cette double application, les
        // deux coupures deviennent explicites.
        //
        // Celle de sortie est ici, et non au début de <méthodes>, parce que
        // <méthodes> ne produit rien quand méthodes.typ est vide : la section
        // Exercices perdrait alors son début de page.
        pagebreak(weak: true)
        set heading(offset: 1, numbering: (first, ..other) => numbering("1.", ..other))
        it
        pagebreak(weak: true)
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
    context if inclus-dans-le-poly() {
        doc
    } else {
        show: init-document.with(titre: titre)
        set heading(numbering: "1.")
        show <correction>: it => if avec-corrigé { it } else {}
        align(center, text(17pt)[*#titre TD*])
        doc
    }
}

#let cours(infos: (:), doc) = {
    let titre = infos.at("titre", default: "")
    let corps = {
        text(size: 17pt, [*Résumé du cours*])
        context [#metadata(here().page()) <première-page-cours>]
        doc
        context [#metadata(here().page()) <dernière-page-cours>]
    }
    context if inclus-dans-le-poly() {
        corps
    } else {
        show: init-document.with(titre: titre)
        set heading(offset: 1, numbering: (first, ..other) => numbering("1.", ..other))
        align(center, text(17pt)[*#titre*])
        corps
    }
}

#let programme-de-colle(date: datetime.today(), doc) = {
    show: init-document.with(titre: "Programme de colle")
    align(center, text(17pt)[*Programme de colle de la semaine du #date.display("[day]/[month]/[year]")*])
    doc
}

#let TP(numéro: none, titre: none, date: datetime.today(), liste-élèves: none, doc) = {
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

    align(center, text(17pt)[*#titre-doc*])
    doc
}

// Feuille A5 à coller dans le cahier de laboratoire : pas de numéro de page,
// et pas de logotype — le pied porte déjà le logo, et la place est comptée.
#let évaluation-TP(doc) = {
    show: init-document.with(
        titre: "Évaluation des TP",
        logotype: false,
        format: "a5",
        marge: (x: 1cm, top: 1cm, bottom: 1.4cm),
        numérotation: none,
    )
    set text(size: 10pt)
    show heading: set text(size: 12pt)
    align(center, text(size: 15pt, [*Évaluation du compte-rendu*]))
    doc
}
