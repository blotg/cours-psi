#import "@local/prepa:0.1.1": *

#show: cours.with(infos: yaml("infos.yml"))

#let grandeurs = (
    "delta m_1": (signification: "la masse rentrant dans le système ouvert entre $t$ et $t+dd(t)$", unité: unit("kg")),
    "delta m_2": (signification: "la masse sortant du système ouvert entre $t$ et $t+dd(t)$", unité: unit("kg")),
    "Delta": (signification: "la différence entre la sortie et l'entrée"),
    "h": (signification: "l'enthalpie massique", unité: unit("J/kg")),
    "e_c": (signification: "l'énergie cinétique massique", unité: unit("J/kg")),
    "e_p": (signification: "l'énergie potentielle massique", unité: unit("J/kg")),
    "w_u": (signification: "le travail utile massique reçu par le système ouvert", unité: unit("J/kg")),
    "q": (signification: "la chaleur massique reçue par le système ouvert", unité: unit("J/kg")),
    "D_m": (signification: "le débit massique", unité: unit("kg/s")),
    "P_u": (signification: "la puissance utile reçue par le système ouvert", unité: unit("W")),
    "P_\"th\"": (signification: "la puissance thermique reçue par le système ouvert", unité: unit("W")),
    "s": (signification: "l'entropie massique", unité: unit("J/K/kg")),
    "s_e": (signification: "l'entropie massique échangée avec l'extérieur", unité: unit("J/K/kg")),
    "s_c": (signification: "l'entropie massique créée à l'intérieur du système ouvert", unité: unit("J/K/kg")),
    "P": (signification: "la pression", unité: unit("Pa")),
    "mu": (signification: "la masse volumique", unité: unit("kg/m^3")),
    "g": (signification: "l'accélération de la pesanteur", unité: unit("m/s^2")),
    "z": (signification: "l'altitude (axe ascendant)", unité: unit("m")),
    "v": (signification: "le champ de vitesse", unité: unit("m/s")),
    "va(p)": (signification: "la quantité de mouvement du système", unité: unit("kg.m/s")),
    "va(F)_\"ext\"": (signification: "les forces extérieures appliquées au système", unité: unit("N")),
    "va(L)_O": (signification: "le moment cinétique par rapport au point O", unité: unit("kg.m^2/s")),
    "va(M)_O(va(F))_\"ext\"": (
        signification: "le moment des forces extérieures par rapport au point O",
        unité: unit("N.m"),
    ),
    "O": (signification: "un point fixe", unité: unit("m")),
)

= Du système ouvert au système fermé
== Système ouvert
Un système ouvert est un système échangeant de la matière avec l'extérieur.

#exemple[Un lac, la mer, la vapeur d'eau dans une machine à vapeur ...]

Le *volume de contrôle* est le volume occupé par un système ouvert. La *surface de contrôle* est la surface qui délimite le volume de contrôle.

La plupart des théorèmes de physique connus ne s'appliquent pas aux systèmes ouverts.

== Système fermé
Un système fermé est un système n'échangeant pas de matière avec l'extérieur.

#exemple[TRC, TMC, TEC, TEM, TPC, 1er et 2nd principes, ne s'appliquent qu'à des systèmes fermés.]

#exemple[Une solution dans un bécher, l'eau dans le circuit primaire d'une centrale nucléaire, ...]

== Système fermé à partir du système ouvert
Lorsqu'un système ouvert est traversé par un écoulement unidimensionnel, il est possible de définir un système fermé.

#schéma(titre: "Système fermé à partir du système ouvert", hauteur: 4cm)

#encadré(
    titre: "Masses rentrante et sortante",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [L'écoulement est unidimensionnel.],
        [L'écoulement est stationnaire.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("delta m_1", "delta m_2")),
)[
    $ delta m_1 = delta m_2 $
]

= Thermodynamique sur des systèmes ouverts
== Premier principe de la thermodynamique pour un système ouvert en écoulement stationnaire#footnote[Le premier principe de la thermodynamique sur un système ouvert en écoulement stationnaire est aussi appelé premier principe industriel.]

#encadré(
    titre: "Premier principe industriel",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [L'écoulement est unidimensionnel.],
        [L'écoulement est stationnaire.],
        [Le système ouvert est immobile et indéformable.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("Delta", "h", "e_c", "e_p", "w_u", "q")),
)[
    $ Delta (h + e_c + e_p) = w_u+q $
]

#question-de-colle(
    "Démontrer le premier principe industriel puis en déduire une formulation faisant apparaitre des puissances.",
)
#flashcard(
    recto: "Premier principe industriel",
    verso: "$ Delta (h + e_c + e_p) = w_u+q $",
)

Pour les applications industrielles, il est souvent plus pratique de travailler avec des relations sur les puissances.

#encadré(
    titre: "Premier principe industriel en termes de puissance",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [L'écoulement est unidimensionnel.],
        [L'écoulement est stationnaire.],
        [Le système ouvert est immobile et indéformable.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("D_m", "Delta", "h", "e_c", "e_p", "P_u", "P_\"th\"")),
)[
    $ D_m Delta (h + e_c + e_p) = P_u+P_"th" $
]

#flashcard(
    recto: "Premier principe industriel en termes de puissance",
    verso: "$D_m Delta (h + e_c + e_p) = P_u+P_\"th\"$",
)

#application[
    Un panneau solaire thermique reçoit une puissance de #qty("1026", "W") et est parcouru par de l'eau avec un débit #qty("60", "L/h"). L'eau (de capacité thermique massique $c=qty("4.18e3", "J/K/kg")$) rentre avec une température #qty("35", "Celsius") et circule lentement et horizontalement dans le panneau. Avec quelle température sort-elle du panneau ?
]

== Second principe de la thermodynamique

#encadré(
    titre: "Second principe de la thermodynamique pour un système ouvert en écoulement stationnaire",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [L'écoulement est unidimensionnel.],
        [L'écoulement est stationnaire.],
        [Le système ouvert est immobile et indéformable.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("Delta", "s", "s_e", "s_c")),
)[
    $ Delta (s) = s_e+s_c $
]

#question-de-colle(
    "Établir le second principe de la thermodynamique pour un système ouvert en écoulement unidimensionnel et stationnaire.",
)
#flashcard(
    recto: "Second principe de la thermodynamique pour un système ouvert",
    verso: "$ Delta (s) = s_e+s_c $",
)

= Conservation de l'énergie dans un écoulement parfait
== Le modèle de l'écoulement parfait
Un écoulement parfait est un écoulement dans lequel il n'existe aucun phénomène de diffusion (thermique, de quantité de mouvement, ...).

Dans un écoulement parfait, l'évolution d'une particule de fluide est adiabatique, réversible. Dans un écoulement parfait, les particules de fluides ne sont soumises à aucune force de viscosité.

Le modèle de l'écoulement parfait donne des résultats conformes à l'expérience lorsque le nombre de Reynolds est grand et hors de la couche limite.

#encadré(
    titre: "Écoulement parfait et incompressible",
    connaitre: true,
    savoir-faire: false,
    hypothèses: (
        [L'écoulement est parfait.],
        [L'écoulement est incompressible.],
    ),
    grandeurs: (),
)[
    La puissance des actions intérieures est nulle.
]

== Relation de Bernoulli

#encadré(
    titre: "Relation de Bernoulli",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [L'écoulement est parfait.],
        [L'écoulement est stationnaire.],
        [L'écoulement est incompressible.],
        [L'écoulement est homogène.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("P", "mu", "g", "z", "v")),
)[
    La quantité $P + mu g z+ 1/2 mu v^2$ est constante le long de chaque ligne de courant.
]

#flashcard(
    recto: "Relation de Bernoulli",
    verso: "La quantité $P + mu g z+ 1/2 mu v^2$ est constante le long de chaque ligne de courant.",
)
#flashcard(
    recto: "Hypothèses de la relation de Bernoulli",
    verso: "L'écoulement est Parfait, Stationnaire, Incompressible et Homogène.",
)
#question-de-colle(
    "Établir la relation de Bernoulli. Note : $u_e=u_s$ est admis jusqu'au chapitre \"Second principe appliqué aux transformations chimiques\".",
)

La relation de Bernoulli traduit la conservation de l'énergie mécanique volumique.

#application[
    Une bassine de #qty("20", "cm") de haut et remplie d'eau est percée d'un trou de #qty("1", "cm") de diamètre. L'écoulement est supposé parfait, stationnaire, incompressible et homogène. Quel est le débit d'eau passant par le trou ?
]

== Effet Venturi
Dans un écoulement horizontal, une augmentation de la vitesse s'accompagne d'une diminution de la pression. Cet effet s'appelle effet Venturi.

#application[
    Relier la différence de pression au débit pour un débitmètre de Venturi. On suppose l'écoulement parfait, stationnaire, incompressible, homogène et horizontal.
    #schéma(hauteur: 3cm)
]

#application[
    Relier la différence de pression à la vitesse de l'écoulement pour un tube de Pitot. On suppose l'écoulement parfait, stationnaire, incompressible, homogène et horizontal.
    #schéma(hauteur: 3cm)
]

= Mécanique sur des systèmes ouverts
== Bilan de quantité de mouvement
La quantité de mouvement est une grandeur conservative. Une force est un débit de quantité de mouvement d'un système vers un autre.

Il est possible de faire des bilans de quantités de mouvement en écrivant le principe fondamental de la dynamique comme une variation de quantité de mouvement.

#encadré(
    titre: "Formulation du PDF en tant que conservation de quantité de mouvement",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [Le système est fermé.],
        [Le référentiel est galiléen.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("va(p)", "va(F)_\"ext\"")),
)[
    $ va(p)(t+dd(t))-va(p)(t)=sum va(F)_"ext" dd(t) $
]

#flashcard(
    recto: "PDF formulé sous forme de conservation de quantité de mouvement",
    verso: "$ va(p)(t+dd(t))-va(p)(t)=sum va(F)_\"ext\" dd(t) $",
)

#application[
    La fusée Ariane se propulse en éjectant des gaz vers le bas avec un débit de #qty("10", "t/s") et une vitesse de #qty("4000", "m/s"). Ariane pèse #qty("750", "t") dont #qty("620", "t") de carburant. Exprimer la vitesse de la fusée au cours du temps en supposant qu'elle part avec une vitesse nulle au décollage. Quelle est la vitesse de la fusée lorsqu'elle a consommé tout son carburant ?
]

#question-de-colle(
    "Traiter l'exemple de la fusée : exprimer la vitesse ne fonction du temps, du débit massique et de la vitesse d'éjection des gaz en sortie de tuyère.",
)

== Bilan de moment cinétique
Le moment cinétique est une grandeur conservative. Le moment d'une force est un débit de moment cinétique d'un système vers un autre.

Il est possible de faire des bilans de moment cinétique en écrivant le théorème du moment cinétique comme une variation de moment cinétique.

#encadré(
    titre: "Formulation du TMC en tant que conservation du moment cinétique",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [Le système est fermé.],
        [Le référentiel est galiléen.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("va(L)_O", "va(M)_O(va(F))_\"ext\"", "O")),
)[
    $ va(L)_O(t+dd(t))-va(L)_O(t) = sum va(M)_O(va(F))_"ext" dd(t) $
]

#flashcard(
    recto: "TMC formulé sous forme de conservation du moment cinétique",
    verso: "$ va(L)_O(t+dd(t))-va(L)_O(t) = sum va(M)_O(va(F))_\"ext\" dd(t) $",
)

#application[
    Les turbines Pelton sont utilisées pour produire de l'électricité dans les centrales hydroélectriques. Elles permettent de convertir l'énergie cinétique de l'eau en travail mécanique avec un bon rendement (de l'ordre de #qty("90", "%")) lorsque les débits sont faibles mais que la pression est importante. Elles sont constituées de plusieurs augets fixées sur une roue. L'eau arrive avec une vitesse $v$ et frappe les augets puis retombe sans vitesse. Relier le couple exercé par la turbine sur l'alternateur au débit massique d'eau $D_m$, à la vitesse d'arrivée de l'eau $v$ et au rayon $R$ de la roue.

    #grid(
        columns: (1fr, 1fr),
        align: horizon,
        figure(image("images/Pelton 1.jpg", width: 100%)),
        figure(
            canvas({
                import draw: *
                let R = 2
                let r = 0.2
                merge-path(
                    {
                        line((-4, -R - r), (-3, -R - r), (-2, -R - 1.7 * r))
                        line((-2, -R - 1.7 * r), (0, -R - 1.7 * r))
                        arc((0, -R - 1.7 * r), start: -90deg, delta: 180deg, radius: 0.7 * r)
                        line((0, -R - 0.3 * r), (0, -R))
                        arc((0, -R), start: 90deg, delta: -180deg, radius: r)
                        arc((0, -R - 2 * r), start: 90deg, delta: -180deg, radius: r)
                        line((0, -R - 4 * r), (0, -R - 3.7 * r))
                        arc((0, -R - 3.7 * r), start: -90deg, delta: 180deg, radius: 0.7 * r)
                        line((0, -R - 2.3 * r), (-1, -R - 2.3 * r))
                        line((-2, -R - 2.3 * r), (-3, -R - 3 * r), (-4, -R - 3 * r))
                    },
                    fill: black.lighten(70%),
                    stroke: none,
                )
                circle((0, 0), radius: R)
                for theta in range(0, 360, step: 45) {
                    arc((theta * 1deg, R), start: 180deg + theta * 1deg, delta: -180deg, radius: r)
                    arc((theta * 1deg, R + 2 * r), start: 180deg + theta * 1deg, delta: -180deg, radius: r)
                }
                circle((0,0), radius: .1, fill: black)
                line((-4, -R - r), (-3, -R - r), (-2, -R - 1.7 * r))
                line((-4, -R - 3 * r), (-3, -R - 3 * r), (-2, -R - 2.3 * r))
                line((-1.5, -R - 2 * r), (rel: (1, 0)), mark: (end: ">>", fill: black), name: "v")
                content("v.mid", $va(v)$, anchor: "south", padding: .4em)
            }),
        ),
    )
]
