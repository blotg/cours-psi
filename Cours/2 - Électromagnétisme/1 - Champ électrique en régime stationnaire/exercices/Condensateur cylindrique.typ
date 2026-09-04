#import "@local/prepa:0.1.1": *

#show: exercice.with(titre: "Condensateur cylindrique", difficulté: 1)

Un condensateur cylindrique est constitué de deux armatures coaxiales de hauteur $h$. L'armature intérieure, de rayon $R_1$, porte la charge $Q$ ; l'armature extérieure, de rayon $R_2$, porte la charge $-Q$. L'espace entre les armatures est vide et on néglige les effets de bord.

#question[
  Que signifie « négliger les effets de bord » ?
][
  Cela revient à traiter les armatures comme des cylindres de longueur infinie : le champ est alors purement radial, ne dépend que de $r$ et ne présente ni composante selon l'axe ni dépendance en $z$. Cette approximation est valable loin des extrémités, lorsque $h gt.double R_2$.
]

#question(coups-de-pouce: (
  "Effectuer les quatre étapes : invariances, symétries, choix de la surface de Gauss, théorème de Gauss.",
))[
  Établir l'expression du champ électrique en tout point de l'espace.
][
  Invariances (cylindre infini) et symétries donnent $va(E) = E(r) va(e_r)$. On prend pour surface de Gauss un cylindre coaxial de rayon $r$ et de hauteur $ell$. Le flux vaut $E(r) times 2 pi r ell$ (les bases ne contribuent pas).

  #strong[Pour $R_1 < r < R_2$ :] la charge intérieure est la fraction $ell \/ h$ de l'armature interne, $Q_"int" = Q ell \/ h$ :
  $ va(E) = Q/(2 pi epsilon_0 h r) va(e_r) $

  #strong[Pour $r < R_1$ :] $Q_"int" = 0$, donc $va(E) = va(0)$.

  #strong[Pour $r > R_2$ :] $Q_"int" = Q - Q = 0$, donc $va(E) = va(0)$.
]

#question(coups-de-pouce: (
  "Utiliser la circulation de $va(E)$ d'une armature à l'autre.",
))[
  Établir l'expression de la différence de potentiel entre les deux armatures.
][
  $ V(R_1) - V(R_2) = integral_(R_1)^(R_2) va(E) dot va(dd(l)) = integral_(R_1)^(R_2) Q/(2 pi epsilon_0 h r) dd(r) = Q/(2 pi epsilon_0 h) ln(R_2/R_1) $
]

#question[
  En déduire l'expression de la capacité du condensateur cylindrique.
][
  $ C = Q/(V(R_1) - V(R_2)) = (2 pi epsilon_0 h)/(ln(R_2 \/ R_1)) $
]
