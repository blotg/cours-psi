#import "@local/prepa:0.1.1": *

= Résoudre une équation différentielle d’ordre 1 linéaire à coefficients constants
+ Résoudre l'équation homogène :
    - Mettre sous la forme canonique $dv(s, t) + alpha s=0$.
    - La solution est $s(t)=K e^(-alpha t)$ avec $K$ un réel.
+ Trouver 1 solution particulière : on la cherche de la même forme que le second membre.
+ Grâce aux conditions initiales, trouver $K$

#application[
    Résoudre $L dv(i, t) + R i=U$ où $U$ est une constante, sachant que $i(t=0)=0$
]

= Résoudre une équation différentielle d’ordre 2 linéaire à coefficients constants
+ Résoudre l'équation homogène :
    - Déterminer le polynôme caractéristique.
    - Déterminer le signe du discriminent.
        - Si $Delta > 0$ la solution est $K_1e^(r_1 t)+K_2e^(r_2 t)$ où $r_1$ et $r_2$ sont les racines du polynôme caractéristique.
        - Si $Delta=0$ la solution est $(K_1+K_2t)e^(r t)$ où $r$ est la racine du polynôme caractéristique.
        - Si $Delta<0$ la solution est $(K_1 cos(beta t)+K_2 sin(beta t))e^(alpha t)$ où $alpha$ et $beta$ sont respectivement la partie réelle et la partie imaginaire d'une des racines du polynôme caractéristique.
+ Trouver 1 solution particulière : on la cherche de la même forme que le second membre.
+ Grâce aux conditions initiales, trouver $K_1$ et $K_2$.

#application[
    Résoudre $L C dv(u, t, 2) + R C dv(u, t)+ u=E$ en distinguant les 3 cas possibles, sachant que $u(0)=0$ et $lr(dv(u, t)\))_(t=0)=E/(R C)$
]
