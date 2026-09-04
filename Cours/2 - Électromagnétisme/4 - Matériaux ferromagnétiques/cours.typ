#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)

#let grandeurs = (
    "cal(M)": (signification: "le moment magnétique", unité: unit("A m^2")),
    "va(S)": (signification: "la surface orientée", unité: unit("m^2")),
    i: (signification: "le courant électrique", unité: unit("A")),
    "B": (signification: "le champ magnétique", unité: unit("T")),
    "mu_0": (signification: "la perméabilité magnétique du vide", unité: unit("H/m")),
    "cal(E)_p": (signification: "l'énergie potentielle d'interaction", unité: unit("J")),
    "va(B)_\"ext\"": (signification: "le champ magnétique extérieur", unité: unit("T")),
    "va(F)": (signification: "la force", unité: unit("N")),
    "va(Gamma)": (signification: "le couple", unité: unit("N m")),
    "mu_B": (signification: "$=(hbar e)/(2 m_e)$ le magnéton de Bohr", unité: unit("A m^2")),
    "M": (signification: "l'aimantation", unité: unit("A/m")),
    "H": (signification: "l'excitation magnétique", unité: unit("A/m")),
    "va(j)_\"lié\"": (signification: "le vecteur densité volumique de courant lié", unité: unit("A/m^2")),
    "va(j)_\"libre\"": (signification: "le vecteur densité volumique de courant libre", unité: unit("A/m^2")),
    "I_\"libre, enlacé\"": (signification: "le courant libre enlacé", unité: unit("A")),
    "mu": (signification: "$=mu_0 mu_r$ la perméabilité magnétique du matériau", unité: unit("H/m")),
    "N": (signification: "le nombre de spires", unité: "sans unité"),
    "l": (signification: "la longueur du circuit magnétique", unité: unit("m")),
    "L": (signification: "l'inductance propre", unité: unit("H")),
    "S": (signification: "la section du circuit magnétique", unité: unit("m^2")),
    "w": (signification: "la densité volumique d'énergie magnétique", unité: unit("J/m^3")),
    "mu_r": (signification: "la perméabilité relative du matériau", unité: "sans unité"),
    "cal(P)_\"hystérésis\"": (signification: "la puissance dissipée par hystérésis", unité: unit("W")),
    "V": (signification: "le volume du matériau", unité: unit("m^3")),
    "f": (signification: "la fréquence", unité: unit("Hz")),
    "cal(A)": (signification: "l'aire du cycle d'hystérésis", unité: unit("T A/m")),
    "e": (signification: "l'épaisseur de l'entrefer", unité: unit("m")),
    "B_\"entrefer\"": (signification: "le champ magnétique dans l'entrefer", unité: unit("T")),
    "n": (signification: "un entier relatif", unité: "sans unité"),
)

= Moment magnétique d'un aimant permanent
== Dipole magnétique
Une spire circulaire parcourue par un courant produit un champ magnétique caractérisé par son moment magnétique $va(cal(M))$.

#encadré(
    titre: "Moment magnétique d'une spire",
    connaitre: true,
    grandeurs: grandeurs,
)[
    $ va(cal(M))=i va(S) $
]

#flashcard(
    recto: "Moment magnétique d'une spire",
    verso: "$va(cal(M))=i va(S)$",
)

Si on fait tendre vers $0$ le rayon d'une spire circulaire en gardant constant son moment magnétique, on obtient un dipole magnétique.

Le dipole magnétique est un système ponctuel. Le dipole magnétique est le plus simple système ayant un moment magnétique.

#grid(
    columns: 3,
    column-gutter: 1fr,
    figure(
        image(width: 90%, "images/spire.svg"),
        caption: "Spire",
    ),
    figure(
        image(width: 90%, "images/dipole.svg"),
        caption: "Dipole magnétique",
    ),
    figure(
        image(width: 90%, "images/aimant.png"),
        caption: "Aimant",
    ),
)

Les champs magnétiques créés par une spire, un dipole magnétique et un aimant sont similaires lorsqu'on se place suffisamment loin du système.

#encadré(
    titre: "Champ magnétique créé par un dipole magnétique",
    grandeurs: grandeurs,
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
    titre: "Équation des lignes de champ magnétique créées par un dipole magnétique",
    grandeurs: grandeurs,
    hypothèses: (
        [Le moment magnétique est orienté selon $va(e_z)$.],
        [Le système de coordonnées est sphérique.],
    ),
)[
    $ r=K sin^2 theta $
    $ phi = K' $
]

#application[
    Tracer l'allure des lignes de champ magnétique créées par un dipole magnétique.
]

#application[
    À l'aide de Python, tracer l'allure des lignes de champ magnétique créées par un dipole magnétique.
]

#question-de-colle(
    "Le champ magnétique créé par un dipole magnétique étant fourni, déterminer l'équation des lignes de champ puis tracer leur allure.",
)

== Champ créé par un aimant

Si on se place suffisamment loin, le champ créé par un aimant, par une spire et par un dipole magnétique sont similaire. On définit le moment magnétique d'un aimant comme le moment magnétique du dipole magnétique ayant le même champ magnétique à grande distance

#application[
    Déterminer la norme du champ magnétique à la surface de la terre à Quimper ($47°59'N, 4°05'O$). On donne $cal(M)_"Terre"=qty("7.7e22", "A/.m^2")$ et $R_"Terre"=qty("6400", "km")$.
]

== Action subie par un moment magnétique
Lorsqu'un système possédant un moment magnétique est placé dans champ magnétique extérieur, il subit des actions de sa part.

#encadré(
    titre: "Énergie potentielle d’interaction entre un système possédant un moment magnétique et un champ magnétique extérieur",
    grandeurs: grandeurs,
)[
    $ cal(E)_p = - va(cal(M)).va(B)_"ext" $
]

L'énergie potentielle est minimales lorsque le moment magnétique est aligné au champ. Un moment magnétique a tendance à s'aligner au champ magnétique.

#encadré(
    titre: "Force subie par un système possédant un moment magnétique",
    grandeurs: grandeurs,
)[
    $ va(F) = - grad cal(E)_p $
]

#encadré(
    titre: "Couple subi par un système possédant un moment magnétique",
    grandeurs: grandeurs,
)[
    $ va(Gamma) = va(cal(M)) and va(B)_"ext" $
]

On retrouve un couple nul lorsque le moment magnétique est aligné avec le champ magnétique.

#application[
    Déterminer la période d'oscillation d'une aiguille de boussole ($va(cal(M))=qty("15", "A m^2") va(e_r)$, $J=qty("1e-4", "kg/m^2")$ selon $va(e_r)$) dans le champ magnétique terrestre. La liaison pivot entre l'aiguille et son support est supposée idéale.
]

#encadré(
    titre: "Quantification du moment magnétique atomique",
    connaitre: true,
    savoir-faire: true,
    grandeurs: grandeurs,
    hypothèses: (
        [L'électron décrit une trajectoire circulaire autour d'un noyau.],
        [L'électron a un moment cinétique quantifié $L=n hbar$ avec $n in NN^*$.],
    ),
)[
    $ cal(M)=n mu_B $
]

#flashcard(
    recto: "Quantification du moment magnétique atomique",
    verso: "$cal(M)=n mu_B$",
)

#question-de-colle(
    "Établir l'expression du moment magnétique atomique quantifié dans le modèle de Bohr en introduisant le magnéton de Bohr.",
)

= Équations de Maxwell dans un milieu magnétique
== Aimantation

Les particules qui constituent la matière peuvent porter un moment magnétique (moment magnétique orbital des électrons, spin des électrons et des noyaux).

L'aimantation est le moment magnétique par unité de volume.

#encadré(
    titre: "Définition de l'aimantation",
    connaitre: true,
    grandeurs: grandeurs,
)[
    $ va(M) = (delta va(cal(M)))/(delta V) $
]

#flashcard(
    recto: "Définition de l'aimantation",
    verso: "$va(M) = (delta va(cal(M)))/(delta V)$",
)

Il est possible de définir des courants fictifs $va(j)_"lié"$ qui, s'ils existaient, donneraient lieu à la même aimantation $va(M)$

#encadré(
    titre: "Courants liés",
    connaitre: true,
    grandeurs: grandeurs,
)[
    $ va(j)_"lié" = rot va(M) $
]

#flashcard(
    recto: "Courants liés",
    verso: "Courants qui, s'ils existaient, donneraient lieu à la même aimantation $ va(j)_\"lié\" = rot va(M) $",
)

== Vecteur excitation magnétique
Les effets de l'aimantation sont pris en compte dans les équations de Maxwell à travers les courants liés.

#encadré(
    titre: "Équation de Maxwell-Ampère dans un milieu magnétique",
    connaitre: true,
    savoir-faire: true,
    grandeurs: grandeurs,
)[
    $ rot va(H)=va(j)_"libre" $
]

#flashcard(
    recto: "Équation de Maxwell-Ampère dans un milieu magnétique",
    verso: "$rot va(H)=va(j)_\"libre\"$",
)
#flashcard(
    recto: "Définition de l'excitation magnétique",
    verso: "$va(H)= (va(B))/(mu_0) - va(M)$",
)

#question-de-colle(
    "Définir l'aimantation, les courants liés et l'excitation magnétique et établir l'équation de Maxwell-Ampère valable dans les milieux magnétique.",
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
    grandeurs: grandeurs,
)[
    $ integral.cont_cal(C) va(H) dot va(dd(l)) = I_"libre, enlacé" $
]

#flashcard(
    recto: "Théorème d'Ampère dans un milieu magnétique",
    verso: "$integral.cont_cal(C) va(H) dot va(dd(l)) = I_\"libre, enlacé\"$",
)

= Milieux ferromagnétiques
== Présentation
Un matériau ferromagnétique est un matériau dans lequel les dipoles magnétiques (de spin, orbital, ...) ont tendance à s'aligner sur le champ magnétique extérieur. Dans un milieu ferromagnétique, l'aimantation $va(M)$ et le champ magnétique $va(B)$ croient avec l'excitation magnétique $va(H)$.

Un matériau ferromagnétique canalise les lignes de champ magnétique. Lorsque des lignes de champ sortent d'un matériau ferromagnétique, elles sortent perpendiculairement à l'interface.

#grid(
    columns: (55%, 40%),
    column-gutter: 1fr,
    align: bottom + center,
    figure(
        image(width: 100%, "images/ferromagnétique.png"),
        caption: "Lignes de champ magnétique dans un circuit magnétique sans entrefer.",
    ),
    figure(
        image(width: 100%, "images/électroaimant.svg"),
        caption: "Lignes de champ magnétique dans un circuit magnétique avec deux entrefers.",
    ),
)

== Présentation empirique : le cycle d'hystérésis
Pour un matériau ferromagnétique, le champ magnétique $va(B)$ et l'aimantation $va(M)$ dépendent de l'excitation magnétique. Cette dépendance comporte une hystérésis.

#schéma(titre: "Cycle d'hystérésis")[#box(height: 5cm)]

L'aimantation peut saturer, ce qui correspond à un état où tous les dipoles magnétiques sont orientés dans le même sens que l'excitation magnétique $va(H)$.

L'aimantation rémanente et le champ magnétique rémanent sont l'aimantation et le champ magnétique subsistant lorsque l'excitation magnétique est nul.

L'excitation coercitive est l'excitation qu'il faut appliquer pour que le champ magnétique et l'aimantation soient nulles#footnote[En toute rigueur, l'excitation magnétique qu'il faut pour avoir $B=0$ n'est pas exactement celle qu'il faut appliquer pour avoir $M=0$, mais elles sont très proches.].

Un matériau ferromagnétique dur est un matériau ferromagnétique dont le cycle d'hystérésis est large.

#schéma(titre: "Cycle d'hystérésis d'un matériau ferromagnétique dur")[#box(height: 3cm)]

Un matériau dur a une grande aimantation rémanente et un grand champ magnétique rémanent.

Les matériaux ferromagnétiques durs sont utilisés pour fabriquer des aimants permanents.

#exemple[Le fer et les alliages à base de néodyme sont des matériaux ferromagnétiques durs.]

#flashcard(
    recto: "Matériau ferromagnétique dur",
    verso: "Cycle d'hystérésis large, grande aimantation rémanente et un grand champ magnétique rémanent. Exemples : fer, alliages au néodyme",
)

== Matériaux ferromagnétiques doux
Un matériau ferromagnétique doux est un matériau ferromagnétique dont le cycle d'hystérésis est fin et linéaire dans une certaine zone.

Les matériaux ferromagnétiques doux sont utilisés pour fabriquer les transformateurs et les machines électriques.

#exemple[La ferrite est un matériau ferromagnétique doux.]

#flashcard(
    recto: "Matériau ferromagnétique doux",
    verso: "Cycle d'hystérésis étroit, faible aimantation rémanente et un faible champ magnétique rémanent. Exemples : ferrite",
)

#schéma(titre: "Cycle d'hystérésis d'un matériau ferromagnétique doux")[#box(height: 3cm)]

#encadré(
    titre: "Perméabilité magnétique",
    connaitre: true,
    grandeurs: grandeurs,
    hypothèses: (
        [Pour un matériau ferromagnétique doux.],
        [Dans la zone de linéarité d'un matériau ferromagnétique doux.],
    ),
)[
    $ va(B) = mu va(H) $
]

#flashcard(
    recto: "Conditions auxquelles $ va(B)= mu va(H) $",
    verso: "Matériau doux, hors saturation.",
)

La perméabilité magnétique relative est de l'ordre de $mu_r tilde.op 10^5$.

= Circuits ferromagnétiques
== Circuit magnétique sans entrefer
=== Présentation générale
Un circuit magnétique sans entrefer est constitué d'un matériau ferromagnétique formant une boucle autour duquel est enroulé un fil parcourant par un courant électrique.

#schéma(titre: "Circuit magnétique sans entrefer")[#box(height: 4cm)]
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
    grandeurs: grandeurs,
)[
    $ va(B) = mu va(H) $
]

Cette relation est mise à profit pour mesurer le champ magnétique et tracer le cycle d'hystérésis.

#encadré(
    titre: "Relation excitation magnétique - courant",
    savoir-faire: true,
    hypothèses: (
        [Dans l'ARQS magnétique.],
        [Le circuit magnétique a une section constante $S$.],
        [Le circuit magnétique ne comporte pas d'entrefer.],
        [L'excitation magnétique est uniforme dans le matériau ferromagnétique.],
    ),
    grandeurs: grandeurs,
)[
    $ H l = N i $
]

#question-de-colle(
    "Établir la relation tension-champ magnétique et la relation courant-excitation magnétique pour un circuit magnétique sans entrefer. Expliquer comment tracer un cycle d'hystérésis expérimentalement.",
)

Cette relation est mise à profit pour mesurer l'excitation magnétique et tracer le cycle d'hystérésis.

#import "@preview/wrap-it:0.1.1": wrap-content
#wrap-content(align: right)[
    #lien("https://upload.wikimedia.org/wikipedia/commons/8/81/Power_Transformer_Over-Excitation.gif")
][
    Si la tension $e$ aux bornes de l'enroulement est sinusoïdale, cela n'implique pas que l'intensité du courant $i$ le soit également. Si le matériau ferromagnétique est doux et hors saturation, alors l'intensité du courant a la même forme que la tension.
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
    grandeurs: grandeurs,
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
    grandeurs: grandeurs,
)[
    $ w = (1)/(2 mu_0 mu_r) B^2 $
]

#question-de-colle(
    "Établir le champ magnétique dans une bobine ayant un cœur magnétique. En déduire son inductance propre. En déduire dans ce cas particulier la densité volumique d'énergie magnétique.",
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
    grandeurs: grandeurs,
)[
    $ mean( cal(P)_"hystérésis" ) = V f cal(A) $
]

#question-de-colle(
    "Établir la puissance moyenne des pertes par hystérésis. Citer les différents types de pertes existant dans un circuit magnétique.",
)

Pour limiter les pertes par hystérésis, on utilise des matériaux ferromagnétiques doux.

Le circuit magnétique étant un conducteur électrique placé dans un champ magnétique variable, des courants de Foucault y sont induits. Pour limiter les pertes par courant de Foucault, on utilise le feuilletage.

Pertes par courant de Foucault et pertes par hystérésis sont appelées les *pertes fer* car elles se produisent dans le matériau ferromagnétique.

Des pertes par effet Joule se produisent également dans le bobinage, souvent réalisé en cuivre. Les pertes par effet Joule sont appelées pertes cuivre.

== Circuit magnétique avec entrefer
Un entrefer est une zone de l'espace vide#footnote[Vide de matériau ferromagnétique.] au sein du circuit magnétique. Un circuit magnétique avec entrefer est appelé un électroaimant car il permet de réaliser un champ magnétique dans une zone de l'espace grâce à un courant électrique.

#schéma(titre: "Circuit magnétique avec entrefer")[#box(height: 4cm)]

#encadré(
    titre: "Champ magnétique dans l'entrefer d'un électroaimant",
    savoir-faire: true,
    hypothèses: (
        [Dans l'ARQS magnétique.],
        [L'excitation magnétique et le champ magnétique sont uniformes dans le matériau ferromagnétique.],
        [Le circuit magnétique a une section constante.],
        [Les effets de bord sont négligés dans l'entrefer#footnote[Autrement dit, l'épaisseur de l'entrefer est très petite devant toutes les autres dimensions.].],
        [Le matériau ferromagnétique est doux et hors saturation.],
    ),
    grandeurs: grandeurs,
)[
    $ B_"entrefer"=(mu_0 N i)/e $
]

#question-de-colle("Établir l'expression du champ magnétique dans l'entrefer d'un électroaimant.")
