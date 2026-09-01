#import "@local/prepa:0.1.1": *

#show: TP.with(
    titre: "Échantillonnage et analyse spectrale",
)

#préparatoire()[
    Lire l'énoncé du TP et ses annexes et effectuer l'@application-calcul-RC, l'@application-GdB-Python
]

#évaluation(
    appel-prof: true,
    barème:(
        ([les manipulations faites sont précisément décrites], 3),
        ([les observations et résultats bruts sont consignés (papier, informatique, .. )], 2),
        ([les traitements, calculs, ... sont explicités], 2),
        ([une conclusion est apportée], 3),
    ),
)[
    Le cahier de TP sera rendu à la fin de la séance et le compte-rendu évalué.
]

= Introduction

L'objectif de ce TP est d'étudier le filtre de Wien et sa fonction de transfert.

= Réalisation et étude préliminaire

Le filtre de Wien sera réalisé avec les composants accessibles dans la salle de TP de sorte que
- sa fréquence caractéristique soit comprise entre #qty("10", "kHz") et #qty("20", "kHz") ;
- sa résistance soit comprise entre #qty("2", "kΩ") et #qty("20", "kΩ").

#application()[
    Choisir des valeurs pour $R$ et $C$.

    Les composants utilisés en TP ont une incertitude-type de #qty("5", "%"). Calculer l'incertitude sur la fréquence caractéristique $f_0$.
]<application-calcul-RC>

#évaluation(
    barème:(
        ([les valeurs de ], 2),
        ([les signaux prennent toute la place], 2),
        ([on voit quelques périodes], 2),
        ([critère sur l'amplitude], 2),
        ([estimation de la fréquence], 2),
    ),
)[
    Choix des valeurs de $R$ et $C$ et calcul de l'incertitude sur la fréquence caractéristique $f_0$.
]

#manipulation()[
    Réaliser le filtre de Wien sur une platine d'essai.

    Relier son entrée à un GBF et observer sa sortie sur un oscilloscope.

    Vérifier rapidement et qualitativement que la nature du filtre et la fréquence caractéristique sont conformes aux attentes.
]

#évaluation(
    appel-prof: true,
    barème:(
        ([les signaux ne défile pas], 2),
        ([les signaux prennent toute la place], 2),
        ([on voit quelques périodes], 2),
        ([critère sur l'amplitude], 2),
        ([estimation de la fréquence], 2),
    ),
)[
    L'enseignant dérègle l'oscilloscope et le binôme le re-règle sans utiliser le bouton auto-scale.

    Le binôme montre ensuite comment il estime la fréquence caractéristique en utilisant l'amplitude.
]

#évaluation(
    appel-prof: true,
    barème:(
        ([les signaux ne défile pas], 2),
        ([les signaux prennent toute la place], 2),
        ([on voit quelques périodes], 2),
        ([critère sur la phase], 2),
        ([estimation de la fréquence], 2),
    ),
)[
    L'enseignant dérègle l'oscilloscope et le binôme le re-règle sans utiliser le bouton auto-scale.

    Le binôme montre ensuite comment il estime la fréquence caractéristique en utilisant la phase.
]

= Tracé et analyse du diagramme de Bode

Le diagramme de Bode (en gain et en phase) sera tracé après un relevé point par point réalisé à l'aide du GBF et de l'oscilloscope. Les tracés seront réalisés avec Python grâce à la bibliothèque pyplot, notamment la fonction `semilogx` de la bibliothèque `matplotlib.pyplot` qui fait le tracé avec les abscisses en échelle logarithmique. La fonction `semilogx` prend les mêmes arguments que la fonction `plot` à la place de laquelle elle s'utilise.

#application()[
    Expliquer pourquoi in est nécessaire de mesurer également l'amplitude de la tension d'entrée, issue du GBF, plutôt que de lire sa valeur sur l'écran de celui-ci.
]

#manipulation()[
    Mesurer pour chaque point
    - l'amplitude de la tension d'entrée ;
    - l'amplitude de la tension de sortie ;
    - la fréquence des signaux ;
    - le retard de la sortie par rapport à l'entrée.

    On répartira les points pour des fréquences entre #qty("10", "Hz") et #qty("100", "kHz") en choisissant 5 points avant la fréquence caractéristique et 5 points après.

    Les données seront rentrées directement dans des variables dans Python.

    Tracer le diagramme de Bode en gain et en phase grâce à Python.
]

#évaluation(
    appel-prof: true,
    barème:(
        ([les signaux ne défile pas], 2),
        ([les signaux prennent toute la place], 2),
        ([on voit quelques périodes], 2),
        ([mesure de l'amplitude], 2),
        ([mesure du retard], 2),
    ),
)[
    L'enseignant dérègle l'oscilloscope et le binôme le re-règle sans utiliser le bouton auto-scale.

    Le binôme montre ensuite comment mesure les grandeurs d'intérêt.
]

#évaluation(appel-prof: true,
    barème:(
        ([courbe du gain en dB], 2),
        ([courbe de la phase], 2),
        ([titre], 2),
        ([axes], 2),
        ([points non reliés], 2),
    ),
)[
    L'enseignant regarde les courbes.
]

L'analyse manuelle du diagramme de Bode ne peut être faite qu'à partir des asymptotes. Dans ce TP, comme les données sont numérisées, on peut faire des traitements plus avancés et notamment une régression sur les données expérimentales.

Pour cela, il est nécessaire de définir en Python la fonction de Bode théorique du filtre de Wien.

#application()[
    Compléter le code suivant qui renvoie le gain en décibels du filtre de Wien.
    ```python
    def GdB(f, A, f0, Q):
        # f  : fréquence en Hz
        # A  : constante sans dimension
        # f0 : fréquence caractéristique
        # Q  : facteur de qualité
        return ...
    ```
]<application-GdB-Python>

Pour vérifier l'adéquation entre les diagrammes de Bode théorique et expérimental, et pour déterminer les paramètres $A$, $f_0$ et $Q$, on peut effectuer un ajustement (_fit_ en anglais), c'est-à-dire chercher la courbe théorique passant au plus près des points expérimentaux.

Pour cela, on utilisera la fonction `curve_fit` de la bibliothèque `scipy.optimize`. Celle-ci prend en arguments
- la fonction à ajuster (son premier argument doit être l'abscisse et les suivants les paramètres à ajuster),
- la liste des abscisses des points expérimentaux,
- la liste des ordonnées des points expérimentaux,
- un paramètre optionnel `bounds` (tuple ou liste de tuples) qui correspond aux bornes inférieure et supérieure des paramètres à ajuster (par exemple, avec `bounds=(0,np.inf)`, les paramètres seront contraints à être positifs).
Elle renvoie un tuple dont le premier élément est la liste des valeurs optimales des paramètres de la fonction.

#manipulation()[
    Écrire des instructions Python permettant d'effectuer l'ajustement de la fonction définie à l'@application-GdB-Python.

    Les instructions devront afficher les valeurs optimales des paramètres $A$, $f_0$ et $Q$.
]

Pour savoir si l'ajustement est correct, il est d'usage de tracer sur le même graphique les points expérimentaux et la courbe théorique obtenue avec les paramètres optimaux.

#manipulation()[
    Écrire des instructions Python permettant de tracer sur le même graphique les points expérimentaux et la courbe théorique obtenue avec les paramètres optimaux.
]

= Prise en compte des incertitudes
Conclure sur la compatibilité ou non entre les valeurs attendues et les valeurs expérimentales, une estimation des incertitudes est indispensable. Reprendre une mesure faite sur l'oscilloscope.

#manipulation()[
    Estimer l'incertitude relative sur la mesure du retard sur l'oscilloscope. On généralisera cette valeur à tous les points de mesure.

    Estimer l'incertitude absolue sur la mesure de l'amplitude sur l'oscilloscope. On généralisera cette valeur à tous les points de mesure.
]
#évaluation(
    barème:(
        ([estimation présente], 3),
        ([estimation pertinente], 4),
        ([estimation précise], 3),
    ),
)[
    Présenter le calcul des incertitudes expérimentales sur l'amplitude.
]
#évaluation(
    barème:(
        ([estimation présente], 3),
        ([estimation pertinente], 4),
        ([estimation précise], 3),
    ),
)[
    Présenter le calcul des incertitudes expérimentales sur le retard.
]

Il reste alors à propager cette incertitude sur la fréquence caractéristique $f_0$, le facteur de qualité $Q$ et sur $A$. On utilisera pour cela la méthode de Monte-Carlo.

#manipulation()[
    Implémenter la méthode de Monte-Carlo pour estimer l'incertitude sur la valeur de $f_0$, $A$ et $Q$.
]

= Conclusion

Il est maintenant possible de conclure sur l'adéquation des valeurs attendues aux valeurs mesurées pour $f_0$, $A$ et $Q$.

#application()[
    Les valeurs mesurées via l'ajustement des trois paramètres sont-elles cohérentes avec elles calculées à partir des valeurs des composants ? La conclusion sera rédigée après le calcul d'un écart normalisé.
]

#show: appendix

= Fonctions Python utiles dans ce TP