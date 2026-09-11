#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Travail, puissance, théorèmes

#flashcard(
    recto: "Travail d'une force",
    verso: "$ delta W = va(F) dot va(dd(l)) $ $ W_(A B) = integral_A^B va(F) dot va(dd(l)) $",
)
#flashcard(
    recto: "Puissance d'une force",
    verso: "$ P = va(F) dot va(v) $",
)
#flashcard(
    recto: "Théorème de l'énergie cinétique",
    verso: "$ Delta E_c = sum W_\"ext\" $",
)
#flashcard(
    recto: "Théorème de la puissance cinétique",
    verso: "$ dv(E_c,t) = sum P_\"ext\"$",
)
#flashcard(
    recto: "Définition d'une force conservative",
    verso: "Une force est conservative si son travail est indépendant du chemin suivi,ce qui équivaut à dire qu'elle s'écrit comme un gradient.",
)
#flashcard(
    recto: "Force conservative comme un gradient",
    verso: "$ va(F) = - grad E_p $ Une force est conservative ssi elle s'écrit comme un gradient.",
)
#flashcard(
    recto: "Travail d'une force conservative",
    verso: "$ W_(A B) = E_p(A) - E_p(B) $ Le travail d'une force conservative ne dépend que des points initial et final."
)
#flashcard(
    recto: "Théorème de l'énergie mécanique",
    verso: "$ Delta E_m = W_\"non conservatives\" $ avec $E_m = E_c + E_p$. L'énergie mécanique se conserve en l'absence de forces non conservatives.",
)
#flashcard(
    recto: "Théorème de la puissance mécanique",
    verso: "$ dv(E_m,t) = sum P_\"non conservatives\"$ avec $E_m = E_c + E_p$. L'énergie mécanique se conserve en l'absence de forces non conservatives.",
)

#question-de-colle(
    "Définir le travail élémentaire d'une force, son travail le long d'un chemin et sa puissance. Citer le théorème de l'énergie cinétique et en déduire le théorème de la puissance cinétique, le théorème de l'énergie mécanique et le théorème de la puissance mécanique.",
)

= Énergies potentielles

#flashcard(
    recto: "Énergies potentielle de pesanteur",
    verso: "$ E_p = m g z $",
)
#flashcard(
    recto: "Énergies potentielle élastique",
    verso: "$ E_p = 1/2 k (l-l_0)^2 $",
)
#flashcard(
    recto: "Énergies potentielle gravitationnelle",
    verso: "$ E_p = -G (m M)/r $",
)
#flashcard(
    recto: "Énergies potentielle de électrostatique",
    verso: "$ E_p = q V $",
)

#question-de-colle(
    "Citer le lien entre travail élémentaire et variation d'énergie potentielle qui définit une force conservative. En déduire l'expression de l'énergie potentielle de pesanteur, de l'énergie potentielle élastique, de l'énergie potentielle gravitationnelle et de l'énergie potentielle électrostatique.",
)

= Équilibres et portrait énergétique

#flashcard(
    recto: "Position d'équilibre et stabilité",
    verso: "Équilibre ssi la force est nulle ssi $dv(E_p,x) = 0$
    
    Stable ssi $E_p$ est un minimum local ssi $dv(E_p,x,2) > 0$)
    
    Instable ssi $E_p$ est un maximum local ssi $dv(E_p,x,2) < 0$",
)

#question-de-colle(
    "Pendule simple à tige rigide repéré par l'angle $theta$ : exprimer son énergie potentielle, tracer $E_p (theta)$ sur $[-2 pi, 2 pi]$. Déterminer les positions d'équilibre et préciser leur stabilité.",
)
#question-de-colle(
    "Déterminer l'équation du mouvement d'un système masse-ressort horizontal en utilisant le théorème de l'énergie mécanique, de la puissance mécanique, de l'énergie cinétique ou de la puissance cinétique au choix du colleur.",
)
