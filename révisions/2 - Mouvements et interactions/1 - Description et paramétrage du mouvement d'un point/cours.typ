#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Systèmes de coordonnées

#flashcard(
    recto: "Déplacement élémentaire en coordonnées cartésiennes",
    verso: "$ dd(va(l)) = dd(x) ex + dd(y) ey + dd(z) ez $",
)
#flashcard(
    recto: "Déplacement élémentaire en coordonnées cylindriques",
    verso: "$ dd(va(l)) = dd(r) er + r dd(theta) etheta + dd(z) ez $",
)
#flashcard(
    recto: "Déplacement élémentaire en coordonnées polaires",
    verso: "$ dd(va(l)) = dd(r) er + r dd(theta) etheta $",
)
#flashcard(
    recto: "Vecteur position en coordonnées cartésiennes",
    verso: "$ va(r) = x ex + y ey + z ez $",
)
#flashcard(
    recto: "Vecteur position en coordonnées cylindriques",
    verso: "$ va(r) = r er + z ez $",
)
#flashcard(
    recto: "Vecteur position en coordonnées polaires",
    verso: "$ va(r) = r er $",
)
#flashcard(
    recto: "Vecteur vitesse en coordonnées cartésiennes",
    verso: "$ va(v) = dot(x) ex + dot(y) ey + dot(z) ez $",
)
#flashcard(
    recto: "Vecteur vitesse en coordonnées cylindriques",
    verso: "$ va(v) = dot(r) er + r dot(theta) etheta + dot(z) ez $",
)
#flashcard(
    recto: "Vecteur vitesse en coordonnées polaires",
    verso: "$ va(v) = dot(r) er + r dot(theta) etheta $",
)
#flashcard(
    recto: "Vecteur accélération en coordonnées cartésiennes",
    verso: "$ va(a) = dot.double(x) ex + dot.double(y) ey + dot.double(z) ez $",
)
#flashcard(
    recto: "Vecteur accélération en coordonnées cylindriques",
    verso: "$ va(a) = (dot.double(r) - r dot(theta)^2) er + (2 dot(r) dot(theta) + r dot.double(theta)) etheta + dot.double(z) ez $",
)
#flashcard(
    recto: "Vecteur accélération en coordonnées polaires",
    verso: "$ va(a) = (dot.double(r) - r dot(theta)^2) er + (2 dot(r) dot(theta) + r dot.double(theta)) etheta $",
)

#question-de-colle(
    "Illustrer par un dessin le repérage d'un point $M$ en coordonnées cartésiennes. Donner l'expression du vecteur position, du déplacement élémentaire, de la vitesse et de l'accélération.",
)
#question-de-colle(
    "Illustrer par un dessin le repérage d'un point $M$ en coordonnées cylindriques. Donner l'expression du vecteur position, du déplacement élémentaire, de la vitesse et de l'accélération.",
)
#question-de-colle(
    "Illustrer par un dessin le repérage d'un point $M$ en coordonnées polaires. Donner l'expression du vecteur position, du déplacement élémentaire, de la vitesse et de l'accélération.",
)

#question-de-colle(
  "Pour un mouvement uniformément accéléré, exprimer le vecteur vitesse et le vecteur position en fonction du temps. Établir la trajectoire en coordonnées cartésiennes.",
)
#question-de-colle(
  "Pour un mouvement circulaire uniforme, exprimer le vecteur vitesse, le vecteur position et le vecteur accélération en fonction du temps en coordonnées polaires.",
)