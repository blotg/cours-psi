#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Machines cycliques dithermes

#flashcard(
    recto: "Variation d'énergie interne et d'entropie sur un cycle",
    verso: "Sur un cycle, $Delta U = 0$ et $Delta S = 0$ car ce sont des fonctions d'état.",
)
#flashcard(
    recto: "Signes du travail et des transferts thermiques pour un moteur ditherme",
    verso: "Il fournit du travail en exploitant le transfert thermique d'une source chaude à une source froide. $ W < 0 $$ Q_C > 0 $$ Q_F < 0 $",
)
#flashcard(
    recto: "Rendement d'un moteur ditherme",
    verso: "$ eta = -W/Q_C $",
)
#flashcard(
    recto: "Signes du travail et des transferts thermiques pour un climatiseur ou un réfrigérateur",
    verso: "Un travail permet de transférer de la chaleur dans le sens froid vers chaud. $ W > 0 $$ Q_C < 0 $$ Q_F > 0 $",
)
#flashcard(
    recto: "Efficacité d'un climatiseur ou d'un réfrigérateur",
    verso: "$ eta = Q_F/W $",
)
#flashcard(
    recto: "Signes du travail et des transferts thermiques pour une pompe à chaleur",
    verso: "Un travail permet de transférer de la chaleur dans le sens froid vers chaud. $ W > 0 $$ Q_C < 0 $$ Q_F > 0 $",
)
#flashcard(
    recto: "Efficacité d'une pompe à chaleur",
    verso: "$ eta = -Q_C/W $",
)
#flashcard(
    recto: "Ordres de grandeur des rendements pour des moteurs thermiques",
    verso: "Moteur à essence ou diesel #qty(\"25\",\"%\") à #qty(\"45\",\"%\").",
)
#flashcard(
    recto: "Ordres de grandeur de l'efficacité d'une pompe à chaleur",
    verso: "#qty(\"300\",\"%\") à #qty(\"400\",\"%\").",
)

#question-de-colle(
    "Établir l'inégalité de Clausius pour une machine ditherme.",
)
#question-de-colle(
    "Pour un moteur ditherme, une pompe à chaleur ou un climatiseur (au choix du colleur), schématiser les échanges énergétiques en précisant leur signe, définir le rendement et établir le théorème de Carnot.",
)
