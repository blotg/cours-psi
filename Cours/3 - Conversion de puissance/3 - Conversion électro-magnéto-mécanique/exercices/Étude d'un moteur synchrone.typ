#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Étude d'un moteur synchrone",
    difficulté: 1,
)

#figure(
    image("../figures/2.png", width: 14cm),
)

Afin de simplifier l'étude, les pertes mécaniques ainsi que les pertes fer du moteur seront négligées. Le moteur est une machine synchrone diphasée dont les deux enroulements statoriques sont identiques.

Toutes les valeurs de tension et courant données le sont en valeur efficace.

L'inducteur du moteur synchrone est à aimants permanents et possède 8 pôles, soir 4 paires de pôles. En régime permanent de vitesse, la condition de synchronisme pour un moteur possédant $p$ paires de pôles s'écrit $w=p Omega$, où $Omega$ désigne la vitesse de rotation du rotor en #unit("rad/s").

Chaque bobinage du stator possède une résistance $R=#qty("0.03", "O")$. L'intensité nominale du courant dans un enroulement du stator est $I_N=#qty("155", "A")$. Pendant une durée limitée, elle peut atteindre la valeur maximale $I_M=#qty("185", "A")$. La machine est étudiée en convention récepteur. Le modèle équivalent à une phase de l'induit est représenté ci-contre. Les tensions et courants sont sinusoïdaux de pulsation $omega=2 pi f$ constante.
#let R = 0.03

Afin de déterminer les paramètres du modèle, divers essais sont effectuées :
/ essai n°1: sur un banc d'essai, on entraine la machine synchrone à vide par l'intermédiaire d'un moteur auxiliaire à la vitesse $n=#qty("1500", "tr/min")$. Aux bornes d'une phase, on a mesuré une tension de #qty("57", "V").
/ essai n°2: avec une alimentation électrique appropriée, on effectue un essai de la machine en moteur à #qty("1500", "tr/min"), pour lequel l'angle de pilotage vaut $Psi=0$, $I=I_M$ et $V=#qty("72", "V")$.
#let pulsation = (1500 / 60) * 2 * calc.pi
#let V = 72
#let E = 57
#let I = 155

#question(
    coups-de-pouce: (
        "Écrire la condition de synchrone (donnée dans l'énoncé). Attention aux unités.",
    ),
)[
    Déterminer la fréquence des tension statoriques quand $n=qty("1500", "tr/min")$.
][
    Comme le moteur possède 4 paires de pôles, en utilisant la condition de synchronisme $omega=p Omega$, on trouve une fréquence $f=(1500 / 60)times 4 = qty(#(1500 / 60 * 4), "Hz")$.
]
#let L = calc.sqrt(calc.pow(V, 2) - calc.pow(E + R * I, 2)) / (pulsation * I)
#question(
    coups-de-pouce: (
        "Que vaut le courant dans l'essai n°1 ? Écrire la loi des mailles pour l'essai n°1 et en déduire la force contre-électromotrice.",
        "Écrire la loi des mailles pour l'essai n°2 en utilisant la valeur de $Phi$ donnée.",
        "Écrire le théorème de Pythagore dans le triangle apparaissant sur le diagramme de Fresnel.",
    ),
)[
    Représenter le diagramme vectoriel relatif à l'essai n°2. La résistance $R$ n'étant *pas* négligée, en déduire la valeur numérique de $L$.
][
    Dans l'essai n°1, le moteur tourne à vide, donc $I=0$. La loi des mailles donne alors $V=E$, d'où $E=#qty("57", "V")$.

    La vitesse angulaire est la même dans l'essai 2 que l'essai 1, la force contre-électromotrice induite est donc la même : $E=#qty("57", "V")$.

    L'angle de pilotage $Psi$ est nul, donc le courant est en phase avec la tension $V$.

    La loi des mailles s'écrit $V=E + R I + j L omega I$.
    #figure(
        canvas({
            import draw: *
            line((0, 0), (4, 0), mark: (end: ">>", fill: black), name: "E")
            line((4, 0), (5, 0), mark: (end: ">>", fill: black), name: "RI")
            line((5, 0), (5, 3), mark: (end: ">>", fill: black), name: "LwI")
            line((0, 0), (5, 3), mark: (end: ">>", fill: black), name: "V")
            content("E.mid", $underline(E)$, anchor: "north", padding: .5em)
            content("RI.mid", $R underline(I)$, anchor: "north", padding: .5em)
            content("LwI.mid", $j L omega underline(I)$, anchor: "west", padding: .5em)
            content("V.mid", $underline(V)$, anchor: "south-east", padding: .5em)
        }),
    )
    En utilisant le théorème de Pythagore, on obtient :
    $ V^2 = (E + R I)^2 + (L omega I)^2 $
    D'où :
    $
        L = sqrt(V^2 - (E + R I)^2)/(omega I)
        = #qty(scientifique(L, 2), "H")
    $
]

#let A = E / pulsation
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
    $ A = E/Omega = #qty(scientifique(A, 2), "Wb") $
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
            import draw: *
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
            content("psi.mid", $psi$, anchor: "west", padding: .5em)
        }),
    )
    En projetant sur l'axe des abscisses, on obtient la relation :
    $ V cos(phi) = E cos(Psi) $
]

#question(
    coups-de-pouce: (
        "Attention, il y a deux phases à prendre en compte.",
        "Rappel des hypothèses : pertes Joules négligeables.",
    ),
)[
    Déterminer l'expression de la puissance électrique $P_a$ absorbée par le moteur en fonction de $V$, $I$ et $phi$, puis en fonction de $E$, $I$ et $Psi$. Quelle relation existe-t-il entre cette puissance électrique $P_a$ et la puissance mécanique électromagnétique $P_m$ reçue par le rotor ?
][
    La puissance électrique absorbée par le moteur s'écrit :
    $ P_a = 2 V I cos(phi) $
    (le facteur 2 provient du fait que la machine est diphasée).

    En utilisant la relation obtenue dans la question précédente, on a aussi :
    $ P_a = 2 E I cos(Psi) $

    En négligeant les pertes Joules, la puissance électrique absorbée par le stator est entièrement convertie en puissance mécanique électromagnétique reçue par le rotor. On a donc :
    $ P_a = P_m $
]

#question(
    coups-de-pouce: (
        "Exprimer la puissance mécanique en fonction du couple et de la vitesse angulaire puis la relier avec l'expression de la question précédente.",
        "Pour quelle valeur de $Psi$ le couple est-il maximal ?",
    ),
)[
    Exprimer le couple électromécanique $C$ développé par le moteur en fonction de $A$, $I$ et $Psi$. Pour une intensité efficace $I$ donnée, que doit-on faire pour maximiser le couple développé par la machine ? De quelle unique variable le couple dépend-il alors ? À quelle autre moteur ce fonctionnement fait-il penser ?
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

    Ce fonctionnement fait penser à celui d'un moteur à courant continu où le couple est proportionnel à l'intensité dans l'induit lorsque la force contre-électromotrice est négligée.
]


#let déphasage = calc.atan((L * pulsation * I) / E)
#question(
    coups-de-pouce: (
        "Représenter le diagramme de Fresnel et utiliser la trigonométrie pour déterminer $phi$ puis $V$.",
    ),
)[
    On se place sur un point de fonctionnement à $Psi=0$, $I=I_N$ et $n=qty("1500", "tr/min")$. Que vaut le moment du couple $C$ développé par le moteur ? Représenter le diagramme vectoriel représentatif du fonctionnement. Placer les vecteurs représentatifs des complexes $underline(E)$, $underline(V)$ et $underline(I)$. En déduire les expressions numériques de $V$ et $phi$. Calculer leurs valeurs numériques correspondantes.
][
    Le couple développé par le moteur vaut :
    $
        C = 2 A I_N cos(0) = 2 A I_N
        = #qty(scientifique(2 * A * I, 2), "N m")
    $

    #figure(
        canvas({
            import draw: *
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
    $ phi = atan((L omega I_N) / E) = #qty("33","deg") $

    En remplaçant $phi$ dans la première équation, on trouve :
    $ V = E / cos(phi) = #qty(scientifique(E / calc.cos(calc.atan((L * pulsation * I) / E)), 2), "V") $
]
