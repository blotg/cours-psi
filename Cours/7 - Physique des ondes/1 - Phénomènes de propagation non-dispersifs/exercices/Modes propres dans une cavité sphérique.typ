#import "@local/prepa:0.1.1": *

#show: exercice.with(titre: "Modes propres dans une cavité sphérique", difficulté: 3)

Un gaz de masse volumique $rho_0$ est enfermé dans une sphère rigide de rayon $R$. Une onde sonore sphérique s'y propage, décrite par la surpression $P(r, t)$ et la vitesse $v(r, t) va(e_r)$. On se place dans le cas
$ P(r, t) = A/r e^(j(omega_1 t - k_1 r)) + B/r e^(j(omega_2 t + k_2 r)) $

#question(coups-de-pouce: (
  "Pour chaque terme : stationnaire ou progressif ? harmonique ? sphérique, cylindrique ou plan ?",
))[
  Que représente chacun des termes de $P(r, t)$ ?
][
  - Premier terme : onde sphérique progressive harmonique divergente (elle se propage vers les $r$ croissants), d'amplitude $prop 1 \/ r$ (atténuation géométrique).
  - Second terme : onde sphérique progressive harmonique convergente (elle se propage vers les $r$ décroissants), également atténuée en $1 \/ r$.
]

#question(coups-de-pouce: (
  "Les ondes ne sont pas des OPPH : on ne peut pas utiliser l'impédance acoustique.",
  "Utiliser l'équation d'Euler linéarisée.",
))[
  Déterminer le champ des vitesses $underline(v)$ associé à l'onde.
][
  Équation d'Euler : $rho_0 pdv(underline(v), t) = - pdv(underline(P), r)$, soit $j rho_0 omega thin underline(v) = - pdv(underline(P), r)$ pour une dépendance temporelle en $e^(j omega t)$.

  Pour le premier terme ($omega_1$, $k_1$) : $pdv(, r)(A/r e^(- j k_1 r)) = - A/r^2 (1 + j k_1 r) e^(- j k_1 r)$, d'où
  $ underline(v)_1 = A/(j rho_0 omega_1 r^2) (1 + j k_1 r) e^(j(omega_1 t - k_1 r)) $

  Pour le second terme ($omega_2$, $k_2$) : $pdv(, r)(B/r e^(j k_2 r)) = B/r^2 (- 1 + j k_2 r) e^(j k_2 r)$, d'où
  $ underline(v)_2 = B/(j rho_0 omega_2 r^2) (1 - j k_2 r) e^(j(omega_2 t + k_2 r)) $

  et $underline(v) = underline(v)_1 + underline(v)_2$.
]

#question(coups-de-pouce: (
  "Écrire la condition d'adhérence en $r = R$ pour tout $t$.",
))[
  Établir le lien entre $omega_1$ et $omega_2$, puis entre $A$ et $B$. En déduire $underline(v)$.
][
  La condition d'adhérence sur la paroi rigide impose $underline(v)(R, t) = 0$ pour tout $t$. Deux termes de pulsations différentes ne peuvent se compenser à tout instant : nécessairement $omega_1 = omega_2 equiv omega$, donc $k_1 = k_2 equiv k = omega \/ c$.

  La condition $underline(v)_1(R) + underline(v)_2(R) = 0$ s'écrit alors
  $ A(1 + j k R) e^(- j k R) = B (- 1 + j k R) e^(j k R) $
  soit
  $ B/A = (1 + j k R)/(j k R - 1) e^(- 2 j k R) $
]

#question(coups-de-pouce: (
  "Pour que $P$ reste finie en $0$, relier simplement $A$ et $B$.",
  "Reporter dans la relation précédente et prendre l'argument.",
))[
  En supposant que la surpression ne diverge pas en $r = 0$, montrer que $k$ vérifie une équation transcendante, et expliquer comment déterminer graphiquement les valeurs de $k$ possibles.
][
  Près de $r = 0$, $P approx (A e^(- j k r) + B e^(j k r))/r thin e^(j omega t)$. Pour que $P$ reste finie, il faut $A + B = 0$, soit $B = - A$. La surpression devient
  $ P(r, t) = - 2 j A (sin(k r))/r e^(j omega t) $
  (bien finie en $0$, puisque $sin(k r) \/ r -> k$).

  En reportant $B = - A$ dans la relation du 3, ou plus directement en réinjectant $P$ dans l'équation d'Euler puis la condition $v(R, t) = 0$, on obtient
  $ v(R, t) prop k R cos(k R) - sin(k R) = 0 quad <=> quad tan(k R) = k R $

  Graphiquement, on trace $y = tan(k R)$ et $y = k R$ en fonction de $k R$ : les abscisses des intersections donnent les valeurs $k_n$ autorisées, donc les pulsations propres $omega_n = c k_n$. (En regroupant les exponentielles et en prenant l'argument, cette condition s'écrit aussi $2 k R equiv arctan((2 k R)/(1 - k^2 R^2)) thick [2 pi]$.)
]
