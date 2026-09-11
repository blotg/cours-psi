#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Quantité de mouvement et lois de Newton

#flashcard(
    recto: "Quantité de mouvement et unité",
    verso: "$ va(p) = m va(v) $ en #unit(\"kg m/s\")

    Pour un système de points, $va(p) = m_\"tot\" va(v)(G)$.",
)
#flashcard(
    recto: "Première loi de Newton",
    verso: "Il existe des référentiels galiléens, où un point matériel isolé (soumis à aucune force) ou pseudo-isolé (soumis à des forces qui se compensent) garde une vitesse constante. Ces référentiels sont en mouvement rectiligne uniforme les uns par rapport aux autres.",
)
#flashcard(
    recto: "Seconde loi de Newton",
    verso: "$ dv(va(p),t) = sum va(F) $",
)
#flashcard(
    recto: "Troisième loi de Newton",
    verso: "Les actions réciproques sont opposées et portées par la droite joignant les deux points.",
)

#question-de-colle(
    "Définir la quantité de mouvement d'un point matériel. Établir l'expression de la quantité de mouvement d'un système de deux points en fonction de la vitesse du centre de masse. Citer les trois lois de Newton.",
)

= Forces usuelles

#flashcard(
    recto: "Poids",
    verso: "$ va(P) = m va(g) $ avec $g approx 9,8$ $m dot s^(-2)$"
)
#flashcard(
    recto: "Force de gravitation",
    verso: "$ va(F) = -G (m_1 m_2)/r^2 va(e_r) $ (force toujours attractive)",
)
#flashcard(
    recto: "Force de rappel d'un ressort (loi de Hooke)",
    verso: "$ va(F) = -k (l - l_0) va(e) $ avec $k$ la raideur du ressort en $N dot m^(-1)$ et $va(e)$ dirigé du point fixe vers la masse.",
)
#flashcard(
    recto: "Frottement fluide",
    verso: "Aux faibles vitesses $va(f) = -alpha va(v)$ (linéaire), aux grandes vitesses $va(f) = -beta v va(v)$ (quadratique).",
)

= Mises en équation classiques

#question-de-colle(
    "Chute d'une bille dans un fluide visqueux avec $va(f) = -alpha va(v)$ et vitesse initiale nulle : établir l'équation différentielle vérifiée par $v_z$, la résoudre en tenant compte des conditions initiales et exprimer la vitesse limite.",
)
#question-de-colle(
    "Tir d'un projectile sans frottement, vitesse initiale faisant un angle $alpha$ avec l'horizontale : déterminer les équations horaires et l'équation de la trajectoire. Définir et exprimer la flèche et la portée.",
)
#question-de-colle(
    "Établir l'équation du mouvement d'un pendule simple par la deuxième loi de Newton. Faire l'approximation des petits angles et exprimer la période $T_0$ des oscillations.",
)
#question-de-colle(
    "Établir l'équation du mouvement de la masse d'un système masse-ressort vertical, en commençant par déterminer la position d'équilibre statique.",
)
