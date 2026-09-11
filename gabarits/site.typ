// Briques communes aux pages du site (cf. outils/site.py).
//
// Tout le contenu du site sort de `typst compile --format html` : ces pages ne
// sont pas une reconstruction du cours en HTML, ce sont les sources du cours
// compilées vers une autre cible. Les formules deviennent du MathML, les
// schémas cetz/zap des SVG, et le reste des balises ordinaires que
// `site.css` habille.

#import "@local/prepa:0.1.1": *

// -- Ce que typst ne sait pas convertir tout seul ---------------------------

// `grid` et `stack` sont de la mise en page : typst les *efface* à l'export
// HTML, avec tout leur contenu (« grid was ignored during HTML export »).
// C'est ce qui vidait la liste de matériel et le barème des évaluations des
// TP, et la double colonne d'hypothèses des points clés. On les rend en
// grille CSS, en reportant les pistes de colonnes.
#let _piste(t) = if type(t) == fraction { "minmax(0, " + repr(t) + ")" } else { "auto" }

#let _colonnes(c) = if type(c) == int {
    "repeat(" + str(c) + ", minmax(0, 1fr))"
} else if type(c) == array and c.len() > 0 {
    c.map(_piste).join(" ")
} else {
    "minmax(0, 1fr)"
}

// Les enfants d'un grid/stack, un div par cellule. `exclus` écarte ce qui n'en
// est pas une : ressorts d'un stack, filets verticaux d'un grid. Un filet
// horizontal, lui, se garde : c'est le trait qui sépare le total du reste d'un
// barème. Il devient un div qui court sur toute la largeur de la grille.
#let _cellules(enfants, exclus) = {
    // Les accolades ne sont pas décoratives : en markup, un `#let f() = expr`
    // s'arrête à la fin de ligne, et le `.filter(...)` suivant redeviendrait
    // du texte.
    enfants
        .filter(c => not (c.func() in exclus))
        .map(c => if c.func() == grid.hline {
            html.elem("div", attrs: (class: "filet-grille"), none)
        } else {
            html.elem("div", if c.func() == grid.cell { c.body } else { c })
        })
        .join()
}

// Un tracé cetz/zap est de la mise en page : sans `html.frame`, il sort une
// balise vide. Le frame le rend en SVG, à sa taille naturelle.
//
// Les images, elles, ne passent PAS par html.frame : typst les exporte
// nativement en `<img src="data:...">`, légende comprise. Les y faire passer
// écrasait la figure sur une bande de quelques millimètres de haut, parce
// qu'une largeur relative (`width: 90%`) n'a rien à quoi se rapporter dans un
// frame — c'est ce qui « mangeait » les copies d'écran des TP.
#let styles-html(doc) = {
    show <canvas>: html.frame
    // Une zone quadrillée est une réserve pour écrire à la main : sur le site,
    // elle ne serait qu'un grand vide.
    show <carreaux>: none
    // `target()` est indispensable : dans un html.frame, la cible redevient
    // « paged » et la grille doit rester une vraie grille typst, sinon les
    // schémas partent en morceaux.
    show grid: it => context if target() == "html" {
        html.elem(
            "div",
            attrs: (class: "grille", style: "grid-template-columns: " + _colonnes(it.columns)),
            _cellules(it.children, (grid.vline,)),
        )
    } else { it }
    show stack: it => context if target() == "html" {
        html.elem("div", attrs: (class: "pile"), _cellules(it.children, (h, v)))
    } else { it }
    // `underline` et `overline` sont *effacés* à l'export MathML (« underline
    // was ignored during MathML export »), sans laisser la moindre trace : le
    // trait des grandeurs complexes ($underline(Z)$, $underline(k)$) et celui
    // des longueurs algébriques ($overline(A B)$) disparaissaient, et plus
    // rien ne distinguait $underline(Z)$ de $Z$ — deux choses différentes.
    //
    // On les rejoue en CSS sur un `<mrow>`, que `html.elem` sait insérer au
    // milieu d'une formule. C'est le seul balisage qui tienne dans les deux
    // moteurs : Firefox ignore `text-decoration` sur du MathML, et Chromium
    // n'étire pas le trait d'un `<munder>` au-delà de la base — sur
    // $underline(Z_(e q))$ il ne restait qu'une encoche sous l'indice. Une
    // bordure, elle, suit la boite entière partout (cf. site.css).
    //
    // Le garde `target()` vaut ici comme pour les grilles : dans un
    // `html.frame`, la cible redevient « paged » et le trait doit rester
    // celui de typst, sinon les étiquettes des schémas le perdraient.
    show math.underline: it => context if target() == "html" {
        html.elem("mrow", attrs: (class: "souligné"), it.body)
    } else { it }
    show math.overline: it => context if target() == "html" {
        html.elem("mrow", attrs: (class: "surligné"), it.body)
    } else { it }
    // Même effacement pour `cancel`, et là c'est le sens qui part avec le
    // trait : sans lui, « $dd(U, 2) + cancel(dd(E_c, 2))$ » se lit comme si le
    // terme comptait encore. Les sept corrigés qui simplifient ainsi
    // annonçaient donc le contraire de ce qu'ils démontrent.
    show math.cancel: it => context if target() == "html" {
        html.elem("mrow", attrs: (class: "barré"), it.body)
    } else { it }
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

// -- Volets à découvrir -----------------------------------------------------

// Sur le papier, `#question` range ses coups de pouce dans une métadonnée et
// ne les imprime jamais : c'est le professeur qui les distribue. Le site, lui,
// les affiche — comme les corrigés — mais floutés : il faut tenir le survol,
// ou l'appui sur écran tactile, le temps du délai. Le geste remplace la
// demande d'aide, et on ne tombe pas sur la solution en faisant défiler.
//
// Chaque classe de volet porte son délai dans site.css (`--délai`) : c'est là
// qu'il se change, en un seul endroit.
#let _volet(classe, titre, corps) = html.elem(
    "div",
    attrs: (
        class: "volet " + classe,
        // Au clavier, le focus révèle sans attendre.
        tabindex: "0",
        // iOS n'applique `:active` à un élément quelconque que s'il porte un
        // gestionnaire tactile. Sans cet attribut vide, l'appui prolongé ne
        // révèle rien sur iPhone.
        ontouchstart: "",
    ),
    {
        html.elem("div", attrs: (class: "volet-titre"), titre)
        html.elem("div", attrs: (class: "volet-texte"), corps)
    },
)

#let coups-de-pouce(it) = {
    let liste = it.value.at("coups-de-pouce", default: ())
    if liste.len() == 0 { return }
    html.elem(
        "div",
        attrs: (class: "volets"),
        for (i, texte) in liste.enumerate() {
            _volet("pouce", "Coup de pouce " + str(i + 1), markup(texte))
        },
    )
}

// Le corrigé vient après les coups de pouce — `question()` émet sa métadonnée
// avant lui exprès — et se mérite trois fois plus longtemps.
#let corrigé(it) = html.elem("div", attrs: (class: "volets"), _volet("corrige", "Corrigé", it))

// -- Gabarit de page --------------------------------------------------------

#let page-site(titre: "", fil: (), corrigés: true, doc) = {
    set document(title: titre)
    show: styles-html
    show <coups-de-pouce>: coups-de-pouce
    show <correction>: it => if corrigés { corrigé(it) } else { none }

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
//      "sections": [{"titre": "...", "url": "...", "liens": [{"texte": "...",
//                       "url": "...", "détail": "...", "marque": "...",
//                       "infobulle": "..."}]}]}
//
// `marque` est la pastille de tête (numéro de chapitre) ; `détail` la mention
// grise de queue (poids d'un fichier, type et difficulté d'un exercice), que
// l'`infobulle` met en mots au survol. Une section peut porter une `url` au
// lieu de liens : son titre devient alors le lien — c'est le cas d'un thème
// qui tient en un seul chapitre du même nom, où la liste ne ferait que
// répéter l'intitulé.
#let page-liens(données) = {
    show: page-site.with(
        titre: données.titre,
        fil: données.at("fil", default: ()).map(e => (e.at(0), e.at(1))),
    )
    html.elem("h1", markup(données.titre))
    for section in données.at("sections", default: ()) {
        let url = section.at("url", default: "")
        if "titre" in section and section.titre != "" {
            html.elem("h2", if url == "" { markup(section.titre) } else { lien(url, markup(section.titre)) })
        }
        if url != "" { continue }
        let liens = section.at("liens", default: ())
        if liens.len() == 0 {
            html.elem("p", attrs: (class: "vide"), "Rien pour l'instant.")
            continue
        }
        html.elem(
            "ul",
            attrs: (class: "liens"),
            for l in liens {
                html.elem("li", {
                    let marque = l.at("marque", default: "")
                    if marque != "" { html.elem("span", attrs: (class: "marque"), markup(marque)) }
                    lien(l.url, markup(l.texte))
                    let détail = l.at("détail", default: "")
                    if détail != "" {
                        let infobulle = l.at("infobulle", default: "")
                        let attrs = (class: "détail")
                        if infobulle != "" { attrs.insert("title", infobulle) }
                        html.elem("span", attrs: attrs, markup(détail))
                    }
                })
            },
        )
    }
}
