#import "@local/prepa:0.1.0": *

#show: exercice.with(
    titre: "Pertes fer",
    ouvert: true,
    difficulté: 3
)

La plaque signalétique d'un moteur à courant continu indique les caractéristiques suivantes :

#figure(
    image("../images/plaque MCC.jpg"),
)

#question(
    coups-de-pouce: (
        "Que vaut la constante de couplage du moteur ?",
        "Que vaut la résistance de l'induit ?",
        "Quelles sont les pertes cuivre dans les conditions nominales ?",
        "Faire un bilan de puissance sur l'induit."
    ),
)[
    Montrer que les pertes fer sont négligeables devant les pertes cuivre dans les conditions nominales.
][
    La constante de couplage s'écrit $Phi_0 = Gamma/I$ avec $Gamma = P_"mécanique" / Omega$
    $ Phi_0 = P_"mécanique"/(I Omega) $

    La loi des mailles donne $U = E + R I = Phi_0 Omega + R I$ d'où
    $ R = (U - Phi_0 Omega)/I = (U - P_"mécanique"/Gamma)/I $

    #let Pméca = 36.3e3
    #let O = 1150/60*2*calc.pi
    #let I = 95.5
    #let Ue = 360
    #let Ie = 3
    #let G = Pméca/O
    #let U = 440
    #let Phi0 = Pméca/(I*O)
    #let R = (U - Phi0*O)/I
    #let Pcu = R*calc.pow(I,2) + Ue*Ie
    Les pertes cuivre sont donc, pour les circuits rotoriques et statorique, $P_ce("Cu") = (U - P_"mécanique"/Gamma) I  + U_e I_e = #qty(scientifique(Pcu,2),"W")$

    Un bilan de puissance sur l'induit donne $U I = P_"mécanique" + P_ce("Cu") + P_ce("Fe")$, soit
    $ P_ce("Fe") = U I - P_"mécanique" - P_ce("Cu") = #qty(scientifique(U*I - Pméca - R*calc.pow(I,2),2),"W") approx 0 $

]
