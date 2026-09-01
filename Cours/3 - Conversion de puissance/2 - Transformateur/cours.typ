#import "@local/prepa:0.1.1": *

#show: cours.with(infos: yaml("infos.yml"))

#let grandeurs = (
    v_1: (signification: "Tension aux bornes du primaire", unité: unit("V")),
    v_2: (signification: "Tension aux bornes du secondaire", unité: unit("V")),
    i_1: (signification: "Courant dans le primaire", unité: unit("A")),
    i_2: (signification: "Courant dans le secondaire", unité: unit("A")),
    N_1: (signification: "Nombre de spires de l'enroulement primaire", unité: "sans unité"),
    N_2: (signification: "Nombre de spires de l'enroulement secondaire", unité: "sans unité"),
    m: (signification: "$=N_2/N_1$ Rapport de transformation", unité: "sans unité"),
    p_1: (signification: "Puissance électrique *reçue* au primaire", unité: unit("W")),
    p_2: (signification: "Puissance électrique *fournie* au secondaire", unité: unit("W")),
)

= Présentation du transformateur
Le transformateur est constitué d'un circuit magnétique sans entrefer sur lequel sont enroulé deux enroulements appelés primaire et secondaire.

#schéma(titre: "Transformateur")[#box(height: 4cm)]

Le transformateur est utilisé pour modifier l'amplitude de la tension et de l'intensité du courant en régime alternatif.

#grid(
    columns: 3,
    column-gutter: 0.5cm,
    align: bottom,
    figure(caption: "Transformateur domestique.")[
        #image("images/transformateur.png", width: 100%)
    ],
    figure(caption: "Transformateur source sur un poteau Enedis.")[
        #image("images/poteau.jpg", width: 100%)
    ],
    figure(caption: "Transformateur dans un poste source.")[
        #image("images/poste source.jpg", width: 100%)
    ],
)

= Modèle du transformateur idéal
== Présentation du modèle
Dans le modèle du transformateur idéal,
- toutes les pertes (cuivre et fer) sont négligées,
- le matériau ferromagnétique est doux hors saturation, de perméabilité magnétique infinie,
- les lignes de champ sont parfaitement canalisées et
- le champ magnétique est de norme uniforme dans le circuit magnétique.

#flashcard(
    recto: "Hypothèses du transformateur idéal",
    verso: "Pertes cuivres et fer négligées, matériaux doux, hors saturation, de perméabilité infinie, lignes de champ parfaitement canalisées, champ magnétique de norme uniforme.",
)

#schéma(titre: "Schéma électrique du transformateur idéal")[#box(height: 3cm)]

== Loi de transformation des tensions

#encadré(
    titre: "Loi de transformation des tensions",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "En régime alternatif.",
        "Pour un transformateur idéal.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("v_1", "v_2", "m", "N_1", "N_2")),
)[
    $ (v_2(t))/(v_1(t))=m $
]

#flashcard(
    recto: "Rapport de transformation sur les tensions",
    verso: "$ (v_2(t))/(v_1(t))=m $",
)

#application[
    Quel rapport de transformation doit avoir un transformateur permettant d'alimenter un moteur $#qty("12", "V") _"eff"$ à partir du secteur ?
]

Si $m > 1$, le transformateur est dit "élévateur de tension". Si $m < 1$, le transformateur est dit "abaisseur de tension".

== Loi de transformation des courants

#encadré(
    titre: "Loi de transformation des courants",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "Pour un transformateur idéal.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("i_1", "i_2", "m", "N_1", "N_2")),
)[
    $ (i_2(t))/(i_1(t))=(-1)/m $
]

#flashcard(
    recto: "Rapport de transformation sur les courants",
    verso: "$ (i_2(t))/(i_1(t))=(-1)/m $",
)

#question-de-colle(
    "Dans le cadre du transformateur idéal, démontrer les lois de transformation sur les tensions et sur les courants.",
)

#application[
    Un transformateur permet de passer du réseau moyenne tension à #qty("25", "kV") au réseau basse tension #qty("600", "V"). Le courant efficace au secondaire est de #qty("75", "A"). Déterminer le courant efficace au primaire.
]

== Transfert de puissance entre primaire et secondaire

#encadré(
    titre: "Transfert de puissance",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "En régime alternatif.",
        "Pour un transformateur idéal.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("p_1", "p_2")),
)[
    $ p_1(t)=p_2(t) $
]
Il n'y a pas de perte ni de stockage d'énergie électromagnétique.

#question-de-colle(
    "Citer les hypothèses du transformateur idéal et montrer que pour un transformateur idéal, il n'y a pas de pertes ni de stockage d'énergie.",
)

== Transfert d'impédance
Afin de simplifier l'analyse des circuits comportant un transformateur, il est possible de déterminer un schéma équivalent ne comportant pas de transformateur.

#encadré(
    titre: "Primaire vu du secondaire",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "En régime alternatif.",
        "Pour un transformateur idéal.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("m", "N_1", "N_2")),
)[
    Les impédances sont multipliées par $m^2$.

    Les tensions sont multipliées par $m$.

    Les courants sont multipliées par $1/m$.
]

#flashcard(
    recto: "Primaire vu du secondaire",
    verso: "Les impédances sont multipliées par $m^2$.\nLes tensions sont multipliées par $m$.\nLes courants sont multipliées par $1/m$.",
)

#application[Déterminer la tension aux bornes de la résistance $R_2$ dans le montage ci-dessous en fonction de $m$, $e$, $R_1$ et $R_2$.
    #figure[
        #zap.circuit({
            import zap: *

            transformateur("transfo", (0, 0))
            vsource("e", (-4, -1), (-4, 1), u: $e$)
            resistor("R1", "transfo.P+", "e.out", label: $R_1$)
            wire("e.in", "transfo.P-")
            resistor("R2", (2, 1), (2, -1), label: $R_2$)
            wire("transfo.S+", "R2.in")
            wire("transfo.S-", "R2.out")
        })
    ]]

#encadré(
    titre: "Secondaire vu du primaire",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "En régime alternatif.",
        "Pour un transformateur idéal.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("m", "N_1", "N_2")),
)[
    Les impédances sont divisées par $m^2$.

    Les tensions sont divisées par $m$.

    Les courants sont divisées par $1/m$.
]

#flashcard(
    recto: "Ramener le secondaire au primaire",
    verso: "Les impédances sont divisées par $m^2$.\nLes tensions sont divisées par $m$.\nLes courants sont divisées par $1/m$.",
)

#question-de-colle(
    "Démontrer les schémas équivalents pour ramener le primaire au secondaire et le primaire au secondaire.",
)

#application[Déterminer le courant au primaire dans le montage ci-dessous en fonction de $e$, $m$, $R_1$ et $R_2$.
    #figure[
        #zap.circuit({
            import zap: *

            transformateur("transfo", (0, 0))
            vsource("e", (-4, -1), (-4, 1), u: $e$)
            resistor("R1", "e.out", "transfo.P+", label: $R_1$, i: $i$)
            wire("e.in", "transfo.P-")
            resistor("R2", (2, 1), (2, -1), label: $R_2$)
            wire("transfo.S+", "R2.in")
            wire("transfo.S-", "R2.out")
        })
    ]
]

= Le transformateur réel
Un transformateur réel comporte des pertes cuivres dues à l'effet Joule dans les fils qui constituent les enroulements primaire et secondaire. Pour limiter les pertes cuivre, on utilise un bon conducteur électrique (quasiment toujours du cuivre), de section suffisamment grande et aussi courts que possible.

Un transformateur réel comporte des pertes par hystérésis. Pour les limiter, les transformateurs sont réalisés avec des matériaux ferromagnétiques doux.

Un transformateur réel comporte des pertes par courants de Foucault. Pour les limiter, le circuit magnétique est feuilleté.

#schéma(titre: "Feuilletage du transformateur réel")[#box(height: 3cm)]

Pertes par hystérésis et pertes par courant de Foucault sont regroupées sous le terme "pertes fer".

#question-de-colle("Citer les types de pertes existantes dans unn transformateur réel et des moyens pour les limiter.")

= Applications du transformateur
== Isolement
Le transformateur d'isolement est un transformateur dont le rapport de transformation $m$ est égal à $1$.

Le transformateur d'isolement sert à isoler électriquement deux parties d'un circuit électrique tout en ayant des tensions identiques au primaire et au secondaire.

#exemple[
    On souhaite afficher sur un oscilloscope la tension et le courant dans un moteur. #schéma[#box(height: 3cm)]
]

== Transport du courant à haute tension
Afin de limiter les pertes par effet Joule lors du transport, on utilise une tension aussi élevée que possible. Pour ce faite, un transformateur augment la tension en sortie de centrale de production et un transformateur abaisse la tension avant de la distribuer au client.

#question-de-colle("Démontrer l'expression de la puissance perdue lors du transport du courant (pertes en ligne) et expliquer comment les réduire.")

#exemple[Le réseau Très Haute Tension qui transporte le courant sur des longues distance a une tension de #qty("400","kV").]

#application[Par combien divise-t-on les pertes par effet Joule dans les cables en utilisant une tension de #qty("20","kV") (ligne moyenne tension) plutôt que de #qty("230","V") ?]
