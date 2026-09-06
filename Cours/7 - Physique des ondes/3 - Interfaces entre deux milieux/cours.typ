#import "@local/prepa:0.1.1": *

#show: cours.with(infos: yaml("infos.yml"))

#let grandeurs = (
    "P_(i,0)": (signification: "l'amplitude de la surpression de l'OPPH incidente", unité: unit("Pa")),
    "P_(r,0)": (signification: "l'amplitude de la surpression de l'OPPH réfléchie", unité: unit("Pa")),
    "P_(t,0)": (signification: "l'amplitude de la surpression de l'OPPH transmise", unité: unit("Pa")),
    "v_(i,0)": (signification: "l'amplitude de la survitesse de l'OPPH incidente", unité: unit("m/s")),
    "v_(r,0)": (signification: "l'amplitude de la survitesse de l'OPPH réfléchie", unité: unit("m/s")),
    "v_(t,0)": (signification: "l'amplitude de la survitesse de l'OPPH transmise", unité: unit("m/s")),
    "Z_1": (signification: "l'impédance acoustique du milieu de l'onde incidente", unité: unit("Pa s/m")),
    "Z_2": (signification: "l'impédance acoustique du milieu de l'onde transmise", unité: unit("Pa s/m")),
    "I_i": (signification: "l'intensité acoustique de l'OPPH incidente", unité: unit("W/m^2")),
    "I_r": (signification: "l'intensité acoustique de l'OPPH réfléchie", unité: unit("W/m^2")),
    "I_t": (signification: "l'intensité acoustique de l'OPPH transmise", unité: unit("W/m^2")),
    "I": (signification: "le courant électrique", unité: unit("A")),
    "va(j_S)": (signification: "le vecteur densité surfacique de courant", unité: unit("A/m")),
    "va(E_1)": (signification: "le champ électrique dans le milieu 1", unité: unit("V/m")),
    "va(E_2)": (signification: "le champ électrique dans le milieu 2", unité: unit("V/m")),
    "sigma": (signification: "la densité surfacique de charge de l'interface", unité: unit("C/m^2")),
    "epsilon_0": (signification: "la permittivité diélectrique du vide", unité: unit("F/m")),
    "va(n)_(1->2)": (signification: "un vecteur unitaire allant du milieu 1 vers le milieu 2", unité:("sans unité")),
    "va(B_1)": (signification: "le champ magnétique dans le milieu 1", unité: unit("T")),
    "va(B_2)": (signification: "le champ magnétique dans le milieu 2", unité: unit("T")),
    "mu_0": (signification: "la perméabilité magnétique du vide", unité: unit("H/m")),
    "va(E_r)": (signification: "le champ électrique de l'onde réfléchie", unité: unit("V/m")),
    "E_0": (signification: "l'amplitude de l'onde incidente", unité: unit("V/m")),
    "omega": (signification: "la pulsation de l'onde incidente", unité: unit("rad/s")),
    "k": (signification: "le nombre d'onde de l'onde incidente", unité: unit("rad/m")),
    "c": (signification: "la célérité de la lumière dans le vide", unité: unit("m/s")),
    "R": (signification: "le coefficient de réflexion en puissance", unité: "sans unité"),
    "T": (signification: "le coefficient de transmission en puissance", unité: "sans unité"),
    "va(Pi_i)": (signification: "le vecteur de Poynting de l'OPPH incidente", unité: unit("W/m^2")),
    "va(Pi_r)": (signification: "le vecteur de Poynting de l'OPPH réfléchie", unité: unit("W/m^2")),
    "va(delta F)": (signification: "la force de Laplace exercée sur la surface $dd(S)$", unité: unit("N")),
    "va(B)": (signification: "le champ magnétique", unité: unit("T")),
    "dd(S)": (signification: "la surface infinitésimale", unité: unit("m^2")),
    "P": (signification: "la pression de radiation", unité: unit("Pa")),
)

= Cas des ondes sonores
Lorsque deux fluides non miscibles sont en contact, des ondes sonores peuvent passer d'un à l'autre.
== Conditions aux limites
Les deux fluides restant en contact, la composante normale de la vitesse est continue à l'interface.

#encadré(
    titre: "Continuité de la surpression",
    connaitre: true,
    savoir-faire: true,
)[
    La surpression est continue à l'interface
]

== Réflexion et transmission sur une interface plane
Lorsqu'une onde sonore arrive perpendiculairement à une interface plane, les coefficients de réflexion et de transmission peuvent s'exprimer simplement grâce aux impédances acoustiques des deux milieux.

#encadré(
    titre: "Coefficients de réflexion et de transmission sur les amplitudes des surpressions et des survitesses",
    connaitre: false,
    savoir-faire: true,
    hypothèses: (
        [Une OPPH $underline(P_i)=P_(i,0)e^(j(omega t-k_1 x))$ arrive en incidence normale.],
        [L'OPPH réfléchie s'écrit $underline(P_r)=underline(P_(r,0))e^(j(omega t+k_1 x))$.],
        [L'OPPH transmise s'écrit $underline(P_t)=underline(P_(t,0))e^(j(omega t-k_2 x))$.],
        [La surface séparant les milieux est plane.],
        [Les fluides ne sont pas miscibles.],
    ),
    grandeurs: sub-dictionary(grandeurs, (
        "P_(i,0)",
        "P_(r,0)",
        "P_(t,0)",
        "v_(i,0)",
        "v_(r,0)",
        "v_(t,0)",
        "Z_1",
        "Z_2",
    )),
)[
    $
        r_v & =: (v_(r,0))/(v_(i,0)) = (Z_1-Z_2)/(Z_1+Z_2) \
        r_P & =: (P_(r,0))/(P_(i,0)) = (Z_2-Z_1)/(Z_1+Z_2) \
        t_v & =: (v_(t,0))/(v_(i,0)) = (2Z_1)/(Z_1+Z_2) \
        t_P & =: (P_(t,0))/(P_(i,0)) = (2Z_2)/(Z_1+Z_2)
    $
]

#encadré(
    titre: "Coefficients de réflexion et de transmission sur les puissances",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [Une OPPH $underline(P_i)=P_(i,0)e^(j(omega t-k_1 x))$ arrive en incidence normale.],
        [L'OPPH réfléchie s'écrit $underline(P_r)=underline(P_(r,0))e^(j(omega t+k_1 x))$.],
        [L'OPPH transmise s'écrit $underline(P_t)=underline(P_(t,0))e^(j(omega t-k_2 x))$.],
        [La surface séparant les milieux est plane.],
        [Les fluides ne sont pas miscibles.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("I_i", "I_r", "I_t", "Z_1", "Z_2")),
)[
    $
        R & =: (I_r)/(I_i) = ((Z_1-Z_2)/(Z_1+Z_2))^2 \
        T & =: (I_t)/(I_i) = (4Z_1Z_2)/((Z_1+Z_2)^2)
    $
]

Lorsque $Z_1=Z_2$, la puissance transmise est maximale, on dit qu'il y a *adaptation d'impédance*.

#application[
    Calculer le coefficient de transmission en puissance pour l'interface air-eau.
    $Z_"air" = qty("4e2","Pa s/m")$ $Z_"eau" = qty("1.5e6","Pa s/m")$.
]

#application[
    Montrer que l'énergie est conservée lors de la réflexion et transmission à l'interface.
]

= Cas des ondes électromagnétiques
== Courant surfacique
Dans un conducteur ohmique, le champ électrique des ondes électromagnétiques engendre un courant électrique d'après la loi d'Ohm locale. Ces ondes y restent en surface et ne pénètrent que de quelques fois la profondeur de peau : les courants électriques sont donc localisés en surface du conducteur. Lorsque les courants sont ainsi répartis à la surface, il est possible de les modéliser par des courants surfaciques.

#encadré(
    titre: "Vecteur densité surfacique de courant",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("I", "va(j_S)"))
)[
    $ I = integral_cal(C) va(j_S) dot va(n) dd(l) $

    où $cal(C)$ est une courbe tracée sur la surface parcourue par les courants et $va(n)$ le vecteur unitaire normal à $cal(C)$, tangent à cette surface.
]

== Relations de passage
Les composantes des champs magnétique et électrique vérifient des relations de passage aux interfaces entre deux milieux.

#encadré(
    titre: "Relations de passage sur le champ électrique",
    grandeurs: sub-dictionary(grandeurs, ("va(E_1)", "va(E_2)", "sigma", "epsilon_0", "va(n)_(1->2)")),
)[
    $ va(E_2) - va(E_1) = sigma/epsilon_0 va(n)_(1 -> 2) $
]

#application[
    Que peut-on dire des composantes du champ électrique tangentes à l'interface ?
]

#encadré(
    titre: "Relations de passage sur le champ magnétique",
    grandeurs: sub-dictionary(grandeurs, ("va(B_1)", "va(B_2)", "va(j_S)", "mu_0", "va(n)_(1->2)")),
)[
    $ va(B_2) - va(B_1) = mu_0 va(j_S) and va(n)_(1 -> 2) $
]

#application[
    Que peut-on dire de la composante du champ magnétique normale à l'interface ?
]

== Réflexion sur un métal parfait
Lorsqu'une onde électromagnétique arrive sur un métal parfait, elle se réfléchit.

#encadré(
    titre: "Onde réfléchie",
    savoir-faire: true,
    hypothèses: (
        [L'onde incidente s'écrit $underline(va(E_i))=E_0 e^(j(omega t-k x)) ey$.],
        [L'onde arrive en incidence normale et l'interface est en $x=0$.],
        [Le métal est parfait.],
        [L'onde réfléchie est une OPPH $underline(va(E_r))=underline(E_(0,r)) e^(j(omega t+k x)) ey$.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("va(E_r)", "E_0", "omega", "k")),
)[
    $ underline(va(E_r))= -E_0 e^(j(omega t + k x)) ey $
]

La réflexion sur un métal parfait est totale.

#application[
    Exprimer les champs électrique et magnétique réels totaux.
]

L'onde totale est une onde stationnaire pour laquelle l'interface est un nœud pour $va(E)$.

La réflexion de l'onde sur le métal induit un courant à sa surface.

#encadré(
    titre: "Courant surfacique induit par la réflexion sur un métal parfait",
    savoir-faire: true,
    hypothèses: (
        [L'onde incidente s'écrit $underline(va(E_i))=E_0 e^(j(omega t-k x)) ey$.],
        [L'onde arrive en incidence normale et l'interface est en $x=0$.],
        [Le métal est parfait.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("va(j_S)", "E_0", "mu_0", "c", "omega")),
)[
    $ va(j_S) = (2E_0)/(mu_0 c) cos(omega t) ey $
]

== Coefficient de réflexion en puissance
Il est possible de calculer le coefficient de réflexion en puissance.

#encadré(
    titre: "Coefficient de réflexion en puissance",
    savoir-faire: true,
    connaitre: true,
    hypothèses: (
        [L'onde incidente s'écrit $underline(va(E_i))=E_0 e^(j(omega t-k x)) ey$.],
        [L'onde arrive en incidence normale et l'interface est en $x=0$.],
        [Le métal est parfait.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("R", "va(Pi_r)", "va(Pi_i)")),
)[
    $
        R =: (||mean(va(Pi_r))||)/(||mean(va(Pi_i))||) = 1
    $
]

== Pression de radiation
#lien("https://www.youtube.com/watch?v=fEecdEzgxzA")
La réflexion sur un métal parfait engendre une force surfacique sur lui appelée *pression de radiation*.

#encadré(
    titre: "Force de Laplace pour un courant surfacique",
    grandeurs: sub-dictionary(grandeurs, ("va(delta F)", "va(j_S)", "va(B_1)", "va(B_2)", "dd(S)")),
)[
    $ va(delta F) = va(j_S) and va(B)_"moy" dd(S) quad "avec" quad va(B)_"moy" = (va(B_1) + va(B_2))/2 $

    Une nappe de courant ne subit pas son propre champ : c'est la moyenne des champs de part et d'autre qui intervient.
]

#encadré(
    titre: "Pression de radiation",
    savoir-faire: true,
    hypothèses: (
        [L'onde incidente s'écrit $underline(va(E_i))=E_0 e^(j(omega t-k x)) ey$.],
        [L'onde arrive en incidence normale et l'interface est en $x=0$.],
        [Le métal est parfait.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("P", "va(delta F)", "dd(S)", "epsilon_0", "E_0")),
)[
    $ P = mean((||va(delta F)||) / dd(S)) = epsilon_0 E_0^2 $
]

#application[
    La sonde spatiale IKAROS est le premier prototype utilisant une voile solaire comme moyen de propulsion. Sa voile mesure #qty("173","m^2"). On assimile la lumière du Soleil à une onde électromagnétique monochromatique d'amplitude #qty("600","V/m"). Calculer la force subie par la sonde.
]
