#import "@local/prepa:0.1.1": *

#show: TP.with(
    titre: "Ferromagnétisme",
)

#préparatoire()[
    Lire l'énoncé du TP et ses annexes et effectuer l'@application-géométrie, l'@application-excitation, l'@application-champ-magnétique et l'@application-utilisation-maquette.
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

#matériel(
    groupe: (
        [Oscilloscope et GBF],
        [Maquette "Étude du transformateur torique"],
        [Tournevis],
        [Fils de connexion adaptés à la maquette],
        [Centrale d'acquisition SYSAM-Campus],
    ),
)

= Introduction

L'objectif de ce TP est d'acquérir expérimentalement les cycle d'hystérésis de deux matériaux ferromagnétiques -- le fer et la ferrite -- et de comparer leurs caractéristiques.

Pour cela, une maquette comportant tous les composants utiles sera utilisée. Leur fonctionnement est présenté dans l'@annexe-maquette.

#application(titre: "Grandeurs géométriques")[
    Calculer la section du circuit magnétique constitué par le tore. Calculer la longueur d'une ligne de champ moyenne dans le tore.
]<application-géométrie>

= Cycle d'hystérésis du fer

On peut exploiter le lien entre les grandeurs électriques et mes grandeurs magnétiques pour tracer expérimentalement le cycle d'hystérésis.

#application(titre: "Mesure de l'excitation")[
    Quel point de la maquette possède un potentiel proportionnel à l'excitation magnétique ? Calculer le coefficient de proportionnalité.
]<application-excitation>

#application(titre: "Mesure du champ magnétique")[
    Quel point de la maquette possède un potentiel proportionnel au champ magnétique ? Calculer le coefficient de proportionnalité.
]<application-champ-magnétique>

#évaluation(
    barème: (
        ([Grandeur proportionnelle à l'excitation.], 2),
        ([Coefficient de proportionnalité pour l'excitation (A.N.).], 3),
        ([Grandeur proportionnelle au champ magnétique.], 2),
        ([Coefficient de proportionnalité pour le champ magnétique (A.N.).], 3),
    ),
)[
    Réponses *écrites* à l'@application-excitation et l'@application-champ-magnétique.
]

La maquette comporte tous les circuits utiles pour réaliser les mesures nécessaires à l'étude du cycle d'hystérésis, mais encore faut-il savoir comment les connecter.

#application(titre: "Utilisation de la maquette")[
    Sur le schéma électrique ci-dessous, tracer les connexions qui permettent d'avoir sur la voie $X$ un potentiel proportionnel à l'excitation magnétique et sur la voie $Y$ un potentiel proportionnel au champ magnétique. Une lecture attentive de l'@annexe-maquette vous aidera certainement.
    
    On utilisera $N_1=60$ spires pour la mesure de l'excitation et $N_2=20$ spires pour la mesure du champ magnétique.
    
    Les adaptateurs BNC permettent simplement de réaliser des connexion entre deux formats de connecteurs : fiche BNC comme sur l'oscilloscope et fiche mini banane comme sur la maquette.

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
            let centre = p(995, 410)
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
            sortie(126deg, p(672, 152), -1)
            sortie(234deg, p(672, 665), -1)
            sortie(54deg, p(1312, 152), 1)
            sortie(-54deg, p(1312, 665), 1)
            let xd = centre.at(0) + calc.sqrt(r * r - .75 * .75)
            wire((xd, -3.35), p(1312, 335))
            wire((xd, -4.85), p(1312, 485))
            borne(p(672, 152), nom: [G], homologue: p(692, 128))
            borne(p(672, 665), nom: [H])
            borne(p(1312, 152), nom: [I], homologue: p(1290, 128))
            borne(p(1312, 335), nom: [J])
            borne(p(1312, 485), nom: [K], homologue: p(1288, 463))
            borne(p(1312, 665), nom: [L])
            content(p(700, 600), align(center)[60 \ spires])
            content(p(1290, 280), align(center)[40 \ spires])
            content(p(1290, 600), align(center)[20 \ spires])

            // Intégrateur
            titre(p(1620, 665), [Intégrateur])
            opamp("INT", p(1691, 527))
            content(p(1725, 492), sym.triangle.r)
            resistor("Ri", p(1380, 492), p(1590, 492))
            wire(p(1590, 492), "INT.minus")
            wire(p(1590, 492), p(1590, 380))
            capacitor("Ci", p(1590, 380), p(1790, 380))
            resistor("Rd", p(1590, 432), p(1790, 432))
            wire(p(1790, 380), p(1790, 527))
            wire(p(1761, 527), p(1845, 527))
            wire("INT.plus", ("INT.plus", "-|", p(1385, 655)), p(1385, 655))
            frame("G3", ("INT.plus", "-|", p(1560, 0)))
            borne(p(1380, 492), nom: $E_i$, ancre: "south")
            borne(p(1845, 527), nom: $S_i$)
            borne(p(1385, 655), nom: [M], ancre: "west")

            // Voies de l'oscilloscope
            titre(p(1625, 80), [Adaptateurs BNC])
            bnc(p(1400, 190), $X$)
            bnc(p(1755, 190), $Y$)
            wire(p(1430, 190), p(1500, 190))
            wire(p(1785, 190), p(1850, 190))
            borne(p(1500, 190))
            borne(p(1850, 190))
        })
    })
]<application-utilisation-maquette> 

#évaluation(
    barème: (
        ([Section du tore.], 2),
        ([Longueur moyenne du tore.], 2),
        ([Branchements amplificateur.], 3),
        ([Branchements intégrateur.], 3),
    ),
)[
    Réponses *écrites* à l'@application-géométrie et l'@application-utilisation-maquette.
]

Avant d'utiliser l'intégrateur, il faut régler son zéro : l'intégrale d'une tension nulle doit être nulle.

#manipulation()[
    Placer une tension nulle à l'entrée de l'intégrateur et observer sa sortie sur un oscilloscope. À l'aide d'un tournevis, ajuster le potentiomètre de l'intégrateur jusqu'à obtenir une sortie constamment nulle.
]

Les acquisitions seront réalisées grâce à Latis Pro via la plateforme d'acquisition SYSAM-Campus.

#manipulation()[
    Réaliser le montage et acquérir les voies $X$ et $Y$ sur une période.

    Le GBF sera réglé pour produire un signal sinusoïdal de fréquence #quan[20 Hz] et d'amplitude #quan[2 V].
]

Une fois les données acquises, on utilise Python pour les traiter et calculer les grandeurs d'intérêt.

#manipulation(titre: [Tracé du cycle d'hystérésis])[
    Exporter les courbes ou format texte puis les importer dans Python.

    Tracer les cycles d'hystérésis $B(H)$ et $M(H)$ à partir des données importées.

    Déterminer
    - l'aimantation de saturation
    - l'aimantation rémanente
    - le champ magnétique rémanent
    - l'excitation coercitive
    En fonction de l'avancée du TP, ces relevés seront faits par lecture graphique ou grâce à un algorithme écrit en Python.
]

#évaluation(
    appel-prof: true,
    barème: (
        ([Import des données.], 2),
        ([Calculs des grandeurs d'intérêt.], 2),
        ([Tracés avec titres et noms des axes.], 2),
        ([Lecture des 4 grandeurs.], 4),
    ),
)[
    Évaluation du code Python.
]

En plus des caractéristiques déjà mesurées sur le cycle d'hystérésis, son aire est également une grandeur importante.

#manipulation(titre: [Aire du cycle])[
    Calculer l'aire du cycle d'hystérésis. On pourra utiliser la fonction `trapezoid` de SciPy (voir @annexe-fonctions-python).
]

#évaluation(
    appel-prof: true,
    barème: (
        ([Import des données.], 2),
        ([Calculs des grandeurs d'intérêt.], 2),
        ([Tracés avec titres et noms des axes.], 2),
        ([Calcul de l'aire du cycle.], 2),
        ([Explication de l'intérêt de l'aire du cycle.], 2),
    ),
)[
    Évaluation du code Python.
]

= Cycle d'hystérésis de la ferrite

Toutes les manipulations réalisées pour le fer peuvent être reproduites pour la ferrite.

#manipulation(titre: [Cycle d'hystérésis de la ferrite])[
    En utilisant la même démarche que pour le fer, tracer les cycles d'hystérésis de la ferrite. Les quatre courbes dument titrées et légendées seront imprimées et intégrées au cours.

    Déterminer
    - l'aimantation de saturation
    - l'aimantation rémanente
    - le champ magnétique rémanent
    - l'excitation coercitive
    Les valeurs seront comparées à celles obtenues pour le fer.

    Calculer également l'aire du cycle d'hystérésis de la ferrite et comparer avec celle du fer.
]

#show: appendix

= Maquette d'étude des matériaux ferromagnétiques<annexe-maquette>

La maquette comporte deux matériaux ferromagnétiques toriques (fer et ferrite) sur lesquels des bobinages sont enroulés.

#figure(
    image("images/maquette.svg", width: 100%),
    caption: [Maquette d'étude des matériaux ferromagnétiques],
)

Différents montages électroniques sont intégrés à la maquette pour faciliter l'étude.

/ Transformateurs: Les transformateurs toriques sont constitués de fer ou de ferrite sur lesquels 3 bobinages distincts de 20, 40 et 60 spires sont enroulés. Le tore a une base carrée. Son diamètre intérieur vaut #quan[38 mm], sont diamètre extérieur vaut #quan[63 mm] et sa hauteur #quan[25 mm].

/ Amplificateur de puissance: La puissance délivrée par un GBF est insuffisante pour exciter suffisamment les matériaux. L'amplificateur de puissance permet de délivrer un signal de même forme et de puissance plus importante. Il comporte un dissipateur thermique pouvant chauffer fortement. *Ne pas toucher au dissipateur thermique pendant l'utilisation.*

/ Amplificateur de mesure du courant: Le courant peut être mesuré grâce à cet amplificateur. Le potentiel au point $C_1$ est proportionnel au courant : $V_(C_1) = k i$ avec $k=#zi.ohm[100]$ et où $i$ est le courant entrant au point $R_p$. L'amplificateur de mesure du courant et l'amplificateur de puissance s'utilisent conjointement en reliant les points $C_c$ et $R_p$.

/ Intégrateur: Le potentiel au point $S_i$ est proportionnel à l'intégrale du potentiel $E_i$ : $V_(S_i)(t) = -1/(R_i C_i) integral_0^t V_(E_i)(x) dd(x)$ avec $R_i = #zi.kohm[2.7]$ et $C_i = #quan[1 uF]$. Pour éviter toute dérive, un réglage du zéro doit être fait avant l'utilisation.

Le générateur de rampe, le multiplieur et le filtre passe-bas ne seront pas utilisés.

= Fonctions Python utiles dans ce TP<annexe-fonctions-python>

#cheatsheet-python(
    (
        "np.loadtxt",
        "plt.clf",
        "plt.plot",
        "plt.xlabel",
        "plt.ylabel",
        "plt.title",
        "plt.grid",
        "plt.show",
        "np.pi",
        "np.max",
        "np.abs",
        "scipy.integrate.trapezoid",
    ),
)
