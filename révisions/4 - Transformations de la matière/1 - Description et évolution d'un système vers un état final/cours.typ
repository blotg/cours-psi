#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Décrire un système physico-chimique

#flashcard(
    recto: [Définition d'une variable extensive et quelques exemples],
    verso: [Grandeur proportionnelle à la quantité de matière. Exemples : volume, quantité de matière, enthalpie],
)
#flashcard(
    recto: [Définition d'une variable intensive et quelques exemples],
    verso: [Grandeur indépendante de la taille du système. Exemples : température, pression, concentration.],
)

= Activité et quotient réactionnel

#flashcard(
    recto: [Activité d'un solide pur],
    verso: [$ a_i = 1 $],
)
#flashcard(
    recto: [Activité d'un liquide pur],
    verso: [$ a_i = 1 $],
)
#flashcard(
    recto: [Activité du solvant],
    verso: [$ a_i = 1 $],
)
#flashcard(
    recto: [Activité d'un soluté très dilué],
    verso: [$ a_i = c_i/standard(c) $ avec $standard(c) = qty("1", "mol/L")$.],
)
#flashcard(
    recto: [Activité d'un gaz parfait],
    verso: [$ a_i = P_i/standard(P) $ avec $standard(P) = qty("1", "bar")$ et $P_i = n_i / n_"total de gaz" P$ la pression partielle du gaz.],
)
#flashcard(
    recto: [Quotient réactionnel],
    verso: [$ Q_r = product a_i^(nu_i) $],
)
#flashcard(
    recto: [Constante thermodynamique d'équilibre],
    verso: [$standard(K)(T)$ est la valeur que prend $Q_r$ à l'équilibre. Elle ne dépend que de la température.],
)

= Sens d'évolution et état final

#flashcard(
    recto: [Critère d'évolution spontanée],
    verso: [/ Si $Q_r < standard(K)$:  la réaction évolue dans le sens direct
    / si $Q_r > standard(K)$ : la réaction évolue dans le sens indirect 
    / si $Q_r = standard(K)$ : le système est à l'équilibre],
)
