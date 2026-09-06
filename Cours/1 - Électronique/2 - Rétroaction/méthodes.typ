= Déterminer la stabilité d'un système comportant un amplificateur linéaire intégré

+ Identifier la présence de rétroaction (c'est-à-dire de composants ou ensembles de composants reliant la sortie à une entrée de l'ALI).
+ Catégoriser les rétroactions selon l'entrée de l'ALI (positive ou négative) :
- Uniquement une rétroaction négative : le système est stable.
- Uniquement une rétroaction positive ou pas de rétroaction : le système est instable.
- Rétroaction mixte (positive et négative) : le système peut être stable ou instable

=  Étudier un montage stable comportant un ALI idéal
+ Dans ce cas, l'entrée différentielle $epsilon = 0$.
+ Il faut souvent utiliser le pont diviseur de tension ou la loi des nœuds en tensions pour relier la sortie à l'entrée inverseuse de l'ALI.

= Étudier un montage instable comportant un ALI idéal
+ Dans ce cas, $s = V_"sat"$ si $epsilon > 0$ et $s = -V_"sat"$ si $epsilon < 0$. L'objectif est de déterminer le signe de $epsilon$.
+ Si le montage comporte une rétroaction, il faut distinguer les cas en fonction de si $s = V_"sat"$ ou $s = -V_"sat"$.
+ Dans les deux cas, il faut se poser la question "à partir de quelle valeur de l'entrée le signe de $epsilon$ change-t-il ?".

= Utiliser la loi des nœuds en tensions
Cette loi est utile lorsque plus de deux composants sont reliés à une des entrées de l'ALI.
+ Écrire la loi des nœuds.
+ Remplacer chaque courant en utilisant la loi d'Ohm pour chacun des composants reliés à ce nœud.
+ Écrire les tensions comme des différences de potentiel.
+ Isoler le potentiel du nœud en fonction des autres.