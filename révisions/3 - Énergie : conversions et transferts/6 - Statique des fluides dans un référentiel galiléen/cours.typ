#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Forces surfaciques et volumiques

#flashcard(recto: "Forces surfaciques et volumiques", verso: "Une force volumique s'exerce sur tout le volume (poids, force électrique) ; une force surfacique s'exerce sur la surface du système (pression, viscosité).")
#flashcard(recto: "Équivalent volumique des forces de pression", verso: "$ va(f)_v = -va(grad) P $")

#question-de-colle("À l'aide de schémas, établir les expressions des surfaces élémentaires en coordonnées cartésiennes, cylindriques et sphériques, et vérifier leur homogénéité.")
#question-de-colle("Établir l'équivalent volumique des forces de pression et en déduire l'équation locale de la statique des fluides.")

= Champ de pression

#flashcard(recto: "Relation fondamentale de la statique des fluides", verso: "$(dif P)/(dif z) = -rho g$ avec un axe orienté vers le haut. Dans un fluide incompressible, $P(z) = P_0 - rho g z$.")
#flashcard(recto: "Ordre de grandeur dans l'eau", verso: "La pression augmente d'environ $1$ bar tous les $10$ m de profondeur.")
#flashcard(recto: "Atmosphère isotherme", verso: "$P(z) = P_0 e^(-(M g z)/(R T))$ : on y reconnait le facteur de Boltzmann, rapport de l'énergie potentielle de pesanteur molaire à l'énergie d'agitation thermique.")
#flashcard(recto: "Poussée d'Archimède", verso: "Tout corps immergé subit de la part du fluide une force opposée au poids du fluide déplacé, appliquée au centre de poussée.")

#question-de-colle("Établir la relation fondamentale de la statique des fluides pour un fluide incompressible dans le champ de pesanteur uniforme, l'intégrer et calculer la pression à $10$ m de profondeur dans l'eau.")
#question-de-colle("Établir l'expression de $P(z)$ dans le modèle de l'atmosphère isotherme, identifier le facteur de Boltzmann et en donner une interprétation énergétique.")
#question-de-colle("Énoncer et justifier le théorème d'Archimède.")
