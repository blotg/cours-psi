#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Description d'un cristal

#flashcard(
    recto: [Maille, réseau, motif],
    verso: [Le cristal est la répétition périodique d'un motif aux nœuds d'un réseau. La maille est un volume qui, translaté, engendre tout le cristal.],
)
#flashcard(
    recto: [Population],
    verso: [Nombre d'atomes par maille.],
)
#flashcard(
    recto: [Coordinence],
    verso: [Nombre de plus proches voisins.],
)
#flashcard(
    recto: [Compacité],
    verso: [Fraction du volume de la maille effectivement occupée.],
)
#flashcard(
    recto: [Masse volumique d'un cristal],
    verso: [$ rho = (Z M) / (Na a^3) $ où $Z$ est la population de la maille, $a$ son paramètre, $M$ la masse molaire et $Na$ le nombre d'Avogadro.],
)

#question-de-colle(
    [Pour une maille cubique simple, cubique à faces centrées ou cubique centrée (au choix du colleur), déterminer la population, la coordinence et la compacité, puis établir l'expression de la masse volumique.],
)
