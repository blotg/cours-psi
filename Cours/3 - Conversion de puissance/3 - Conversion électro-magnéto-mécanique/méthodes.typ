#import "@local/prepa:0.1.1": *

= Représenter la loi des mailles sur un diagramme de Fresnel
+ Écrire la loi des mailles en utilisant les notations complexes.
+ Prendre le courant $underline(I)$ comme origine des phases : il est horizontal, et les angles $phi$ (de $underline(I)$ vers $underline(V)$) et $Psi$ (de $underline(I)$ vers $underline(E)$) se mesurent dans le sens trigonométrique.
+ Chaque tension correspond à un vecteur sur le diagramme de Fresnel. La norme du vecteur est la valeur efficace de la tension, et l'angle du vecteur avec l'horizontale est l'argument de la tension complexe.
+ Une multiplication par $j$ correspond à une rotation de #quan[90 °] dans le sens trigonométrique.
+ Pour représenter une somme de tensions, on place les vecteurs bout à bout.
+ Pour obtenir une relation entre valeurs efficaces, projeter la loi des mailles sur l'axe du courant et sur l'axe perpendiculaire, ou appliquer le théorème de Pythagore dans un triangle rectangle.

= Choisir une convention pour une machine à courant continu
+ En fonctionnement moteur, choisir la convention récepteur : $u = R I_r + L dv(I_r, t) + E_"cém"$, avec $E_"cém" = Phi_0 Omega$ et $Gamma_"ém" = Phi_0 I_r$.
+ En fonctionnement générateur, choisir la convention générateur en orientant le courant dans l'autre sens, $i = -I_r$ : $u = E - R i - L dv(i, t)$, avec $E = Phi_0 Omega$ et $Gamma_"ém" = -Phi_0 i$.
+ Vérifier les signes sur un cas simple : en fonctionnement générateur, $E$, $i$ et $Omega$ sont positifs et le couple électromagnétique freine le rotor.

= Écrire les équations d'une machine à courant continu
+ Équation électrique : écrire la loi des mailles dans le schéma équivalent de l'induit, dans la convention choisie.
+ Équation mécanique : appliquer le théorème du moment cinétique au rotor et à tout ce qui lui est lié, $J dv(Omega, t) = Gamma_"ém" + Gamma_"charge" + Gamma_"frottements"$.
+ Relations de couplage : $Gamma_"ém" = Phi_0 I_r$ et $E_"cém" = Phi_0 Omega$.
+ En régime permanent, annuler les dérivées : l'inductance n'intervient plus.

= Calculer un rendement
+ Identifier la puissance utile et la puissance couteuse : électrique puis mécanique pour un moteur, mécanique puis électrique pour un générateur.
+ Calculer chacune avec la grandeur adaptée : $u i$ en continu, $2 V I cos(phi)$ pour une machine diphasée en régime sinusoïdal, $Gamma Omega$ pour une puissance mécanique.
+ Lister les pertes : pertes cuivre ($R I^2$ dans l'induit, $U_e I_e$ dans l'inducteur), pertes fer, pertes mécaniques. Le rendement vaut $eta = P_"utile" / P_"couteuse" = P_"utile" / (P_"utile" + P_"pertes")$.
+ Contrôler le résultat par une seconde méthode, la différence $P_"couteuse" - P_"utile"$ devant redonner les pertes, et vérifier que $eta < 1$.
