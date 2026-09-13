#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Oxydants, réducteurs, potentiel

#flashcard(
    recto: [Oxydant et réducteur],
    verso: [Un oxydant capte des électrons, un réducteur en cède. Une réaction d'oxydo-réduction est un transfert d'électrons entre deux couples.],
)
#flashcard(
    recto: [Formule de Nernst],
    verso: [$ E = E^circ + (R T)/(n cal(F)) log (product a_("ox"))/(product a_("red")) $ À #qty("25", "Celsius"), $(R T)/cal(F)=#num("0.06")$ ; $n$ est le nombre d'électrons échangés.],
)
#flashcard(
    recto: [Prévision du sens d'une réaction],
    verso: [L'oxydant du couple de potentiel le plus élevé réagit avec le réducteur du couple de potentiel le plus bas : c'est la règle du gamma.],
)

= Piles

#flashcard(
    recto: [Anode],
    verso: [Électrode où a lieu l'oxydation.],
)
#flashcard(
    recto: [Cathode],
    verso: [Électrode où a lieu la réduction.],
)
#flashcard(
    recto: [Constitution d'une pile],
    verso: [Deux demi-piles reliées par un pont salin.],
)
#flashcard(
    recto: [Bornes $+$ et $-$ d'une pile],
    verso: [La borne $+$ correspond à la cathode, la borne $-$ à l'anode.],
)
#flashcard(
    recto: [Force électromotrice d'une pile],
    verso: [$ e = E_(+) - E_(-) $ C'est la différence des potentiels d'électrode calculés par la formule de Nernst. La pile est usée quand $e = 0$, c'est-à-dire à l'équilibre chimique.],
)

#question-de-colle[
    Schématiser une pile. Préciser les bornes, la nature des électrodes, le sens du courant et du déplacement des électrons.
]

= Diagrammes potentiel-pH
