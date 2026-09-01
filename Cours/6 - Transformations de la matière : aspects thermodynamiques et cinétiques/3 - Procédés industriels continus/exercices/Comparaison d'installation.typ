#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Comparaison d'installation",
)

Un acide gras insaturé $ce("A")$ est obtenu par saponification d'un ester $ce("E")$ en présence d'un large excès de soude. Cette transformation est modélisée par l'équation
$ ce("E (aq) + HO- (aq) -> A (aq) + alcool (aq)") $
En présence de ce large excès de soude, la vitesse de réaction est du premier ordre par rapport à l'ester, avec une constante de vitesse $k_"app" = qty("6.0E-2", "/min")$.

#question(
    coups-de-pouce: (
        "Relier la vitesse volumique de réaction à la concentration d'ester de deux façons : grâce en faisant intervenir le coefficient stœchiométrique et en utilisant le fait que la réaction est d'ordre 1.",
        "Résoudre l'équation différentielle pour exprimer la concentration d'ester en fonction du temps.",
    ),
)[
    Dans un premier temps, on emploi un *réacteur fermé* contenant #qty("40", "L") de mélange homogène. Quelle doit être la durée de l'opération pour obtenir un taux de conversion égal à #qty("98", "%") ?
][
    $
        v = k_"app" [ce("E")] = -dv([ce("E")], t)
    $
    La solution est
    $
        [ce("E")](t) = [ce("E")]_0 exp(-k_"app" t)
    $
    On note $t_qty("98", "%")$ la durée au bout de laquelle #qty("98", "%") de l'ester a réagi. On a donc
    $
        [ce("E")](t_qty("98", "%")) = [ce("E")]_0 (1 - 0.98) = [ce("E")]_0 exp(-k_"app" t_qty("98", "%"))
    $
    Soit
    #let kapp = 6e-2
    #let t98 = -calc.ln(0.02) / kapp
    $
        t_qty("98", "%") = -ln(0.02) / k_"app"
        approx #qty(scientifique(t98, 2), "min")
    $
]

#question(
    coups-de-pouce: (
        "Faire un bilan de matière en ester sur un système fermé constitué à partir du système ouvert ${\"réacteur\"}$.",
        "Relier la concentration en entrée, la concentration en sortie, le temps de passage et la constante $k_\"app\"$.",
    ),
)[
    On désire cette fois traiter #qty("40", "L/h") de solution dans un *réacteur ouvert* parfaitement agité continu pour obtenir un taux de conversion de #qty("98", "%"). Quels doivent être le temps de passage et le volume du réacteur ?
][
    La conservation de l'ester s'écrit
    $
        F_(ce("E"), e) - F_(ce("E"), s) -k_"app" [ce("E")] V = 0
    $
    En divisant par le débit volumique $Q$, on obtient
    $
        [ce("E")]_e - [ce("E")]_s - k_"app" [ce("E")] tau = 0
    $
    d'où
    $
        tau = ([ce("E")]_e - [ce("E")]_s ) / (k_"app" [ce("E")]_s)
    $
    Pour un taux de conversion de #qty("98", "%"), on a $[ce("E")]_s = [ce("E")]_e (1 - 0.98) = 0.02 [ce("E")]_e$. On en déduit
    #let kapp = 6e-2
    #let tau98 = (1 - 0.02) / (kapp * 0.02)
    $
        tau = 0.98 / (0.02 k_"app")
        approx #qty(scientifique(tau98, 2), "min")
    $
]

#question(
    coups-de-pouce: (
        "Reprendre le résultat précédent et l'appliquer entre un réacteur $i$ et un réacteur $i+1$.",
        "Quelle est la nature de la suite $( [ce(\"E\")]_i )_(i in NN^*)$ ?",
        "Exprimer $[ce(\"E\")]_10$ en fonction de $[ce(\"E\")]_0$, $k_\"app\"$ et $tau$.",
    ),
)[
    On désire, enfin, traiter #qty("40", "L/h") de solution dans une cascade de $n=10$ réacteur parfaitement agités continus de mêmes dimensions, associés en série. On suppose que le temps de passage est le même dans chaque réacteur. Quels doivent être le temps de passage et le volume total des réacteurs pour obtenir un taux de conversion de #qty("98", "%") ?
][
    On peut reprendre le résultat précédent entre le réacteur $i$ et le réacteur $i+1$ :
    $
        [ce("E")]_i - [ce("E")]_(i+1) - k_"app" [ce("E")]_(i+1) tau = 0
    $
    soit
    $
        [ce("E")]_(i+1) = 1 / (1 + k_"app" tau) [ce("E")]_i
    $
    La suite $( [ce("E")]_i )_(i in NN^*)$ est donc géométrique de raison $1 / (1 + k_"app" tau)$ et de terme initial $[ce("E")]_0$. On en déduit
    $
        [ce("E")]_10 = [ce("E")]_0 (1 / (1 + k_"app" tau))^10
    $
    Pour un taux de conversion de #qty("98", "%"), on a
    $
        [ce("E")]_10 = [ce("E")]_0 (1 - 0.98) = 0.02 [ce("E")]_0
    $
    On en déduit
    #let kapp = 6e-2
    #let tau98 = (calc.pow(0.02, -1/10) - 1) / kapp
    $        tau = ( (1 / 0.02)^(1/10) - 1 ) / k_"app"
        approx #qty(scientifique(tau98, 2), "min")
    $
]
