#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Vocabulaire des transformations

#flashcard(recto: "Transformations : les préfixes", verso: "« Iso- » : la grandeur est uniforme et constante dans le système tout au long de la transformation. « Mono- » : c'est la grandeur du milieu extérieur qui est constante, le système n'étant défini qu'aux états initial et final.")
#flashcard(recto: "Transformation adiabatique", verso: "Sans transfert thermique avec l'extérieur : $Q = 0$.")

#question-de-colle("Définir une transformation monobare, isobare, isochore, monotherme, isotherme et adiabatique.")

= Travail des forces de pression

#flashcard(recto: "Travail élémentaire des forces de pression", verso: "$delta W = -P_(\"ext\") dif V$ : le système reçoit du travail quand son volume diminue.")
#flashcard(recto: "Travail dans les cas classiques", verso: "Isochore : $W = 0$. Monobare : $W = -P_(\"ext\") Delta V$. Isotherme réversible d'un gaz parfait : $W = -n R T ln(V_f\\/V_i)$.")
#flashcard(recto: "Aire d'un cycle en diagramme de Clapeyron", verso: "Elle vaut le travail échangé au cours du cycle. Parcouru dans le sens horaire, le cycle est moteur (le système cède du travail) ; dans le sens trigonométrique, il est récepteur.")

#question-de-colle("Donner l'expression du travail élémentaire des forces de pression. Calculer le travail reçu dans les trois cas classiques : transformation isochore, monobare, et isotherme mécaniquement réversible d'un gaz parfait.")
#question-de-colle("Dessiner un cycle quelconque en diagramme de Clapeyron, interpréter son aire et préciser selon le sens de parcours si le système reçoit ou cède du travail.")

= Transferts thermiques

#flashcard(recto: "Les trois modes de transfert thermique", verso: "Conduction (de proche en proche dans la matière immobile), convection (par déplacement de matière), rayonnement (par ondes électromagnétiques, sans support).")

#question-de-colle("Citer les trois modes de transfert thermique et donner pour chacun un exemple accompagné d'un schéma.")
