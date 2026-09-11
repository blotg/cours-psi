#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Décrire un système physico-chimique

#flashcard(recto: "Grandeurs de composition", verso: "Concentration $c_i = n_i\\/V$ en $m o l dot L^(-1)$, fraction molaire $x_i = n_i\\/n_(\"tot\")$ sans unité, pression partielle $p_i = x_i P$ en Pa.")
#flashcard(recto: "Variable extensive ou intensive", verso: "Extensive : proportionnelle à la quantité de matière (volume, quantité de matière, enthalpie). Intensive : indépendante de la taille du système (température, pression, concentration).")
#flashcard(recto: "Avancement d'une réaction", verso: "$xi = (n_i - n_(i,0))/nu_i$, en mol, avec $nu_i$ algébrique : négatif pour un réactif, positif pour un produit.")

#question-de-colle("Décrire la composition d'un système physico-chimique à l'aide des grandeurs pertinentes. Reconnaitre le caractère extensif ou intensif d'une variable, sur des exemples.")

= Activité et quotient réactionnel

#flashcard(recto: "Activités", verso: "Soluté très dilué : $a_i = c_i\\/c^circ$ avec $c^circ = 1$ $m o l dot L^(-1)$. Gaz parfait : $a_i = p_i\\/p^circ$ avec $p^circ = 1$ bar. Solide ou liquide pur, solvant : $a_i = 1$.")
#flashcard(recto: "Quotient réactionnel", verso: "$Q_r = product a_i^(nu_i)$, calculé à tout instant à partir de la composition du système.")
#flashcard(recto: "Constante thermodynamique d'équilibre", verso: "$K^circ$ est la valeur que prend $Q_r$ à l'équilibre. Elle ne dépend que de la température.")

#question-de-colle("Définir l'activité d'une espèce dans les différents cas rencontrés. Définir le quotient réactionnel et la constante thermodynamique d'équilibre.")

= Sens d'évolution et état final

#flashcard(recto: "Critère d'évolution spontanée", verso: "Si $Q_r < K^circ$ la réaction évolue dans le sens direct ; si $Q_r > K^circ$ dans le sens indirect ; si $Q_r = K^circ$ le système est à l'équilibre.")
#flashcard(recto: "Équilibre ou transformation totale", verso: "Une transformation est totale si un réactif limitant disparait avant que $Q_r$ n'atteigne $K^circ$. Sinon le système atteint un état d'équilibre chimique.")

#question-de-colle("Énoncer le critère d'évolution spontanée d'un système chimique et l'illustrer. Déterminer la composition du système dans l'état final en distinguant équilibre chimique et transformation totale.")
