#import "@preview/showybox:2.0.4": showybox
#import "helper-functions.typ": *
#import "@preview/oasis-align:0.3.3": oasis-align
#import "@preview/wrap-it:0.1.1": wrap-content

#let numQuestion = counter("question")

#let question(
    body,
    ..autres,
    coups-de-pouce: (),
) = {
    if type(coups-de-pouce) == str { coups-de-pouce = (coups-de-pouce,) }
    assert(type(coups-de-pouce) == array)
    let corrigé = none
    if autres.pos().len() > 0 { corrigé = autres.pos().first() }
    numQuestion.step()
    parbreak()
    [*#context numQuestion.display()#sym.slash* <numéro-question> #body <question>]
    if corrigé != none {
        [
            #showybox(
                frame: (
                    border-color: red.darken(40%),
                ),
                breakable: true,
            )[#corrigé]<correction>
        ]
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
        #for _ in range(difficulté) {
            sym.star.filled
        }
    ]) <titre-exercice>
    #if ouvert [
        _Cet exercice est un problème ouvert. Il nécessite de prendre des initiatives et de faire des choix dans la modélisation. Des approximations et des estimations sont souvent nécessaires pour arriver à une solution._
    ]
    #if explique [
        _Le but de cet exercice est de vous faire expliquer un concept/phénomène avec des mots simples et courants (pas de vocabulaire technique ou scientifique) à une personne de votre entourage. Tachez de faire simple et court, utilisez des analogies avec des choses connues. Vous pouvez vous inspirer de #link("https://www.youtube.com/@MT180_fr", "Ma thèse en 180 secondes"). Profitez-en pour prendre des nouvelles !_
    ]
    #show <question>: it => if ouvert or explique { strong(it) } else { it }
    #show <numéro-question>: it => if ouvert or explique {} else { it }
    #body
]

#let compteur-demo = counter("démonstration")

#let demo() = [
    #compteur-demo.step()
    $text(font: "D050000L", "-")^#context compteur-demo.display()$
]

#let encadré(titre: "", connaitre: false, savoir-faire: false, hypothèses: (), grandeurs: (:), contenu) = {
    let contenu-principal = [
        #set align(horizon)
        #set text(size: 9pt)
        #if type(hypothèses) in (str, content) {
            hypothèses = (hypothèses,)
        }
        #if hypothèses.len() == 1 {
            [_Hypothèse : #hypothèses.at(0)_#linebreak()]
        } else if hypothèses.len() > 1 {
            [_Hypothèses : #for hypo in hypothèses [- #hypo]_]
        }
        #set text(size: 14pt)
        #contenu
    ]
    if grandeurs != (:) {
        contenu-principal = oasis-align(contenu-principal, [
            #set align(horizon)
            #set text(size: 9pt)
            #block(inset: (x: 10pt), [
                Avec
                #import "symboles.typ" as symboles
                // #panic(grandeurs.at(0).keys())
                #for (key, value) in grandeurs {
                    list.item[
                        #eval(key, mode: "math", scope: dictionary(symboles))
                        #eval(value.signification, mode: "markup", scope: dictionary(symboles))
                        #if "unité" in value.keys() and value.unité != none [(#value.unité)]
                    ]
                }
            ])
        ])
    }
    [#showybox(
        frame: (
            border-color: black,
            title-color: black,
            body-color: black.lighten(90%),
            title-inset: (x: 0.5em, y: 0.4em),
        ),
        title: [
            #titre #h(1fr)
            #if connaitre { sym.suit.heart }
            #if savoir-faire { demo() }
        ],
        contenu-principal,
    ) <encadré>]
}

#let schéma(titre: "", quadrillage: auto, hauteur: auto, ..contenu) = {
    [
        #showybox(
            frame: (
                border-color: black,
                title-color: black,
                body-color: white,
                title-inset: (x: 0.5em, y: 0.4em),
                inset: (x: 0pt, y: 0pt),
                thickness: 1pt,
                radius: 5pt,
            ),
            title: [
                #smallcaps("Schéma")
                #if titre != "" [: #titre]
            ],
            block(clip: true, width: 100%, height: if hauteur != auto { hauteur } else { auto })[
                #if quadrillage == true or (quadrillage == auto and contenu.pos().len() == 0) {
                    place(
                        center + horizon,
                        rect(
                            width: 100%,
                            height: 100%,
                            fill: tiling(size: (0.5cm, 0.5cm))[
                                #place(line(start: (0%, 0%), end: (100%, 0%), stroke: 0.5pt + luma(70%)))
                                #place(line(start: (0%, 0%), end: (0%, 100%), stroke: 0.5pt + luma(70%)))
                            ],
                        ),
                    )
                }
                #if contenu.pos().len() > 0 {
                    contenu.pos().first()
                } else {
                    block(height: hauteur, width: 100%)[#h(1fr)]
                }
            ],
        ) <schéma>
    ]
}

#let application(titre: "", contenu) = {
    [#showybox(
        frame: (
            border-color: black,
            title-color: black,
            body-color: white,
            title-inset: (x: 0.5em, y: 0.4em),
            thickness: (left: 1pt),
            radius: (top-left: 5pt, top-right: 5pt, rest: 0pt),
        ),
        title: [
            #smallcaps("Application")
            #if titre != "" [: #titre]
            #h(1fr)
            #demo()
        ],
        [#contenu],
    ) <application>]
}

#let exemple(titre: "", contenu) = {
    [#showybox(
        frame: (
            border-color: black,
            title-color: black,
            body-color: white,
            title-inset: (x: 0.5em, y: 0.4em),
            thickness: (left: 1pt),
            radius: (top-left: 5pt, top-right: 5pt, rest: 0pt),
        ),
        title: [
            #smallcaps("Exemple")
            #if titre != "" [: #titre]
        ],
        [#contenu],
    ) <application>]
}

#let lien(lien) = {
    import "@preview/tiaoma:0.3.0": qrcode
    align(center, block(width: 5cm)[
        #link(lien, qrcode(lien))
        #text(size: 6pt, lien)
    ])
}


#let matériel(groupe: (), classe: ()) = {
    let nombre-catégories = 0
    if groupe.len() > 0 { nombre-catégories += 1 }
    if classe.len() > 0 { nombre-catégories += 1 }
    assert(nombre-catégories > 0, message: "Il faut au moins une catégorie de matériel (groupe ou classe)")
    [#showybox(
        frame: (
            border-color: black,
            title-color: black,
            body-color: white,
            title-inset: (x: 0.5em, y: 0.4em),
            thickness: (left: 1pt, right: 1pt, bottom: 1pt),
            radius: 5pt,
        ),
        title: [
            #smallcaps("Matériel")
            #h(1fr)
        ],
        columns(nombre-catégories)[
            #if groupe.len() > 0 [
                _Par groupe :_
                #for m in groupe [- #m]
                #colbreak()
            ]
            #if classe.len() > 0 [
                _Pour la classe :_
                #for m in classe [- #m]
                #colbreak()
            ]],
    ) <matériel>]
}

#let compteur-manip = counter("manipulation")
#let manip() = [
    #compteur-manip.step()
    $text(font: "Noto Emoji", #emoji.hands.raised)^#context compteur-manip.display("I")$
]

#let manipulation(titre: "", contenu) = {
    [#showybox(
        frame: (
            border-color: black,
            title-color: black,
            body-color: white,
            title-inset: (x: 0.5em, y: 0.4em),
            thickness: (left: 1pt),
            radius: (top-left: 5pt, top-right: 5pt, rest: 0pt),
        ),
        title: [
            #smallcaps("Manipulation")
            #if titre != "" [
                : #titre
            ]
            #h(1fr)
            #manip()
        ],
        [
            #contenu
        ],
    ) <manipulation>]
}

#let préparatoire(contenu) = {
    [#showybox(
        frame: (
            border-color: black,
            title-color: black,
            body-color: black.lighten(90%),
            title-inset: (x: 0.5em, y: 0.4em),
            thickness: (left: 1pt, bottom: 1pt, right: 1pt),
            radius: 5pt,
        ),
        title: [
            #smallcaps("Travail préparatoire")
        ],
        [
            #contenu
        ],
    ) <préparatoire>]
}

#let i-évaluation = counter("évaluation")

#let évaluation(appel-prof: false, barème: (), rotation: true, contenu) = {
    context if (
        not rotation
            or not "numéro-copie" in sys.inputs
            or calc.rem(int(sys.inputs.at("numéro-copie")), i-évaluation.final().at(0)) == i-évaluation.get().at(0)
    ) [#showybox(
        frame: (
            border-color: black,
            title-color: black,
            body-color: black.lighten(90%),
            title-inset: (x: 0.5em, y: 0.4em),
            thickness: (left: 1pt, bottom: 1pt, right: 1pt),
            radius: 5pt,
        ),
        title: [
            #smallcaps([#if (appel-prof) { [Appel prof - ] }  Évaluation ])
        ],
        if barème == () { contenu } else {
            let total = 0
            grid(
                columns: (1fr, auto),
                inset: ((right: 0.5em), (left: 0.5em)),
                stroke: (none, (left: 1pt)),
                contenu,
                [
                    #grid(
                        columns: (auto, 2em, auto),
                        align: (left, right, right),
                        row-gutter: 0.65em,
                        ..for (i, (critère, points)) in barème.enumerate() {
                            ([_#critère _], [/], [#points ])
                            total += points
                        },
                        [*_Total _*], [/], [#total],
                    )],
            )
        },
    ) <évaluation>]
    i-évaluation.step()
}
