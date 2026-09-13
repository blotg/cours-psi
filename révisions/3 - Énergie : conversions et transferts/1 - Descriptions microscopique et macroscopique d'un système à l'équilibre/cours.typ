#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Échelles et libre parcours moyen

#flashcard(
    recto: [Libre parcours moyen : définition et ordres de grandeur],
    verso: [Distance moyenne parcourue par une particule entre deux chocs.

    Dans un gaz aux conditions usuelles, de l'ordre de #qty("100","nm") ; dans un liquide, de l'ordre de la distance intermoléculaire.],
)
#flashcard(
    recto: [Vitesse quadratique moyenne],
    verso: [$ v^* = sqrt(mean(v^2)) $],
)
#flashcard(
    recto: [Vitesse quadratique moyenne pour un gaz parfait monoatomique],
    verso: [$ 1/2 m v^(*2) = 3/2 k_B T $],
)

= Système et équation d'état

#flashcard(
    recto: [Définition d'un système ouvert],
    verso: [Système pouvant échanger matière et énergie.],
)
#flashcard(
    recto: [Définition d'un système fermé],
    verso: [Système pouvant échanger uniquement de l'énergie avec l'extérieur.],
)
#flashcard(
    recto: [Définition d'un système isolé],
    verso: [Système ne pouvant échanger ni matière ni énergie avec l'extérieur.],
)
#flashcard(
    recto: [Équation d'état du gaz parfait (avec unités)],
    verso: [$ P V = n R T $ avec $P$ en #unit("Pa"), $V$ en #unit("m^3"), $n$ en #unit("mol"), $R = #qty("8.314", "J/K/mol")$ et $T$ en #unit("K"). $P V$ et $n R T$ sont des énergies, en #unit("J").],
)
#flashcard(
    recto: [Modèle de la phase condensée],
    verso: [Incompressible et indilatable : le volume massique est constant, et l'énergie interne ne dépend que de la température.],
)

#question-de-colle(
    [Citer l'équation d'état des gaz parfaits en précisant le nom et l'unité de chaque grandeur. Définir un système ouvert, fermé et isolé.],
)

= Énergie interne

#flashcard(
    recto: [Première loi de Joule],
    verso: [L'énergie interne d'un gaz parfait ne dépend que de la température.],
)
#flashcard(
    recto: [Énergie interne d'un gaz parfait monoatomique],
    verso: [$ U = 3/2 n R T $],
)
#flashcard(
    recto: [Énergie interne d'un gaz parfait diatomique],
    verso: [$ U = 5/2 n R T $],
)
#flashcard(
    recto: [Capacité thermique à volume constant],
    verso: [$C_V = lr(pdv(U, T)\))_V$, en en #unit("J/K").],
)

#question-de-colle(
    [Définir le modèle du gaz parfait. Exprimer l'énergie interne d'un gaz parfait monoatomique à partir de la vitesse quadratique moyenne. En déduire la capacité thermique à volume constant d'un gaz parfait monoatomique. Citer la première loi de Joule.],
)

= Corps pur diphasé

#flashcard(
    recto: [Diagramme $(P,T)$ d'un corps pur (cas général)],
    verso: [], //TODO schéma
)
#flashcard(
    recto: [Diagramme $(P,T)$ de l'eau pure],
    verso: [], //TODO schéma
)
#flashcard(
    recto: [Théorème des moments],
    verso: [Sur un palier de changement d'état, $x_v = (overline(L M))/(overline(L V))$ : la fraction de vapeur se lit comme un rapport de longueurs sur l'isotherme.],//TODO schéma
)

#question-de-colle(
    [Tracer le diagramme de phases $(P,T)$ de l'eau en indiquant les trois domaines, le point triple, le point critique et les trois courbes d'équilibre.],
)
#question-de-colle(
    [Tracer le diagramme de Clapeyron $(P,v)$ de l'eau pour l'équilibre liquide-vapeur, en y plaçant la courbe d'ébullition, la courbe de rosée, le point critique et quelques isothermes. Énoncer le théorème des moments.],
)
