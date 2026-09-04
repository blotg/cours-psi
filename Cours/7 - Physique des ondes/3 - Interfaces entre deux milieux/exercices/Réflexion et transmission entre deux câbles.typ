#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Réflexion et transmission entre deux câbles",
)

Deux câbles coaxiaux différents, d'impédances caractéristiques $Z_1$ et $Z_2$ sont mis bout à bout en $x=0$. Une onde harmonique est émise dans le câble occupant les abscisses $x<0$, qui se propage dans le sens des $x$ croissants.

#question(
    coups-de-pouce: (
        "Quelle est l'expression générale d'une onde progressive harmonique ?"
    ),
)[
    Proposer une expression mathématique pour les tensions des ondes incidentes, réfléchies et transmises. On ne supposera *pas* a priori les pulsations identiques.
][
    Les ondes sont progressives et harmoniques, elles ont pour expression
    $
        cases(
            underline(u_i)(x,t) = underline(u_(i,0)) e^(j omega_i t - j k_i x),
            underline(u_r)(x,t) = underline(u_(r,0)) e^(j omega_r t + j k_r x),
            underline(u_t)(x,t) = underline(u_(t,0)) e^(j omega_t t - j k_t x)
        )
    $
]

#question(
    coups-de-pouce: (
        "Quelle est la relation entre la tension et le courant dans un câble coaxial ?",
        "Attention au sens de propagation des ondes !",
    ),
)[
    Déterminer les expressions des courants associés en faisant apparaitre les impédances caractéristiques des câbles.
][
    En utilisant la relation entre la tension et le courant dans un câble coaxial, on trouve
    $
        cases(
            underline(i_i)(x,t) = underline(u_(i,0)) / Z_1 e^(j omega_i t - j k_i x),
            underline(i_r)(x,t) = -underline(u_(r,0)) / Z_1 e^(j omega_r t + j k_r x),
            underline(i_t)(x,t) = underline(u_(t,0)) / Z_2 e^(j omega_t t - j k_t x)
        )
    $
]

#question(
    coups-de-pouce: (
        "La tension et le courant sont continus à l'interface entre les deux câbles."
    ),
)[
    Quelles sont les 2 conditions aux limites en $x=0$ ? En déduire deux relations entre $underline(u_(i,0))$, $underline(u_(r,0))$ et $underline(u_(t,0))$.
][
    Les conditions aux limites sont la continuité de la tension et du courant en $x=0$, soit
    $
        cases(
            underline(u_(i,0)) + underline(u_(r,0)) = underline(u_(t,0)),
            underline(u_(i,0)) / Z_1 - underline(u_(r,0)) / Z_1 = underline(u_(t,0)) / Z_2
        )
    $
]

#question()[
    Définir et établir les coefficients de réflexion et de transmission en amplitude pour la tension, à la jonction entre les deux câbles. Conclure quant à la nécessité d'assurer une adaptation d'impédance lors de la mise en série de deux câbles coaxiaux.
][
    En combinant les deux relations précédentes, on trouve
    $
        cases(
            2 underline(u_(i,0)) + 0 = (1 + Z_1 / Z_2) underline(u_(t,0)),
            (1 - Z_2/Z_1) underline(u_(i,0)) + (1 + Z_2/Z_1) underline(u_(r,0)) = 0
        )
    $
    On en déduit les coefficients de réflexion et de transmission en amplitude sur la tension
    $
        cases(
            r =: underline(u_(r,0)) / underline(u_(i,0)) = (Z_2/Z_1-1)/(1+Z_2/Z_1) = (Z_2 - Z_1) / (Z_2 + Z_1),
            t =: underline(u_(t,0)) / underline(u_(i,0)) = (2 Z_2) / (Z_2 + Z_1)
        )
    $

    Si l'impédance n'est pas adaptée, $r != 0$ et il existera une onde réfléchie, ce qui n'est pas souhaitable dans le cadre de la transmission d'un signal.
]
