#import "@local/prepa:0.1.1": *

= Faire un bilan infinitésimale
Pour faire un bilan d'une grandeur sur un système infinitésimal :
+ S'assurer que la grandeur est conservative et si besoin, le justifier.
+ Représenter le système.
+ Déterminer les surfaces qui sont traversées par un flux et déterminer leur aire.
+ En déduire le flux net rentrant en multipliant les aires par les vecteurs densité de courant. Attention aux orientations des surfaces !
+ Déterminer le volume du système.
+ En déduire la grandeur nette "créée" par unité de temps dans la système.
+ Écrire l'égalité entre la variation de la grandeur entre $t$ et $t+dd(t)$ d'une part et la grandeur rentrant entre $t$ et $t+dd(t)$ plus la grandeur créée entre $t$ et $t+dd(t)$ d'autre part.

#application[
    On se place en coordonnées cylindriques et on suppose que les grandeurs ne dépendent que de $r$ et de $t$. En effectuant un bilan sur un volume infinitésimal en coordonnées cylindriques, déterminer l'équation locale de conservation de l'énergie en coordonnées cylindriques sans terme source.
]

#application[
    On se place en coordonnées sphériques et on suppose que les grandeurs ne dépendent que de $r$ et de $t$. En effectuant un bilan sur un volume infinitésimal en coordonnées sphériques, déterminer l'équation locale de conservation de l'énergie en coordonnées sphériques sans terme source.
]

#application[
    On se place en coordonnées cylindriques et on suppose que les grandeurs ne dépendent que de $r$ et de $t$. En effectuant un bilan sur un cylindre creux d'épaisseur infinitésimale, déterminer l'équation locale de conservation de l'énergie en coordonnées cylindriques sans terme source.
]

#application[
    On se place en coordonnées sphériques et on suppose que les grandeurs ne dépendent que de $r$ et de $t$. En effectuant un bilan sur une coquille creuse d'épaisseur infinitésimale, déterminer l'équation locale de conservation de l'énergie en coordonnées sphériques sans terme source.
]


= Utiliser la conservation du flux de $va(j)$
On peut utiliser cette propriété pour déterminer les dépendances de $va(j)$ ou pour relier $va(j)$ en deux points de l'espace.

+ Trouver un tube de champ allant d'un point à l'autre.
+ Déterminer la section des tubes de champ aux niveaux des deux points.
+ Exprimer les flux de $va(j)$ aux niveaux des deux points.
+ Écrire l'égalité entre ces deux flux.

#application[
    On se place en coordonnées cylindriques et on suppose que les grandeurs ne dépendent que de $r$. On suppose $va(j)=j er$ à flux conservatif. Relier $va(j)(R_1)$ et $va(j)(R_2)$.
]

#application[
    On se place en coordonnées sphériques et on suppose que les grandeurs ne dépendent que de $r$. On suppose $va(j)=j er$ à flux conservatif. Relier $va(j)(R_1)$ et $va(j)(R_2)$.
]

#application[
    On se place en coordonnées cylindriques et on suppose que les grandeurs ne dépendent que de $r$. On suppose $va(j)=j er$ à flux conservatif. Montrer que $va(j)(r)="cte"/r er$.
]

#application[
    On se place en coordonnées sphériques et on suppose que les grandeurs ne dépendent que de $r$. On suppose $va(j)=j er$ à flux conservatif. Montrer que $va(j)(r)="cte"/r^2 er$.
]
