#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Méthode des trois ampèremètres",
    difficulté: 0,
)

On considère le montage ci-dessous qui utilise une résistance étalon $R$ connue pour déterminer expérimentalement le facteur de puissance d'une impédance $Z$.

Les grandeurs $i(t)$, $i_1(t)$ et $i_2(t)$ sont sinusoïdales de valeurs efficaces respectives $I$, $I_1$ et $I_2$.

#figure(
    zap.circuit({
        import zap: *

        ammeter("A", (0, 0), (2, 0), i: $i(t)$)
        ammeter("A1", "A.out", (rel: (0, -2)), i: (content: $i_1(t)$, anchor: "east", label-distance: 15pt))
        resistor("Z", "A1.out", (rel: (0, -2)), label: $underline(Z)$)
        ammeter("A2", (4, 0), (rel: (0, -2)), i: (content: $i_2(t)$, anchor: "east", label-distance: 15pt))
        resistor("R", "A2.out", (rel: (0, -2)), label: $R$)
        wire("R.out", (0, -4))
        wire("A.out", "A2.in")
        // draw.line((0, -3.9), (0, -0.1), mark:(end:">>", fill: black))
    }),
)

#question(
    coups-de-pouce: (
        "Écrire la loi des nœuds et en déduire une relation entre $I$, $I_1$ et $I_2$.",
        "Écrire les expressions temporelles de $i_1(t)$ et $i_2(t)$. Quelle est la définition de la valeur efficace ?",
    ),
)[
    Exprimer le facteur de puissance $cos phi_1$ du dipole $underline(Z)$ en fonction de $I_1$, $I_2$ et $I$.
][
    $ i(t) = i_1(t) + i_2(t) $
    $
        integral_0^T i^2(t) dd(t) &= integral_0^T i_1^2(t) dd(t) + integral_0^T i_2^2(t) dd(t) + 2integral_0^T i_1(t) i_2(t) dd(t)
    $
    Les courants $i$, $i_1$ et $i_2$ sont sinusoïdaux : $i(t)=sqrt(2)I cos(omega t + phi)$, $i_1(t)=sqrt(2)I_1 cos(omega t + phi_1)$ et $i_2(t)=sqrt(2)I_2 cos(omega t)$ (pas de phase pour $i_2$ la $R in RR$).

    $
        I^2 & = I_(1)^2 + I_(2)^2 + 4I_(1)I_(2) integral (cos(2 omega t + phi_1) + cos(phi_1))/2 dd(t) \
            & = I_(1)^2 + I_(2)^2 + 2I_1 I_2cos(phi_1)
    $
    On a finalement :
    $ cos(phi_1) = (I^2 - I_(1)^2 - I_(2)^2)/(2I_1 I_2) $
]

#let I = 40
#let I2 = 12
#let I1 = 30

Un abonné d'EDF dispose d'un radiateur électrique qui est parcouru par #qty(I2, "A") efficace quand il est branché seul et d'un moteur qui est parcouru par #qty(I, "A") efficace dans les mêmes conditions. Lorsqu'il branche les deux, le courant efficace total est #qty(I, "A").

#question(
    coups-de-pouce: (),
)[
    Calculer le facteur de puissance du moteur.
][
    $ cos(phi_1) = (I^2 - I_(1)^2 - I_(2)^2)/(2I_1 I_2) = (#I^2 - #I1^2 - #I2^2)/(2 times #I1 times #I2) = #num(scientifique((I*I - I1*I1 - I2*I2)/(2*I1*I2), 2)) $
]
