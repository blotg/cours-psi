// Briques communes aux pages du site (cf. outils/site.py).
//
// Tout le contenu du site sort de `typst compile --format html` : ces pages ne
// sont pas une reconstruction du cours en HTML, ce sont les sources du cours
// compilées vers une autre cible. Les formules deviennent du MathML, les
// schémas cetz/zap des SVG, et le reste des balises ordinaires que
// `site.css` habille.

#import "@local/prepa:0.1.1": *

// -- Ce que typst ne sait pas convertir tout seul ---------------------------

// Un tracé cetz/zap est de la mise en page : sans `html.frame`, il sort une
// balise vide. Le frame le rend en SVG, à sa taille naturelle.
#let styles-html(doc) = {
    show <canvas>: html.frame
    show figure.where(kind: image): html.frame
    doc
}

// -- Navigation -------------------------------------------------------------

#let lien(url, texte) = html.elem("a", attrs: (href: url), texte)

// Fil d'Ariane : une suite de (texte, url), la dernière entrée sans lien.
#let fil-ariane(entrées) = html.elem(
    "nav",
    attrs: (class: "fil"),
    for (i, entrée) in entrées.enumerate() {
        if i > 0 { html.elem("span", attrs: (class: "sep"), "›") }
        let (texte, url) = entrée
        if url == none { html.elem("span", attrs: (class: "ici"), markup(texte)) } else { lien(url, markup(texte)) }
    },
)

// -- Coups de pouce ---------------------------------------------------------

// `#question` range ses coups de pouce dans une métadonnée et ne les imprime
// jamais : sur le papier, c'est le professeur qui les distribue. Sur le site,
// on les affiche — mais floutés, et il faut rester dessus trois secondes pour
// les lire (cf. `site.css`). Le geste remplace la demande d'aide.
#let coups-de-pouce(it) = {
    let liste = it.value.at("coups-de-pouce", default: ())
    if liste.len() == 0 { return }
    html.elem(
        "div",
        attrs: (class: "pouces"),
        for (i, texte) in liste.enumerate() {
            html.elem(
                "div",
                // tabindex : au clavier, le focus révèle sans attendre.
                attrs: (class: "pouce", tabindex: "0"),
                {
                    html.elem("div", attrs: (class: "pouce-titre"), "Coup de pouce " + str(i + 1))
                    html.elem("div", attrs: (class: "pouce-texte"), markup(texte))
                },
            )
        },
    )
}

// -- Gabarit de page --------------------------------------------------------

// `corrigés` : les pages d'exercice n'en montrent pas. Les coups de pouce
// perdraient tout intérêt si la solution complète se lisait juste en dessous.
#let page-site(titre: "", fil: (), corrigés: false, doc) = {
    set document(title: titre)
    show: styles-html
    show <correction>: it => if corrigés { it } else { none }
    show <coups-de-pouce>: coups-de-pouce

    fil-ariane(fil)
    // Pas de <main> autour du document : `init-document` pose un
    // `set document(...)`, que typst refuse à l'intérieur d'un conteneur.
    // C'est `body` qui porte la largeur de lecture, dans site.css.
    doc
    html.elem(
        "footer",
        {
            html.elem("span", "Cours de PSI — lycée Brizeux")
            lien("https://creativecommons.org/licenses/by-nc/4.0/deed.fr", "CC BY-NC 4.0")
        },
    )
}

// -- Page de liens (accueil, sommaire d'un chapitre) ------------------------

// Alimentée par `--input données` :
//
//     {"titre": "...", "fil": [["texte", "url"], ...],
//      "sections": [{"titre": "...", "liens": [{"texte": "...", "url": "...",
//                                               "détail": "..."}]}]}
#let page-liens(données) = {
    show: page-site.with(
        titre: données.titre,
        fil: données.at("fil", default: ()).map(e => (e.at(0), e.at(1))),
    )
    html.elem("h1", markup(données.titre))
    for section in données.at("sections", default: ()) {
        if "titre" in section and section.titre != "" {
            html.elem("h2", markup(section.titre))
        }
        html.elem(
            "ul",
            attrs: (class: "liens"),
            for l in section.at("liens", default: ()) {
                html.elem("li", {
                    lien(l.url, markup(l.texte))
                    let détail = l.at("détail", default: "")
                    if détail != "" { html.elem("span", attrs: (class: "détail"), markup(détail)) }
                })
            },
        )
        if section.at("liens", default: ()).len() == 0 {
            html.elem("p", attrs: (class: "vide"), "Rien pour l'instant.")
        }
    }
}
