#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Signaux périodiques

#flashcard(
    recto: "Valeur moyenne",
    verso: " $mean(s) = 1/T integral_0^T s(t) dd(t) $",
)
#flashcard(
    recto: "Valeur efficace",
    verso: "$ S_\"eff\" = sqrt(mean(s^2)) $",
)
#flashcard(
    recto: "Valeur efficace d'un signal sinusoïdal",
    verso: "$S_\"eff\" = S_m / sqrt(2)$, où $S_m$ est l'amplitude.",
)
#flashcard(
    recto: "Fondamental et harmoniques",
    verso: "Un signal périodique de fréquence $f$ se décompose en une somme de sinusoïdes de fréquences $f$ (le fondamental), $2f$, $3f$… (les harmoniques).",
)

#question-de-colle(
    "Définir la valeur moyenne et la valeur efficace d'un signal périodique. Établir par le calcul l'expression de la valeur efficace d'un signal sinusoïdal.",
)

= Fonction de transfert

#flashcard(
    recto: "Fonction de transfert",
    verso: "$ underline(H) = underline(s)/underline(e) $",
)
#flashcard(
    recto: "Gain",
    verso: "$G = |underline(H)|$",
)
#flashcard(
    recto: "Gain en décibels",
    verso: "$G_\"dB\" = 20 log G$",
)
#flashcard(
    recto: "Déphasage",
    verso: "$phi = arg underline(H)$",
)
#flashcard(
    recto: "Pulsation de coupure et bande passante",
    verso: "La pulsation de coupure à $-3$ dB est celle où $G = G_max/sqrt(2)$.

    La bande passante est l'intervalle de pulsations où $G >= G_max/sqrt(2)$.",
)

#question-de-colle(
    "Définir la fonction de transfert, le gain, le gain en décibels et le déphasage d'un filtre, en précisant les unités. Définir la pulsation de coupure à $-3$ dB et la bande passante.",
)

= Filtres usuels

#flashcard(
    recto: "Comportement asymptotique d'un condensateur",
    verso: "- À basse fréquence, le condensateur est un interrupteur ouvert
    - À haute fréquence, c'est l'inverse.",
)
#flashcard(
    recto: "Comportement asymptotique d'une bobine",
    verso: "- À basse fréquence, la bobine est un fil.
    - À haute fréquence, la bobine un interrupteur ouvert.",
)

#question-de-colle(
    "Pour un filtre $R C$ avec sortie aux bornes du condensateur : déterminer la nature du filtre sans calcul, établir sa fonction de transfert et tracer le diagramme de Bode (en gain et en phase).",
)
#question-de-colle(
    "Pour un filtre $R L C$ avec sortie aux bornes de la résistance : déterminer la nature du filtre sans calcul, établir la fonction de transfert sous forme canonique. Tracer le diagramme de Bode. Établir la bande passante. On se placera dans le cas $Q > 1/2$",
)
