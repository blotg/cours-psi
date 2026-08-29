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

// Enveloppe : rectangle fermé arrondi = bandeau + corps.
#let _boite(
    bandeau,
    corps,
    noir: false,
    fond-corps: none,
    inset-corps: (x: _inset-x, y: 0.6em),
    breakable: true,
    écart: _écart,
    étiquette: <bloc>,
) = [#block(
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
    ) #étiquette]

// Bloc courant : bandeau standard + corps.
#let _bloc(intitulé, corps, titre: none, marqueur: none, noir: false, fond-corps: none, étiquette-de: <bloc>) = _boite(
    _bandeau(intitulé, titre: titre, marqueur: marqueur, noir: noir),
    corps,
    noir: noir,
    fond-corps: fond-corps,
    étiquette: étiquette-de,
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

#let entourage() = {
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
    context {
        let n = counter(heading).get().sum() + datetime.today().year() * 36500 + datetime.today().ordinal() * 100
        return L.at(calc.rem(n, L.len()))
    }
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
            #text(font: "Noto Emoji", emoji.bubble.speech.r) J'explique à #entourage() :
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

// -- Compteurs de démonstration / manipulation ------------------------------

#let compteur-demo = counter("démonstration")
#let demo() = [
    #compteur-demo.step()
    $text(font: "D050000L", "-")^#context compteur-demo.display()$
]

#let compteur-manip = counter("manipulation")
#let manip() = [
    #compteur-manip.step()
    $text(font: "Noto Emoji", #emoji.hands.raised)^#context compteur-manip.display("I")$
]

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
        if titre != "" { titre } else { "À retenir" },
        corps,
        marqueur: marqueur,
        noir: true,
        fond-corps: _fond-encadré,
        étiquette-de: <encadré>,
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
        _bandeau("Schéma", titre: if titre != "" { titre }),
        block(clip: true, width: 100%, height: hauteur, {
            if quadrillage == true or (quadrillage == auto and vide) {
                place(center + horizon, rect(width: 100%, height: 100%, fill: _quadrillage))
            }
            if not vide { contenu.pos().first() }
        }),
        inset-corps: 0pt,
        breakable: false,
        étiquette: <schéma>,
    )
}

// -- Blocs d'activité ---------------------------------------------------

#let application(titre: "", contenu) = _bloc(
    "Application",
    contenu,
    titre: titre,
    marqueur: demo(),
    étiquette-de: <application>,
)

#let exemple(titre: "", contenu) = _bloc("Exemple", contenu, titre: titre, étiquette-de: <exemple>)

#let manipulation(titre: "", contenu) = _bloc(
    "Manipulation",
    contenu,
    titre: titre,
    marqueur: manip(),
    étiquette-de: <manipulation>,
)

#let préparatoire(contenu) = _bloc("Travail préparatoire", contenu, noir: true, étiquette-de: <préparatoire>)

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
        étiquette-de: <matériel>,
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

#let évaluation(appel-prof: false, barème: (), rotation: true, contenu) = {
    context if (
        not rotation
            or "numéro-copie" not in sys.inputs
            or calc.rem(int(sys.inputs.at("numéro-copie")), i-évaluation.final().first()) == i-évaluation.get().first()
    ) {
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
            étiquette-de: <évaluation>,
        )
    }
    i-évaluation.step()
}
