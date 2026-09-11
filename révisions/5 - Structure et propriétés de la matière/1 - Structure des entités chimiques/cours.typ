#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Classification périodique

#flashcard(recto: "Électrons de valence", verso: "Ce sont les électrons de la couche de nombre quantique principal le plus élevé. Pour les blocs s et p, leur nombre se lit dans le numéro de colonne.")
#flashcard(recto: "Organisation de la classification", verso: "Une ligne est une période (même couche de valence), une colonne une famille (même configuration de valence, donc mêmes propriétés chimiques).")
#flashcard(recto: "Électronégativité", verso: "Aptitude d'un atome à attirer les électrons d'une liaison. Elle croit de la gauche vers la droite d'une période et du bas vers le haut d'une colonne.")

#question-de-colle("Déterminer, pour les éléments des blocs s et p, le nombre d'électrons de valence d'un atome à partir de sa position dans le tableau périodique. Expliquer l'évolution de l'électronégativité dans la classification.")

= Liaisons et schémas de Lewis

#flashcard(recto: "Ordre de grandeur d'une liaison covalente", verso: "Longueur de l'ordre de $100$ pm, énergie de l'ordre de quelques centaines de $k J dot m o l^(-1)$.")
#flashcard(recto: "Règle de l'octet", verso: "Les atomes tendent à s'entourer de huit électrons de valence ; les éléments de la troisième période et au-delà peuvent l'étendre.")
#flashcard(recto: "Mésomérie", verso: "Quand plusieurs schémas de Lewis sont envisageables, la molécule réelle est un hybride de résonance : les électrons délocalisés sont répartis sur l'ensemble du système conjugué.")

#question-de-colle("Établir un ou plusieurs schémas de Lewis pertinents pour une molécule ou un ion donné, et justifier le choix du plus représentatif à l'aide des charges formelles et de l'électronégativité.")

= Géométrie des molécules

#flashcard(recto: "Méthode VSEPR", verso: "Les doublets de la couche de valence de l'atome central se repoussent et se placent le plus loin possible les uns des autres : la géométrie se déduit du nombre de doublets liants et non liants.")
#flashcard(recto: "Moment dipolaire", verso: "$va(p) = q va(d)$, en $C dot m$ ou en debye ($1$ D $approx 3,3 dot 10^(-30)$ $C dot m$). Une molécule est polaire si la somme vectorielle des moments de liaison est non nulle.")

#question-de-colle("Prévoir et justifier la géométrie d'entités de type $A X_n$ avec $n <= 4$, et de type $A X_p E_q$ avec $p+q = 3$ ou $4$. En déduire dans chaque cas si la molécule est polaire.")
