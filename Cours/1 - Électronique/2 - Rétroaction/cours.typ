#import "@local/prepa:0.1.1": *

#show: cours.with(infos: yaml("infos.yml"))

#let grandeurs = (
    "A(p)": (signification: "la fonction de transfert de l'ALI", unité: "sans unité"),
    "S(p)": (signification: "la sortie de l'ALI", unité: unit("V")),
    "epsilon": (signification: "l'entrée différentielle de l'ALI", unité: unit("V")),
    "A_0": (signification: "le gain statique de l'ALI", unité: "sans unité"),
    "tau": (signification: "le temps de réponse de l'ALI", unité: unit("s")),
    "e": (signification: "l'entrée du montage", unité: unit("V")),
    "s": (signification: "la sortie de l'ALI", unité: unit("V")),
    "V_\"sat\"": (signification: "$lt.tilde V_\"cc\"$ la tension de saturation de l'ALI", unité: unit("V")),
    "V_\"cc\"": (signification: "la tension d'alimentation de l'ALI", unité: unit("V")),
    "Delta omega": (signification: "la bande passante", unité: unit("rad/s")),
    "H_0": (signification: "$=1+R_2/R_1$ le gain statique de l'amplificateur non-inverseur", unité: "sans unité"),
    "Z_e": (signification: "l'impédance d'entrée", unité: unit("O")),
    "U_e": (signification: "la tension d'entrée", unité: unit("V")),
    "I_e": (signification: "le courant d'entrée", unité: unit("A")),
    "R_e": (signification: "la résistance d'entrée de l'ALI", unité: unit("O")),
)

= Présentation de l'amplificateur linéaire intégré (ALI)
== Découverte
L'ALI est aussi appelé amplificateur opérationnel.

L'ALI est un composant électronique actif#footnote[Un composant actif est un composant qui fournit de l'énergie au circuit dans lequel il est connecté.], donc il doit être alimenté. L'alimentation de l'ALI est symétrique $+V_"cc"$, $-V_"cc"$. Souvent $V_"cc"=qty("15", "V")$.

#schéma(titre: "Symboles de l'ALI", hauteur: 5cm)

== Modèle de l'ALI
L'entrée différentielle est la différence de potentiel entre l'entrée non-inverseuse et l'entrée inverseuse : $epsilon=V_+-V_-$.

#manipulation(
    titre: "Découverte expérimentale de l'ALI",
    matériel: (
        "GBF",
        "Oscilloscope",
        "Alimentation symétrique +15V",
        "Breadboard \"Rétroaction\"",
        "3 adaptateurs BNC/banane",
        "3 câbles rouges",
        "3 câbles noirs",
        "Caméra pour projection",
    ),
)[
    On place un signal sinusoïdal venant d'un GBF en entrée d'un pont diviseur de tensions et dont la sortie va à un ALI alimenté en #qty("15", "V") et #qty("-15", "V") et on observe la tension de sortie sur un oscilloscope.
    #carreaux(4cm)
]

#encadré(
    titre: "Fonction de transfert de l'ALI",
    hypothèses: "Le régime est linéaire",
    grandeurs: sub-dictionary(grandeurs, ("A(p)", "S(p)", "epsilon", "A_0", "tau")),
    connaitre: true,
)[
    $
        A(p)=(S(p))/(epsilon(p)) = A_0/(1+tau p)
    $
]

La fréquence de coupure $1/(2 pi tau) tilde qty("10", "Hz")$ est trop faible pour la plupart des applications et le gain est très élevé et ne peut pas être réglé. L'ALI ne peut donc pas être utilisé seul. On utilise l'ALI dans des montages permettant de surmonter ces limitations.

#manipulation(titre: "Saturation de l'ALI")[
    On reprend la manipulation précédente et on augmente l'amplitude du GBF.
]

#encadré(
    titre: "Saturation",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("s", "V_\"sat\"", "V_\"cc\"")),
)[
    La tension de sortie est bornée : $s(t) in [-V_"sat",V_"sat"]$
]

#flashcard(
    recto: "Modèle de l'ALI",
    verso: "Résistance d'entrée infinie, résistance de sortie nulle, fonction de transfert du premier ordre en régime linéaire $(S(p))/(epsilon(p)) = A_0/(1+tau p)$, existence d'une saturation de la tension de sortie.",
)
#flashcard(
    recto: "Ordre de grandeur du gain statique et du temps de réponse d'un ALI",
    verso: "$A_0 tilde num(\"e5\")$, $tau tilde qty(\"e-2\", \"s\")$.",
)

/ Résistance d'entrée: La résistance d'entrée $R_e$ est très élevée sur les deux entrées. Le courant d'entrée $i_e=e/R_e$ est donc très faible.

#application[
    Déterminer le courant d'entrée pour l'entrée maximale admissible.
]

/ Résistance de sortie: La résistance de sortie est très faible. La tension de sortie est donc indépendante du courant de sortie.

== Limitations du modèle de l'ALI
Le modèle présenté dans la partie précédente a des limites.

#manipulation(titre: "Vitesse de balayage")[
    On reprend le montage précédent et on remplace le signal sinusoïdal par un signal créneau.
]

/ Vitesse de balayage: La dérivée de la tension de sortie est bornée à une valeur appelée *vitesse de balayage* (slew rate en anglais). La tension de sortie ne peut pas croitre ou décroitre plus rapidement que la vitesse de balayage.

#application[
    Que vaut la vitesse de balayage pour l'ALI utilisé en TP ?
]

/ Courant de sortie: Le courant de sortie est borné et peut donc saturer.

#application[
    Quelle résistance peut-on mettre en sortie de l'ALI utilisé en TP tout en restant sûr que le courant de sortie ne sature pas ?
]

#flashcard(
    recto: "Limites du modèle de l'ALI",
    verso: "Vitesse de balayage, saturation du courant de sortie.",
)

#question-de-colle(
    "Décrire le modèle de l'ALI en précisant les ordres de grandeurs du gain statique et du temps de réponse, ainsi que ses limitations.",
)

== Modèle de l'ALI idéal

Dans le modèle de l'ALI idéal, le gain statique est infini et le temps de réponse est nul.

Dans le modèle de l'ALI idéal, deux régimes existent :
- le régime saturé où la sortie vaut $V_"sat"$ ou $-V_"sat"$
- le régime linéaire où l'entrée différentielle est nulle

#encadré(
    titre: "Comportement de l'ALI idéal",
    hypothèses: (
        "L'ALI est idéal (gain statique infini et temps de réponse nul)",
    ),
    grandeurs: sub-dictionary(grandeurs, ("epsilon", "s", "V_\"sat\"")),
)[
    #grid(
        columns: (1fr, 1fr),
        [
            #set align(center)
            *Régime saturé*\
            si $epsilon > 0$ alors $s(t)=V_"sat"$\
            si $epsilon < 0$ alors $s(t)=-V_"sat"$
        ],
        [
            #set align(center)
            *Régime linéaire*
            $ epsilon = 0 $
        ],
    )
]

#flashcard(
    recto: "Fonctionnement de l'ALI idéal en régime saturé",
    verso: "si $epsilon > 0$ alors $s(t)=V_\"sat\"$\\ si $epsilon < 0$ alors $s(t)=-V_\"sat\"$",
)
#flashcard(
    recto: "Fonctionnement de l'ALI idéal en régime linéaire",
    verso: "$epsilon = 0$",
)

= L'ALI dans un montage avec rétroaction négative
#{
    grandeurs.insert("S(p)", (signification: "la sortie du montage", unité: unit("V")))
    grandeurs.insert("E(p)", (signification: "l'entrée du montage", unité: unit("V")))
    grandeurs.insert("R_1", (signification: "une résistance", unité: unit("O")))
    grandeurs.insert("R_2", (signification: "une résistance", unité: unit("O")))
    grandeurs.insert("H(p)", (
        signification: "$=S(p)/E(p)$ la fonction de transfert du montage",
        unité: "sans unité",
    ))
}
== Notion de rétroaction
La rétroaction est la prise en compte de la sortie d'un système à son entrée. Le système est alors bouclé.

#exemple[
    #lien("https://youtu.be/MFzDaBzBlL0")
    Je fais du vélo au milieu d'une route droite. J'observe ma trajectoire. Je vois que je suis un peu trop à droite. Deux options s'offrent à moi :
    / Je peux commander à mon vélo d'aller vers la gauche: Il s'agit d'une rétroaction négative#footnote[Notez qu'il ne s'agit pas d'un jugement sur le résultat de l'action. La rétroaction est négative si elle va à l'encontre de la situation actuelle, que cela soit souhaitable ou non.] : elle tend à annuler les variations de la sortie. Je vais me rapprocher du milieu de la route.
    / Je peux commander à mon vélo d'aller vers la droite: Il s'agit d'une rétroaction positive : elle tend à amplifier les variations de la sortie. Je vais m'éloigner de plus en plus et de plus en plus vite du milieu de la route.
]

#encadré(
    titre: "Effet d'une rétroaction",
    connaitre: true,
)[
    Une rétroaction négative suggère un fonctionnement stable.

    Une rétroaction positive ou une absence de rétroaction suggère un fonctionnement instable.
]

#flashcard(
    recto: "Lien entre la nature de la rétroaction et la stabilité",
    verso: "Une rétroaction négative suggère un fonctionnement stable. Une rétroaction positive ou une absence de rétroaction suggère un fonctionnement instable.",
)

#application[
    Pour chacune des rétroactions suivantes, dire si elles sont positives ou négatives et dire si elles tendent à stabiliser ou déstabiliser le système.
    + Plus il fait chaud, plus l'air contient de vapeur d'eau (qui est un gaz à effet de serre).
    + Plus le climat se réchauffe, plus le permafrost fond, ce qui libère du méthane, un puissant gaz à effet de serre.
    + Plus il fait chaud, plus l'eau s'évapore et plus il y a de nuages (qui bloquent une partie du rayonnement solaire vers l'espace).
    + Le robinet thermostatique du radiateur s'ouvre davantage lorsqu'il fait froid, laissant ainsi circuler l'eau chaude du chauffage central.
    + Un excès de graisse dans le corps perturbe la régulation hormonale de la satiété et amplifie la sensation de faim.
]

== Le montage amplificateur non-inverseur
Le montage étudié dans cette partie est couramment utilisé pour amplifier des signaux. Amplifier des signaux est une tâche très utile et très répandue.

#exemple[
    Amplification d'un signal audio, d'un signal en provenance d'un instrument de mesure, ...
]

#schéma(titre: "Montage amplificateur non-inverseur", hauteur: 5cm)

#encadré(
    titre: "Schéma bloc de l'amplificateur non-inverseur",
    hypothèses: (
        "circuit dans l'ARQS",
        "ALI en régime linéaire",
    ),
    grandeurs: sub-dictionary(grandeurs, ("S(p)", "E(p)", "epsilon", "A_0", "tau", "R_1", "R_2")),
    savoir-faire: true,
)[
    #carreaux(7cm)
]

Ce schéma bloc explicite le caractère bouclé du montage amplificateur non-inverseur. La sortie est renvoyée à l'entrée inverseuse de l'ALI par l'intermédiaire d'un pont diviseur de tension.

La plupart des montages utilisant un ALI sont des systèmes bouclés comportant une rétroaction.

#encadré(
    titre: "Fonction de transfert de l'amplificateur non-inverseur",
    hypothèses: (
        "circuit dans l'ARQS",
        "ALI en régime linéaire",
        [$R_1$ et $R_2$ sont du même ordre de grandeur.],
    ),
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("H(p)", "S(p)", "E(p)", "epsilon", "A_0", "tau", "R_1", "R_2")),
)[
    $
        H(p) = (1+R_2/R_1) / (1+ (1+R_2/R_1) tau/A_0 p)
    $
]

== Stabilité
Le montage amplificateur non-inverseur est stable.

Si l'ALI est hors saturation, comme son gain est très grand, l'entrée différentielle est quasi-nulle.

#question-de-colle(
    "Le montage étant donné, établir le schéma-bloc régissant le montage amplificateur non-inverseur et en déduire sa fonction de transfert et sa stabilité.",
)

#encadré(
    titre: "Stabilité d'un montage avec rétroaction négative",
    hypothèses: (
        "Il y a une rétroaction négative"
    ),
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("epsilon",)),
)[
    Le système est généralement stable et $epsilon$ est faible.
]

== Bande passante

#encadré(
    titre: "Bande passante du montage amplificateur non-inverseur",
    savoir-faire: true,
    hypothèses: (
        "Le circuit est dans l'ARQS.",
        "L'ALI est en régime linéaire.",
        [$R_1$ et $R_2$ sont du même ordre de grandeur.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("Delta omega", "A_0", "tau", "H_0")),
)[
    $
        Delta omega = A_0 / (tau H_0)
    $
]

#application[
    Calculer la bande passante d'un amplificateur non-inverseur ayant un gain de $100$ réalisé avec un ALI utilisé en TP.
]

#manipulation(titre: "Amplificateur non-inverseur")[
    On réalise le montage de l'amplificateur non-inverseur et on place en entrée un signal sinusoïdal. On observe la sortie sur un oscilloscope.
    #carreaux(3cm)
]

La bande passante de l'amplificateur non-inverseur est considérablement plus grande que celle de l'ALI. Le gain de l'amplificateur non-inverseur peut être réglé par les résistances $R_1$ et $R_2$. Ceci pallie les défauts de l'ALI comme amplificateur.

Le produit gain bande-passante $H_0 times Delta omega = A_0/tau$ ne dépend que de l'ALI. Pour cette raison, le produit gain bande-passante figure sur la notice de l'ALI (_gain-bandwidth product_).

== Impédance d'entrée

#encadré(
    titre: "Impédance d'entrée d'un montage",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("Z_e", "U_e", "I_e")),
)[
    $
        underline(Z_e) = underline(U_e) / underline(I_e)
    $
]
#application[
    Déterminer l'impédance d'entrée de l'amplificateur non-inverseur.
]

Il est parfois nécessaire d'associer plusieurs filtres en cascade. Il est alors nécessaire que chaque filtre ne perturbe pas celui placé en amont et ne soit pas facilement perturbé par celui placé en aval. Pour cela, on cherche à concevoir des filtres ayant une impédance d'entrée élevée et une impédance de sortie faible.

== Étude de l'amplificateur non-inverseur avec un ALI idéal
La présence d'une rétroaction négative stabilisant le montage permet de supposer l'ALI en régime linéaire. Si l'ALI est idéal, la fonction de transfert du montage amplificateur non-inverseur peut être déterminée simplement.

#application[Déterminer la fonction de transfert de l'amplificateur non-inverseur en supposant l'ALI idéal.]

= L'ALI dans un montage avec rétroaction positive : le comparateur à hystérésis négatif
== Présentation du montage

#schéma(titre: "Montage comparateur à hystérésis négatif", hauteur: 5cm)

== Étude de la stabilité

#encadré(
    titre: "Fonction de transfert du comparateur à hystérésis négatif",
    savoir-faire: true,
    hypothèses: (
        "Le circuit est dans l'ARQS.",
        "L'ALI est en régime linéaire",
        [$R_1$ et $R_2$ sont du même ordre de grandeur.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("H(p)", "R_1", "R_2", "tau", "A_0")),
)[
    $
        H(p) = 1 / ( R_1/(R_1+R_2) - tau/A_0 p)
    $
]

== Stabilité

Le comparateur à hystérésis est un montage instable. Sa sortie diverge, ou plutôt atteint rapidement la saturation. Ainsi $s(t)=plus.minus V_"sat"$.

#question-de-colle(
    "Le montage étant donné, établir le schéma-bloc régissant le montage comparateur à hystérésis négatif et en déduire sa fonction de transfert et sa stabilité.",
)

#encadré(
    titre: "Stabilité d'un montage avec rétroaction positive ou sans rétroaction",
    hypothèses: (
        "Il y a une rétroaction positive ou pas de rétroaction."
    ),
    grandeurs: sub-dictionary(grandeurs, ("V_\"sat\"",)),
)[
    Le système est généralement instable et la sortie tend rapidement vers $plus.minus V_"sat"$.
]

== Cycle d'hystérésis
Le comparateur à hystérésis n'étant pas un système linéaire, il ne peut pas être décrit par une fonction de transfert.

Pour décrire le fonctionnement du comparateur à hystérésis, on représente sa sortie en fonction de son entrée dans un diagramme appelé *cycle d'hystérésis*.

#encadré(
    titre: "Cycle d'hystérésis du comparateur à hystérésis négatif",
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("R_1", "R_2", "V_\"sat\"")),
    hypothèses: (
        "Le circuit est dans l'ARQS.",
        "La sortie est stabilisée à sa valeur limite.",
    ),
)[
    #carreaux(5cm)
]

#manipulation(titre: "Cycle d’hystérésis expérimental")[
    On réalise le montage du comparateur à hystérésis négatif et on place en entrée un signal sinusoïdal. On observe la sortie sur un oscilloscope en mode XY.
    #carreaux(3cm)
]

== Fonction mémoire
En physique, le mot "hystérésis" renvoie à la notion de mémoire : l'état du système ne dépend pas que de l'état actuel de l'entrée mais aussi de son état passé.

#encadré(
    titre: "Effet mémoire du comparateur à hystérésis",
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("R_1", "R_2", "V_\"sat\"", "e")),
)[
    #set list(spacing: 1.2em)
    - $e < -R_1 / (R_1+R_2) V_"sat"$ force la sortie à $V_"sat"$
    - $e > R_1 / (R_1+R_2) V_"sat"$ force la sortie à $-V_"sat"$
    - $e in [-R_1 / (R_1+R_2) V_"sat", R_1 / (R_1+R_2) V_"sat"]$ conserve la valeur précédente de la sortie (effet mémoire)
]

#question-de-colle(
    "Le montage étant donné, établir le cycle d'hystérésis du montage comparateur à hystérésis négatif. Expliciter l'effet mémoire du montage.",
)

#pagebreak()
#show: appendix

= Extrait de la notice du TL081

#figure(
    image("images/datasheet.pdf", page: 3, width: 100%),
    caption: "Notice du TL081 - caractéristiques électriques (page 3)",
)

