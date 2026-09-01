#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Size of marine mammals",
)

Marine mammals are warm-blooded animas whose temperature remain constant. To maintain this temperature, exothermal reactions happen in their cells and produce a volumetric power $a$. The total power produced by the mammal is $P$.

To simplify, mammals are described as spheres of radius $R$, immersed in immobile water of thermal conductivity $lambda$ and which temperature is $T_infinity$ far away from the animal.

The problem is supposed to be invariant through a rotation about $theta$ and $phi$.

#question(
    coups-de-pouce: (
        "Faire un bilan d'énergie sur un volume infinitésimal ou une boule creuse.",
    ),
)[
    Establish the thermal diffusion equation in water (in spherical coordinates).
][
    By applying the first principle of thermodynamics on a spherical shell of radius $r$ and thickness $dd(r)$ :
    $
        dd(U, 2) + dd(E_c, 2) = delta^2 Q + delta^2 W
    $
    with $dd(E_c, 2) = 0$ and $delta^2 W = 0$.
    $
              mu dd(V)(u(t+dd(t)) - u(t)) & = j_Q (r) 4 pi r^2 dd(t) - j_Q (r+dd(r)) 4 pi (r+dd(r))^2 dd(t) \
        mu 4 pi r^2 dd(r) pdv(u, t) dd(t) & = - pdv(j_Q r^2, r) 4 pi dd(r) dd(t)
    $
    We then use Fourier's law $j_Q = - lambda pdv(T, r)$ and the caloric equation $dd(u) = c dd(T)$ to obtain :
    $
        mu c pdv(T, t) = lambda 1/r^2 pdv(pdv(T,r) r^2, r)\
        pdv(T,t) - D_"th" 1/r^2 pdv(pdv(T,r) r^2, r) = 0 
    $
    with $D_"th" = lambda/(mu c)$ the thermal diffusivity of water.
]

#question(
    coups-de-pouce: (
        "Résoudre l'équation précédente en régime stationnaire.",
    ),
)[
    Ascertain the temperature $T(r)$ around the animal in stationary state.
][
    In stationary state, the equation becomes :
    $
        1/r^2 pdv(pdv(T,r) r^2, r) &= 0\
        pdv(pdv(T,r) r^2, r) &= 0
    $
    Integrating gives :
    $
        pdv(T,r) r^2 = A\
        pdv(T,r) = A/r^2\
        T(r) = -A/r + B
    $
    with $A$ and $B$ constants to be determined using the boundary conditions :
    - $T(r -> infinity) = T_infinity$ implies $B = T_infinity$,
    - $T(r=R) = T_0$ implies $A = (T_0 - T_infinity) R$.

    Finally, the temperature profile is :
    $
        T(r) = (T_0 - T_infinity) R/r + T_infinity
    $
]

#question(
    coups-de-pouce: (
        "La puissance perdue par l'animal est le flux thermique sortant de l'animal en $r=R$.",
    ),
)[
    Determine the thermal power lost by the mammal by integrating $va(j_Q)$.
][
    The thermal flux at the surface of the animal is given by Fourier's law :
    $
        j_Q (R) = - lambda pdv(T,r) (r=R) = - lambda (T_0 - T_infinity) R / R^2 = - lambda (T_0 - T_infinity) / R
    $
    The total power lost by the animal is then :
    $
        P = - j_Q (R) 4 pi R^2 = 4 pi lambda R (T_0 - T_infinity)
    $
]

#question(
    coups-de-pouce: (
        "Déterminer la puissance volumique produite par l'animal et montrer qu'elle est d'autant plus grande que l'animal est petit.",
    ),
)[
    Explain why there is no small aquatic mammal.
][
    The volumetric power produced by the animal is given by :
    $
        a = P / (4/3 pi R^3) = 3 lambda (T_0 - T_infinity) / R^2
    $
    This power increases when the radius of the animal decreases. Small animals thus need to produce more power to maintain their temperature, which is not sustainable for them. This explains why there are no small aquatic mammals.
]
