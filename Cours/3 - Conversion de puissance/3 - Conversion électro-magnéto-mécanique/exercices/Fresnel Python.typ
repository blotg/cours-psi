#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Calculs numériques sur un diagramme de Fresnel",
    numérique: true,
)

En Python, le nombre complexe $i$ s'écrit `1j`. L'exponentielle complexe est la fonction `exp` du module `cmath`. Le module est réalisé par la fonction `abs`.

À l'aide de Python, déterminer la tension efficace aux bornes d'un moteur synchrone diphasé dipolaire dans chacun des cas suivants. On sommera les amplitudes complexes résultant de la loi des mailles.

#question(
    coups-de-pouce: (
        "Quelles amplitudes complexes sont en fait réelles si on prend $i$ commet origine des phases ?",
        "Écrire la loi des mailles en utilisant les amplitudes complexes.",
    ),
)[
    La force contre-électromotrice induite efficace est #qty("250", "V"), la résistance de l'induit est négligeable, l'inductance de l'induit est #qty("0.10", "H"), la fréquence de rotation est #qty("3000", "tr/min") et le courant est #qty("10", "A"). L'angle de pilotage est nul. Le calcul effectué par Python pourra être vérifié à la main de ce premier cas simple.
][
    ```python
    from math import pi
    E = 250 # V
    I = 10  # A
    L = 0.1  # H
    f = 3000 / 60  # Hz
    w = 2 * pi * f  # rad/s
    U = E + 1j * w * L * I
    print(abs(U))
    ```
    #let U = calc.sqrt(calc.pow(250,2) + calc.pow(2 * calc.pi * (3000/60) * 0.1 * 10,2))
    A la main, le théorème de Pythagore donne :
    $ U = sqrt(E^2 + (L omega I)^2) = #qty(scientifique(U,2),"V")$
]

#question(
    coups-de-pouce: (),
)[
    La force contre-électromotrice induite efficace est #qty("250", "V"), la résistance de l'induit est négligeable, l'inductance de l'induit est #qty("0.1", "H"), la fréquence de rotation est #qty("3000", "tr/min") et le courant est #qty("10", "A"). L'angle de pilotage vaut #qty("30", "deg").
][
    ```python
    from math import pi
    from cmath import exp
    psi = 30 * pi / 180  # rad
    E = 250 * exp(1j*psi) # V
    I = 10  # A
    L = 0.1  # H
    f = 3000 / 60  # Hz
    w = 2 * pi * f  # rad/s
    U = E + 1j * w * L * I
    print(abs(U))
    ```
]

#question(
    coups-de-pouce: (),
)[
    La force contre-électromotrice induite efficace est #qty("250", "V"), la résistance de l'induit est #qty("0.1", "O"), l'inductance de l'induit est #qty("0.1", "H"), la fréquence de rotation est #qty("3000", "tr/min") et le courant est #qty("10", "A"). L'angle de pilotage vaut #qty("30", "deg").
][
    ```python
    from math import pi
    from cmath import exp
    psi = 30 * pi / 180  # rad
    E = 250 * exp(1j*psi) # V
    I = 10  # A
    R = 0.1  # Ohm
    L = 0.1  # H
    f = 3000 / 60  # Hz
    w = 2 * pi * f  # rad/s
    U = E + R * I + 1j * w * L * I
    print(abs(U))
    ```
]
