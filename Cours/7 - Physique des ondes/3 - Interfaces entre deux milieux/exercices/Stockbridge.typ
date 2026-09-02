#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Amortisseur de Stockbridge",
    ouvert: true,
)

Les amortisseurs de Stockbridge sont utilisés pour réduire les vibrations dans les câbles dues au vent, notamment ceux des ponts suspendus ou des lignes haute tension. Ils se comportent comme des amortisseurs et exercent une force verticale $F = - alpha v$ sur le cable où $v$ est la vitesse verticale du cable.

#figure(
    grid(
        columns: (1fr,) * 2,
        image("/images/Stockbridge1.jpeg", height: 5cm), image("/images/Stockbridge2.png", height: 5cm),
    ),
)

On s'intéresse à un cable en aluminium (de masse volumique $qty("2.7", "g/cm^3")$) de section #qty("500", "mm^2") sur lequel on veut installer un amortisseur de Stockbridge pour éliminer les vibrations. On suppose que le cable est tendu par une force de #qty("1000", "N").


#question()[
    Quel paramètre de l'amortisseur de Stockbridge doit-on choisir pour que les vibrations soient éliminées, c'est -à-dire pour qu'une onde incidente ne donne lieu à aucune onde réfléchie ?
][
    On modélise les ondes incidente et réfléchie dans la ligne par
    $
        cases(
            underline(y_i) = underline(y_(i,0)) e^(i(omega t + k x)),
            underline(y_r) = underline(y_(r,0)) e^(i(omega t - k x))
        )
    $
    La condition aux limites s'obtient en appliquant le théorème de la résultante cinétique à une portion de cable très courte au niveau de l'amortisseur de Stockbridge. On trouve

    #figure(
        canvas({
            import cetz.draw: *
            bezier((0, 0), (2, 1), (60deg, 1))
            circle((0, 0), radius: .05, fill: black)
            line((0, 0), (0, -0.5), stroke: 2pt)
            line((-0.2, -0.5), (0.2, -0.5), stroke: 2pt)
            line((-0.3, -0.1), (-0.3, -1), (0.3, -1), (0.3, -0.1), stroke: 2pt)
            line((0, -1), (0, -1.5), stroke: 2pt)
            line((-0.4, -1.5), (0.4, -1.5), stroke: 2pt)
            line((-0.3, -1.5), (rel: (-135deg, 0.3)), stroke: 2pt)
            line((-0.1, -1.5), (rel: (-135deg, 0.3)), stroke: 2pt)
            line((0.1, -1.5), (rel: (-135deg, 0.3)), stroke: 2pt)
            line((0.3, -1.5), (rel: (-135deg, 0.3)), stroke: 2pt)
            line((0, 0), (rel: (60deg, 1)), mark: (end: ">>", fill: black))
            content((), $va(T)(0,t)$, anchor: "south", padding: .2em)
        }),
    )

    $
        va(T)(x=0,t) dot ey + F = 0
    $
    $
        theta(x=0, t) T - alpha pdv(y, t)|_(x=0) = 0
    $
    $
        T lr(pdv(y, x)|)_(x=0) - alpha pdv(y, t)|_(x=0) = 0
    $
    $
      i k T underline(y_(i,0)) - i k T underline(y_(r,0))  - alpha i omega underline(y_(i,0)) - alpha i omega underline(y_(r,0)) = 0
    $
    $
      underline(y_(r,0)) (-k T - alpha omega) = underline(y_(i,0)) (-k T + alpha omega)
    $
    $
      underline(y_(r,0)) = (-k T + alpha omega)/(-k T - alpha omega) underline(y_(i,0)) = (k T - alpha omega)/(k T + alpha omega) underline(y_(i,0))
    $
    Il n'existe pas d'onde réfléchie si $underline(y_(r,0)) = 0$, c'est-à-dire si
    $
    alpha = k T / omega = T/c = sqrt(T mu)
    $
    où la masse linéique $mu$ est liée à la masse volumique $rho$ par $mu = rho S$, d'où
    $
    #let T = 1000
    #let r = 2.7e3
    #let S = 500e-6
      alpha = sqrt(T rho S) = #qty(scientifique(calc.sqrt(T*r*S), 2), "N s/m")
    $
]
