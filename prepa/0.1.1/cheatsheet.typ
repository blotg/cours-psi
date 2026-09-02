// Aide-mémoire Python.
//
//   #cheatsheet-python("np.linspace", "numpy.fft.rfft", "plt.plot", "curve_fit", …)
//
// Génère un aide-mémoire des commandes demandées à partir de
// cheatsheet-python.yaml (base à enrichir progressivement). Chaque commande
// peut être demandée sous sa forme abrégée ("np.linspace", "curve_fit") ou
// complète ("numpy.linspace", "scipy.optimize.curve_fit") — même entrée. Les
// commandes provenant d'un module abrégé ou importé sont suivies d'un appel de
// note (¹, ², …) ; les imports correspondants sont rappelés en fin d'aide-mémoire.

#let _données = yaml("cheatsheet-python.yaml")
#let _gris-cs = luma(45%)

// nom (abrégé ou complet) -> (canonique, court, stmt)
//   abrév       : module -> alias        (import module as alias  ->  alias.fonction)
//   imports-from : module -> (noms…)     (from module import nom   ->  nom)
#let _résout(nom, abrév, imports-from) = {
    let canonique = nom
    for (module, alias) in abrév {
        if nom == alias or nom.starts-with(alias + ".") {
            canonique = module + nom.slice(alias.len())
        }
    }
    for (module, noms) in imports-from {
        if nom in noms { canonique = module + "." + nom }
    }
    for (module, alias) in abrév {
        if canonique == module or canonique.starts-with(module + ".") {
            return (
                canonique: canonique,
                court: alias + canonique.slice(module.len()),
                stmt: "import " + module + " as " + alias,
            )
        }
    }
    for (module, noms) in imports-from {
        for n in noms {
            if canonique == module + "." + n {
                return (canonique: canonique, court: n, stmt: "from " + module + " import " + n)
            }
        }
    }
    (canonique: canonique, court: canonique, stmt: none)
}

// Commentaire : chaîne évaluée comme du balisage Typst (maths $…$ et code `…`
// permis). Un habillage \[ … \] facultatif — qui empêche YAML d'interpréter un
// « [ » initial comme une liste — est retiré avant l'évaluation.
#let _rendu-commentaire(c) = {
    if c == none { return none }
    let s = str(c).trim()
    if s.starts-with("\\[") and s.ends-with("\\]") { s = s.slice(2, s.len() - 2) }
    eval(s, mode: "markup")
}

#let cheatsheet-python(..noms) = {
    let abrév = _données.at("abréviations", default: (:))
    let imports-from = _données.at("imports-from", default: (:))
    let commandes = _données.at("commandes", default: (:))

    // Accepte aussi bien cheatsheet-python("a", "b") que cheatsheet-python(("a", "b")).
    let liste = noms.pos()
    if liste.len() == 1 and type(liste.first()) == array { liste = liste.first() }

    let imports-vus = () // instructions d'import, dans l'ordre de première apparition
    let cellules = ()

    for nom in liste {
        let r = _résout(nom, abrév, imports-from)
        assert(
            r.canonique in commandes,
            message: "cheatsheet-python : commande « " + nom + " » inconnue (résolue en « "
                + r.canonique + " »). À ajouter dans cheatsheet-python.yaml.",
        )
        let cmd = commandes.at(r.canonique)

        // Appel de note vers l'import nécessaire (numéroté par ordre d'apparition).
        let note = none
        if r.stmt != none {
            if r.stmt not in imports-vus { imports-vus.push(r.stmt) }
            note = imports-vus.position(s => s == r.stmt) + 1
        }

        let exemples = cmd.at("exemple", default: ())
        if type(exemples) == str { exemples = (exemples,) }
        let commentaire = _rendu-commentaire(cmd.at("commentaire", default: none))

        cellules.push(strong(raw(r.court)) + if note != none { super[#note] })
        cellules.push(stack(
            dir: ttb,
            spacing: 0.45em,
            ..exemples.map(e => raw(str(e), lang: "python")),
            ..if commentaire != none { (text(size: 0.9em, fill: _gris-cs, commentaire),) },
        ))
    }

    grid(
        columns: (auto, 1fr),
        column-gutter: 1.4em,
        row-gutter: 0.9em,
        ..cellules,
    )

    if imports-vus.len() > 0 {
        block(
            above: 0.9em,
            text(size: 0.85em, fill: _gris-cs, imports-vus
                .enumerate()
                .map(((i, s)) => [#super[#(i + 1)]~#raw(s)])
                .join(h(1.2em))),
        )
    }
}
