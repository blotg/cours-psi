#import "@local/prepa:0.1.1": *

#show: cours.with(infos: yaml("infos.yml"))

#let grandeurs = (
    "I": (signification: "le courant électrique", unité: unit("A")),
    "va(j)": (signification: "le vecteur densité volumique de courant électrique", unité: unit("A/m^2")),
    "va(j_S)": (signification: "le vecteur densité surfacique de courant électrique", unité: unit("A/m")),
    "va(B)": (signification: "le champ magnétique", unité: unit("T")),
    "va(E)": (signification: "le champ électrique", unité: unit("V/m")),
    "mu_0": (signification: "la perméabilité magnétique du vide ($4 pi times 10^(-7)$ H/m)"),
    "epsilon_0": (signification: "la permittivité diélectrique du vide", unité: unit("F/m")),
    "va(F)": (signification: "la partie magnétique de la force de Lorentz", unité: unit("N")),
    "q": (signification: "la charge de la particule", unité: unit("C")),
    "va(v)": (signification: "la vitesse de la particule chargée", unité: unit("m/s")),
    "va(dif l)": (signification: "l'élément de longueur orienté dans le sens du courant", unité: unit("m")),
    "dif V": (signification: "l'élément de volume", unité: unit("m^3")),
    "va(dif F)": (signification: "la force magnétique subie par l'élément de conducteur", unité: unit("N")),
    "cal(C)": (signification: "une courbe fermée orientée"),
    "I_text(\"enlacé\")": (signification: "le courant enlacé par $cal(C)$, compté positivement dans le sens direct", unité: unit("A")),
)

= Notion de courant électrique
Le courant électrique correspond à un déplacement de porteurs de charge. La répartition des courants peut être modélisée de plusieurs manières.

== Distribution volumique
$va(j)(M, t)$ désigne le vecteur densité volumique de courant électrique au point $M$ et à l'instant $t$.

#encadré(
    titre: "Courant en description volumique",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("I", "va(j)")),
)[
    $ I = integral.double va(j) dot va(dif S) $
]

== Distribution surfacique
$va(j_S)(M, t)$ désigne le vecteur densité surfacique de courant électrique au point $M$ et à l'instant $t$. Ce modèle décrit un courant circulant dans une couche d'épaisseur négligeable devant l'échelle de description.

#encadré(
    titre: "Courant en description surfacique",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("I", "va(j_S)")),
)[
    $ I = integral va(j_S) dot va(dif l) $
]

== Distribution linéique
$I$ désigne le courant circulant dans un objet filiforme.

= Propriétés du champ magnétostatique
== Équations de Maxwell
Le comportement du champ magnétique est régi par les équations de Maxwell-Thomson et de Maxwell-Ampère.

#encadré(
    titre: "Équation de Maxwell-Thomson",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("va(B)",)),
)[
    $ div va(B) = 0 $
]

#flashcard(recto: "Équation de Maxwell-Thomson", verso: "$ div va(B) = 0 $")

#encadré(
    titre: "Équation de Maxwell-Ampère",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("va(B)", "va(j)", "va(E)", "mu_0", "epsilon_0")),
)[
    $ rot va(B) = mu_0 va(j) + mu_0 epsilon_0 pdv(va(E), t) $
]

#flashcard(recto: "Équation de Maxwell-Ampère", verso: "$ rot va(B) = mu_0 va(j) + mu_0 epsilon_0 pdv(va(E), t) $")

== Théorème de superposition
Les équations de Maxwell sont linéaires : le champ magnétique résultant de plusieurs distributions de courant est la somme vectorielle des champs magnétiques créés par chacune d'elles.

== Conservation du flux du champ magnétique
#encadré(
    titre: [Conservation du flux de $va(B)$],
    connaitre: true,
    savoir-faire: true,
)[
    Le champ magnétique est à flux conservatif, et ce sans aucune condition.
]

#flashcard(
    recto: "À quelle condition le champ magnétique est-il à flux conservatif ?",
    verso: "Aucune, c'est toujours le cas.",
)

Du fait de cette propriété, l'équation de Maxwell-Thomson est parfois appelée équation de Maxwell-flux. L'évasement d'un tube de champ s'accompagne alors de la diminution de la norme du champ magnétique.

#question-de-colle("Énoncer l'équation de Maxwell-Thomson, démontrer que le champ magnétique est à flux conservatif et faire le lien avec la topographie des cartes de champ magnétique.")

== Forces causées par un champ magnétique
Le champ magnétique exerce une force sur les particules chargées en mouvement. Son expression dépend de la description du déplacement des charges.

=== Description ponctuelle
Une particule chargée est animée d'une vitesse.

#encadré(
    titre: "Force magnétique subie par une particule ponctuelle",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("va(F)", "q", "va(v)", "va(B)")),
)[
    $ va(F) = q va(v) and va(B) $
]

#flashcard(recto: "Force de Lorentz", verso: "$ va(F) = q va(E) + q va(v) and va(B) $")

#application[
    Une particule de charge $q$ et de masse $m$ plongée dans un champ magnétique uniforme et stationnaire $va(B) = B va(e_z)$ a une trajectoire circulaire orthogonale à $va(B)$. Exprimer sa vitesse angulaire.
]

=== Description linéique
Un fil infiniment fin est parcouru par un courant électrique.

#encadré(
    titre: "Force de Laplace",
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("va(dif F)", "I", "va(dif l)", "va(B)")),
)[
    $ va(dif F) = I va(dif l) and va(B) $
]

#flashcard(recto: "Force de Laplace sur un élément de fil", verso: "$ va(dif F) = I va(dif l) and va(B) $")

#application[
    Dans les rails de Laplace, une barre traversée par un courant $qty("5", "A")$ dirigé selon $va(e_y)$ roule sur des rails horizontaux distants de $qty("10", "cm")$, en présence d'un champ magnétique vertical $qty("3e-2", "T")$ dirigé selon $va(e_z)$. Calculer la norme de la force magnétique subie par la barre.
]

=== Description volumique
Le déplacement des charges est décrit par le vecteur densité volumique de courant.

#encadré(
    titre: "Force de Laplace volumique",
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("va(dif F)", "va(j)", "dif V", "va(B)")),
)[
    $ va(dif F) = (va(j) dif V) and va(B) $
]

#flashcard(recto: "Force de Laplace volumique", verso: "$ va(dif F) = (va(j) dif V) and va(B) $")

#question-de-colle("Citer l'expression de la partie magnétique de la force de Lorentz. En déduire la force de Laplace exercée sur un élément de fil puis sur un élément de volume.")

#application[
    Un fil épais de section $qty("6", "mm^2")$ et de longueur $qty("10", "m")$ est parcouru par un vecteur densité de courant uniforme $va(j) = j va(e_x)$, le courant total valant $qty("10", "A")$. Calculer la norme de la force exercée par le champ magnétique terrestre ($qty("5e-5", "T")$ selon $va(e_z)$), supposé orthogonal au courant.
]

= Théorème d'Ampère
== Invariances du champ magnétique
Les invariances de la distribution de courant contraignent la forme du champ magnétique : d'après le principe de Curie, les invariances de la distribution de courant sont aussi des invariances du champ magnétique.

#flashcard(
    recto: "Lien entre les invariances de la distribution de courant et celles du champ magnétique",
    verso: "Les invariances de la distribution de courant sont aussi des invariances du champ magnétique (principe de Curie).",
)

== Symétries du champ magnétique
Le champ magnétique est un #emph[pseudo-vecteur] : il est symétrique par rapport aux plans d'antisymétrie de la distribution de courant, et antisymétrique par rapport à ses plans de symétrie.

#encadré(
    titre: "Plans de symétrie et champ magnétique",
    connaitre: true,
    savoir-faire: true,
)[
    Le champ magnétique est orthogonal aux plans de symétrie de la distribution de courant.
]

#flashcard(
    recto: "Lien entre le champ magnétique et les plans de symétrie de la distribution de courant",
    verso: "Le champ magnétique leur est orthogonal.",
)

#application[
    Déterminer la direction du champ magnétique créé par un fil rectiligne infini et infiniment fin parcouru par un courant.
]

#encadré(
    titre: "Plans d'antisymétrie et champ magnétique",
    connaitre: true,
    savoir-faire: true,
)[
    Le champ magnétique est inclus dans les plans d'antisymétrie de la distribution de courant.
]

#flashcard(
    recto: "Lien entre le champ magnétique et les plans d'antisymétrie de la distribution de courant",
    verso: "Le champ magnétique y est inclus.",
)

#question-de-colle("Énoncer le principe de Curie. Établir le lien entre les plans de symétrie et d'antisymétrie de la distribution de courant et la direction du champ magnétique.")

== Théorème d'Ampère
Le théorème d'Ampère permet de déterminer le champ magnétique à partir de la distribution de courant, lorsque celle-ci est suffisamment symétrique.

#encadré(
    titre: "Théorème d'Ampère",
    connaitre: true,
    savoir-faire: true,
    hypothèses: "En régime stationnaire.",
    grandeurs: sub-dictionary(grandeurs, ("cal(C)", "va(B)", "mu_0", "I_text(\"enlacé\")")),
)[
    $ integral.cont_(cal(C)) va(B) dot va(dif l) = mu_0 I_"enlacé" $
]

#flashcard(recto: "Théorème d'Ampère", verso: "$ integral.cont_(cal(C)) va(B) dot va(dif l) = mu_0 I_\"enlacé\" $")

#question-de-colle("Citer l'équation de Maxwell-Ampère puis établir le théorème d'Ampère.")

Le champ magnétique s'obtient alors par la méthode en quatre étapes : analyse des invariances, analyse des symétries, choix d'un contour d'Ampère adapté, application du théorème d'Ampère.

#application[
    Déterminer le champ magnétique créé dans tout l'espace par un fil épais de rayon $R$, rectiligne et infini, parcouru par un vecteur densité de courant $va(j)$ uniforme.
]
#question-de-colle("Déterminer le champ magnétique créé dans tout l'espace par un fil épais de rayon $R$ et infini parcouru par un vecteur densité de courant $va(j)$ uniforme.")

#application[
    Déterminer le champ magnétique créé dans tout l'espace par un solénoïde infini de rayon $R$ comportant $n$ spires par unité de longueur parcourues par un courant $I$. Le solénoïde est assimilé à une succession de spires circulaires jointives ; on admet que le champ magnétique est nul à l'extérieur.
]
#question-de-colle("Déterminer le champ magnétique créé dans tout l'espace par un solénoïde infini de rayon $R$ comportant $n$ spires par unité de longueur parcourues par un courant $I$. Le solénoïde est assimilé à une succession de spires circulaires jointives. On suppose le champ magnétique nul à l'extérieur du solénoïde.")

#application[
    Déterminer le champ magnétique créé par une bobine torique comportant $N gt.double 1$ spires parcourues par un courant $I$.
]
#question-de-colle("Déterminer le champ magnétique créé par une bobine torique comportant $N gt.double 1$ spires parcourues par un courant $I$.")
