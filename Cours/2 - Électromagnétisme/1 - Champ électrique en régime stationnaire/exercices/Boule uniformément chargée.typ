#import "@local/prepa:0.1.1": *

#show: exercice.with(titre: "Champ et potentiel d'une boule uniformément chargée", difficulté: 1)

Une boule de centre $O$ et de rayon $R$ est uniformément chargée ; sa charge totale est $Q$. On rappelle l'expression du gradient en coordonnées sphériques :
$ grad f = pdv(f, r) va(e_r) + 1/r pdv(f, theta) va(e_theta) + 1/(r sin theta) pdv(f, phi) va(e_phi) $

#question(coups-de-pouce: (
  "Déterminer d'abord le champ électrique, puis en déduire le potentiel.",
  "Effectuer les quatre étapes : invariances, symétries, choix de la surface de Gauss, théorème de Gauss.",
  "Pour la charge intérieure, distinguer $r < R$ et $r > R$.",
  "Déterminer la constante d'intégration pour $r > R$ (potentiel nul à l'infini), puis celle pour $r < R$ par continuité de $V$ en $r = R$.",
))[
  Déterminer le champ électrique puis le potentiel électrique en tout point de l'espace. Le potentiel est pris nul loin de la boule.
][
  #strong[Invariances.] La distribution est invariante par toute rotation autour de $O$ : $va(E)$ ne dépend que de $r$.

  #strong[Symétries.] Tout plan contenant $O$ et $M$ est plan de symétrie de la distribution : $va(E)(M)$ appartient à leur intersection, donc $va(E) = E(r) va(e_r)$.

  #strong[Surface de Gauss.] Sphère $S$ de centre $O$ et de rayon $r$. Le théorème de Gauss donne
  $ E(r) times 4 pi r^2 = Q_"int"/epsilon_0 $

  #strong[Pour $r > R$ :] $Q_"int" = Q$, d'où
  $ va(E) = Q/(4 pi epsilon_0 r^2) va(e_r) $

  #strong[Pour $r < R$ :] $Q_"int" = Q r^3/R^3$, d'où
  $ va(E) = (Q r)/(4 pi epsilon_0 R^3) va(e_r) $

  #strong[Potentiel.] Par symétrie $V = V(r)$ et $va(E) = - grad V = - dv(V, r) va(e_r)$.

  Pour $r > R$ : $dv(V, r) = - Q/(4 pi epsilon_0 r^2)$ donne $V(r) = Q/(4 pi epsilon_0 r) + K$. Comme $V -> 0$ quand $r -> +oo$, $K = 0$ :
  $ V(r) = Q/(4 pi epsilon_0 r) $

  Pour $r < R$ : $dv(V, r) = - (Q r)/(4 pi epsilon_0 R^3)$ donne $V(r) = - (Q r^2)/(8 pi epsilon_0 R^3) + K'$. La continuité de $V$ en $r = R$ impose $K' = (3 Q)/(8 pi epsilon_0 R)$, d'où
  $ V(r) = Q/(8 pi epsilon_0 R^3) (3 R^2 - r^2) $
]

#question[
  Tracer $E(r)$ et $V(r)$ en fonction de $r$.
][
  $E$ croît linéairement de $0$ à $E(R) = Q/(4 pi epsilon_0 R^2)$, puis décroit en $1/r^2$. $V$ est une parabole décroissante de $V(0) = (3 Q)/(8 pi epsilon_0 R)$ à $V(R) = Q/(4 pi epsilon_0 R)$, puis décroit en $1/r$. $E$ est continu, $V$ est continu et de dérivée continue.

  #figure(canvas({
    import cetz.draw: *
    let R = 2.0
    // E(r)
    let E(r) = if r < R { r / R } else { calc.pow(R / r, 2) }
    plot.plot(
      size: (5.5, 3.5),
      x-label: $r$,
      y-label: $E(r)$,
      x-tick-step: none,
      y-tick-step: none,
      x-ticks: ((R, $R$),),
      axis-style: "left",
      { plot.add(domain: (0, 6), samples: 200, E, style: (stroke: blue + 1.5pt)) },
    )
  }))

  #figure(canvas({
    import cetz.draw: *
    let R = 2.0
    let V(r) = if r < R { (3 * R * R - r * r) / (2 * R * R * R) } else { 1 / r }
    plot.plot(
      size: (5.5, 3.5),
      x-label: $r$,
      y-label: $V(r)$,
      x-tick-step: none,
      y-tick-step: none,
      x-ticks: ((R, $R$),),
      axis-style: "left",
      { plot.add(domain: (0, 6), samples: 200, V, style: (stroke: olive + 1.5pt)) },
    )
  }))
]
