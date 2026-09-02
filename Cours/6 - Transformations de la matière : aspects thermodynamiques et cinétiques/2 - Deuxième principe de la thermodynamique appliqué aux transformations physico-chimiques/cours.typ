#import "@local/prepa:0.1.1": *

#show: cours.with(infos: yaml("infos.yml"))

#let grandeurs = (
    "U": (signification: "l'énergie interne", unité: unit("J")),
    "T": (signification: "la température", unité: unit("K")),
    "S": (signification: "l'entropie", unité: unit("J/K")),
    "P": (signification: "la pression", unité: unit("Pa")),
    "V": (signification: "le volume", unité: unit("m^3")),
    "H": (signification: "l'enthalpie", unité: unit("J")),
    "G": (signification: "l'enthalpie libre", unité: unit("J")),
    "delta S_c": (signification: "l'entropie créée", unité: unit("J/K")),
    "U_m": (signification: "l'énergie interne molaire", unité: unit("J/mol")),
    "H_m": (signification: "l'enthalpie molaire", unité: unit("J/mol")),
    "G_m": (signification: "l'enthalpie libre molaire", unité: unit("J/mol")),
    "S_m": (signification: "l'entropie molaire", unité: unit("J/K/mol")),
    "V_m": (signification: "le volume molaire", unité: unit("m^3/mol")),
    "n": (signification: "la quantité de matière", unité: unit("mol")),
    "mu^*": (signification: "le potentiel chimique du corps pur", unité: unit("J/mol")),
    "mu": (signification: "le potentiel chimique de l'espèce au sein d'un mélange", unité: unit("J/mol")),
    "R": (signification: "la constante des gaz parfaits", unité: unit("J/K/mol")),
    "a": (signification: "l'activité de l'espèce", unité: "sans unité"),
    "Delta_r S": (signification: "l'entropie de réaction", unité: unit("J/K/mol")),
    "nu_i": (signification: "les coefficients stœchiométriques algébriques", unité: "sans unité"),
    "K^circ": (signification: "la constante d'équilibre", unité: "sans unité"),
    "Delta_r G^circ": (signification: "l'enthalpie libre standard de réaction", unité: unit("J/mol")),
    "Delta_r G": (signification: "l'enthalpie libre de réaction", unité: unit("J/mol")),
    "Q": (signification: "$=product a_i^(nu_i)$ le quotient réactionnel", unité: "sans unité"),
    "Delta_r H^circ": (signification: "l'enthalpie standard de réaction", unité: unit("J/mol")),
    "Delta_r H": (signification: "l'enthalpie de réaction", unité: unit("J/mol")),
)

= Potentiels thermodynamiques
== L'énergie interne $U$

#encadré(
    titre: "Variation d'énergie interne pour une transformation infinitésimale réversible",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "Le système est fermé.",
        "La transformation est réversible.",
        "Le système est immobile.",
        "Le seul travail est celui des forces de pression.",
        "Il n'y a pas de transformation chimique.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("U", "T", "S", "P", "V")),
)[
    $ dd(U) = T dd(S) - P dd(V) $
]

#flashcard(
    recto: "Différentielle de l'énergie interne",
    verso: "$ dd(U) = T dd(S) - P dd(V) $",
)

Cette formule ressemble à la définition d'une différentielle d'une fonction $f(x,y)$ :
$ dd(f)= lr(pdv(f, x)\))_y dd(x) + lr(pdv(f, y)\))_x dd(y) $
Par identification, on en déduit que les variables naturelles de la fonction $U$ sont $S$ et $V$. On note $U(S,V)$.

== L'enthalpie $H$
L'entropie $S$ et le volume $V$ ne sont pas facile à mesurer et à imposer. On introduit donc d'autres potentiels thermodynamiques#footnote[Un potentiel thermodynamique est une fonction d'état qui sert à prévoir l'évolution d'un système.].

#encadré(
    titre: "Définition de l'enthalpie",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("H", "U", "P", "V")),
)[
    $ H = U + P V $
]

#flashcard(
    recto: "Définition de l'enthalpie $H$",
    verso: "$ H = U + P V $",
)

On peut déduire la différentielle de l'enthalpie $H$ à partir de la différentielle de l'énergie interne $U$.

#encadré(
    titre: "Variation d'enthalpie pour une transformation infinitésimale réversible",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "Le système est fermé.",
        "La transformation est réversible.",
        "Le système est immobile.",
        "Le seul travail est celui des forces de pression.",
        "Il n'y a pas de transformation chimique.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("H", "T", "S", "V", "P")),
)[
    $ dd(H) = T dd(S) + V dd(P) $
]

#flashcard(
    recto: "Différentielle de l'enthalpie",
    verso: "$ dd(H) = T dd(S) + V dd(P) $",
)

Les variables naturelles de l'enthalpie $H$ sont donc $S$ et $P$. On note $H(S,P)$.

== L'enthalpie libre#footnote[Synonymes : "enthalpie libre de Gibbs" et "énergie de Gibbs".] $G$

#encadré(
    titre: "Définition de l'enthalpie libre",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("G", "H", "T", "S", "U", "P", "V")),
)[
    $ G = H - T S = U + P V - T S $
]

#flashcard(
    recto: "Définition de l'enthalpie libre $G$",
    verso: "$ G = H - T S = U + P V - T S $",
)

On peut déduire la différentielle de l'enthalpie libre $G$ à partir de la différentielle de l'énergie interne $H$.

#encadré(
    titre: "Variation d'enthalpie libre pour une transformation infinitésimale réversible",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "Le système est fermé.",
        "La transformation est réversible.",
        "Le système est immobile.",
        "Le seul travail est celui des forces de pression.",
        "Il n'y a pas de transformation chimique.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("G", "T", "S", "V", "P")),
)[
    $ dd(G) = V dd(P) - S dd(T) $
]

#flashcard(
    recto: "Différentielle de l'enthalpie libre",
    verso: "$ dd(G) = V dd(P) - S dd(T) $",
)

#question-de-colle(
    "Citer la différentielle de l'énergie interne. Définir l'enthalpie et l'enthalpie libre et établir leur différentielle.",
)

Les variables naturelles de l'enthalpie libre $G$ sont donc $T$ et $P$. On note $G(T,P)$. Pour une transformation isotherme et isobare (les variables naturelles de $G$ restent constantes), la variation d'enthalpie libre est facilement calculable.

#encadré(
    titre: "Variation d'enthalpie libre pour une transformation isotherme et isobare",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "Le système est fermé.",
        "Le seul travail est celui des forces de pression.",
        "Le système est immobile.",
        "Il n'y a pas de transformation chimique.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("G", "T", "delta S_c")),
)[
    $ dd(G) = - T delta S_c $
]

== Grandeurs molaires associées
Les potentiels thermodynamiques $U$, $H$ et $G$ sont des grandeurs extensives. On définit les grandeurs molaires associées.

#encadré(
    titre: "Grandeurs molaires associées aux potentiels thermodynamiques",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("U_m", "H_m", "G_m", "U", "H", "G", "n")),
)[
    $ U_m = U/n quad quad H_m = H/n quad quad G_m = G/n $
]

Les différentielles des grandeurs molaires ont la même forme que les différentielles des grandeurs extensives.

#encadré(
    titre: "Différentiels des potentiels thermodynamiques molaires",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "Le système est fermé.",
        "La transformation est réversible.",
        "Le système est immobile.",
        "Le seul travail est celui des forces de pression.",
        "Il n'y a pas de transformation chimique.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("U_m", "H_m", "G_m", "T", "S_m", "V_m", "P")),
)[
    $ dd(U_m) = T dd(S_m) - P dd(V_m) $
    $ dd(H_m) = T dd(S_m) + V_m dd(P) $
    $ dd(G_m) = V_m dd(P) - S_m dd(T) $
]

= Potentiel chimique
== Définition
Tout ce qui précède ne s'applique qu'à des systèmes fermés. Pour un système ouvert, les potentiels thermodynamiques $U$, $H$ et $G$ dépendent de la quantité de matière dans le système : $U(S,V,n)$, $H(S,P,n)$ et $G(T,P,n)$. Pour un système ouvert, les différentielles des potentiels thermodynamiques $U$, $H$ et $G$ comportent un terme supplémentaire.

#encadré(
    titre: "Variation d'énergie interne pour une transformation infinitésimale réversible d'un système ouvert",
    connaitre: true,
    hypothèses: (
        "Le système est un corps pur.",
        "La transformation est réversible.",
        "Le système est immobile.",
        "Le seul travail est celui des forces de pression.",
        "Il n'y a pas de transformation chimique.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("U", "H", "G", "T", "S", "P", "V", "mu^*", "n")),
)[
    $ dd(U) = T dd(S) - P dd(V) + mu^* dd(n) $
    $ dd(H) = T dd(S) + V dd(P) + mu^* dd(n) $
    $ dd(G) = V dd(P) - S dd(T) + mu^* dd(n) $
]

L'étoile \* sert à préciser qu'il s'agit d'une propriété d'un corps pur.

Bien que les grandeurs extensives $U(S,V,b)$, $H(S,P,n)$ et $G(T,P,n)$ dépendent de $n$, les grandeurs molaires associées n'en dépendent pas : $U_m (S_m,V_m)$, $H_m (S_m,P)$, $G_m (T,P)$. Le potentiel chimique d'un corps pur est donc son enthalpie libre molaire.

#encadré(
    titre: "Potentiel chimique d'un corps et enthalpie libre molaire",
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("mu^*", "G_m")),
)[
    $ mu^* = G_m (T,P) $
]

#flashcard(
    recto: "Lien entre potentiel chimique et enthalpie libre molaire",
    verso: "$ mu = G_m $",
)

== Changements d'états
On s'intéresse à un changement d'état d'un corps pur #ce("A ($alpha$) <=> A ($beta$)").

#exemple[
    #ce("H2O (l) <=> H2O (g)"), #ce("C (graphite) <=> C (diamant)"), ...
]

#encadré(
    titre: "Égalité des potentiels chimiques à l'équilibre",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "Le système est un corps pur.",
        [Le système est à l'équilibre entre deux phases $alpha$ et $beta$.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("mu^*",)),
)[
    $ mu^*_alpha (T,P) = mu^*_beta (T,P) $
]

#flashcard(
    recto: "Lien entre les potentiels chimiques lors d'un équilibre entre plusieurs phases",
    verso: "$ mu^*_alpha (T,P) = mu^*_beta (T,P) $",
)

L'égalité $mu^*_alpha (T,P) = mu^*_beta (T,P)$ est l'équation implicite d'une courbe dans un diagramme $(P,T)$. Lorsqu'un système est à l'équilibre entre deux phases, il se trouve sur une courbe dans le diagramme $(P,T)$

#schéma(titre: [Diagramme $(P,T)$ de l'eau], hauteur: 4cm)

#question-de-colle("Définir le potentiel chimique, montrer qu'il s'identifie à l'enthalpie libre molaire puis que le potentiel chimique est le même pour toutes les phases en présences lors d'un changement d'état d'un corps pur. Schématiser le diagramme $(P,T)$ de l'eau.")

== Potentiel chimique d'une espèce au sein d'un mélange
Le potentiel chimique d'une espèce au sein d'un mélange dépend de l'activité de cette espèce.

#encadré(
    titre: "Potentiel chimique d'une espèce au sein d'un mélange",
    grandeurs: sub-dictionary(grandeurs, ("mu", "mu^*", "R", "T", "a")),
)[
    $ mu = mu^* + R T ln a $
]
Comme l'enthalpie libre est une grandeur additive, l'enthalpie libre d'un mélange s'exprime à partir des enthalpies libres molaires de ses constituants, c'est-à-dire des potentiels chimiques de ses constituants.

#encadré(
    titre: "Enthalpie libre d'un mélange",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("G", "mu", "n")),
)[
    $ G = sum mu_i n_i $
]

#flashcard(
    recto: "Enthalpie libre d'un mélange",
    verso: "$ G = sum mu_i n_i $",
)

= Sens d'évolution d'une réaction
== Entropie de réaction
#encadré(
    titre: "Entropie de réaction",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("Delta_r S", "nu_i", "S_m")),
)[
    $ Delta_r S^circ = sum nu_i S_(m,i)^circ $
]

#flashcard(
    recto: "Entropie de réaction en fonction des entropie molaires",
    verso: "$ Delta_r S^circ = sum nu_i S_(m,i)^circ $"
)

L'entropie molaire est bien plus grande pour un gaz que pour un liquide et pour un liquide que pour un solide. On peut alors déterminer le signe de l'entropie de réaction en observant les états physiques des réactifs et des produits.

#application[
    Quel est le signe de l'entropie de réaction pour les réactions suivantes ?
    $ ce("C6H12O6 (s) + 6O2 (g) -> 6 CO2 (g)  + 6 H2O(g)") $
    $ ce("H2O (l) -> H2O (s)") $
]

== Enthalpie libre de réaction
L'enthalpie libre de réaction peut être exprimée en fonction de l'enthalpie de réaction et de l'entropie de réaction.

#encadré(
    titre: "Enthalpie libre de réaction",
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("Delta_r G", "Delta_r H", "Delta_r S", "T")),
)[
    $ Delta_r G = Delta_r H - T Delta_r S $
]

== Constante d'équilibre

La constante d'équilibre d'une réaction peut être définie à partir de l'enthalpie libre standard de réaction.
#encadré(
    titre: "Constante d'équilibre",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("K^circ", "Delta_r G^circ", "R", "T") ),
)[
    $ K^circ (T) = exp(- (Delta_r G^circ) / (R T)) $
]

#flashcard(
    recto: "Définition de la constante d'équilibre",
    verso: "$ K^circ (T) = exp(- (Delta_r G^circ) / (R T)) $"
)

L'enthalpie de réaction s'exprime alors en fonction de la constante d'équilibre et du quotient de réaction.

#encadré(
    titre: "Enthalpie libre de réaction et quotient réactionnel",
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("Delta_r G", "K^circ", "R", "T", "Q"))
)[
    $ Delta_r G = R T ln(Q/K^circ) $
]

#flashcard(
    recto: "Lien entre enthalpie libre de réaction et quotient réactionnel",
    verso: "$ Delta_r G = R T ln(Q/K^circ) $"
)

Pour une réaction spontanée, l'enthalpie libre ne peut que diminuer. Ceci contraint le sens d'évolution en fonction du signe de l'enthalpie libre de réaction.

#encadré(
    titre: "Évolution d'un système",
    connaitre: true,
    savoir-faire: true,
    // grandeurs: sub-dictionary(grandeurs, ("Delta_r G",))
)[
    - Si $Delta_r G < 0$ alors la réaction se produit dans le sens direct.
    - Si $Delta_r G > 0$ alors la réaction se produit dans le sens inverse.
    - Si $Delta_r G = 0$ alors le système est à l'équilibre.
]

Cette condition d'évolution peut être reformulée en fonction des valeurs relatives du quotient réactionnel et de la constante d'équilibre.

#encadré(
    titre: "Loi de Guldberg-Waage (loi d'action de masse)",
    connaitre: true,
    savoir-faire: true,
    // grandeurs: sub-dictionary(grandeurs, ("Q", "K^circ")),
)[
    - Si $Q < K^circ$ alors la réaction se produit dans le sens direct.
    - Si $Q > K^circ$ alors la réaction se produit dans le sens inverse.
    - Si $Q = K^circ$ alors le système est à l'équilibre.
]

#flashcard(
    recto: "Loi de Guldberg-Waage (loi d'action de masse)",
    verso: "Si $Q < K^circ$ (c'est-à-dire $Delta_r G <0$) alors la réaction se produit dans le sens direct et réciproquement.\nLa réaction est à l'équilibre ssi $Q = K^circ$ (c'est-à-dire $Delta_r G =0$).",
)

#question-de-colle("Exprimer l'enthalpie libre de réaction en fonction du quotient réactionnel puis établir la loi de Guldberg-Waage.")

#application[
    Pour la réaction $ce("N2 (g) + 3H2 (g) <=> 2NH3 (g)")$, la constante d'égalité vaut $K^circ = #num("1.6e5")$ à #qty("500","K"). Dans quel sens évolue le système si les quantités initiales sont $n_ce("N2") = qty("1","mol")$, $n_ce("H2") = qty("3","mol")$ et $n_ce("NH3") = qty("0.5","mol")$ ?
]

= Déplacement d'équilibre

Pour produire des substances chimiques, il peut être intéressant de déplacer l'équilibre d'une réaction dans un sens afin de favoriser la formation des produits désirés. On peut agir sur les conditions de température et de pression pour déplacer l'équilibre.

== Effet de la température

La loi de Van't Hoff relie la variation de la constante d'équilibre avec la température à l'enthalpie standard de réaction.

#encadré(
    titre: "Relation de Van't Hoff",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("K^circ", "Delta_r H^circ", "R", "T")),
)[
    $ dv(ln K^circ,T) = (Delta_r H^circ)/(R T^2) $
]

#flashcard(
    recto: "Relation de Van't Hoff",
    verso: "$ dv(ln K^circ,T) = (Delta_r H^circ)/(R T^2) $"
)

#application[
    #ce("N2 + 3H2 <=> 2NH3") est une réaction exothermique. Vaut-il mieux faire la réaction à haute ou à basse température pour obtenir davantage de #ce("NH3") ?
]

#question-de-colle("Énoncer la relation de Van't Hoff. Dans quel sens se déplace l'équilibre lorsqu'on augmente/diminue la température pour une réaction exothermique/endothermique (au choix de l'interrogateur) ?")

La relation de Van't Hoff est cohérente avec le *principe de modération de Le Chatelier* : lorsque l'on perturbe les conditions de température ou de pression d'un système réactif à l'équilibre, la réaction va spontanément être déplacée dans le sens qui tend à s'opposer à la perturbation imposée.

== Approximation d'Ellingham
Dans l'approximation d'Ellingham, $Delta_r H^circ$ et $Delta_r S^circ$ sont indépendants de la température.

#flashcard(
    recto: "Approximation d'Ellingham",
    verso: "$Delta_r H^circ$ et $Delta_r S^circ$ sont indépendants de la température."
)

Dans l'approximation d'Ellingham, $Delta_r G^circ = Delta_r H^circ - T Delta_r S^circ$ est une fonction affine de la température.

#application[
    Exprimer, dans l'approximation d'Ellingham, $K^circ (T_1)$ en fonction de $K^circ (T_2)$, $Delta_r H^circ$, $T_1$ et $T_2$.
]

== Effet de la pression
Si des réactifs ou des produits sont des gaz, la pression a une influence sur l'équilibre du système. Il est alors possible de déplacer l'équilibre dans un sens ou dans l'autre en modifiant la pression.

#application[
    Vaut-il mieux travailler à haute ou basse pression pour former #ce("NH3") selon la réaction #ce("N2 (g) + 3H2 (g) <=> 2NH3 (g)") ?
]

La loi de Le Chatelier stipule qu'une augmentation de la pression déplace l'équilibre dans le sens qui diminue le nombre de moles de gaz, et réciproquement. La loi de Le Chatelier est cohérente avec le principe de modération de Le Chatelier.

#question-de-colle("Dans le cas particulier d'une réaction fournie par l'interrogateur, déterminer dans quel sens est déplacé l'équilibre en cas d'augmentation/diminution de la pression.")


