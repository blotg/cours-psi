#import "symboles.typ" as symboles

#let contains(a, b) = {
    if a == b {
        return true
    }
    if type(b) == content and "body" in b.fields() {
        return contains(a, b.body)
    } else if type(b) == content and "children" in b.fields() {
        return contains(a, b.children)
    }

    if type(a) == content {
        if "body" in a.fields() {
            return contains(a.body, b)
        } else if "children" in a.fields() {
            return contains(a.children, b)
        } else if "num" in a.fields() and "denom" in a.fields() {
            return contains(a.num, b) or contains(a.denom, b)
        } else if "base" in a.fields() {
            return contains(a.base, b)
        } else if "child" in a.fields() {
            return contains(a.child, b)
        }
    }
    if type(a) == array and type(b) == array {
        for décalage in range(a.len() - b.len() + 1) {
            if a.slice(décalage, décalage + b.len()) == b {
                return true
            }
        }
        return false
    } else if type(a) == array {
        for x in a {
            if contains(x, b) {
                return true
            }
        }
        return false
    } else {
        // panic(type(a) + "\n\n" + repr(a))
        return false
    }
}

#let has-symbols(block, symbols) = {
    import "symboles.typ" as symboles
    let d = (:)
    for (key, value) in symbols {
        if contains(block, eval(key, mode: "math", scope: dictionary(symboles))) {
            d.insert(key, value)
        }
    }
    for (key1, _) in d {
        for (key2, _) in d {
            if key1 == key2 { continue }
            if contains(eval(key1, mode: "math", scope: dictionary(symboles)), eval(
                key2,
                mode: "math",
                scope: dictionary(symboles),
            )) {
                d.remove(key2)
            }
        }
    }
    return d
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
