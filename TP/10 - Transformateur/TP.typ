#import "@local/prepa:0.1.1": *

#show: TP.with(
    titre: "Transformateur",
    taille: 10.5pt,
    compact: true,
)

#matériel(
    groupe: (
        [Oscilloscope et GBF],
        [Maquette "Étude du transformateur torique"],
        [Fils de connexion adaptés à la maquette],
        [Wattmètre + alimentation],
        [Rhéostat],
        [2 multimètres numériques],
    ),
)

#préparatoire()[
    Ce TP s'étale sur 2 séances. Les binômes sont les mêmes pour les 2 séances.

    Pour la première séance : lire les parties 1 et 2 du TP et ses annexes et effectuer l'@application-sonde-différentielle, l'@application-rapport-tensions,et l'@application-pertes-fer.

    Pour la séance suivante : lire les parties 3 et 4 du TP et effectuer l'@application-rapport-courants, l'@application-court-circuit, l'@application-pertes-cuivre et l'@application-mesure-puissances.
]

#compte-rendu()


= Introduction<intro>

L'objectif de ce TP est de vérifier les lois de transformation de tension et de courant dans un transformateur et de réaliser une étude énergétique de ce transformateur. Le transformateur utilisé est un transformateur torique à cœur de *fer* comportant $N_1=#quan[60]$ spires au primaire et $N_2=#quan[40]$ spires au secondaire. Dans tout le TP, on travaillera avec des tensions sinusoïdales (donc sans valeur moyenne) de fréquence $f=#quan[50 Hz]$.

= Étude à vide<a-vide>
Dans cette partie, aucun courant ne parcourt le circuit secondaire.

== Rapport de transformation de tension
On cherche ici à vérifier la loi de transformation de tension. Pour cela, on mesure la tension au primaire et au secondaire du transformateur avec l'oscilloscope.

L'amplificateur de puissance sera utilisé en mode "source de tension" (points $C_p$ et $R_p$ #underline[dé]connectés)

#application(titre: "Sonde différentielle")[
    Expliquer pourquoi il est nécessaire d'utiliser une sonde différentielle pour mesurer la tension au primaire du transformateur.

    Sur le schéma ci-dessous, indiquer les connexions à réaliser. On indiquera notamment les deux bornes de la sonde différentielle, la masse de l'oscilloscope et sa voie 2.

    #figure({
        set text(size: 9pt)
        circuit(length: .85cm, {
            import zap: *
            import cetz.draw: *
            // zap lit ses styles dans ctx.style.zap : set-style n'y touche pas.
            let resistor = resistor.with(scale: .55)
            let capacitor = capacitor.with(scale: .6)
            let opamp = opamp.with(scale: .78)
            let frame = frame.with(scale: .8)
            // Coordonnées relevées en pixels sur le schéma d'origine (y vers le bas).
            let p(x, y) = (x / 100, -y / 100)
            let borne(pos, nom: none, ancre: "north", homologue: none) = {
                on-layer(2, circle(pos, radius: .1, fill: white, stroke: .6pt))
                if nom != none { content(pos, nom, anchor: ancre, padding: .18) }
                if homologue != none { on-layer(2, circle(homologue, radius: .05, fill: black)) }
            }
            let bnc(pos, nom) = {
                let (x, y) = pos
                line((x - .3, y), (x + .3, y), stroke: .6pt)
                on-layer(2, circle(pos, radius: .2, fill: white, stroke: 1pt))
                on-layer(2, circle(pos, radius: .09, stroke: 1pt))
                wire((x, y - .2), (x, y - .55))
                frame("T" + str(int(x * 100)), (x, y - .55))
                content((x, y + .35), text(weight: "bold", nom), anchor: "south")
            }
            let titre(pos, corps) = content(pos, text(weight: "bold", corps))

            // Amplificateur de puissance
            titre(p(320, 40), [Amplificateur de puissance])
            bnc(p(45, 125), [GBF])
            wire(p(75, 125), p(150, 125))
            opamp("PA", p(400, 157), invert: true)
            content(p(435, 125), sym.triangle.r)
            resistor("R1", p(150, 125), p(150, 290))
            resistor("R2", p(150, 290), p(150, 415))
            resistor("R3", p(45, 290), p(45, 445))
            resistor("R4", p(215, 290), p(215, 415))
            wire(p(45, 290), p(185, 290), (p(185, 290), "|-", "PA.plus"), "PA.plus")
            wire(p(150, 415), p(215, 415))
            frame("G1", p(183, 415))
            wire(p(215, 290), p(293, 290))
            wire("PA.minus", ("PA.minus", "-|", p(293, 290)), p(293, 290))
            wire(p(470, 157), p(578, 157))
            resistor("Rf", p(515, 290), p(293, 290))
            wire(p(515, 157), p(515, 290))
            borne(p(150, 125), nom: $E_p$, ancre: "north-east")
            borne(p(45, 445), nom: $E_r$)
            borne(p(293, 290), nom: $C_c$, ancre: "north-west")
            borne(p(578, 157), nom: $S_p$, ancre: "south")

            // Amplificateur de mesure du courant
            titre(p(305, 720), [Amplificateur])
            titre(p(305, 760), [de mesure du courant])
            opamp("CA", p(365, 502), invert: true, scale: (x: -.78, y: .78))
            content(p(330, 470), sym.triangle.l)
            wire(p(293, 393), p(578, 393))
            wire(p(458, 393), (p(458, 393), "|-", "CA.plus"), "CA.plus")
            wire("CA.minus", ("CA.minus", "-|", p(458, 632)), p(458, 632))
            wire(p(295, 502), p(140, 502), p(140, 632))
            resistor("R5", p(140, 632), p(293, 632))
            resistor("R6", p(293, 632), p(458, 632))
            resistor("R7", p(458, 632), p(578, 632))
            wire(p(578, 272), p(578, 393))
            resistor("Rm", p(578, 393), p(578, 632))
            wire(p(578, 632), p(578, 660))
            frame("G2", p(578, 660))
            borne(p(293, 393), nom: $R_p$, ancre: "east")
            borne(p(578, 272), nom: $R_p$, ancre: "south")
            borne(p(140, 632), nom: $C_1$)
            borne(p(293, 632), nom: $C_2$)

            // Transformateur torique
            let centre = p(1195, 410)
            let r = 2.7
            circle(centre, radius: r, stroke: .6pt)
            circle(centre, radius: r / 2, stroke: .6pt)
            let bord(angle) = (centre.at(0) + r * calc.cos(angle), centre.at(1) + r * calc.sin(angle))
            // fils obliques à 45° jusqu'à l'horizontale de la borne
            let sortie(angle, borne, sens) = {
                let (xb, yb) = bord(angle)
                let yh = borne.at(1)
                wire(borne, (xb + sens * calc.abs(yh - yb), yh), (xb, yb))
            }
            sortie(126deg, p(872, 152), -1)
            sortie(234deg, p(872, 665), -1)
            sortie(54deg, p(1512, 152), 1)
            sortie(-54deg, p(1512, 665), 1)
            let xd = centre.at(0) + calc.sqrt(r * r - .75 * .75)
            wire((xd, -3.35), p(1512, 335))
            wire((xd, -4.85), p(1512, 485))
            borne(p(872, 152), nom: [G], homologue: p(892, 128))
            borne(p(872, 665), nom: [H])
            borne(p(1512, 152), nom: [I], homologue: p(1490, 128))
            borne(p(1512, 335), nom: [J])
            borne(p(1512, 485), nom: [K], homologue: p(1488, 463))
            borne(p(1512, 665), nom: [L])
            content(p(900, 600), align(center)[60 \ spires])
            content(p(1490, 280), align(center)[40 \ spires])
            content(p(1490, 600), align(center)[20 \ spires])
        })
    })
]<application-sonde-différentielle>

#manipulation(titre: "Formes des tensions")[
    En utilisant une tension de valeur efficace #quan[5 V], observer sur l'oscilloscope les formes d'onde des tensions au primaire et au secondaire du transformateur.

    Leurs formes respectives sont-elles conformes à ce qu'on attend ? Est-ce le cas de leurs amplitudes ?
]<manipulation-formes-tensions>

#évaluation(
    appel-prof: true,
    barème: (
        ([Utilité sonde différentielle], 2),
        ([Connexions sur le schéma (amplificateur)], 2),
        ([Connexions sur le schéma (mesures)], 2),
        ([Commentaire sur la forme des courbes], 2),
        ([Commentaire sur les amplitudes], 2),
    ),
)[
    Le binôme présente l'oscillogramme et répond aux questions de l'@application-sonde-différentielle et de la @manipulation-formes-tensions.
]

Afin de vérifier la loi de transformation de tension avec plus de précision, on va tracer la valeur efficace de la tension au secondaire en fonction de la valeur efficace de la tension au primaire.

#manipulation(titre: "Rapport de transformation des tensions")[
    Avec deux voltmètres, mesurer les valeurs efficaces des tensions au primaire et au secondaire. On prendra 7 points de mesure en faisant varier la tension efficace au primaire de #quan[1 V] à #quan[7 V].
]

#application(titre: "Rapport de transformation des tensions")[
    Quelle courbe tracer pour obtenir une droite de pente $m$ ?

    Tracer cette courbe grâce à Python. Les incertitudes seront calculées et représentées. Réaliser une régression linéaire et déterminer la valeur de la pente $m$ ainsi que son incertitude. On pourra utiliser la méthode de Monte Carlo.

    Conclure sur la cohérence de $m$ avec la valeur attendue.
]<application-rapport-tensions>

#évaluation(
    appel-prof: true,
    barème: (
        ([Courbe tracée], 2),
        ([Titre, axes corrects et nommés], 2),
        ([Incertitudes calculées], 2),
        ([Régression], 2),
        ([Monte Carlo], 2),
    ),
)[
    Le binôme présente se code Python.
]

== Pertes fer
À vide, les pertes dans le transformateur sont essentiellement dues aux pertes fer. Elles seront mesurées à l'aide d'un wattmètre.

#application()[
    Justifier que, à vide, la puissance absorbée par le transformateur est essentiellement constituée des pertes fer.
]<application-pertes-fer>

#manipulation(titre: "Pertes fer")[
    À l'aide du wattmètre, mesurer la puissance absorbée par le transformateur à vide pour des tensions efficaces au primaire entre #quan[1 V] et #quan[7 V].

    Tracer la puissance absorbée en fonction de la tension efficace au primaire.
]

= Étude en court-circuit<c-circuit>
Dans cette partie, le secondaire du transformateur est court-circuité. Pour éviter de faire circuler un courant trop important dans le transformateur, *on limitera la tension efficace au primaire à #quan[1 V]*.

L'amplificateur de puissance sera utilisé en mode "source de tension" (points $C_p$ et $R_p$ #underline[dé]connectés)

== Loi de transformation de courant
On cherche ici à vérifier la loi de transformation de courant. Pour cela, on mesure le courant au primaire et au secondaire du transformateur avec deux ampèremètres.

#manipulation(titre: "Rapport de transformation des courants")[
    Avec deux ampèremètres, mesurer les valeurs efficaces des courants au primaire et au secondaire. On prendra 7 points de mesure en faisant varier la tension efficace au primaire de #quan[0.1 V] à #quan[1 V].
]

#application(titre: "Rapport de transformation des courants")[
    Quelle courbe tracer pour obtenir une droite de pente $m$ ?

    Tracer cette courbe grâce à Python. Les incertitudes seront calculées et représentées. Réaliser une régression linéaire et déterminer la valeur de la pente $m$ ainsi que son incertitude. On pourra utiliser la méthode de Monte Carlo.

    Conclure sur la cohérence de $m$ avec la valeur attendue.
]<application-rapport-courants>

#évaluation(
    appel-prof: true,
    barème: (
        ([Courbe tracée], 2),
        ([Titre, axes corrects et nommés], 2),
        ([Incertitudes calculées], 2),
        ([Régression], 2),
        ([Monte Carlo], 2),
    ),
)[
    Le binôme présente se code Python.
]

== Pertes cuivre
En court-circuit, les pertes dans le transformateur sont essentiellement dues aux pertes cuivre. Elles seront mesurées à l'aide d'un wattmètre.

#application()[
    Justifier que, en court-circuit, la puissance absorbée par le transformateur est essentiellement constituée des pertes cuivre.
]<application-court-circuit>

#manipulation(titre: "Pertes cuivre")[
    À l'aide du wattmètre, mesurer la puissance absorbée par le transformateur en court-circuit pour des tensions efficaces au primaire entre #quan[0.1 V] et #quan[1 V]. Dans cette manipulation, le secondaire du transformateur est court-circuité avec un fil, sans passer par un ampèremètre. On prendra soin de placer l'ampèremètre du primaire en amont du wattmètre afin que le wattmètre ne mesure pas la puissance (certes faible) dissipée dans l'ampèremètre.

    Tracer la puissance absorbée en fonction du courant efficace au primaire.
]

#application(titre: "Pertes cuivre")[
    Comment les pertes théoriques dépendent-elles du courant efficace au primaire ? Déterminer la résistance équivalente, vue du primaire, des fils du transformateur.
]<application-pertes-cuivre>

#évaluation(
    appel-prof: true,
    barème: (
        ([Wattmètre bien connecté], 2),
        ([Courbe, titre, axes], 2),
        ([Justification de la forme de la courbe], 2),
        ([Résistance équivalente trouvée (méthode indifférente)], 2),
        ([Incertitude sur la résistance équivalente calculée de façon pertinente], 2),
    ),
)[
    Le binôme présente son montage et son code Python.
]

= Bilan énergétique<bilan>
Dans cette partie, le secondaire du transformateur alimente une charge résistive : un rhéostat. On cherche à mesurer le rendement du transformateur et à vérifier que les pertes en charge s'expliquent par les pertes fer et les pertes cuivre déterminées précédemment.

L'amplificateur de puissance sera utilisé en mode "source de tension" (points $C_p$ et $R_p$ #underline[dé]connectés). La tension efficace au primaire sera maintenue à #quan[5 V].

#application(titre: "Mesure des puissances")[
    Justifier que, si le transformateur est relié à une charge résistive, son rendement s'écrit $eta = (U_2 I_2) / P_1$, où $P_1$ est la puissance moyenne reçue par le primaire, $U_2$ la tension efficace au secondaire et $I_2$ le courant efficace au secondaire.
]<application-mesure-puissances>

#manipulation(titre: "Rendement")[
    À l'aide d'un ohmmètre, régler la résistance du rhéostat entre #quan[2 Ω] et #quan[3 Ω] et noter sa valeur.

    Mesurer simultanément la puissance absorbée par le primaire, la tension efficace au secondaire et le courant efficace au secondaire.
]

#application(titre: "Rendement")[
    Calculer les pertes du transformateur. Cette valeur est-elle cohérente avec les pertes fer et cuivre mesurées précédemment (méthode des pertes séparées) ?
    
    Calculer le rendement du transformateur.
]<application-rendement>


#show: appendix

= Utilisation d'une sonde différentielle
#grid(
    columns: (2fr,0.3fr),
    column-gutter: 1em,
)[
    Une sonde différentielle permet de mesurer la tension entre deux points d'un circuit sans que l'un de ces points soit relié à la masse de l'oscilloscope. Elle s'utilise en lieu et place des adaptateurs BNC/banane habituellement connectés aux entrées de l'oscilloscope.

    Les sondes différentielles utilisées divisent la tension mesurée d'un facteur #num[20] ou #num[200] (au choix de l'utilisateur). Il est donc nécessaire de multiplier la valeur affichée par ce facteur pour obtenir la tension réelle. Cette opération peut être réalisée directement par l'oscilloscope en sélectionnant le facteur approprié dans le menu "sonde" de la voie correspondante.
][
    #image("Images/sonde différentielle.jpg", width: 100%)
]

= Utilisation d'un wattmètre

#grid(
    columns: (2fr,1fr),
    column-gutter: 1em,
)[
    Un wattmètre permet de mesurer la puissance absorbée par un dipôle ("charge") en mesurant simultanément la tension à ses bornes et le courant qui le traverse. Les bornes "sources" sont connectées à ce qui apporte la puissance au dipôle.

    Schématiquement, les 2 fils connectant le dipôle au circuit passent par le wattmètre.

    La notice indique "Précision : meilleure que 2 % à pleine échelle courant et tension.".
][
    #image("Images/wattmètre.png", width: 100%)
]
