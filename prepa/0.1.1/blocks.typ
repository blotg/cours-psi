#import "helper-functions.typ": *
#import "@preview/wrap-it:0.1.1": wrap-content // ré-exporté pour les documents

// =============================================================================
//  Thème « titré » — boîtes fermées à bandeau
//  Chaque bloc est un rectangle fermé (filet 0,6 pt, coins légèrement
//  arrondis) coiffé d'un bandeau portant le type en gras et le titre en
//  romain. Bandeau gris clair pour les activités, noir pour les encadrés de
//  cours (dont le corps reste sur fond gris).
//
//  Construction : _bandeau() fabrique l'en-tête, _boite() l'enveloppe
//  (bandeau + corps), _bloc() combine les deux. Tous les blocs passent par là.
// =============================================================================

#let numQuestion = counter("question")

// -- Réglages partagés -------------------------------------------------------

#let _gris = luma(45%)
#let _filet = 0.6pt + luma(20%)
#let _fond-bandeau = luma(90%)
#let _fond-bandeau-noir = black
#let _fond-encadré = black.lighten(90%) // teinte de la version d'origine
#let _rayon = 2pt
#let _inset-x = 0.85em
#let _écart = 1.4em // blanc avant / après un bloc

// En-tête : **Intitulé** – titre …………………………………………… marqueur
// Le marqueur (emoji + numéro) suit la couleur du bandeau : noir sur fond
// clair, blanc sur fond noir.
#let _bandeau(intitulé, titre: none, marqueur: none, noir: false) = {
    set text(fill: if noir { white } else { black })
    strong(intitulé)
    if titre != none and titre != "" {
        text(fill: if noir { luma(75%) } else { _gris })[#h(0.4em)#sym.dash.en#h(0.4em)]
        titre
    }
    if marqueur != none {
        h(1fr)
        marqueur
    }
}

// -- Blocs référençables ------------------------------------------------
// Chaque type de bloc numéroté est une figure(kind: …) : un label posé sur
// l'appel (ex. #manipulation(...)[...] <ma-manip>) devient alors
// référençable avec @ma-manip, qui affiche « Supplément N » (lien cliquable),
// exactement comme pour un heading numéroté.
#let _genres-blocs = (
    "encadré",
    "schéma",
    "application",
    "exemple",
    "manipulation",
    "préparatoire",
    "matériel",
)
// Ces figures n'ont ni légende ni mise en page propre : elles ne servent
// qu'au compteur et à la référence. align(start) annule le centrage que
// figure() applique par défaut à son contenu ; l'apparence redevient
// entièrement celle de _boite ci-dessous.
//
// À appliquer une fois dans la mise en page du document (fait par
// init-document) : une règle `show` au niveau module ne se propage pas
// à travers `import`, d'où cette fonction.
#let styles-blocs(doc) = {
    show figure: it => if type(it.kind) == str and it.kind in _genres-blocs {
        align(start, it.body)
    } else {
        it
    }
    doc
}

// Numéro (au sens de figure(kind: genre)) du bloc en cours de construction,
// formaté selon `format` (cf. numbering(), ex. "1" ou "I").
#let _numéro-bloc(genre, format: "1") = context numbering(format, ..counter(figure.where(kind: genre)).get())

// Enveloppe : rectangle fermé arrondi = bandeau + corps.
// `genre` (avec `supplement`) rend la boîte référençable : voir ci-dessus.
#let _boite(
    bandeau,
    corps,
    noir: false,
    fond-corps: none,
    inset-corps: (x: _inset-x, y: 0.6em),
    breakable: true,
    écart: _écart,
    genre: none,
    supplement: none,
) = {
    let boîte = block(
        breakable: breakable,
        width: 100%,
        above: écart,
        below: écart,
        radius: _rayon,
        stroke: _filet,
        clip: true,
        {
            block(
                width: 100%,
                above: 0pt,
                below: 0pt,
                sticky: true, // ne pas laisser le bandeau seul en bas de page
                fill: if noir { _fond-bandeau-noir } else { _fond-bandeau },
                inset: (x: _inset-x, y: 0.45em),
                stroke: (bottom: _filet),
                bandeau,
            )
            block(width: 100%, above: 0pt, fill: fond-corps, inset: inset-corps, corps)
        },
    )
    if genre != none { figure(kind: genre, supplement: supplement, numbering: "1", caption: none, boîte) } else { boîte }
}

// Bloc courant : bandeau standard + corps.
#let _bloc(intitulé, corps, titre: none, marqueur: none, noir: false, fond-corps: none, genre: none, supplement: none) = _boite(
    _bandeau(intitulé, titre: titre, marqueur: marqueur, noir: noir),
    corps,
    noir: noir,
    fond-corps: fond-corps,
    genre: genre,
    supplement: supplement,
)

// -- Questions ---------------------------------------------------------------

#let question(
    body,
    ..autres,
    coups-de-pouce: (),
) = {
    if type(coups-de-pouce) == str { coups-de-pouce = (coups-de-pouce,) }
    assert(type(coups-de-pouce) == array)
    let corrigé = if autres.pos().len() > 0 { autres.pos().first() }
    numQuestion.step()
    parbreak()
    [*#context numQuestion.display()#sym.slash* <numéro-question> #body <question>]
    if corrigé != none {
        // Style volontairement à part : un simple filet gris à gauche.
        [#block(
                breakable: true,
                width: 100%,
                above: 0.7em,
                below: 0.9em,
                stroke: (left: 1.5pt + luma(65%)),
                inset: (left: 0.9em, top: 0.15em, bottom: 0.15em),
                corrigé,
            ) <correction>]
    }
    import "symboles.typ" as symboles
    for c in coups-de-pouce {
        let _ = eval(c, mode: "markup", scope: dictionary(symboles))
    }
    context [#metadata((
            exercice: counter(heading).get().sum(),
            question: numQuestion.get().first(),
            coups-de-pouce: coups-de-pouce,
        )) <coups-de-pouce>]
}

#let entourage(graine: "") = {
    let L = (
        "ma grand-mère",
        "mon grand-père",
        "mon voisin",
        "ma voisine",
        "un ami",
        "une amie",
        "mon père",
        "ma mère",
        "mon frère",
        "ma sœur",
        "mon cousin",
        "ma cousine",
        "mon oncle",
        "ma tante",
        "mon chien",
        "mon chat",
    )
    // Choix déterministe à partir du titre de l'exercice (hachage type
    // « polynomial rolling hash »). Pas d'aléa d'horloge : la compilation
    // reste reproductible et deux exercices distincts tombent sur des
    // personnes bien réparties dans la liste.
    let n = 0
    for octet in array(bytes(repr(graine))) {
        n = calc.rem(n * 31 + octet, 2147483647)
    }
    L.at(calc.rem(n, L.len()))
}

#let exercice(
    body,
    titre: "",
    difficulté: 0,
    numérique: false,
    ouvert: false,
    explique: false,
) = [
    #numQuestion.update(0)
    #heading(depth: 1, [
        #if explique [
            #text(font: "Noto Emoji", emoji.bubble.speech.r) J'explique à #entourage(graine: titre) :
        ]
        #if ouvert {
            text(font: "Noto Emoji", emoji.face.think)
        }
        #if numérique [
            #text(font: "Noto Emoji", emoji.computer)
        ]
        #titre
        #text(fill: _gris)[#for _ in range(difficulté) { sym.star.filled }]
    ]) <titre-exercice>
    #if ouvert [
        #text(fill: _gris)[_Cet exercice est un problème ouvert. Il nécessite de prendre des initiatives et de faire des choix dans la modélisation. Des approximations et des estimations sont souvent nécessaires pour arriver à une solution._]
    ]
    #if explique [
        #text(fill: _gris)[_Le but de cet exercice est de vous faire expliquer un concept/phénomène avec des mots simples et courants (pas de vocabulaire technique ou scientifique) à une personne de votre entourage. Tachez de faire simple et court, utilisez des analogies avec des choses connues. Vous pouvez vous inspirer de #link("https://www.youtube.com/@MT180_fr", "Ma thèse en 180 secondes"). Profitez-en pour prendre des nouvelles !_]
    ]
    #show <question>: it => if ouvert or explique { strong(it) } else { it }
    #show <numéro-question>: it => if ouvert or explique {} else { it }
    #body
]

// -- Marqueur « savoir-faire » (bout de bandeau des encadrés) --------------
// Un simple pictogramme, sans numéro : le numéro du bloc est désormais dans
// le bandeau lui-même (cf. _numéro-bloc et les fonctions de bloc plus bas).

#let demo() = text(font: "D050000L", "-")

// -- Encadré de cours ------------------------------------------------------

#let _rendu-grandeurs(grandeurs) = {
    import "symboles.typ" as symboles
    let items = ()
    for (clé, valeur) in grandeurs {
        let unité = if "unité" in valeur and valeur.unité != none [ (#valeur.unité)]
        items.push([#eval(clé, mode: "math", scope: dictionary(symboles)) #eval(valeur.signification, mode: "markup", scope: dictionary(symboles))#unité])
    }
    items.join([ ; ])
}

#let encadré(titre: "", connaitre: false, savoir-faire: false, hypothèses: (), grandeurs: (:), contenu) = {
    if type(hypothèses) in (str, content) { hypothèses = (hypothèses,) }

    let marqueur = none
    if connaitre and savoir-faire {
        marqueur = [#sym.suit.heart#h(0.4em)#demo()]
    } else if savoir-faire {
        marqueur = demo()
    } else if connaitre {
        marqueur = sym.suit.heart
    }

    let corps = {
        if hypothèses.len() == 1 {
            text(size: 0.92em, style: "italic", fill: _gris)[Hypothèse : #hypothèses.first()]
            parbreak()
        } else if hypothèses.len() > 1 {
            text(size: 0.92em, style: "italic", fill: _gris)[Hypothèses : #list(..hypothèses)]
        }
        contenu
        if grandeurs != (:) {
            block(
                width: 100%,
                above: 0.7em,
                stroke: (top: 0.4pt + luma(65%)),
                inset: (top: 0.5em),
                text(size: 0.88em, fill: _gris)[avec #_rendu-grandeurs(grandeurs).],
            )
        }
    }

    _bloc(
        [Point clé #_numéro-bloc("encadré")],
        corps,
        titre: if titre != "" { titre },
        marqueur: marqueur,
        noir: true,
        fond-corps: _fond-encadré,
        genre: "encadré",
        supplement: "point clé",
    )
}

// -- Schéma --------------------------------------------------------------

#let _quadrillage = tiling(size: (0.5cm, 0.5cm))[
    #place(line(start: (0%, 0%), end: (100%, 0%), stroke: 0.5pt + luma(80%)))
    #place(line(start: (0%, 0%), end: (0%, 100%), stroke: 0.5pt + luma(80%)))
]

#let schéma(titre: "", quadrillage: auto, hauteur: auto, ..contenu) = {
    let vide = contenu.pos().len() == 0
    if hauteur == auto and vide { hauteur = 6cm }
    _boite(
        _bandeau([Schéma #_numéro-bloc("schéma")], titre: if titre != "" { titre }),
        block(clip: true, width: 100%, height: hauteur, {
            if quadrillage == true or (quadrillage == auto and vide) {
                place(center + horizon, rect(width: 100%, height: 100%, fill: _quadrillage))
            }
            if not vide { contenu.pos().first() }
        }),
        inset-corps: 0pt,
        breakable: false,
        genre: "schéma",
        supplement: "schéma",
    )
}

// Zone quadrillée seule (tracé à main levée, croquis…), sur toute la largeur.
// `hauteur` : hauteur de la zone. `bordure` : entoure la zone d'un filet.
#let carreaux(hauteur, bordure: false) = [#block(
        width: 100%,
        height: hauteur,
        above: _écart,
        below: _écart,
        radius: _rayon,
        stroke: if bordure { _filet },
        clip: true,
        breakable: false,
        place(center + horizon, rect(width: 100%, height: 100%, fill: _quadrillage, stroke: none)),
    ) <carreaux>]

// -- Blocs d'activité ---------------------------------------------------

#let application(titre: "", contenu) = _bloc(
    [Application #_numéro-bloc("application")],
    contenu,
    titre: titre,
    marqueur: text(font: "D050000L", "-"),
    genre: "application",
    supplement: "application",
)

#let exemple(titre: "", contenu) = _bloc(
    [Exemple #_numéro-bloc("exemple")],
    contenu,
    titre: titre,
    genre: "exemple",
    supplement: "exemple",
)

#let manipulation(titre: "", matériel: (), contenu) = _bloc(
    [Manipulation #_numéro-bloc("manipulation")],
    contenu,
    titre: titre,
    marqueur: text(font: "Noto Emoji", emoji.hands.raised),
    genre: "manipulation",
    supplement: "manipulation",
)

// préparatoire et matériel : uniques dans un document, donc pas de numéro
// affiché dans le bandeau (mais restent référençables : @label => « … 1 »).
#let préparatoire(contenu) = _bloc(
    "Travail préparatoire",
    contenu,
    noir: true,
    genre: "préparatoire",
    supplement: "travail préparatoire",
)

#let lien(url) = {
    import "@preview/tiaoma:0.3.0": qrcode
    align(center, block(width: 5cm)[
        #link(url, qrcode(url))
        #text(size: 6pt, url)
    ])
}

#let matériel(groupe: (), classe: ()) = {
    let catégories = ()
    if groupe.len() > 0 { catégories.push(("Par groupe", groupe)) }
    if classe.len() > 0 { catégories.push(("Pour la classe", classe)) }
    assert(catégories.len() > 0, message: "Il faut au moins une catégorie de matériel (groupe ou classe).")
    _bloc(
        "Matériel",
        // Colonnes de largeur égale, réparties sur toute la largeur (50/50).
        grid(
            columns: (1fr,) * catégories.len(),
            column-gutter: 1.2em,
            ..catégories.map(((titre, items)) => [
                #emph(text(fill: _gris, titre))
                #list(..items)
            ]),
        ),
        genre: "matériel",
        supplement: "matériel",
    )
}

// -- Évaluation --------------------------------------------------------

#let i-évaluation = counter("évaluation")

#let _barème(barème) = {
    let total = 0
    for (_, points) in barème { total += points }
    set text(size: 0.92em)
    grid(
        columns: (auto, auto),
        align: (left, right),
        row-gutter: 0.55em,
        column-gutter: 0.9em,
        ..barème.map(((critère, points)) => (emph(critère), [\/ #points])).flatten(),
        grid.hline(y: barème.len(), stroke: _filet),
        grid.cell(inset: (top: 0.6em))[*Total*], grid.cell(inset: (top: 0.6em))[\/ *#total*],
    )
}

// Pas de genre/figure ici (donc pas référençable par @label), à la différence
// des autres blocs : la rotation entre copies exige que le pas du compteur
// reste un statement top-level inconditionnel, incompatible avec figure().
//
// Rotation : chaque évaluation occupe `nombre` créneaux consécutifs (défaut
// 1) ; la copie n° k reçoit l'évaluation dont le créneau contient
// k modulo (total des créneaux). `nombre` > 1 ⇒ une même évaluation est
// proposée à plusieurs binômes.
#let évaluation(appel-prof: false, barème: (), rotation: true, nombre: 1, contenu) = {
    assert(type(nombre) == int and nombre >= 1, message: "évaluation : `nombre` doit être un entier ≥ 1")
    context {
        let total = i-évaluation.final().first()
        let copie = if "numéro-copie" in sys.inputs {
            calc.rem(int(sys.inputs.at("numéro-copie")), total)
        }
        let début = i-évaluation.get().first()
        if not rotation or copie == none or (début <= copie and copie < début + nombre) {
            _bloc(
                if appel-prof { "Appel prof — Évaluation" } else { "Évaluation" },
                if barème == () { contenu } else {
                    grid(
                        columns: (1fr, auto),
                        column-gutter: 1.4em,
                        contenu,
                        block(stroke: (left: _filet), inset: (left: 1em), _barème(barème)),
                    )
                },
                noir: true,
                // Vue « prof » (sans --input numéro-copie) : poids de rotation.
                marqueur: if copie == none { $#nombre / #total$ },
            )
        }
    }
    i-évaluation.update(n => n + nombre)
}
