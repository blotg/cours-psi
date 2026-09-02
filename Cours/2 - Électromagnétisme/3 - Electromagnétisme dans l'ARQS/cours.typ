#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)

#let grandeurs = (
    t: (signification: "le temps", unité: unit("s")),
    j: (signification: "le vecteur densité volumique de courant", unité: unit("A/m^2")),
    rho: (signification: "la densité volumique de charge", unité: unit("C m^3")),
    epsilon_0: (signification: "la permittivité diélectrique du vide", unité: unit("F/m")),
    mu_0: (signification: "la perméabilité magnétique du vide", unité: unit("H/m")),
    E: (signification: "le champ électrique", unité: unit("V/m")),
    B: (signification: "le champ magnétique", unité: unit("T")),
    tau: (signification: "durée caractéristique de variation des grandeurs", unité: unit("s")),
    lambda: (signification: "longueur caractéristique du système", unité: unit("m")),
    "I_text(\"enlacé\")": (signification: "le courant électrique enlacé par la courbe d'Ampère", unité: unit("A")),
    Phi: (signification: "le flux du champ magnétique", unité: unit("T m^2")),
    e: (signification: "la force électromotrice", unité: unit("V")),
    B_0: (signification: "l'amplitude du champ magnétique extérieur", unité: unit("T")),
    "cal(P)_text(\"vol\")": (
        signification: "la densité volumique de puissance dissipée par effet Joule",
        unité: unit("W/m^3"),
    ),
    gamma: (signification: "la conductivité électrique", unité: unit("S/m")),
    omega: (signification: "la pulsation", unité: unit("rad/s")),
    h: (signification: "la hauteur du cylindre", unité: unit("m")),
    a: (signification: "le rayon du cylindre", unité: unit("m")),
    L: (signification: "l'inductance propre", unité: unit("H")),
    i: (signification: "l'intensité du courant", unité: unit("A")),
    u_L: (signification: "la tension aux bornes de la bobine", unité: unit("V")),
    "cal(E)": (signification: "l'énergie stockée ", unité: unit("J")),
    "Phi_1": (signification: "le flux magnétique sur la bobine 1", unité: unit("T m^2")),
    "Phi_(1 arrow 1)": (signification: "le flux propre de la bobine 1", unité: unit("T m^2")),
    "Phi_(2 arrow 1)": (signification: "le flux mutuel induit par la bobine 2 sur la bobine 1", unité: unit("T m^2")),
    L_1: (signification: "l'inductance propre de la bobine 1", unité: unit("H")),
    L_2: (signification: "l'inductance propre de la bobine 2", unité: unit("H")),
    M: (signification: "l'inductance mutuelle entre la bobine 1 et la bobine 2", unité: unit("H")),
    i_1: (signification: "l'intensité du courant circulant dans la bobine 1", unité: unit("A")),
    i_2: (signification: "l'intensité du courant circulant dans la bobine 2", unité: unit("A")),
)

= ARQS magnétique
== Conservation de la charge

Les équations de Maxwell sont compatibles avec l'équation locale de conservation de la charge.

#encadré(
    titre: "Équation locale de conservation de la charge",
    connaitre: true,
    savoir-faire: true,
    grandeurs: grandeurs,
)[
    $ div va(j)+ (partial rho)/(partial t)=0 $
]

#flashcard(
    recto: "Équation locale de conservation de la charge",
    verso: "$ div va(j) + (partial rho)/(partial t)=0 $",
)
#question-de-colle(
    "Énoncer les 4 équations de Maxwell et établir l'équation locale de conservation de la charge.",
)

== Courants de déplacement

Le terme $epsilon_0 (partial va(E))/(partial t)$ se nomme courant de déplacement. Son unité est $unit("A/m^2")$.

L'ARQS#footnote[approximation des régimes quasi-stationnaire] magnétique consiste à négliger les courants de déplacement.

#encadré(
    titre: "Équation de Maxwell dans l'ARQS",
    connaitre: true,
    hypothèses: ("Dans l'ARQS magnétique",),
    grandeurs: grandeurs,
)[
    $ div va(E)=rho / epsilon_0 $
    $ rot va(E)=-(partial va(B))/(partial t) $
    $ div va(B)=0 $
    $ rot va(B) = mu_0 va(j) $
]

#flashcard(
    recto: "Équations de Maxwell dans l'ARQS",
    verso: "$ div va(E)=rho / epsilon_0 $
        $ rot va(E)=-(partial va(B))/(partial t) $
        $ div va(B)=0 $
        $ rot va(B) = mu_0 va(j) $",
)

#encadré(
    titre: "Condition d'application de l'ARQS",
    savoir-faire: true,
    grandeurs: grandeurs,
    [
        $ lambda / tau << c $
    ],
)

#question-de-colle(
    "Énoncer les équations de Maxwell dans l'ARQS. Établir la condition à laquelle on peut négliger les courants de déplacement.",
)

== Du régime stationnaire au régime variable

Dans l'ARQS magnétique, les équation de Maxwell-Thomson et Maxwell-Ampère sont les mêmes qu'en stationnaire. Tous les résultats vus dans le chapitre "Champ magnétique en régime stationnaire" restent donc valables.

#encadré(
    titre: "Théorème d'Ampère",
    connaitre: true,
    savoir-faire: true,
    grandeurs: grandeurs,
    hypothèses: ("Dans l'ARQS magnétique",),
    [ $ integral.cont_cal(C) va(B).va(dif l)=mu_0 I_text("enlacé") $],
)

== Principe de l'ARQS

Dans l'ARQS, les courants créent des champs magnétiques (qu'on peut déterminer avec le théorème d'Ampère) qui induisent à leur tour des champs électriques (qu'on peut déterminer avec la loi de Maxwell-Faraday).

Dans l'ARQS, le champ magnétique induit le champ électrique.

= Induction

== Circulation du champ électrique

#encadré(
    titre: "Circulation du champ électrique",
    connaitre: true,
    savoir-faire: true,
    grandeurs: grandeurs,
    [
        $ integral.cont_cal(C) va(E).va(dif l)=- (dif Phi)/(dif t) $
    ],
)

#flashcard(
    recto: "Circulation du champ électrique dans l'ARQS",
    verso: "$ integral.cont_cal(C) va(E).va(dif l)=- (dif Phi)/(dif t) $",
)

Dans le cas où $cal(C)$ suit un circuit électrique, on obtient la loi de Lenz-Faraday.

#encadré(
    titre: "Loi de Lenz-Faraday",
    connaitre: true,
    grandeurs: grandeurs,
    [
        $ e=- (dif Phi)/(dif t) $
    ],
)

#flashcard(
    recto: "Loi de Lenz-Faraday",
    verso: "$ e=- (dif Phi)/(dif t) $",
)

#application(
    [Un circuit électrique carré de côté $a$ comportant un condensateur de capacité $C$ et un résistor de résistance $R$ est placé dans un champ magnétique $va(B)=B_0 cos(omega t)va(e)_z$ qui lui est orthogonal. Représenter le circuit électrique équivalent.],
)

== Courant de Foucault

Lorsqu'un cylindre conducteur est placé dans un champ magnétique oscillant, des courants y apparaissent. Ces courants sont appelés courants de Foucault.

#encadré(
    titre: "Courants de Foucault",
    savoir-faire: true,
    hypothèses: (
        "A l'intérieur du cylindre",
        "Dans l'ARQS",
        [Le cylindre est plongé dans un champ magnétique $B=B_0 cos(omega t) va(e_z)$],
    ),
    grandeurs: grandeurs,
    [
        $ va(E)= 1/2 B_0 omega r sin(omega t) va(e_theta) $
    ],
)

La présence d'un champ électrique dans un milieu conducteur entraine la production de chaleur par effet Joule#footnote[Les détails de cette production de chaleur seront étudiés dans le chapitre "Transport de charge".].

#encadré(
    titre: "Densité volumique de puissance dissipée par effet Joule",
    connaitre: true,
    hypothèses: (
        "Dans un conducteur ohmique",
        "Dans l'ARQS",
    ),
    grandeurs: grandeurs,
    [
        $ cal(P)_text("vol")=gamma E^2 $
    ],
)

#encadré(
    titre: "Puissance moyenne dissipée par les courants de Foucault",
    savoir-faire: true,
    hypothèses: (
        "Dans un conducteur ohmique",
        "Dans l'ARQS",
    ),
    grandeurs: grandeurs,
    [
        $ P_text("moy")= (pi gamma B_0^2 omega^2 h a^4)/16 $
    ],
)

#question-de-colle(
    "Établir l'expression du vecteur densité de courant puis de la puissance dissipée par les courants de Foucault dans un cylindre conducteur placé dans un champ magnétique uniforme et sinusoïdal.",
)

#application[Le fond d'une casserole en fer ($gamma_ce("Fe")=qty("1e7", "S/m")$) a un rayon de #qty(15, "cm") et une épaisseur de #qty(1, "cm"). La casserole est posée sur un plaque à induction qui emmet un champ magnétique oscillant à la fréquence #qty(20, "kHz"). Quelle amplitude doit avoir le champ magnétique pour que la puissance apportée à la casserole soit de #qty(1, "kW") ?]

== Intérêt du feuilletage

Dans les transformateurs et dans les moteurs, des pièces métalliques sont placées dans des champs magnétiques variables et sont donc le siège de courants de Foucault. Ces courants de Foucault représentent des pertes qu'on souhaite limiter.

Pour limiter les pertes par courant de Foucault, on utilise le *feuilletage*. Le feuilletage consiste à découper la pièce métallique en feuillets séparés par de l'isolant électrique afin d’empêcher les courants de Foucault de circuler. Le feuilletage doit être effectué dans une direction orthogonale aux courants de Foucault.

#figure(
    grid(
        columns: 2,
        image("images/transformateur.jpg"), image("images/rotor.jpg"),
    ),
    caption: "Transformateur et rotor d'un moteur électrique dont le feuilletage est visible.",
)

= Inductance propre, inductance mutuelle

== Cas du solénoïde

#encadré(
    titre: "Champ magnétique et flux pour un solénoïde",
    savoir-faire: true,
    hypothèses: (
        "Les effets de bord sont négligés.",
        "Le champ magnétique est nul à l'extérieur du solénoïde est nul.",
        "Le solénoïde est assimilé à une succession de spires resserrées et d'espacement constant.",
    ),
    grandeurs: grandeurs,
    [
        $ B=mu_0 N/l i va(e_x) $
        $ Phi=pi R^2 mu_0 (N^2)/l i $
    ],
)


Le flux magnétique propre est proportionnel au courant. Cette propriété peut être généralisée. Le coefficient de proportionnalité est l'inductance propre.

#encadré(
    titre: "Inductance propre",
    connaitre: true,
    grandeurs: grandeurs,
    [
        $ Phi=L i $
    ],
)

#question-de-colle(
    "Établir le champ magnétique créé par un solénoïde puis son inductance propre.",
)

#application[
    Calculer l'inductance propre d'un solénoïde de #qty(10, "cm") de long et de #qty(1, "cm") de rayon comportant #num(1000) spires.
]

#encadré(
    titre: "Relation tension-courant pour une bobine",
    savoir-faire: true,
    connaitre: true,
    grandeurs: grandeurs,
    [
        $ u_L = L (dif i)/(dif t) $
    ],
)

== Énergie stockée

#encadré(
    titre: "Énergie stockée dans une bobine",
    savoir-faire: true,
    connaitre: true,
    grandeurs: grandeurs,
    [
        $ cal(E)=1/2 L i^2 $
    ],
)

Dans l'exemple d'un solénoïde, l'énergie stockée s'écrit $cal(E)=1/2 mu_0 pi R^2 N^2/L i^2$. On peut utiliser cette expression pour exprimer la densité volumique d'énergie magnétique.

#encadré(
    titre: "Densité volumique d'énergie magnétique",
    savoir-faire: true,
    connaitre: true,
    hypothèses: (
        [L'expression obtenue pour un solénoïde peut être généralisée.],
    ),
    grandeurs: grandeurs,
    [
        $ w=1/2 mu_0 B^2 $
    ],
)

#flashcard(
    recto: "Densité volumique d'énergie magnétique",
    verso: "$ w=1/2 mu_0 B^2 $",
)
#question-de-colle(
    "Sur l'exemple du solénoïde, établir l'expression de la densité volumique d'énergie magnétique.",
)

== Inductance mutuelle

Lorsque deux bobines sont présentes simultanément, le champ magnétique créé par l'une peut induite une tension dans l'autre. Ce phénomène s'appelle *induction mutuelle*.

#encadré(
    titre: "Flux magnétique",
    connaitre: true,
    grandeurs: grandeurs,
    [
        $ Phi_1=Phi_(1 arrow 1)+Phi_(2 arrow 1)=L_1 i_1 + M i_2 $
    ],
)

#flashcard(
    recto: "Flux propre",
    verso: "$ Phi_(1 arrow 1)= integral.double(S_1) va(B_1).va(dif S) = L_1 i_1 $",
)
#flashcard(
    recto: "Flux mutuel",
    verso: "$ Phi_(2 arrow 1)= integral.double(S_1) va(B_2).va(dif S) = M i_2 $",
)

L'inductance mutuelle $M$ dépend de la géométrie et de la position relative des deux bobines. Si les bobines sont infiniment éloignées, $M=0$.


#encadré(
    titre: "Énergie stockée dans deux bobines en interaction",
    savoir-faire: true,
    connaitre: true,
    grandeurs: grandeurs,
    [
        $ cal(E)=1/2 L_1 (i_1)^2 + 1/2 L_2 (i_2)^2 + M i_1 i_2 $
    ],
)

En plus de l'énergie stockée dans chacune des bobines $1/2 L_1 i_1^2$ et $1/2 L_2 i_2^2$, un troisième terme $M i_1 i_2$ correspondant à l’interaction des bobines apparait.

#encadré(
    titre: "Valeur limite de l'inductance mutuelle",
    savoir-faire: true,
    connaitre: true,
    grandeurs: grandeurs,
    [
        $ M <= sqrt(L_1 L_2) $
    ],
)

#flashcard(
    recto: "Inégalité vérifiée par l'inductance mutuelle $M$",
    verso: "$ M<= sqrt(L_1 L_2) $",
)
#question-de-colle(
    "A partir de l'expression des flux magnétiques, établir l'énergie stockée dans deux bobines en interaction puis établir une inégalité portant sur l'inductance mutuelle et les inductances propres.",
)
