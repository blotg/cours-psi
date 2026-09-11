#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Champ magnétique

#flashcard(recto: "Ordres de grandeur de champs magnétiques", verso: "Champ terrestre : quelques dizaines de $mu T$. Aimant usuel : $10$ mT à $1$ T. IRM : $1$ à $3$ T.")
#flashcard(recto: "Moment magnétique d'une boucle de courant", verso: "$va(m) = i va(S)$, en $A dot m^2$, orienté par la règle de la main droite à partir du sens du courant.")

#question-de-colle("Tracer l'allure des cartes de champ magnétique d'un aimant droit, d'une spire circulaire et d'une bobine longue. Préciser où le champ est quasi uniforme.")

= Forces de Laplace

#flashcard(recto: "Force de Laplace élémentaire", verso: "$dif va(F) = i dif va(l) and va(B)$.")
#flashcard(recto: "Couple subi par une spire dans un champ uniforme", verso: "$va(Gamma) = va(m) and va(B)$ : la spire tend à aligner son moment magnétique sur le champ.")

#question-de-colle("Établir l'expression de la résultante des forces de Laplace sur la barre mobile des rails de Laplace.")
#question-de-colle("Spire rectangulaire parcourue par un courant et placée dans un champ uniforme orthogonal à son axe de rotation : montrer que les forces de Laplace forment un couple de moment $va(Gamma) = va(m) and va(B)$, et que la puissance des actions de Laplace s'écrit $P = Gamma omega$.")

= Lois de l'induction

#flashcard(recto: "Loi de Faraday", verso: "$e = - (dif Phi)/(dif t)$, avec $e$ en V et $Phi$ le flux du champ magnétique à travers le circuit orienté, en Wb.")
#flashcard(recto: "Loi de Lenz", verso: "Les conséquences de l'induction s'opposent à la cause qui leur a donné naissance.")
#flashcard(recto: "Inductance propre", verso: "$Phi_(\"propre\") = L i$, avec $L$ en H. Une bobine de laboratoire fait quelques dizaines de mH.")
#flashcard(recto: "Inductance mutuelle en influence totale", verso: "$M = sqrt(L_1 L_2)$ : c'est le meilleur couplage possible entre deux bobines.")
#flashcard(recto: "Énergie de couplage magnétique", verso: "$E_(\"couplage\") = M i_1 i_2$, qui s'ajoute aux énergies propres $1/2 L_1 i_1^2$ et $1/2 L_2 i_2^2$.")

#question-de-colle("Définir le flux d'un champ magnétique à travers un circuit et citer la loi de Faraday. À partir de cette loi, montrer qu'une bobine se comporte comme un générateur de fem $e = -L (dif i)\\/(dif t)$, et retrouver la convention récepteur $u_L = L (dif i)\\/(dif t)$.")
#question-de-colle("Deux bobines couplées par une inductance mutuelle : écrire les deux équations différentielles couplées, puis faire le bilan de puissance en faisant apparaitre les énergies stockées et l'énergie de couplage.")

= Conversion de puissance

#flashcard(recto: "Conversion électromécanique dans les rails de Laplace", verso: "La puissance de la force de Laplace et la puissance de la fem induite sont opposées : la conversion se fait sans perte, les pertes venant de la résistance du circuit.")
#flashcard(recto: "Loi des tensions du transformateur idéal", verso: "$u_2\\/u_1 = n_2\\/n_1$, sous les hypothèses de flux canalisé, sans fuite ni pertes.")

#question-de-colle("Rails de Laplace sans générateur, tige tirée par une force constante : établir les équations électrique et mécanique, les découpler et les résoudre pour exprimer $i(t)$ et $v(t)$.")
#question-de-colle("À partir des équations électrique et mécanique des rails de Laplace, faire le bilan de puissance et montrer que le dispositif convertit de la puissance mécanique en puissance électrique.")
#question-de-colle("Établir la loi des tensions d'un transformateur idéal en précisant les hypothèses simplificatrices.")
