#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Vocabulaire des transformations

#flashcard(
    recto: [Signification de isobare, monobare, isotherme, monotherme, isochore, monochore],
    verso: [/ "Iso-" : la grandeur est uniforme et constante dans le système tout au long de la transformation
    / "Mono-" : c'est la grandeur du milieu extérieur qui est constante, le système n'étant défini qu'aux états initial et final
    / "-bare" : la pression
    / "-therme" : la température
    / "-chore" : le volume
    ],
)
#flashcard(
    recto: [Transformation adiabatique],
    verso: [Sans transfert thermique avec l'extérieur : $Q = 0$.],
)

= Travail des forces de pression

#flashcard(
    recto: [Travail élémentaire des forces de pression],
    verso: [$ delta W = -P_"ext" dd(V) $ le système reçoit du travail quand son volume diminue],
)
#flashcard(
    recto: [Travail reçu lors d'une transformation isochore],
    verso: [$ W = 0 $ ($dd(V) = 0$).],
)
#flashcard(
    recto: [Travail reçu lors d'une transformation monobare],
    verso: [$ W = -P_"ext" Delta V $],
)
#flashcard(
    recto: [Travail reçu lors d'une transformation isotherme quasi-statique d'un gaz parfait],
    verso: [$ W = integral_(V_i)^(V_f) -(n R T)/V dd(V) = n R T ln(V_f/V_i) $],
)
#flashcard(
    recto: [Lien entre l'aire d'un cycle en diagramme de Clapeyron et travail échangé],
    verso: [L'aire du cycle vaut le travail échangé au cours du cycle.
    
    Parcouru dans le sens horaire, le cycle est moteur (le système cède du travail).
    
    Parcouru dans le sens trigonométrique, il est récepteur.],
)

#question-de-colle(
    [Donner l'expression du travail élémentaire des forces de pression. Exprimer le travail reçu dans les trois cas : transformation isochore, monobare, et isotherme quasi-statique d'un gaz parfait.],
)

= Transferts thermiques

#flashcard(
    recto: [Les trois modes de transfert thermique],
    verso: [/ Conduction : de proche en proche dans la matière immobile
    / Convection : par déplacement de matière
    / Rayonnement : par ondes électromagnétiques, sans support],
)
