#import "@local/prepa:0.1.1": *

#show: cours.with(infos: yaml("infos.yml"))

#let grandeurs = (
    "omega": (signification: "la pulsation", unité: unit("rad/s")),
    "va(underline(k))": (signification: "$=underline(k)va(u)$ le vecteur d'onde complexe", unité: unit("rad/m")),
    "k": (signification: "le nombre d'onde", unité: unit("rad /m")),
    "underline(k)": (signification: "$=k_r + j k_i$ le nombre d'onde complexe", unité: unit("rad /m")),
    "k_i": (signification: "la partie imaginaire du nombre d'onde complexe", unité: unit("rad /m")),
    "va(u)": (signification: "le vecteur unitaire dans lequel l'onde se propage"),
    "underline(y_0)": (signification: "$=y_0 e^(j phi)$ l'amplitude complexe"),
    "y_0": (signification: "l'amplitude"),
    "phi": (signification: "la phase à l'origine", unité: unit("rad")),
    "delta": (signification: "la profondeur de peau", unité: unit("m")),
    "v_g": (signification: "la vitesse de groupe", unité: unit("m/s")),
    "Delta f": (signification: "la largeur spectrale du paquet d'onde", unité: unit("Hz")),
    "Delta t": (signification: "l'étendue temporelle du paquet d'onde", unité: unit("s")),
    "rho": (signification: "la densité volumique de charge", unité: unit("C/m^3")),
    "va(E)": (signification: "le champ électrique", unité: unit("V/m")),
    "D": (signification: "$=1/(mu_0 gamma)$ le coefficient de diffusion", unité: unit("m^2/s")),
    "mu_0": (signification: "la perméabilité magnétique du vide", unité: unit("H/m")),
    "gamma": (signification: "la conductivité électrique du milieu", unité: unit("S/m")),
    "n": (signification: "la densité particulaire d'électrons", unité: unit("/m^3")),
    "m_e": (signification: "la masse d'un électron", unité: unit("kg")),
    "e": (signification: "la charge élémentaire", unité: unit("C")),
    "omega_p": (signification: "$=sqrt((n e^2) / (m_e epsilon_0))$ la pulsation plasma", unité: unit("rad/s")),
    "c": (signification: "la célérité de la lumière dans le vide", unité: unit("m/s")),
    "epsilon_0": (signification: "la permittivité diélectrique du vide", unité: unit("F/m")),
)

= Ondes dans les milieux diffusifs
== Onde électromagnétique dans un conducteur ohmique

Un conducteur ohmique est un milieu où la loi d'ohm locale est vérifiée.
#exemple[
    Solution électrolytique, métal.
]

=== Retour sur le modèle de Drude
La loi d'ohm locale a été démontrée en supposant le champ électrique uniforme et stationnaire, et en l'absence de champ magnétique.

#application[
    Comparer en ordre de grandeur les termes électrique et magnétique de la force de Lorentz.
]

#application[
    On peut supposer le champ uniforme à condition qu'il varie peu à l'échèle du libre parcours moyen des porteurs de charge ($qty("e-8","m")$). Calculer jusqu'à quelle fréquence cette hypothèse est valide dans le cuivre.
]

La loi d'ohm locale reste valable à condition que la période de l'onde soit très petite devant le temps moyen entre deux chocs.

=== Équation de propagation
#encadré(
    titre: "Neutralité locale du métal",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [La fréquence $f < qty("e14","Hz")$],
        [La conductivité est du même ordre de grandeur que celle du cuivre],
    ),
    grandeurs: sub-dictionary(grandeurs, ("rho",))
)[
    $ rho approx 0 $
]

#encadré(
    titre: "Équation de propagation de l'onde",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [La fréquence $f < qty("e14","Hz")$],
        [La conductivité est du même ordre de grandeur que celle du cuivre],
    ),
    grandeurs: sub-dictionary(grandeurs, ("va(E)", "D", "mu_0", "gamma")),
)[
    $ pdv(va(E),t) - D va(Delta) va(E) = 0 $
]

#question-de-colle("Montrer qu'un conducteur ohmique est localement neutre. Établir l'équation de propagation du champ électrique.")

Dans un conducteur ohmique, le champ électrique obéit à une équation de diffusion, tout comme la température (cf chapitre transfert thermique par conduction).

=== Relation de dispersion
#encadré(
    titre: "Relation de dispersion pour une OPPH dans un milieu diffusif",
    savoir-faire: true,
    hypothèses: (
        [L'onde vérifie une équation de diffusion],
        [L'onde est une OPPH],
    ),
    grandeurs: sub-dictionary(grandeurs, ("omega", "k", "D")),
)[
    $ k^2 = -j omega /D $
]

Cette relation de dispersion n'admet pas de solution réelle. On introduit le nombre d'onde complexe $underline(k)=k_r+j k_i$ solution de l'équation de diffusion.

= Ondes progressives en milieu linéaire
== Milieu linéaire
Pour une équation aux dérivées partielle linéaire, si $y_1$ et $y_2$ sont solutions, alors $lambda y_1+mu y_2$ est également solution.

#exemple[
    Équation de d'Alembert, équation de diffusion.
]

Un milieu linéaire est un milieu dans lequel les équations aux dérivées partielle décrivant l'évolution des grandeurs sont linéaires.

#exemple[
    L'air est un milieu linéaire pour les ondes sonores dans l'approximation acoustique. Les milieux homogènes sont des milieux linéaires pour les ondes thermiques.
]

== Onde progressive harmonique
La définition d'une OPH peut être élargie pour être solution de n'importe quelle équation aux dérivées partielles linéaire.

#encadré(
    titre: "Onde progressive harmonique",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("omega", "va(underline(k))", "underline(k)", "va(u)", "underline(y_0)", "y_0", "phi")),
)[
    $ underline(y)(M,t) = underline(y_0)e^(j (omega t - va(underline(k)).va(O M) )) $
]

#flashcard(
    recto: "Onde (plane) progressive harmonique dans un milieu linéaire quelconque.",
    verso: "$ underline(y)(M,t) = underline(y_0)e^(j (omega t - va(underline(k)).va(O M) )) $"
)

#application[
    Déterminer l'expression réelle d'une OPH. On notera $underline(k)=k_r+j k_i$.
]

== Paquet d'onde
#lien("https://upload.wikimedia.org/wikipedia/commons/c/c1/Wave_packet_%28no_dispersion%29.gif")

Une OPH a une extension temporelle et spatiale infinie, ce qui ne correspond pas aux ondes réelles.

Un paquet d'onde est une superposions d'OPH de pulsations proches et d'extension spatiale et temporelle finie.

Dans un milieu linéaire, on peut étudier la propagation d'un paquet d'onde en étudiant la propagation de chacune des OPH qui le composent.

#schéma(titre: "Représentations temporelle et fréquentielle d'un paquet d'onde", hauteur: 4cm)

La largeur spectrale du paquet d'onde est reliée avec son étendue temporelle.

#encadré(
    titre: "Relation entre étendue temporelle et largeur spectrale",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("Delta f", "Delta t")),
)[
    $ Delta f tilde.op 1 / (Delta t) $
]

#application[
    Un laser femtoseconde produit des impulsions de très courte durée (de l'ordre de la centaine de femtosecondes). Calculer l'ordre de grandeur de la largeur spectrale d'un laser femtoseconde rouge et comparer à la fréquence moyenne.
]

#flashcard(
    recto: "Relation entre étendue temporelle et largeur spectrale",
    verso: "$ Delta f tilde.op 1 / (Delta t) $"
)

== Vitesse de phase

La partie réelle de $underline(k)$ est en lien avec la propagation de la phase.

#encadré(
    titre: "Vitesse de phase",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("omega", "underline(k)")),
)[
    $ v_phi = omega / Re(underline(k)) $
]

#flashcard(
    recto: "Vitesse de phase",
    verso: "$ v_phi = omega / Re(underline(k)) $"
)

La vitesse de phase représente la vitesse à laquelle la phase se propage.

Un milieu *dispersif* est un milieu dans lequel la vitesse de phase dépend de la pulsation.

#application[
    Déterminer la vitesse de phase d'une OPPH se propageant dans le sens des $x$ croissants dans un milieu vérifiant l'équation de diffusion. Le milieu est-il dispersif ?
]

Dans un milieu dispersif, les différentes composantes d'un paquet d'onde se propagent à des vitesses différentes, ce qui entraîne un étalement du paquet d'onde.

#lien("https://upload.wikimedia.org/wikipedia/commons/b/b0/Wave_packet_%28dispersion%29.gif")

== Profondeur de peau

La partie imaginaire de $underline(k)$ est liée avec la variation de l'amplitude au cours de la propagation de l'onde.

#encadré(
    titre: [Profondeur de peau#footnote[Aussi appelée épaisseur de peau ou longueur de pénétration.]],
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("delta", "underline(k)")),
)[
    $ delta = 1 / (|Im(underline(k))|) $
]

#flashcard(
    recto: "Profondeur de peau",
    verso: "$ delta = 1 / (|Im(underline(k))|) $"
)

Quand l'onde a parcouru quelques fois la profondeur de peau, son amplitude devient négligeable.

#application[
    Déterminer la profondeur de peau d'une OPPH se propageant dans le sens des $x$ croissants dans un milieu vérifiant l'équation de diffusion. Le milieu est-il dispersif ? Déterminer la profondeur de peau.
]

Au fur et à mesure de la propagation dans un conducteur ohmique, l'onde électromagnétique perd de l'énergie qui est convertie en chaleur par effet Joule.

#encadré(
    titre: "Profondeur de peau dans le cuivre pour la fréquence du secteur",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [La conductivité du cuivre est #qty("6e7","S/m")],
        [La fréquence est celle du secteur (50 Hz)],
    ),
)[
    $ delta_"cuivre" approx qty("1","cm") $
]

#flashcard(
    recto: "Profondeur de peau dans le cuivre à qty(\"50\",\"Hz\")",
    verso: "#qty(\"1\",\"cm\")"
)

#application[
    Calculer la profondeur de peau pour une onde thermique dans un sol de diffusivité thermique #qty("0.2e-6","m^2/s") en considérant les variations journalières de température.
]

#question-de-colle("Pour une O(P)PH vérifiant une équation de diffusion, établir la relation de dispersion. En déduire la profondeur de peau. Donner sa valeur dans le cuivre à qty(\"50\",\"Hz\").")


== Vitesse de groupe

Dans un milieu dispersif, toutes les pulsations ne se propagent pas à la même vitesse. Il en résulte un étalement des paquets d'onde.

#application[
    On considère un paquet d'onde simplifié constitué de deux OPH de fréquences proches : $y(x,t)=cos(omega t-k x) + cos(( omega+dd(omega))t - (k+dd(k))x)$. En l'écrivant comme un produit de cosinus, montrer que son enveloppe se propage à la vitesse $dv(omega,k)$ et que se phase se propage à la vitesse $omega/k$.
]

#question-de-colle("Définir et représenter un paquet d'onde. Donner le lien entre étendue temporelle et largeur spectrale. Dans le cas simple d'un paquet d'onde constitué de seulement deux ondes sinusoïdales, montrer que l'enveloppe se propage à la vitesse de groupe.")

#encadré(
    titre: "Vitesse de groupe",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("v_g", "omega", "underline(k)"))
)[
    $ v_g = dv(omega, Re(underline(k))) $
]

#flashcard(
    recto: "Vitesse de groupe",
    verso: "$ v_g = dv(omega, Re(underline(k))) $"
)

#lien("https://upload.wikimedia.org/wikipedia/commons/b/bd/Wave_group.gif?uselang=fr")
La vitesse de groupe est la vitesse à laquelle l'envelope d'un paquet d'onde se propage.

#question-de-colle("Donner l'expression d'une O(P)PH dans un milieu linéaire quelconque. Définir vitesse de phase, vitesse de groupe et profondeur de peau.")

== Aspect énergétique pour une OPPH dans un conducteur ohmique
#application[
    On considère une OPPH électromagnétique dans un conducteur ohmique $va(underline(E)) = E_0 e^(j(omega t - underline(k) x)) ey$. Déterminer le champ magnétique puis le vecteur de Poynting.
]

L'onde a de moins en moins d'énergie au fur et à mesure de sa propagation. Le conducteur ohmique a absorbé de l'énergie qui a été convertie en chaleur par effet Joule.

Un métal parfait est un métal de conductivité électrique infinie.

Dans un métal parfait, la profondeur de peau est nulle. Dans un métal parfait, les champs électrique et magnétique sont nuls.

= Ondes électromagnétiques un plasma
== Le plasma

Un *plasma* est un état de la matière. Dans un plasma, des atomes ou des molécules ont été ionisés. Dans un plasma, il y a des électrons, des cations et éventuellement des espèces neutres. Un plasma est globalement neutre.

#exemple[
    Les éclairs, le soleil et les flammes de haute température sont des plasmas.
]
#exemple[
    L'ionosphère est une couche de la haute atmosphère ionisée par le rayonnement solaire.
]

Dans un plasma *dilué*, la concentration est faible. Dans un plasma dilué, les particules n’interagissent pas entre elles.

== Conductivité d'un plasma
Les ions ont une masse bien supérieure à celle des électrons, le déplacement des ions peut donc être négligé.

#encadré(
    titre: "Conductivité d'un plasma",
    savoir-faire: true,
    hypothèses: (
        [Pour une OPPH polarisée rectilignement],
        [Le plasma est dilué],
        [Les ions sont immobiles],
    ),
    grandeurs: sub-dictionary(grandeurs, ("gamma", "n", "omega", "m_e", "e")),
)[
    $ underline(gamma)=-j (n e^2)/(omega m_e) $
]

La conductivité est imaginaire, ce qui traduit un déphasage entre le champ électrique et le vecteur densité volumique de courant.

#application[
    On considère une OPPH $underline(va(E)) = E_0 e^(j(omega t - underline(k)x)) ey$. Déterminer le vecteur densité volumique de courant électrique puis la densité volumique de puissance cédée par l'onde aux porteurs de charge et enfin sa valeur moyenne.
]

#question-de-colle("Définir un plasma dilué. Établir la conductivité d'un plasma. En déduire que le champ électromagnétique ne cède pas de puissance aux porteurs de charge en moyenne.")

Un plasma ne reçoit en moyenne pas de puissance du champ électromagnétique.

== Relation de dispersion
#encadré(
    titre: "Relation de dispersion",
    savoir-faire: true,
    hypothèses: (
        [Pour une OPPH polarisée rectilignement],
        [Le plasma est dilué],
        [Les ions sont immobiles],
    ),
    grandeurs: sub-dictionary(grandeurs, ("underline(k)", "omega", "omega_p", "c", "n", "e", "m_e", "epsilon_0")),
)[
    $ underline(k)^2 = omega^2 / c^2 (1 - (omega_p^2 / omega^2)) $
]

Les solutions de la relation de dispersion dépendent du signe de $1- omega_p^2/omega^2$.

#application[
    Calculer la pulsation plasma pour l'ionosphère ($n approx qty("e5","/cm^3")$).
]

La fréquence de coupure correspondant à la pulsation plasma est de l'ordre de #qty("10","MHz") pour l'ionosphère.

== Pulsation supérieure à la pulsation plasma
Dans ce cas, la relation de dispersion a deux solutions réelles : $underline(k)= plus.minus omega/c sqrt((1-omega_p^2/ omega^2))$.

Le nombre d'onde est réel, ce qui traduit une propagation de l'onde sans atténuation dans l'ionosphère.

L'onde est une onde progressive qui transporte donc de l'énergie.

#application[
    Déterminer les vitesses de phase $v_phi$ et de groupe $v_g$ pour une OPPH dans l'ionosphère vérifiant $omega > omega_p$. Tracer $v_phi$ et $v_g$ en fonction de $omega$. L'ionosphère est-elle un milieu dispersif.
]

#question-de-colle("Établir la relation de dispersion pour une onde électromagnétique plane progressive harmonique dans un plasma dilué. Présenter les solutions pour $omega>omega_p$ et déterminer leur vitesse de groupe et de phase.")

== Pulsation inférieure à la pulsation plasma
Dans ce cas, la relation de dispersion a deux solutions imaginaires pures : $underline(k)= plus.minus j omega/c sqrt(omega_p^2/omega^2 - 1)$.

L'onde obtenue est une onde évanescente. Une onde évanescente est une onde stationnaire qui décroit exponentiellement avec la position.

#encadré(
    titre: "Onde évanescente",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("omega", "k_i"))
)[
    $ y(x,t)=y_0 cos(omega t + phi) e^(k_i x) $
]

#flashcard(
    recto: "Onde évanescente",
    verso: "$ y(x,t)=y_0 cos(omega t + phi) e^(k_i x) $"
)

#application[
    Déterminer le vecteur de Poynting pour une onde évanescente $va(E) = E_0 cos(omega t + phi)e^(k_i x) ey$ puis sa valeur moyenne.
]

Une onde évanescente ne transporte pas d'énergie en moyenne.

Lorsque $omega < omega_p$ les ondes ne traversent pas l'ionosphère, elles sont réfléchies.

#question-de-colle("Établir la relation de dispersion pour une onde électromagnétique plane progressive harmonique dans un plasma dilué. Présenter les solutions pour $omega<omega_p$ et montrer qu'elles ne transportent pas d'énergie en moyenne.")