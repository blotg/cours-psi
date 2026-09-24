#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Condensateur sphérique",
    difficulté: 1,
)

Un condensateur sphérique est formé de deux sphères concentriques de rayons $R_1 < R_2$, séparées par du vide.

#question(
  coups-de-pouce: (
    "Noter $Q$ la charge de l'armature intérieure et $-Q$ celle de l'armature extérieure.",
    "Effectuer une analyse des symétries et des invariances.",
    "Utiliser le théorème de Gauss.",
    "Exprimer la différence de potentiel entre les armatures.",
    "Utiliser la relation $Q = C U$."
  )
)[
    Déterminer sa capacité en fonction de $R_1$ et $R_2$. Montrer que lorsque l'écart $e = R_2 - R_1$ entre les armatures est petit devant $R_1$, on retrouve la capacité d'un condensateur plan.
][
    On note $Q$ la charge de l'armature intérieure et $-Q$ celle de l'armature extérieure.

    *Invariances.*
    La distribution est invariante par toute rotation autour du centre $O$ : $va(E)$ ne dépend que de $r$.

    *Symétries.*
    Tout plan contenant $O$ et $M$ est plan de symétrie de la distribution : $va(E)(M)$ appartient à leur intersection, donc $va(E) = E(r) va(e_r)$.

    *Théorème de Gauss.*
    Pour $R_1 < r < R_2$, la sphère de centre $O$ et de rayon $r$ contient la charge $Q$. Le théorème de Gauss donne $E(r) times 4 pi r^2 = Q \/ epsilon_0$, d'où
    $ va(E) = Q/(4 pi epsilon_0 r^2) va(e_r) $

    *Différence de potentiel.*
    On fait circuler $va(E)$ d'une armature à l'autre :
    $ U = V(R_1) - V(R_2) = integral_(R_1)^(R_2) Q/(4 pi epsilon_0 r^2) dd(r) = Q/(4 pi epsilon_0) (1/R_1 - 1/R_2) = Q/(4 pi epsilon_0) (R_2 - R_1)/(R_1 R_2) $

    *Capacité.*
    La relation $Q = C U$ donne
    $ C = (4 pi epsilon_0 R_1 R_2)/(R_2 - R_1) $

    *Limite du condensateur plan.*
    Si $e = R_2 - R_1 << R_1$, alors $R_2 approx R_1$ et $R_1 R_2 approx R_1^2$, d'où
    $ C approx (4 pi epsilon_0 R_1^2)/e = (epsilon_0 S_a)/e $
    avec $S_a = 4 pi R_1^2$ l'aire des armatures en regard. C'est la capacité d'un condensateur plan de surface $S_a$ et d'épaisseur $e$ : vues de près, deux sphères très proches ressemblent localement à deux plans parallèles.
]
