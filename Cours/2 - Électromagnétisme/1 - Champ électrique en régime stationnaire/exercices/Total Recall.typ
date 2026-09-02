#import "@local/prepa:0.1.1": *

#show: exercice.with(titre: "Total Recall : Mémoires programmées", difficulté: 2, ouvert: true)

Dans le film #emph[Total Recall : Mémoires programmées] (2012), les ouvriers empruntent quotidiennement un train gravitationnel, « The Fall », qui traverse la Terre de part en part. Ce train n'est mû que par la gravité et tombe en chute libre jusqu'à sa destination, qu'il atteint en $qty("12", "min")$.

Données : masse de la Terre $qty("6.0e24", "kg")$ ; rayon de la Terre $qty("6400", "km")$.

#question(coups-de-pouce: (
  "Champ de gravitation à l'intérieur d'une Terre de masse volumique uniforme : théorème de Gauss gravitationnel.",
  "Montrer que le mouvement le long d'un diamètre est harmonique.",
))[
  Cette durée est-elle vraisemblable ?
][
  On modélise la Terre par une boule de masse volumique uniforme. À l'intérieur ($r <= R$), le théorème de Gauss gravitationnel donne $g(r) times 4 pi r^2 = - 4 pi cal(G) M_"int"$ avec $M_"int" = M_T r^3 \/ R^3$, soit
  $ va(g)(r) = - (cal(G) M_T)/R^3 r va(e_r) $

  Le long d'un diamètre, un wagon de masse $m$ repéré par son abscisse $x$ subit $m dot.double(x) = - (cal(G) M_T m)/R^3 x$ : c'est un oscillateur harmonique de pulsation
  $ omega = sqrt((cal(G) M_T)/R^3) $
  Le trajet d'un bout à l'autre correspond à une demi-période :
  $ tau = pi/omega = pi sqrt(R^3/(cal(G) M_T)) approx pi sqrt((6.4 times 10^6)^3/(6.67 times 10^(-11) times 6.0 times 10^(24))) approx qty("2.5e3", "s") approx qty("42", "min") $

  Le résultat ne dépend ni de la masse du wagon ni du diamètre choisi : c'est toujours environ $42$ minutes. La durée de $12$ min annoncée dans le film n'est donc pas vraisemblable pour un train purement gravitationnel (il faudrait une gravité effective une dizaine de fois plus forte, ou une propulsion).
]
