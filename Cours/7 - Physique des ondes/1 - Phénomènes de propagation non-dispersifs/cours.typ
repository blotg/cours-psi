#import "@local/prepa:0.1.1": *

#show: cours.with(infos: yaml("infos.yml"))

#let lien(url) = text(size: 0.85em, fill: luma(45%))[Animation : #link(url)]

#let grandeurs = (
    "y(x, t)": (signification: "l'écart à l'équilibre à l'abscisse $x$ et à l'instant $t$", unité: unit("m")),
    "c": (signification: "la célérité de l'onde", unité: unit("m/s")),
    "T": (signification: "la tension de la corde", unité: unit("N")),
    "mu": (signification: "la masse linéique de la corde", unité: unit("kg/m")),
    "u(x, t)": (signification: "la tension à l'abscisse $x$ et à l'instant $t$", unité: unit("V")),
    "i(x, t)": (signification: "l'intensité du courant à l'abscisse $x$ et à l'instant $t$", unité: unit("A")),
    "Lambda": (signification: "l'inductance linéique du câble", unité: unit("H/m")),
    "Gamma": (signification: "la capacité linéique du câble", unité: unit("F/m")),
    "P(M, t)": (signification: "la pression", unité: unit("Pa")),
    "P_0": (signification: "la pression ambiante (en l'absence d'onde)", unité: unit("Pa")),
    "P_1(M, t)": (signification: "la surpression causée par l'onde", unité: unit("Pa")),
    "rho_0": (signification: "la masse volumique ambiante du fluide", unité: unit("kg/m^3")),
    "rho_1": (signification: "la sur-masse volumique causée par l'onde", unité: unit("kg/m^3")),
    "va(v)_1": (signification: "la vitesse du fluide", unité: unit("m/s")),
    "chi_S": (signification: "le coefficient de compressibilité isentropique", unité: unit("Pa^-1")),
    "gamma": (signification: "le rapport des capacités thermiques du gaz (sans unité)"),
    "R": (signification: "la constante des gaz parfaits", unité: unit("J/K/mol")),
    "M": (signification: "la masse molaire du gaz", unité: unit("kg/mol")),
    "va(E)": (signification: "le champ électrique", unité: unit("V/m")),
    "va(B)": (signification: "le champ magnétique", unité: unit("T")),
    "epsilon_0": (signification: "la permittivité diélectrique du vide", unité: unit("F/m")),
    "mu_0": (signification: "la perméabilité magnétique du vide", unité: unit("H/m")),
    "y_0": (signification: "l'amplitude de l'onde"),
    "omega": (signification: "$= 2 pi \/ T$ la pulsation", unité: unit("rad/s")),
    "va(k)": (signification: "$= (2 pi \/ lambda) va(n)$ le vecteur d'onde", unité: unit("rad/m")),
    "k": (signification: "le nombre d'onde", unité: unit("rad/m")),
    "lambda": (signification: "la longueur d'onde", unité: unit("m")),
    "phi": (signification: "la phase à l'origine", unité: unit("rad")),
    "va(n)": (signification: "un vecteur unitaire dans la direction de propagation"),
    "underline(y)": (signification: "la représentation complexe d'une OPH quelconque"),
    "va(underline(A))": (signification: "la représentation complexe d'un champ d'OPH quelconque"),
    "v_phi": (signification: "la vitesse de phase", unité: unit("m/s")),
    "omega_n": (signification: "la $n$-ième pulsation propre", unité: unit("rad/s")),
    "L": (signification: "la distance entre les deux conditions aux limites strictes", unité: unit("m")),
    "Z_c": (signification: "$= sqrt(Lambda \/ Gamma)$ l'impédance caractéristique du câble", unité: unit("ohm")),
    "Z_a": (signification: "$= rho_0 c$ l'impédance acoustique", unité: unit("Pa s/m")),
    "u_(i\,0)": (signification: "l'amplitude de l'onde de tension incidente", unité: unit("V")),
    "u_(r\,0)": (signification: "l'amplitude de l'onde de tension réfléchie", unité: unit("V")),
    "R_t": (signification: "la résistance terminale", unité: unit("ohm")),
    "va(Pi)": (signification: "le vecteur de Poynting", unité: unit("W/m^2")),
    "I": (signification: "l'intensité acoustique", unité: unit("W/m^2")),
    "I_0": (signification: "l'intensité acoustique de référence ($10^(-12)$ W/m²)"),
    "I_text(\"dB\")": (signification: "le niveau sonore", unité: unit("dB")),
    "w": (signification: "la densité volumique d'énergie", unité: unit("J/m^3")),
    "va(j)_text(\"élec\")": (signification: "le vecteur densité de courant électrique", unité: unit("A/m^2")),
    "cal(E)": (signification: "l'énergie d'un photon", unité: unit("J")),
    "h": (signification: "la constante de Planck ($6.63 times 10^(-34)$ J·s)"),
    "nu": (signification: "la fréquence de l'onde", unité: unit("Hz")),
    "E_0": (signification: "l'amplitude du champ électrique", unité: unit("V/m")),
)

= Différents phénomènes régis par la même équation
== Onde dans une corde
#lien("https://www.youtube.com/watch?v=jV1Tp_tM2Ts&t=37s")

Une corde peut être le siège d'ondes transversales. C'est un milieu unidimensionnel : une seule direction de propagation est possible.

#schéma(titre: "Corde", hauteur: 4cm)

#encadré(
    titre: "Équation de propagation dans une corde",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "La corde est infiniment flexible et inextensible.",
        "Les déplacements sont faibles et transverses.",
        "Les effets de la gravité sont négligés.",
        "Les frottements sont négligés.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("y(x, t)", "c", "T", "mu")),
)[
    $ pdv(y, x, 2) - 1/c^2 pdv(y, t, 2) = 0 quad "avec" quad c = sqrt(T/mu) $
]

#question-de-colle("Établir l'équation aux dérivées partielles vérifiée par une onde dans une corde, en précisant les hypothèses et approximations effectuées.")

#flashcard(recto: "Équation de d'Alembert", verso: "$ Delta y - 1/c^2 pdv(y, t, 2) = 0 $ (ou $ pdv(y, x, 2) - 1/c^2 pdv(y, t, 2) = 0 $ en 1D)")

Cette équation aux dérivées partielles s'appelle #strong[équation de d'Alembert].

== Ondes dans un câble coaxial
Un câble coaxial est constitué de deux conducteurs concentriques (l'âme et la gaine) séparés par un isolant ; c'est un milieu unidimensionnel.

#figure(image("images/coaxial.jpg", width: 60%), caption: [Photographie d'un câble coaxial.])

#schéma(titre: "Câble coaxial", hauteur: 3cm)

#exemple[Les câbles d'antenne (satellite, TNT, wifi…) sont souvent des câbles coaxiaux.]

Les câbles coaxiaux étant parfois longs, les conditions de l'ARQS ne sont pas toujours remplies : des ondes de tension et de courant peuvent s'y propager.

Dans le modèle à constantes réparties sans pertes, on étudie une portion mésoscopique de câble caractérisée par son inductance linéique et sa capacité linéique ; le conducteur a une résistance nulle et l'isolant une conductance nulle.

#schéma(titre: "Portion mésoscopique de câble dans le modèle à constantes réparties", hauteur: 4cm)

#encadré(
    titre: "Équation de propagation dans un câble coaxial",
    connaitre: true,
    savoir-faire: true,
    hypothèses: "Dans le modèle à constantes réparties sans pertes.",
    grandeurs: sub-dictionary(grandeurs, ("u(x, t)", "i(x, t)", "c", "Lambda", "Gamma")),
)[
    $ cases(
        pdv(u, x, 2) - 1/c^2 pdv(u, t, 2) = 0,
        pdv(i, x, 2) - 1/c^2 pdv(i, t, 2) = 0,
    ) quad "avec" quad c = 1/sqrt(Lambda Gamma) $
]

#question-de-colle("Établir l'équation aux dérivées partielles vérifiée par une onde de tension dans un câble coaxial, en précisant les hypothèses et approximations effectuées.")

#application[
    Calculer la vitesse de propagation d'une onde dans un câble coaxial de capacité linéique $qty("40", "pF/m")$ et d'inductance linéique $qty("0.4", "µH/m")$.
]

== Ondes sonores
=== Le son
Le son est une onde longitudinale de compression dans un fluide ; il se propage dans un milieu tridimensionnel. Lors du passage de l'onde, la pression et la vitesse des particules de fluide oscillent.

#schéma(titre: "Domaines fréquentiels des ondes sonores", hauteur: 4cm)

=== Approximation acoustique
#encadré(
    titre: "Approximation acoustique",
    connaitre: true,
    hypothèses: "Le fluide est macroscopiquement au repos.",
    grandeurs: sub-dictionary(grandeurs, ("P(M, t)", "P_0", "P_1(M, t)", "rho_0", "rho_1", "va(v)_1", "c")),
)[
    $
        & P(M, t) = P_0 + P_1(M, t) & "avec" abs(P_1) &<< P_0 \
        & rho(M, t) = rho_0 + rho_1(M, t) & "avec" abs(rho_1) &<< rho_0 \
        & va(v)(M, t) = va(0) + va(v)_1(M, t) & "avec" norm(va(v)_1) &<< c
    $
]

=== Équation de propagation
Trois équations couplées permettent d'obtenir l'équation de propagation des ondes sonores.

#encadré(
    titre: "Conservation de la masse (linéarisée)",
    savoir-faire: true,
    hypothèses: ("Dans l'approximation acoustique.", "Le fluide est macroscopiquement au repos."),
    grandeurs: sub-dictionary(grandeurs, ("rho_0", "rho_1", "va(v)_1")),
)[
    $ pdv(rho_1, t) = - rho_0 div va(v)_1 $
]

#encadré(
    titre: "Équation thermodynamique (linéarisée)",
    savoir-faire: true,
    hypothèses: (
        "Dans l'approximation acoustique.",
        "Le fluide est macroscopiquement au repos.",
        "L'évolution est adiabatique réversible.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("rho_1", "rho_0", "P_1(M, t)", "chi_S")),
)[
    $ rho_1 = chi_S rho_0 P_1 quad "avec" quad chi_S = 1/rho_0 lr((pdv(rho, P))_S) $
]

#encadré(
    titre: "Équation de la dynamique (linéarisée, équation d'Euler)",
    savoir-faire: true,
    hypothèses: (
        "En l'absence de viscosité.",
        "Dans l'approximation acoustique.",
        "Le fluide est macroscopiquement au repos.",
        "L'action de la gravité est négligée.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("rho_0", "va(v)_1", "P_1(M, t)")),
)[
    $ rho_0 pdv(va(v)_1, t) = - grad P_1 $
]

#encadré(
    titre: "Équation de propagation de la surpression",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "Dans l'approximation acoustique.",
        "Le fluide est macroscopiquement au repos.",
        "L'évolution est adiabatique réversible.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("P_1(M, t)", "c", "rho_0", "chi_S")),
)[
    $ Delta P_1 - 1/c^2 pdv(P_1, t, 2) = 0 quad "avec" quad c = 1/sqrt(rho_0 chi_S) $
]

#question-de-colle("Établir l'équation aux dérivées partielles vérifiée par une onde sonore, en précisant les hypothèses et approximations effectuées.")

La surpression vérifie une équation de d'Alembert. On admet que la vitesse vérifie une équation de d'Alembert analogue.

=== Célérité
#encadré(
    titre: "Célérité d'une onde sonore dans un gaz parfait",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "Dans l'approximation acoustique.",
        "Le fluide est macroscopiquement au repos.",
        "L'évolution est adiabatique réversible.",
        "Le gaz est parfait.",
    ),
    grandeurs: ("c": grandeurs.at("c"), "gamma": grandeurs.at("gamma"), "R": grandeurs.at("R"), "T": (signification: "la température", unité: unit("K")), "M": grandeurs.at("M")),
)[
    $ c = sqrt((gamma R T)/M) $
]

#question-de-colle("Montrer que les ondes sonores sont longitudinales et établir la célérité d'une onde sonore dans un gaz parfait.")

#application[
    Déterminer la célérité d'une onde sonore dans l'air, considéré comme un gaz parfait diatomique, à la température de référence. L'air est constitué de $qty("80", "%")$ de diazote ($M(N) = qty("14", "g/mol")$) et de $qty("20", "%")$ de dioxygène ($M(O) = qty("16", "g/mol")$).
]

La célérité d'une onde sonore dans l'eau est environ $c_"eau" = qty("1400", "m/s")$.

== Ondes électromagnétiques dans le vide
Les ondes électromagnétiques sont la variation couplée des champs électrique et magnétique ; elles se propagent dans le vide ou dans un milieu.

=== Spectre électromagnétique
Ondes radio, lumière visible et invisible, rayons X et $gamma$ sont des ondes électromagnétiques.

#figure(image("images/spectre EM.svg", width: 100%))

=== Équation de propagation
#encadré(
    titre: "Équation de propagation d'une onde électromagnétique",
    connaitre: true,
    savoir-faire: true,
    hypothèses: "Dans le vide.",
    grandeurs: sub-dictionary(grandeurs, ("va(E)", "va(B)", "c", "mu_0", "epsilon_0")),
)[
    $
        Delta va(E) - 1/c^2 pdv(va(E), t, 2) = va(0) quad "et" quad Delta va(B) - 1/c^2 pdv(va(B), t, 2) = va(0)
    $
    avec $c = 1 \/ sqrt(epsilon_0 mu_0)$.
]

#question-de-colle("Établir l'équation aux dérivées partielles vérifiée par une onde électromagnétique dans le vide, en précisant les hypothèses faites.")

#application[
    Vérifier l'homogénéité de l'expression $c = 1 \/ sqrt(mu_0 epsilon_0)$.
]

= Solutions de l'équation de d'Alembert
== Ondes progressives
Dans un milieu unidimensionnel, une onde progressive est une fonction de $x - c t$ (propagation vers les $x$ croissants) ou de $x + c t$ (propagation vers les $x$ décroissants).

#flashcard(recto: "Onde progressive (1D)", verso: "Fonction de $x - c t$ (propagation vers les $x$ croissants) ou de $x + c t$ (vers les $x$ décroissants).")

#exemple[$A cos(k(x + c t))$, $B sin(omega t - omega/c x)$, $C exp((- x - c t)/lambda)$ sont des ondes progressives.]

Une onde est solution de l'équation de d'Alembert 1D si et seulement si c'est une somme de deux ondes progressives de sens opposés.

#application[Montrer qu'une superposition d'ondes progressives est solution de l'équation de d'Alembert.]

== Forme des surfaces d'onde
Une surface d'onde est une surface sur laquelle la phase de l'onde est constante ; à $t$ fixé, l'onde y prend la même valeur en tout point.

- #strong[Onde plane] : surfaces d'onde planes ; dans un repère cartésien bien choisi, fonction de $t$ et d'une seule coordonnée.
- #strong[Onde cylindrique] : surfaces d'onde cylindriques ; fonction de $t$ et de $r$ (cylindrique).
- #strong[Onde sphérique] : surfaces d'onde sphériques ; fonction de $t$ et de $r$ (sphérique).

#application[
    Dire si les ondes suivantes sont planes, cylindriques ou sphériques :
    $P_1 = A cos(omega t - k x)$ ; $va(E) = B sin(omega t - k y) va(e_x)$ ; $P_1 = C f(omega t + k sqrt(x^2 + y^2))$ ; $P_1 = D cos(omega t + va(k) dot va(O M))$ ; $P_1 = E cos(omega t - k norm(va(O M)))$.
]

== Notion de polarisation
Pour une onde transversale, la direction de la grandeur est orthogonale à la direction de propagation. Pour une onde polarisée rectilignement, cette direction reste constante au cours du temps.

#exemple[$va(E) = E_0 cos(omega t - k x) va(e_z)$ est une onde polarisée rectilignement.]

Un polariseur est un dispositif permettant de sélectionner une direction de polarisation.

== Ondes (planes) progressives harmoniques
Une onde (plane) progressive harmonique (OP(P)H) est une onde progressive dont la dépendance en $x - c t$ est sinusoïdale.

#encadré(
    titre: "Onde (plane) progressive harmonique",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("y_0", "omega", "va(k)", "lambda", "va(n)", "phi")),
)[
    $ y(M, t) = y_0 cos(omega t - va(k) dot va(O M) + phi) $
]

#flashcard(recto: "Onde (plane) progressive harmonique", verso: "$ y(M, t) = y_0 cos(omega t - va(k) dot va(O M) + phi) $ (ou $y_0 cos(omega t plus.minus k x + phi)$ en 1D)")

En 1D : $y(M, t) = y_0 cos(omega t plus.minus k x + phi)$ (le signe $+$ correspond à une onde vers les $x$ décroissants, $-$ vers les $x$ croissants). $k$ est le #strong[nombre d'onde].

On associe à l'OPH $y = y_0 cos(omega t - va(k) dot va(O M) + phi)$ la grandeur complexe $underline(y) = y_0 e^(j(omega t - va(k) dot va(O M) + phi))$.

#encadré(
    titre: "Dérivées pour une OP(P)H",
    connaitre: true,
    savoir-faire: true,
    hypothèses: [$underline(y)$ et $va(underline(A))$ sont les représentations complexes d'OP(P)H quelconques.],
    grandeurs: sub-dictionary(grandeurs, ("underline(y)", "va(underline(A))", "omega", "va(k)", "k")),
)[
    $
        pdv(underline(y), t) = j omega underline(y) quad
        div va(underline(A)) = - j va(k) dot va(underline(A)) quad
        grad underline(y) = - j va(k) underline(y) \
        rot va(underline(A)) = - j va(k) and va(underline(A)) quad
        Delta underline(y) = - k^2 underline(y) quad
        Delta va(underline(A)) = - k^2 va(underline(A))
    $
]

#question-de-colle("Définir une onde plane progressive harmonique. Établir l'expression de la dérivée temporelle, de la divergence, du gradient et du laplacien pour une OPPH.")

#flashcard(recto: "Dérivées pour une OPH", verso: "$pdv(underline(y), t) = j omega underline(y)$ ; $div va(underline(A)) = - j va(k) dot va(underline(A))$ ; $grad underline(y) = - j va(k) underline(y)$ ; $Delta underline(y) = - k^2 underline(y)$")

Les dérivées spatiales se résument par $nabla -> - j va(k)$.

=== Caractère longitudinal des ondes sonores
#encadré(
    titre: "Caractère longitudinal d'une onde sonore",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "Dans l'approximation acoustique.",
        "Le fluide est macroscopiquement au repos.",
        "L'évolution est adiabatique réversible.",
    ),
)[
    Les ondes sonores sont longitudinales : la vitesse du fluide est colinéaire à la direction de propagation.
]

=== Relation de dispersion
#encadré(
    titre: "Relation de dispersion (équation de d'Alembert)",
    connaitre: true,
    savoir-faire: true,
    hypothèses: ("L'onde vérifie l'équation de d'Alembert.", "L'onde est une O(P)PH."),
    grandeurs: sub-dictionary(grandeurs, ("omega", "va(k)", "c")),
)[
    $ omega^2/k^2 = c^2 $
]

#flashcard(recto: "Relation de dispersion pour une équation de d'Alembert", verso: "$ omega^2/k^2 = c^2 $")

=== Vitesse de phase
La vitesse de phase est la vitesse à laquelle se propage un plan de phase constante.

#encadré(
    titre: "Vitesse de phase",
    connaitre: true,
    savoir-faire: true,
    hypothèses: [L'onde est une OPH s'écrivant $y = y_0 cos(omega t - k x)$.],
    grandeurs: sub-dictionary(grandeurs, ("v_phi", "omega", "k")),
)[
    $ v_phi = omega/k $
]

#encadré(
    titre: "Vitesse de phase pour une OPH de d'Alembert",
    connaitre: true,
    savoir-faire: true,
    hypothèses: ("L'onde est une OPH.", "L'onde vérifie l'équation de d'Alembert."),
    grandeurs: sub-dictionary(grandeurs, ("v_phi", "c")),
)[
    $ v_phi = plus.minus c $
]

#flashcard(recto: "Vitesse de phase", verso: "$ v_phi = omega/k $, et $v_phi = plus.minus c$ pour une OPH de d'Alembert")

#question-de-colle("Établir la relation de dispersion. Définir la vitesse de phase en justifiant cette définition. Établir la vitesse de phase pour une OPH vérifiant l'équation de d'Alembert.")

=== Superposition d'OPH
L'équation de d'Alembert étant linéaire, toute combinaison linéaire de solutions est solution. Toute onde périodique se décompose en série de Fourier d'OPH, toute onde en intégrale de Fourier d'OPH : connaître la propagation des OPH suffit à connaître celle de n'importe quelle onde.

== Ondes stationnaires
Une onde stationnaire ne se propage pas : la position des sommets et des creux ne varie pas dans le temps. Les points d'amplitude nulle sont les #strong[nœuds], ceux d'amplitude maximale les #strong[ventres].

Une onde stationnaire s'écrit souvent comme un produit d'une fonction de $t$ et d'une fonction de l'espace ; une onde (plane) stationnaire harmonique s'écrit $A cos(omega t + phi) cos(va(k) dot va(O M) + psi)$.

== Quelle solution privilégier ?
#flashcard(
    recto: "Solution à privilégier selon le milieu",
    verso: "Milieu infini : solutions progressives. Milieu fini ou semi-infini : solutions stationnaires.",
)

Dans un milieu infini, on privilégie les solutions progressives ; dans un milieu fini ou semi-infini, les solutions stationnaires.

= Conditions aux limites dans un milieu fini ou semi-infini
Un milieu semi-infini possède un bord (une condition aux limites), un milieu fini deux bords (deux conditions aux limites).

== Conditions strictes
Une condition aux limites stricte impose une valeur constante (souvent nulle) à l'onde en un point.

#schéma(titre: "Conditions strictes pour la corde", hauteur: 4cm)

Pour un câble coaxial : court-circuit ($u = 0$) ou circuit ouvert ($i = 0$).

#schéma(titre: "Conditions strictes pour un câble coaxial", hauteur: 3cm)

Pour une onde sonore, la condition porte sur la surpression ou sur la vitesse.

#exemple[Dans un tuyau, une extrémité fermée impose une vitesse nulle et une extrémité ouverte impose une surpression nulle.]

Pour une onde électromagnétique : dans un métal parfait la conductivité est infinie, donc le champ électrique y est nul ; la composante tangentielle de $va(E)$ étant continue, un métal parfait impose une condition stricte au champ électrique tangent.

#schéma(titre: "Condition stricte pour une onde électromagnétique", hauteur: 4cm)

=== Réflexion et onde stationnaire
Une OPH incidente se réfléchit sur une condition aux limites stricte et donne une onde stationnaire.

#encadré(
    titre: "Réflexion d'une OPH sur une condition stricte",
    savoir-faire: true,
    hypothèses: (
        [Onde incidente : OPH $underline(y_i) = Y_(0,i) e^(j(omega t + k x))$.],
        [Onde réfléchie : OPH $underline(y_r) = underline(Y_(0,r)) e^(j(omega t - k x))$.],
        [Condition aux limites : $forall t, thin y(0, t) = 0$.],
    ),
)[
    $ y(x, t) = - 2 Y_(0,i) sin(omega t) sin(k x) $
]

Une onde stationnaire peut donc s'écrire comme somme de deux ondes progressives.

#application[Montrer qu'une OPH peut s'écrire comme la somme de deux ondes stationnaires harmoniques.]

#question-de-colle("Montrer que la réflexion d'une OPH incidente sur une condition aux limites stricte donne lieu à une onde stationnaire. Montrer qu'une OPH peut aussi s'écrire comme une superposition d'ondes stationnaires.")

== Condition imposée
Une source (pot vibrant, générateur, membrane…) peut imposer la valeur de l'onde en un point.

== Deux conditions aux limites : quantification des modes propres
Dans un milieu fini, deux conditions aux limites sont imposées. Si elles sont toutes deux strictes, seules certaines ondes peuvent exister : les #strong[modes propres].

#encadré(
    titre: "Modes propres pour deux conditions strictes",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [$y$ est solution d'une équation de d'Alembert.],
        [Condition stricte en $L$ : $forall t, thin y(L, t) = 0$.],
        [Condition imposée en $0$ : $forall t, thin y(0, t) = a_0 cos(omega_0 t)$.],
        [$y$ est cherchée comme superposition d'une OPH incidente et d'une OPH réfléchie.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("omega_n", "c", "L")),
)[
    $ omega_n = n (pi c)/L quad "avec" quad n in NN^* $
]

#flashcard(recto: "Modes propres pour des conditions aux limites strictes", verso: "$ omega_n = n (pi c)/L $ avec $n in NN^*$")

Lorsque le milieu fini est excité à une fréquence proche d'un mode propre, l'amplitude devient très grande : c'est la #strong[résonance].

#application[
    Une corde de longueur $L$ est accrochée à un vibreur imposant $a_0 cos(omega t)$ en $x = 0$ ; l'autre extrémité est fixe. Déterminer les pulsations de résonance et montrer qu'elles coïncident avec celles des modes propres.
]

#question-de-colle("Déterminer les modes propres d'une corde fixée à ses deux extrémités. Montrer que les fréquences de résonance sont celles des modes propres.")

= Relation entre grandeurs couplées
Les deux grandeurs couplées d'une onde sont liées par des relations simples pour les OPH.

== Impédance caractéristique d'un câble coaxial
#figure(image("images/impedance.jpg", width: 55%))

#encadré(
    titre: "Impédance caractéristique d'un câble coaxial",
    connaitre: true,
    savoir-faire: true,
    hypothèses: "Pour une OPH.",
    grandeurs: sub-dictionary(grandeurs, ("u(x, t)", "i(x, t)", "Z_c", "Lambda", "Gamma")),
)[
    $ u = plus.minus Z_c i quad "avec" quad Z_c = sqrt(Lambda/Gamma) $
    ($+$ pour une OPH vers les $x$ croissants, $-$ vers les $x$ décroissants.)
]

#flashcard(recto: "Impédance caractéristique d'un câble coaxial", verso: "$ Z_c = sqrt(Lambda \/ Gamma) $")
#flashcard(recto: "Condition pour avoir $u = Z_c i$ dans un câble coaxial", verso: "OPH se propageant dans le sens des $x$ croissants.")

#question-de-colle("Définir l'impédance caractéristique d'un câble coaxial. Établir le lien entre tension et courant pour des OPH se propageant dans les deux sens.")

=== Réflexion sur une impédance terminale
#schéma(titre: "Câble coaxial fermé sur une impédance terminale", hauteur: 4cm)

#encadré(
    titre: "Coefficient de réflexion sur une résistance terminale",
    savoir-faire: true,
    hypothèses: (
        [Onde incidente : OPH $u_i = u_(i,0) cos(omega t - k x)$.],
        [Onde réfléchie : OPH $u_r = u_(r,0) cos(omega t + k x + phi)$.],
        [Le câble est fermé sur une résistance $R_t$ en $x = 0$.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("u_(i\,0)", "u_(r\,0)", "R_t", "Z_c")),
)[
    $ u_(r,0)/u_(i,0) = (R_t - Z_c)/(R_t + Z_c) $
]

Lorsque la résistance terminale est égale à l'impédance caractéristique, il n'y a pas d'onde réfléchie : le câble est #strong[adapté].

#exemple[Les prises d'antenne de téléviseur sont chargées par une résistance égale à l'impédance caractéristique du câble, pour éviter toute réflexion.]

#question-de-colle("Montrer que l'onde réfléchie est nulle lorsqu'un câble coaxial est fermé sur une résistance égale à son impédance caractéristique. Citer une application.")

== Impédance acoustique
#encadré(
    titre: "Impédance acoustique",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "Pour une OPPH.",
        "Dans l'approximation acoustique.",
        "Le fluide est macroscopiquement au repos.",
        "L'évolution est adiabatique réversible.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("P_1(M, t)", "va(v)_1", "va(n)", "Z_a", "rho_0", "c")),
)[
    $ P_1 = Z_a thin va(v) dot va(n) quad "avec" quad Z_a = rho_0 c $
]

#flashcard(recto: "Impédance acoustique", verso: "$ Z_a = rho_0 c $")
#flashcard(recto: "Condition pour avoir $P_1 = Z_a v$", verso: "OPPH se propageant dans le sens croissant.")

#question-de-colle("Définir l'impédance acoustique. Établir le lien entre surpression et vitesse pour une OPPH dans le sens croissant.")

== Relation de structure
L'équation de Maxwell-Faraday fournit une relation entre les champs pour une OPPH.

#encadré(
    titre: "Relation de structure d'une OPPH électromagnétique",
    connaitre: true,
    savoir-faire: true,
    hypothèses: ("Pour une OPPH.", "Dans le vide."),
    grandeurs: sub-dictionary(grandeurs, ("va(B)", "va(k)", "va(E)", "omega")),
)[
    $ va(B) = (va(k) and va(E))/omega $
]

Les vecteurs $va(k)$, $va(E)$ et $va(B)$ sont mutuellement orthogonaux et $(va(k), va(E), va(B))$ forme un trièdre direct.

#flashcard(recto: "Relation de structure", verso: "$ va(B) = (va(k) and va(E))/omega $")

#question-de-colle("Démontrer la relation de structure pour une OPPH électromagnétique. En déduire que $(va(k), va(E), va(B))$ est un trièdre direct.")

= Aspects énergétiques
== Énergie acoustique
=== Vecteur de Poynting
Le vecteur de Poynting est le vecteur densité surfacique de puissance transportée par l'onde.

#encadré(
    titre: "Vecteur de Poynting acoustique",
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("va(Pi)", "P_1(M, t)", "va(v)_1")),
)[
    $ va(Pi) = P_1 va(v) $
]

#flashcard(recto: "Vecteur de Poynting acoustique", verso: "$ va(Pi) = P_1 va(v) $")

=== Intensité acoustique
#encadré(
    titre: "Intensité acoustique",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("I", "va(Pi)")),
)[
    $ I = mean(norm(va(Pi))) $
]

#flashcard(recto: "Intensité acoustique", verso: "$ I = mean(norm(va(Pi))) $")

Les intensités sonores usuelles s'étalant sur de nombreux ordres de grandeur, on introduit le niveau sonore.

#encadré(
    titre: "Niveau sonore",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("I", "I_0")),
)[
    $ I_"dB" = 10 log(I/I_0) $
]

#flashcard(recto: "Niveau sonore (en dB)", verso: "$ 10 log(I \/ I_0) $")

$I_0 = qty("1e-12", "W/m^2")$ est le plus faible son perceptible par l'oreille humaine.

#exemple[
    Quelques ordres de grandeur :
    - pièce calme : $qty("20", "dB")$ ;
    - conversation à $qty("1", "m")$ : $qty("60", "dB")$ ;
    - rue animée (réflexe stapédien) : $qty("80", "dB")$ ;
    - avion à quelques mètres (seuil de douleur) : $qty("120", "dB")$.
]

#question-de-colle("Établir l'expression du vecteur de Poynting acoustique. Définir l'intensité acoustique et le niveau sonore. Citer quelques ordres de grandeur.")

=== Retour sur l'approximation acoustique
#encadré(
    titre: "Vérification des hypothèses de l'approximation acoustique",
    savoir-faire: true,
    hypothèses: (
        "Pour une OPPH.",
        [Dans l'air à la température de référence ($D_"th" = qty("2e-5", "m^2/s")$).],
    ),
)[
    Aux niveaux sonores usuels, l'évolution est adiabatique et $P_1 << P_0$, $norm(va(v)) << c$.
]

#question-de-colle("À l'aide d'ordres de grandeur de niveaux sonores usuels, vérifier que les hypothèses de l'approximation acoustique sont satisfaites.")

=== Forme d'une onde sphérique
#encadré(
    titre: "Forme d'une onde sonore sphérique",
    connaitre: true,
    hypothèses: "L'onde est sphérique.",
    grandeurs: sub-dictionary(grandeurs, ("P_1(M, t)",)),
)[
    $ P_1 = f(r - c t)/r + g(r + c t)/r $
]

#flashcard(recto: "Onde sphérique", verso: "$ P_1 = f(r - c t)/r + g(r + c t)/r $")

Une onde sphérique s'atténue : sa puissance s'étale sur une surface croissante.

#application[Montrer que la puissance moyenne traversant une sphère de rayon $r gt.double 1 \/ k$ ne dépend pas de $r$.]

== Énergie électromagnétique
=== Conservation de l'énergie
#encadré(
    titre: "Équation locale de conservation de l'énergie (Poynting)",
    savoir-faire: true,
    hypothèses: "L'onde peut céder de la puissance aux porteurs de charge.",
    grandeurs: sub-dictionary(grandeurs, ("w", "va(Pi)", "va(j)_text(\"élec\")", "va(E)")),
)[
    $ pdv(w, t) = - div va(Pi) - va(j)_"élec" dot va(E) $
]

Ce bilan permet d'identifier le vecteur de Poynting et la densité volumique d'énergie.

#encadré(
    titre: "Densité d'énergie et vecteur de Poynting électromagnétiques",
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("w", "va(Pi)", "va(E)", "va(B)", "mu_0", "epsilon_0")),
)[
    $ w = (epsilon_0 E^2)/2 + B^2/(2 mu_0) quad "et" quad va(Pi) = (va(E) and va(B))/mu_0 $
]

#flashcard(recto: "Densité volumique d'énergie électromagnétique", verso: "$ w = (epsilon_0 E^2)/2 + B^2/(2 mu_0) $")
#flashcard(recto: "Vecteur de Poynting électromagnétique", verso: "$ va(Pi) = (va(E) and va(B))/mu_0 $")

#question-de-colle("Par un bilan local d'énergie, établir par identification l'expression du vecteur de Poynting et de la densité volumique d'énergie électromagnétiques.")

=== Flux de photons
Le photon est une particule élémentaire de masse nulle qui transporte l'énergie de l'onde électromagnétique.

#encadré(
    titre: "Relation de Planck-Einstein",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("cal(E)", "h", "nu")),
)[
    $ cal(E) = h nu $
]

#flashcard(recto: "Relation de Planck-Einstein", verso: "$ cal(E) = h nu $")

#application[Déterminer le débit de photons d'un pointeur laser rouge de puissance $qty("5", "mW")$.]

=== Énergie d'une OPPH
#encadré(
    titre: "Densité d'énergie et vecteur de Poynting d'une OPPH",
    savoir-faire: true,
    hypothèses: ("Dans le vide.", [OPPH $va(E) = E_0 cos(omega t - k x) va(e_y)$.]),
    grandeurs: sub-dictionary(grandeurs, ("w", "va(Pi)", "E_0", "epsilon_0", "mu_0", "c")),
)[
    $ mean(w) = (epsilon_0 E_0^2)/2 quad "et" quad mean(va(Pi)) = E_0^2/(2 c mu_0) va(e_x) $
]

Pour une OPPH, l'énergie est équirépartie entre forme électrique et forme magnétique, et l'énergie se propage dans la direction de l'onde.
