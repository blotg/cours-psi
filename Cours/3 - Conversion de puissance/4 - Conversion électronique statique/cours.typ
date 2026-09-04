#import "@local/prepa:0.1.1": *

#show: cours.with(infos: yaml("infos.yml"))

#let grandeurs = (
    "T": (signification: "la période", unité: unit("s")),
    "Delta t_f": (signification: "la durée de fermeture de l'interrupteur", unité: unit("s")),
    "alpha": (signification: "$in [0,1]$ le rapport cyclique", unité: "sans unité"),
    "cal(A)": (signification: "$=integral_0^T s(t) dd(t)$ l'aire sous la courbe"),
    "s(t)": (signification: "une grandeur quelconque"),
    "s_\"max\"": (signification: "la valeur maximale de $s(t)$"),
    "s_\"min\"": (signification: "la valeur minimale de $s(t)$"),
)

= L'énergie électrique
L'énergie électrique peut se présenter sous plusieurs formes.

== Présentation alternative
En présentation alternative, le courant et la tension sont de moyenne nulle : $mean(u(t))=0$ et $mean(i(t))=0$. La puissance moyenne peut être non nulle $mean(u(t)i(t))$ peut être non nulle.

#exemple[
    L'électricité produite par les centrales nucléaires et hydroélectriques est produite par des alternateurs, elle est donc en présentation alternative.
]

#exemple[
    L'électricité du secteur et donc reçue par tous les appareils électroménagers est en présentation alternative.
]

== Présentation continue
En présentation continue $mean(u(t)) != 0$ ou $mean(i(t)) != 0$.

#exemple[
    Les piles, accumulateurs et panneaux photovoltaïques produisent de l'électricité en présentation continue.
]

#exemple[
    Les voitures, électrolyseurs et certains TGV consomment de l'électricité en présentation continue.
]

== Ordres de grandeurs

#application[
    Associer les ordres de grandeurs de puissances et les émissions#footnote[Les émissions de gaz à effets de serre sont exprimés en équivalents #ce("CO2") et calculés sur l'ensemble du cycle de vie.] de #ce("CO2") aux systèmes de production suivants.
    #let puissances = (
        qty("400", "W"),
        qty("2", "MW"),
        qty("100", "MW"),
        qty("100", "MW"),
        qty("100", "MW"),
        qty("1", "GW"),
    )
    #let moyens = (
        [barrage],
        [centrale au charbon],
        [centrale au gaz],
        [éolienne],
        [panneau solaire #qty("1", "m^2")],
        [réacteur nucléaire],
    )
    #let CO2 = (
        $< #num("10") frac(" g"ce("CO2")_"éq", "kWh", style: "horizontal")$,
        $< #num("10") frac(" g"ce("CO2")_"éq", "kWh", style: "horizontal")$,
        $< #num("10") frac(" g"ce("CO2")_"éq", "kWh", style: "horizontal")$,
        $#num("55") frac(" g"ce("CO2")_"éq", "kWh", style: "horizontal")$,
        $#num("400") frac(" g"ce("CO2")_"éq", "kWh", style: "horizontal")$,
        $#num("1000") frac(" g"ce("CO2")_"éq", "kWh", style: "horizontal")$,
    )
    #let points = (sym.circle.filled,) * CO2.len()
    #table(
        columns: (auto, 1fr, 1fr, auto, 1fr, 1fr, auto),
        stroke: none,
        row-gutter: 5pt,
        align: (right, left, right, center, left, right, left),
        ..for x in puissances.zip(points, points, moyens, points, points, CO2) {
            (
                ..for y in x {
                    (
                        [#y],
                    )
                },
            )
        }
    )
]

= Convertisseur électronique statique de puissance
== Structure générale
Un convertisseur électrique statique est constitué d'interrupteurs intégrés dans un circuit de puissance. Les interrupteurs peuvent être commandés par un circuit de commande.

Le circuit de commande fonctionne avec des petites tensions (de l'ordre de #qty("5", "V") et des petits courants (de l'ordre de #qty("10", "mA")).

#schéma(titre: "Structure générale d'un convertisseur", hauteur: 3cm)

Les convertisseurs portent des noms différents en fonction de la présentation en entrée et en sortie.

#schéma(titre: "Nommage des convertisseurs statiques", hauteur: 3cm)

== Exemple introductif : conversion continu/continu
Dans cet exemple, on souhaite faire varier la tension aux bornes d'un résistor à partir d'un générateur de tension idéal.

#exemple[
    On souhaite faire varier le rétroéclairage du tableau de bord d'une voiture qui est alimenté par la batterie.
]

=== Première idée : potentiomètre
On pourrait penser utiliser un montage un potentiomètre pour faire varier la tension. Un potentiomètre est l'association de deux résistors de résistances $k r_0$ et $(1-k) r_0$ avec $k$ réglable entre $0$ et $1$.

#schéma(titre: "Montage avec le potentiomètre", hauteur: 3cm)

#application[
    Exprimer $u$ en fonction de $E$, $k$, $R$ et $r_0$. Quelles sont les valeurs maximales et minimales atteintes par $u$ ? Pour quelle valeur de $k$ sont-elles atteintes ?
]

Ce système remplit son rôle mais il consomme de l'énergie.

=== Deuxième idée : utiliser un composant ne recevant pas de puissance
Afin d'avoir un bon rendement, on peut envisager d'utiliser un dipôle ne recevant pas de puissance ($u=0$ ou $i=0$).

Un dipôle ne recevant jamais de puissance est un interrupteur.

#schéma(titre: "Caractéristique d'un interrupteur", hauteur: 3cm)

#schéma(titre: "Montage avec un interrupteur", hauteur: 3cm)

Pour faire varier la tension aux bornes du résistor, on ouvre et on ferme périodiquement l'interrupteur.

La puissance arrivant au résistor peut être modulée grâce à la *modulation de la largeur d'impulsion* : l'interrupteur est fermé une plus ou moins grande partie du temps.

#encadré(
    titre: "Rapport cyclique",
    connaitre: true,
    hypothèses: (
        "L'ouverture et la fermeture de l'interrupteur est périodique",
    ),
    grandeurs: sub-dictionary(grandeurs, ("T", "Delta t_f", "alpha")),
)[
    $ alpha=(Delta t_f) / T $
]

#flashcard(
    recto: "Rapport cyclique",
    verso: "$ alpha=(Delta t_f) / T $",
)

Le rapport cyclique est la proportion du temps où l'interrupteur est fermé.

#application[
    Tracer le chronogramme de la tension aux bornes du résistor pour $alpha=num("0")$, $alpha=num("0.2")$, $alpha=num("0.5")$ et $alpha=num("1")$.
]

#application[
    Exprimer la valeur moyenne de la tension aux bornes du résistor en fonction de $E$ et $alpha$.
]

Ce système permet de faire varier la tension moyenne aux bornes du résistor sans perte de puissance.

== Cahier des charges et structure d'un convertisseur
Le cahier des charges d'un convertisseur est le suivant.
- Pas de consommation d'énergie, donc un rendement $eta=1$.
- Fonctionnement périodique.

Un convertisseur électrique statique est constitué d'interrupteurs, de bobines et de condensateurs.

es interrupteurs régulent le flux énergétique.

Les condensateurs et les bobines stockent l'énergie puis la restitue périodiquement. Les condensateurs et les bobines servent à lisser la tension ou le courant.

= Dipoles de types sources de tension ou de courant
== Dipoles de type source de tension
=== Source de tension idéale
Une source de tension idéale produit une tension indépendante du courant. Cette tension peut être continue ou alternative.

#schéma(titre: "Caractéristique d'une source de tension idéale", hauteur: 3cm)

== Générateur de Thévenin
Dans le modèle de Thévenin, le générateur de tension comporte une résistance interne.
#schéma(titre: "Modèle de Thévenin", hauteur: 3cm)
#application[
    Déterminer la caractéristique du générateur de Thévenin.
]

#application[
    Si le courant augmente en passant de $i$ à $i+ Delta i$, la tension passe de $u$ à $u+Delta u$. Déterminer $Delta u$ en fonction de $R$ et $Delta i$.
]

=== Générateur de type source de tension
Afin d'améliorer le générateur de Thévenin, on peut lui associer en parallèle un condensateur.

#schéma(titre: "Amélioration d'un générateur de Thévenin", hauteur: 3cm)

#application[
    En régime stationnaire, exprimer $u$ en fonction de $i$, $R$ et $E$. Si le courant passe de $i$ à $i+ Delta i$ en une petite durée $Delta t$, quelle est la variation de tension $Delta u$ ?
]

Si la capacité du condensateur est suffisamment grande#footnote[Précisément, si $R C >> Delta t$.], la tension aux bornes de la source est quasiment constante.

On appelle *dipôle de type source de tension* un dipôle qui présente à ses bornes une capacité de forte valeur. La tension aux bornes d'un dipôle de type source de tension varie peu autour de sa valeur moyenne.

#schéma(titre: "Exemples de dipôles de type source de tension", hauteur: 3cm)

#exemple[
    Les piles et les batteries sont des dipôles de type source de tension.
]

== Dipole de type source de courant
Par analogie avec la partie précédente, un *dipôle de type source de courant* est un dipôle qui présente, en série, une inductance de forte valeur. Le courant dans un dipôle de type source de courant varie peu autour de sa valeur moyenne.

#schéma(titre: "Exemples de dipôles de type source de courant", hauteur: 3cm)

#exemple[
    Les machines à courant continu, et les machines synchrones sont des dipôles de type source de courant.
]

== Réversibilité des sources
=== Réversibilité en tension
Une source est *réversible en tension* si, pour un courant donné, la tension à ses bornes peut être positive ou négative.
#exemple[
    Dans une machine à courant continu, le couple étant fixé, la machine peut tourner dans un sens ou dans l'autre suivant si elle est en fonctionnement moteur ou générateur. Une machine à courant continu est donc réversible en tension.

    Une source de courant idéale est réversible en tension.
]


== Réversibilité en courant
Une source est *réversible en courant* si, pour une tension donnée, le courant la traversant peut être positive ou négative.
#exemple[
    Dans une machine à courant continu, la vitesse angulaire étant fixée, la machine peut subir un couple moteur ou résistant suivant si elle est en fonctionnement moteur ou générateur. Une machine à courant continu est donc réversible en courant.
    
    Une source de tension idéale est réversible en courant.
]

== Réversibilité en puissance
Une source est *réversible en puissance* si la puissance qu'elle reçoit peut être positive ou négative.
#exemple[
    Une machine à courant continu peut fonctionner en moteur (récepteur de puissance électrique) ou en générateur (générateur de puissance électrique).
    
    Une source de tension idéale et une source de courant idéale sont réversibles en puissance.
]

== Règles d'interconnexion des sources
Il n'est pas possible d'associer deux sources de tension en parallèle car chacune va "essayer" d'imposer sa tension ce qui peut conduire à la destruction d'une ou des deux sources.

Il n'est pas possible d'associer deux sources de courant en série car chacune va "essayer" d'imposer son courant ce qui peut conduire à la destruction d'une ou des deux sources.

Il est possible de connecter directement une source de tension et une source de courant.

#schéma(titre: "Interconnection des sources", hauteur: 3cm)

#flashcard(
    recto: "Règles d'interconnection des sources",
    verso: "Deux sources de tension ne peuvent pas être en parallèle. Deux sources de courant ne peuvent pas être en série.",
)

== Structure d'un convertisseur direct
Un *convertisseur direct*  est un convertisseur ne comportant que des interrupteurs.

Un convertisseur direct s'utilise nécessairement entre un dipôle de type source de tension et un dipôle de type source de courant.

#application[
    En distinguant les cas, montrer qu'il n'est pas possible de concevoir un convertisseur direct ne comportant qu'un seul interrupteur.
]

Un convertisseur direct utilise au minimum deux interrupteurs. Le convertisseur direct à deux interrupteurs s'appelle cellule élémentaire de commutation.

#schéma(titre: "Cellule élémentaire de commutation", hauteur: 3cm)

#application[
    Montrer que lorsqu'un interrupteur est fermé, l'autre est nécessairement ouvert.
]

Dans la cellule élémentaire de commutation, les interrupteurs ont un fonctionnement *complémentaire* : lorsqu'un est ouvert, l'autre est fermé.

#question-de-colle(
    "Montrer qu'un convertisseur direct est constitué d'aux moins 2 interrupteurs. Présenter la cellule élémentaire de commutation et montrer que les interrupteurs ont nécessairement un fonctionnement complémentaire.",
)

= Interrupteurs électroniques
Les interrupteurs constituant les convertisseurs ne sont pas des interrupteurs manuels mais des interrupteurs électroniques.

== Interrupteur idéal
Un interrupteur idéal ne reçoit pas de puissance.

#schéma(titre: "Caractéristique interrupteur idéal", hauteur: 3cm)

Lorsqu'un interrupteur est fermé, on dit qu'il est *passant*, le courant peut passer et la tension à ses bornes est nulle.

Lorsqu'un interrupteur est ouvert, on dit qu'il est *bloqué*, le courant est nul.

Une interrupteur à *commutation spontanée* devient spontanément passant ou bloqué en fonction du courant ou de la tension dans le circuit de puissance.

Un interrupteur à *commutation commandée* peut devenir passant ou bloqué sur commande d'un circuit de commande#footnote[La commande peut se faire en tension, par exemple pour un MOSFET ou en courant, par exemple pour un transistor bipolaire.].

== La diode

#figure(
    grid(
        columns: (1fr, 1fr, 1fr),
        row-gutter: 0.5cm,
        figure(image("images/diode 1.jpg", height: 4cm)),
        figure(image("images/diode 2.jpg", height: 4cm)),
        figure(image("images/diode 3.jpg", height: 4cm)),
    ),
    caption: "Photographies de 3 diodes.",
)

La *diode* est un interrupteur *unidirectionnel* (elle ne laisse passer le courant que dans un sens) à commutation spontanée.

#schéma(titre: "Symbole et caractéristique", hauteur: 4cm)

#flashcard(
    recto: "Caractéristique de la diode",
    verso: "$(i=0, u <= 0)$ ou $(i>= 0, u=0)$ en convention directe",
)

== Le transistor
#figure(
    image("images/transistors.jpg", height: 5cm),
    caption: "Photographies de transistors.",
)

Le *transistor* est un interrupteur *unidirectionnel* à commutation commandée à l'amorçage et au blocage#footnote[On peut lui commander de passer de l'état passant à l'état bloqué et de l'état bloqué à l'état passant.].

#schéma(titre: "Symbole et caractéristique du transistor", hauteur: 4cm)
#flashcard(
    recto: "Caractéristique du transistor",
    verso: "$(i=0,u>=0)$ ou $(i>= 0, u=0)$",
)

= Hacheur série
== Présentation
Le hacheur série (ou hacheur dévolteur) est un convertisseur direct dont la source est une source de tension et la charge une source de courant. Le hacheur série est constitué d'une cellule élémentaire de commutation.

#schéma(titre: "Hacheur dévolteur", hauteur: 4cm)

Les deux interrupteurs ont un fonctionnement complémentaire et sont commandés de façon périodique par un circuit de commande qui ne sera pas étudié.

#figure(
    table(
        columns: (auto, auto, auto),
        align: (left, center, center),
        [], $K_1$, $K_2$,
        $0 <= t <alpha T$, [Fermé], [Ouvert],
        $alpha T <= t < T$, [Ouvert], [Fermé],
    ),
)

== Étude avec des sources idéales
On s'intéresse ici au cas où la source de tension et la source de courant sont des sources continues idéales.
=== Chronogrammes
#application[
    Déterminer $u_1$, $u_s$, $i_e$, et $i_2$ en fonction de $E$ et $I$ entre $0$ et $alpha T$ puis entre $alpha T$ et $T$.
    Tracer les chronogrammes de $u_s$ et $i_e$.
]

=== Nature des interrupteurs

#application[
    Placer $u_1$ et $i_e$ sur une caractéristique et en déduire la nature de $K_1$. Faire de même pour $K_2$.
]

$K_1$ est un transistor. $K_2$ est une diode en convention inverse.

#schéma(titre: "Hacheur", hauteur: 4cm)

#question-de-colle(
    "Donner la caractéristique d'une diode et d'un transistor en précisant la convention choisie. Pour un hacheur série, déterminer la nature des interrupteurs.",
)

=== Valeurs moyennes

#encadré(
    titre: "Valeur moyenne",
    connaitre: true,
    hypothèses: (
        "Le régime est périodique",
    ),
    grandeurs: sub-dictionary(grandeurs, ("cal(A)", "T", "s(t)")),
)[
    $ mean(s(t)) = cal("A") / T $
]

#application[
    Déterminer la valeur moyenne de $i_e$ et de $u_s$.
]

Le hacheur série s'appelle hacheur dévolteur car la valeur moyenne de la tension de sortie est inférieure à $E$.

=== Bilan de puissance
#application[
    Déterminer la valeur moyenne de la puissance en entrée. Faire de même pour la puissance en sortie.
]

Le hacheur série ne consomme pas de puissance en moyenne. Le rendement du hacheur série est $eta=1$.

#question-de-colle(
    "Pour un hacheur série entre deux sources idéales, déterminer les valeurs moyennes du courant d'entrée et de la tension de sortie. Montrer que le hacheur a un rendement de 1.",
)

== Application à la commande d'une machine à courant continu
On s'intéresse ici au cas où la source de tension est continue et idéale et la source de courant est un moteur à courant continu dont on néglige la résistance interne.

#schéma(titre: "Moteur à courant continu alimenté par un hacheur", hauteur: 4cm)

On se place dans le cas d'une conduction continue ($i_s(t)>0$). On suppose la vitesse angulaire $Omega$ constante, la force contre-électromotrice $E_"cém"$ est donc constante elle-aussi.

=== Chronogrammes

#application[
    Déterminer les équations différentielles vérifiées par $i_s$ entre $0$ et $alpha T$ puis entre $alpha T$ et $T$. Tracer le chronogramme de $u_s$, $u_L$, $i_s$ et $i_e$.
]

=== Valeurs moyennes

#encadré(
    titre: "Valeur moyenne d'une dérivée",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "En régime périodique.",
    ),
)[
    $ mean(dv(s, t)) = 0 $
]

#application[
    Déterminer la valeur moyenne de $i_s$, $i_e$, $u_s$ et $u_L$ en fonction de $alpha$, $E$, $i_"max"$ et $i_"min"$. En déduire la force contre-électromotrice puis la vitesse angulaire du moteur $Omega$ en fonction de $Phi_0$, $alpha$ et $E$.
]

=== Ondulation du courant de sortie
#encadré(
    titre: "Ondulation",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("s(t)", "s_\"max\"", "s_\"min\"")),
)[
    $ Delta s=s_"max" - s_"min" $
]

L'ondulation du courant peut poser des problèmes, notamment des vibrations causant du bruit et une usure prématurée.

Dans le lien suivant, on peut entendre le bruit causé par l'ondulation du courant dans un moteur à courant continu alimenté par un hacheur série lors du départ du métro.
#lien("https://www.youtube.com/shorts/LRoi3NtIZE4")

#application[
    Exprimer l'ondulation du courant de sortie en fonction de $alpha$, $E$, $T$ et $L$.
]

#question-de-colle(
    "Pour un hacheur série alimentant un moteur à courant continu dont on néglige la résistance interne, exprimer la vitesse angulaire en fonction du rapport cyclique et déterminer l'ondulation du courant de sortie.",
)

Afin de réduire l'ondulation du courant, on travaille avec des fréquences élevées. On peut aussi ajouter une bobine en série avec le moteur afin de lisser le courant.

=== Rendement
#application[
    Déterminer le rendement du hacheur.
]

= Onduleur
== Cahier des charges et architecture
L'onduleur est un convertisseur prenant en entrée une source de tension continue et alimentant, en sortie, une source de courant alternatif.

#exemple[
    Un onduleur est utilisé dans une voiture électrique pour convertir la tension continue fournie par la batterie en tension alternative utilisable par le moteur synchrone.
]

L'onduleur est constitué d'un point à 4 interrupteurs.

#schéma(titre: "Schéma de l'onduleur", hauteur: 4cm)

== Séquence de commutation
#application[
    Lister les 16 états pour les interrupteurs et dire s'ils sont possibles et s'ils permettent de transférer de l'énergie entre la source et la charge.
]
Les deux états retenus sont ceux qui permettent de connecter la source à la charge dans un sens ou dans l'autre.
    
#schéma(titre: "États utilisés pour un onduleur", hauteur: 4cm)

Pour avoir une présentation alternative en sortie, on choisi un rapport cyclique $alpha=1/2$.

#question-de-colle("Schématiser la structure d'un onduleur. Lister les états pour les interrupteurs et dire s'ils sont possibles et ceux qui sont retenus.")

== Utilisation avec une charge R-L
L'onduleur peut être utilisé pour alimenter un dipôle inductif modélisé par une charge R-L.

#schéma(titre: "Onduleur alimentant une charge R-L", hauteur: 3cm)
#application[
    Pour chaque demi-période, déterminer une équation différentielle vérifiée par le courant de sortie de l'onduleur.
]

#lien("https://capytale2.ac-paris.fr/web/c/c90e-2976695")
Pour obtenir un courant de sortie environ sinusoïdal, il est possible d'utiliser la MLI.
