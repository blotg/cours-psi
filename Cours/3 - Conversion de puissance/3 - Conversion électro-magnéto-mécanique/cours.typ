#import "@local/prepa:0.1.0": *

#show: cours.with(infos: yaml("infos.yml"))

#let grandeurs = (
    "B": (signification: "le champ magnétique", unité: unit("T")),
    "mu_0": (signification: "la perméabilité magnétique du vide", unité: unit("H/m")),
    "mu_r": (signification: "la perméabilité magnétique relative du matériau ferromagnétique", unité: "sans unité"),
    "N": (signification: "le nombre de spires", unité: "sans unité"),
    "i": (signification: "le courant", unité: unit("A")),
    "l_\"fixe\"": (
        signification: "la longueur du circuit magnétique dans le milieu ferromagnétique fixe",
        unité: unit("m"),
    ),
    "l_\"mobile\"": (
        signification: "la longueur du circuit magnétique dans le milieu ferromagnétique mobile",
        unité: unit("m"),
    ),
    "x": (signification: "la largeur des entrefers", unité: unit("m")),
    "L": (signification: "l'inductance propre", unité: unit("H")),
    "S": (signification: "la section du circuit magnétique", unité: unit("m^2")),
    "F_\"ém\"": (signification: "la force électromagnétique s'exerçant sur la partie mobile", unité: unit("N")),
    "cal(E)": (signification: "l'énergie magnétique dans le système", unité: unit("J")),
    "e": (signification: "l'épaisseur de l'entrefer", unité: unit("m")),
    "theta": (signification: "la seconde coordonnée du point en coordonnées cartésiennes", unité: unit("rad")),
    "I_s": (
        signification: "la valeur efficace du courant dans chacun des deux enroulements statoriques",
        unité: unit("A"),
    ),
    "omega": (
        signification: "la pulsation du courant circulant dans les enroulements statoriques",
        unité: unit("rad/s"),
    ),
    "t": (signification: "le temps", unité: unit("s")),
    "B_(s 1)": (
        signification: "le champ magnétique créé par le circuit statorique 1 dans l'entrefer",
        unité: unit("T"),
    ),
    "B_s": (
        signification: "le champ magnétique créé par les deux circuits statoriques dans l'entrefer",
        unité: unit("T"),
    ),
    "B_r": (signification: "le champ magnétique créé par le circuit rotorique dans l'entrefer", unité: unit("T")),
    "I_e": (signification: "l'intensité du courant (continu) dans le circuit excitateur", unité: unit("A")),
    "theta_r": (signification: "l'inclinaison du rotor", unité: unit("rad")),
    "N_r": (signification: "le nombre de spires de l'enroulement rotorique", unité: "sans unité"),
    "N_s": (signification: "le nombre de spires de l'enroulement statorique", unité: "sans unité"),
    "R": (signification: "le rayon moyen de la machine", unité: unit("m")),
    "h": (signification: "la hauteur de la machine", unité: unit("m")),
    "Gamma_\"ém\"": (signification: "le moment électromagnétique exercé sur le rotor", unité: unit("N m")),
    "Omega": (signification: "la vitesse angulaire du rotor", unité: unit("rad/s")),
    "alpha": (signification: "l'angle entre le rotor et le champ statorique", unité: unit("rad")),
    "u_1": (signification: "la tension aux bornes de l'enroulement statorique 1", unité: unit("V")),
    "u_2": (signification: "la tension aux bornes de l'enroulement statorique 2", unité: unit("V")),
    "i_1": (signification: "le courant dans l'enroulement statorique 1", unité: unit("A")),
    "i_2": (signification: "le courant dans l'enroulement statorique 2", unité: unit("A")),
    "R_s": (signification: "la résistance de chaque enroulement statorique", unité: unit("Ω")),
    "E_1": (
        signification: "$=dv(Phi_1,t)$ la force contre-électromotrice dans l'enroulement statorique 1",
        unité: unit("V"),
    ),
    "E_2": (
        signification: "$=dv(Phi_2,t)$ la force contre-électromotrice dans l'enroulement statorique 2",
        unité: unit("V"),
    ),
    "Phi_1": (signification: "le flux mutuel du circuit rotorique sur le circuit statorique 1", unité: unit("Wb")),
    "Phi_2": (signification: "le flux mutuel du circuit rotorique sur le circuit statorique 2", unité: unit("Wb")),
    "P_\"ém\"": (signification: "la puissance moyenne reçue par les forces contre-électromotrices", unité: unit("W")),
    "P_\"méca\"": (signification: "la puissance mécanique moyenne fournie par le moteur", unité: unit("W")),
    "K": (signification: "la constante de couplage de la machine à courant continu", unité: unit("N m/A^2")),
    "I_r": (signification: "l'intensité du courant (continu) dans le circuit rotorique", unité: unit("A")),
    "Phi_0": (signification: "la constante de couplage", unité: unit("Wb")),
    "E_\"cém\"": (signification: "la force contre-électromotrice dans le circuit rotorique", unité: unit("V")),
)


= Contacteur électromagnétique en translation
== Présentation
Le contacteur électromécanique en translation est composé de deux parties ferromagnétiques. Une partie est fixe, l'autre partie est mobile. Les deux parties sont séparées par deux entrefers.

#figure(image("images/relais.png", height: 5cm), caption: "Contacteur électromécanique en translation")


#schéma(titre: "Contacteur électromécanique en translation")[#box(height: 3cm)]

Le courant électrique crée un champ magnétique qui fait se déplacer la partie mobile.

Le contacteur électromécanique en translation est utilisé pour fabriquer un relais. Un relais est un interrupteur commandé par un courant électrique.

== Inductance

#encadré(
    titre: "Champ magnétique dans l'entrefer",
    savoir-faire: true,
    hypothèses: (
        "Le matériau ferromagnétique est doux, hors saturation.",
        $mu_r >> 1$,
        "La section du circuit magnétique est constante.",
        "Les effets de bord sont négligés dans l'entrefer.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("B", "mu_0", "mu_r", "N", "i", "l_\"fixe\"", "l_\"mobile\"", "x")),
)[
    $ B=(mu_0 N i)/((l_"fixe" + l_"mobile")/ mu_r+2x) $
]

#encadré(
    titre: "Inductance propre",
    savoir-faire: true,
    hypothèses: (
        "Le matériau ferromagnétique est doux, hors saturation.",
        $mu_r >> 1$,
        "La section du circuit magnétique est constante.",
        "Les effets de bord sont négligés dans l'entrefer.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("L", "mu_0", "mu_r", "N", "l_\"fixe\"", "l_\"mobile\"", "x", "S")),
)[
    $ L=(mu_0 mu_r N^2S)/(l_"fixe"+l_"mobile"+2 mu_r x) $
]

== Énergie et forces électromagnétique

#encadré(
    titre: "Force électromagnétique",
    grandeurs: sub-dictionary(grandeurs, ("F_\"ém\"", "cal(E)", "x", "i")),
)[
    $ F_"ém"= lr(pdv(cal(E), x) \))_i $
]

#encadré(
    titre: "Force sur la partie mobile",
    savoir-faire: true,
    hypothèses: (
        "Le matériau ferromagnétique est doux, hors saturation.",
        $mu_r >> 1$,
        "La section du circuit magnétique est constante.",
        "Les effets de bord sont négligés dans l'entrefer.",
    ),
    grandeurs: sub-dictionary(grandeurs, (
        "F_\"ém\"",
        "mu_0",
        "mu_r",
        "N",
        "S",
        "i",
        "l_\"fixe\"",
        "l_\"mobile\"",
        "x",
    )),
)[
    $ F_"ém"=- (mu_0 mu_r^2 N^2 S i^2)/( (l_"fixe" + l_"mobile" + 2 mu_r x)^2) $
]

#question-de-colle(
    "Déterminer le champ magnétique dans l'entrefer d'un contacteur électromagnétique en translation, puis en déduire la force s'exerçant sur la partie mobile, la formule $F_\"ém\"= lr(pdv(cal(E),x) \))_i$ étant fournie.",
)

La force électromagnétique est toujours attractive. La force électromagnétique tend à diminuer le volume des entrefers.

#flashcard(
    recto: "Sens de la force électromagnétique.",
    verso: "La force électromagnétique est toujours attractive. La force électromagnétique tend à diminuer le volume des entrefers.",
)

#application[
    Déterminer la force nécessaire pour forcer un portail fermé par un verrou magnétique. On donne $i=qty("20", "mA")$, $mu_r=num("1e5")$, $N=num("2000")$, $S=qty("4", "cm^2")$, $l_"fixe"+l_"mobile"=qty("30", "cm")$.
]

= Machine synchrone
== Structure
La machine synchrone peut être utilisée comme un moteur ou comme un alternateur. La machine synchrone a un très bon rendement.

#exemple[
    Des machines synchrones sont utilisées dans les TGV, certaines voitures électriques et les centrales de production électriques (hors éoliennes).
]

La machine synchrone est constituée d'une partie fixe, appelée stator et d'une partie mobile appelée rotor. Le stator est aussi appelé induit. Le rotor est aussi appelé inducteur.

#flashcard(
    recto: "Induit et inducteur de la machine synchrone",
    verso: "L'induit désigne les circuits statoriques, l'inducteur désigne le circuit rotorique.",
)

Sur le rotor, un circuit électrique est enroulé orthogonalement à l'axe de rotation.

Sur le stator, plusieurs circuits électriques sont enroulés orthogonalement à l'axe de rotation. Sur une machine diphasée, il y a deux enroulements tournés de #qty("90", "deg") l'un par rapport à l'autre.

Les circuits électriques peuvent donner naissance à plusieurs paires de pôles. Dans une machine bipolaire, chaque enroulement donne naissance à une seule paire de pôles.

Les circuits électriques se trouvent dans des encoches sur le matériau ferromagnétique. L'entrefer est très étroit.

#schéma(titre: "Structure d'une machine synchrone diphasée et bipolaire")[#box(height: 4cm)]

#grid(
    columns: (1fr, 1fr),
    column-gutter: 10pt,
    figure(image("images/zoe.jpg", height: 5cm), caption: "Stator du moteur synchrone d'une Renault Zoé."),
    figure(image("images/centrale.jpg", height: 5cm), caption: "Stator d'un alternateur de centrale nucléaire."),
)

== Champ statorique

#encadré(
    titre: "Champ créé par une spire verticale dans l'entrefer",
    savoir-faire: true,
    hypothèses: (
        "L'entrefer a une épaisseur constante.",
        "Les matériaux ferromagnétiques sont doux, hors saturation et de perméabilité magnétique infinie.",
        "La machine est diphasée et bipolaire.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("B_(s 1)", "mu_0", "i", "e", "theta")),
)[
    $
        va(B_(s 1))(theta)= cases(
            (mu_0 i)/(2e) va(e)_r "si" theta in \]-pi/2 \, pi/2 \[,
            -(mu_0 i)/(2e) va(e)_r "si" theta in \]pi/2 \, (3pi)/2 \[,
        )
    $
]

#question-de-colle(
    "Décrire la structure d'une machine synchrone et établir l'expression du champ magnétique créé dans l'entrefer par une spire d'un circuit électrique statorique.",
)

Un circuit statorique est constitué de plusieurs spires décalées dans l'espace. Ces spires sont placées de sorte que le champ créé soit sinusoïdal. Dans ces conditions, le champ magnétique créé par le circuit $cal(C)_1$ est $va(B_(s 1))=(2 mu_0 N_s)/(pi e) i_1 cos(theta) va(e)_r$.

#schéma(titre: [Champ statorique créé par 3 spires d'*un* circuit statorique])[#box(height: 4cm)]

Les deux circuits statoriques sont parcourus par des courants sinusoïdaux de même amplitudes en quadrature de phase $i_1=I sqrt(2) cos(omega t)$ et $i_2=I sqrt(2) cos(omega t+pi/2)$.

#encadré(
    titre: [Champ glissant statorique],
    savoir-faire: true,
    hypothèses: (
        [L'entrefer a une épaisseur constante.],
        [Les matériaux ferromagnétiques sont doux, hors saturation et de perméabilité magnétique infinie.],
        [La machine est diphasée et bipolaire.],
        [Les deux circuits statoriques sont parcourus par des courants $i_1=I_s sqrt(2) cos(omega t)$ et $i_2=I_s sqrt(2) cos(omega t+pi/2)$.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("B_s", "mu_0", "N_s", "I_s", "e", "omega", "t", "theta")),
)[
    $ va(B_s)=(2 mu_0 N_s)/(pi e) I_s sqrt(2) cos(omega t - theta) va(e)_r $
]

Ce champ magnétique est appelé champ glissant car il tourne#footnote[Pour être précis, la position du maximum de $B_s$ tourne.] à la pulsation $omega$ dans le sens trigonométrique.

#schéma(titre: "Champ glissant")[#box(height: 3cm)]

== Champ rotorique
Le circuit rotorique est parcouru par un courant continu $I_e$ appelé courant excitateur. Le champ produit par cet enroulement peut être trouvé par analogie avec le champ statorique.

#encadré(
    titre: "Champ rotorique",
    savoir-faire: true,
    hypothèses: (
        [L'entrefer a une épaisseur constante.],
        [Les matériaux ferromagnétiques sont doux, hors saturation et de perméabilité magnétique infinie.],
        [La machine est diphasée et bipolaire.],
        [Le circuit rotorique est alimenté par un courant $I_e$.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("B_r", "mu_0", "N_r", "I_e", "e", "theta", "theta_r")),
)[
    $ va(B_r) (theta)=(2 mu_0 N_r)/(pi e) I_e cos(theta - theta_r) va(e)_r $
]

== Énergie et couple

Connaissant le champ magnétique dans l'entrefer, il est possible d'en déduire l'énergie magnétique qui y est stockée et le couple électromagnétique exercé sur le rotor.

#encadré(
    titre: "Moment électromagnétique",
    grandeurs: sub-dictionary(grandeurs, ("Gamma_\"ém\"", "cal(E)", "theta_r")),
)[
    $ Gamma_"ém"= lr(pdv(cal(E), theta_r)\))_i $
]

#encadré(
    titre: "Moment électromagnétique pour la machine synchrone",
    savoir-faire: true,
    hypothèses: (
        [L'entrefer a une épaisseur constante.],
        [Les matériaux ferromagnétiques sont doux, hors saturation et de perméabilité magnétique infinie.],
        [La machine est diphasée et bipolaire.],
        [Les deux circuits statoriques sont parcourus par des courants $i_1=I_s sqrt(2) cos(omega t)$ et $i_2=I_s sqrt(2) cos(omega t+pi/2)$.],
        [Le circuit rotorique est alimenté par un courant $I_e$.],
    ),
    grandeurs: sub-dictionary(grandeurs, (
        "Gamma_\"ém\"",
        "mu_0",
        "N_r",
        "N_s",
        "I_e",
        "I_s",
        "e",
        "R",
        "h",
        "omega",
        "t",
        "theta_r",
    )),
)[
    $
        Gamma_"ém"= (4 sqrt(2) mu_0 N_r N_s R h)/( pi e^2) I_s I_e sin(omega t - theta_r)
    $
]


== Condition de synchronisme
On s'intéresse au régime permanent, dans lequel le rotor tourne à une vitesse angulaire $Omega$ constante. L'angle entre le rotor et le stator est donc une fonction affine du temps $theta_r=Omega t-alpha$.

#encadré(
    titre: "Couple moyen",
    savoir-faire: true,
    hypothèses: (
        [L'entrefer a une épaisseur constante.],
        [Les matériaux ferromagnétiques sont doux, hors saturation et de perméabilité magnétique infinie.],
        [La machine est diphasée et bipolaire.],
        [Les deux circuits statoriques sont parcourus par des courants $i_1=I_s sqrt(2) cos(omega t)$ et $i_2=I_s sqrt(2) cos(omega t+pi/2)$.],
        [Le circuit rotorique est alimenté par un courant continu $I_e$.],
        [Le rotor tourne à une vitesse angulaire constante.],
    ),
    grandeurs: sub-dictionary(grandeurs, (
        "Gamma_\"ém\"",
        "mu_0",
        "N_r",
        "N_s",
        "I_e",
        "I_s",
        "e",
        "R",
        "h",
        "omega",
        "Omega",
        "alpha",
    )),
)[
    $
        mean(Gamma_"ém") = cases(
            0 "si" Omega != omega,
            (4 sqrt(2) mu_0 N_r N_s R h)/(pi e^2) I_s I_e sin(alpha) "si" Omega = omega,
        )
    $
]

#question-de-colle(
    "Le champ statorique glissant $va(B_s)(theta)=k_s I_s sqrt(2) cos(omega t-theta) va(e)_r$, le champ rotorique $va(B_r)(theta)=k_r I_e cos(theta- theta_r) va(e)_r$ et la formule $Gamma_\"ém\"=lr(pdv(E,theta_r)\))_i$ étant fournis, déterminer l'expression du couple électromagnétique moyen subi par le rotor.",
)

La condition $Omega = omega$ est appelée condition de synchronisme. Dans une machine synchrone, pour avoir un couple non nul, il est indispensable que la rotation du rotor soit synchrone avec la rotation du champ glissant.

#flashcard(
    recto: "Condition à laquelle le couple électromagnétique moyen d'une machine synchrone est non nul.",
    verso: "La condition de synchronisme $Omega = omega$.",
)

Si $alpha > 0$ le champ glissant est en avance sur le rotor. Le couple moyen subi par le rotor est positif, le fonctionnement est moteur.

Si $alpha < 0$ le rotor est en avance sur le champ glissant. Le couple moyen subi par le rotor est négatif, le fonctionnement est générateur.

== Stabilité du système

#schéma(titre: [Courbe du couple moyen en fonction de $alpha$])[#box(height: 3cm)]

Pour $alpha in ]-pi/2, pi/2[$, le système est stable : si le couple résistant augmente, le rotor ralentit brièvement, augmentant ainsi l'angle $alpha$ entre rotor et champ tournant ; le couple moteur augmente alors pour s'ajuster au couple résistant.

Pour $alpha > pi/2$, le système est instable : si le couple résistant augmente, le rotor ralentit, augmentant ainsi l'angle $alpha$ entre rotor et champ tournant ; le couple moteur diminue alors, ce qui empire encore la situation.

Si le couple résistant dépasse $(4 sqrt(2) mu_0 N_r N_s R h)/(pi e^2) I_s I_e$, le moteur décroche et le couple moyen devient alors nul.

== Démarrage
La condition de synchronisme exige que la vitesse angulaire du rotor $Omega$ soit égale à la pulsation du courant statorique $omega$ pour avoir un couple non nul. Mais alors, comment faire démarrer un moteur synchrone initialement à l'arrêt ($Omega=0$) ? Il est possible de transformer le moteur synchrone en moteur asynchrone le temps du démarrage ou d'utiliser un système d'auto-pilotage qui asservit $alpha$ à une valeur voulue pour augmenter progressivement la vitesse angulaire du rotor.

== Modèle électrique de l'inducteur
L'enroulement rotorique est parcouru par un courant continu. Il n'est le siège d'aucun phénomène d'induction. La relation tension-courant s'écrit simplement $U_e=R_e I_e$ où $R_e$ est la résistance des fils.

== Modèle électrique de l'induit
Les enroulements statoriques sont le siège d'un phénomène d'induction.

#encadré(
    titre: "Modèle électrique des enroulements statoriques",
    savoir-faire: true,
    hypothèses: (
        [L'entrefer a une épaisseur constante.],
        [Les matériaux ferromagnétiques sont doux, hors saturation et de perméabilité magnétique infinie.],
        [La machine est diphasée et bipolaire.],
        [Les deux circuits statoriques sont parcourus par des courants $i_1=I_s sqrt(2) cos(omega t)$ et $i_2=I_s sqrt(2) cos(omega t+ pi/2)$.],
        [Le circuit rotorique est alimenté par un courant $I_e$.],
        [Le rotor tourne à une vitesse angulaire constante.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("u_1", "u_2", "i_1", "i_2", "R_s", "L", "E_1", "E_2", "Phi_1", "Phi_2")),
)[
    $ u_1(t)=R_s i_1 + L dv(i_1, t) + E_1 $
    $ u_2(t)=R_s i_2 + L dv(i_2, t) + E_2 $
]

#schéma(titre: "Schéma équivalent de l'induit")[#box(height: 4cm)]

#flashcard(
    recto: "Modèle électrique équivalent d'un moteur synchrone.",
    verso: "Une résistance, une bobine et une force contre-électromotrice en série. La force contre-électromotrice est en convention récepteur.",
)

#encadré(
    titre: "Flux induit du rotor sur le stator",
    hypothèses: (
        [L'entrefer a une épaisseur constante.],
        [Les matériaux ferromagnétiques sont doux, hors saturation et de perméabilité magnétique infinie.],
        [La machine est diphasée et bipolaire.],
        [Les deux circuits statoriques sont parcourus par des courants $i_1=I_s sqrt(2) cos(omega t)$ et $i_2=I_s sqrt(2) cos(omega t+ pi/2)$.],
        [Le circuit rotorique est alimenté par un courant $I_e$.],
        [Le rotor tourne à une vitesse angulaire constante.],
    ),
    grandeurs: sub-dictionary(grandeurs, (
        "Phi_1",
        "Phi_2",
        "mu_0",
        "N_r",
        "N_s",
        "I_e",
        "R",
        "h",
        "e",
        "omega",
        "alpha",
    )),
)[
    $
        Phi_1 & = (4 mu_0 N_r N_s I_e R h)/(pi e) cos(omega t - alpha) \
        Phi_2 & = (4 mu_0 N_r N_s I_e R h)/(pi e) cos(omega t - alpha + (pi)/2)
    $
]

L'angle de pilotage est $Psi=pi/2 - alpha$.

#flashcard(
    recto: "Angle de pilotage",
    verso: "Angle $Psi=pi/2 - alpha$ où $alpha$ est l'angle entre le champ glissant et le champ rotorique.",
)

#schéma(titre: "Angle de pilotage")[#box(height: 3cm)]

La loi des mailles peut être représentée sur un diagramme de Fresnel#footnote[Dans ce contexte, le diagramme de Fresnel est parfois appelé diagramme de Behn-Eschenburg].

#schéma(titre: "Diagramme de Fresnel de la loi des mailles")[#box(height: 4cm)]

== Rendement et puissance

Le moteur synchrone reçoit de la puissance sous forme électrique. Une partie est dissipée par effet Joule, le reste est transformée en puissance électromagnétique puis en puissance mécanique.

#encadré(
    titre: "Transfert de puissance électrique - mécanique",
    savoir-faire: true,
    connaitre: true,
    hypothèses: (
        [L'entrefer a une épaisseur constante.],
        [Les matériaux ferromagnétiques sont doux, hors saturation et de perméabilité magnétique infinie.],
        [La machine est diphasée et bipolaire.],
        [Les deux circuits statoriques sont parcourus par des courants $i_1=I_s sqrt(2) cos(omega t)$ et $i_2=I_s sqrt(2) cos(omega t+ pi/2)$.],
        [Le circuit rotorique est alimenté par un courant $I_e$.],
        [Le rotor tourne à une vitesse angulaire constante.],
        [Les seules pertes considérées sont les pertes cuivre.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("P_\"ém\"", "P_\"méca\"")),
)[
    $ P_"ém"=P_"méca" $
]

Il est possible de réaliser un bilan de puissance plus complet faisant apparaitre toutes les formes de pertes.

#schéma(titre: "Transfert de puissance électrique - mécanique")[#box(height: 4cm)]

== Fonctionnement en alternateur

Lorsqu'une machine synchrone fonctionne en alternateur, un système extérieur met le rotor en rotation, ce qui crée une force électromotrice dans les circuits induits.

En fonctionnement alternateur, le rotor "entraine" le champ glissant. En fonctionnement alternateur, le couple subi par le rotor est négatif donc $alpha<0$.

Si les courants dans les deux circuits induits sont identiques, on dit que l'alternateur est équilibré.

Si l'alternateur est équilibré, les relations vues précédemment sont valables en fonctionnement alternateur comme en fonctionnement moteur.

On définit la force électromotrice $-E_1$ l'opposé de la force contre-électromotrice.

#schéma(titre: "Schéma équivalent et diagramme de Fresnel en fonctionnement générateur")[#box(height: 4cm)]

#question-de-colle(
    "Représenter le schéma équivalent de l'induit en fonctionnement moteur et alternateur. Écrire la loi des mailles et la représenter sur un diagramme de Fresnel dans les deux cas.",
)

= Machine à courant continu
== Structure
La machine à courant continu est constituée d'un stator, aussi appelé inducteur#footnote[La correspondance induit/inducteur - rotor/stator est inversée par rapport à la machine synchrone.] sur lequel est enroulé un circuit électrique et d'un rotor, aussi appelé induit sur lequel sont enroulés plusieurs circuits électriques indépendants.

#flashcard(
    recto: "Inducteur et induit d'une machine à courant continu",
    verso: "L'induit désigne le circuit rotorique. L'inducteur désigne le circuit statorique.",
)

#exemple[
    Les machines à courant continu sont utilisées pour les petits équipements de voiture (essuie-glaces, vitres, rétroviseurs, ...), dans la plupart des appareils électroménagers et comme dynamo sur les anciennes bicyclettes.
]

Les enroulements rotorique et statorique sont parcourus par des courants continus $I_r$ et $I_e$ respectivement.

#figure(
    grid(
        columns: (1fr, 1fr),
        column-gutter: 10pt,
        image("images/MCC1.jpg", height: 5cm), image("images/MCC2.jpg", height: 5cm),
    ),
    caption: "Photographies de machines à courant continu dont on a retiré le capot.",
)

#schéma(titre: "Schéma en couple d'une machine à courant continu")[#box(height: 3cm)]

Dans une machine bipolaire, chaque enroulement donne naissance à une seule paire de poles.

Dans une machine à excitation séparée, les circuits rotoriques et statoriques sont séparés.

Par analogie avec la machine synchrone, l'interaction entre le champ induit et le champ inducteur donne lieu à un couple électromagnétique subi par le rotor si la condition de synchronisme est vérifiée.

#encadré(
    titre: "Couple électromagnétique",
    hypothèses: (
        [L'entrefer a une épaisseur constante.],
        [Les matériaux ferromagnétiques sont doux, hors saturation et de perméabilité magnétique infinie.],
        [La machine est diphasée et bipolaire.],
        [Le circuit statorique est alimenté par un courant $I_e$.],
        [Le circuit rotorique est alimenté par un courant continu $I_r$.],
        [Le rotor tourne à une vitesse angulaire constante.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("Gamma_\"ém\"", "K", "I_e", "I_r", "alpha")),
)[
    $ Gamma_"ém" = K I_e I_r sin alpha $
]

== Système balais-collecteurs

Pour faire en sorte que la condition de synchronisme soit toujours vérifiée et pour maximiser le couple électromagnétique, le système balais-collecteurs est utilisé. Parmi tous les enroulements rotoriques, le système balais-collecteurs fait passer du courant dans celui qui forme un angle $alpha=pi/2$ avec le stator.

Le système balais-collecteurs est constitué de collecteurs solidaires du rotor et reliés à chacun des enroulements rotoriques et de balais#footnote[Les balais sont aussi appelés charbon car ils sont souvent constitués de graphite.] qui sont solidaires avec le stator. Les balais frottent sur les collecteurs et connectent celui qui correspond au bon enroulement rotorique.

Le lien ci-dessous mène à une animation illustrant le fonctionnement du système balais-collecteurs.

#lien("https://youtu.be/LAtPHANEfQo?feature=shared")

#flashcard(
    recto: "Rôle du système balais-collecteur",
    verso: "Alimenter le circuit rotorique formant un angle $\pi/2$ avec le stator afin d'assurer la condition de synchronisme et maximiser le couple électromagnétique.",
)

#grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 10pt,
    figure(image("images/collecteurs.jpg", height: 3cm), caption: "Collecteurs"),
    figure(image("images/balais.jpg", height: 3cm), caption: "Balais"),
    figure(image("images/balais-collecteur.jpg", height: 3cm), caption: "Système balais-collecteurs"),
)

Le frottement des balais sur les collecteurs dégrade le rendement de la machine à courant continu et use les balais, qu'il faut changer régulièrement.

#question-de-colle(
    "Présenter la machine à courant continu à l'aide d'un schéma. Expliquer l'intérêt et le fonctionnement du système balais-collecteurs.",
)

== Relations entre grandeurs électriques et grandeurs mécaniques

Par analogie avec la machine synchrone, le couple électromagnétique subi par le rotor est proportionnel au courant rotorique.

#encadré(
    titre: "Couple électromagnétique d'une machine à courant continu",
    connaitre: true,
    hypothèses: (
        [L'entrefer a une épaisseur constante.],
        [Les matériaux ferromagnétiques sont doux, hors saturation et de perméabilité magnétique infinie.],
        [La machine est bipolaire à excitation séparée.],
        [Le circuit statorique est alimenté par un courant $I_e$.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("Gamma_\"ém\"", "Phi_0", "I_r")),
)[
    $ Gamma_"ém" = Phi_0 I_r $
]

#flashcard(
    recto: "Couple électromagnétique pour une machine à courant continu",
    verso: "$ Gamma_\"ém\" = Phi_0 I_r $",
)

#application[
    Vérifier l'homogénéité de la relation ci-dessus.
]

#application[
    Pour réaliser un treuil, on utilise un moteur à courant continu de constante de couplage #qty("0.11", "Wb") pour faire tourner un réducteur de rapport de transmission $1/100$ qui fait à son tour tourner une poulie de rayon #qty("3", "cm") sur lequel est enroulé un câble. Sachant que le moteur à courant continu a un courant maximum de #qty("6", "A"), quelle masse maximale le treuil peut-il soulever ?
]

La conservation de l'énergie dans une machine sans perte permet d'en déduire le lien entre force contre-électromotrice et vitesse angulaire.

#encadré(
    titre: "Force contre-électromotrice d'une machine à courant continu",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [L'entrefer a une épaisseur constante.],
        [Les matériaux ferromagnétiques sont doux, hors saturation et de perméabilité magnétique infinie.],
        [La machine est bipolaire à excitation séparée.],
        [Le circuit statorique est alimenté par un courant $I_e$.],
        [La machine ne comporte pas de pertes.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("E_\"cém\"", "Phi_0", "Omega")),
)[
    $ E_"cém" = Phi_0 Omega $
]

#flashcard(
    recto: "Force contre-électromotrice pour une machine à courant continu",
    verso: "$ E_\"cém\" = Phi_0 Omega $",
)

#application[
    Le moteur de treuil de l'application précédente a une tension d'alimentation de #qty("12", "V"). À quelle vitesse maximale le câble s'enroule-t-il ?
]

== Pertes
Les bilans énergétiques aux différentes étapes de conversion peuvent être représentés sur un schéma.

#schéma(titre: "Pertes aux différentes étapes de conversion en régime stationnaire")[#box(height: 4cm)]

#question-de-colle(
    "Énoncer la relation couple-courant pour une machine à courant continu. Établir la relation vitesse angulaire-tension pour une machine sans pertes. Présenter la chaine énergétique pour un moteur à courant continu, en faisant apparaitre tous les types de pertes.",
)

== Modèle électrique
Comme pour la machine synchrone, le modèle électrique de l'inducteur ne se compose que d'une résistance parcourue par un courant constant.

Le modèle équivalent de l'induit est le même que pour la machine synchrone, mais il n'y a qu'un seul circuit.

#schéma(titre: "Modèle électrique de l'induit")[#box(height: 3cm)]

#flashcard(
    recto: "Modèle équivalent de l'induit d'un moteur à courant continu",
    verso: "Résistance, bobine et force contre-électromotrice, le tout en convention récepteur.",
)
#flashcard(
    recto: "Modèle équivalent de l'induit d'une dynamo",
    verso: "Résistance, bobine et force électromotrice, le tout en convention générateur.",
)

Il est possible de déduire de ce modèle la caractéristique couple-vitesse angulaire lorsque la tension d'alimentation du moteur est constante.

#application[
    Déterminer la relation entre le couple $Gamma$ et la vitesse angulaire $Omega$ en régime stationnaire. Tracer $Omega$ en fonction de $Gamma$.
]

#question-de-colle(
    "Présenter le modèle équivalent de l'induit d'un moteur à courant continu. En déduire la caractéristique $(Omega, Gamma)$ en régime stationnaire.",
)

== Démarrage
Le moteur à courant continu n'a pas besoin d'aide pour démarrer, c'est même là que son couple est le plus important. En revanche, ce couple important se traduit aussi par un courant important, qu'il peut être souhaitable de limiter.

#application[
    On considère un moteur dont le rotor est lié à une hélice de bateau subissant un frottement fluide de couple $-f Omega$ mais pas de frottements solides. On note $J$ le moment d'inertie du système {rotor + hélice} Déterminer 4 relations liant les grandeurs électriques ($E_"cém"$ et $I_r$) et mécaniques ($Gamma$ et $Omega$).
]

#application[
    Pour un moteur à courant continu soumis à un frottement fluide $-f Omega$, présenter un schéma bloc résumant les relations entre les grandeurs électriques et les grandeurs mécaniques.
]

== Fonctionnement générateur
La machine à courant continu peut être utilisée en fonctionnement générateur, on parle alors de dynamo. En fonctionnement générateur, le champ statorique induit une tension dans l'enroulement rotorique.

#exemple[
    Les dynamos étaient utilisées pour générer l'électricité dans les voitures jusqu'aux années 60 et dans les bicyclettes jusqu'aux années 1990. Les dynamos ne sont quasiment plus utilisées en raison de leur mauvais rendement comparé aux alternateurs.
]

En fonctionnement générateur, on adopte préférentiellement la convention générateur, en posant $E_"cém" = -E_"ém"$.

#schéma(titre: "Schéma équivalent en fonctionnement générateur")[#box(height: 4cm)]
