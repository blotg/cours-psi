#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Einstein relation and stability of isothermal atmosphere",
)

The atmosphere is described as an isothermal ideal gas. In the terrestrial gravitation field, pressure varies as
$ P(z)=P_0 exp (-(m g z)/(k_B T) ) $
where the axis $O_z$ is vertical and ascending, $z=0$ at sea level and $k_B = R\/Na$ is the Boltzmann constant.

#question(
    coups-de-pouce: (
        "Attention à ne pas confondre la quantité de matière et la densité particulaire, toutes deux notées fréquemment $n$.",
    ),
)[
    Using the ideal gas law, ascertain the particle density $n(z)$.
][
    The ideal gas law gives $P V=n_"mol" R T$ where $n_"mol"$ is the amount of substance. By dividing by the volume, we get
    $ P = n_"mol"/V R T = n/Na R T = n k_B T $

    Thus $ n(z) = P(z)/(k_B T) = P_0/(k_B T) exp (-(m g z)/(k_B T) ) $
]

#question(
    coups-de-pouce: (),
)[
    Using Fick law, express the current density vector $va(j_"diff")$ due to the diffusion of particles.
][
    $
        va(j_"diff") = - D grad n = D (P_0 m g)/(k_B T)^2 exp (-(m g z)/(k_B T) ) va(e_z)
    $
]

#question(
    coups-de-pouce: (
        "Le modèle proposé ressemble au modèle de Drude. Appliquer la loi de la quantité de mouvement en régime stationnaire.",
        "Relier la vitesse au vecteur densité de courant de particules.",
    ),
)[
    The particles that make up air are in motion at microscopic scale. The collisions between particles are modeled with a drag force $va(f)=- m/tau va(v)$ that apply on an average particle. Make an inventory of the forces and deduce the limit speed $va(v)$ of an average particle. Deduce the current density vector $va(j_"mig")$ due to the gravitation.
][
    The forces that apply on an average particle are
    - the weight $va(P)=m va(g)$
    - the drag force $va(f)=- m/tau va(v)$
    In stationary regime, these forces balance each other:
    $ m va(g) - m/tau va(v) = 0 $
    Thus, the limit speed is
    $ va(v) = tau va(g) $

    The current density vector due to the gravitation is
    $ va(j_"mig") = n va(v) = n tau va(g) = -(P_0 tau g) /(k_B T) exp (-(m g z)/(k_B T) ) va(e_z) $
]

#question(
    coups-de-pouce: (
        "Faire un bilan de particules sur une tranche infinitésimale d'atmosphère. Quatre flux de particules y rentrent : dû à la gravitation et dû à la diffusion, en $z$ et en $z+dd(z)$.",
    ),
)[
    By making an inventory of the particles on a slice of atmosphere in a stationary state, express a relation between $D$, $tau$, $k_B$, $T$ and $m$. This relation is known as Einstein relation.
][
    We study a slice of atmosphere between $z$ and $z + dd(z)$ and of area $S$. In stationary state, the number of particles that enter this slice is equal to the number of particles that exit it :
    $
        0 = delta^2 Q = integral.double_S_z va(j_"diff") (z) dot va(dd(S_z)) dd(t) + integral.double_S_(z+dd(z)) va(j_"diff") (z+dd(z)) dot va(dd(S_(z+dd(z)))) dd(t) \ + integral.double_S_z va(j_"mig") (z) dot va(dd(S_z)) dd(t) + integral.double_S_(z+dd(z)) va(j_"mig") (z+dd(z)) dot va(dd(S_(z+dd(z)))) dd(t)\
        = S j_"diff" (z ) dd(t) - S j_"diff" (z + dd(z)) dd(t) + S j_"mig" (z ) dd(t) - S j_"mig" (z + dd(z)) dd(t)\
        = - S dd(t) (pdv(j_"diff", z) + pdv(j_"mig", z)) dd(z)
    $
    $ pdv(j_"diff", z) + pdv(j_"mig", z) = 0 $
    $
        D (P_0 m g)/(k_B T)^2 (-m g)/(k_B T) exp (-(m g z)/(k_B T) ) - (P_0 tau g)/(k_B T) (-m g)/(k_B T) exp (-(m g z)/(k_B T) ) = 0
    $
    $
        (D m) / (k_B T) -tau = 0
    $
    $ tau = (D m)/(k_B T) $
]
