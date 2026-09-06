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
    import "symboles.typ" as symboles
    x.split("\n").map(l => eval(l, mode: "markup", scope: dictionary(symboles))).join(linebreak())
} else { x }
