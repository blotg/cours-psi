#import "exercice.typ":*

#exercice(
  titre: "Orage",
  difficulté:1,
  numérique: false
)[
Au cours d'un orage, un éclair peut être assimilé à un conduit cylindrique rectiligne de rayon $a=qty("10","cm")$ et parcouru par un courant $I=qty("1e5","A")$ de densité volumique de courant uniforme. On supposera dans un premier temps le courant ascendant. Les effets de bord seront négligés.

#question[
  Faire un schéma et expliqué pourquoi les électrons de ce courant sont soumis à une force magnétique de Lorentz. Quel est son sens ?
][
  Des particules chargées sont en mouvement dans un champ magnétique, ils subissent donc une force de Lorentz.

  #canvas({
    import draw: *
    line( (0,0), (0,-2) )
    line( (0.5,0), (0.5,-2) )
    line( (-0.2,-1), (0.25,-0.5), (0.7,-1), stroke: red)
    content((), anchor: "west", padding:.2em, text($I$,red))
    line( (0.25,-1), (0.25,-1.5), mark:(end:"barbed"), stroke: blue)
    content((), anchor: "north", padding:.2em, text($v$,blue))
    bezier( (1,-1.5), (-0.5,-1.5), (1,-2), (-0.5,-2), mark:(start:">"), name:"arrowB")
    content( "arrowB.start", anchor: "west", padding:.2em, text($B$) )
  })

  Si le courant va vers le haut, $arrow(j)$ aussi, $arrow(v)$ vers le bas. D'après la règle de la main droite, $arrow(B)$ est selon $arrow(e)_theta$. Donc $arrow(F)=-e arrow(v)and arrow(B)$ est selon $-arrow(e)_r$.

  Dans tous les cas, la force de Lorentz est selon $-arrow(e)_r$.
]

#question[
  Exprimer le vecteur densité volumique de courant $arrow(j)$.
][
  Un électron subit une force $-e arrow(v) and arrow(B)$. Un volume $d tau$ contient $n d tau$ électrons, donc la force subie par ce volume est $d arrow(F) = -e n d tau arrow(v) and arrow(B)=arrow(j) and arrow(B) d tau$.

  La force volumique est donc $arrow(j) and arrow(B)$.
]

#question[
  Déterminer $arrow(B)$ au niveau du bord du conduit et exprimer la norme de cette force magnétique par unité de volume en fonction de $I$ et $a$.
][
  *Invariances* On se place en coordonnées cylindriques. La distribution de courant est invariante par rotation selon $theta$ et par translation selon $z$. Le champ magnétique $arrow(B)$ doit donc être aussi invariant par rotation selon $theta$ et par translation selon $z$. Donc $arrow(B)$ ne dépend que de $r$ et s'écrit sous la forme $arrow(B)(r)$

  *Symétries* Soit $M$ un point de l'espace. $(M, arrow(e)_r, arrow(e)_theta)$ est un plan de symétrie de la distribution de courant donc $arrow(B)$ lui est orthogonal. Donc $arrow(B)(r)=B(r) arrow(e)_theta$.

  *Choix du contour d'Ampère* On choisit un contour circulaire de rayon $r$ centré sur l'axe $O z$ orienté selon $arrow(e)_theta$.

  *Théorème d'Ampère* $2 pi r B = mu_0 I_"enlacé"$ donc $ arrow(B)=mu_0 I_"enlacé" / (2 pi a) arrow(e)_theta $

  Au bord du conduit : $I_"enlacé" = -I$

  Or $arrow(j)=-I/(2 pi a) arrow(e)_z$ d'où la force volumique s'écrit $ (dif f_m) / (dif tau) = - mu_0 I^2/(2 pi^2 a^3) arrow(e)_r $
]

#question[
  Le sens de la force change-t-il si le courant est descendant ?
]


#question[
  Faire l'application numérique de cette force et la comparer au poids volumique de l'air. Pourquoi les éclairs causent-ils le tonnerre#footnote[L'éclair est le résultat visible du passage du courant tandis que le tonnerre est le son produit] ?
][
  L'AN donne $qty("6e5", "N")$
]

]