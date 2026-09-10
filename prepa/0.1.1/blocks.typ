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

// Le tirage au sort (la personne à qui l'on explique, cf. `entourage`) est
// délégué à suiji : générateur de Tausworthe combiné, sans état global, et
// reproductible à graine égale.
#import "@preview/suiji:0.4.0": choice-f, gen-rng-f

#let numQuestion = counter("question")

// -- Réglages partagés -------------------------------------------------------

#let _gris = luma(35%)
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
    import "helper-functions.typ": markup
    set text(fill: if noir { white } else { black })
    // h() est une mise en page : à l'export HTML elle disparait, et le tiret
    // comme le marqueur viennent se coller au titre. On repasse par de vraies
    // espaces, que les deux cibles savent composer.
    let écart = context if target() == "html" { sym.space } else { h(0.4em) }
    strong(intitulé)
    if titre != none and titre != "" {
        text(fill: if noir { luma(75%) } else { _gris })[#écart#sym.dash.en#écart]
        markup(titre)
    }
    if marqueur != none {
        context if target() == "html" { sym.space } else { h(1fr) }
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
        // align() est une mise en page : à l'export HTML, typst ne sait pas la
        // représenter et emporte le contenu de la boîte avec elle — un cours
        // sortait réduit à ses titres et à ses paragraphes. Le centrage qu'elle
        // annule n'existe de toute façon qu'en sortie paginée. En HTML, c'est
        // _boite qui a déjà posé la <section> : il ne reste qu'à la laisser
        // passer, sans la <figure> que typst mettrait autour.
        context if target() == "html" { it.body } else { align(start, it.body) }
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
//
// `classe` nomme la boîte à l'export HTML (attribut `data-genre`). Par défaut
// c'est le genre ; les blocs qui ne peuvent pas être des figure() — cf.
// évaluation — la donnent à la main.
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
    classe: auto,
) = {
    if classe == auto { classe = genre }
    let boîte = context if target() == "html" {
        // Les block() ci-dessous sont de la mise en page : à l'export HTML
        // typst n'en laisse qu'un div anonyme, et le bandeau se confond avec le
        // corps. On écrit la structure en clair, pour que site.css ait prise
        // dessus — filet, bandeau noir, fond du corps.
        html.elem(
            "section",
            attrs: (class: "bloc", "data-genre": if classe == none { "" } else { classe }),
            {
                html.elem("div", attrs: (class: if noir { "bloc-bandeau noir" } else { "bloc-bandeau" }), bandeau)
                html.elem("div", attrs: (class: "bloc-corps"), corps)
            },
        )
    } else {
        block(
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
    }
    if genre != none { figure(kind: genre, supplement: supplement, numbering: "1", caption: none, boîte) } else {
        boîte
    }
}

// Bloc courant : bandeau standard + corps.
#let _bloc(
    intitulé,
    corps,
    titre: none,
    marqueur: none,
    noir: false,
    fond-corps: none,
    genre: none,
    supplement: none,
    classe: auto,
) = _boite(
    _bandeau(intitulé, titre: titre, marqueur: marqueur, noir: noir),
    corps,
    noir: noir,
    fond-corps: fond-corps,
    genre: genre,
    supplement: supplement,
    classe: classe,
)

// -- Questions ---------------------------------------------------------------

#let question(
    body,
    ..autres,
    coups-de-pouce: (),
) = {
    if type(coups-de-pouce) == str { coups-de-pouce = (coups-de-pouce,) }
    assert(type(coups-de-pouce) == array)
    // `..autres` avale tout argument nommé inconnu sans broncher : sans ce
    // garde-fou, un `coup-de-pouce:` mal orthographié perd silencieusement ses
    // coups de pouce, à la compilation comme dans le PDF.
    assert(
        autres.named().len() == 0,
        message: "question() : argument nommé inconnu " + repr(autres.named().keys()),
    )
    let corrigé = if autres.pos().len() > 0 { autres.pos().first() }
    numQuestion.step()
    parbreak()
    [*#context numQuestion.display()#sym.slash* <numéro-question> #body <question>]
    import "helper-functions.typ": scope-des-chaines
    for c in coups-de-pouce {
        let _ = eval(c, mode: "markup", scope: scope-des-chaines)
    }
    // Émise AVANT le corrigé, et non après : la métadonnée n'imprime rien, mais
    // le site s'en sert pour poser les coups de pouce dans le flux — et ils
    // doivent y venir avant la solution, sans quoi ils ne servent plus à rien.
    context [#metadata((
        exercice: counter(heading).get().sum(),
        question: numQuestion.get().first(),
        coups-de-pouce: coups-de-pouce,
    )) <coups-de-pouce>]
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
    // Choix déterministe à partir du titre de l'exercice : pas d'aléa
    // d'horloge, la compilation reste reproductible et deux exercices
    // distincts tombent sur des personnes bien réparties dans la liste.
    //
    // Le tirage est celui de suiji ; il ne reste ici que la conversion du
    // titre en graine (cf. `graine-du-texte`).
    import "helper-functions.typ": graine-du-texte
    let (_, personne) = choice-f(gen-rng-f(graine-du-texte(graine)), L)
    personne
}

#let exercice(
    body,
    titre: "",
    difficulté: 0,
    numérique: false,
    ouvert: false,
    explique: false,
) = [
    #import "helper-functions.typ": markup
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
        #markup(titre)
        #text(fill: _gris)[#for _ in range(difficulté) { sym.star.filled }]
    ]) <titre-exercice>
    #if ouvert [
        #text(
            fill: _gris,
        )[_Cet exercice est un problème ouvert. Il nécessite de prendre des initiatives et de faire des choix dans la modélisation. Des approximations et des estimations sont souvent nécessaires pour arriver à une solution._]
    ]
    #if explique [
        #text(
            fill: _gris,
        )[_Le but de cet exercice est de vous faire expliquer un concept/phénomène avec des mots simples et courants (pas de vocabulaire technique ou scientifique) à une personne de votre entourage. Tachez de faire simple et court, utilisez des analogies avec des choses connues. Vous pouvez vous inspirer de #link("https://www.youtube.com/@MT180_fr", "Ma thèse en 180 secondes"). Profitez-en pour prendre des nouvelles !_]
    ]
    #show <question>: it => if ouvert or explique { strong(it) } else { it }
    #show <numéro-question>: it => if ouvert or explique {} else { it }
    #body
]

// -- Marqueur « savoir-faire » (bout de bandeau des encadrés) --------------
// Un simple pictogramme, sans numéro : le numéro du bloc est désormais dans
// le bandeau lui-même (cf. _numéro-bloc et les fonctions de bloc plus bas).

// Une main qui écrit. Le glyphe vient d'une police de dingbats, que le web
// n'a pas : à l'export HTML on passe au caractère Unicode équivalent, sans
// quoi le marqueur se lisait « - » sur toutes les pages du site.
#let demo() = context if target() == "html" { "✍" } else { text(font: "D050000L", "-") }

// -- Encadré de cours ------------------------------------------------------

#let _rendu-grandeurs(grandeurs) = {
    import "helper-functions.typ": scope-des-chaines
    let items = ()
    for (clé, valeur) in grandeurs {
        let unité = if "unité" in valeur and valeur.unité != none [ (#valeur.unité)]
        items.push([#eval(clé, mode: "math", scope: scope-des-chaines) #if type(valeur.signification) == str {
                eval(
                    valeur.signification,
                    mode: "markup",
                    scope: scope-des-chaines,
                )
            } else { valeur.signification } #unité])
    }
    items.join([ ; ])
}

#let encadré(titre: "", connaitre: false, savoir-faire: false, hypothèses: (), grandeurs: (:), contenu) = {
    import "helper-functions.typ": markup
    if type(hypothèses) in (str, content) { hypothèses = (hypothèses,) }
    hypothèses = hypothèses.map(markup)

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
            let mi = calc.ceil(hypothèses.len() / 2)
            text(size: 0.92em, style: "italic", fill: _gris)[
                Hypothèses :
                #grid(
                    columns: (1fr, 1fr),
                    column-gutter: 1.2em,
                    list(..hypothèses.slice(0, mi)), list(..hypothèses.slice(mi)),
                )
            ]
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
    marqueur: demo(),
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

// `matériel` n'apparait pas dans le bloc : il alimente la liste des
// manipulations, tirée du document par `typst query ... <manipulation>`.
#let manipulation(titre: "", matériel: (), contenu) = {
    [#metadata((titre: titre, matériel: matériel)) <manipulation>]
    _bloc(
        [Manipulation #_numéro-bloc("manipulation")],
        contenu,
        titre: titre,
        marqueur: text(font: "Noto Emoji", emoji.hands.raised),
        genre: "manipulation",
        supplement: "manipulation",
    )
}

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
                        contenu, block(stroke: (left: _filet), inset: (left: 1em), _barème(barème)),
                    )
                },
                noir: true,
                classe: "évaluation",
                // Vue « prof » (sans --input numéro-copie) : poids de rotation.
                // Rien sur le site : l'élève n'a que faire de la rotation.
                // marqueur: if copie == none and target() != "html" { $#nombre / #total$ },
                marqueur: text(font: "Noto Sans Symbols 2", "★★⯪"),
            )
        }
    }
    i-évaluation.update(n => n + nombre)
}
