#import "/gabarits/site.typ": *

#let TRAIT = "\u{0332}"

#let souligne(c) = {
  let f = c.func()
  let champs = c.fields()
  if "text" in champs and champs.text.len() > 0 {
    let g = champs.text.clusters()
    return text(g.first() + TRAIT + g.slice(1).join())
  }
  if f == [].func() {
    let enfants = champs.at("children", default: ())
    for (i, e) in enfants.enumerate() {
      let neuf = souligne(e)
      if neuf != none {
        return enfants.slice(0, i).join() + neuf + enfants.slice(i + 1).join()
      }
    }
    return none
  }
  if f == math.attach {
    let neuf = souligne(champs.base)
    if neuf == none { return none }
    let reste = champs
    let _ = reste.remove("base")
    return math.attach(neuf, ..reste)
  }
  // `styled` n'a pas de constructeur public : on ne peut pas le rebâtir. On
  // descend donc dedans et on rend l'enfant nu — à vérifier à l'œil.
  if "child" in champs {
    return souligne(champs.child)
  }
  if f == math.accent {
    let neuf = souligne(champs.base)
    if neuf == none { return none }
    return math.accent(neuf, champs.accent)
  }
  none
}

#let formes = json(bytes(sys.inputs.formes))
#let scope = (:)

#for (i, s) in formes.enumerate() [
  #let corps = eval(s, mode: "math", scope: scope-des-chaines).body
  #raw(s) ¦ $#corps$ ¦ #{
    let n = souligne(corps)
    if n == none [ÉCHEC] else [$#n$]
  } ¦#linebreak()
]
