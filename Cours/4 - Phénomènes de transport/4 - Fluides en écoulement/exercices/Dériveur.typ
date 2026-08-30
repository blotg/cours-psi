

// \exercice{Dériveur}

// \begin{figure}[!ht]
//   \centering
//   \begin{tikzpicture}[%
//     >=latex,
//   ]
//   \draw (0,0) .. controls (1,1) and (4,1) .. (5,1) -- (5,-1) .. controls (4,-1) and (1,-1) .. (0,0);
//   \draw[dashdotted] (-1,0) -- (6,0);
//   \draw (2.3,0) .. controls (2.3,0.2) and (3,0.1) .. (3.7,0) .. controls (3,-0.1) and (2.3,-0.2) .. (2.3,0) node[midway, below] {dérive};
//   \draw[dashed] (1.5,0) --++ (30:4) coordinate (A) node[pos=0.8, right] {ligne de corde};
//   \draw (1.5,0) .. controls (1.5,0.5) and (4,1.7) .. (A) node[midway, sloped, above] {voile};
//   \draw (1.5,0) ++ (3,0) arc (0:30:3) node[midway, right] {$\alpha_1$};
//   \draw[->] (8.5,0) --++ (-1,0) node[left] {$\vv{u_x}$};
//   \draw[->] (8.5,0) --++ (0,1) node[above] {$\vv{u_y}$};
//   \draw[->] (0,0) --++ (160:1.5) node[above right] {$\vv{v}_\text{vit}$};
//   \draw (180:0.8) arc (180:160:0.8) node[midway, left] {$i_e$};
//   \draw[->] (-3,-1) --++ (0,2) node[right] {$\vv{v}_\text{vent}$};
// \end{tikzpicture}

// \end{figure}
// On considère un dériveur, c'est-à-dire un petit bateau à voile équipé d'une dérive. Comme tous les navires, il est amené à se déplacer en restant sans cesse à l'interface entre deux fluides, l'air et l'eau. Compte tenu des vitesses mises en jeu dans un tel contexte, l'air et l'eau peuvent tous deux être considérés en écoulement homogène et incompressibles.

// On prendra pour l'air $\mu_a = \SI{1,2}{kg.m^{-3}}$, $\eta_a = \SI{1,8e-5}{Pl}$ ; les valeurs relatives à l'eau sont à connaitre : $\mu_e = \SI{1.0e3}{kg.m^{-3}}$, $\eta_e = \SI{1,0e-3}{Pl}$.

// L'eau est considérée immobile dans le référentiel terrestre. En revanche, le vent souffle avec une vitesse de norme $v_\text{vent} = \SI{50}{km.h^{-1}}$. Étant à l'interface entre deux fluides, le dériveur utilise deux sortes d'ailes pour s'y déplacer : à voile, pour laquelle le mat mesure $L_{env, a} = \SI{5,0}{m}$, et la bôme (donc la corde) $L_a = \SI{2,5}{m}$ ; et la dérive, de longueur de corde $L_{env, e}$. On suppose dans cet exercice que les cordes sont de longueur constante tout le long des envergures.
// \begin{enumerate}
//   \question{Si le dériveur se déplaçait par rapport à l'eau à une vitesse de norme $v_e = \SI{20}{km.h^{-1}}$, dans une direction orthogonale à celle du vent, quelles seraient les valeurs des nombres de Reynolds associés aux deux écoulements : air et eau ? Commenter.}
//     [Pour l'écoulement d'air autour de la voile, quelle vitesse prendre ? Quelle viscosité cinématique ? Quelle distance caractéristique ?]
//     [Pour l'écoulement d'eau autour de la dérive, quelle vitesse prendre ? Quelle viscosité cinématique ? Quelle distance caractéristique ?]
//   \question{La figure ci-dessus montre un schéma très simplifié du dériveur en vue de dessus. A la différence d'un char à voile, dont les roues adhèrent bien au sol, un dériveur ne peut pas se déplacer dans la direction de son axe $(Ox)$. En plus de son mouvement d'avancement selon son axe, il subit un mouvement dit <<de dérive>>. La direction de sa vitesse $\vv{v_{vit}}$ par rapport à l'eau est indiquée sur la figure. En utilisant la portance et la trainée des deux ailes que constituent la voile et la dérive, effectuer un schéma des différentes forces horizontales agissant sur le dériveur. Y a t-il d'autres forces à ajouter ?}
//     [Représenter la vitesse de l'eau par rapport au dériveur.]
//     [Les forces de trainée sont colinéaires aux vitesses. Les forces de portance sont orthogonales aux vitesses.]
//     [En plus des forces horizontales, quelles sont les deux forces à rajouter.]
//   \question{En déduire un ordre de grandeur de l'envergure $L_{env, e}$ à choisir pour la dérive.}
//     [En régime stationnaire, l'accélération est nulle, et donc la somme des forces l'est aussi.]
//     [Projeter le TRC sur l'axe $(Ox)$.]
// \end{enumerate}