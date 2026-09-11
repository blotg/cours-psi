#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Description d'un cristal

#flashcard(recto: "Maille, réseau, motif", verso: "Le cristal est la répétition périodique d'un motif aux nœuds d'un réseau. La maille est le plus petit volume qui, translaté, engendre tout le cristal.")
#flashcard(recto: "Population, coordinence, compacité", verso: "Population : nombre de motifs par maille. Coordinence : nombre de plus proches voisins. Compacité : fraction du volume de la maille effectivement occupée.")
#flashcard(recto: "Masse volumique d'un cristal", verso: "$rho = (Z M)/(cal(N)_a a^3)$, où $Z$ est la population de la maille et $a$ son paramètre.")

#question-de-colle("Pour une maille cubique à faces centrées, déterminer la population, la coordinence et la compacité, puis établir l'expression de la masse volumique.")

= Les différents types de cristaux

#flashcard(recto: "Cristal métallique", verso: "Cations dans un « gaz » d'électrons délocalisés : bon conducteur électrique et thermique, ductile et malléable.")
#flashcard(recto: "Cristal ionique", verso: "Alternance de cations et d'anions liés par interaction électrostatique : dur, cassant, isolant à l'état solide mais conducteur fondu ou en solution.")
#flashcard(recto: "Cristal covalent et cristal moléculaire", verso: "Covalent (diamant, silice) : réseau de liaisons covalentes, très dur, très haute température de fusion. Moléculaire (glace, $I_2$) : molécules liées par interactions faibles, tendre, basse température de fusion.")

#question-de-colle("Comparer les quatre types de cristaux (métallique, ionique, covalent, moléculaire) : nature des entités, nature des interactions, et conséquences sur les propriétés macroscopiques.")
