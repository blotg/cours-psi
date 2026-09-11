#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Deuxième principe

#flashcard(recto: "Deuxième principe de la thermodynamique", verso: "Il existe une fonction d'état extensive $S$ telle que $Delta S = S_e + S_c$ avec $S_e = sum Q_i\\/T_i$ et $S_c >= 0$, nulle si et seulement si la transformation est réversible.")
#flashcard(recto: "Interprétation de l'entropie", verso: "L'entropie mesure le désordre statistique : plus le nombre de micro-états compatibles avec l'état macroscopique est grand, plus l'entropie est élevée.")

#question-de-colle("Énoncer le deuxième principe de la thermodynamique, en précisant les hypothèses, le nom et l'unité de chaque grandeur. Préciser le statut de chacun des deux termes.")

= Entropie du gaz parfait et de la phase condensée

#flashcard(recto: "Variation d'entropie d'un gaz parfait", verso: "$Delta S = n C_(V m) ln(T_f\\/T_i) + n R ln(V_f\\/V_i)$, ou encore $n C_(P m) ln(T_f\\/T_i) - n R ln(P_f\\/P_i)$.")
#flashcard(recto: "Variation d'entropie d'une phase condensée", verso: "$Delta S = m c ln(T_f\\/T_i)$.")
#flashcard(recto: "Lois de Laplace", verso: "Pour un gaz parfait subissant une transformation adiabatique réversible à $gamma$ constant : $P V^gamma$, $T V^(gamma-1)$ et $T^gamma P^(1-gamma)$ sont constants.")
#flashcard(recto: "Entropie de changement d'état", verso: "$Delta s = (Delta h)/T$ à la température d'équilibre, en $J dot K^(-1) dot k g^(-1)$.")

#question-de-colle("Énoncer les lois de Laplace en précisant les hypothèses. Démontrer celles portant sur $(T,V)$ et $(T,P)$ à partir de celle portant sur $(P,V)$.")
#question-de-colle("Calculer l'entropie créée lors de la mise en contact de deux corps de capacités thermiques identiques et de températures différentes, et vérifier son signe.")
