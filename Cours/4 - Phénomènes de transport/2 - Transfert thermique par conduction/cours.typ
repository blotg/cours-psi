#import "@local/prepa:0.1.1": *

#show: cours.with(infos: yaml("infos.yml"))

#let grandeurs = (
    "dd(E)": (signification: "$=dd(E_c) + dd(U)$ la variation d'énergie totale", unité: unit("J")),
    "dd(E_c)": (signification: "la variation d'énergie mécanique macroscopique", unité: unit("J")),
    "dd(U)": (signification: "la variation d'énergie interne", unité: unit("J")),
    "delta W": (signification: "le travail reçu", unité: unit("J")),
    "delta Q": (signification: "la chaleur reçue", unité: unit("J")),
    "cal(S)": (signification: "l'entropie", unité: unit("J/K")),
    "delta cal(S)_e": (signification: "$=(delta Q)/T_\"ext\"$l'entropie échangée", unité: unit("J/K")),
    "delta cal(S)_c": (signification: "$>0$ l'entropie créée", unité: unit("J/K")),
    "T_\"ext\"": (signification: "la température extérieure", unité: unit("K")),
    "dd(S)": (signification: "la surface élémentaire", unité: unit("m^2")),
    "va(j_Q)": (signification: "le vecteur densité de courant thermique", unité: unit("J/m^2/s")),
    "delta Phi": (signification: "la puissance traversant une surface élémentaire", unité: unit("W")),
    "Phi": (signification: "la puissance traversant une surface", unité: unit("W")),
    "lambda": (signification: "la conductivité thermique", unité: unit("W/m/K")),
    "T": (signification: "la température", unité: unit("K")),
    "u": (signification: "l'énergie interne volumique", unité: unit("J/m^3")),
    "cal(P)_V": (signification: "la puissance volumique convertie en chaleur", unité: unit("W/m^3")),
    "D_\"th\"": (signification: "$=lambda/(mu c_V)$ la diffusivité thermique", unité: unit("m^2/s")),
    "mu": (signification: "la masse volumique", unité: unit("kg/m^3")),
    "c_V": (signification: "la capacité thermique massique à volume constant", unité: unit("J/kg/K")),
    "f": (signification: "une fonction de $x$ quelconque"),
    "F": (signification: "un ordre de grandeurs des variations de $f$"),
    "l": (signification: "un ordre de grandeurs de la distance", unité: unit("m")),
    "tau": (signification: "le temps caractéristique de diffusion thermique", unité: unit("s")),
    "cal(T)": (signification: "la durée caractéristique de variation de la température", unité: unit("s")),
    "R_\"th\"": (signification: "la résistance thermique", unité: unit("K/W")),
    "L": (signification: "la longueur du cylindre", unité: unit("m")),
    "S": (signification: "la section du cylindre", unité: unit("m^2")),
    "T_0": (signification: "la température initiale du système", unité: unit("K")),
    "C_V": (signification: "la capacité thermique à volume constant", unité: unit("J/K")),
)

= Formulation infinitésimale des principes de la thermodynamique
== La différentielle mathématique

#encadré(
    titre: "Différentielle d'une fonction d'une variable",
    connaitre: true,
    hypothèses: (
        ["$f$ est une fonction de $x$ dérivable"],
    ),
)[
    $ dd(f) = dv(f, x) dd(x) $
]

#application[
    Déterminer la différentielle de la fonction $sin$.
]

#encadré(
    titre: "Différentielle d'une fonction de deux variables",
    connaitre: true,
    hypothèses: (
        [$f$ est une fonction de $x$ et de $y$ dérivable par rapport à $x$ et à $y$],
    ),
)[
    $ dd(f)= pdv(f, x) dd(x) + pdv(f, y) dd(y) $
]

#application[
    Déterminer la différentielle de $(x,y) arrow.r.bar x/y$.
]

La formule de la différentielle d'une fonction de deux variables peut être généralisée pour un nombre quelconque de variables.

Une quantité $A dd(x)+B dd(y)$ est une *forme différentielle*. On note les formes différentielle avec un $delta$ : $delta f=A dd(x)+B dd(y)$. Une quantité $A dd(x)+B dd(y)$ est une différentielle ssi il existe $f$ telle que $dd(f)=A dd(x) + B dd(y)$.

#application[
    Les formes différentielles suivantes sont-elles des sont-elles des différentielles ?
    $ delta f = x dd(x) + y dd(y) $
    $ delta g = y dd(x) + x dd(y) $
]

L'intégrale d'une différentielle ne dépend pas du chemin suivi : $integral_((P Q)) dd(f) = f(Q)-f(P)$.

L'intégrale d'une forme différentielle $integral_((P Q)) delta f$ dépend du chemin suivi.

#exemple[
    On note $W=integral delta W$ : le travail dépend a priori du chemin suivi.

    On note $W=- integral dd(E_p)$ car pour une force conservative, le travail est indépendant du chemin suivi.
]

En physique, les grandeurs notées $dd(f)$ représentent des *variation* infinitésimales.

#exemple[
    Entre $t$ et $t+dd(t)$, la température augment de $dd(T)$.
]

#flashcard(
    recto: "Signification physique de $dd(f)$.",
    verso: "Petite variation : $dd(f)=f(t+dd(t))-f(t)$.",
)

En physique, les grandeurs notées $delta f$ représentent des *quantités* infinitésimales.

#exemple[
    Entre $t$ et $t+dd(t)$, une chaleur $delta Q$ rentre dans le système.
]

#flashcard(
    recto: "Signification physique de $delta f$.",
    verso: "Petite quantité.",
)

Exception : pour les variables d'intégration, cette règle est enfreinte. On note $dd(x)$, $dd(y)$, $dd(z)$ des dimensions, $dd(S)$ une surface, $dd(V)$ un volume, $dd(t)$ une durée alors que ce ne sont pas des variations.

== Premier principe

#encadré(
    titre: "Formulation infinitésimale du premier principe de la thermodynamique",
    connaitre: true,
    hypothèses: (
        "Le système est fermé.",
        "La transformation est infinitésimale",
    ),
    grandeurs: sub-dictionary(grandeurs, ("dd(E)", "dd(E_c)", "dd(U)", "delta W", "delta Q")),
)[
    $ dd(E)=delta W + delta Q $
]

#flashcard(
    recto: "Premier principe de la thermodynamique pour une transformation infinitésimale.",
    verso: "$dd(U)+dd(E_c)= delta W +  delta Q$",
)

La variation d'énergie $dd(E)$ est une petite variation et s'écrit bien avec un d. La chaleur $delta Q$ et le travail $delta W$ sont des petites quantités et s'écrivent bien avec un $delta$.

== Second principe

#encadré(
    titre: "Formulation infinitésimale du second principe de la thermodynamique",
    connaitre: true,
    hypothèses: (
        "Le système est fermé.",
        "La transformation est infinitésimale",
    ),
    grandeurs: sub-dictionary(grandeurs, ("cal(S)", "delta cal(S)_e", "delta cal(S)_c", "delta Q", "T_\"ext\"")),
)[
    $ dd(cal(S))=delta cal(S)_e + delta cal(S)_c $
]

#flashcard(
    recto: "Second principe de la thermodynamique pour une transformation infinitésimale.",
    verso: "$dd(S)=delta S_e + delta S_c$ avec $delta S_e=(delta Q)/T_\"ext\"$ et $delta S_c >= 0$",
)

La variation de d'entropie $dd(cal(S))$ est une petite variation et s'écrit bien avec un $d$. La chaleur $delta Q$, l'entropie échangée $delta cal(S)_e$ et l'entropie créée $delta cal(S)_c$ des petites quantités et s'écrivent bien avec un $delta$.

== Équilibre thermodynamique local
=== Les 3 échèles
/ Échelle microscopique ($tilde qty("e-10", "m")$): C'est l'échelle des molécules du système. Ces molécules sont animées d'un mouvement erratique. Les grandeurs thermodynamiques n'ont pas de sens pour une molécule.

/ Échelle macroscopique ($tilde qty("e-2", "m")$): C'est l'échelle des systèmes étudiés dans leur ensemble.\ Si le système est à l'équilibre thermodynamique, on peut définir ses grandeurs thermodynamiques (température, pression, ...) et les étudier comme vu en première année. \ Lorsqu'il y a des transferts thermiques à l'intérieur d'un système, ce système n'est pas à l'équilibre thermodynamique. Certaines des grandeurs thermodynamiques de ce système (température, pression, ...) ne sont donc pas définies.

/ Échelle mésoscopique ($>> qty("e-10", "m")$ et $<< qty("e-2", "m")$): L'échelle mésoscopique est une échelle intermédiaire entre l'échelle microscopique et l'échelle macroscopique.\ Comme l'échelle mésoscopique est très grande devant l'échelle microscopique, les fluctuations dues à l'agitation des molécules sont faibles.\ Comme l'échelle mésoscopique est très petite devant l'échelle macroscopique, les grandeurs y sont uniformes (ce sont les mêmes en un point ou un autre du système mésoscopique).

L'échelle mésoscopique sert
- pour décrire les systèmes qui ne sont pas à l'équilibre thermodynamique
- pour passer des propriétés microscopiques au propriétés macroscopiques

Les grandeurs extensives associées à un système mésoscopique sont notées avec un $delta$ car ce sont des quantités infinitésimales : $delta U$, $delta V$, ...

=== Équilibre thermodynamique local
Si un système macroscopique peut être découpé en systèmes mésoscopiques qui sont tous à l'équilibre thermodynamique, on dit qu'il y a équilibre thermodynamique local. A l'équilibre thermodynamique local, les grandeurs thermodynamiques sont définies pour les systèmes mésoscopiques.

A l'équilibre thermodynamique local, les grandeurs thermodynamiques sont des champs#footnote[Un champ est une fonction définie sur tous les points de l'espace.]. Par exemple, la température au point $M$ $T(M)$ est définie comme la température d'un système mésoscopique centré sur le point $M$. Cette température existe car à l'équilibre thermodynamique local, tous les systèmes mésoscopiques sont à l'équilibre thermodynamique. De plus, cette température ne dépend pas du choix, arbitraire, du système mésoscopique.

Ces champs n'ont un sens que pour les grandeurs intensives car ils dépendraient du choix du volume mésoscopique. On transforme donc les grandeurs extensives en grandeurs intensives en divisant soit par la masse soit par le volume.

#figure(
    table(
        columns: 3,
        stroke: none,
        table.header([grandeur extensive], table.vline(), [grandeur massique], table.vline(), [grandeur volumique]),
        table.hline(),
        [énergie interne $U$ (#unit("J"))],
        [énergie interne massique $u$ (#unit("J/kg"))],
        [énergie interne volumique $u_V$ (#unit("J/m^3"))],

        [masse $m$ (#unit("kg"))], [], [masse volumique $\mu$ (#unit("kg/m^3"))],
        [entropie $S$ (#unit("J/K"))],
        [entropie massique $s$ (#unit("J/K/kg"))],
        [entropie volumique $s_V$ (#unit("J/K/m^3"))],
    ),
)

= Transport de chaleur
== Les 3 modes de transport de chaleur
La chaleur peut se transporter d'un système à un autre de 3 façons :
/ Par diffusion (= par conduction): L'énergie se transmet de proche en proche. Le milieu est macroscopiquement immobile.
#exemple[
    La queue d'un ustensile de cuisine devient chaude.
]

/ Par conducto-convection (= par convection): Un fluide est en mouvement. En se déplaçant, le fluide transporte de l'énergie avec lui.\ Le fluide peut se mettre en mouvement spontanément si certaines zones sont plus chaudes que d'autres. Ça s'appelle la convection naturelle. #exemple[L'eau qui chauffe dans la casserole, les courants marins.] Le fluide peut être mis en mouvement par autre chose. Ça s'appelle la convection forcée. #exemple[L'air du sèche-cheveux.]

/ Par rayonnement: Tous les matériaux émettent un rayonnement électromagnétique. La fréquence et l'intensité du rayonnement électromagnétique dépendent de la température du matériau. Le rayonnement électromagnétique transporte de l'énergie. Le rayonnement électromagnétique peut se propager dans le vide ou dans les milieux transparents. Le rayonnement électromagnétique peut être absorbé par un matériau, il lui apporte alors de la chaleur. #exemple[La chaleur du Soleil, les plaques vitro-céramiques.]

#flashcard(
    recto: "Trois façons de transférer de la chaleur (avec exemples).",
    verso: "Par conduction (la queue d'une casserole devient chaude) ; par conducto-convection (le fond de la casserole chauffe l'eau qu'elle contient) ; par rayonnement (la chaleur du Soleil nous parvient).",
)

== Le vecteur densité de courant thermique
Le vecteur densité de courant thermique $va(j_Q)$ est la chaleur transitant par unité de surface et de temps.
#encadré(
    titre: "Chaleur traversant une surface infinitésimale",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("va(j_Q)", "dd(S)", "delta Q")),
)[
    $ delta Q = va(j_Q) dot va(dd(S)) dd(t) $

]

#encadré(
    titre: "Puissance traversant une surface infinitésimale",
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("va(j_Q)", "dd(S)", "delta Phi")),
)[
    $ delta Phi = va(j_Q) dot va(dd(S)) $
]

#flashcard(
    recto: "Lien entre la chaleur $delta Q$, le flux thermique $delta Phi$ et le vecteur densité de courant thermique $va(j_Q)$.",
    verso: "$delta Q = delta Phi dd(t) = va(j_Q) dot va(dd(S)) dd(t)$.",
)

La puissance (aussi appelée flux thermique#footnote[En physique, les intégrales doubles sur des surfaces s'appellent des flux.]) qui traverse une surface finie est l'intégrale du flux sur une surface infinitésimale.

#encadré(
    titre: "Puissance traversant une surface finie",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("Phi", "delta Phi")),
)[
    $ Phi = integral.double_S delta Phi $
]

#application[
    Déterminer le flux thermique du vecteur densité de courant $va(j_Q)= h (T-T_"ext") er$ sur un cylindre de rayon $R$, de longueur $L$ centré sur l'axe $(O,ex)$ du repère.
]

== Loi de Fourier
La loi de Fourier est une loi phénoménologique#footnote[Phénoménologique veut dire qui vient de l'expérience.]. La loi de Fourier relie le vecteur densité de courant de chaleur $va(j_Q)$ et la température $T$ dans le cas du transfert thermique par *conduction*.

#encadré(
    titre: "Loi de Fourier",
    connaitre: true,
    hypothèses: (
        "Le système est à l'équilibre thermodynamique local.",
        "Le transport de chaleur se fait par conduction.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("va(j_Q)", "lambda", "T")),
)[
    $ va(j_Q) = - lambda grad T $
]

#flashcard(
    recto: "Loi de Fourier.",
    verso: "$ va(j_Q)=-lambda grad T $",
)

La conductivité thermique $lambda$ permet de mesurer la facilité avec laquelle un matériau transporte la chaleur.

#encadré(
    titre: "Ordres de grandeur de la conductivité thermique",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("lambda",)),
)[
    $ lambda_"air" tilde #qty("e-2", "J/s/m/K") $
    $ lambda_"eau" tilde #qty("e-1", "J/s/m/K") $
    $ lambda_"béton" tilde #qty("e0", "J/s/m/K") $
    $ lambda_"acier" tilde #qty("e1", "J/s/m/K") $
]

#flashcard(
    recto: "Conductivité thermique de l'acier, de l'air, du béton et de l'eau (ordres de grandeur)",
    verso: "$ lambda_\"air\" tilde #qty(\"e-2\", \"J/s/m/K\") $
    $ lambda_\"eau\" tilde #qty(\"e-1\", \"J/s/m/K\") $
    $ lambda_\"béton\" tilde #qty(\"e0\", \"J/s/m/K\") $
    $ lambda_\"acier\" tilde #qty(\"e1\", \"J/s/m/K\") $",
)

Le signe "$-$" dans la loi de Fourier traduit le sens de déplacement de la chaleur : toujours du chaud vers le froid.

#application[
    Déterminer le vecteur densité de courant thermique pour le champ de température $ T(x,y,z)=(x y)/z T_0/l $
]

= Équation de la diffusion thermique
== Bilan d'énergie
Le premier principe de la thermodynamique traduit la conservation de l'énergie, c'est-à dire que l'énergie ne peut pas être créée ou détruite, elle ne peut que se transformer d'une forme à l'autre.

#exemple[
    Quand un vélo freine, son énergie mécanique se transforme en énergie thermique.
]

Quand une grandeur se conserve, on peut en faire le bilan.

Faire le bilan d'une grandeur dans un système veut dire compter combien de cette grandeur rentre dans ce système et combien y est créée. On ne s'intéresse qu'au flux rentrant car un flux sortant est un flux entrant de sens opposé.

En faisant un bilan sur un volume infinitésimale entre $t$ et $t+d t$, on aboutit à l'équation locale de conservation de l'énergie.

#encadré(
    titre: "Équation locale de conservation de l'énergie",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "Le système est à l'équilibre thermodynamique local.",
        "Le système est incompressible et macroscopiquement immobile.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("u", "va(j_Q)", "cal(P)_V")),
)[
    $ mu pdv(u, t)=-div va(j_Q) + cal(P)_v $
]

#flashcard(
    recto: "Équation locale de conservation de l'énergie.",
    verso: "$ mu pdv(u,t)=-div va(j_Q) + cal(P)_V $",
)

== Équation de la diffusion thermique
Lorsqu'on remplace le vecteur densité de courant thermique $va(j_Q)$ grâce à la loi de Fourier dans l'équation locale de conservation de l'énergie, on aboutit à l'équation de la diffusion thermique.

#encadré(
    titre: "Équation de la diffusion thermique",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "Le système est à l'équilibre thermodynamique local.",
        "Le système est incompressible et macroscopiquement immobile.",
        "La capacité thermique massique à volume constant $c_V$ est constante.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("T", "D_\"th\"", "cal(P)_V", "mu", "c_V", "lambda")),
)[
    $ pdv(T, t) - D_"th" Delta T = cal(P)_v/(mu c_V) $
]

Le coefficient $D_"th"$ est appelé diffusivité thermique ou coefficient de diffusion thermique.

#flashcard(
    recto: "Équation de diffusion thermique.",
    verso: "$ pdv(T, t) - D_\"th\" Delta T = cal(P)_v/(mu c_V) $",
)

== Analyse en ordres de grandeurs
#encadré(
    titre: "Approximation d'une dérivée par le taux d'accroissement",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("f", "F", "l")),
)[
    $ pdv(f, x) tilde F/l $
]

Si on analyse en ordres de grandeurs l'équation de diffusion thermique, on peut trouver la durée que met une variation de température à parcourir une certaine distance.

#encadré(
    titre: "Durée caractéristique de propagation d'une variation de température",
    savoir-faire: true,
    hypothèses: (
        "Le système est à l'équilibre thermodynamique local.",
        "Le système est incompressible et macroscopiquement immobile.",
        "La capacité thermique massique à volume constant $c_V$ est constante.",
        "Il n'y a pas de terme source.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("tau", "l", "D_\"th\"")),
)[
    $ tau = (l^2)/(D_"th") $
]

Comme la durée caractéristique dépend de $l^2$, l'onde de température ralenti en se propageant : elle met 4 fois plus de temps pour parcourir une distance 2 fois plus grande.

#application[
    Si je plonge une cuillère de #qty("20", "cm") en acier ($mu=#qty("8e3", "kg/m^3")$, $c_V=qty("4e2", "J/K/kg")$) dans une casserole d'eau bouillante, quel est l'ordre de grandeur de la durée au bout de laquelle la queue de la cuillère devient chaude ?
]

== Irréversibilité
La vidéo du lien ci-dessous illustre l'irréversibilité de différents phénomènes.
#lien("https://youtu.be/i6rVHr6OwjI")
Si, quand on remplace $t$ par $-t$ dans l'équation on obtient une équation différente, l'équation est irréversible.

Si une vidéo d'un phénomène irréversible est passée à l'envers, on s'en rend compte.

#application[
    L'équation de diffusion thermique sans terme source est-elle irréversible ?
]

#application[
    L'équation de D'Alembert $pdv(f, x, 2)-1/c^2 pdv(f, t, 2) =0$ est-elle irréversible ?
]

L'équation de la diffusion thermique est irréversible.

== Conditions aux limites
Le flux thermique est toujours continu.
#encadré(
    titre: "Continuité du flux thermique",
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("Phi",)),
)[
    $ Phi(x^+)= Phi(x^-) $
]

Lorsque la température est continue à une interface, on dit qu'il y a *contact thermique parfait*.


= ARQS et résistance thermique
== Approximation du régime quasi-stationnaire (ARQS)
Dans l'ARQS, les grandeurs ne varient pas très vite avec le temps. Dans l'ARQS, on peut négliger les dérivées partielles par rapport au temps ($pdv(, t)$). Dans l'ARQS, la durée que met une variation de température à parcourir le système est très courte devant la durée caractéristique de variation de la température.

#encadré(
    titre: "Condition de l'ARQS",
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("l", "D_\"th\"", "cal(T)")),
)[
    $ l^2 << D_"th"/cal(T) $
]

== Conservation du flux de $va(j_Q)$

#encadré(
    titre: "Équation locale de conservation de l'énergie en régime stationnaire",
    savoir-faire: true,
    hypothèses: (
        [Le système est à l'équilibre thermodynamique local.],
        [Le système est incompressible et macroscopiquement immobile.],
        [En l'absence de terme source#footnote[Sans terme source veut dire $cal(P)_V=0$.].],
        [Dans l'ARQS.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("va(j_Q)",)),
)[
    $ div va(j_Q) = 0 $
]

En régime stationnaire, le flux de chaleur est conservatif.

== Résistance thermique
Dans l'ARQS, la différence de température entre les extrémités d'un système est proportionnelle avec le flux thermique. Le facteur de proportionnalité s'appelle la *résistance thermique*.

#schéma(titre: "Convention récepteur pour une résistance thermique", hauteur: 3cm)

#encadré(
    titre: "Résistance thermique d'un cylindre",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [Le système est à l'équilibre thermodynamique local.],
        [Le système est incompressible et macroscopiquement immobile.],
        [En l'absence de terme source.],
        [Dans l'ARQS.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("T", "R_\"th\"", "Phi", "lambda", "L", "S")),
)[
    $ T_1-T_2 = R_"th" Phi $
    avec $ R_"th" = L/(S lambda) $
]

#flashcard(
    recto: "Résistance thermique d'un barreau cylindrique.",
    verso: "$T_1-T_2=R_\"th\" Phi$ avec $R_\"th\"=L/(S lambda)$",
)

== Association de résistances thermiques
Si deux résistances thermiques sont en série, elles sont traversées par le même flux thermique.
#schéma(titre: "Résistances thermiques en série", hauteur: 3cm)

#exemple[
    Double vitrage, isolation d'un mur, ...
]

#encadré(
    titre: "Association en série de résistances thermiques",
    connaitre: true,
    hypothèses: (
        [Le système est à l'équilibre thermodynamique local.],
        [Le système est incompressible et macroscopiquement immobile.],
        [En l'absence de terme source.],
        [Dans l'ARQS.],
        [Le problème est unidimensionnel, les grandeurs dépendent de la seule coordonnée $x$.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("R_\"th\"",)),
)[
    $ R_"th, éq" = R_"th, 1" + R_"th, 2" $
]

#application[
    Déterminer la résistance thermique équivalente d'un double vitrage. Chaque vitre a une épaisseur #qty("1", "cm"), de même que l'air entre les deux. La surface de la fenêtre est #qty("1", "m^2"). $lambda_"verre"=qty("1", "W/m/K")$.
]

Si deux résistances thermiques sont en parallèle, elles sont soumises à la même différence de température.
#schéma(titre: "Résistances thermiques en parallèle", hauteur: 3cm)
#exemple[
    Fenêtre dans un mur, ...
]

#encadré(
    titre: "Association en parallèle de deux résistances thermiques",
    connaitre: true,
    hypothèses: (
        [Le système est à l'équilibre thermodynamique local.],
        [Le système est incompressible et macroscopiquement immobile.],
        [En l'absence de terme source.],
        [Dans l'ARQS.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("R_\"th\"",)),
)[
    $ 1/R_"th, éq" = 1/R_"th, 1" + 1/R_"th, 2" $
]

#application[
    #add-unit("tog", "tog", "upright(\"tog\")")
    Déterminer la résistance thermique équivalente d'une gigoteuse de surface #qty("0.5", "m^2") et de #qty("2", "tog")#footnote[Le #unit("tog") est une unité inverse de la résistance thermique surfacique. Un #qty("1", "tog") correspond à #qty("0.1", "m^2 K/W").] et d'un bonnet de surface #qty("400", "cm^2") et de #qty("1", "tog").
]

== Circuit RC thermique
Le circuit RC thermique correspond à une capacité thermique en contact avec un thermostat à travers une résistance thermique.

#exemple[
    Le circuit RC thermique peut modéliser le refroidissement du contenu d'une tasse ou le réchauffement d'un petit pois dans une casserole d'eau.
]

#encadré(
    titre: "Évolution de la température dans un circuit RC thermique",
    savoir-faire: true,
    hypothèses: (
        "En l'absence de terme source",
        "Dans l'ARQS",
        "Le système est à l'équilibre thermodynamique local",
        "Le système est incompressible et macroscopiquement immobile",
        "La température est uniforme dans le système",
        [a capacité thermique à volume constant $C_V$ est constante.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("T", "T_0", "T_\"ext\"", "R_\"th\"", "C_V")),
)[
    $ T(t) = (T_0 -T_"ext") exp(-t/(R_"th" C_V))  + T_"ext" $
]

== Analogie avec l'électrocinétique
On peut faire une analogie entre l'électrocinétique et la thermique.

#figure(
    table(
        columns: 3,
        stroke: none,
        table.header([], table.vline(), [Thermique], table.vline(), [Électrocinétique]),
        table.hline(),
        [Flux],
        [$Phi=integral.double_S va(j_Q) dot va(dd(S))$ #h(1em) (#unit("W"))],
        [$I = integral.double_S va(j_"élec") dot va(dd(S))$ #h(1em) (#unit("A"))],

        [Vecteur densité de courant],
        [$va(j_Q) = -lambda grad T$ #h(1em) (#unit("W/m^2"))],
        [$va(j_"élec") = -gamma grad V$ #h(1em) (#unit("A/m^2"))],

        [Conservation],
        [$div va(j_Q) = 0$],
        [$div va(j_"élec") = 0$],

        [Résistance],
        [$R_"th" = L/(lambda S)$ #h(1em) (#unit("K/W"))],
        [$R = L/(gamma S)$ #h(1em) (#unit("ohm"))],

        [Loi d'Ohm],
        [$T_1 - T_2 = R_"th" Phi$ #h(1em) (#unit("K"))],
        [$V_1 - V_2 = R I$ #h(1em) (#unit("V"))],

        [Capacité],
        [$c_V$ #h(1em) (#unit("J/K"))],
        [$C$ #h(1em) (#unit("F"))],

        [Équation différentielle pour un RC],
        [$R_"th" c_V pdv(T, t) + T = T_"ext"$],
        [$R C pdv(u, t) + u = E$],
    ),
)

// \section{Ondes thermiques}
// Des ondes peuvent être solution de l'équation de la diffusion thermique.
// L'équation de la diffusion thermique est linéaire\footnote{Une équation est linéaire si pour tous $f$ et $g$ solution de l'équation ,$\lambda f+\mu g$ est aussi solution.}
// Pour toutes les équations linéaires, on s'intéresse aux solutions sinusoïdales.

// \formule{%
//   Solutions sinusoïdales de l'équation de la diffusion thermique}[%
//   \begin{itemize}
//     \item en l'absence de terme source
//     \item le système est à l'équilibre thermodynamique local
//     \item le système est incompressible et macroscopiquement immobile
//     \item la température de dépend que de la coordonnée cartésienne $x$
//     \item le système est latéralement calorifugé
//   \end{itemize}]{%
//   $$T(x,t)=T_0+\Theta_0\cos\left(\omega t-\frac{x}{\delta}\right) e^{-\frac{x}{\delta}}$$}[%
//   \begin{itemize}
//     \item $T(x,t)$ la température du système à l'instant $t$ et à l'abscisse $x$ (\unit{K})
//     \item $T_0$ la valeur moyenne de la température (\unit{K})
//     \item $\Theta_0$ l'amplitude des variations de température (\unit{K})
//     \item $\omega$ la pulsation (\unit{rad.s^{-1}})
//     \item $\delta=\sqrt{\frac{2D_\text{th}}{\omega}}$ la profondeur de peau (\unit{m})
//     \item $D_\text{th}=\frac{\lambda}{\mu C_V}$ le coefficient de diffusion thermique (\unit{m^2.s^{-1}})
//   \end{itemize}\schema{}{3cm}][][o]

// L'amplitude des ondes thermiques diminue quand elles se propagent (terme en $e^{-\frac{x}{\delta}}$). La relation qui relie la pulsation spatiale ($\frac{1}{\delta}$) et $\omega$ s'appelle la relation de dispersion.

// Pour une distance supérieure à quelques fois la profondeur de peau, la température est quasiment égale à $T_0$.

// \application{Pour un sol de diffusivité thermique $D_\text{th}=\SI{2e-7}{m^2.s^{-1}}$, déterminer la profondeur de peau pour une période de \SI{1}{jour} et pour une période de \SI{1}{an}.}
