// Unités et nombres, rendus par zero.
//
// Module FEUILLE : il n'importe que zero. C'est nécessaire — `scope-des-chaines`
// (helper-functions.typ) doit l'ouvrir pour que `qty(…)` marche dans une
// flashcard ou une signification de grandeur, et helper-functions est lui-même
// importé par types-documents. Poser cette couche dans types-documents fermait
// le cycle.

#import "@preview/zero:0.6.1": num as _num-zero, zi

//
// Le cours écrit ses unités en chaines — `unit("m/s")`, `qty("1.3", "T")` —
// comme le voulait unify. C'est désormais zero qui les rend, et il lit la même
// syntaxe à deux graphies près : unify notait l'ohm « O » et le micro « u ».
// D'où la table ci-dessous, qui traduit jeton par jeton, et rien de plus.
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

// Arrondi à un nombre de chiffres significatifs, appliqué à la VALEUR avant que
// zero ne la mette en forme.
//
// zero sait arrondir (`round: (mode: "figures", …)`), mais il fixe l'exposant
// sur la valeur d'entrée et ne renormalise pas la mantisse quand l'arrondi la
// porte à 10 : 9,96·10⁵ à deux chiffres sortait « 10,0·10⁵ » au lieu de
// « 1,0·10⁶ ». En arrondissant d'abord, zero voit un nombre déjà propre et
// retombe sur le bon exposant. Tout le rendu, lui, est à lui.
#let arrondi-significatif(valeur, chiffres) = {
    if type(valeur) not in (int, float) or valeur == 0 { return valeur }
    // Le pas de l'arrondi, puis `round(v / pas) * pas`. Surtout PAS l'inverse
    // (`round(v * f) / f`) : 1,2·10⁹ à un chiffre y donnait 1/10⁻⁹, soit
    // 999 999 999,999… — zero y lisait l'exposant 8 et sortait « 10·10⁸ ».
    let pas = calc.pow(10.0, int(calc.floor(calc.log(calc.abs(valeur), base: 10))) - chiffres + 1)
    calc.round(valeur / pas) * pas
}

// unify tolérait l'exposant en E majuscule (« 6.0E-2 ») ; zero, lui, refuse
// net — il y lit le début d'une incertitude asymétrique et s'arrête. Le cours
// en contient, on les ramène donc à la casse que zero attend.
#let _normalise-nombre(valeur) = if type(valeur) == str { valeur.replace("E", "e") } else { valeur }

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
#let unit(unité) = (zi.declare(normalise-unité(unité)))()

// Un nombre : `num("1.3")`, ou `num(x, chiffres: 2)` pour l'arrondir à deux
// chiffres significatifs et le mettre en notation scientifique.
#let num(valeur, chiffres: none, ..args) = {
    let valeur = _normalise-nombre(valeur)
    if chiffres == none {
        _num-zero(valeur, ..args)
    } else {
        _num-zero(arrondi-significatif(valeur, chiffres), .._réglages-chiffres(valeur, chiffres), ..args)
    }
}

// Un nombre et son unité : `qty("1.3", "T")`, ou `qty(x, "T", chiffres: 2)`.
#let qty(valeur, unité, chiffres: none, ..args) = {
    let valeur = _normalise-nombre(valeur)
    let u = zi.declare(normalise-unité(unité))
    if chiffres == none {
        u(valeur, ..args)
    } else {
        u(arrondi-significatif(valeur, chiffres), .._réglages-chiffres(valeur, chiffres), ..args)
    }
}

