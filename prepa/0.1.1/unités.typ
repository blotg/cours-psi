// Unités et nombres, rendus par zero.
//
// Module FEUILLE : il n'importe que zero. C'est nécessaire — `scope-des-chaines`
// (helper-functions.typ) doit l'ouvrir pour que `quan[…]` marche dans une
// flashcard ou une signification de grandeur, et helper-functions est lui-même
// importé par types-documents. Poser cette couche dans types-documents fermait
// le cycle.

#import "@preview/zero:0.7.0": num as _num-zero, format-table, zi, quan as _quan-zero, impl

//
// Une grandeur écrite en toutes lettres suit la syntaxe de zero :
// `#quan[1.3 T]`, `#quan[4.7 kΩ]`, `#quan[20 °C]`. En mode maths aussi, le `#`
// est obligatoire : `$quan[1 s]$` ne serait pas un appel de fonction, et
// imprimerait « quan[1 s] » sans erreur.
//
// `unit("m/s")` et les grandeurs calculées, `qty(x, "T", chiffres: 2)`, gardent
// la syntaxe de chaine d'unify, que zero lit à deux graphies près : unify notait
// l'ohm « O » et le micro « u ». D'où la table ci-dessous, qui traduit jeton par
// jeton, et rien de plus.
//
// zero fait mieux qu'unify sur deux points au passage : `zi.declare` rend
// « tr/min » et « an » sans rien déclarer, là où unify les perdait
// silencieusement malgré ses `add-unit` — « 1500 tr/min » sortait
// « 1500 min⁻¹ », et « 8,9 an » sortait sans unité du tout.

#let UNITÉS-COMPLÉMENTAIRES = (
    // L'ohm : unify l'écrivait « O », zero veut le symbole.
    "O": "Ω",
    "kO": "kΩ",
    "MO": "MΩ",
    "mO": "mΩ",
    "ohm": "Ω",
    // Le micro : « u » chez unify, « mu » chez zero.
    "um": "mum",
    "uF": "muF",
    "us": "mus",
    "uH": "muH",
    "uA": "muA",
    "uV": "muV",
    "uC": "muC",
    "uL": "muL",
    // Le degré et le degré Celsius, sous les graphies en usage dans le cours.
    "Celsius": "°C",
    "dC": "°C",
    "deg": "°",
)

// Traduit une unité écrite à la mode d'unify en une unité que zero comprend.
//
// On découpe sur les espaces puis sur les barres de fraction, et on ne
// remplace que des jetons entiers : « USI » ne doit pas devenir « mSI » parce
// qu'il commence par un u, et « mol/s » ne doit pas voir son « s » touché.
// L'exposant reste collé au jeton (« uF^2 » se lit « uF » puis « ^2 »).
#let normalise-unité(chaine) = {
    chaine
        .split(" ")
        .map(morceau => morceau
            .split("/")
            .map(part => {
                let m = part.match(regex("^([^\^]*)(\^.*)?$"))
                let base = if m == none { part } else { m.captures.at(0) }
                let exposant = if m == none or m.captures.at(1) == none { "" } else { m.captures.at(1) }
                UNITÉS-COMPLÉMENTAIRES.at(base, default: base) + exposant
            })
            .join("/"))
        .join(" ")
}

// zero 0.7.0 décrit chaque unité pour les lecteurs d'écran, et arrête la
// compilation (« Failed to auto-generate alt description ») sur un symbole
// qu'il ne connait pas. Les unités hors SI du cours reçoivent leur description
// ici. Le poiseuille n'est connu que du dictionnaire français de zero : les
// flashcards Anki, exportées en HTML sans `lang: "fr"`, butaient dessus.
#let UNITÉS-HORS-SI = (
    "an": "an",
    "bar": "bar",
    "cal": "calorie",
    "kcal": "kilocalorie",
    "Pl": "poiseuille",
    "tog": "tog",
    "tr": "tour",
    "USI": "unité SI",
)

// La description d'une unité qui contient un symbole hors SI (« tr/min » donne
// « tour par min ») ; `auto` sinon, et zero la génère lui-même.
#let _description(unité) = {
    let symbole(jeton) = jeton.split("^").first()
    let jetons = unité.split(regex("[ /]")).filter(j => j != "")
    if not jetons.any(j => symbole(j) in UNITÉS-HORS-SI) { return auto }
    unité
        .split("/")
        .map(morceau => morceau
            .split(" ")
            .filter(j => j != "")
            .map(j => UNITÉS-HORS-SI.at(symbole(j), default: j))
            .join(" "))
        .filter(m => m != "")
        .join(" par ")
}

// Une grandeur écrite en toutes lettres : `quan[1.3 T]`, `quan[1500 tr/min]`.
//
// C'est le `quan` de zero, qui n'accepte pas de description : pour une unité
// hors SI, on sépare la valeur de l'unité (le cours met toujours une espace
// entre les deux) et on passe par `zi.declare`, qui en accepte une.
#let quan(entrée) = {
    let texte = if type(entrée) == content { impl.parsing.content-to-string(entrée) } else { entrée }
    let (tête, ..reste) = texte.trim().split(" ")
    let (valeur, unité) = if tête.contains(regex("\d")) {
        (tête, reste.join(" "))
    } else {
        (none, texte.trim())
    }
    let description = if unité == none { auto } else { _description(unité) }
    if description == auto {
        _quan-zero(entrée)
    } else if valeur == none {
        (zi.declare(unité, alt: description))()
    } else {
        (zi.declare(unité, alt: description))(valeur)
    }
}

// Arrondi à un nombre de chiffres significatifs, appliqué à la VALEUR avant que
// zero ne la mette en forme.
//
// zero sait arrondir (`round: (mode: "figures", …)`), mais il fixe l'exposant
// sur la valeur d'entrée et ne renormalise pas la mantisse quand l'arrondi la
// porte à 10 : 9,96·10⁵ à deux chiffres sortait « 10,0·10⁵ » au lieu de
// « 1,0·10⁶ ». En arrondissant d'abord, zero voit un nombre déjà propre et
// retombe sur le bon exposant. Tout le rendu, lui, est à lui. Toujours vrai
// avec zero 0.7.0 : 0,999 à deux chiffres y sort « 10·10⁻¹ ».
#let arrondi-significatif(valeur, chiffres) = {
    if type(valeur) not in (int, float) or valeur == 0 { return valeur }
    // Le pas de l'arrondi, puis `round(v / pas) * pas`. Surtout PAS l'inverse
    // (`round(v * f) / f`) : 1,2·10⁹ à un chiffre y donnait 1/10⁻⁹, soit
    // 999 999 999,999… — zero y lisait l'exposant 8 et sortait « 10·10⁸ ».
    let pas = calc.pow(10.0, int(calc.floor(calc.log(calc.abs(valeur), base: 10))) - chiffres + 1)
    calc.round(valeur / pas) * pas
}

// Les réglages de rendu d'un nombre à `chiffres` significatifs.
//
// `(sci: 1)` : notation scientifique dès l'exposant 1, et pas en deçà — sans
// quoi « 3,14 » sortirait « 3,14·10⁰ ». Zéro n'a pas d'exposant : on laisse
// zero à son mode ordinaire, sinon il en fabrique un (« 0,00·10⁻¹ »).
#let _réglages-chiffres(valeur, chiffres) = (
    round: (mode: "figures", precision: chiffres),
    exponent: if valeur == 0 { auto } else { (sci: 1) },
)

// Une unité seule : `unit("m/s")`.
#let unit(unité) = {
    let unité = normalise-unité(unité)
    (zi.declare(unité, alt: _description(unité)))()
}

// Un nombre calculé : `num(x, chiffres: 2)` l'arrondit à deux chiffres
// significatifs et le met en notation scientifique.
#let num(valeur, chiffres: none, ..args) = {
    if chiffres == none {
        _num-zero(valeur, ..args)
    } else {
        _num-zero(arrondi-significatif(valeur, chiffres), .._réglages-chiffres(valeur, chiffres), ..args)
    }
}

// Une grandeur calculée : `qty(x, "T")`, ou `qty(x, "T", chiffres: 2)`.
// zero n'offre pas mieux : son `quan` ne prend qu'un texte, sans arrondi, et
// l'arrondi natif de `zi.declare` bute sur la renormalisation (cf.
// `arrondi-significatif`).
//
// Un flottant de 10¹⁹ ou plus est passé en chaine « mantisse e exposant » :
// zero 0.7.0 convertit sinon sa partie entière en `int` pour la description
// et déborde (« integer value is too large »).
#let qty(valeur, unité, chiffres: none, ..args) = {
    let unité = normalise-unité(unité)
    let u = zi.declare(unité, alt: _description(unité))
    let valeur = if chiffres == none { valeur } else { arrondi-significatif(valeur, chiffres) }
    let entrée = if type(valeur) == float and calc.abs(valeur) >= 1e15 {
        let exposant = int(calc.floor(calc.log(calc.abs(valeur), base: 10)))
        repr(valeur / calc.pow(10.0, exposant)) + "e" + str(exposant)
    } else { valeur }
    if chiffres == none {
        u(entrée, ..args)
    } else {
        u(entrée, .._réglages-chiffres(valeur, chiffres), ..args)
    }
}
