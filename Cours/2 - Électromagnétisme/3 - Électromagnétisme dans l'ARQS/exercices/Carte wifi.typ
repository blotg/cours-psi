#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "L'ARQS dans une carte wifi",
)

La carte wifi d'un ordinateur portable, au format M.2 2230, est un circuit imprimé de #quan[22 mm] sur #quan[30 mm]. Elle émet et reçoit des ondes électromagnétiques dans deux bandes de fréquences, autour de #quan[2.4 GHz] et de #quan[5 GHz]. Ses antennes, reliées à la carte par de fins câbles coaxiaux, sont logées dans le cadre de l'écran.

#question(coups-de-pouce: (
    "Rappeler la condition d'application de l'ARQS.",
    "Quelle est la longueur caractéristique $lambda$ du système ? La durée caractéristique $tau$ sur laquelle les grandeurs varient ?",
    "Faire le calcul pour les deux bandes de fréquences.",
))[
    L'ARQS est-elle vérifiée sur la carte wifi ?
][
    L'ARQS s'applique si $lambda \/ tau << c$, où $lambda$ est la taille du système, et non la longueur d'onde. Ici, $lambda = #quan[3 cm]$, la plus grande dimension de la carte. Les signaux sont sinusoïdaux : leur durée caractéristique de variation est la période $tau = 1\/f$.

    - à #quan[2.4 GHz] : $lambda \/ tau = lambda f = #quan[7.2e7 m/s] approx #num[0.24] c$ ;
    - à #quan[5 GHz] : $lambda \/ tau = #quan[1.5e8 m/s] = #num[0.5] c$.

    Dans les deux cas, $lambda \/ tau$ n'est pas très petit devant $c$ : l'ARQS n'est pas vérifiée. De façon équivalente, la carte n'est pas petite devant la longueur d'onde $c \/ f$, qui vaut #quan[12.5 cm] et #quan[6 cm].

    À titre de comparaison, pour une installation électrique domestique à #quan[50 Hz], $c \/ f = #quan[6000 km]$ : l'ARQS y est largement vérifiée.
]

#question(coups-de-pouce: (
    "Réécrire la condition d'ARQS sous la forme d'une comparaison entre deux durées.",
    "Que représente la durée $lambda \/ c$ ?",
))[
    Interpréter la condition d'ARQS en comparant deux durées. Dans les pistes en cuivre d'un circuit imprimé, les signaux se propagent à une vitesse d'environ $c \/ 2$. Calculer la durée que met un signal pour traverser la carte et conclure. Jusqu'à quelle fréquence l'ARQS serait-elle vérifiée sur cette carte ?
][
    La condition s'écrit $lambda \/ c << tau$ : la durée que met le champ électromagnétique pour traverser le système doit être négligeable devant la durée sur laquelle il varie. Tout se passe alors comme si les champs s'établissaient instantanément dans tout le système.

    Dans les pistes, le signal se propage à $v approx c \/ 2$ : il traverse la carte en $lambda \/ v = #quan[0.2 ns]$. C'est la moitié de la période à #quan[2.4 GHz] ($1 \/ f = #quan[0.42 ns]$), et autant que la période à #quan[5 GHz] (#quan[0.2 ns]). La condition est encore moins bien vérifiée qu'avec $c$.

    En prenant un facteur 10 pour traduire « très petit devant », l'ARQS est vérifiée si $lambda \/ v <= tau \/ 10$, soit
    $ f <= v / (10 lambda) = #quan[500 MHz] $
]
