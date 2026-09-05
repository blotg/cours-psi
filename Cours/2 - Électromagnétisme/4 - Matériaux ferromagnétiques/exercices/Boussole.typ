#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "La boussole",
    ouvert: true,
)

Visionner la vidéo suivante.

#lien("https://www.youtube.com/shorts/ES7-7crFrI0")

#let J = 1 / 12 * 5e-3 * calc.pow(5e-2, 2)
#let B = 2e-5
#let T = 3
#let M = 4 * calc.pow(calc.pi, 2) * J / (B * calc.pow(T, 2))


*Données :*

Moment d'inertie de l'aiguille de la boussole : $J = #qty(scientifique(J, 1), "kg m^2")$.

Composante horizontale du champ magnétique terrestre : $B = #qty(scientifique(B, 1), "T")$.

#question(
    coups-de-pouce: (
        "Faire l'inventaire des moments s'exerçant sur l'aiguille de la boussole.",
        "Rappeler l'expression du TMC (dans sa version en rotation autour d'un axe fixe).",
        "Montrer que l'équation différentielle régissant le mouvement de l'aiguille est celle d'un oscillateur harmonique et donner l'expression de la période des oscillations.",
        "La vidéo permet d'estimer la période des oscillations. En déduire le moment magnétique de la boussole.",
    ),
)[
    Calculer le moment magnétique de la boussole de la vidéo.
][
    On étudie l'aiguille de boussole, soumise aux actions :
    - poids (de moment nul)
    - force de réaction du support (de moment nul si on suppose la liaison pivot idéale)
    - l'action du champ magnétique (de moment $va(cal(M)) and va(B)$)
    - les frottements (négligés)

    On note $theta(t)$ l'angle entre l'aiguille et la composante horizontale du champ magnétique terrestre.

    Le TMC s'écrit $ J dv(theta, t, 2) = (va(cal(M)) and va(B)) dprod va(e_z) = -cal(M) B sin(theta) $

    Aux petits angles, on a $sin(theta) approx theta$, donc l'équation différentielle devient $ dv(theta, t, 2) = -(cal(M) B)/J theta = - omega^2 theta $ avec $ omega = sqrt((cal(M) B)/J) $

    Cette équation différentielle est celle d'un oscillateur harmonique de pulsation $omega$.

    La période des oscillations est donc $ T = (2 pi) / omega = 2 pi sqrt(J/(cal(M) B)) $

    Avec la vidéo, on peut estimer la période des oscillations à environ $T approx qty("3", "s")$, soit $ cal(M) = 4 pi^2J/(B T^2) approx qty(#scientifique(M, 1), "A m^2") $
]
