#import "@local/prepa:0.1.1": *

#show: cours.with(infos: yaml("infos.yml"))

#let grandeurs = (
    "I": (signification: "le courant électrique", unité: unit("A")),
    "Q": (signification: "la charge électrique", unité: unit("C")),
    "t": (signification: "le temps", unité: unit("s")),
    "n": (signification: "la densité particulaire", unité: unit("/m^3")),
    "delta N": (
        signification: "le nombre de particules dans un système mésoscopique autour de $M$",
        unité: "sans unité",
    ),
    "delta V": (signification: "le volume du système mésoscopique autour de $M$", unité: unit("m^3")),
    "rho": (signification: "la densité volumique de charge", unité: unit("C/m^3")),
    "delta Q": (signification: "la charge dans un système mésoscopique autour de $M$", unité: unit("C")),
    "q": (signification: "la charge d'un porteur de charge", unité: unit("C")),
    "va(j_\"élec\")": (signification: "le vecteur densité de courant électrique", unité: unit("A/m^2")),
    "va(dd(S))": (signification: "une surface infinitésimale", unité: unit("m^2")),
    "delta I": (signification: "le courant traversant une surface infinitésimale", unité: unit("A")),
    "n_\"libre\"": (signification: "la densité particulaire de porteurs de charge libres", unité: unit("/m^3")),
    "rho_\"libre\"": (
        signification: "la densité volumique de charge des porteurs de charge libres",
        unité: unit("C/m^3"),
    ),
    "v": (signification: "la vitesse *moyenne* des porteurs de charge libres", unité: unit("m/s")),
    "F": (
        signification: "la force modélisant les interactions entre les électrons et le métal dans le modèle de Drude",
        unité: unit("N"),
    ),
    "m_e": (signification: "la masse d'un électron", unité: unit("kg")),
    "tau": (
        signification: "la durée moyenne entre deux collisions entre un électron et un atome du réseau cristallin",
        unité: unit("s"),
    ),
    "va(E)": (signification: "le champ électrique", unité: unit("V/m")),
    "gamma": (signification: "la conductivité électrique", unité: unit("S/m")),
    "e": (signification: "la charge élémentaire", unité: unit("C")),
    "R": (signification: "la résistance électrique", unité: unit("O")),
    "L": (signification: "la longueur du conducteur", unité: unit("m")),
    "S": (signification: "la section du conducteur", unité: unit("m^2")),
    "p_\"vol\"": (signification: "la densité volumique de puissance dissipée par effet Joule", unité: unit("W/m^3")),
)

= Différentes descriptions de la charge électrique
== Description macroscopique (OdG : #unit("cm"))
Certains objets peuvent posséder une charge électrique. La charge électrique se mesure en Coulomb (C).

#exemple[
    Les armatures des condensateurs possèdent une charge électrique.
]
Dans un milieu conducteur, un courant électrique peut apparaitre. Le courant électrique se mesure en Ampère (A).

Le courant électrique est le débit de charge passant à travers une section.

#encadré(
    titre: "Courant électrique",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("I", "Q", "t")),
)[
    $ I=dv(Q, t) $
]

== Description microscopique (OdG : #qty("e-10", "m"))
Au niveau microscopique, la charge est portée par des particules chargées appelées "porteurs de charge".

#exemple[
    Électrons, protons, ions dans une solution, positons, noyau d'atome, trous dans les semi-conducteurs.
]
Ces particules peuvent être fixes (comme les noyaux d'atomes dans un cristal) ou libres (comme certains électrons dans les métaux.)

Les charges libres sont toujours animées d'un mouvement d'agitation. Le mouvement d'agitation peut être accompagné d'un mouvement global.

#schéma(titre: "Agitation et mouvement global", hauteur: 3cm)

== Description mésoscopique
Une troisième échelle, intermédiaire, est nécessaire pour
- décrire des systèmes pour lesquels la charge et le courant ne sont pas les mêmes partout,
- passer des propriétés microscopiques des matériaux à leurs propriétés macroscopiques.

L'échelle mésoscopique est très petite devant l'échelle macroscopique.

L'échelle mésoscopique est très grande devant l'échelle microscopique. Un système mésoscopique contient un grand nombre de porteurs de charge.

#schéma(titre: "Système mésoscopique", hauteur: 3cm)
Il y a constamment des particules qui rentrent et qui sortent du système mésoscopique. Comme le système est très grand, les fluctuations dues à l'agitation sont négligeables.

Le système mésoscopique permet de définir des grandeurs locales.

#encadré(
    titre: "Densité particulaire",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("n", "delta N", "delta V")),
)[
    $ n=dv(N, V, d: delta) $
]


#encadré(
    titre: "Densité volumique de charge",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("rho", "delta Q", "delta V")),
)[
    $ rho=dv(Q, V, d: delta) $
]

#encadré(
    titre: "Densité volumique de charge et densité particulaire",
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("rho", "n", "q")),
    hypothèses: (
        "Tous les porteurs de charge sont identiques",
    ),
)[
    $ rho=n q $
]

Lorsqu'il y a plusieurs types de porteurs de charge, il faut sommer les contributions de chacun : $rho=sum_"types de porteurs de charge" n_i q_i$.

#application[
    Le fer $isotope("Fe", z: 26)$ a pour masse volumique $rho=#qty("7.9", "g/cm^3")$ et une masse molaire $M=#qty("56", "g/mol")$. Calculer la densité particulaire de noyaux de fer, la densité particulaire d'électrons et enfin la densité volumique de charge.
]

#flashcard(
    recto: "Relation entre la densité volumique de charge $rho$ et la densité particulaire $n$.",
    verso: "$rho=n q$ ou $rho=sum_\"porteurs de charge\" n_i q_i$",
)

= Déplacement global de charge
== Le vecteur densité de courant électrique
Pour rendre compte du déplacement global des porteurs de charge, on définit le vecteur densité de courant électrique.

#encadré(
    titre: "Vecteur densité de courant électrique",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("va(j_\"élec\")", "delta I", "va(dd(S))")),
)[
    $ delta I = va(j_"élec") dot va(dd(S)) $
]
#flashcard(
    recto: "Courant traversant une surface infinitésimale",
    verso: "$delta I = va(j_\"élec\") dot va(dd(S))$",
)

#encadré(
    titre: "Vecteur densité de courant électrique",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "Tous les porteurs de charge libres sont identiques",
    ),
    grandeurs: sub-dictionary(grandeurs, ("va(j_\"élec\")", "n_\"libre\"", "q", "v", "rho_\"libre\"")),
)[
    $ va(j_"élec") = n_"libre" q va(v) = rho_"libre" va(v) $
]

Lorsqu'il y a plusieurs types de porteurs de charge, il faut sommer les contributions de chacun : $va(j_"élec")= sum_"types de porteurs de charge"n_i q_i va(v)_i= sum_"types de porteurs de charge" rho_i va(v)_i$.

#flashcard(
    recto: "Vecteur densité de courant électrique.",
    verso: "$va(j_\"élec\") = rho_\"libre\" va(v) = n_\"libre\" q va(v)$",
)

== Grandeurs locales et globales
Le vecteur densité de courant électrique (propriété locale) peut être reliée au courant électrique (propriété globale).

#encadré(
    titre: "Courant électrique",
    grandeurs: sub-dictionary(grandeurs, ("I", "va(j_\"élec\")")),
)[
    $ I=integral.double_S dd(I, d: delta) = integral.double_S va(j_"élec") dot va(dd(S)) $
]

#flashcard(
    recto: "Courant traversant une surface finie",
    verso: "$I = integral.double_S va(j_\"élec\") dot va(dd(S))$",
)
#question-de-colle(
    "Relier le courant traversant une surface infinitésimale, puis finie, au vecteur densité de courant.",
)

== Conservation de la charge
La charge est une grandeur conservative. La variation de charge est uniquement due à un transfert de charge, c'est-à-dire un courant électrique.

#encadré(
    titre: "Équation locale de conservation de la charge",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "L'équation, démontrée en coordonnées cartésiennes dans un cadre unidimensionnel, est généralisable en trois dimensions.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("rho", "va(j_\"élec\")")),
)[
    $ pdv(rho, t) = -div(va(j_"élec")) $
]

#application[
    On se place en coordonnées cylindriques et on suppose que $va(j_"élec") = j_"élec"(r) er$. Montrer que l'équation locale de conservation de la charge s'écrit : $ pdv(rho,t) = -1/r pdv(r j_"élec", r) $
]

#application[
    On se place en coordonnées sphériques et on suppose que $va(j_"élec") = j_"élec"(r) er$. Montrer que l'équation locale de conservation de la charge s'écrit : $ pdv(rho,t) = -1/r^2 pdv(r^2 j_"élec", r) $
]

L'équation locale de conservation de la charge peut également s'obtenir à partir des équations de Maxwell.

#application[
    Démontrer l'équation locale de conservation de la charge en utilisant les équations de Maxwell-Gauss et de Maxwell-Ampère.
]

#flashcard(
    recto: "Équation locale de conservation de la charge.",
    verso: "$ pdv(rho,t) = -div(va(j_\"élec\"))$",
)
#question-de-colle(
    "Établir l'équation locale de conservation de la charge grâce à un bilan à 1D en coordonnées cartésiennes et généraliser à 3D. Retrouver cette équation à partir des équations de Maxwell.",
)

== Équation de conservation de la charge en régime stationnaire
En régime stationnaire, l'équation de conservation de la charge s'écrit $div va(j_"élec")=0$, le vecteur densité de courant électrique est donc à flux conservatif en régime stationnaire.

#application[
    Démontrer que le vecteur densité de courant électrique est à flux conservatif en régime stationnaire.
]
#flashcard(
    recto: "Que peut-on dire de $va(j_\"élec\")$ en régime stationnaire ?",
    verso: "Il est à flux conservatif : $div va(j_\"élec\")=0$",
)
#question-de-colle(
    "Montrer que $va(j_\"élec\")$ est à flux conservatif en régime stationnaire.",
)

#application[
    Démontrer la loi des nœuds en régime stationnaire.
]

= Courant dans un métal : le modèle de Drude
== Description microscopique d'un métal
Les matériaux conducteurs d'électricité sont nombreux.
#exemple[
    Les solutions ioniques, les plasmas, les semi-conducteurs, les métaux (cuivre, or, acier, bronze, ...) sont des milieux conducteurs.
]
On s'intéressera dans la suite uniquement aux corps simples#footnote[Un corps simple est une substance chimique constituée d'un seul type d'atome.] cristallins, métaux et semi-conducteurs. Les résultats pourront être généralisés à tout métal mais *pas* à tout conducteur, semi-conducteur ou solution ionique.

Un métal est un cristal ionique dans lequel certains électrons de valence sont libres de se déplacer. Les électrons libres de se déplacer sont appelés électrons de conduction et forment la "mer d'électrons" qui transporte la charge macroscopiquement.

Le modèle de Drude est un modèle classique du déplacement des électrons dans un cristal. Dans le modèle de Drude, les électrons de conduction ont des mouvements désordonnés dans le réseau cristallin du fait des collisions avec les atomes du réseau. La vitesse de l'électron est aléatoire après la collision et toutes les directions sont équiprobables.

En l'absence de champ électrique, la vitesse moyenne des électrons est nulle. En présence d'un champ électrique, les électrons se déplacent globalement dans le sens opposé au champ électrique.

#schéma(titre: "Mouvement désordonné des électrons de conduction à l'échelle microscopique", hauteur: 3cm)

== Conducteur soumis à un champ électrique
Les interactions entre électrons et atomes du réseau cristallin sont modélisées par une force de frottement fluide.

#encadré(
    titre: "Force modélisant les interactions entre les électrons et le métal dans le modèle de Drude",
    connaitre: true,
    hypothèses: (
        "Le conducteur est un métal ou un semi-conducteur cristallin.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("F", "m_e", "tau", "v")),
)[
    $ va(F)= -m_e/tau va(v) $
]
#application[
    On s'intéresse à un électron d'un métal dans un champ électrique. Démontrer que la vitesse moyenne d'un électron soumis uniquement à la force de Lorentz et subissant des chocs avec le réseau cristallin est la même que celle d'un électron soumis à la force de Lorentz et à la force de frottement fluide ci-dessous.
]

#application[
    Déterminer la vitesse limite atteinte par un électron dans un métal plongé dans un champ électrique.
]

La durée du régime transitoire est très courte. On considère que les électrons se déplacent toujours à leur vitesse limite.

#flashcard(
    recto: "Force modélisant les interactions entre les électrons et le métal dans le modèle de Drude",
    verso: "$ va(F)=-m_e/tau va(v) $",
)

#encadré(
    titre: "Loi d'Ohm locale",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "Le conducteur est un métal ou un semi-conducteur cristallin.",
        "La durée moyenne entre deux chocs est négligeable devant la durée caractéristique de variation du champ électrique.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("va(j_\"élec\")", "va(E)", "gamma", "n_\"libre\"", "e", "m_e", "tau")),
)[
    $ va(j_"élec")=gamma va(E) $
    avec $gamma=(n_"libre" e^2)/m_e tau$
]

La résistivité est l'inverse de la conductivité. La résistivité se mesure en #unit("O m").

#exemple[La conductivité du cuivre pur est de #qty("6e7", "S/m").]

#application[
    Chaque atome de cuivre apporte un électron de conduction. On donne $e=#qty("1.6e-19","C")$, $m_e=#qty("9.1e-31","kg")$, $mu_#ce("Cu")=#qty("8.96","g/cm^3")$, $M_#ce("Cu")=#qty("63.5","g/mol")$.

    Calculer la durée moyenne entre deux chocs pour le cuivre pur. Justifier de l'hypothèse selon laquelle le régime permanent est très rapidement atteint.
]

#question-de-colle(
    "Établir la loi d'Ohm locale dans le cadre du modèle de Drude.",
)
#flashcard(
    recto: "Loi d'Ohm locale",
    verso: "$va(j_\"élec\")= gamma va(E)$",
)
#flashcard(
    recto: "Ordre de grandeur de la conductivité électrique du cuivre.",
    verso: "$#qty(\"6e7\",\"S/m\")$",
)

== Lien avec la loi d'Ohm intégrale
La loi d'Ohm est une conséquence de la loi d'Ohm locale.

#encadré(
    titre: "Résistance d'un barreau cylindrique",
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("R", "L", "gamma", "S")),
    hypothèses: (
        "Le conducteur est un métal ou un semi-conducteur cristallin.",
        "La durée moyenne entre deux chocs est négligeable devant la durée caractéristique de variation du champ électrique.",
        "Le conducteur est cylindrique.",
        "Le champ électrique est uniforme le long du conducteur.",
    ),
)[
    $ R = L/(gamma S) $
]

#application[
    Calculer la résistance d'un conducteur en cuivre utilisé en TP (#qty("1", "m") de long et #qty("1","mm") de diamètre).
]


#question-de-colle("Établir la résistance d'un barreau cylindrique à partir de la loi d'Ohm locale.")

#flashcard(
    recto: "Résistance électrique d'un barreau cylindrique",
    verso: "$R=L/(gamma S)$",
)

== Aspect énergétique
La puissance reçue par l'électron de la part du champ électrique est dissipée sous forme de chaleur à chaque choc avec le réseau cristallin. C'est la source de l'effet Joule.

#encadré(
    titre: "Densité volumique de puissance dissipée par effet Joule",
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("p_\"vol\"", "va(j_\"élec\")", "va(E)"))
)[
    $ p_"vol"= va(j_"élec") dot va(E) $
]

#question-de-colle(
    "Établir l'expression de la densité volumique de puissance cédée aux porteurs de charge par le champ électrique."
)
#flashcard(
    recto: "Densité volumique de puissance cédée aux porteurs de charge par le champ électrique",
    verso: "$ p_\"vol\"= va(j_\"élec\") dot va(E) $"
)

#application[
    Retrouver l'expression de la puissance dissipée par effet Joule dans un barreau cylindrique de section $S$ et de longueur $L$ à partir de la formule ci-avant.
]

== Discussion de la validité du modèle
#application[
    La vitesse typique des électrons dans un métal est de #qty("e6","m/s"). Calculer le libre parcours moyen d'un électron. Le comparer à la distance interatomique dans un cristal.
]

Il semble peu probable qu'un électron puisse voyager aussi longtemps dans le cristal sans subir de choc.

Le modèle de Drude explique bien la conduction électrique dans les métaux dans les conditions usuelles. Toutefois, le modèle de Drude possède des limites.

Un modèle plus précis devrait prendre en compte l'interaction entre l'électron et le réseau cristallin de façon quantique.
