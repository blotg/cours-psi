#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Moment cinétique et moment d'une force

#flashcard(
    recto: "Moment cinétique d'un point matériel en un point O",
    verso: "$ va(L)_O = va(O M) and m va(v) $",
)
#flashcard(
    recto: "Moment cinétique d'un point matériel par rapport à un axe",
    verso: "$ va(L)_Delta = (va(O M) and m va(v)) dot va(u)_Delta $ où $O$ est un point de l'axe $Delta$ et $va(u)_Delta$ est le vecteur unitaire le long de l'axe.",
)
#flashcard(
    recto: "Moment d'une force en un point O",
    verso: "$ va(M)_O (va(F)) = va(O M) and va(F) $",
)
#flashcard(
    recto: "Moment d'une force par rapport à un axe",
    verso: "$ va(M)_Delta (va(F)) = (va(O M) and va(F)) dot va(u)_Delta $ où $O$ est un point de l'axe $Delta$ et $va(u)_Delta$ est le vecteur unitaire le long de l'axe.",
)
#flashcard(
    recto: "Bras de levier",
    verso: "Le moment par rapport à un axe vaut $M_Delta = plus.minus F d$, où $d$ est la distance de l'axe à la droite d'action de la force.",
)

= Théorème du moment cinétique

#flashcard(
    recto: "Théorème du moment cinétique en un point fixe",
    verso: "En un point fixe $O$ d'un référentiel galiléen $ (dv(va(L)_O,t) = sum va(M)_O (va(F)_\"ext\") $",
)
#flashcard(
    recto: "Théorème du moment cinétique par rapport à un axe fixe",
    verso: "Sur un axe fixe $Delta$ d'un référentiel galiléen $ (dv(va(L)_Delta,t) = sum va(M)_Delta (va(F)_\"ext\") $",
)

#question-de-colle(
    "Définir le moment cinétique d'un point matériel par rapport à un point, puis le moment d'une force par rapport à un point. Énoncer puis démontrer le théorème du moment cinétique.",
)
#question-de-colle(
    "Établir l'équation différentielle vérifiée par l'angle d'un pendule simple en utilisant le théorème du moment cinétique par rapport à un point fixe ou un axe fixe (au choix du colleur). Donner la forme des solutions pour de petites oscillations.",
)