#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Rendement d'une génératrice à courant continu",
)

Une génératrice à courant continu de constante de couplage $phi_0=qty("0.12", "Wb")$, de résistance interne $r=qty("0.45", "O")$, d'inductance propre $L=qty("20", "mH")$ et dont les valeurs nominales de tension et courant sont $U_n=qty("40", "V")$ et $I_n=qty("6", "A")$, est utilisée pour alimenter une charge électrique symbolisée par une résistance $R_c=qty("3", "O")$.

On néglige les pertes mécaniques.

La machine est entrainée par une turbine qui exerce sur son rotor un couple de moment $Gamma_t=qty("0.5", "N m")$. La MCC tourne à la vitesse de rotation $Omega > 0$.

#question(
    coups-de-pouce: (
        "Le couple dont on demande l'expression est le couple qui s'exerce *sur* la machine.",
    ),
)[
    Représenter le schéma électrique de l'induit alimentant la charge électrique (on placera la machine à courant continu en convention générateur). Préciser l'expression du couple électromagnétique qui s'exerce sur la machine en fonction de $Phi_0$ et $i$.
][
    #figure(
        zap.circuit({
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
    La vitesse angulaire étant constante, la somme des couples s'exerçant sur le rotor est nulle donc $Gamma_"t" = Phi_0 i$.
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
    $ i = Gamma_"t" / Phi_0 = #qty(scientifique(i, 2), "A") $

    L'équation électrique issue de la loi des mailles dans le circuit de l'induit s'écrit $u = e - r i - L dv(i,t)$ soit $R_c i = e - r i$.

    #let Rc = 3
    #let r = 0.45
    #let O = ((Rc + r) * Gamma-t) / calc.pow(phi-0,2)
    Or $e = Phi_0 Omega$ d'où
    $ (R_c+r) i = (R_c + r)Gamma_"t"/Phi_0 = Phi_0 Omega $
    Finalement,
    $ Omega = ((R_c + r)Gamma_"t")/(Phi_0^2) = #qty(scientifique(O,2),"rad/s") $
]

#question(
    coups-de-pouce: (
        "Calculer la tension aux bornes du moteur. Est-elle égale à la tension nominale ?",
    ),
)[
    Définir puis calculer le rendement de conversion de la machine? La machine fonctionne-t-elle dans les conditions nominales ?
][
    #let Rc = 3
    #let r = 0.45
    #let rendement = Rc / (r + Rc)
    Le rendement s'écrit
    $ eta = (u i) / (Gamma_"t" Omega) = (u i)/(Phi_0 i e/Phi_0) = u /e = R_c/(r+R_c) = #num(scientifique(rendement,2)) $

    #let Gamma-t = 0.5
    #let phi-0 = 0.12
    #let i = Gamma-t / phi-0
    #let u = Rc * i
    La tension $u$ s'écrit
    $ u = R_c i = #qty(scientifique(u,2), "V") < #qty("40","V") = U_n $
    La machine ne fonctionne pas dans les conditions nominales.
]
