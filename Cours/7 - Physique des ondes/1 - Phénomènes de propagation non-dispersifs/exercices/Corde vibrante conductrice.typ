#import "@local/prepa:0.1.1": *

#show: exercice.with(titre: "Corde vibrante conductrice", difficulté: 2)

On étudie les petits mouvements transverses d'une corde métallique de longueur $L$, de masse linéique $mu$ et de tension $T$, fixée en $x = 0$ et $x = L$. Un point de la corde d'abscisse au repos $x$ se déplace de $z(x, t) va(e_z)$ au passage de l'onde ; la pesanteur est négligée. La corde est parcourue par un courant $i(t) = i_0 cos(omega t)$ et plongée dans un champ magnétique $va(B)(x) = B_0 sin((pi x)/L) va(e_y)$. On rappelle la force de Laplace sur un élément $va(dif l)$ : $va(dif f) = i va(dif l) and va(B)$.

#question(coups-de-pouce: (
  "Reprendre la démonstration de l'équation de d'Alembert de la corde, avec en plus la force de Laplace.",
))[
  Établir l'équation du mouvement sous la forme
  $ pdv(z, t, 2) - c^2 pdv(z, x, 2) = (i_0 B_0)/mu cos(omega t) sin((pi x)/L) $
  où $c$ est une constante à exprimer.
][
  On isole l'élément de corde compris entre $x$ et $x + dif x$, de masse $mu dif x$. Il subit :
  - la résultante transverse des tensions, $T pdv(z, x, 2) dif x va(e_z)$ (petits angles) ;
  - la force de Laplace : $va(dif l) approx dif x va(e_x)$, donc
    $ va(dif f) = i(t) dif x va(e_x) and B_0 sin((pi x)/L) va(e_y) = i_0 cos(omega t) B_0 sin((pi x)/L) dif x thin va(e_z) $

  La relation fondamentale de la dynamique projetée sur $va(e_z)$ donne
  $ mu dif x pdv(z, t, 2) = T pdv(z, x, 2) dif x + i_0 B_0 cos(omega t) sin((pi x)/L) dif x $
  soit, en posant $c = sqrt(T/mu)$,
  $ pdv(z, t, 2) - c^2 pdv(z, x, 2) = (i_0 B_0)/mu cos(omega t) sin((pi x)/L) $
]

#question(coups-de-pouce: (
  "Cette onde est-elle stationnaire ou progressive ?",
  "Le milieu est-il fini, semi-infini ou infini ?",
))[
  En régime sinusoïdal forcé, on cherche $z(x, t) = z_0 sin((pi x)/L) cos(omega t)$. Commenter ce choix.
][
  C'est une onde stationnaire (produit d'une fonction de $x$ et d'une fonction de $t$). Le milieu est fini : on y privilégie les solutions stationnaires. Le profil spatial $sin(pi x \/ L)$ s'annule en $x = 0$ et $x = L$ : il respecte les deux conditions aux limites strictes (corde fixée). Enfin, le second membre a exactement la même dépendance spatiale et temporelle : la réponse forcée a naturellement cette forme.
]

#question(coups-de-pouce: (
  "Injecter $z$ dans l'équation d'onde.",
  "Les hypothèses de petits déplacements sont-elles compatibles avec une amplitude qui diverge ?",
))[
  Déterminer $z_0$. Que se passe-t-il quand $omega -> pi c \/ L$ ? La modélisation reste-t-elle valable ?
][
  En injectant : $pdv(z, t, 2) = - omega^2 z$ et $pdv(z, x, 2) = - (pi/L)^2 z$, d'où
  $ (- omega^2 + c^2 (pi/L)^2) z_0 sin((pi x)/L) cos(omega t) = (i_0 B_0)/mu cos(omega t) sin((pi x)/L) $
  $ z_0 = (i_0 B_0 \/ mu)/((pi c \/ L)^2 - omega^2) $

  Quand $omega -> omega_1 = pi c \/ L$ (première pulsation propre de la corde fixée à ses deux extrémités), $z_0 -> oo$ : c'est une #strong[résonance] avec le premier mode propre.

  L'amplitude ne peut évidemment pas diverger réellement : l'hypothèse des petits déplacements (et la linéarité de la tension) cesse d'être valable, et surtout l'amortissement — négligé ici — limite l'amplitude au voisinage de la résonance.
]
