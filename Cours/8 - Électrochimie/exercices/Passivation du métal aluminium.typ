#import "@local/prepa:0.1.1": *
#let cpl(a, b) = [#ce(a)\/#ce(b)]

#show: exercice.with(titre: "Passivation du métal aluminium", difficulté: 2)

Au contact de l'air, l'aluminium se couvre spontanément d'une couche d'oxyde d'aluminium(III) qui le protège. On épaissit cette couche par électrolyse dans un bain d'acide sulfurique concentré (anodisation). Donnée : masse volumique de l'oxyde d'aluminium(III) $rho = #quan[3.16 g/cm^3]$ ; $M(ce("Al")) = #quan[27 g/mol]$, $M(ce("O")) = #quan[16 g/mol]$.

#question(coups-de-pouce: (
  "Dans quelles proportions se trouvent l'aluminium (nombre d'oxydation +III) et l'oxygène (−II) dans un oxyde neutre ?",
  "Écrire la demi-équation entre l'oxyde d'aluminium(III) et l'aluminium solide, puis la combiner avec un couple de l'eau.",
))[
  Quelle est la formule de l'oxyde d'aluminium(III) ? En déduire l'équation de la réaction électrochimique d'obtention de l'oxyde.
][
  Neutralité : $2 times (+3) + 3 times (-2) = 0$, donc #ce("Al2O3").

  Demi-équation (l'aluminium passe de $0$ à $+"III"$, il est oxydé) :
  $ 2 ce("Al") + 3 ce("H2O") -> ce("Al2O3") + 6 ce("H+") + 6 e^- $
  C'est la réaction anodique ($n = 6$).
]

#question(coups-de-pouce: (
  "Intégrer $i = - n cal(F) dv(xi, t)$ pour l'avancement, puis passer à la masse, au volume, à l'épaisseur.",
))[
  On impose une densité de courant $j = #quan[1 A/dm^2]$. Quelle est l'épaisseur de la couche d'alumine après $#quan[10 min]$ d'électrolyse ?
][
  Par unité de surface, la charge est $q = j thin t = 100 times 600 = #quan[6e4 C/m^2]$ (avec $j = #quan[1 A/dm^2] = #quan[100 A/m^2]$).

  Quantité d'#ce("Al2O3") formée par unité de surface : $n = q \/ (6 cal(F)) = 6 times 10^4 \/ (6 times 96500) approx #quan[0.104 mol/m^2]$.

  Avec $M(ce("Al2O3")) = 2 times 27 + 3 times 16 = #quan[102 g/mol]$, la masse par unité de surface est $#quan[10.6 g/m^2]$, le volume $10.6 \/ (3.16 times 10^6) approx #quan[3.4e-6 m^3/m^2]$, soit une épaisseur
  $ e approx #quan[3.4 um] $
]

#question(coups-de-pouce: (
  "Reprendre la formule littérale et calculer l'épaisseur théorique.",
  "Qu'est-ce qui peut faire que tout le courant ne participe pas à la passivation ?",
))[
  Un manuel indique : « avec $j = #quan[150 A/m^2]$, la couche atteint $#quan[10 um]$ en $#quan[30 min]$ ». Est-ce en accord avec l'étude théorique ? Sinon, proposer une explication.
][
  Théorie : $q = 150 times 1800 = #quan[2.7e5 C/m^2]$, $n = 2.7 times 10^5 \/ (6 times 96500) approx #quan[0.47 mol/m^2]$, masse $#quan[47.6 g/m^2]$, volume $#quan[1.5e-5 m^3/m^2]$, soit $e_"théo" approx #quan[15 um]$.

  Le manuel annonce $#quan[10 um]$, soit nettement moins. Le rendement faradique n'est donc pas de $#quan[100 %]$ : $rho_F approx 10 \/ 15 approx #quan[67 %]$. Une partie du courant sert au dégagement de #ce("O2") à l'anode (réaction parasite), et une partie de l'alumine formée se dissout dans l'acide sulfurique concentré.
]
