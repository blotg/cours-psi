#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Deuxième principe

#flashcard(
    recto: [Deuxième principe de la thermodynamique],
    verso: [Pour un système fermé, il existe une fonction d'état extensive $S$ telle que $ Delta S = S_e + S_c $ avec $S_e = sum Q_i/T_i$ et
    - $S_c > 0$ si la transformation est irréversible
    - $S_c = 0$ si elle est réversible.],
)
#flashcard(
    recto: [Interprétation de l'entropie],
    verso: [L'entropie mesure le désordre statistique : plus le nombre de micro-états compatibles avec l'état macroscopique est grand, plus l'entropie est élevée.],
)

#question-de-colle(
    [Énoncer le deuxième principe de la thermodynamique, en précisant les hypothèses, le nom et l'unité de chaque grandeur. Donner une interprétation de l'entropie.],
)

= Entropie du gaz parfait et de la phase condensée

#flashcard(
    recto: [Loi de Laplace],
    verso: [Pour un gaz parfait subissant une transformation adiabatique réversible $ P V^gamma = "constante" $],
)
#flashcard(
    recto: [Hypothèses de la loi de Laplace],
    verso: [- gaz parfait
  - transformation adiabatique
  - transformation réversible],
)
#flashcard(
    recto: [Entropie de changement d'état],
    verso: [$ Delta s = (Delta h)/T $ à la température d'équilibre.],
)

#question-de-colle(
    [Énoncer les lois de Laplace en précisant les hypothèses. Démontrer celles portant sur $(T,V)$ et $(T,P)$ à partir de celle portant sur $(P,V)$.],
)