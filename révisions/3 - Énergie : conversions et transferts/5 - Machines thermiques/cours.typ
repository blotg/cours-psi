#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Machines cycliques dithermes

#flashcard(recto: "Bilan sur un cycle", verso: "Sur un cycle, $Delta U = 0$ et $Delta S = 0$ : donc $W + Q_C + Q_F = 0$ et $Q_C\\/T_C + Q_F\\/T_F = -S_c <= 0$ (inégalité de Clausius).")
#flashcard(recto: "Moteur ditherme", verso: "Il fournit du travail : $W < 0$, $Q_C > 0$, $Q_F < 0$. Rendement $eta = -W\\/Q_C$, majoré par $eta_(\"Carnot\") = 1 - T_F\\/T_C$.")
#flashcard(recto: "Machine frigorifique", verso: "Elle refroidit la source froide : $W > 0$, $Q_F > 0$, $Q_C < 0$. Efficacité $e = Q_F\\/W <= T_F\\/(T_C - T_F)$.")
#flashcard(recto: "Pompe à chaleur", verso: "Elle chauffe la source chaude : $W > 0$, $Q_C < 0$, $Q_F > 0$. Efficacité $e = -Q_C\\/W <= T_C\\/(T_C - T_F)$.")
#flashcard(recto: "Ordres de grandeur des rendements", verso: "Moteur à essence $25$ à $35$ %, diesel $35$ à $45$ %, centrale thermique $40$ %. Une pompe à chaleur domestique a une efficacité de $3$ à $4$.")

#question-de-colle("Moteur thermique ditherme : expliquer à quoi il sert, faire le schéma des échanges énergétiques, préciser le signe de $W$, $Q_C$ et $Q_F$, définir le rendement et établir le théorème de Carnot. Donner un ordre de grandeur du rendement réel.")
#question-de-colle("Machine frigorifique : mêmes questions, avec l'efficacité.")
#question-de-colle("Pompe à chaleur : mêmes questions, avec l'efficacité.")
#question-de-colle("Expliquer le principe de la cogénération et dire en quoi elle améliore le bilan énergétique d'une installation.")
