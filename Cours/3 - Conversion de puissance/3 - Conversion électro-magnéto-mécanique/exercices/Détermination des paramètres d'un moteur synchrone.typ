#import "@local/prepa:0.1.1": *

#show: exercice.with(titre: "Détermination des paramètres d'un moteur synchrone")

On étudie un moteur synchrone diphasé, monopolaire, dont on cherche à déterminer les principaux paramètres.

Le circuit rotorique est parcouru par le courant d'excitation continu d'intensité $I_e$ maintenu constant pendant tous les essais.

Le circuit diphasé statorique est parcouru par deux courants sinusoïdaux de pulsation $omega$, déphasé de $pi/2$, de valeurs efficaces identiques égales à $I$.

#question(
    coups-de-pouce: (
        "À quelle condition le couple moyen exercé par le moteur est-il non nul ?",
    ),
)[
    En régime permanent de rotation, quelle est la relation entre la vitesse de rotation du rotor $Omega$ et $omega$ ?
][
    Le couple moteur est non nul seulement si la condition de synchronisme $Omega = omega$ est vérifiée.
]

On désigne par $L$ l'inductance d'une phase et on néglige la résistance des enroulements. En régime permanent de rotation, on note $underline(U)$ la représentation complexe de la tension d'alimentation de la phase, $underline(I)$ celle de l'intensité du courant et $underline(E)$ celle de la force contre-électromotrice.

#question(
    coups-de-pouce: (
        "La résistance est négligée.",
    ),
)[
    Rappeler le schéma électrique d'une phase en fonctionnement moteur et en fonctionnement générateur.
][
    #figure(
        zap.circuit({
            import zap: *
            import cetz.draw: *
            inductor("L", (0, 0), (3, 0), variant: "ieee", label: $L$, i: $underline(I)$)
            vsource("E", (3, -3), (3, 0), u: $underline(E)$)
            wire((0, -3), (3, -3))
            line((0, -2.8), (0, -0.2), mark: (end: ">>", fill: black), name: "U")
            content("U.mid", $underline(U)$, anchor: "east", padding: 10pt)
        }),
    )
]


#question(
    coups-de-pouce: (),
)[
    La valeur efficace de la force contre-électromotrice s'écrit sous la forme $E= Phi Omega$. Que représente la grandeur $Phi$ ? De quels paramètres dépend-elle ?
][
    La grandeur $Phi$ représente le flux magnétique créé par le rotor dans une phase du stator. Elle dépend de l'intensité du courant d'excitation $I_e$ et de la géométrie de la machine.
]

#question(
    coups-de-pouce: (
        "D'après la loi de Lenz-Faraday, quelle relation lie $underline(Phi)$ à $underline(E)$ ?",
        "Relier la tension aux bornes de l'induit à la force contre-électromotrice pour cet essai.",
    ),
)[
    Afin de mesurer $Phi$, on réalise un essai en circuit ouvert, le rotor de la machine synchrone étant entrainé par un moteur auxiliaire à la vitesse de #qty("6.0e3", "tr/min"), on mesure la tension efficace aux bornes d'une phase égale à #qty("1.2e2", "V"). Calculer la valeur de $Phi$.
][
    #let E = 1.2e2
    #let O = 6.0e3 * 2 * calc.pi / 60
    #let flux = E / O
    En circuit ouvert, l'intensité dans la phase est nulle ($underline(I)=0$), donc la tension aux bornes de la phase est égale à la force contre-électromotrice ($underline(U)=underline(E)$). On en déduit que $Phi = E / Omega = #qty(scientifique(flux,2), "Wb")$.
]

#question(
    coups-de-pouce: (
        "Grâce à une loi des mailles, relier $underline(E)$ à $L$, $omega$ et $underline(I)$ pour cet essai.",
    ),
)[
    Pour mesurer la valeur de l'inductance d'une phase, on réalise un essai en court-circuit, le rotor étant toujours entrainé par le moteur auxiliaire à #qty("6.0e3", "tr/min"). Le dipôle de sortie d'une phase étant court-circuité, la mesure de l'intensité efficace du courant de court-circuit dans une phase donne la valeur $I_(c c)=qty("1.2e2", "A")$. Calculer l'inductance $L$ d'une phase.
][
    #let E = 1.2e2
    #let Icc = 1.2e2
    #let O = 6.0e3 * 2 * calc.pi / 60
    #let L = E/(Icc*O)
    La loi des mailles appliquée au circuit de la phase en court-circuit donne $underline(U)=0 = underline(E) + j omega L underline(I)$. On en déduit que $underline(E) = - j omega L underline(I)$. La valeur efficace de la force contre-électromotrice s'écrit donc $E = omega L I$.
    $E$ ne dépend que de la vitesse de rotation du rotor et du flux magnétique $Phi$ créé par le rotor, on a donc toujours $E = #qty("1.2e2","V")$.
    On en déduit que $L = E / (omega I_(c c)) = #qty(scientifique(L,2), "H")$.
]
