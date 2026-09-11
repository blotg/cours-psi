// #let contains(a, b) = {
//     if a == b {
//         return true
//     }
//     if type(b) == content and "body" in b.fields() {
//         return contains(a, b.body)
//     } else if type(b) == content and "children" in b.fields() {
//         return contains(a, b.children)
//     }

//     if type(a) == content {
//         if "body" in a.fields() {
//             return contains(a.body, b)
//         } else if "children" in a.fields() {
//             return contains(a.children, b)
//         } else if "num" in a.fields() and "denom" in a.fields() {
//             return contains(a.num, b) or contains(a.denom, b)
//         } else if "base" in a.fields() {
//             return contains(a.base, b)
//         } else if "child" in a.fields() {
//             return contains(a.child, b)
//         }
//     }
//     if type(a) == array and type(b) == array {
//         for décalage in range(a.len() - b.len() + 1) {
//             if a.slice(décalage, décalage + b.len()) == b {
//                 return true
//             }
//         }
//         return false
//     } else if type(a) == array {
//         for x in a {
//             if contains(x, b) {
//                 return true
//             }
//         }
//         return false
//     } else {
//         // panic(type(a) + "\n\n" + repr(a))
//         return false
//     }
// }

// #let has-symbols(block, symbols) = {
//     import "symboles.typ" as symboles
//     let d = (:)
//     for (key, value) in symbols {
//         if contains(block, eval(key, mode: "math", scope: dictionary(symboles))) {
//             d.insert(key, value)
//         }
//     }
//     for (key1, _) in d {
//         for (key2, _) in d {
//             if key1 == key2 { continue }
//             if contains(eval(key1, mode: "math", scope: dictionary(symboles)), eval(
//                 key2,
//                 mode: "math",
//                 scope: dictionary(symboles),
//             )) {
//                 d.remove(key2)
//             }
//         }
//     }
//     return d
// }

// Le scope commun à toutes les chaines que le paquet évalue — titres,
// hypothèses, flashcards, questions de colle, coups de pouce, significations.
//
// Les symboles du cours, et les enveloppes de dessin de cetz.typ : un schéma
// glissé dans une flashcard doit pouvoir s'écrire `circuit(…)` plutôt que
// `zap.circuit(…)`, et surtout porter par elle l'étiquette <canvas>, sans
// laquelle il sort vide en HTML — la carte Anki de l'oscillateur de Wien n'en
// montrait qu'un cadre vide.
//
// Les symboles passent en second : à nom égal ce sont eux qui l'emportent,
// comme avant l'ajout des dessins.
#let scope-des-chaines = {
    import "symboles.typ" as symboles
    import "cetz.typ" as dessins
    import "unités.typ" as unités
    dictionary(dessins) + dictionary(symboles) + dictionary(unités)
}

#let sub-dictionary(d, keys) = {
    let d2 = (:)
    for key in keys {
        if key in d {
            d2.insert(key, d.at(key))
        } else {
            panic("Key '" + key + "' not found in dictionary.")
        }
    }
    return d2
}

// Typst ne compose une chaine que telle qu'elle est écrite : ni correction
// typographique (' → ’, « … », --- → —), ni syntaxe de markup. Les titres, les
// titres d'exercices et les hypothèses arrivent ici sous forme de chaines ; on
// les évalue en markup au moment de les afficher, comme le sont déjà les
// significations, les flashcards, les questions de colle et les coups de pouce.
// Le scope leur ouvre les symboles du paquet : un titre peut donc contenir
// $E_c$, #ce("H2O") ou *gras*, au prix d'un antislash devant un # ou une * qui
// se voudraient littéraux.
// Les titres de chapitre d'infos.yml sont des blocs YAML de deux lignes (le
// numéro du chapitre, puis son intitulé) : en markup un simple passage à la
// ligne n'est qu'une espace, on rétablit donc la coupure ligne par ligne.
#let markup(x) = if type(x) == str {
    x.split("\n").map(l => eval(l, mode: "markup", scope: scope-des-chaines)).join(linebreak())
} else { x }

// Graine entière tirée d'un texte, pour `suiji`.
//
// Les tirages du paquet doivent être **déterministes** : le même texte donne
// la même graine, donc le même résultat d'une compilation à l'autre — pas
// d'aléa d'horloge, un `git diff` sur un PDF reste lisible. Mais ils partent
// d'un texte (le titre d'un exercice, l'énoncé d'une question) là où suiji
// veut un entier de 32 bits : d'où ce repli.
//
// Ce n'est **pas** un générateur — c'est suiji qui tire, et lui seul. On ne
// demande ici qu'une chose : que deux textes différents donnent deux graines
// différentes. Une somme d'octets ne suffirait pas (les anagrammes
// collisionnent), le facteur 31 les sépare.
#let graine-du-texte(valeur) = {
    let texte = if type(valeur) == str { valeur } else { repr(valeur) }
    array(bytes(texte)).fold(0, (n, octet) => calc.rem(n * 31 + octet, 4294967296))
}
