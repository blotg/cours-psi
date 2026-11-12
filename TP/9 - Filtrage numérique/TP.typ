#import "@local/prepa:0.1.1": *

#show: TP.with(
    titre: "Filtrage numérique",
    taille: 10.5pt,
    compact: true,
)

#matériel(
    groupe: (
        [Oscilloscope et GBF],
        [Microcontrôleur ESP32 et cable USB],
        [Platine de prototypage et fils de connection],
    ),
)

#préparatoire()[
    Lire l'énoncé du TP et ses annexes et effectuer l'@application-mesure-tension, l'@application-sortie-analogique, l'@application-grandeurs-sinusoidales, l'@application-filtre-ordre-0, l'@application-methode-euler et l'@application-filtre-ordre-1.
]

#compte-rendu()

#évaluation(
    barème: (
        ([les manipulations faites sont précisément décrites], 2),
        ([les résultats bruts sont consignés (cahier, fichiers sur le réseau)], 2),
        ([les calculs sont explicités (formules, valeurs, script Python)], 2),
        ([une conclusion est formulée], 2),
        ([le compte rendu donne envie d'être lu], 2),
    ),
)[
    Le cahier de TP sera rendu à la fin de la séance et le compte-rendu évalué.
]


= Introduction

L'objectif de ce TP est de réaliser un filtre numérique dont on peut choisir les paramètres (ordre, fréquence de coupure, etc.) et de vérifier son fonctionnement expérimentalement.

Un filtre numérique un un dispositif qui acquiers un signal, le traite numériquement et le restitue en temps réel. Contrairement à un filtre analogique (composé de résistors, condensateurs et bobines), ses caractéristiques peuvent être facilement modifiées par simple changement de paramètres dans le logiciel et ceux-ci ne sont pas contraints par les valeurs des composants accessibles. Enfin, il est possible avec un filtre numérique de réaliser des filtres d'ordre élevé sans avoir multiplier le nombre de composants.

Le filtre numérique sera réalisé avec le microcontrôleur ESP32, programmé en MicroPython. On y accèdera en utilisant le logiciel Thonny.

_*La carte ESP 32 accepte des tensions d'entrée entre 0 et 3.3V. Des tensions négatives ou supérieures à 3.3V vont endommager la carte.*_

Lorsqu'on programme des microcontrôleurs, contrairement à un ordinateur, il n'est pas rare de créer des boucles infinies pour maintenir le programme en fonctionnement continu.

= Utilisation d'une entrée analogique
Pour se familiariser avec l'utilisation des entrées analogiques, nous allons mesurer une tension continue appliquée à une broche de la carte ESP32 en utilisant sont convertisseur analogique-numérique (ADC).

#application(titre: "Mesure d'une tension continue")[
    Écrire des instructions permettant de lire la tension présente sur la broche 33 et de l'afficher en volts dans la console.
]<application-mesure-tension>

#manipulation(titre: "Réglage du GBF")[
    Régler le GBF pour qu'il génère une tension continue de 1.5V.

    _*Appeler l'enseignant pour vérifier.*_
]

#manipulation(titre: "Création d'un voltmètre")[
    Réaliser un voltmètre, c'est-à-dire un dispositif qui acquiert continument la tension toutes les #quan[0.5 s] et l'affiche en volts dans la console.
]

#évaluation(appel-prof: true, barème: (
    ([acquisition dans une boucle infinie], 2),
    ([conversion des µV en volts], 2),
    ([attente de #quan[0.5 s] entre deux mesures], 2),
    ([affichage avec unité], 2),
    ([valeur cohérente avec le GBF, écart commenté], 2),
))[
    Le binôme exécute son programme et commente l'écart éventuel entre la tension affichée et celle du GBF.
]

= Utilisation d'une sortie analogique
Pour se familiariser avec l'utilisation des sorties analogiques, nous allons générer une tension continue sur une broche de la carte ESP32 en utilisant son convertisseur numérique-analogique (DAC).

Les sorties analogiques de l'ESP32 sont codées sur 8 bits. Une valeur de 0 correspond à #quan[0 V] et une valeur de 255 correspond à #quan[3.3 V], l'association étant linéaire.

#application(titre: "Génération d'une tension continue")[
    Quelle nombre sur 8 bits correspond à une tension de 1V ?

    Écrire des instructions permettant de générer une tension continue de 1V sur la broche 25.
]<application-sortie-analogique>

#manipulation(titre: "Création d'un générateur de tension continue")[
    Réaliser un dispositif qui génère continument une tension de 1V sur la broche 25. On vérifiera la tension générée à l'aide de l'oscilloscope.
]

#évaluation(appel-prof: true, barème: (
    ([valeur sur 8 bits correcte], 2),
    ([valeur entière passée à `dac.write`], 2),
    ([broche 25 utilisée], 2),
    ([mesure à l'oscilloscope], 2),
    ([écart à #quan[1 V] expliqué (quantification)], 2),
))[
    Le binôme montre la tension générée à l'oscilloscope et justifie la valeur choisie.
]

= Filtre d'ordre 0
Pour commencer, on réalise un filtre d'ordre 0 : $underline(H)=underline(s)/underline(e) = K$. On choisira $K=0.5$ dans cette partie.

Le microcontrôleur devra continuellement acquérir la tension d'entrée, lui appliquer le filtre et l'envoyer sur sa sortie.

#application(titre: "Grandeurs sinusoïdales")[
    Quelles doivent être l'amplitude crête à crête et la valeur moyenne d'un signal sinusoïdal de minimum #quan[0.5 V] et de maximum #quan[2.5 V] ?
]<application-grandeurs-sinusoidales>

#manipulation(titre: "Réglage du GBF")[
    _*Débrancher le bornier du GBF.*_

    Régler le GBF pour qu'il génère une tension sinusoïdale de minimum #quan[0.5 V], de maximum #quan[2.5 V] et de fréquence #quan[30 Hz].
]

#application(titre: "Filtre d'ordre 0")[
    Écrire des instructions permettant de réaliser un filtre d'ordre 0 avec $K=0.5$.
]<application-filtre-ordre-0>

#manipulation(titre: "Filtre d'ordre 0")[
    Réaliser un filtre d'ordre 0 avec $K=0.5$ sur le microcontrôleur et vérifier son fonctionnement en observant sa sortie sur l'oscilloscope.
]

#évaluation(
    appel-prof: true,
    barème: (
        ([les signaux ne défilent pas], 2),
        ([entrée et sortie visibles simultanément], 2),
        ([rapport des amplitudes égal à 0,5], 2),
        ([valeur moyenne également divisée par 2], 2),
        ([retard éventuel de la sortie commenté], 2),
    ),
)[
    L'enseignant dérègle l'oscilloscope et le binôme le re-règle sans utiliser le bouton auto-scale.

    Le binôme montre ensuite comment il vérifie que $K = 0.5$.
]

= Filtre passe bas d'ordre 1

On souhaite maintenant réaliser un filtre passe bas d'ordre 1 de fonction de transfert
$ underline(H) = underline(s)/underline(e) = 1/(1+j omega/(2 pi f_c)) $
avec une fréquence de coupure $f_c = #quan[30 Hz]$.

Pour cela, on utilise la méthode d'Euler pour calculer de proche en proche les valeurs de $s$.

#application(titre: "Méthode d'Euler")[
    Établir une équation différentielle reliant $s(t)$ et $e(t)$.

    En notant $s_i = s(i times Delta t)$ et $e_i = e(i times Delta t)$ établir le schéma d'Euler explicite : une relation de récurrence pour calculer $s_(i+1)$ à partir de $s_i$ et $e_i$.
]<application-methode-euler>

Lorsqu'on utilise un filtre, seul le régime établi est étudié. La valeur initiale $s_0$ n'a donc pas d'importance et peut être choisir arbitrairement.

#application(titre: "Filtre passe bas d'ordre 1")[
    Écrire une boucle permettant de réaliser un filtre passe bas d'ordre 1 avec le schéma d'Euler explicite. A chaque tour de boucle, $e_i$ est acquis, $s_(i+1)$ est calculé à partir de $s_i$ et $e_i$ puis envoyé sur la sortie.

    Il n'est pas nécessaire de stocker les valeurs successives de $s_i$ et $e_i$. Seules les valeurs courantes sont utiles au calcul.
]<application-filtre-ordre-1>

#manipulation(titre: "Filtre passe bas d'ordre 1")[
    Réaliser le filtre passe bas d'ordre 1 sur le microcontrôleur et vérifier son fonctionnement en observant sa sortie sur l'oscilloscope. On vérifiera notamment que l'amplitude décroit avec la fréquence au delà de la fréquence de coupure.
]

#show: appendix

= Utilisation de Thonny avec l'ESP32

Thonny est un environnement de développement intégré (IDE) pour le langage Python. On peut l'utiliser pour écrire et exécuter du code Python sur l'ordinateur sur lequel il est installé (comme Spyder par exemple) mais aussi sur un microcontrôleur sur lequel MicroPython est installé.

Pour utiliser Thonny avec l'ESP32, il faut d'abord connecter le microcontrôleur à l'ordinateur via un câble USB. Ensuite, dans Thonny, ouvrir Tools #sym.arrow Options #sym.arrow Interpreter et sélectionner "MicroPython (ESP32)" comme interpréteur. Il faut également choisir le port série correspondant à l'ESP32. Après validation, la console affiche la version de MicroPython installée sur le microcontrôleur.

= Fonctions MicroPython utiles dans ce TP<annexe-fonctions-python>

#cheatsheet-python(
    colonnes: 1,
    (
        "ADC",
        "DAC",
        "time.sleep_us",
    ),
)
