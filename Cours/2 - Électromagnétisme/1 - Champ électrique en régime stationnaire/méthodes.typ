#import "@local/prepa:0.1.1": *

= Exploiter une carte de potentiels
+ Tracer les lignes de champ orthogonales aux équipotentielles, orientées vers les potentiels décroissants.
+ Estimer la norme du champ entre deux équipotentielles voisines : $E approx abs(Delta V)/(Delta l)$, où $Delta l$ est la distance entre les deux équipotentielles, mesurée le long de la ligne de champ et convertie à l'aide de l'échelle de la carte.
+ Repérer les sources : les équipotentielles entourent les sources et sont plus rapprochées près des charges.

= Exploiter une carte de champ
+ Tracer les équipotentielles orthogonales aux lignes de champ. Elles sont d'autant plus serrées que le champ est grand.
+ Dans une zone vide de charges, un tube de champ qui s'évase indique un champ qui diminue.
+ Repérer les sources : les lignes de champ partent des charges positives et aboutissent aux charges négatives. Dans une zone vide de charges, un tube de champ qui s'évase indique un champ qui diminue.

= Déterminer la vitesse d'une particule chargée accélérée par une tension
+ Exprimer l'énergie potentielle $E_p = q V$ de la particule au point de départ $A$ et au point d'arrivée $B$.
+ Appliquer le théorème de l'énergie cinétique entre $A$ et $B$, en négligeant le poids : $1/2 m v_B^2 - 1/2 m v_A^2 = q (V_A - V_B)$.
+ Vérifier le signe : une charge positive est accélérée vers les potentiels décroissants, une charge négative vers les potentiels croissants.

#application[
    Quelle tension faut-il appliquer pour qu'un proton ($m = #quan[1.67e-27 kg]$, $q = #quan[1.60e-19 C]$) initialement immobile atteigne #quan[1 %] de la vitesse de la lumière ?
]

= Déterminer un champ électrique (ou gravitationnel) avec le théorème de Gauss
+ Étudier les invariances de la distribution de charge (ou de masse) pour déterminer les variables dont dépend $va(E)$ (ou $va(g)$), et choisir le système de coordonnées adapté.
+ Chercher les plans de symétrie de la distribution passant par un point $M$ quelconque : $va(E)(M)$ (ou $va(g)(M)$) est porté par leur intersection.
+ Choisir une surface de Gauss fermée, passant par $M$ et adaptée aux symétries : sur chacune de ses parties, $va(E)$ (ou $va(g)$) est soit normal à la surface et de norme constante, soit tangent à la surface (flux nul).
    - Symétrie sphérique : sphère de rayon $r$.
    - Symétrie cylindrique : cylindre coaxial de rayon $r$ et de hauteur $h$, fermé par deux disques.
    - Plan infini : cylindre traversant le plan, symétrique par rapport à lui.
+ Calculer le flux.
+ Calculer la charge (ou la masse) intérieure (en distinguant les cas zone par zone si nécessaire). Si $rho$ (ou $mu$) n'est pas uniforme, intégrer.
+ Appliquer le théorème de Gauss.

= Déterminer le potentiel électrique à partir du champ
+ Projeter $va(E) = - grad V$ dans le système de coordonnées adapté : $E(r) = - dv(V, r)$ en coordonnées sphériques ou cylindriques, $E(z) = - dv(V, z)$ en coordonnées cartésiennes.
+ Intégrer zone par zone : chaque zone apporte sa constante d'intégration.
+ Fixer une première constante par le choix de la référence. Un choix courant est de prendre le potentiel nul à l'infini lorsque cela est possible.
+ Fixer les autres constantes par la continuité de $V$ aux frontières entre les zones.

= Déterminer le potentiel électrique directement à partir de la distribution de charge
+ Utiliser l'équation de Laplace (ou de Poisson dans une zone vide de charges), puis fixer les constantes par les conditions aux limites : potentiels imposés, continuité de $V$.

= Calculer une différence de potentiel
+ Écrire $V_A - V_B = integral_A^B va(E) dot va(dd(l))$.
+ Choisir un chemin qui simplifie le calcul : le long d'une ligne de champ, où $va(E) dot va(dd(l)) = E dd(l)$, ou en plusieurs morceaux dont certains sont orthogonaux à $va(E)$ et ne contribuent pas.

= Déterminer la capacité d'un condensateur
+ Supposer que les armatures portent les charges opposées $Q$ et $-Q$.
+ Déterminer le champ électrique entre les armatures, par exemple avec le théorème de Gauss.
+ Calculer la tension $U = V_+ - V_-$ par la circulation de $va(E)$ de l'armature positive à l'armature négative.
+ Écrire $C = Q/U$. Vérifier que $Q$ se simplifie et que $C$ est positive : la capacité ne dépend que de la géométrie et de l'isolant.
+ Si l'espace entre les armatures est occupé par un isolant, remplacer $epsilon_0$ par $epsilon = epsilon_r epsilon_0$.

= Calculer l'énergie électrostatique d'une distribution
+ Déterminer le champ électrique dans tout l'espace.
+ Écrire la densité volumique d'énergie $w = 1/2 epsilon_0 E^2$ dans chaque zone.
+ Intégrer sur tout l'espace, zone par zone : $cal(E) = integral.triple w dd(tau)$.
