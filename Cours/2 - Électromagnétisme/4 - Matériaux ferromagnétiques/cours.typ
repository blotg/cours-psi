#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)

#let grandeurs = (
    "va(cal(M))": (signification: "le moment magnétique", unité: unit("A m^2")),
    "cal(M)": (signification: "la norme du moment magnétique", unité: unit("A m^2")),
    "va(S)": (signification: "la surface orientée de la spire", unité: unit("m^2")),
    i: (signification: "l'intensité du courant électrique", unité: unit("A")),
    "va(B)": (signification: "le champ magnétique", unité: unit("T")),
    "mu_0": (signification: "la perméabilité magnétique du vide", unité: unit("H/m")),
    r: (signification: "la distance au dipôle", unité: unit("m")),
    theta: (signification: "l'angle entre le moment magnétique et la direction du point considéré", unité: unit("rad")),
    phi: (signification: "l'angle azimutal", unité: unit("rad")),
    K: (signification: "une constante propre à chaque ligne de champ", unité: unit("m")),
    "K'": (signification: "une constante propre à chaque ligne de champ", unité: unit("rad")),
    "cal(E)_p": (signification: "l'énergie potentielle d'interaction", unité: unit("J")),
    "va(B)_\"ext\"": (signification: "le champ magnétique extérieur", unité: unit("T")),
    "va(F)": (signification: "la force", unité: unit("N")),
    "va(Gamma)": (signification: "le couple", unité: unit("N m")),
    "n": (signification: "un entier naturel non nul", unité: "sans unité"),
    "k": (signification: "un entier relatif", unité: "sans unité"),
    "mu_B": (signification: "$=(hbar e)/(2 m_e)$ le magnéton de Bohr", unité: unit("A m^2")),
    "va(M)": (signification: "l'aimantation", unité: unit("A/m")),
    "delta va(cal(M))": (signification: "le moment magnétique contenu dans le volume $delta V$", unité: unit("A m^2")),
    "delta V": (signification: "un volume mésoscopique de matériau", unité: unit("m^3")),
    "va(j)_\"lié\"": (signification: "le vecteur densité volumique de courant lié", unité: unit("A/m^2")),
    "va(H)": (signification: "l'excitation magnétique", unité: unit("A/m")),
    "va(j)_\"libre\"": (signification: "le vecteur densité volumique de courant libre", unité: unit("A/m^2")),
    "cal(C)": (signification: "une courbe fermée orientée"),
    "va(dd(l))": (
        signification: "l'élément de longueur de $cal(C)$, orienté dans son sens de parcours",
        unité: unit("m"),
    ),
    "I_\"libre, enlacé\"": (signification: "le courant libre enlacé par $cal(C)$", unité: unit("A")),
    "mu": (signification: "$=mu_0 mu_r$ la perméabilité magnétique du matériau", unité: unit("H/m")),
    "mu_r": (signification: "la perméabilité relative du matériau", unité: "sans unité"),
    "u": (signification: "la tension aux bornes de l'enroulement", unité: unit("V")),
    "N": (signification: "le nombre de spires", unité: "sans unité"),
    "S": (signification: "la section du circuit magnétique", unité: unit("m^2")),
    "B": (signification: "le champ magnétique dans le matériau", unité: unit("T")),
    t: (signification: "le temps", unité: unit("s")),
    "H": (signification: "l'excitation magnétique dans le matériau", unité: unit("A/m")),
    "l": (signification: "la longueur du circuit magnétique", unité: unit("m")),
    "L": (signification: "l'inductance propre", unité: unit("H")),
    "w": (signification: "la densité volumique d'énergie magnétique", unité: unit("J/m^3")),
    "mean(cal(P)_\"hystérésis\")": (signification: "la puissance moyenne dissipée par hystérésis", unité: unit("W")),
    "V": (signification: "le volume du matériau", unité: unit("m^3")),
    "f": (signification: "la fréquence", unité: unit("Hz")),
    "cal(A)": (signification: "l'aire du cycle d'hystérésis", unité: unit("T A/m")),
    "B_\"entrefer\"": (signification: "le champ magnétique dans l'entrefer", unité: unit("T")),
    "e": (signification: "l'épaisseur de l'entrefer", unité: unit("m")),
)

= Moment magnétique d'un aimant permanent
== Dipôle magnétique
Une spire circulaire parcourue par un courant produit un champ magnétique caractérisé par son moment magnétique $va(cal(M))$.

#encadré(
    titre: "Moment magnétique d'une spire",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("va(cal(M))", "i", "va(S)")),
)[
    $ va(cal(M))=i va(S) $
]

#flashcard(
    recto: [Moment magnétique d'une spire],
    verso: [$va(cal(M))=i va(S)$],
)

#question-de-début-de-cours(
    "Le moment magnétique d'une spire parcourue par un courant s'écrit",
    (
        "$i va(S)$",
        "$mu_0/(4 pi r^3) vec(2 cos(theta), sin(theta), 0)$",
        "$- grad cal(E)_p$",
        "$va(cal(M)) and va(B)$",
    ),
)

#question-de-début-de-cours(
    "Lequel de ces systèmes ne possède PAS de moment magnétique ?",
    (
        "un champ magnétique",
        "un dipôle magnétique",
        "une spire parcourue par un courant",
        "un aimant",
    ),
)

Si on fait tendre vers $0$ le rayon d'une spire circulaire en gardant constant son moment magnétique, on obtient un dipôle magnétique.

Le dipôle magnétique est un système ponctuel. Le dipôle magnétique est le plus simple système ayant un moment magnétique.

#grid(
    columns: 3,
    column-gutter: 1fr,
    figure(
        image(width: 90%, "Simulations/spire.svg"),
        caption: "Spire",
    ),
    figure(
        image(width: 90%, "Simulations/dipole.svg"),
        caption: "Dipôle magnétique",
    ),
    figure(
        image(width: 90%, "Simulations/aimant.svg"),
        caption: "Aimant",
    ),
)

Les champs magnétiques créés par une spire, un dipôle magnétique et un aimant sont similaires lorsqu'on se place suffisamment loin du système.

#encadré(
    titre: "Champ magnétique créé par un dipôle magnétique",
    grandeurs: sub-dictionary(grandeurs, ("va(B)", "mu_0", "cal(M)", "r", "theta")),
    hypothèses: (
        [Le moment magnétique est orienté selon $va(e_z)$.],
        [Le système de coordonnées est sphérique.],
    ),
)[
    $
        va(B)=(mu_0)/(4 pi) cal(M)/(r^3) vec(
            2 cos theta,
            sin theta,
            0
        )
    $
]

#encadré(
    titre: "Équation des lignes de champ magnétique créées par un dipôle magnétique",
    grandeurs: sub-dictionary(grandeurs, ("r", "theta", "phi", "K", "K'")),
    savoir-faire: true,
    hypothèses: (
        [Le moment magnétique est orienté selon $va(e_z)$.],
        [Le système de coordonnées est sphérique.],
    ),
)[
    $ r=K sin^2 theta $
    $ phi = K' $
]

#application[
    Tracer l'allure des lignes de champ magnétique créées par un dipôle magnétique.
]

#application[
    À l'aide de Python, tracer l'allure des lignes de champ magnétique créées par un dipôle magnétique.
]

#question-de-colle(
    [Le champ magnétique créé par un dipôle magnétique étant fourni, déterminer l'équation des lignes de champ puis tracer leur allure.],
)

== Champ créé par un aimant

#question-de-début-de-cours(
    "Quimper a pour coordonnées 47°59′ N, 4°05′ O. L'angle $theta$ des coordonnées sphériques y vaut",
    (
        "42,02°",
        "47,98°",
        "47,59°",
        "42,41°",
    ),
)

Si on se place suffisamment loin, les champs créés par un aimant, par une spire et par un dipôle magnétique sont similaires. On définit le moment magnétique d'un aimant comme le moment magnétique du dipôle magnétique ayant le même champ magnétique à grande distance.

#application[
    Déterminer la norme du champ magnétique à la surface de la terre à Quimper ($47°59'N, 4°05'O$). On donne $cal(M)_"Terre"=#quan[7.7e22 A m^2]$ et $R_"Terre"=#quan[6400 km]$.
]

== Action subie par un moment magnétique
Lorsqu'un système possédant un moment magnétique est placé dans un champ magnétique extérieur, il subit des actions de sa part.

#encadré(
    titre: "Énergie potentielle d’interaction entre un système possédant un moment magnétique et un champ magnétique extérieur",
    grandeurs: sub-dictionary(grandeurs, ("cal(E)_p", "va(cal(M))", "va(B)_\"ext\"")),
)[
    $ cal(E)_p = - va(cal(M)).va(B)_"ext" $
]

L'énergie potentielle est minimale lorsque le moment magnétique est aligné au champ. Un moment magnétique a tendance à s'aligner au champ magnétique.

#encadré(
    titre: "Force subie par un système possédant un moment magnétique",
    grandeurs: sub-dictionary(grandeurs, ("va(F)", "cal(E)_p")),
)[
    $ va(F) = - grad cal(E)_p $
]

#encadré(
    titre: "Couple subi par un système possédant un moment magnétique",
    grandeurs: sub-dictionary(grandeurs, ("va(Gamma)", "va(cal(M))", "va(B)_\"ext\"")),
)[
    $ va(Gamma) = va(cal(M)) and va(B)_"ext" $
]

On retrouve un couple nul lorsque le moment magnétique est aligné avec le champ magnétique.

#application[
    Déterminer la période des petites oscillations d'une aiguille de boussole autour de sa position d'équilibre. L'aiguille a un moment magnétique de norme $cal(M)=#quan[0.2 A m^2]$ et un moment d'inertie $J=#quan[1e-6 kg m^2]$ par rapport à l'axe vertical de la liaison pivot, supposée idéale, qui la relie à son support. La composante horizontale du champ magnétique terrestre vaut $B_h=#quan[2e-5 T]$ à Quimper.
]

#encadré(
    titre: "Quantification du moment magnétique atomique",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [L'électron décrit une trajectoire circulaire autour d'un noyau.],
        [L'électron a un moment cinétique quantifié $L=n hbar$ avec $n in NN^*$.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("cal(M)", "n", "mu_B", "k")),
)[
    $ cal(M)=k mu_B $
]

#flashcard(
    recto: [Quantification du moment magnétique atomique],
    verso: [$cal(M)=k mu_B$],
)

#question-de-colle(
    [Établir l'expression du moment magnétique atomique quantifié dans le modèle de Bohr en introduisant le magnéton de Bohr.],
)

= Équations de Maxwell dans un milieu magnétique
== Aimantation

Les particules qui constituent la matière peuvent porter un moment magnétique (moment magnétique orbital des électrons, spin des électrons et des noyaux).

L'aimantation est le moment magnétique par unité de volume.

#encadré(
    titre: "Définition de l'aimantation",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("va(M)", "delta va(cal(M))", "delta V")),
)[
    $ va(M) = (delta va(cal(M)))/(delta V) $
]

#flashcard(
    recto: [Définition de l'aimantation],
    verso: [$va(M) = (delta va(cal(M)))/(delta V)$],
)

Il est possible de définir des courants fictifs $va(j)_"lié"$ qui, s'ils existaient, créeraient le même champ magnétique que l'aimantation $va(M)$.

#encadré(
    titre: "Courants liés",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("va(j)_\"lié\"", "va(M)")),
)[
    $ va(j)_"lié" = rot va(M) $
]

#flashcard(
    recto: [Courants liés],
    verso: [Courants qui, s'ils existaient, créeraient le même champ magnétique que l'aimantation $ va(j)_"lié" = rot va(M) $],
)

== Vecteur excitation magnétique
Les effets de l'aimantation sont pris en compte dans les équations de Maxwell à travers les courants liés. On les regroupe en définissant l'excitation magnétique.

#encadré(
    titre: "Définition de l'excitation magnétique",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("va(H)", "va(B)", "mu_0", "va(M)")),
)[
    $ va(H)= (va(B))/(mu_0) - va(M) $
]

#flashcard(
    recto: [Définition de l'excitation magnétique],
    verso: [$va(H)= (va(B))/(mu_0) - va(M)$],
)

#encadré(
    titre: "Équation de Maxwell-Ampère dans un milieu magnétique",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [Dans l'ARQS magnétique.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("va(H)", "va(j)_\"libre\"")),
)[
    $ rot va(H)=va(j)_"libre" $
]

#flashcard(
    recto: [Équation de Maxwell-Ampère dans un milieu magnétique],
    verso: [Dans l'ARQS magnétique, $rot va(H)=va(j)_"libre"$],
)

#question-de-début-de-cours(
    "L'équation de Maxwell-Ampère s'écrit, dans un matériau magnétique",
    (
        "$rot va(H) = va(j)_\"libre\"$",
        "$rot va(B) = va(j)_\"libre\"$",
        "$rot va(H) = mu_0 va(j)_\"libre\"$",
        "$rot va(B) = mu_0 va(j)_\"libre\"$",
    ),
)

#question-de-colle(
    [Définir l'aimantation, les courants liés et l'excitation magnétique et établir l'équation de Maxwell-Ampère valables dans les milieux magnétiques.],
)

Les sources de l’excitation magnétique sont donc les courants électriques libres.

Les sources du champ magnétique sont les courants électriques libres et l’aimantation.

== Équations de Maxwell intégrées
Dans les milieux magnétiques, l'équation de Maxwell-Faraday est inchangée donc la loi de Lenz-Faraday $e=-dv(Phi, t)$ s'applique toujours.

Dans les milieux magnétiques, l'équation de Maxwell-Thomson est inchangée donc le champ magnétique $va(B)$ est toujours à flux conservatif.

#encadré(
    titre: "Théorème d'Ampère dans un milieu magnétique",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [Dans l'ARQS magnétique.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("cal(C)", "va(H)", "va(dd(l))", "I_\"libre, enlacé\"")),
)[
    $ integral.cont_cal(C) va(H) dot va(dd(l)) = I_"libre, enlacé" $
]

#flashcard(
    recto: [Théorème d'Ampère dans un milieu magnétique],
    verso: [$integral.cont_cal(C) va(H) dot va(dd(l)) = I_"libre, enlacé"$],
)

= Milieux ferromagnétiques
== Présentation
Un matériau ferromagnétique est un matériau dans lequel les moments magnétiques atomiques (de spin, orbitaux…) s'alignent spontanément entre eux, en dessous d'une température appelée température de Curie. Dans un milieu ferromagnétique, l'aimantation $va(M)$ et le champ magnétique $va(B)$ croissent avec l'excitation magnétique $va(H)$.

Un matériau ferromagnétique canalise les lignes de champ magnétique. Lorsque des lignes de champ sortent d'un matériau ferromagnétique, elles sortent perpendiculairement à l'interface.

// Largeurs proportionnelles à l'étendue de chaque simulation : les trois
// circuits, larges de 10 cm, sont dessinés à la même échelle.
#grid(
    columns: (26%, 38%, 30%),
    column-gutter: 1fr,
    align: bottom + center,
    figure(
        image(width: 100%, "Simulations/sans entrefer.svg"),
        caption: "Circuit magnétique sans entrefer.",
    ),
    figure(
        image(width: 100%, "Simulations/entrefer.svg"),
        caption: "Circuit magnétique avec un entrefer.",
    ),
    figure(
        image(width: 100%, "Simulations/électroaimant.svg"),
        caption: "Électroaimant à deux entrefers.",
    ),
)

== Présentation empirique : le cycle d'hystérésis
Pour un matériau ferromagnétique, le champ magnétique $va(B)$ et l'aimantation $va(M)$ dépendent de l'excitation magnétique. Cette dépendance comporte une hystérésis.

#schéma(titre: "Cycle d'hystérésis", hauteur: 5cm)

L'aimantation peut saturer, ce qui correspond à un état où tous les dipôles magnétiques sont orientés dans le même sens que l'excitation magnétique $va(H)$.

L'aimantation rémanente et le champ magnétique rémanent sont l'aimantation et le champ magnétique subsistant lorsque l'excitation magnétique est nulle.

L'excitation coercitive est l'excitation qu'il faut appliquer pour que le champ magnétique et l'aimantation soient nuls#footnote[En toute rigueur, l'excitation magnétique qu'il faut pour avoir $B=0$ n'est pas exactement celle qu'il faut appliquer pour avoir $M=0$, mais elles sont très proches.].

Un matériau ferromagnétique dur est un matériau ferromagnétique dont le cycle d'hystérésis est large.

#schéma(titre: "Cycle d'hystérésis d'un matériau ferromagnétique dur", hauteur: 3cm)

Un matériau dur a une grande aimantation rémanente et un grand champ magnétique rémanent.

Les matériaux ferromagnétiques durs sont utilisés pour fabriquer des aimants permanents.

#exemple[Les alliages à base de néodyme (NdFeB) et les alnicos sont des matériaux ferromagnétiques durs.]

#flashcard(
    recto: [Matériau ferromagnétique dur],
    verso: [Cycle d'hystérésis large, grande aimantation rémanente et un grand champ magnétique rémanent. Exemples : alliages au néodyme, alnicos],
)

#question-de-début-de-cours(
    "Pour fabriquer un aimant permanent, on utilise un matériau",
    (
        "ferromagnétique dur",
        "ferromagnétique doux",
        "non magnétique",
        "isolant",
    ),
)

== Matériaux ferromagnétiques doux
Un matériau ferromagnétique doux est un matériau ferromagnétique dont le cycle d'hystérésis est fin et linéaire dans une certaine zone.

Les matériaux ferromagnétiques doux sont utilisés pour fabriquer les transformateurs et les machines électriques.

#exemple[Le fer doux et la ferrite sont des matériaux ferromagnétiques doux.]

#flashcard(
    recto: [Matériau ferromagnétique doux],
    verso: [Cycle d'hystérésis étroit, faible aimantation rémanente et un faible champ magnétique rémanent. Exemples : fer doux, ferrite],
)

#question-de-début-de-cours(
    "Pour limiter les pertes par hystérésis",
    (
        "on utilise un matériau doux.",
        "on travaille hors de la zone de saturation.",
        "on utilise le feuilletage.",
        "on utilise un bon conducteur électrique.",
    ),
)

#schéma(titre: "Cycle d'hystérésis d'un matériau ferromagnétique doux", hauteur: 3cm)

#encadré(
    titre: "Perméabilité magnétique",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("va(B)", "mu", "va(H)")),
    hypothèses: (
        [Pour un matériau ferromagnétique doux.],
        [Dans la zone de linéarité d'un matériau ferromagnétique doux.],
    ),
)[
    $ va(B) = mu va(H) $
]

#flashcard(
    recto: [Conditions auxquelles $ va(B)= mu va(H) $],
    verso: [Matériau doux, hors saturation.],
)

#question-de-début-de-cours(
    "Dans quel cas a-t-on $va(B) = mu va(H)$ ?",
    (
        "Pour un matériau doux, hors de la zone de saturation.",
        "Pour un matériau doux, dans la zone de saturation.",
        "Pour un matériau dur, hors de la zone de saturation.",
        "Pour un matériau dur, dans la zone de saturation.",
    ),
)

La perméabilité magnétique relative d'un matériau ferromagnétique doux est très grande : $mu_r$ va de $10^3$ à $10^5$ (de l'ordre de $10^3$ à $10^4$ pour le fer doux, jusqu'à $10^5$ pour le mu-métal).

= Circuits ferromagnétiques
== Circuit magnétique sans entrefer
=== Présentation générale
Un circuit magnétique sans entrefer est constitué d'un matériau ferromagnétique formant une boucle autour duquel est enroulé un fil parcouru par un courant électrique.

#schéma(titre: "Circuit magnétique sans entrefer", hauteur: 4cm)
Le matériau guide les lignes de champ, elles ont donc une forme similaire à celle du circuit magnétique. Pour étudier le système, on s'intéresse à une ligne de champ moyenne.

=== Relations entre grandeurs électriques et électromagnétiques
#encadré(
    titre: "Relation champ magnétique - tension",
    savoir-faire: true,
    hypothèses: (
        [Dans l'ARQS magnétique.],
        [Le circuit magnétique a une section constante $S$.],
        [Le circuit magnétique ne comporte pas d'entrefer.],
        [Le champ magnétique est uniforme dans le matériau ferromagnétique.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("u", "N", "S", "B", "t")),
)[
    $ u = N S dv(B, t) $
]

Cette relation est mise à profit pour mesurer le champ magnétique et tracer le cycle d'hystérésis : intégrer la tension donne le champ magnétique.

#encadré(
    titre: "Relation excitation magnétique - courant",
    savoir-faire: true,
    hypothèses: (
        [Dans l'ARQS magnétique.],
        [Le circuit magnétique a une section constante $S$.],
        [Le circuit magnétique ne comporte pas d'entrefer.],
        [L'excitation magnétique est uniforme dans le matériau ferromagnétique.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("H", "l", "N", "i")),
)[
    $ H l = N i $
]

#question-de-colle(
    [Établir la relation tension-champ magnétique et la relation courant-excitation magnétique pour un circuit magnétique sans entrefer. Expliquer comment tracer un cycle d'hystérésis expérimentalement.],
)

Cette relation est mise à profit pour mesurer l'excitation magnétique et tracer le cycle d'hystérésis.

#import "@preview/wrap-it:0.1.1": wrap-content
#wrap-content(align: right)[
    #lien("https://upload.wikimedia.org/wikipedia/commons/8/81/Power_Transformer_Over-Excitation.gif")
][
    Si la tension $u$ aux bornes de l'enroulement est sinusoïdale, cela n'implique pas que l'intensité du courant $i$ le soit également. Si le matériau ferromagnétique est doux et hors saturation, alors l'intensité du courant est également sinusoïdale : elle est proportionnelle à $B$, donc à une primitive de $u$.
]

== Bobine à noyau ferromagnétique
Le circuit magnétique sans entrefer peut être utilisé pour réaliser une bobine. Pour cela, on utilise un matériau ferromagnétique doux hors saturation.

=== Inductance propre

#encadré(
    titre: "Inductance propre d'une bobine avec noyau ferromagnétique",
    savoir-faire: true,
    hypothèses: (
        [Dans l'ARQS magnétique.],
        [L'excitation magnétique et le champ magnétique sont uniformes dans le matériau ferromagnétique.],
        [Le matériau ferromagnétique est doux et hors saturation.],
        [Le circuit magnétique ne comporte pas d'entrefer.],
        [Le circuit magnétique a une section constante.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("L", "N", "S", "mu", "l")),
)[
    $ L = (N^2 S mu)/(l) $
]

Cette inductance propre est $mu_r >> 1$ fois plus grande que celle d'un tore sans cœur ferromagnétique de dimensions équivalentes.

=== Aspect énergétique

#encadré(
    titre: "Densité volumique d'énergie magnétique dans un matériau ferromagnétique doux",
    savoir-faire: true,
    connaitre: true,
    hypothèses: (
        [Dans l'ARQS magnétique.],
        [Le matériau ferromagnétique est doux et hors saturation.],
        [La formule établie pour un circuit magnétique sans entrefer peut être généralisée.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("w", "B", "mu_0", "mu_r")),
)[
    $ w = (1)/(2 mu_0 mu_r) B^2 $
]

#question-de-colle(
    [Établir le champ magnétique dans une bobine ayant un cœur magnétique. En déduire son inductance propre. En déduire dans ce cas particulier la densité volumique d'énergie magnétique.],
)

=== Pertes
La présence d'un milieu ferromagnétique au cœur de la bobine induit des pertes.

#encadré(
    titre: "Pertes par hystérésis",
    savoir-faire: true,
    hypothèses: (
        [Dans l'ARQS magnétique.],
        [L'excitation magnétique et le champ magnétique sont uniformes dans le matériau ferromagnétique.],
        [Le circuit magnétique a une section constante.],
        [Le circuit magnétique ne comporte pas d'entrefer.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("mean(cal(P)_\"hystérésis\")", "V", "f", "cal(A)")),
)[
    $ mean(cal(P)_"hystérésis") = V f cal(A) $
]

#question-de-colle(
    [Établir la puissance moyenne des pertes par hystérésis. Citer les différents types de pertes existant dans un circuit magnétique.],
)

Pour limiter les pertes par hystérésis, on utilise des matériaux ferromagnétiques doux.

Le circuit magnétique étant un conducteur électrique placé dans un champ magnétique variable, des courants de Foucault y sont induits. Pour limiter les pertes par courants de Foucault, on utilise le feuilletage.

Pertes par courants de Foucault et pertes par hystérésis sont appelées les *pertes fer* car elles se produisent dans le matériau ferromagnétique.

Des pertes par effet Joule se produisent également dans le bobinage, souvent réalisé en cuivre. Les pertes par effet Joule sont appelées pertes cuivre.

== Circuit magnétique avec entrefer
Un entrefer est une zone de l'espace vide#footnote[Vide de matériau ferromagnétique.] au sein du circuit magnétique. Un circuit magnétique avec entrefer est appelé un électroaimant car il permet de réaliser un champ magnétique dans une zone de l'espace grâce à un courant électrique.

#schéma(titre: "Circuit magnétique avec entrefer", hauteur: 4cm)

#encadré(
    titre: "Champ magnétique dans l'entrefer d'un électroaimant",
    savoir-faire: true,
    hypothèses: (
        [Dans l'ARQS magnétique.],
        [L'excitation magnétique et le champ magnétique sont uniformes dans le matériau ferromagnétique.],
        [Le circuit magnétique a une section constante.],
        [Les effets de bord sont négligés dans l'entrefer#footnote[Autrement dit, l'épaisseur de l'entrefer est très petite devant toutes les autres dimensions.].],
        [Le matériau ferromagnétique est doux et hors saturation.],
        [La perméabilité du matériau est assez grande pour que $mu_r >> l/e$.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("B_\"entrefer\"", "mu_0", "N", "i", "e", "mu_r", "l")),
)[
    $ B_"entrefer"=(mu_0 N i)/e $
]

#question-de-colle([Établir l'expression du champ magnétique dans l'entrefer d'un électroaimant.])
