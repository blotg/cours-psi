#import "@local/prepa:0.1.1": *

= Comparer en ordre de grandeur les termes d'une équation aux dérivées partielles
+ Identifier les échelles caractéristiques du problème : la durée $tau$ sur laquelle les grandeurs varient (période, durée d'un régime transitoire…) et la longueur $lambda$ sur laquelle elles varient (taille du système, longueur d'onde…).
+ Remplacer chaque dérivée par un taux d'accroissement : $pdv(f, t) tilde F/tau$ et $pdv(f, x) tilde F/lambda$, où $F$ est l'ordre de grandeur des variations de $f$. Une dérivée seconde donne $F/tau^2$ ou $F/lambda^2$. La divergence, le rotationnel et le gradient contiennent des dérivées spatiales premières : $norm(rot va(B)) tilde B/lambda$.


= Représenter le circuit équivalent en présence d'un flux magnétique variable
+ Choisir un sens de parcours du circuit et le représenter par une flèche sur le schéma. Ce choix est arbitraire, mais toutes les orientations qui suivent en découlent.
+ Orienter la surface s'appuyant sur le circuit, et donc $va(dd(S))$, par la règle de la main droite à partir du sens de parcours : les doigts suivent le sens de parcours, le pouce indique le sens de $va(dd(S))$.
+ Calculer le flux $Phi = integral.double_S va(B) dot va(dd(S))$ du champ magnétique extérieur. Il est algébrique : il est négatif si $va(B)$ et $va(dd(S))$ sont de sens opposés. Pour un bobinage de $N$ spires, $Phi = N Phi_(1 "spire")$.
+ Calculer la f.é.m. induite $e = - dv(Phi, t)$.
+ Dessiner le circuit équivalent : ajouter en série un générateur de f.é.m. $e$, en convention générateur, c'est-à-dire avec la flèche de $e$ dans le sens de parcours. Orienter l'intensité $i$ dans ce même sens.

= Déterminer le champ électrique induit par un champ magnétique variable
+ Étudier les invariances de $va(B)$ et de la géométrie du système pour déterminer les variables dont dépend $va(E)$, et choisir le système de coordonnées adapté.
+ Déterminer la direction de $va(E)(M)$ par les symétries de cette distribution de courant : $va(E)(M)$ est inclus dans les plans de symétrie passant par $M$ et orthogonal aux plans d'antisymétrie passant par $M$, à l'inverse de $va(B)(M)$.
+ Choisir une courbe fermée orientée $cal(C)$ passant par $M$ et adaptée aux symétries.
+ Calculer le flux $Phi$ de $va(B)$ à travers une surface s'appuyant sur $cal(C)$, orientée par la règle de la main droite à partir du sens de parcours de $cal(C)$. Appliquer $integral.cont_cal(C) va(E) dot va(dd(l)) = - dv(Phi, t)$ et isoler $E$.

= Déterminer le flux du champ magnétique sur un bobinage
+ Intégrer le champ magnétique (préalablement déterminé) sur *une* spire du bobinage pour obtenir le flux magnétique $Phi_(1 "spire")$.
+ Le flux total est le flux sur une spire multiplié par le nombre de spires $N$ : $Phi = N Phi_(1 "spire")$.

= Déterminer l'inductance propre d'un bobinage
+ Déterminer le champ magnétique $B$ créé par le bobinage en fonction de l'intensité $i$ du courant qui le traverse.
+ Déterminer le flux magnétique $Phi$.
+ L'inductance propre est le rapport entre le flux et l'intensité : $L=Phi/i$.

= Déterminer l'inductance mutuelle entre deux bobinages
+ Déterminer le champ magnétique $B$ créé par un des bobinages en fonction de l'intensité $i$ du courant qui le traverse. Le champ créé par l'un des bobinages peut être plus simple à déterminer que celui créé par l'autre bobinage.
+ Déterminer le flux magnétique $Phi$ de ce champ magnétique sur l'*autre* bobinage.
+ L'inductance mutuelle est le rapport entre le flux et l'intensité : $M=Phi/i$.