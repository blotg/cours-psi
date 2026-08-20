#set text(
  font: "New Computer Modern",
  lang: "fr"
)

#let avecCorrection = true
// #let avecCorrection = false
#show label("correction"): it => if avecCorrection [#it] else []

#include "orage.typ"
#include "bobine torique.typ"
#include "coaxial.typ"