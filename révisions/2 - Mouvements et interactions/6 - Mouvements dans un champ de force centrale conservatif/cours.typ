#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Constantes du mouvement

#flashcard(
  recto: "Définition force centrale",
  verso: "Une force centrale est une force dont la direction est toujours dirigée vers un point fixe (le centre) et dont la valeur ne dépend que de la distance au centre."
)
#flashcard(
    recto: "Moment d'une force centrale",
    verso: "$ va(M)_O (va(F)) =  va(O M) and va(F) = 0 $",
)
#flashcard(
    recto: "Seconde loi de Kepler",
    verso: "Pour un point matériel soumis à une force centrale, la vitesse aréolaire $dv(cal(A),t)$ est constante : $ dv(cal(A),t) = C/2 $ où $C$ est la constante des aires.",
)
#flashcard(
    recto: "Constante des aires",
    verso: "$ C = r^2 dot(theta) $ C'est une constante d'après la seconde loi de Kepler.",
)

#question-de-colle(
    "Montrer que le moment cinétique se conserve pour un point matériel soumis à une force centrale. En déduire que le mouvement est plan et établir la seconde loi de Kepler.",
)

= Énergie potentielle effective

#flashcard(
    recto: "Nature de la trajectoire dans un champ newtonien en fonction du signe de l'énergie mécanique",
    verso: "/$E_m < 0$ : état lié, trajectoire elliptique (circulaire si $E_m$ est minimale)
    / $E_m >= 0$ : état de diffusion, trajectoire parabolique ou hyperbolique",
)

#question-de-colle(
  "Dans le cas d'une trajectoire circulaire d'un satellite autour de la Terre, établir que le mouvement est uniforme et démontrer la troisième loi de Kepler. Comment cette loi se généralise-t-elle pour une orbite elliptique ?"
)
#question-de-colle(
    "Pour une planète orbitant autour du Soleil, mettre l'énergie mécanique sous la forme $E_m = 1/2 m dot(r)^2 + E_(p,\"eff\")(r)$, tracer l'allure de $E_(p,\"eff\")$ et discuter la nature du mouvement selon la valeur de $E_m$.",
)

= Lois de Kepler et satellites

#flashcard(
    recto: "Première loi de Kepler",
    verso: "Les trajectoires des planètes sont des ellipses dont le Soleil occupe un foyer.",
)
#flashcard(
    recto: "Troisième loi de Kepler",
    verso: "$ a^3 / T^2 = (cal(G) M_\"soleil\")/(4 pi^2) $ avec $a$ le demi-grand axe de l'orbite et $T$ sa période.",
)
#flashcard(
    recto: "Énergie mécanique sur une orbite elliptique",
    verso: "$ E_m = -(G m M)/(2a) $ où $a$ est le demi-grand axe.",
)
#flashcard(
    recto: "Signification des vitesses cosmiques",
    verso: "/ Première vitesse cosmique : vitesse d'un satellite en orbite circulaire rasante autour de la Terre
    / Seconde vitesse cosmique : vitesse de libération d'un satellite depuis la surface de la Terre",
)

#question-de-colle(
    "Définir un satellite géostationnaire et déterminer l'expression de son altitude.",
)
#question-de-colle(
    "Établir les expressions des deux vitesses cosmiques et effectuer leur application numérique. On donne $G = qty(\"6.7e-11\", \"m^3/kg/s\")$, $M_T = qty(\"6.0e24\", \"kg\")$, $R_T = qty(\"6.4e3\", \"km\")$.",
)
