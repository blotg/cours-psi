#import "@local/prepa:0.1.1": *
#let cpl(a, b) = [#ce(a)\/#ce(b)]

#show: cours.with(infos: yaml("infos.yml"))

#let grandeurs = (
    "Delta_r G": (signification: "l'enthalpie libre de réaction", unité: unit("J/mol")),
    "n": (signification: "le nombre d'électrons échangés (sans unité)"),
    "U": (signification: "$= E_+ - E_-$ la différence des potentiels des couples", unité: unit("V")),
    "cal(F)": (signification: "$= cal(N)_a e$ la constante de Faraday ($approx qty(\"96500\", \"C/mol\")$)"),
    "W": (signification: "le travail électrique reçu par le système chimique", unité: unit("J")),
    "Delta G": (signification: "la variation d'enthalpie libre", unité: unit("J")),
    "i": (signification: "le courant électrique arrivant à l'électrode", unité: unit("A")),
    "xi": (signification: "l'avancement de la réaction", unité: unit("mol")),
    "i_text(\"max\")": (signification: "l'intensité du courant sur le palier de diffusion", unité: unit("A")),
    "S": (signification: "la surface immergée de l'électrode", unité: unit("m^2")),
    "D": (signification: "le coefficient de diffusion", unité: unit("m^2/s")),
    "c": (signification: "la concentration de l'espèce limitant le courant", unité: unit("mol/L")),
    "delta": (signification: "l'épaisseur de la couche limite de diffusion", unité: unit("m")),
)

= Thermodynamique d'une réaction électrochimique
== Enthalpie libre de réaction
Pour une réaction électrochimique, les potentiels des couples redox sont liés à l'enthalpie libre de réaction.

#encadré(
    titre: "Enthalpie libre de réaction électrochimique",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("Delta_r G", "n", "U", "cal(F)")),
)[
    $ Delta_r G = - n cal(F) U $
    où $U = E_+ - E_-$, $E_+$ étant le potentiel du couple dont l'oxydant est du côté des réactifs.
]

#flashcard(recto: "Enthalpie libre de réaction pour une réaction électrochimique", verso: "$ Delta_r G = - n cal(F) U $")

#application[
    Déterminer l'enthalpie libre de réaction de #ce("2 Fe^3+ + Zn -> 2 Fe^2+ + Zn^2+"). Données : $ce("[Fe^2+]") = ce("[Fe^3+]") = ce("[Zn^2+]") = qty("0.1", "mol/L")$, $E^circ(cpl("Fe^3+", "Fe^2+")) = qty("0.77", "V")$, $E^circ(cpl("Zn^2+", "Zn")) = qty("-0.76", "V")$.
]

#application[
    Déterminer l'enthalpie libre standard de la réaction précédente.
]

#application[
    Écrire la réaction d'oxydoréduction faisant intervenir les couples #ce("O2/H2O") et #ce("H2O/H2"). En déduire le potentiel standard du couple #ce("O2/H2O") à la température de référence.
    #figure(table(
        columns: 4,
        align: (left, center, center, center),
        stroke: none,
        table.hline(),
        table.header([], [#ce("H2O(l)")], [#ce("H2")], [#ce("O2")]),
        table.hline(),
        [$Delta_f H^circ$ (kJ/mol)], [$-241.8$], [], [],
        [$S_m^circ$ (J/mol/K)], [$188.7$], [$130.5$], [$204.8$],
        table.hline(),
    ))
]

== Travail électrique
Le travail électrique reçu par un système chimique est borné par la variation d'enthalpie libre.

#encadré(
    titre: "Travail électrique",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "Pour une transformation isotherme et isobare.",
        "Les seuls travaux sont le travail électrique et celui des forces de pression.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("W", "Delta G")),
)[
    $ - W <= Delta G $
    Le travail électrique maximal récupérable d'un système électrochimique est $abs(Delta G)$.
]

= Réaction et courant électrique
== Courant électrique
Dans une pile ou un électrolyseur, la vitesse de réaction est liée au courant électrique.

#encadré(
    titre: "Lien courant – vitesse de réaction",
    connaitre: true,
    savoir-faire: true,
    hypothèses: "La réaction électrochimique s'effectue à la surface d'une électrode.",
    grandeurs: sub-dictionary(grandeurs, ("i", "cal(F)", "n", "xi")),
)[
    $ i = - n cal(F) dv(xi, t) $
    où $i$ est le courant #strong[arrivant] à l'électrode. On définit aussi $j = i \/ S$ la densité surfacique de courant.
]

#flashcard(recto: "Courant arrivant à une électrode", verso: "$ i = - n cal(F) dv(xi, t) $")

== Montage à trois électrodes
Pour mesurer le courant $i$ arrivant à une électrode en fonction de son potentiel, on utilise un montage à trois électrodes.

#schéma(titre: "Montage à trois électrodes", hauteur: 5cm)

Le voltmètre mesure la différence de potentiel entre l'électrode de travail et l'électrode de référence (potentiel fixe et connu), ce qui donne le potentiel $E$ de l'électrode de travail. Comme on ne peut pas faire circuler de courant dans l'électrode de référence sans l'endommager, une contre-électrode ferme le circuit. On obtient ainsi la courbe $i(E)$ point par point.

#question-de-colle("Établir la relation entre courant arrivant à une électrode et vitesse de réaction. Schématiser le montage à trois électrodes en expliquant le rôle de chaque électrode.")

== Courbes intensité-potentiel
Une courbe intensité-potentiel représente le courant arrivant à une électrode en fonction de son potentiel. Elle dépend du couple redox, des concentrations et de l'électrode utilisée.

#schéma(titre: "Allure d'une courbe intensité-potentiel", hauteur: 4cm)

#figure(image("images/i-e.png", height: 4cm), caption: [Courbes de l'eau sur une électrode de platine.])

- Pour $i = 0$ : la réaction est à l'équilibre, son potentiel $E_"eq"$ est donné par la formule de Nernst.
- Pour $i > 0$ : $v = - i \/ (n cal(F)) < 0$, la réaction évolue dans le sens indirect, l'électrode est une #strong[anode].
- Pour $i < 0$ : $v > 0$, la réaction évolue dans le sens direct, l'électrode est une #strong[cathode].

Une courbe mesurée est la somme des courants de toutes les réactions en cours : on ne peut pas savoir expérimentalement à quelle réaction participent les électrons.

=== Système rapide et système lent
Pour certains couples et certaines électrodes, un courant mesurable n'apparait qu'au-delà d'un écart au potentiel d'équilibre appelé #strong[surpotentiel] (ou surtension) : le système est alors #strong[lent]. Sa valeur dépend du seuil arbitraire de « courant mesurable ».

#schéma(titre: "Système rapide et système lent", hauteur: 4cm)

=== Paliers de diffusion
Les solutés sont transportés par diffusion (dans la couche limite), convection (au-delà) et migration (ions, en général négligeable). Lorsque le courant augmente, les réactifs peuvent manquer au voisinage de l'électrode : le courant est alors limité et un #strong[palier de diffusion] apparait.

#schéma(titre: "Palier de diffusion", hauteur: 4cm)

#encadré(
    titre: "Courant limite de diffusion",
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("i_text(\"max\")", "n", "cal(F)", "S", "D", "c", "delta")),
)[
    $ i_"max" = (n cal(F) S D c)/delta $
]

#question-de-colle("Expliquer ce qu'est un palier de diffusion et dans quels cas il apparait. Exprimer la hauteur d'un palier de diffusion en fonction de la concentration et de l'épaisseur de la couche limite.")

Lorsque le réactif ne peut pas manquer (solvant, ou électrode elle-même), il n'y a pas de palier de diffusion.

#application[
    Parmi les réactions suivantes, déterminer celles qui peuvent présenter un palier de diffusion : #ce("Fe^3+ + e^- -> Fe^2+"), #ce("Zn -> Zn^2+ + 2 e^-"), #ce("2 H2O -> O2 + 4 H+ + 4 e^-"), #ce("2 H+ + 2 e^- -> H2").
]

=== Mur du solvant
Si le solvant participe à un couple redox, on peut tracer sa courbe intensité-potentiel : le #strong[mur du solvant]. C'est le cas de l'eau, oxydant du couple #ce("H2O/H2") ($E^circ = qty("0", "V")$) et réducteur du couple #ce("O2/H2O") ($E^circ = qty("1.23", "V")$) ; ces courbes dépendent fortement de l'électrode, qui catalyse plus ou moins la réaction.

#schéma(titre: "Mur du solvant", hauteur: 4cm)

#application[
    Tracer l'allure de la courbe intensité-potentiel d'une électrode d'argent dans une solution de nitrate d'argent à $qty("0.01", "mol/L")$ acidifiée à $"pH" = 1$. Faire figurer le mur du solvant, les paliers de diffusion et les surpotentiels éventuels.
    Données : $E^circ(cpl("Ag+", "Ag")) = qty("0.80", "V")$, surpotentiel de #ce("H2O/H2") sur l'argent $qty("-0.22", "V")$, surpotentiel de #ce("O2/H2O") sur l'argent $qty("0.91", "V")$, #cpl("Ag+", "Ag") rapide.
]

= Piles, accumulateurs et électrolyseurs
== Présentation
Une #strong[pile] convertit de l'énergie chimique en énergie électrique : elle utilise une réaction spontanée pour faire circuler des électrons. Si la conversion est réversible, on parle d'#strong[accumulateur] (batterie). Une pile est constituée de deux demi-piles (une électrode plongée dans une solution).

#schéma(titre: "Pile", hauteur: 4cm)

#exemple[Piles : alcaline, au lithium, Daniell. Accumulateurs : Li-ion, au plomb.]

Un #strong[électrolyseur] convertit de l'énergie électrique en énergie chimique : une tension force une réaction à se produire dans le sens opposé au sens spontané (production de dihydrogène, d'aluminium…).

== Caractéristique
On construit la caractéristique d'une pile ou d'un électrolyseur à partir des courbes intensité-potentiel de ses deux électrodes.

#application[
    Pile Daniell (électrodes de cuivre et de zinc), courbes intensité-potentiel fournies. Quel courant maximal la pile peut-elle débiter ? Quelle est sa tension à vide ? Tracer sa caractéristique courant-tension pour les courants $\{0 ; 0,2 ; qty("0.4", "A")\}$, en faisant apparaitre la saturation en courant.
    #figure(image("images/courbes_i-E_Daniell.png", width: 85%))
]

#application[
    Le procédé chlore-soude produit de la soude, du dihydrogène et du dichlore à partir d'une solution de chlorure de sodium. Quelle tension minimale faut-il appliquer pour amorcer la réaction voulue ? Quel courant maximal peut-on faire passer ? Quelle tension imposer pour un courant de $qty("200", "A")$ ?
    #figure(image("images/courbes_i-E_chlore-soude.png", width: 85%))
]

La tension mesurée aux bornes d'une pile peut être plus faible que celle prévue par les courbes intensité-potentiel : une #strong[résistance interne], due surtout au pont ionique, s'y ajoute. Elle est d'autant plus faible que les ions sont mobiles et concentrés et que le pont salin est court.

== Capacité et masse électrolysée
La #strong[capacité] d'une pile est la quantité d'électricité qu'elle peut débiter avant d'atteindre l'équilibre chimique. Elle se mesure en coulombs, usuellement en ampères-heures ($qty("1", "A h") = qty("3600", "C")$), et se déduit d'un tableau d'avancement.

#application[
    Pile Daniell : électrode de cuivre dans $qty("100", "mL")$ de sulfate de cuivre à $qty("1", "mol/L")$, électrode de zinc dans $qty("100", "mL")$ de sulfate de zinc à $qty("1", "mol/L")$. Déterminer l'avancement à l'équilibre et en déduire la capacité de la pile.
    Données : $E^circ(cpl("Cu^2+", "Cu")) = qty("0.34", "V")$, $E^circ(cpl("Zn^2+", "Zn")) = qty("-0.76", "V")$.
]

#application[
    Un électrolyseur industriel produit $qty("7", "kg")$ de #ce("Al(s)") par jour à partir de #ce("Al^3+(aq)"). Déterminer le courant, en l'absence de réactions parasites. Donnée : $M(ce("Al")) = qty("27", "g/mol")$.
]

== Rendement faradique
Le #strong[rendement faradique] est la proportion des électrons participant à la réaction chimique désirée.

#flashcard(recto: "Rendement faradique", verso: "Proportion du courant participant à la réaction désirée.")

#application[
    Dans l'électrolyseur précédent, le courant réel est $qty("1000", "A")$. Déterminer le rendement faradique.
]

= Corrosion humide
== Présentation
La #strong[corrosion] est l'attaque d'un métal par son environnement, qui l'oxyde à l'état d'ions métalliques. Les principaux agents oxydants sont le dioxygène dissous et l'eau. La corrosion est d'autant plus rapide que le solvant est riche en ions et en dioxygène ; les microorganismes la favorisent aussi.

== Corrosion uniforme
La pièce est corrodée de façon homogène sur toute sa surface (solution acide, ou neutre oxygénée).

#exemple[En milieu acide : #ce("Fe(s) + 2 H+(aq) -> Fe^2+(aq) + H2(g)").]

=== Aspect thermodynamique
On superpose le diagramme potentiel-pH du métal et celui de l'eau. Trois cas :
/ Immunité : le métal a un domaine commun avec l'eau, aucune réaction, le métal n'est pas corrodé.
/ Corrosion : pas de domaine commun, l'espèce formée est un ion, le métal est corrodé jusqu'à disparition.
/ Passivation : pas de domaine commun, l'espèce formée est un solide qui recouvre et protège le métal ; la réaction s'arrête après la passivation.

#figure(grid(columns: 2, gutter: 6pt,
    image("images/bronze1.jpg", height: 4cm), image("images/bronze2.jpg", height: 4cm),
), caption: [Bronze poli, puis recouvert de vert-de-gris par passivation naturelle.])

#application[
    Pour le fer, l'or et l'aluminium, déterminer en fonction du pH s'il y a immunité, passivation ou corrosion. Les pointillés représentent les courbes potentiel-pH de l'eau.
    #figure(grid(columns: 1, gutter: 8pt,
        image("images/EpH-Fe.svg", height: 6cm),
        grid(columns: 2, gutter: 8pt, image("images/EpH-Au.svg", height: 6cm), image("images/EpH-Al.svg", height: 6cm)),
    ))
]

=== Aspect cinétique
La cinétique se déduit des courbes intensité-potentiel. Oxydation et réduction ayant lieu au même endroit, il n'y a qu'un seul potentiel, le #strong[potentiel de corrosion] (cas particulier de potentiel mixte). L'électrode restant neutre, les courants anodique et cathodique sont égaux : un seul point des courbes vérifie ces conditions.

#schéma(titre: "Potentiel de corrosion", hauteur: 5cm)

== Corrosion différentielle
Elle apparait quand deux métaux différents sont en contact, ou quand le milieu est inhomogène : c'est une #strong[pile de corrosion]. Oxydation et réduction ont alors lieu à des endroits différents.

#figure(image("images/i-E Fe Zn.svg", height: 6cm), caption: [Corrosion du zinc en présence de fer.])

== Protection contre la corrosion
=== Recouvrement
On recouvre le métal d'une substance étanche : peinture, métal (chromage, galvanisation…) ou oxyde métallique. La passivation peut être naturelle (zinc, aluminium) ou forcée par électrolyse.

=== Anode sacrificielle
On réalise volontairement une pile de corrosion : la pièce à protéger, reliée à une anode plus réductrice, devient cathode et ne peut plus s'oxyder.

#schéma(titre: "Protection par anode sacrificielle", hauteur: 4cm)

#figure(grid(columns: 3, gutter: 6pt,
    image("images/bateau1.jpg", height: 3.5cm),
    image("images/bateau2.jpg", height: 3.5cm),
    image("images/bateau3.jpg", height: 3.5cm),
), caption: [Anodes sacrificielles en zinc sur un bateau : en place, neuves, usées.])

#exemple[La galvanisation protège l'acier par recouvrement ; en cas de rayure, le zinc joue le rôle d'anode sacrificielle.]

=== Courant imposé
On impose un courant pour contrôler les réactions à l'électrode : #strong[protection cathodique] (augmenter le potentiel pour empêcher l'oxydation) ou #strong[protection anodique] (forcer une réaction de passivation).

#question-de-colle("Présenter trois méthodes permettant de protéger un métal de la corrosion.")
