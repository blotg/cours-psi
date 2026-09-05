#import "@local/prepa:0.1.1": *

#show: cours.with(infos: yaml("infos.yml"))

#let grandeurs = (
    "xi": (signification: "l'avancement", unité: unit("mol")),
    "Y": (signification: "une grandeur thermodynamique extensive quelconque"),
    "Delta_r Y": (signification: "la grandeur Y de réaction", unité: [unité de $Y$ #unit("/mol")]),
    "T": (signification: "la température", unité: unit("K")),
    "P": (signification: "la pression", unité: unit("Pa")),
    "nu_i": (signification: "le coefficient stœchiométrique algébrique de la i-ème espèce (négatif pour un réactif)", unité: "sans unité"),
    "Y_m(X_i)": (signification: "la grandeur Y molaire de l'espèce #ce(\"X_i\")", unité: [unité de $Y$ #unit("/mol")]),
    "Delta_f H(X_i)": (signification: "l'enthalpie de formation de l'espèce #ce(\"X_i\")", unité: unit("J/mol")),
    "Delta_r H": (signification: "l'enthalpie de réaction", unité: unit("J/mol")),
    "Delta H": (signification: "la variation d'enthalpie", unité: unit("J")),
    "Q": (signification: "la chaleur échangée", unité: unit("J")),
    "T_i": (signification: "la température initiale", unité: unit("K")),
    "T_f": (signification: "la température finale", unité: unit("K")),
    "C_P": (signification: "la capacité thermique à pression constante *des produits et des réactifs non consommés*", unité: unit("J/K"))
)

= Grandeur standard
== État standard
La pression standard est la pression $standard(P)=qty("1", "bar")=qty("1e5", "Pa")$. La pression standard est approximativement égale à la pression atmosphérique.

La température de référence est la température $T=qty("25", "Celsius")=qty("298.15", "K")$.

L'état standard d'une substance est un état particulier servant de référence pour les tables de grandeurs physicochimiques. L'état standard d'un corps pur est l'état physique (liquide, solide ou gaz) le plus stable à la pression standard. Si l'état le plus stable est l'état gazeux, on prend le gaz parfait comme état standard.

#flashcard(
    recto: "Pression standard",
    verso: "$standard(P)=qty(\"1\",\"bar\")=qty(\"1e5\",\"Pa\")$",
)
#flashcard(
    recto: "Température de référence",
    verso: "$T=qty(\"25\",\"Celsius\")=qty(\"298.15\",\"K\")$",
)

L'état standard de référence est l'état standard à la température de référence.

#application[
    Quel est l'état standard de l'eau à #qty("400", "K") ?
]
#application[
    Quel est l'état standard de référence de l'eau ?
]
#application[
    Quel est l'état standard de référence du chlorure de sodium ?
]

== Grandeur de réaction
Lorsqu'une réaction chimique se produit, des grandeurs thermodynamiques du système peuvent varier. Les grandeurs de réaction représentent à quel point la grandeur varie lorsque la réaction se produit.

#encadré(
    titre: "Grandeur de réaction",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("Delta_r Y", "Y", "xi", "T", "P")),
)[
    $ Delta_r Y = lr(pdv(Y, xi) \))_(T,P) $
]

#exemple[
    On utilise souvent l'enthalpie de réaction $Delta_r H=lr(pdv(H, xi)\))_(T,P)$ qui se mesure en #unit("J/mol") et l'entropie de réaction $Delta_r S=lr(pdv(S, xi)\))_(T,P)$ qui se mesure en #unit("J/K/mol").
]

#encadré(
    titre: "Grandeur de réaction en fonction des grandeurs molaires",
    grandeurs: sub-dictionary(grandeurs, ("Delta_r Y", "Y_m(X_i)", "nu_i")),
    connaitre: true
)[
    $ Delta_r Y=sum nu_i Y_m(X_i) $
]

== Grandeur standard de réaction
Une grandeur standard de réaction est une grandeur de réaction pour laquelle on considère chaque constituant du mélange dans son état standard. On note les grandeurs standards avec un $standard("")$.

#encadré(
    titre: "Grandeur standard de réaction",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("Delta_r Y", "Y_m(X_i)", "nu_i")),
)[
    $ standard(Delta_r Y) = sum nu_i standard(Y_m(X_i)) $
]

#flashcard(
    recto: "Grandeur standard de réaction",
    verso: "$ standard(Delta_r Y) = sum nu_i standard(Y_m(X_i)) $",
)


#application[
    Déterminer l'entropie standard de réaction de #ce("Ni(CO)_4(g)") #ce("->") #ce("Ni(s)") + 4 #ce("CO(g)").
    #table(
        columns: 4,
        [Espèces chimiques], ce("Ni(CO)_4(g)"), ce("Ni(s)"), ce("CO(g)"),
        [$standard(S)_m$ (#unit("J/K/mol"))], num("409"), num("30"), num("198"),
    )
]

== Loi de Hess
La loi de Hess est un cas particulier de la formule précédente pour l'enthalpie.

On ne peut pas parler d'enthalpie molaire d'un réactif car l'enthalpie est définie à une constante additive près#footnote[Le premier principe définit l'énergie interne comme une grandeur dont la *variation* est reliée au travail et à la chaleur. L'énergie interne est donc définie à une constante additive près. Comme l'enthalpie est définie à partir de l'énergie interne, l'enthalpie est définie à une constante additive près.]. On choisit alors une "origine" des enthalpies : les corps simples dans leur état standard.

Un corps simple est un corps constitué d'un seul type d'atome.

#application[
    Parmi les substances suivantes, lesquelles sont des corps simples ? Graphite, diamant, eau pure, eau de mer, air, diazote, argon.
]
#application[
    Quels sont les corps simples dans leur état standard de référence pour les éléments suivants ? Carbone, hydrogène, oxygène, azote.
]

La réaction de formation d'une espèce #ce("X") est une réaction dont le seul produit est #ce("X"), avec comme coefficient stœchiométrique $1$, et dont les réactifs sont des corps simples dans leur état standard.

#application[
    Écrire les réactions de formation des espèces suivantes : eau liquide, dioxyde de carbone gazeux, diazote liquide.
]

L'enthalpie standard de formation $standard(Delta_f H)$ d'une espèce est l'enthalpie standard de réaction $standard(Delta_r H)$ pour la réaction de formation de cette espèce. L'enthalpie standard de formation d'un corps simple dans son état standard est donc nulle.

#flashcard(
    recto: "Pour quelles espèces l'enthalpie standard de formation est-elle nulle ?",
    verso: "Les corps simples dans leur état standard.",
)
#application[
    Donner l'enthalpie standard de formation $standard(Delta_f H)$ des espèces suivantes : #ce("H2(g)"), #ce("C(gr)"), #ce("O2(g)").
]

#encadré(
    titre: "Loi de Hess",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("Delta_r H", "Delta_f H(X_i)", "nu_i")),
)[
    $ standard(Delta_r H) = sum nu_i standard(Delta_f H(X_i)) $
]

#flashcard(
    recto: "Loi de Hess",
    verso: "$ standard(Delta_r H) = sum nu_i standard(Delta_f H(X_i)) $",
)

#application[
    Calculer l'enthalpie standard de réaction de la combustion du méthane #ce("CH4(g)") + 2 #ce("O2(g)") #ce("->") #ce("CO2(g)") + 2 #ce("H2O(g)")
    #table(
        columns: 4,
        [Espèces chimiques], ce("CH4(g)"), ce("CO2(g)"), ce("H2O(g)"),
        [$standard(Delta_f H)$ (#unit("kJ/mol"))], num("-74.9"), num("-393.52"), num("-241.8"),
    )

]

#encadré(
    titre: "Classification des réactions chimiques selon l'enthalpie de réaction",
    grandeurs: sub-dictionary(grandeurs, ("Delta_r H",)),
)[
    Si $standard(Delta_r H) > 0$, la réaction est dite endothermique.

    Si $standard(Delta_r H) < 0$, la réaction est dite exothermique.
]

#flashcard(
    recto: "Réaction exothermique",
    verso: "$standard(Delta_r H) < 0$",
)
#flashcard(
    recto: "Réaction endothermique",
    verso: "$standard(Delta_r H) > 0$",
)

#application[
    Est-ce que la combustion du méthane est endothermique ou exothermique ?
]

= Effets thermiques pour une transformation isobare
== Transfert thermique causé par une transformation chimique
Lorsqu'une réaction chimique se produit au contact d'un thermostat, la variation d'entropie due à la réaction entraine un transfert thermique avec le thermostat.

#figure(
    canvas({
        import cetz.draw: *
        content(
            (0, 0),
            [
                État initial :\
                $n_(1,i)$ moles de #ce("X_1")\
                $n_(2,i)$ moles de #ce("X_2")\
                ...\
                $T$, $standard(P)$
            ],
            frame: "rect",
            padding: .6em,
            name: "i",
        )
        content(
            (6, 0),
            [
                État final :\
                $n_(1,f)$ moles de #ce("X_1")\
                $n_(2,f)$ moles de #ce("X_2")\
                ...\
                $T$, $standard(P)$
            ],
            frame: "rect",
            padding: .6em,
            name: "f",
        )
        line("i", "f", mark: (end: ">>", fill: black), name: "flèche")
        content("flèche.mid", $Delta H$, anchor: "south", padding: .4em)
    }),
)

#encadré(
    titre: "Variation de l'enthalpie",
    hypothèses: (
        "La réaction est isotherme",
        "La réaction est isobare",
    ),
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("Delta H", "Delta_r H", "xi")),
)[
    $ standard(Delta H) = xi standard(Delta_r H) $
]

#flashcard(
    recto: "Variation de l'enthalpie pour une isotherme isobare à la pression standard",
    verso: "$ standard(Delta H) = xi standard(Delta_r H) $",
)

#encadré(
    titre: "Chaleur échangée",
    hypothèses: (
        "La réaction est isotherme",
        "La réaction est isobare",
    ),
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("Delta H","Q")),
)[
    $ standard(Delta H) = Q $
]

- Pour une réaction exothermique, la chaleur va du système vers le thermostat ($Q<0$)
- Pour une réaction endothermique, la chaleur va du thermostat vers le système ($Q>0$)

#application[
    Calculer la chaleur libérée par la combustion de #qty("0.5","mol") de méthane.
]

== Température de flamme
La température de flamme est la température atteinte par un système lors d'une réaction adiabatique, isobare.

Pour une transformation adiabatique et isobare, la variation d'enthalpie est nulle.

#figure(
    canvas({
        import cetz.draw: *
        content(
            (0, 0),
            [
                État initial :\
                $n_(1,i)$ moles de #ce("X_1")\
                $n_(2,i)$ moles de #ce("X_2")\
                ...\
                $T_i$, $standard(P)$
            ],
            frame: "rect",
            padding: .6em,
            name: "i",
        )
        content(
            (6, 0),
            [
                État final :\
                $n_(1,f)$ moles de #ce("X_1")\
                $n_(2,f)$ moles de #ce("X_2")\
                ...\
                $T_f$, $standard(P)$
            ],
            frame: "rect",
            padding: .6em,
            name: "f",
        )
        line("i", "f", mark: (end: ">>", fill: black), name: "flèche")
        content("flèche.mid", $Delta H$, anchor: "south", padding: .4em)
    }),
)

#encadré(
    titre: "Température de flamme",
    hypothèses: (
        "La transformation est isobare",
        "La transformation est adiabatique",
        "La capacité thermique des produits est indépendante de la température",
    ),
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("T_i", "T_f", "xi", "Delta_r H", "C_P")),
)[
    $ T_f = T_i - (xi standard(Delta_r H))/C_P $
]

#flashcard(
    recto: "Définition température de flamme",
    verso: "Température atteinte pour une réaction faite de façon adiabatique et isobare."
)
#flashcard(
    recto: "Méthode calcul température de flamme",
    verso: "Décomposer la réaction en (1) une isotherme et (2) une élévation de température sans réaction. Utiliser le fait que l'enthalpie est une fonction d'état."
)

Il est également possible d'exprimer la température de flamme en fonction de la capacité thermique du système avant réaction plutôt qu'après réaction.

#application[
    Calculer la température de flamme du méthane en réaction avec du dioxygène pur, dans les proportions stœchiométriques et avec une température initiale $T_i=qty("25","Celsius")$.
    #table(
        columns: 3,
        [Espèces chimiques], ce("CO2(g)"), ce("H2O(g)"),
        [$C_(P,m)$ (#unit("J/K/mol"))], num("40"), num("36.5"),
    )
]


