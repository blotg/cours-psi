#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Échelles et libre parcours moyen

#flashcard(recto: "Libre parcours moyen", verso: "Distance moyenne parcourue par une particule entre deux chocs. Dans un gaz aux conditions usuelles, de l'ordre de $100$ nm ; dans un liquide, de l'ordre de la distance intermoléculaire.")
#flashcard(recto: "Vitesse quadratique moyenne", verso: "$v^* = sqrt(mean(v^2))$ ; pour un gaz parfait monoatomique, $1/2 m v^(*2) = 3/2 k_B T$.")
#flashcard(recto: "Ordre de grandeur des vitesses moléculaires", verso: "Quelques centaines de $m dot s^(-1)$ à température ambiante — comparable à la célérité du son dans le gaz.")

#question-de-colle("Définir le libre parcours moyen et donner son ordre de grandeur dans un gaz puis dans un liquide. Exprimer la vitesse quadratique moyenne en fonction de la température et la calculer pour l'hélium à $300$ K.")

= Système et équation d'état

#flashcard(recto: "Système ouvert, fermé, isolé", verso: "Ouvert : échange matière et énergie. Fermé : énergie seulement. Isolé : ni l'un ni l'autre.")
#flashcard(recto: "Équation d'état du gaz parfait", verso: "$P V = n R T$, avec $P$ en Pa, $V$ en $m^3$, $n$ en mol, $R = 8,314$ $J dot K^(-1) dot m o l^(-1)$ et $T$ en K.")
#flashcard(recto: "Modèle de la phase condensée", verso: "Incompressible et indilatable : le volume massique est constant, et l'énergie interne ne dépend que de la température.")

#question-de-colle("Citer l'équation d'état des gaz parfaits en précisant le nom et l'unité de chaque grandeur. Définir un système ouvert, fermé et isolé.")

= Énergie interne

#flashcard(recto: "Première loi de Joule", verso: "L'énergie interne d'un gaz parfait ne dépend que de la température. Pour un gaz parfait monoatomique, $U = 3/2 n R T$.")
#flashcard(recto: "Capacité thermique à volume constant", verso: "$C_V = (pdv(U, T))_V$, en $J dot K^(-1)$.")

#question-de-colle("Définir l'énergie interne d'un système thermodynamique. Montrer, avec les hypothèses du gaz parfait monoatomique, que $U = 3/2 n R T$, puis citer la première loi de Joule.")

= Corps pur diphasé

#flashcard(recto: "Diagramme (P,T) d'un corps pur", verso: "Trois domaines (solide, liquide, gaz) séparés par les courbes de fusion, de vaporisation et de sublimation, qui se coupent au point triple ; la courbe de vaporisation s'arrête au point critique.")
#flashcard(recto: "Théorème des moments", verso: "Sur un palier de changement d'état, $x_v = (overline(L M))/(overline(L V))$ : la fraction de vapeur se lit comme un rapport de longueurs sur l'isotherme.")

#question-de-colle("Tracer le diagramme de phases $(P,T)$ de l'eau en indiquant les trois domaines, le point triple, le point critique et les trois courbes d'équilibre. Commenter la pente de la courbe de fusion.")
#question-de-colle("Tracer le diagramme de Clapeyron $(P,v)$ de l'eau pour l'équilibre liquide-vapeur, en y plaçant la courbe d'ébullition, la courbe de rosée, le point critique et quelques isothermes. Énoncer le théorème des moments.")
