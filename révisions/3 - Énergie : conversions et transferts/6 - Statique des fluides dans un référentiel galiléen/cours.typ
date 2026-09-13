#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Forces surfaciques et volumiques

#flashcard(
    recto: [Équivalent volumique des forces de pression],
    verso: [$ va(f)_v = -va(grad) P $ $va(f)_v$ en #unit("N/m^3")],
)
#flashcard(
    recto: [Force pressante],
    verso: [$ va(dd(F)) = P va(dd(S)) $ $va(S)$ orientée du fluide vers la surface],
)
#flashcard(
    recto: [Équation locale de la statique des fluides],
    verso: [$ dv(P,z) = -rho g $ pour un axe $z$ orienté vers le haut],
)
#question-de-colle(
    [Établir l'équivalent volumique des forces de pression et en déduire l'équation locale de la statique des fluides.],
)
#question-de-colle(
    [Établir le champ de pression dans un fluide incompressible. En déduire la force pressante subie par un barrage rectangulaire de hauteur $h$ et de largeur $l$.],
)

= Champ de pression

#flashcard(
    recto: [Poussée d'Archimède],
    verso: [Tout corps immergé subit de la part du fluide une force opposée au poids *du fluide déplacé*, appliquée au centre de poussée.],
)

#question-de-colle(
    [Établir le champ de pression dans le modèle de l'atmosphère isotherme. Identifier le facteur de Boltzmann et en donner une interprétation énergétique.],
)

