#import "@local/prepa:0.1.1": *

#show: cours.with(infos: yaml("infos.yml"))

#let grandeurs = (
    "v_1": (
        signification: "la sortie de l'amplificateur non-inverseur et l'entrée du filtre de Wien",
        unité: unit("V"),
    ),
    "v_2": (
        signification: "l'entrée de l'amplificateur non-inverseur et la sortie de filtre de Wien",
        unité: unit("V"),
    ),
    "R": (
        signification: "la résistance du filtre de Wien",
        unité: unit("O"),
    ),
    "R_1, R_2": (
        signification: "les résistances de l'amplificateur non-inverseur",
        unité: unit("O"),
    ),
    "C": (
        signification: "la capacité des condensateurs du filtre de Wien",
        unité: unit("F"),
    ),
    "V_\"sat\"": (
        signification: "la tension de saturation de l'ALI",
        unité: unit("V"),
    ),
    "u": (
        signification: "la sortie du comparateur à hystérésis positif et l'entrée de l'intégrateur",
        unité: unit("V"),
    ),
    "v": (
        signification: "l'entrée du comparateur à hystérésis positif et la sortie de l'intégrateur",
        unité: unit("V"),
    ),
    "T": (
        signification: "la période d'oscillation",
        unité: unit("s"),
    ),
)

= Les oscillateurs
Un oscillateur est un montage électronique délivrant un signal périodique.La fréquence peut généralement être réglée via le choix des composants.

Deux grandes familles d'oscillateurs existent :
- les oscillateurs quasi-sinusoïdaux produisent des signaux proches de sinusoïdes
- les oscillateurs à relaxation produisent des signaux créneaux ou triangulaires

Les oscillateurs sont souvent des systèmes bouclés.

= Oscillateur quasi-sinusoïdal : l'oscillateur de Wien
== Montage de l'oscillateur de Wien
Les oscillateurs quasi-sinusoïdaux sont très souvent constitués
- d'un amplificateur
- d'un filtre passe-bande

Pour le filtre de Wien, le filtre passe-bande est un filtre de Wien et l'amplificateur est un amplificateur non-inverseur.

#encadré(
    titre: "Montage de l'oscillateur de Wien",
    grandeurs: sub-dictionary(grandeurs, ("v_1", "v_2")),
    connaitre: true,
)[
    #carreaux(8cm)
]

#flashcard(
    recto: "Montage de l'oscillateur de Wien.",
    verso: "
    #import \"@preview/zap:0.6.0\"
    #import \"@preview/cetz:0.5.1\": draw
    #figure(
        zap.circuit({
            import zap: *
            import draw: *
            opamp(\"ALI\", (0,0), invert: true)
            resistor(\"R2\", (-1.5,-1.5), (1.5,-1.5), label: (content:$R_2$, anchor: \"south\"))
            resistor(\"R1\", (-1.5,-1.5), (-1.5,-4), label: $R_1$)
            swire(\"R1.in\", \"ALI.minus\", axis: \"y\")
            swire(\"ALI.out\", \"R2.out\")
            frame(\"G1\",\"R1.out\")
            rect((-2.5,-5), (1.8,1.2), stroke: (paint: red, dash: \"dashed\"), name: \"ANI\")
            content(\"ANI.south\", [Amplificateur non-inverseur], anchor: \"north\", padding: .4em)

            resistor(\"Rs\", (3,0), (5,0), label: $R$)
            capacitor(\"Cs\", (5,0), (7,0), label: $C$)
            resistor(\"Rp\", (7,-0), (7,-3), label: $R$)
            capacitor(\"Cp\", (8.5,0), (8.5,-3), label: $C$)
            frame(\"GR\", \"Rp.out\")
            frame(\"GC\", \"Cp.out\")
            wire(\"Cs.out\", \"Cp.in\")
            rect((3,-5), (10,1.2), name: \"FW\", stroke: (paint: blue, dash: \"dashed\"))
            content(\"FW.south\", [Filtre de Wien], anchor: \"north\", padding: .4em)

            wire(\"ALI.out\", \"Rs.in\")
            swire(\"Cp.in\", (rel: (2,0)), (rel:(-2,1.3), to: \"ALI.plus\"), \"ALI.plus\", axis: \"y\")
        })
    )",
)

Le fonctionnement des parties de l'oscillateur de Wien peut être représenté par un schéma-bloc.

#encadré(
    titre: "Schéma bloc de l'oscillateur de Wien",
    grandeurs: sub-dictionary(grandeurs, ("v_1", "v_2", "R", "R_1, R_2", "C")),
    savoir-faire: true,
    hypothèses: (
        "le circuit est dans l'ARQS",
        "la fréquence est dans la bande passante de l'amplificateur non-inverseur",
        "l'ALI est en régime linéaire",
    ),
)[
    #carreaux(5cm)
]

#question-de-colle("Schématiser le montage et établir le schéma-bloc de l'oscillateur de Wien.")

Le schéma-bloc met en évidence le caractère bouclé de l'oscillateur de Wien.

== Condition d'oscillation et fréquence des oscillations

La boucle présente sur le schéma-bloc contraint le signaux pouvant exister dans leur l'oscillateur. De plus, certaines conditions doivent être vérifiées pour que des oscillations sinusoïdales puissent exister.

Comme le système est bouclé, on doit retrouver le signal de départ après un tour de boucle complet. Mathématiquement, cela se traduit par le fait que le produit des fonctions de transfert doit être égal à $1$. Cette condition est appelée critère de Barkhausen.

#encadré(
    titre: "Condition d'oscillation et pulsation des oscillations sinusoïdales",
    grandeurs: sub-dictionary(grandeurs, ("R_1, R_2",)),
    savoir-faire: true,
    hypothèses: (
        "le circuit est dans l'ARQS",
        "la fréquence est dans la bande passante de l'amplificateur non-inverseur",
        "l'ALI est en régime linéaire",
    ),
)[
    Des oscillations sinusoïdales ne peuvent exister que si $R_2=2R_1$.
]

#encadré(
    titre: "Pulsation des oscillations sinusoïdales",
    grandeurs: sub-dictionary(grandeurs, ("R", "C")),
    savoir-faire: true,
    hypothèses: (
        "le circuit est dans l'ARQS",
        "la fréquence est dans la bande passante de l'amplificateur non-inverseur",
        "l'ALI est en régime linéaire",
        "la condition d'oscillation est vérifiée",
    ),
)[
    La pulsation des oscillations sinusoïdales est $omega=1/(R C)$.
]

De manière générale, un oscillateur quasi-sinusoïdal composé d'un filtre passe-bande et d'un amplificateur oscille à la pulsation caractéristique du filtre passe-bande si les conditions d'oscillation sont vérifiées.

#question-de-colle(
    "Le schéma-bloc de l’oscillateur de Wien étant fourni, établir la condition d’existence d’oscillations sinusoïdales ainsi que leur fréquence.",
)

== Démarrage des oscillations

Si le système est stable et que les tensions sont initialement nulles, rien ne se passe. Pour que des oscillations démarrent spontanément, le système bouclé doit être instable#footnote[C'est le système bouclé qui doit être instable. Chacun des deux systèmes qui le composent sont stables.].

#encadré(
    titre: "Condition de démarrage des oscillations",
    grandeurs: sub-dictionary(grandeurs, ("R_1, R_2",)),
    savoir-faire: true,
    hypothèses: (
        "le circuit est dans l'ARQS",
        "la fréquence est dans la bande passante de l'amplificateur non-inverseur",
        "l'ALI est en régime linéaire",
    ),
)[
    Pour que des oscillations démarrent, il faut que $R_2>2 R_1$.
]

La condition d'existence d'oscillations sinusoïdales apparait comme un cas limite de cette inégalité.

#manipulation(
    titre: "Démarrage des oscillations",
    matériel: (
        "oscilloscope",
        "alim. sym.",
        "breadboard \"Oscillateurs\"",
        "boite à décades de résistances",
        "2 adaptateurs banane-BNC",
        "caméra de projection sur pied"
    )
)[
    On réalise le montage de l'oscillateur de Wien avec une résistance $R_2$ réglable. On cherche les valeurs de $R_2$ pour lesquelles des oscillations apparaissent spontanément. On mesure la fréquence des oscillations dans le cas limite.
    #figure(
        zap.circuit({
            import zap: *
            import cetz.draw: *
            opamp("ALI", (0, 0), invert: true)
            resistor("R2", (-1.5, -1.5), (1.5, -1.5), label: (content: $R_2$, anchor: "south"), variable: true)
            resistor("R1", (-1.5, -1.5), (-1.5, -4), label: qty("10", "kO"))
            swire("R1.in", "ALI.minus", axis: "y")
            swire("ALI.out", "R2.out")
            frame("G1", "R1.out")

            resistor("Rs", (3, 0), (5, 0), label: qty("10", "kO"))
            capacitor("Cs", (5, 0), (7, 0), label: qty("100", "nF"))
            resistor("Rp", (7, -0), (7, -3), label: (content: qty("10", "kO"), anchor: "south"))
            capacitor("Cp", (8.5, 0), (8.5, -3), label: qty("100", "nF"))
            frame("GR", "Rp.out")
            frame("GC", "Cp.out")
            wire("Cs.out", "Cp.in")

            wire("ALI.out", "Rs.in")
            swire("Cp.in", (rel: (2, 0)), (rel: (-2, 1.3), to: "ALI.plus"), "ALI.plus", axis: "y")
        }),
    )
]

== Saturation de l'ALI
S'il n'y avait pas la saturation de l'ALI, l'amplitude des oscillations continuerait à augmenter indéfiniment tant que la condition de démarrage des oscillations reste vérifiée. C'est la saturation de l'ALI qui fixe l'amplitude des oscillations.

#encadré(
    titre: "Amplitude des tensions",
    grandeurs: sub-dictionary(grandeurs, ("v_1", "v_2", "V_\"sat\"")),
    savoir-faire: true,
    hypothèses: (
        "le circuit est dans l'ARQS",
        "la fréquence est dans la bande passante de l'amplificateur non-inverseur",
        "l'ALI est en régime linéaire",
        "la condition de démarrage des oscillations est vérifiée",
    ),
)[
    $v_1$ a pour amplitude $V_"sat"$ et $v_2$ a pour amplitude $V_"sat"/3$.
]

La saturation de l'ALI est un phénomène non linéaire, qui modifie donc les spectres de $v_1$ et $v_2$. Expérimentalement, on observe que plus $R_2-2R_1$ est grand, plus les spectres comportent d'harmoniques et moins les signaux sont sinusoïdaux.

La tension $v_2$ est "plus sinusoïdale" que $v_1$ car c'est la sortie du filtre passe-bande, qui diminue l'amplitude relative des harmoniques.

#question-de-colle(
    "Le schéma-bloc de l’oscillateur de Wien étant fourni, établir la condition de démarrage des oscillations et établir l’amplitude des oscillations sinusoïdales pour les deux tensions.",
)

= Oscillateur à relaxation
#grandeurs.insert("R", (signification: "la résistance de l'intégrateur", unité: unit("O")))
#grandeurs.insert("R_1, R_2", (signification: "les résistances du comparateur à hystérésis", unité: unit("O")))
#grandeurs.insert("C", (signification: "la capacité de l'intégrateur", unité: unit("F")))
== Montage de l'oscillateur à relaxation
L'oscillateur à relaxation est constitué d'un comparateur à hystérésis positif et d'un intégrateur.

#encadré(
    titre: "Montage de l'oscillateur à relaxation",
    grandeurs: sub-dictionary(grandeurs, ("u", "v")),
    connaitre: true,
)[
    #carreaux(7cm)
]

#flashcard(
    recto: "Montage de l'oscillateur à relaxation.",
    verso: "
    #import \"@preview/zap:0.6.0\"
    #import \"@preview/cetz:0.5.1\": draw
    #figure(
        zap.circuit({
            import zap: *
            import draw: *
            opamp(\"ALI\", (0,0), invert: true)
            resistor(\"R2\", (-2,1.5), (2,1.5), label: $R_2$)
            resistor(\"R1\", (rel:(-1,0), to: \"ALI.plus\"), (rel: (-2.5,0)), label: $R_1$)
            frame(\"G1\", (rel: (-.5,-.5), to:\"ALI.minus\"))
            swire(\"G1\", \"ALI.minus\", axis: \"y\")
            swire(\"ALI.out\", \"R2.out\")
            swire(\"R2.in\", \"ALI.plus\", axis: \"y\")
            rect((-4.2,-1.8), (2.5,3), stroke: (paint: red, dash: \"dashed\"), name: \"CH\")
            content(\"CH.south\", [Comparateur à hystérésis positif], anchor: \"north\", padding: .4em)

            opamp(\"ALI2\", (8,0))
            resistor(\"R\", (rel: (-1,0), to: \"ALI2.minus\"), (rel:(-3,0)), label: $R$)
            capacitor(\"C\", (6,2), (10,2), label: $C$)
            frame(\"G2\", (rel: (-.5,-.5), to:\"ALI2.plus\"))
            swire(\"G2\", \"ALI2.plus\", axis: \"y\")
            swire(\"ALI2.out\", \"C.out\")
            swire(\"C.in\", \"ALI2.minus\", axis: \"y\")
            rect((3.5,-1.8), (10.5,3), stroke: (paint: blue, dash: \"dashed\"), name: \"INT\")
            content(\"INT.south\", [Intégrateur], anchor: \"north\", padding: .4em)

            swire(\"ALI.out\", \"R.out\")
            swire(\"ALI2.out\", (11,3.5), (rel: (-0.3,0), to:\"R1.out\"),\"R1.out\")
        })
    )",
)

#encadré(
    titre: "Caractéristique du comparateur à hystérésis positif",
    grandeurs: sub-dictionary(grandeurs, ("u", "v", "R_1, R_2")),
    savoir-faire: true,
    hypothèses: (
        "le circuit est dans l'ARQS",
    ),
)[
    #carreaux(3cm)
]

#encadré(
    titre: "Fonction intégrateur",
    grandeurs: sub-dictionary(grandeurs, ("u", "v", "R", "C")),
    savoir-faire: true,
    hypothèses: (
        "le circuit est dans l'ARQS",
        "l'ALI est en régime linéaire",
    ),
)[
    $
        v(t) = v_0 - 1/(R C) integral_0^t u(x) dd(x)
    $
]

#question-de-colle(
    "Schématiser le montage de l’oscillateur à relaxation et établir l'équation différentielle du montage intégrateur et la caractéristique du montage comparateur à hystérésis positif.",
)

== Signaux de sortie
La sortie du comparateur à hystérésis vaut soit $V_"sat"$ soit $-V_"sat"$, il s'agit donc d'un signal créneau.

Son intégration par l'intégrateur donne un signal triangulaire en sortie de l'intégrateur.

#encadré(
    titre: "Allure des signaux de sortie",
    grandeurs: sub-dictionary(grandeurs, ("u", "v", "V_\"sat\"", "R_1, R_2")),
    savoir-faire: true,
    connaitre: true,
    hypothèses: (
        "le circuit est dans l'ARQS",
        "l'ALI de l'intégrateur est en régime linéaire",
        "la période est très grande devant la durée de commutation de l'ALI",
    ),
)[
    #carreaux(4cm)
]

#manipulation(titre: "Forme des signaux de sortie")[
    On réalise le montage de l'oscillateur à relaxation et on observe les signaux de sortie du comparateur à hystérésis et de l'intégrateur. On prend initialement $R_2=qty("22","kO")$
    #figure(
        zap.circuit({
            import zap: *
            import cetz.draw: *
            opamp("ALI", (0, 0), invert: true)
            resistor("R2", (-2, 1.5), (2, 1.5), label: $R_2$, variable: true)
            resistor("R1", (rel: (-1, 0), to: "ALI.plus"), (rel: (-2.5, 0)), label: qty("10", "kO"))
            frame("G1", (rel: (-.5, -.5), to: "ALI.minus"))
            swire("G1", "ALI.minus", axis: "y")
            swire("ALI.out", "R2.out")
            swire("R2.in", "ALI.plus", axis: "y")

            opamp("ALI2", (8, 0))
            resistor("R", (rel: (-1, 0), to: "ALI2.minus"), (rel: (-3, 0)), label: qty("10", "kO"))
            capacitor("C", (6, 2), (10, 2), label: qty("100", "nF"))
            frame("G2", (rel: (-.5, -.5), to: "ALI2.plus"))
            swire("G2", "ALI2.plus", axis: "y")
            swire("ALI2.out", "C.out")
            swire("C.in", "ALI2.minus", axis: "y")

            swire("ALI.out", "R.out")
            swire("ALI2.out", (11, 3), (rel: (-0.3, 0), to: "R1.out"), "R1.out")
        }),
    )
]

== Période d'oscillation

#encadré(
    titre: "Période d’oscillation de l'oscillateur à relaxation",
    grandeurs: sub-dictionary(grandeurs, ("T", "R_1, R_2", "R", "C")),
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "le circuit est dans l'ARQS",
        "l'ALI de l'intégrateur est en régime linéaire",
        "la période est très grande devant la durée de commutation de l'ALI",
    ),
)[
    $
        T = 4 R_1/R_2 R C
    $
]

Cette expression est valable tant que la période est très grande devant la durée de commutation de l'ALI.
#schéma(titre: "Influence de la vitesse de balayage sur le signal créneau", hauteur: 3cm)

#application[
    Déterminer la durée de commutation de l'ALI.
]

#question-de-colle(
    "L'équation différentielle de l'intégrateur et la caractéristique du comparateur à hystérésis étant données, établir la forme des signaux dans un oscillateur à relaxation et leur période.",
)

== Choix de $R_1$ et $R_2$

La tension $v(t)$ étant la sortie de l'ALI, $v in [-V_"sat",V_"sat"]$. Si cette tension est inférieure à la tension de seuil du comparateur à hystérésis, celui-ci ne commutera jamais et l'oscillateur n'oscillera pas.

#application[
    À quelle condition sur $R_1$ et $R_2$ peut-on observer des oscillations ?
]

#application[
    Tracer les chronogrammes de $u(t)$ et $v(t)$ dans le cas où $R_1 > R_2$. On supposera qu'initialement, $u(0) = -V_"sat"$ et $v(0) = 0$.
]

#manipulation(titre: "Condition d'oscillation")[
    On reprend le montage précédent et on change la valeur de $R_2$.
]
