#import "@local/prepa:0.1.1": *

#show: exercice.with(titre: "Modèle d'une clarinette", difficulté: 1)

Une clarinette est modélisée par un tuyau de section $S$ et de longueur $l$ contenant un fluide où la célérité du son est $c$. L'extrémité $x = 0$ est fermée (paroi rigide) ; l'extrémité $x = l$ est ouverte sur l'atmosphère, qui y impose la pression $P_0$. Au repos, la pression vaut $P_0$ et la masse volumique $rho_0$ ; la pesanteur est négligée et on se place dans l'approximation acoustique.

Le musicien injecte une onde sonore plane : il s'établit une onde stationnaire de surpression $P_1(x, t) = A_0 cos(omega t) cos(k x)$.

#figure(canvas({
  import draw: *
  line((-1, 0), (10, 0), stroke: (dash: "dash-dotted"), mark: (end: "stealth"))
  content((10, 0), anchor: "west", padding: 0.2em, $x$)
  line((8, 0.5), (0, 0.5), (0, -0.5), (8, -0.5), stroke: 1.2pt)
  line((0, 1), (8, 1), mark: (start: "stealth", end: "stealth"))
  content((4, 1), anchor: "south", $l$)
  content((8, -0.1), anchor: "north-west", padding: 0.2em, $P_0$)
}))

#question(coups-de-pouce: (
  "Le milieu est-il fini, semi-infini ou infini ? Quelle forme de solution y privilégie-t-on ?",
))[
  Pourquoi modéliser l'onde sonore par une onde stationnaire ?
][
  Le tuyau est un milieu fini (deux bords, deux conditions aux limites). Dans un milieu fini, on privilégie les solutions stationnaires : superposition d'une onde incidente et d'une onde réfléchie qui satisfont les conditions aux limites.
]

#question(coups-de-pouce: (
  "Écrire l'équation d'Euler linéarisée reliant surpression et vitesse.",
))[
  Établir le champ de vitesse dans la clarinette. A-t-on $P_1(x, t) = Z v(x, t)$ avec $Z = rho_0 c$ ?
][
  Équation d'Euler linéarisée : $rho_0 pdv(v, t) = - pdv(P_1, x) = A_0 k cos(omega t) sin(k x)$. En intégrant (constante nulle) :
  $ v(x, t) = (A_0 k)/(rho_0 omega) sin(omega t) sin(k x) = A_0/(rho_0 c) sin(omega t) sin(k x) $

  On compare : $P_1 = A_0 cos(omega t) cos(k x)$ tandis que $Z v = rho_0 c dot A_0/(rho_0 c) sin(omega t) sin(k x) = A_0 sin(omega t) sin(k x)$. Les deux ne sont pas égaux (déphasage de $pi \/ 2$ en temps et en espace) : la relation $P_1 = Z v$ n'est valable que pour une onde progressive, pas pour une onde stationnaire.
]

#question(coups-de-pouce: (
  "Attention : ici $P$ désigne la surpression, pas la pression.",
  "Condition d'adhérence en $x = 0$, continuité de la pression en $x = l$.",
))[
  Quelles sont les deux conditions aux limites ?
][
  - En $x = 0$ (paroi rigide) : condition d'adhérence, $v(0, t) = 0$ pour tout $t$. Avec l'expression trouvée, $v(0, t) = 0$ est automatiquement vérifié : c'est un nœud de vitesse (et un ventre de surpression).
  - En $x = l$ (ouverture) : la pression y est égale à la pression atmosphérique, donc la surpression est nulle, $P_1(l, t) = 0$ pour tout $t$.
]

#question(coups-de-pouce: (
  "Quelles valeurs de $k$ satisfont $P_1(l, t) = 0$ ?",
  "Relier $k$ à $omega$ par la relation de dispersion.",
))[
  Établir les pulsations qui peuvent être jouées.
][
  $P_1(l, t) = A_0 cos(omega t) cos(k l) = 0$ pour tout $t$ impose $cos(k l) = 0$, soit $k l = pi/2 + n pi$, $n in NN$. La relation de dispersion $omega = c k$ donne alors
  $ omega_n = (2 n + 1) (pi c)/(2 l), quad n in NN $
  La clarinette ne produit que les harmoniques impairs de sa fondamentale.
]

#question(coups-de-pouce: (
  "La fondamentale correspond à $n = 0$.",
))[
  La fondamentale d'une flûte de longueur $l$ est $omega_f = pi c \/ l$. Comparer la hauteur du son d'une flûte et d'une clarinette de même longueur.
][
  Pour la clarinette, la fondamentale ($n = 0$) est $omega_c = pi c \/ (2 l) = omega_f \/ 2$. À longueur égale, la clarinette (fermée–ouverte) sonne #strong[une octave plus bas] que la flûte (ouverte–ouverte).
]
