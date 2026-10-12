// Pied de page commun à tous les documents : identité de l'établissement,
// licence du contenu, numéro de page.
//
// Le logo appartient au lycée : il identifie le document, il n'est pas couvert
// par la licence CC BY-NC qui s'applique au contenu (cf. LICENCE.md). D'où la
// séparation visuelle entre le bloc de gauche et la mention de licence.
#import "helper-functions.typ": markup
#import "@preview/ccicons:1.0.1": *
#import "@preview/zero:0.6.1": set-num, set-round
#import "@preview/tiaoma:0.3.0": qrcode
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
        {
            set text(size: 12pt)
            link("https://creativecommons.org/licenses/by-nc/4.0/deed.fr")[#cc-by-nc]
        },
    )
}

// cours.typ et TD.typ se compilent seuls ou inclus dans le poly. Inclus,
// c'est le poly qui met le document en place : ils ne doivent alors poser ni
// page, ni titre, ni logotype. Ce garde l'évite en amont — plutôt que de
// laisser init-document s'appliquer deux fois et de masquer après coup ce qui
// en déborde, ce qui obligeait à tenir une liste d'étiquettes à jour.
//
// Un cours s'inclut aussi ailleurs que dans le poly, pour ses flashcards et ses
// questions de colle (cf. `cours-en-annexe`). C'est alors `--input inclus=1` qui
// le dit : il n'y a pas de poly pour poser l'état `racine`.
#let inclus-dans-le-poly() = (
    sys.inputs.at("inclus", default: "") != "" or state("racine").get() == "full-poly"
)

// L'écriture des nombres du cours. Hors d'`init-document` parce qu'un
// document qui ne passe pas par lui en a besoin aussi : une page d'exercice du
// site ou un notebook n'incluent que l'exercice, sans TD autour. Sans ces
// réglages, ils sortaient « 99 × 10⁻⁶ » et « 0.1 s ».
#let réglages-nombres() = {
    set-round(mode: "figures")
    // Le point de multiplication d'unify plutôt que la croix, défaut de zero :
    // c'est la notation du cours, et tous les documents déjà tirés l'ont.
    set-num(product: sym.dot.op, decimal-separator: ",")
}

// Où le site est publié : la même adresse qu'`ADRESSE_PUBLIQUE` dans
// outils/site.py.
#let adresse-du-site = "https://blotg.github.io/cours-psi/"

// Les lettres accentuées et leur lettre de base : ce que `adresse()`, dans
// outils/site.py, obtient en décomposant le texte (NFD) puis en jetant les
// accents. Typst ne sait pas décomposer : on énumère.
#let _sans-accent = (
    a: "àâäáã",
    c: "ç",
    e: "éèêë",
    i: "îïíì",
    n: "ñ",
    o: "ôöóò",
    u: "ùûüú",
    y: "ÿý",
)

// L'adresse de la page d'un chapitre sur le site, tirée de son titre court
// comme le fait `dossier_du_chapitre` dans outils/site.py — « Électromagnétisme
// 3 » donne « electromagnetisme-3/ ». Les deux règles doivent rester les
// mêmes : le QR code du poly mènerait sinon vers une page qui n'existe pas.
//
// Le calcul se fait ici plutôt que d'arriver par un `--input` : le poly se
// compile aussi hors des outils Python — par le hook pre-commit, par l'aperçu
// de l'éditeur —, et il y faut le même QR code.
//
// C'est la forme en dossier, sans `index.html` : celle que le site tient pour
// canonique, et une adresse plus courte fait un QR code moins dense.
#let page-du-chapitre(titre-court, révision: false) = {
    let texte = lower(titre-court)
    for (lettre, accentuées) in _sans-accent {
        texte = texte.replace(regex("[" + accentuées + "]"), lettre)
    }
    let dossier = texte.replace(regex("[^a-z0-9]+"), "-").trim("-")
    if dossier == "" { dossier = "page" }
    adresse-du-site + (if révision { "revisions/" } else { "" }) + dossier + "/"
}

// `logotype` : bandeau d'en-tête sur la première page. À couper pour les
// documents qui ne sont pas des feuilles de cours — la planche de
// flashcards, les pages quadrillées — où il tomberait au travers.
// `qr` : une adresse, que porte un QR code en regard du logotype, à droite.
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
    qr: none,
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
    réglages-nombres()
    show: styles-blocs
    if logotype {
        let largeur = 30mm
        let hauteur = largeur * 592.873 / 969.344 // proportions du SVG
        let montée = 8mm // ce dont il déborde dans la marge haute (10 mm)

        // Le logotype est placé, donc hors du flux : il ne prend que la
        // hauteur explicitement réservée ci-dessous, et le titre remonte
        // d'autant. Les titres les plus longs occupent toute la largeur sur
        // deux lignes : le logotype ne peut pas se mettre à côté d'eux.
        // Toute la largeur, explicitement : rien n'y est dans le flux, le bloc
        // n'aurait sinon aucune largeur, et la droite serait à gauche.
        block(width: 100%)[
            #place(top + left, dy: -montée, image("logos/Logotype noir.svg", width: largeur))
            #if qr != none {
                // Aligné sur le dessin du logotype, et non sur sa boîte : le
                // SVG l'entoure d'un blanc de 85 unités de tous côtés (mesuré).
                // Le QR code, lui, n'a pas de marge : à la hauteur de la boîte,
                // il dépassait le logotype et montait à 2 mm du bord du papier,
                // là où une imprimante rogne ses repères.
                let blanc = largeur * 85 / 969.344
                place(
                    top + right,
                    dx: -blanc,
                    dy: blanc - montée,
                    link(qr, qrcode(qr, height: hauteur - 2 * blanc)),
                )
            }
            #v(hauteur - montée)
        ]
    }
    doc
}

// Titre d'un document : centré et en gros sur le papier.
//
// align() est de la mise en page : à l'export HTML, typst l'ignore *avec son
// contenu* — les pages du site sortaient sans titre du tout. On y met à la
// place le <h1> que typst réserve justement au titre du document — il décale
// d'un cran ceux du corps, si bien qu'un `=` sort en <h2>.
#let titre-document(contenu, taille: 17pt) = context if target() == "html" {
    html.elem("h1", contenu)
} else {
    align(center, text(size: taille, strong(contenu)))
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

// `révision: true` : le poly d'un chapitre de révision de PCSI. D'une part la
// page de garde seule — titre, compétences, questions de colle —, sans le
// résumé du cours : celui-ci ne porte que des flashcards et des questions de
// colle, rien qui s'imprime, son résumé ne serait qu'une page de titres de
// sections. D'autre part sa page du site, rangée sous `revisions/`.
#let full-poly(infos: (:), révision: false, doc) = {
    let titre = infos.at("titre", default: "")
    let révisions-sup = infos.at("révisions-sup", default: ())
    let cahier-entrainement = infos.at("cahier-entrainement", default: ())
    let cahier-entrainement-sup = infos.at("cahier-entrainement-sup", default: ())
    let DM = infos.at("DM", default: ())
    let titre-court = infos.at("titre-court", default: none)
    show: init-document.with(
        titre: titre,
        qr: if titre-court != none { page-du-chapitre(str(titre-court), révision: révision) },
    )
    state("racine").update("full-poly")
    show <compétences>: it => {
        set list(marker: checkbox)
        [= Compétences]
        it
        if query(<question-de-colle>).len() > 0 {
            [= Questions de cours des interrogations orales]
            for q in query(<question-de-colle>) {
                [
                    - #q.value
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
    show <cours>: it => if révision {
        // Tu, mais pas retiré : la page de garde tire ses questions de colle
        // des métadonnées du cours, qui doivent donc rester dans le document.
        //
        // Pas de `place` pour le sortir du flux : c'est un conteneur, et à la
        // première passe — l'état `racine` n'y est pas encore connu — `cours()`
        // s'y croit seul et pose sa page, ce que typst refuse sans attendre la
        // passe suivante. Titres et texte sont donc supprimés sur place, sans
        // laisser de blanc ; `hide` couvre ce qui resterait.
        show heading: none
        show text: none
        hide(it)
    } else {
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
    titre-document(markup(titre))
    doc
    context [#metadata(here().page()) <dernière-page>]
}

// Le TD se tire en deux documents : l'énoncé seul, à distribuer, et le TD
// corrigé. `--input sans-corrigé=1` demande le premier ; sans lui, les
// corrigés restent — c'est ce que montre l'aperçu de l'éditeur, pendant qu'on
// écrit les exercices. Le hook pre-commit produit les deux.
//
// Le titre dit lequel est lequel : sur papier, rien d'autre ne les distingue
// avant la première question.
#let TD(infos: (:), avec-corrigé: true, doc) = {
    let titre = infos.at("titre", default: "")
    let avec-corrigé = avec-corrigé and sys.inputs.at("sans-corrigé", default: "") == ""
    context if inclus-dans-le-poly() {
        doc
    } else {
        show: init-document.with(titre: titre)
        set heading(numbering: "1.")
        show <correction>: it => if avec-corrigé { it } else {}
        titre-document[#markup(titre) TD#if avec-corrigé [ corrigé]]
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
        titre-document(markup(titre))
        corps
    }
}

#let programme-de-colle(date: datetime.today(), doc) = {
    show: init-document.with(titre: "Programme de colle")
    titre-document[Programme de colle de la semaine du #date.display("[day]/[month]/[year]")]
    doc
}

#let TP(numéro: none, titre: none, date: datetime.today(), liste-élèves: none, doc) = {
    // Inclus en annexe de la fiche de notation (`--input inclus=1`, cf.
    // `cours-en-annexe`), le sujet ne met pas la page en place : la fiche n'y
    // lit que ses évaluations, et garde sa propre page et son titre. La
    // numérotation des titres reste : un sujet renvoie à ses parties.
    if sys.inputs.at("inclus", default: "") != "" {
        return {
            set heading(numbering: "1.")
            doc
        }
    }
    let titre-doc = "TP"
    if numéro != none {
        titre-doc = titre-doc + [ #numéro]
    }
    if titre != none {
        titre-doc = titre-doc + [ #sym.dash #markup(titre)]
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

    titre-document(titre-doc)
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
    titre-document([Évaluation du compte-rendu], taille: 15pt)
    doc
}
