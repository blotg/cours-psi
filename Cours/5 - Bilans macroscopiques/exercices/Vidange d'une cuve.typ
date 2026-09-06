#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Vidange d'une cuve",
    ouvert: true,
)

Un agriculteur souhaite vidanger une cuve cubique d'un mètre cube remplie d'eau par un robinet situé en bas.

#figure(
    image("../images/cuve.jpg", width: 7cm),
)

#question(
    coups-de-pouce: (
        "En supposant l'écoulement parfait, stationnaire, incompressible et homogène, établir l'expression de la vitesse au niveau de la vanne.",
        "Relier le débit volumique à la vitesse de l'écoulement au niveau de la vanne.",
        "Relier le volume d'eau dans la cuve à la hauteur d'eau.",
        "Formuler une équation différentielle sur la hauteur ou le volume d'eau puis l'intégrer.",
        "L'équation différentielle peut être intégrée entre l'état initial et l'état final par séparation des variables.",
        "$2 sqrt(x)$ est une primitive de $1/sqrt(x)$",
        "Estimer la section de la vanne à partir de la photo.",
    ),
)[
    Combien de temps doit-il prévoir ?
][
    On note $h(t)$ la hauteur d'eau dans la cuve à l'instant $t$, $a$ la largeur de la cuve, $S$ la section de la vanne, $v(t)$ la vitesse de l'eau à la sortie de la cuve et $D_V(t)$ le débit volumique à la sortie de la cuve.

    Si on suppose l'écoulement parfait, stationnaire, incompressible et homogène, on peut appliquer le théorème de Bernoulli entre la surface libre de l'eau dans la cuve (point 1) et la sortie du robinet (point 2). On a alors, en négligeant la vitesse de la surface libre par rapport à la vitesse de sortie (ce qui revient à supposer que la section de la cuve est bien plus grande que celle de la vanne),
    $
        P_1 + rho g h(t) + 0 = P_2 + 0 + 1/2 rho v^2\
    $
    Ici, $P_1 = P_2 = P_"atm"$, d'où
    $
        v = sqrt(2 g h(t))
    $
    Le débit volumique s'écrit alors
    $
        D_V = S v = S sqrt(2 g h(t))
    $
    Pour un fluide incompressible, le volume se conserve, donc
    $
        dd(V, 2) = delta^2 V\
        a^2 (h(t+dd(t)) - h(t)) = -D_V dd(t)\
        a^2 dv(h, t) = -S sqrt(2 g h(t))\
    $
    En séparant les variables, on obtient
    $ dd(h)/sqrt(h) = - (S sqrt(2 g))/a^2 dd(t) $
    $ integral_a^(0) dd(h)/sqrt(h) = - (S sqrt(2 g))/a^2 integral_(0)^(t_f) dd(t) $

    $ [2 sqrt(h)]_(h=a)^(h=0) = - (S sqrt(2 g))/a^2 t_f $
    $ -2 sqrt(a) = - (S sqrt(2 g))/a^2 t_f $
    $ t_f = (2 a^(5/2))/(S sqrt(2 g)) $
    On estime la section de la vanne à $S approx qty("10","cm^2")$ et le côté de la cuve à $a = #qty("1", "m")$. On trouve alors
    #let a = 1
    #let S = 10e-4
    #let g = 9.81
    #let tf = 2 * calc.pow(a, 5/2) / (S * calc.sqrt(2 * g))
    $
      t_f = #qty(scientifique(tf,1), "s") approx #qty(scientifique(tf/60,1), "min")
    $
]
