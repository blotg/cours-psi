#import "@local/prepa:0.1.1": *

#show: exercice.with(titre: "Mesure du champ magnétique terrestre", difficulté: 1, numérique: true)

Pour mesurer la composante horizontale du champ magnétique terrestre, on utilise une boussole. On place un solénoïde autour de la boussole, son axe étant horizontal et orthogonal à l'aiguille au repos. Lorsqu'un courant circule dans le solénoïde, l'aiguille tourne d'un angle $alpha = qty("40", "deg")$.

Données : rayon du solénoïde $R = qty("5", "cm")$, nombre de spires $N = 100$, longueur $l = qty("30", "cm")$, intensité $I = qty("1", "mA")$.

#question(coups-de-pouce: (
  "Faire un schéma vu de dessus, avec les deux champs horizontaux.",
  "L'aiguille s'aligne sur le champ magnétique horizontal total.",
))[
  Calculer la composante horizontale du champ magnétique terrestre.
][
  #figure(canvas({
    import draw: *
    line((-2.4, 0), (2.4, 0), stroke: (dash: "dashed"))
    // champ terrestre horizontal (direction initiale de l'aiguille)
    line((0, 0), (2, 0), mark: (end: "stealth"), stroke: 1pt)
    content((2, 0), anchor: "west", padding: 0.2em, $va(B)_(H)$)
    // champ du solénoïde, orthogonal
    line((0, 0), (0, 1.6), mark: (end: "stealth"), stroke: red + 1pt)
    content((0, 1.6), anchor: "south", padding: 0.2em, text(fill: red)[$va(B)_"sol"$])
    // champ total / aiguille déviée
    line((0, 0), (2, 1.6), mark: (end: "stealth"), stroke: blue + 1pt)
    content((2, 1.6), anchor: "west", padding: 0.2em, text(fill: blue)[$va(B)_"tot"$])
    arc((0.9, 0), start: 0deg, stop: 38deg, radius: 0.9)
    content((1.15, 0.35), $alpha$)
  }))

  Le solénoïde est assez long devant son rayon ($l / R = 6$) pour être assimilé à un solénoïde infini : il crée en son centre un champ axial, horizontal et orthogonal à $va(B)_H$,
  $ B_"sol" = mu_0 N/l I $

  L'aiguille s'aligne sur le champ horizontal total, somme de $va(B)_H$ (inchangé) et de $va(B)_"sol"$ (orthogonal). L'angle de déviation vérifie
  $ tan alpha = B_"sol"/B_H quad => quad B_H = B_"sol"/(tan alpha) = (mu_0 N I)/(l tan alpha) $

  Application numérique :
  $ B_"sol" = (4 pi times 10^(-7) times 100 times 10^(-3))/(0.30) approx qty("4.2e-7", "T") $
  $ B_H = (4.2 times 10^(-7))/(tan 40 degree) approx qty("5.0e-7", "T") $

  L'ordre de grandeur réel de la composante horizontale étant plutôt $qty("2e-5", "T")$, ce dispositif est ici trop peu sensible (courant et nombre de spires faibles) : en pratique on augmente $N I$ pour obtenir une déviation exploitable.
]
