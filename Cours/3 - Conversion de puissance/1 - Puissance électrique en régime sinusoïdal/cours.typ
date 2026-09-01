#import "@local/prepa:0.1.1": *

#show: cours.with(infos: yaml("infos.yml"))

#let grandeurs = (
    T: (signification: "la période", unité: unit("s")),
    S: (signification: "l'amplitude", unité: none),
    omega: (signification: "la pulsation", unité: unit("rad/s")),
    phi: (signification: "la phase à l'origine", unité: unit("rad")),
    "S_\"eff\"": (signification: "la valeur efficace", unité: none),
    p_C: (signification: "la puissance instantanée reçue par un condensateur", unité: unit("W")),
    p_L: (signification: "la puissance instantanée reçue par une bobine", unité: unit("W")),
    p_R: (signification: "la puissance instantanée reçue par un résistor", unité: unit("W")),
    R: (signification: "la résistance", unité: unit("\ohm")),
    "U_\"eff\"": (signification: "la valeur efficace de la tension", unité: unit("V")),
    "I_\"eff\"": (signification: "la valeur efficace du courant", unité: unit("A")),
    "cos(phi)": (signification: "le facteur de puissance", unité: "sans unité"),
    "underline(Z)": (signification: "l'impédance", unité: unit("O")),
    "underline(Y)": (signification: "l'admittance", unité: unit("S")),
    P: (signification: "la puissance moyenne reçue par le dipole", unité: unit("W")),
)

= Distinguer les grandeurs
== Grandeur instantanée
La grandeur instantanée est la valeur d'une grandeur à un instant en particulier.

#exemple[$u(t)$, $i(t)$]

== Différents régimes
Il existe différents régimes :
- le régime permanent dans lequel les grandeurs instantanées sont constantes
- le régime sinusoïdal
- le régime périodique dans lequel les grandeurs sont des fonctions périodiques du temps et dont le régime sinusoïdal est un cas particulier. Dans le régime périodique, tout signal peut être décomposé en série de Fourier, c'est-à-dire comme une somme de signaux sinusoïdaux.
- le régime transitoire

== Amplitude
L'amplitude pic à pic est la différence entre la valeur la plus haute et la valeur la plus basse.

L'amplitude est la moitié de l'amplitude pic à pic.

#schéma(titre: "Amplitude et amplitude pic à pic")[#box(height: 3cm)]

== Valeur moyenne
La valeur moyenne est définie pour les signaux périodiques. La valeur moyenne est la valeur autour de laquelle évolue le signal.

#encadré(
    titre: "Valeur moyenne",
    connaitre: true,
    hypothèses: (
        [$s$ est périodique],
    ),
    grandeurs: sub-dictionary(grandeurs, "T"),
)[
    $ chevron.l s chevron.r = 1/T integral_0^T s(t) dd(t) $
]

#flashcard(
    recto: "Valeur moyenne",
    verso: "$ chevron.l s chevron.r = 1/T integral_0^T s(t) dd(t) $",
)

#schéma(titre: "Valeur moyenne")[#box(height: 3cm)]

#encadré(
    titre: "Valeur moyenne d'un signal sinusoïdal",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [$s$ est sinusoïdal],
    ),
    grandeurs: sub-dictionary(grandeurs, ("T", "S", "omega", "phi")),
)[
    $ chevron.l S cos(omega t + phi) chevron.r = 0 $
]

#flashcard(
    recto: "Valeur moyenne d'un signal sinusoïdal",
    verso: "$ 0 $",
)

== Valeur efficace

#encadré(
    titre: "Valeur efficace",
    connaitre: true,
    hypothèses: (
        [$s$ est périodique],
    ),
    grandeurs: sub-dictionary(grandeurs, ("S_\"eff\"",)),
)[
    $ S_"eff" = sqrt(chevron.l s^2(t) chevron.r) $
]

#flashcard(
    recto: "Valeur efficace",
    verso: "$ S_\"eff\" = sqrt( chevron.l s^2(t) chevron.r ) $",
)

La valeur efficace de la tension délivrée aux foyers par Enedis est #qty("230", "V").

En électricité, la valeur efficace d'une tension est la tension continue qui, si elle était appliquée aux bornes d'un résistor, y dissiperait la même puissance par effet Joule.

#application[Calculer la résistance d'un radiateur de #qty("1", "kW").]

En électricité, la valeur efficace d'un courant est le courant continu qui, s'il était appliqué aux bornes d'un résistor, y dissiperait la même puissance par effet Joule.

#application[Calculer le courant qui circule dans un radiateur de #qty("1", "kW").]

#encadré(
    titre: "Valeur efficace d'un signal sinusoïdal",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [$s$ est sinusoïdal, de valeur moyenne nulle],
    ),
    grandeurs: sub-dictionary(grandeurs, ("S", "S_\"eff\"")),
)[
    $ S_"eff" = S / sqrt(2) $
]

#flashcard(
    recto: "Valeur efficace d'un signal sinusoïdal",
    verso: "$ S_\"eff\" = S / sqrt(2) $",
)

#question-de-colle(
    "Définir la valeur moyenne et la valeur efficace. Déterminer la valeur moyenne et la valeur efficace de $S cos(omega t+phi)$.",
)

#application[Calculer l'amplitude de la tension délivrée aux foyers par Enedis.]

= Puissance reçue par un dipole
La puissance instantanée reçue par un dipole est $p(t)=u(t) i(t)$ en convention récepteur.

== Puissance moyenne reçue par un dipôle purement réactif

#encadré(
    titre: "Puissance moyenne reçue par un condensateur",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [En régime périodique],
        [Pour un condensateur],
    ),
    grandeurs: sub-dictionary(grandeurs, ("p_C",)),
)[
    $ chevron.l p_C chevron.r = 0 $
]

#flashcard(
    recto: "Puissance moyenne reçue par un condensateur",
    verso: "$ 0 $",
)

#encadré(
    titre: "Puissance moyenne reçue par une bobine",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [En régime périodique],
        [Pour une bobine],
    ),
    grandeurs: sub-dictionary(grandeurs, ("p_L",)),
)[
    $ chevron.l p_L chevron.r = 0 $
]

#flashcard(
    recto: "Puissance moyenne reçue par une bobine",
    verso: "$ 0 $",
)

== Puissance moyenne reçu par un dipôle purement résistif
#encadré(
    titre: "Puissance moyenne reçue par un résistor",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [En régime périodique],
        [Pour un résistor],
    ),
    grandeurs: sub-dictionary(grandeurs, ("p_R", "U_\"eff\"", "R", "I_\"eff\"")),
)[
    $ chevron.l p_R chevron.r = R I_"eff"^2 = U_"eff"^2 / R $
]

#application[
    #grid(
        columns: (70%, 30%),
        [
            Calculer la résistance de la lampe halogène (assimilée à un résistor) en photo.
        ],
        image("images/Ampoule-Halogène.jpg", width: 100%),
    )
]

#flashcard(
    recto: "Puissance moyenne reçue par une résistor",
    verso: "$ R I_\"eff\"^2 = U_\"eff\"^2 / R $",
)
#question-de-colle(
    "Déterminer en régime périodique la puissance moyenne reçue par un condensateur, une bobine et un résistor.",
)

= Puissance en régime sinusoïdal
En électricité, on appelle régime sinusoïdal le régime dans lequel les tensions et les courants sont des fonctions sinusoïdales (sans valeurs moyennes) du temps : $u(t)=U cos(omega t+phi_u)$ et $i(t)=I cos(omega t + phi_i)$). La puissance $p(t)=u(t)i(t)$ peut comporter une valeur moyenne non nulle.

== Notations complexes
Aux grandeurs sinusoïdales, on peut associer des grandeurs complexes permettant de faciliter les calculs. À $s(t)=S cos(omega t+phi)$, on associe $underline(s)(t)=S e^(j( omega t+phi))=underline(S)e^(j omega t)$. La grandeur $underline(S)=S e^(j phi)$ est appelée amplitude complexe.

#schéma(titre: "Diagramme de Fresnel")[#box(height: 3cm)]

Pour passer d'une grandeur complexe $underline(s)$ à une grandeur $s$, on prend la partie réelle : $s=Re(underline(s))$.

== Grandeurs caractéristiques d'un dipole
L'impédance est $underline(Z)=underline(U) / underline(I)$.

La résistance $R$ est la partie réelle de l'impédance.

La réactance $X$ est la partie imaginaire de l'impédance.

#flashcard(
    recto: "Réactance",
    verso: "$X=Im(underline(Z))$",
)

L’admittance $underline(Y)$ est l'inverse de l'impédance. L'admittance se mesure en siemens.

#flashcard(
    recto: "Admittance",
    verso: "$underline(Y)=1/underline(Z)$",
)

#flashcard(
    recto: "Unité de l'admittance",
    verso: "Siemens ($unit(\"S\") = unit(\"1/O\")$",
)

#application[
    Donner l'impédance et exprimer la résistance, la réactance et l'admittance pour un résistor, un condensateur et une bobine. Les réponses seront représentées sous la forme d'un tableau.
]

Un dipole dont la réactance est positive est dit inductif. Un dipole dont la réactance est négative est dit capacitif.

Un dipole de résistance nulle est dit purement réactif.

#schéma(titre: "Diagramme de Fresnel pour un dipole inductif et un dipole capacitif")[#box(height: 3cm)]

== Puissance moyenne reçue par un dipole

#encadré(
    titre: "Puissance moyenne reçue par un dipole en régime sinusoïdal",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [En régime sinusoïdal],
        [Le dipole est linéaire],
    ),
    grandeurs: sub-dictionary(grandeurs, ("U_\"eff\"", "I_\"eff\"", "phi", "cos(phi)", "underline(Z)", "P")),
)[
    $ P = U_"eff" I_"eff" cos phi $
]

#application[
    Une habitation qu'on modélise par une impédance $underline(Z)$ est alimentée via des cables de résistance $r$ par une source de tension. Exprimer le courant en fonction de la valeur efficace $U_"eff"$ aux bornes de l'habitation, de la puissance qu'elle consomme et de son facteur de puissance. En déduire la puissance moyenne perdue par effet Joule dans les câbles.
]

Afin de limiter les pertes par effet Joule lors du transport, on utilise une tension aussi élevée que possible.

#question-de-colle("Démontrer l'expression de la puissance perdue lors du transport du courant (pertes en ligne) et expliquer comment les réduire.")

#exemple[Le réseau Très Haute Tension qui transporte le courant sur des longues distance a une tension de #qty("400","kV").]

#application[Par combien divise-t-on les pertes par effet Joule dans les cables en utilisant une tension de #qty("20","kV") (ligne moyenne tension) plutôt que de #qty("230","V") ?]

Le facteur de puissance a aussi un effet important car pour une même puissance et une même tension, le courant sera d'autant plus grand que le facteur de puissance est petit, ce qui entraine des pertes par effet Joule. Les fabricants cherchent à rapprocher le facteur de puissance de $1$.

La vidéo du lien ci-dessous debunk un boitier sensé améliorer le facteur de puissance dans les habitations.
#lien("https://www.youtube.com/watch?v=1FLwy4XPBg0")

#encadré(
    titre: "Puissance moyenne reçue par un dipole en régime sinusoïdal",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [En régime sinusoïdal],
        [Le dipole est linéaire],
    ),
    grandeurs: sub-dictionary(grandeurs, ("underline(Z)", "I_\"eff\"", "P")),
)[
    $ P = Re(underline(Z)) I_"eff"^2 $
]

#application[
    On modélise un appareil électroménager de #qty("2100","W") par une impédance $Z=qty("20","O") + qty("10","O")j$. Calculer le courant efficace le traversant.
]

#encadré(
    titre: "Puissance moyenne reçue par un dipole en régime sinusoïdal",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [En régime sinusoïdal],
        [Le dipole est linéaire],
    ),
    grandeurs: sub-dictionary(grandeurs, ("underline(Y)", "U_\"eff\"", "P")),
)[
    $ P = Re(underline(Y)) U_"eff"^2 $
]
#application[
    On modélise un appareil par une impédance $Z=qty("20","O") + qty("10","O")j$. Calculer son admittance puis la puissance moyenne qu'il reçoit.
]

#flashcard(
    recto: "Puissance reçue par un dipôle en régime sinusoïdal",
    verso: "$P=U_\"eff\" I_\"eff\" cos phi = Re(underline(Z))I_\"eff\"^2=Re(underline(Y))U_\"eff\"^2$",
)

#question-de-colle(
    "En régime sinusoïdal, exprimer la puissance reçue par un dipole d'impédance $Z$ en fonction de du facteur de puissance, puis de l'impédance et enfin de l'admittance.",
)
