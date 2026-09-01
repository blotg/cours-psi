#import "@local/prepa:0.1.1": *

#exercice(
  titre: "Entrée dans un IRM",
  ouvert: true,
)[

#figure[
  #image(width: 40%, "../images/irm.jpg")
]

Le champ magnétique dans un IRM est stationnaire et de l'ordre de #qty("1","T"). La conductivité électrique du corps humain est de l'ordre de #qty("0.2","S/m").

Lors de l'entrée dans la machine, le patient se déplace à une vitesse d'environ #qty("0.2","m/s").

#question(coups-de-pouce:(
  "On peut modéliser le corps humain par un cylindre dont il faudra estimer les dimensions.",
  "L'expression de la puissance dissipée par les courants de Foucault dans un cylindre conducteur soumis à un champ magnétique variable devra être a été établie en cours.",
  "Bien que le champ magnétique de l'IRM soit stationnaire dans le référentiel de la salle, il varie dans le référentiel du patient en mouvement.",
  "On peut approximer le champ dans le référentiel du patient par un signal sinusoïdal. Estimer la durée nécessaire pour passer du minimum au maximum.",
))[
  La chaleur dégagée par les courants de Foucault lors de l'entrée dans la machine est-elle dangereuse ?
][
  On modélise le corps humain par un cylindre conducteur de rayon $R = #qty("0.2","m")$ et de hauteur $h = #qty("1.7","m")$.
  
  #let pulsation = 2 * calc.pi / 10
  On estime la taille de l'IRM à #qty("1","m"). Le temps d'entrée dans la machine est donc $Delta t = L/v = #qty("5","s")$. Cette durée est la durée nécessaire pour passer du champ magnétique minimal au champ maximal. Pour un signal sinusoïdal, il s'agirait de la demi période. On note donc $T=qty("10","s")$. La pulsation associée est donc $omega = 2 pi / T = qty(scientifique(#pulsation,#1),"rad/s")$.

  #let P = calc.pi * 0.2 * calc.pow(pulsation,2) * 1.7 * calc.pow(0.2,4) / 16
  La puissance moyenne dissipée par les courants de Foucault s'écrit alors
  $ P_text("moy") approx (pi gamma B_0^2 omega^2 h R^4)/16 = (pi dot 0.2 dot 1^2 dot 0.6^2 dot 1.7 dot 0.2^4)/16 approx qty(scientifique(#P,#1), "W")$

  Cette puissance est négligeable devant la puissance métabolique d'un être humain au repos (environ #qty("100","W")). On en conclut que la chaleur dégagée n'est pas dangereuse.

  Il se trouve que ces courants de Foucault peuvent néanmoins être la source de sensations de picotements.
]

]