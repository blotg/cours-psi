
// \exercice{Les propriétés de l’air sont-elles celles d’un gaz parfait dans les conditions ambiantes ?}

// On donne le diagramme $(P, h)$ de l’air entre $\SI{0.1}{bar}$ et $\SI{200}{bar}$ (cf annexe). La masse molaire de l’air vaut environ $M = \SI{29}{g.mol^{-1}}$ . On convient de définir les conditions ambiantes par les valeurs $T_a = \SI{20}{\celsius}$, $P_a = \SI{1}{bar}$ (point $A$ sur le diagramme).

// \begin{center}
//   \begin{tabular}{c|cccc}
//     $s$ (\unit{kJ.K^{-1}.kg^{-1}}) & \num{4.00} & \num{4.00} & \num{4.00} & \num{4.00}\\
//     \hline
//     $T$ (\unit{\celsius}) & \num{-100} & \num{0} & \num{100} & \num{200}\\
//     \hline
//     $P$ (\unit{bar}) & \num{0.121} & \num{0.603} & \num{1.82} & \num{4.23}\\
//     \hline
//     $v$ (\unit{m^3.kg^{-1}}) & \num{4.06} & \num{1.30} & \num{0.589} & \num{0.322}\\
//   \end{tabular}
// \end{center}

// \begin{enumerate}
//   \question{L’air vérifie-t-il l’équation d’état d’un gaz parfait dans les conditions du tableau ?}
//     [A l'aide de l'équation d'état des gaz parfaits, relier $P$, $v$, $R$, $T$ et $M$. Cette relation est-elle vérifiée pour les valeurs du tableau ?]
//   \question{Sur le diagramme $(P, h)$, les isothermes sont-elles conformes aux propriétés d’un gaz parfait ? Qu’en est-il au voisinage du point $A$ ?}
//     [Que dit la seconde loi de Joule pour un gaz parfait ? Comment varie l'enthalpie pour une isotherme ?]
//   \question{Mesurer la capacité thermique massique à pression constante $c_p$ au voisinage du point $A$. En déduire le coefficient $\gamma$ en adoptant le modèle du gaz parfait.}
//     [Au voisinage du point $A$, de combien varie l'enthalpie massique lorsque la température passe de $\SI{0}{°C}$ à $\SI{20}{°C}$ ?]
//     [On rappelle les relations de Mayer $C_P-C_V=nR$ et $\gamma=\frac{C_P}{C_V}$. En déduire $C_P$ puis $c_P$ en fonction de $\gamma$.]
//   \question{En considérant l’isentropique $s = \SI{4}{kJ.K^{-1}.kg^{-1}}$, tracer une courbe permettant de valider ou d'invalider la relation de Laplace. La courbe pourra être tracer sur Python ou la calculatrice et devra comporter 9 points.}
//     [Mesurer $P$ et $v$ pour des points le long de l'isentropique.]
//     [En fonction de quoi doit-on tracer la pression pour obtenir une droite si la relation de Laplace est vérifiée ?]
//     [Tracer $P$ en fonction de $v^{-\gamma}$.]
//   \question{En conclusion, le modèle de gaz parfait pour l’air est-il bien vérifié dans les conditions ambiantes.}
// \end{enumerate}

// \begin{center}
//   \includegraphics[page=13,width=\linewidth]{images/cpge-diagramme_ph.pdf}
// \end{center}