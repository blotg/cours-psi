#import "@local/prepa:0.1.1": *

= Lister les états des interrupteurs
Pour $N$ interrupteurs, il y a $2^N$ états possibles. Pour les lister, on peut compter en binaire, chaque bit représentant l'état d'un interrupteur : 
000, 001, 010, 011, 100, 101, 110, 111.

Une autre façon de le voir est de placer les états dans un tableau. L'état de l'interrupteur $1$ change toutes les lignes, celui de l'interrupteur $2$ toutes les deux lignes, etc.

= Établir une séquence de commutation
+ Lister les états des interrupteurs
+ Parmi ces états, lesquels sont possibles (c'est-à-dire ne contreviennent pas aux règles d'interconnexion des sources) ?
+ Parmi ces états possibles, on est parfois amené à éliminer ceux qui ne permettent pas de transfert de puissance entre la source et la charge.

= Déterminer une valeur moyenne
Il y a deux façons de déterminer une valeur moyenne d'une grandeur périodique
- Graphiquement :
  + Représenter la grandeur en fonction du temps sur une période.
  + Exprimer géométriquement l'aire sous la courbe sur une période.
  + La valeur moyenne est $mean(s)=cal(A)/T$
- À partir d'une autre grandeur : Certaines grandeurs ont une valeur moyenne dont on sait qu'elle est nulle (par exemple le courant dans un condensateur ou la tension aux bornes d'une bobine idéale). En reliant cette grandeur à celle qu'on cherche (par une loi des mailles, des nœuds, ...), on peut en déduire sa valeur moyenne.

