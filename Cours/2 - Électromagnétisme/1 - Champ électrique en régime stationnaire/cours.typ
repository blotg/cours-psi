#import "@local/prepa:0.1.1": *

#show: cours.with(infos: yaml("infos.yml"))

#let grandeurs = (
    "Q": (signification: "la charge électrique", unité: unit("C")),
    "rho": (signification: "la densité volumique de charge", unité: unit("C/m^3")),
    "sigma": (signification: "la densité surfacique de charge", unité: unit("C/m^2")),
    "lambda": (signification: "la densité linéique de charge", unité: unit("C/m")),
    "va(F)_(1 slash 2)": (signification: "la force exercée par la particule 1 sur la particule 2", unité: unit("N")),
    "q_1": (signification: "la charge de la particule 1", unité: unit("C")),
    "q_2": (signification: "la charge de la particule 2", unité: unit("C")),
    "q": (signification: "la charge de la particule", unité: unit("C")),
    "epsilon_0": (signification: "la permittivité diélectrique du vide ($8.85 times 10^(-12)$ F/m)"),
    "va(e)": (signification: "le vecteur unitaire dirigé de la particule 1 vers la particule 2"),
    "va(E)": (signification: "le champ électrique", unité: unit("V/m")),
    "va(B)": (signification: "le champ magnétique", unité: unit("T")),
    "r": (signification: "la distance à la charge (première coordonnée sphérique)", unité: unit("m")),
    "va(e_r)": (signification: "le vecteur unitaire radial des coordonnées sphériques"),
    "V": (signification: "le potentiel électrique", unité: unit("V")),
    "V_A": (signification: "le potentiel électrique au point $A$", unité: unit("V")),
    "V_B": (signification: "le potentiel électrique au point $B$", unité: unit("V")),
    "Delta": (signification: "le laplacien scalaire"),
    "S": (signification: "une surface fermée orientée vers l'extérieur"),
    "Q_text(\"int\")": (signification: "la charge contenue à l'intérieur de $S$", unité: unit("C")),
    "va(g)": (signification: "le champ gravitationnel", unité: unit("m/s^2")),
    "cal(G)": (signification: "la constante gravitationnelle ($6.67 times 10^(-11)$ m³·kg⁻¹·s⁻²)"),
    "M_text(\"int\")": (signification: "la masse contenue à l'intérieur de $S$", unité: unit("kg")),
    "C": (signification: "la capacité du condensateur", unité: unit("F")),
    "va(n)": (signification: "un vecteur unitaire allant de l'armature positive vers l'armature négative"),
    "S_a": (signification: "la surface d'une armature", unité: unit("m^2")),
    "e": (signification: "la distance entre les armatures", unité: unit("m")),
    "epsilon": (signification: "$= epsilon_r epsilon_0$ la permittivité diélectrique de l'isolant", unité: unit("F/m")),
    "epsilon_r": (signification: "la permittivité diélectrique relative de l'isolant (sans unité)"),
    "w": (signification: "la densité volumique d'énergie électrostatique", unité: unit("J/m^3")),
)

= Notion de charge électrique
La charge est une grandeur extensive. Au niveau microscopique, elle est portée par des porteurs de charge dont la charge est quantifiée : $q = k e$ avec $k in ZZ$ et $e = qty("1.6e-19", "C")$ la charge élémentaire. Un électron porte la charge $q_(e^-) = -e$.

== Description de la charge
=== Distribution volumique
$rho(M, t)$ désigne la densité volumique de charge au point $M$ et à l'instant $t$.

#encadré(
    titre: "Charge d'un système en description volumique",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("Q", "rho")),
)[
    $ Q = integral.triple rho dif V $
]

=== Distribution surfacique
$sigma(M, t)$ désigne la densité surfacique de charge au point $M$ et à l'instant $t$.

#encadré(
    titre: "Charge d'un système en description surfacique",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("Q", "sigma")),
)[
    $ Q = integral.double sigma dif S $
]

=== Distribution linéique
$lambda(M, t)$ désigne la densité linéique de charge au point $M$ et à l'instant $t$.

#encadré(
    titre: "Charge d'un système en description linéique",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("Q", "lambda")),
)[
    $ Q = integral lambda dif l $
]

=== Distribution ponctuelle
$Q$ désigne la charge d'un objet ponctuel.

== Charge électrique et force
#encadré(
    titre: "Force d'interaction électrostatique (loi de Coulomb)",
    connaitre: true,
    hypothèses: "Les deux particules sont ponctuelles.",
    grandeurs: sub-dictionary(grandeurs, ("va(F)_(1 slash 2)", "q_1", "q_2", "epsilon_0", "va(e)")),
)[
    $ va(F)_(1 slash 2) = (q_1 q_2)/(4 pi epsilon_0) 1/(M_1 M_2)^2 va(e) $
]

#flashcard(
    recto: "Force subie par une particule chargée 2 de la part d'une particule chargée 1",
    verso: "$ va(F)_(1 slash 2) = (q_1 q_2)/(4 pi epsilon_0) 1/(M_1 M_2)^2 va(e) $",
)

La force est répulsive si les charges sont de même signe, attractive si elles sont de signes différents.

#encadré(
    titre: "Champ électrique créé par une particule ponctuelle",
    connaitre: true,
    savoir-faire: true,
    hypothèses: "La particule est placée à l'origine du repère.",
    grandeurs: sub-dictionary(grandeurs, ("va(E)", "q", "epsilon_0", "r", "va(e_r)")),
)[
    $ va(E) = q/(4 pi epsilon_0) 1/r^2 va(e_r) $
]

#flashcard(
    recto: "Champ électrique créé par une particule ponctuelle",
    verso: "$ va(E) = q/(4 pi epsilon_0) 1/r^2 va(e_r) $",
)

= Champ et potentiel électriques
== Équations de Maxwell
Le champ électrique obéit aux équations de Maxwell.

#encadré(
    titre: "Équation de Maxwell-Gauss",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("va(E)", "rho", "epsilon_0")),
)[
    $ div va(E) = rho/epsilon_0 $
]

#flashcard(recto: "Équation de Maxwell-Gauss", verso: "$ div va(E) = rho/epsilon_0 $")

#encadré(
    titre: "Équation de Maxwell-Faraday",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("va(E)", "va(B)")),
)[
    $ rot va(E) = - pdv(va(B), t) $
]

#flashcard(recto: "Équation de Maxwell-Faraday", verso: "$ rot va(E) = - pdv(va(B), t) $")

== Potentiel électrique
#encadré(
    titre: "Potentiel électrique",
    connaitre: true,
    savoir-faire: true,
    hypothèses: "En régime stationnaire.",
    grandeurs: sub-dictionary(grandeurs, ("va(E)", "V")),
)[
    $ va(E) = - grad V $
]

#flashcard(recto: "Lien entre potentiel électrique et champ électrique", verso: "$ va(E) = - grad V $ (en régime stationnaire)")

Comme $grad K = va(0)$ pour toute constante $K$, le potentiel électrique est défini à une constante additive près : on choisit arbitrairement sa valeur en un point.

#encadré(
    titre: [Circulation de $va(E)$],
    connaitre: true,
    savoir-faire: true,
    hypothèses: "En régime stationnaire.",
    grandeurs: sub-dictionary(grandeurs, ("va(E)", "V_A", "V_B")),
)[
    $ integral_A^B va(E) dot va(dif l) = V_A - V_B $
]

#flashcard(recto: "Circulation du champ électrique", verso: "$ integral_A^B va(E) dot va(dif l) = V_A - V_B $ (en régime stationnaire)")

#question-de-colle("Énoncer l'équation de Maxwell-Faraday, en déduire qu'en régime stationnaire $va(E) = - grad V$, puis exprimer la circulation du champ électrique.")

== Équation de Poisson
#encadré(
    titre: "Équation de Poisson",
    connaitre: true,
    savoir-faire: true,
    hypothèses: "En régime stationnaire.",
    grandeurs: sub-dictionary(grandeurs, ("Delta", "V", "rho", "epsilon_0")),
)[
    $ Delta V = - rho/epsilon_0 $
]

#flashcard(recto: "Équation de Poisson vérifiée par le potentiel électrique", verso: "$ Delta V = - rho/epsilon_0 $")

#encadré(
    titre: "Équation de Laplace",
    connaitre: true,
    savoir-faire: true,
    hypothèses: ("En régime stationnaire.", "Dans une zone vide de charges."),
    grandeurs: sub-dictionary(grandeurs, ("Delta", "V")),
)[
    $ Delta V = 0 $
]

#flashcard(recto: "Équation de Laplace vérifiée par le potentiel électrique dans le vide", verso: "$ Delta V = 0 $")

#question-de-colle("Énoncer les équations de Maxwell-Gauss et Maxwell-Faraday, puis établir les équations de Poisson et de Laplace vérifiées par le potentiel électrique.")

== Topographie des cartes de champ
=== Tubes de champ en l'absence de sources
Une ligne de champ est une courbe tangente en tout point au champ. Un tube de champ est un ensemble de lignes de champ s'appuyant sur une courbe fermée.

#encadré(
    titre: [Conservation du flux de $va(E)$],
    connaitre: true,
    savoir-faire: true,
    hypothèses: ("En régime stationnaire.", "Dans une zone vide de charges."),
    grandeurs: sub-dictionary(grandeurs, ("va(E)",)),
)[
    Le flux de $va(E)$ est le même à travers chaque section d'un même tube de champ.
]

#flashcard(recto: "Conditions pour que le champ électrique soit à flux conservatif", verso: "En régime stationnaire, dans une zone vide de charges.")

Un rétrécissement d'un tube de champ s'accompagne donc d'une augmentation de la norme du champ électrique.

=== Passer d'une carte à l'autre
#encadré(
    titre: "Lien entre cartes de champ et cartes de potentiel",
    connaitre: true,
    hypothèses: "En régime stationnaire.",
)[
    - les lignes de champ sont orthogonales aux équipotentielles ;
    - $va(E)$ pointe dans le sens des potentiels décroissants ;
    - plus $norm(va(E))$ est grand, plus les équipotentielles sont resserrées.
]

#flashcard(
    recto: "Lien entre carte de champ électrique et carte de potentiel électrique",
    verso: "Les lignes de champ sont orthogonales aux équipotentielles ; $va(E)$ pointe vers les potentiels décroissants ; plus $va(E)$ est intense, plus les équipotentielles sont resserrées.",
)

#application[
    Tracer des lignes de champ électrique sur les cartes d'équipotentielles suivantes.
    #figure(canvas({
        import cetz.draw: *
        set-style(stroke: 0.7pt)
        // charge ponctuelle : équipotentielles circulaires
        for (rad, lab) in ((0.45, "15 V"), (0.95, "10 V"), (1.8, "5 V"), (3.0, "0 V")) {
            circle((0, 0), radius: rad)
            content((rad * 0.71, rad * 0.71), anchor: "south-west", text(0.75em)[#lab])
        }
        // condensateur : équipotentielles planes
        for (x, lab) in ((0.0, "30 V"), (0.8, "20 V"), (2.0, "10 V"), (3.8, "0 V")) {
            line((7 + x, -2.4), (7 + x, 2.4))
            content((7 + x, 2.4), anchor: "south", text(0.75em)[#lab])
        }
    }))
]

#application[
    Tracer des équipotentielles sur la carte de lignes de champ suivante.
    #figure(canvas({
        import cetz.draw: *
        set-style(stroke: 0.8pt)
        for (y0, y1) in ((1, 3.2), (0.5, 1.6), (0, 0), (-0.5, -1.6), (-1, -3.2)) {
            bezier((0, y0), (8, y1), (3.5, y0), (5, y1), mark: (pos: 0.55, end: "stealth"))
        }
    }))
]

#application[
    Déterminer la valeur, la direction et le sens du champ électrique aux points $M_1$ et $M_2$ à l'aide de la carte des équipotentielles.
    #figure(canvas({
        import cetz.draw: *
        set-style(stroke: 0.7pt)
        let xs = (0, 0.2, 0.4, 0.6, 1.0, 1.3, 1.7, 2.2, 2.8, 3.5, 4.4, 5.4, 6.4, 7.4, 8.4, 9.4)
        let labs = (0, 5, 10, 15)
        for x in xs {
            line((x, -2), (x, 2))
        }
        for (x, v) in ((0, 0), (1.3, 5), (4.4, 10), (9.4, 15)) {
            content((x, 2), anchor: "south", text(0.8em)[#v V])
        }
        circle((0.2, 0), radius: 0.05, fill: black)
        content((0.2, 0), anchor: "north", padding: 0.35em, $M_1$)
        circle((8.4, 0), radius: 0.05, fill: black)
        content((8.4, 0), anchor: "north", padding: 0.35em, $M_2$)
    }))
]

== Linéarité
Les équations de Maxwell étant linéaires, on peut appliquer le théorème de superposition.

#encadré(
    titre: "Théorème de superposition",
    connaitre: true,
    savoir-faire: true,
)[
    Si les distributions $rho_1$ et $rho_2$ créent respectivement les champs $va(E_1)$ et $va(E_2)$, alors la distribution $rho_1 + rho_2$ crée le champ $va(E_1) + va(E_2)$.
]

= Théorème de Gauss
== Symétries du champ électrique
Les symétries de la distribution de charge contraignent le champ électrique.

#encadré(titre: "Principe de Curie", connaitre: true)[
    Lorsque des causes produisent des effets, les symétries des causes se retrouvent dans leurs effets.
]

#encadré(
    titre: "Plans de symétrie et champ électrique",
    connaitre: true,
    savoir-faire: true,
)[
    Le champ électrique est inclus dans les plans de symétrie de la distribution de charge.
]

#flashcard(recto: "Rapport du champ électrique aux plans de symétrie de la distribution de charge", verso: "Le champ électrique y est inclus.")

#application[
    On considère une boule uniformément chargée. Déterminer la direction du champ électrique en tout point de l'espace.
]

Si, pour chaque couple de points symétriques par un plan, la distribution de charge y est opposée, le plan est un plan d'antisymétrie.

#encadré(
    titre: "Plans d'antisymétrie et champ électrique",
    connaitre: true,
    savoir-faire: true,
)[
    Le champ électrique est orthogonal aux plans d'antisymétrie de la distribution de charge.
]

#flashcard(recto: "Rapport du champ électrique aux plans d'antisymétrie de la distribution de charge", verso: "Le champ électrique leur est orthogonal.")

#application[
    On considère deux armatures planes en regard, de charges opposées. Déterminer la direction du champ électrique dans le plan médiateur des armatures.
]

== Invariances du champ électrique
Un champ est invariant par une transformation si celle-ci le laisse inchangé. Les invariances de la distribution de charge contraignent le champ électrique.

#encadré(titre: "Principe de Curie (invariances)", connaitre: true)[
    Les invariances des causes se retrouvent dans leurs effets : $va(E)$ possède (au moins) les invariances de la distribution de charge.
]

#flashcard(recto: "Lien entre les invariances de $va(E)$ et celles de la distribution de charge", verso: "$va(E)$ a (au moins) les mêmes invariances que la distribution de charge.")

#application[
    De quelles variables d'espace dépend le champ électrique dans chacun des cas suivants ?
    + boule uniformément chargée de densité volumique $rho$ ;
    + plan infini uniformément chargé de densité surfacique $sigma$ ;
    + fil infini infiniment fin uniformément chargé de densité linéique $lambda$.
]

== Théorème de Gauss
#encadré(
    titre: "Théorème de Gauss",
    connaitre: true,
    savoir-faire: true,
    hypothèses: "En régime stationnaire.",
    grandeurs: sub-dictionary(grandeurs, ("S", "va(E)", "Q_text(\"int\")", "epsilon_0")),
)[
    $ integral.surf_S va(E) dot va(dif S) = Q_"int"/epsilon_0 $
]

#flashcard(recto: "Théorème de Gauss", verso: "$ integral.surf_S va(E) dot va(dif S) = Q_\"int\"/epsilon_0 $")

#question-de-colle("Énoncer l'équation de Maxwell-Gauss et démontrer le théorème de Gauss.")

#application[
    Déterminer le champ électrique créé par une particule ponctuelle de charge $q$.
]
#question-de-colle("Déterminer le champ électrique créé par une particule ponctuelle de charge $q$.")

#application[
    Déterminer le champ électrique créé par une boule de rayon $R$ uniformément chargée de densité volumique $rho$.
]
#question-de-colle("Déterminer le champ électrique créé par une boule uniformément chargée de densité volumique $rho$.")

#application[
    Déterminer le champ électrique créé par un cylindre plein de rayon $R$, infiniment long, uniformément chargé de densité volumique $rho$.
]
#question-de-colle("Déterminer le champ électrique créé par un cylindre plein uniformément chargé de densité volumique $rho$.")

#application[
    Déterminer le champ électrique créé par un plan infini uniformément chargé de densité surfacique $sigma$.
]
#question-de-colle("Déterminer le champ électrique créé par un plan infini uniformément chargé de densité surfacique $sigma$.")

== Analogie avec le champ de gravitation
Champ électrique et champ gravitationnel sont analogues.

#figure(table(
    columns: 3,
    align: (left, center, center),
    stroke: none,
    table.hline(),
    table.header([], [électrostatique], [gravitation]),
    table.hline(),
    [Grandeur portée par une particule], [charge $q$ (C)], [masse $m$ (kg)],
    [Force],
    $va(F)_(1 slash 2) = (q_1 q_2)/(4 pi epsilon_0) 1/(M_1 M_2)^2 va(e)$,
    $va(F)_(1 slash 2) = - cal(G) m_1 m_2 1/(M_1 M_2)^2 va(e)$,

    [Champ], $va(E) " (V/m)"$, $va(g) " (m/s"^2")"$,
    [Constante], $1/(4 pi epsilon_0)$, $- cal(G)$,
    table.hline(),
))

#encadré(
    titre: "Théorème de Gauss gravitationnel",
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("S", "va(g)", "M_text(\"int\")", "cal(G)")),
)[
    $ integral.surf_S va(g) dot va(dif S) = - 4 pi cal(G) M_"int" $
]

#flashcard(recto: "Théorème de Gauss gravitationnel", verso: "$ integral.surf_S va(g) dot va(dif S) = - 4 pi cal(G) M_\"int\" $")

#question-de-colle("Dresser les analogies entre les champs électrique et gravitationnel. Énoncer le théorème de Gauss gravitationnel.")

#application[
    La Terre a une masse $m_T = qty("6.0e24", "kg")$ et un rayon $R = qty("6.4e3", "km")$. Déterminer le champ gravitationnel qu'elle crée dans tout l'espace, en supposant sa masse volumique uniforme.
]
#question-de-colle("Déterminer le champ gravitationnel créé par une boule de masse volumique uniforme $mu$.")

= Condensateur plan
== Champ électrique
#encadré(
    titre: "Champ électrique dans un condensateur plan",
    savoir-faire: true,
    hypothèses: (
        "En régime stationnaire, effets de bord négligés.",
        "Deux armatures planes en regard, uniformément chargées de charges opposées, séparées par du vide.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("va(E)", "Q", "epsilon_0", "va(n)", "S_a")),
)[
    $ va(E) = cases((Q/(epsilon_0 S_a)) va(n) & "entre les armatures", va(0) & "ailleurs") $
]

== Capacité
#encadré(
    titre: "Capacité d'un condensateur plan",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "En régime stationnaire, effets de bord négligés.",
        "Deux armatures planes identiques en regard, de charges opposées, séparées par du vide.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("C", "S_a", "epsilon_0", "e")),
)[
    $ C = (epsilon_0 S_a)/e $
]

== Influence de la permittivité
Lorsque l'espace entre les armatures est occupé par un isolant, il faut prendre en compte sa permittivité.

#encadré(
    titre: "Capacité d'un condensateur plan avec diélectrique",
    savoir-faire: true,
    hypothèses: (
        "En régime stationnaire, effets de bord négligés.",
        "Deux armatures planes identiques en regard, de charges opposées.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("C", "S_a", "epsilon", "epsilon_r", "epsilon_0", "e")),
)[
    $ C = (epsilon S_a)/e $
]

#flashcard(recto: "Capacité d'un condensateur plan", verso: "$ C = (epsilon S_a)/e $ avec $epsilon = epsilon_0 epsilon_r$")

#question-de-colle("Établir le champ électrique entre les armatures d'un condensateur plan. En déduire la capacité. Généraliser au cas où l'isolant entre les armatures n'est pas du vide.")

#application[
    Un condensateur céramique de capacité $qty("470", "pF")$ comporte un diélectrique de permittivité relative $epsilon_r = 20$ et d'épaisseur $qty("1", "µm")$. Déterminer le diamètre des armatures.
]

== Aspect énergétique
L'énergie stockée dans un condensateur est $cal(E) = 1/2 C U^2$.

#encadré(
    titre: "Densité volumique d'énergie électrostatique",
    connaitre: true,
    savoir-faire: true,
    hypothèses: "Dans le vide.",
    grandeurs: sub-dictionary(grandeurs, ("w", "epsilon_0", "va(E)")),
)[
    $ w = 1/2 epsilon_0 E^2 $
]

#flashcard(recto: "Densité volumique d'énergie électrostatique", verso: "$ w = 1/2 epsilon_0 E^2 $")

#application[
    Déterminer l'énergie électrostatique totale contenue dans tout l'espace pour une boule de rayon $R$ uniformément chargée de densité volumique $rho$.
]
