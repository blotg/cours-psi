#import "@local/prepa:0.1.1": *

= Ramener un dipôle au primaire ou au secondaire
+ Repérer le côté du transformateur où l'on cherche une grandeur : on garde ce côté tel quel et on y ramène tout ce qui est de l'autre côté.
+ Remplacer le transformateur idéal par un simple fil en transformant les dipôles de l'autre côté :
    - pour ramener le primaire au secondaire, multiplier les impédances par $m^2$ et les tensions des sources par $m$ ;
    - pour ramener le secondaire au primaire, diviser les impédances par $m^2$ et les tensions des sources par $m$.
+ Résoudre le circuit obtenu, qui ne comporte plus de transformateur (pont diviseur, loi des mailles…).
+ Revenir à la grandeur réelle si elle est de l'autre côté, avec $v_2 = m v_1$ et $i_1 = -m i_2$ (attention aux bornes homologues pour les signes).


= Faire un bilan de pertes
+ Les pertes fer (hystérésis et courants de Foucault) dépendent de la tension appliquée mais pas du courant débité : on les mesure par un essai à vide, secondaire ouvert, où les pertes cuivre sont négligeables.
+ La puissance moyenne reçue par le primaire est $P_1 = U_(1"eff") I_(1"eff") cos phi_1$, celle fournie par le secondaire $P_2 = U_(2"eff") I_(2"eff") cos phi_2$.
+ Les pertes totales valent $P_1 - P_2 = P_"fer" + P_"cuivre"$ ; on en déduit les pertes cuivre, qui varient comme le carré du courant.
+ Le rendement est $eta = P_2 / P_1$.
