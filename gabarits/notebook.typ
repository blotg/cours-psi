// Un exercice numérique compilé pour devenir un notebook (cf. outils/notebook.py).
//
// Comme pour le site, rien n'est réécrit : c'est l'exercice lui-même, compilé
// en HTML. Ce gabarit n'en retire que ce que l'élève ne doit pas voir, et pose
// des repères qui disent à outils/notebook.py où couper les cellules. Le HTML
// n'est qu'une étape : pandoc en tire le notebook, formules traduites en LaTeX
// pour le MathJax du notebook.

#import "@local/prepa:0.1.1": *
#import "site.typ": styles-html

// Des repères vides, que pandoc garde en `Span` ou en `Div` avec leur classe.
#let _repère-en-ligne(classe) = html.elem("span", attrs: (class: classe))
#let _repère(classe) = html.elem("div", attrs: (class: classe))

// Une décoration de formule en MathML standard, que pandoc sait traduire :
// `<munder>`/`<mover>` avec un trait donnent `\underline`/`\overline`, et
// `<menclose>` donne `\cancel`. Le site, lui, les rend en CSS (cf. site.typ),
// ce qu'un notebook n'a pas.
#let _sous(corps, trait) = html.elem(
    "munder",
    attrs: (accentunder: "true"),
    { html.elem("mrow", corps); html.elem("mo", trait) },
)
#let _sur(corps, trait) = html.elem(
    "mover",
    attrs: (accent: "true"),
    { html.elem("mrow", corps); html.elem("mo", trait) },
)

#let page-notebook(doc) = {
    show: styles-html
    // Posées après celles de `styles-html`, ces règles passent avant elles.
    show math.underline: it => context if target() == "html" { _sous(it.body, "_") } else { it }
    show math.overline: it => context if target() == "html" { _sur(it.body, "¯") } else { it }
    show math.cancel: it => context if target() == "html" {
        html.elem("menclose", attrs: (notation: "updiagonalstrike"), html.elem("mrow", it.body))
    } else { it }

    // Ni corrigé, ni coup de pouce : le notebook est celui de l'élève. Les
    // coups de pouce ne s'impriment déjà pas ; leur métadonnée, émise juste
    // après l'énoncé de la question, sert de repère de fin.
    show <correction>: none
    show <coups-de-pouce>: _repère("fin-question")
    // Le notebook pointerait sur lui-même.
    show <lien-capytale>: none

    // Le début d'une question se repère sur son numéro, et à défaut sur son
    // énoncé : un exercice « ouvert » ou « explique » ne numérote pas ses
    // questions. Le script ne tient compte que du premier repère.
    show <numéro-question>: it => _repère-en-ligne("début-question") + it
    show <question>: it => _repère-en-ligne("début-question") + it

    // `init-document` le pose pour les PDF, mais l'exercice seul ne passe pas
    // par lui : les renvois disaient « Table 1 » au lieu de « Tableau 1 ».
    set text(lang: "fr")
    réglages-nombres()
    doc
}
