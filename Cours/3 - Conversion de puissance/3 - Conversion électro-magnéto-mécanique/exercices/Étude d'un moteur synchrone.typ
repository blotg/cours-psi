#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Étude d'un moteur synchrone",
    difficulté: 1,
)

#figure(
    grid(
        columns: (1fr, 1fr),
        align: horizon,
        circuit({
            import zap: *
            import cetz.draw: *
            node("A", (0, 3), fill: true)
            node("B", (0, 0), fill: true)
            fil((0, 3), (1, 3), i: $underline(I)$)
            resistor("R", (1, 3), (3, 3), label: $R$)
            inductor("L", (3, 3), (5, 3), label: $L$, variant: "ieee")
            wire((5, 3), (6, 3))
            vsource("E", (6, 0), (6, 3), u: $underline(E)$)
            wire((6, 0), (0, 0))
            line((0, 0.3), (0, 2.7), mark: (end: ">>", fill: black), name: "V")
            content("V.mid", $underline(V)$, anchor: "east", padding: 4pt)
        }),
        canvas({
            import cetz.draw: *
            let psi = 30deg
            let E = 4
            let RI = 0.7
            let XI = 2.2
            let Ee = (E * calc.cos(psi), E * calc.sin(psi))
            let Ve = (Ee.at(0) + RI, Ee.at(1) + XI)
            let ang-phi = calc.atan2(Ve.at(0), Ve.at(1))
            line((0, 0), (2.6, 0), mark: (end: ">>", fill: red), stroke: red, name: "I")
            line((0, 0), Ee, mark: (end: ">>", fill: black), name: "E")
            line(Ee, (rel: (RI, 0)), mark: (end: ">>", fill: black), name: "RI")
            line("RI.end", Ve, mark: (end: ">>", fill: black), name: "XI")
            line((0, 0), Ve, mark: (end: ">>", fill: black), name: "V")
            arc((1.2, 0), radius: 1.2, start: 0deg, stop: psi, mark: (end: ">>", fill: black), name: "psi")
            arc((1.9, 0), radius: 1.9, start: 0deg, stop: ang-phi, mark: (end: ">>", fill: black), name: "phi")
            arc((0, 0), anchor: "origin", radius: 3, start: psi, stop: ang-phi, mark: (end: ">>", fill: black), name: "delta")
            content("I.end", text(red, $underline(I)$), anchor: "west", padding: 3pt)
            content((0.75 * Ee.at(0), 0.75 * Ee.at(1)), $underline(E)$, anchor: "north-west", padding: 3pt)
            content("V.mid", $underline(V)$, anchor: "south-east", padding: 3pt)
            content("RI.mid", $R underline(I)$, anchor: "north", padding: 3pt)
            content("XI.mid", $j L omega underline(I)$, anchor: "west", padding: 3pt)
            content((15deg, 1.45), $Psi$)
            content((37deg, 2.4), $phi$)
            content((ang-phi / 2 + psi / 2, 3.3), $delta$)
        }),
    ),
)

Afin de simplifier l'étude, les pertes mécaniques ainsi que les pertes fer du moteur seront négligées. Le moteur est une machine synchrone diphasée dont les deux enroulements statoriques sont identiques.

Toutes les valeurs de tension et courant données le sont en valeur efficace.

L'inducteur du moteur synchrone est à aimants permanents et possède 8 pôles, soit 4 paires de pôles. En régime permanent de vitesse, la condition de synchronisme pour un moteur possédant $p$ paires de pôles s'écrit $omega=p Omega$, où $Omega$ désigne la vitesse de rotation du rotor en #unit("rad/s").

Chaque bobinage du stator possède une résistance $R=#quan[0.03 Ω]$. L'intensité nominale du courant dans un enroulement du stator est $I_N=#quan[155 A]$. Pendant une durée limitée, elle peut atteindre la valeur maximale $I_M=#quan[185 A]$. La machine est étudiée en convention récepteur. Le modèle équivalent à une phase de l'induit et le diagramme de Fresnel associé sont représentés ci-dessus. Le courant $underline(I)$ y est pris comme origine des phases : $phi$ est le déphasage de $underline(V)$ par rapport à $underline(I)$ et $Psi$, l'angle de pilotage, celui de $underline(E)$ par rapport à $underline(I)$. Les tensions et courants sont sinusoïdaux de pulsation $omega=2 pi f$ constante.
#let R = 0.03

Afin de déterminer les paramètres du modèle, divers essais sont effectués :
/ essai n°1: sur un banc d'essai, on entraine la machine synchrone à vide par l'intermédiaire d'un moteur auxiliaire à la vitesse $n=#quan[1500 tr/min]$. Aux bornes d'une phase, on a mesuré une tension de #quan[57 V].
/ essai n°2: avec une alimentation électrique appropriée, on effectue un essai de la machine en moteur à #quan[1500 tr/min], pour lequel l'angle de pilotage vaut $Psi=0$, $I=I_M$ et $V=#quan[72 V]$.
// Ω, la vitesse angulaire du rotor ; ω = p Ω, la pulsation des courants.
#let vitesse-angulaire = (1500 / 60) * 2 * calc.pi
#let pulsation = 4 * vitesse-angulaire
#let V = 72
#let E = 57
#let IM = 185
#let IN = 155

#question(
    coups-de-pouce: (
        "Écrire la condition de synchronisme (donnée dans l'énoncé). Attention aux unités.",
    ),
)[
    Déterminer la fréquence des tensions statoriques quand $n=#quan[1500 tr/min]$.
][
    Comme le moteur possède 4 paires de pôles, en utilisant la condition de synchronisme $omega=p Omega$, on trouve une fréquence $f=(1500 / 60)times 4 = #qty(1500 / 60 * 4, "Hz")$.
]
#let L = calc.sqrt(calc.pow(V, 2) - calc.pow(E + R * IM, 2)) / (pulsation * IM)
#question(
    coups-de-pouce: (
        "Que vaut le courant dans l'essai n°1 ? Écrire la loi des mailles pour l'essai n°1 et en déduire la force contre-électromotrice.",
        "Écrire la loi des mailles pour l'essai n°2, la force contre-électromotrice étant celle de l'essai n°1.",
        "Écrire le théorème de Pythagore dans le triangle apparaissant sur le diagramme de Fresnel.",
    ),
)[
    Représenter le diagramme vectoriel relatif à l'essai n°2. La résistance $R$ n'étant *pas* négligée, en déduire la valeur numérique de $L$.
][
    Dans l'essai n°1, le moteur tourne à vide, donc $I=0$. La loi des mailles donne alors $V=E$, d'où $E=#quan[57 V]$.

    La vitesse angulaire est la même dans l'essai 2 que l'essai 1, la force contre-électromotrice induite est donc la même : $E=#quan[57 V]$.

    L'angle de pilotage $Psi$ est nul, donc le courant est en phase avec la force contre-électromotrice $E$.

    La loi des mailles s'écrit $V=E + R I + j L omega I$.
    #figure(
        canvas({
            import cetz.draw: *
            line((0, 0), (4, 0), mark: (end: ">>", fill: black), name: "E")
            line((4, 0), (5, 0), mark: (end: ">>", fill: black), name: "RI")
            line((5, 0), (5, 3), mark: (end: ">>", fill: black), name: "LwI")
            line((0, 0), (5, 3), mark: (end: ">>", fill: black), name: "V")
            line((0, -0.6), (2, -0.6), mark: (end: ">>", fill: red), stroke: red, name: "I")
            content("I.end", [#set text(red); $underline(I)$], anchor: "west", padding: .3em)
            content("E.mid", $underline(E)$, anchor: "south", padding: .3em)
            content("RI.mid", $R underline(I)$, anchor: "north", padding: .5em)
            content("LwI.mid", $j L omega underline(I)$, anchor: "west", padding: .5em)
            content("V.mid", $underline(V)$, anchor: "south-east", padding: .5em)
        }),
    )
    En utilisant le théorème de Pythagore, on obtient :
    $ V^2 = (E + R I_M)^2 + (L omega I_M)^2 $ avec $omega = p Omega = #qty(pulsation, "rad/s", chiffres: 3)$.
    D'où :
    $
        L = sqrt(V^2 - (E + R I_M)^2)/(omega I_M)
        = #qty(L, "H", chiffres: 2)
    $
]

#let A = E / vitesse-angulaire
#question(
    coups-de-pouce: (
        "Utiliser la condition de synchronisme.",
    ),
)[
    La valeur efficace de la force contre-électromotrice $E$ a pour expression $E=Phi_0 omega$. Quelle est l'unité de la constante $Phi_0$ dans le système SI ? Que représente-t-elle ? De quels paramètres de la machine dépend-elle ? Montrer que $E=A Omega$, où $A$ est une constante dont on précisera l'expression et la valeur numérique.
][
    $Phi_0$ est un flux magnétique, son unité est donc le #unit("Wb") (weber). Il représente le flux magnétique créé par l'inducteur à aimants permanents à travers une spire de l'induit. Il dépend de la géométrie de la machine et de l'induction magnétique créée par les aimants permanents.

    En utilisant la condition de synchronisme $omega=p Omega$, on a :
    $ E = Phi_0 omega = Phi_0 p Omega = A Omega $ d'où
    $ A = p Phi_0 = E/Omega = #qty(A, "Wb", chiffres: 2) $
]


#question(
    coups-de-pouce: (
        "Écrire la loi des mailles dans un circuit statorique puis la représenter sur un diagramme de Fresnel. Représenter les angles $phi$ et $Psi$ sur le diagramme.",
        "Relier géométriquement les projections de $underline(V)$ et $underline(E)$ sur l'axe des abscisses. En déduire une relation mathématique en utilisant la trigonométrie.",
    ),
)[
    Dans toute la suite, on négligera la chute de tension ohmique ainsi que les pertes par effet Joule dans les circuits statoriques. Tracer un diagramme vectoriel représentatif d'un point de fonctionnement quelconque dans le cas où $0 < Psi < pi/2$. En déduire une relation entre $V$, $E$, $phi$ et $Psi$.
][
    En négligeant la chute de tension ohmique, la loi des mailles s'écrit :
    $ underline(V) = underline(E) + j L omega underline(I) $
    #figure(
        canvas({
            import cetz.draw: *
            line((0, 0), (30deg, 4), mark: (end: ">>", fill: black), name: "E")
            line("E.end", (rel: (0, 3)), mark: (end: ">>", fill: black), name: "LwI")
            line((0, 0), "LwI.end", mark: (end: ">>", fill: black), name: "V")
            line((0, 0), (3.47, 0), stroke: (dash: "dashed"))
            line("E.end", (rel: (0, -2)), stroke: (dash: "dashed"))
            line((0, 0), (2, 0), mark: (end: ">>", fill: red), stroke: red, name: "I")
            arc((1, 0), radius: 1, start: 0deg, stop: 55deg, mark: (end: ">>", fill: black), name: "phi")
            arc((1.7, 0), radius: 1.7, start: 0deg, stop: 30deg, mark: (end: ">>", fill: black), name: "psi")
            content("E.mid", $underline(E)$, anchor: "south-east", padding: .1em)
            content("LwI.mid", $j L omega underline(I)$, anchor: "west", padding: .5em)
            content("V.mid", $underline(V)$, anchor: "south-east", padding: .1em)
            content("I.mid", [#set text(red); $underline(I)$], anchor: "north", padding: .5em)
            content("phi.mid", $phi$, anchor: "west", padding: .5em)
            content("psi.mid", $Psi$, anchor: "west", padding: .5em)
        }),
    )
    En projetant sur l'axe des abscisses, on obtient la relation :
    $ V cos(phi) = E cos(Psi) $
]

#question(
    coups-de-pouce: (
        "Attention, il y a deux phases à prendre en compte.",
        "Rappel des hypothèses : pertes Joule négligeables.",
    ),
)[
    Déterminer l'expression de la puissance électrique moyenne $P_a$ absorbée par le moteur en fonction de $V$, $I$ et $phi$, puis en fonction de $E$, $I$ et $Psi$. Quelle relation existe-t-il entre cette puissance électrique $P_a$ et la puissance mécanique électromagnétique $P_m$ reçue par le rotor ?
][
    La puissance électrique absorbée par le moteur s'écrit :
    $ P_a = 2 V I cos(phi) $
    (le facteur 2 provient du fait que la machine est diphasée).

    En utilisant la relation obtenue dans la question précédente, on a aussi :
    $ P_a = 2 E I cos(Psi) $

    En négligeant les pertes Joule, la puissance électrique absorbée par le stator est entièrement convertie en puissance mécanique électromagnétique reçue par le rotor. On a donc :
    $ P_a = P_m $
]

#question(
    coups-de-pouce: (
        "Exprimer la puissance mécanique en fonction du couple et de la vitesse angulaire puis la relier avec l'expression de la question précédente.",
        "Pour quelle valeur de $Psi$ le couple est-il maximal ?",
    ),
)[
    Exprimer le couple électromécanique $C$ développé par le moteur en fonction de $A$, $I$ et $Psi$. Pour une intensité efficace $I$ donnée, que doit-on faire pour maximiser le couple développé par la machine ? De quelle unique variable le couple dépend-il alors ? À quel autre moteur ce fonctionnement fait-il penser ?
][
    La puissance mécanique électromagnétique reçue par le rotor s'écrit :
    $ P_m = C Omega $
    En utilisant l'expression de la puissance électrique absorbée obtenue précédemment, on a :
    $ C Omega = 2 E I cos(Psi) $
    D'où :
    $ C = (2 E I cos(Psi)) / Omega $
    En remplaçant $E$ par son expression en fonction de $A$, on obtient :
    $ C = 2 A I cos(Psi) $

    Pour une intensité efficace $I$ donnée, le couple est maximal lorsque $cos(Psi)$ est maximal, c'est-à-dire lorsque $Psi=0$.

    Dans ce cas, le couple dépend uniquement de l'intensité efficace $I$.

    Ce fonctionnement fait penser à celui d'un moteur à courant continu, dont le couple est proportionnel à l'intensité dans l'induit.
]


#let déphasage = calc.atan((L * pulsation * IN) / E)
#question(
    coups-de-pouce: (
        "Représenter le diagramme de Fresnel et utiliser la trigonométrie pour déterminer $phi$ puis $V$.",
    ),
)[
    On se place sur un point de fonctionnement à $Psi=0$, $I=I_N$ et $n=#quan[1500 tr/min]$. Que vaut le moment du couple $C$ développé par le moteur ? Représenter le diagramme vectoriel représentatif du fonctionnement. Placer les vecteurs représentatifs des complexes $underline(E)$, $underline(V)$ et $underline(I)$. En déduire les expressions numériques de $V$ et $phi$. Calculer leurs valeurs numériques correspondantes.
][
    Le couple développé par le moteur vaut :
    $
        C = 2 A I_N cos(0) = 2 A I_N
        = #qty(2 * A * IN, "N m", chiffres: 3)
    $

    #figure(
        canvas({
            import cetz.draw: *
            line((0, 0), (0deg, 4), mark: (end: ">>", fill: black), name: "E")
            line("E.end", (rel: (0, 3)), mark: (end: ">>", fill: black), name: "LwI")
            line((0, 0), "LwI.end", mark: (end: ">>", fill: black), name: "V")
            line((0, 0), (2, 0), mark: (end: ">>", fill: red), stroke: red, name: "I")
            arc((1, 0), radius: 1, start: 0deg, stop: 36deg, mark: (end: ">>", fill: black), name: "phi")
            content("E.mid", $underline(E)$, anchor: "south", padding: .5em)
            content("LwI.mid", $j L omega underline(I)$, anchor: "west", padding: .5em)
            content("V.mid", $underline(V)$, anchor: "south-east", padding: .1em)
            content("I.mid", [#set text(red); $underline(I)$], anchor: "north", padding: .5em)
            content("phi.mid", $phi$, anchor: "west", padding: .5em)
        }),
    )

    En utilisant le diagramme de Fresnel avec $Psi=0$, on a :
    $ V cos(phi) = E $
    et
    $ V sin(phi) = L omega I_N $

    En divisant la deuxième équation par la première, on obtient :
    $ tan(phi) = (L omega I_N) / E $
    D'où :
    $ phi = arctan((L omega I_N) / E) = #str(int(calc.round(déphasage.deg())))° $

    En remplaçant $phi$ dans la première équation, on trouve :
    $ V = E / cos(phi) = #qty(E / calc.cos(déphasage), "V", chiffres: 2) $
]
