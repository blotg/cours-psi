

\exercice{Désintégration de l'uranium 235}[2]
% TRANSFORMER POUR FAIRE AVEC PYTHON
\enonce{
L'uranium 235 n'a pas un noyau stable, celui-ci peut se fissionner en <<captant>> un neutron selon la réaction nucléaire $$\ce{^{235}_{92}U + n -> X + Y + $\nu$n + $\gamma$}$$ où X et Y sont deux noyaux plus légers, n est un neutron et $\gamma$ représente l'énergie émise. La valeur moyenne de $\nu$ est \SI{2.5}{}. L'énergie moyenne libérée par cette désintégration est \SI{170e6}{eV}. Cette réaction a une probabilité $\frac{N}{\tau}$ de se produire par unité de temps et de volume.}

\enonce{On note $N(x,y,z,t)$ le nombre de neutrons par unité de volume et $\vv{j}$ le vecteur densité de courant de neutrons.}

\enonce{On donne, en sphériques, pour des grandeurs ne dépendant que de $r$ et de $t$ : $\grad N=\frac{\partial N}{\partial r}\vv{e_r}$, $\divv\vv{j}=\frac{1}{r^2}\frac{r^2\partial j_r}{\partial r}$ et $\Delta N = \frac{1}{r^2}\frac{\partial}{\partial r}\left(r^2\frac{\partial N}{\partial r}\right)$.}

\begin{enumerate}
  \question{En faisant un bilan de neutron sur une volume mésoscopique, démontrer l'équation fondamentale de la neutronique $$\frac{\partial N}{\partial t}=-\divv\vv{j}+\frac{\nu-1}{\tau}N(x,y,z,t)$$}
    [Combien de neutrons sont captés durant $dt$ dans le volume considéré ? Combien sont émis ?]
  \question{On considère une sphère de rayon $R$ d'uranium 235 et on suppose le problème à symétrie sphérique. On recherche une solution de l'équation ci-dessus sous la forme $N(r,t) = \frac{f(t)g(r)}{r}$. Déterminer les équations vérifiées par $f$ et par $g$.}
    [Il faut procéder par séparation des variables.]
  \question{On prend pour condition aux limites $N(r=R)=0$. Justifier.}
  \question{Quelles sont les différentes formes de solution pour $g(r)$. Lesquelles décrivent physiquement la réaction en chaine d'une bombe nucléire ? Résoudre l'équation différentielle sur $g(r)$.}
    [Distinguer les cas sur le discriminent et utiliser les conditions aux limites pour trouver les constantes.]
    [Une solution constamment nulle ne décrit pas une explosion nucléaire.]
  \question{En déduire la solution de l'équation sur $f(t)$.}
  \question{Sous quelle condition sur le rayon la réaction s’emballe-t-elle ?}
  \question{Quelle masse minimale doit donc avoir une bombe nucléaire ?}
\end{enumerate}
