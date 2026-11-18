#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Rendement d'une génératrice à courant continu",
)

Une génératrice à courant continu de constante de couplage $Phi_0=#quan[0.12 Wb]$, de résistance interne $r=#quan[0.45 Ω]$, d'inductance propre $L=#quan[20 mH]$ et dont les valeurs nominales de tension et courant sont $U_n=#quan[40 V]$ et $I_n=#quan[6 A]$, est utilisée pour alimenter une charge électrique symbolisée par une résistance $R_c=#quan[3 Ω]$.

La machine est entrainée par une turbine qui exerce sur son rotor un couple de moment $Gamma_t=#quan[0.5 N m]$. En régime permanent, le rotor tourne à la vitesse angulaire constante $Omega > 0$. On néglige les pertes mécaniques et les pertes fer.

#question(
    coups-de-pouce: (
        "En convention générateur, le courant $i$ est l'opposé du courant $I_r$ de la convention récepteur, dans laquelle $Gamma_\"ém\" = Phi_0 I_r$.",
    ),
)[
    Représenter le schéma électrique de l'induit alimentant la charge électrique (on placera la machine à courant continu en convention générateur). Préciser l'expression du couple électromagnétique qui s'exerce sur le rotor en fonction de $Phi_0$ et $i$. En déduire une relation entre $Gamma_t$, $Phi_0$ et $i$.
][
    #figure(
        circuit({
            import zap: *
            import cetz.draw: *
            vsource("e", (0, 0), (0, 2), u: $e$)
            resistor("r", (0, 2), (0, 4), label: $r$)
            inductor("L", (0, 4), (0, 6), label: $L$, variant: "ieee")
            fil((0, 6), (3, 6), i: $i$)
            resistor("Rc", (3, 6), (3, 0), label: $R_c$, u: (content: $u$, anchor: "south-west"))
            wire((3, 0), (0, 0))
        }),
    )
    En convention récepteur, le couple électromagnétique s'écrit $Gamma_"ém" = Phi_0 I_r$. En convention générateur, le courant est orienté dans l'autre sens, $i = -I_r$, donc $Gamma_"ém" = -Phi_0 i$ : il s'oppose à la rotation quand la machine débite ($i > 0$). La force électromotrice, orientée dans le sens de $i$, vaut $e = Phi_0 Omega > 0$.

    La vitesse angulaire étant constante, la somme des couples s'exerçant sur le rotor est nulle : $Gamma_"t" + Gamma_"ém" = 0$, donc $Gamma_"t" = Phi_0 i$.
]

#question(
    coups-de-pouce: (
        "Écrire une équation électrique et une équation mécanique et utiliser les relations entre grandeurs mécaniques et électriques pour une machine à courant continu.",
        "Pour l'équation électrique, écrire la loi des mailles dans le circuit électrique équivalent de l'induit.",
        "Pour l'équation mécanique, écrire le théorème du moment cinétique au rotor.",
    ),
)[
    Calculer les valeurs de l'intensité du courant dans la charge et la vitesse de rotation de la machine.
][
    #let Gamma-t = 0.5
    #let phi-0 = 0.12
    #let i = Gamma-t / phi-0
    $ i = Gamma_"t" / Phi_0 = #qty(i, "A", chiffres: 2) $

    L'équation électrique issue de la loi des mailles dans le circuit de l'induit s'écrit $u = e - r i - L dv(i,t)$ soit $R_c i = e - r i$.

    #let Rc = 3
    #let r = 0.45
    #let O = ((Rc + r) * Gamma-t) / calc.pow(phi-0,2)
    Or $e = Phi_0 Omega$ d'où
    $ (R_c+r) i = (R_c + r)Gamma_"t"/Phi_0 = Phi_0 Omega $
    Finalement,
    $ Omega = ((R_c + r)Gamma_"t")/(Phi_0^2) = #qty(O, "rad/s", chiffres: 2) $
]

#question(
    coups-de-pouce: (
        "Le rendement est le rapport de la puissance utile, électrique, à la puissance couteuse, mécanique.",
        "Calculer la tension aux bornes de la génératrice. Est-elle égale à la tension nominale ?",
    ),
)[
    Définir puis calculer le rendement de conversion de la machine. La machine fonctionne-t-elle dans les conditions nominales ?
][
    #let Rc = 3
    #let r = 0.45
    #let Gamma-t = 0.5
    #let phi-0 = 0.12
    #let i = Gamma-t / phi-0
    #let O = ((Rc + r) * Gamma-t) / calc.pow(phi-0, 2)
    #let u = Rc * i
    #let Pu = u * i
    #let Pa = Gamma-t * O
    #let rendement = Rc / (r + Rc)
    Le rendement de conversion est le rapport de la puissance utile, électrique, fournie à la charge, à la puissance couteuse, mécanique, fournie par la turbine :
    $ eta = (u i) / (Gamma_"t" Omega) $

    *Méthode 1 : par les relations de la machine.* Avec $Gamma_"t" = Phi_0 i$ et $e = Phi_0 Omega$, la puissance mécanique reçue vaut $Gamma_"t" Omega = Phi_0 i Omega = e i$ : elle est intégralement convertie en puissance électrique, puisqu'il n'y a ni pertes mécaniques ni pertes fer. Donc
    $ eta = (u i)/(e i) = u / e = R_c/(r+R_c) = #num(rendement, chiffres: 2) $
    la dernière égalité venant de la loi des mailles $e = (R_c + r) i$ et de $u = R_c i$.

    *Méthode 2 : par un bilan de puissance.* Les seules pertes sont les pertes Joule dans l'induit, $r i^2$. La puissance couteuse est donc la somme de la puissance utile et des pertes :
    $ eta = (R_c i^2)/(R_c i^2 + r i^2) = R_c/(R_c + r) $

    *Méthode 3 : numériquement.* La puissance utile vaut $P_u = R_c i^2 = #qty(Pu, "W", chiffres: 2)$ et la puissance mécanique reçue $P_a = Gamma_"t" Omega = #qty(Pa, "W", chiffres: 2)$, d'où $eta = P_u / P_a = #num(Pu / Pa, chiffres: 2)$.

    Ces méthodes se contrôlent l'une l'autre : la différence $P_a - P_u = #qty(Pa - Pu, "W", chiffres: 2)$ doit être égale aux pertes Joule $r i^2 = #qty(r * calc.pow(i, 2), "W", chiffres: 2)$.

    La tension $u$ s'écrit
    $ u = R_c i = #qty(u, "V", chiffres: 2) < #quan[40 V] = U_n $
    et le courant $i = #qty(i, "A", chiffres: 2)$ est lui aussi inférieur à $I_n = #quan[6 A]$. La machine ne fonctionne pas dans les conditions nominales.
]
