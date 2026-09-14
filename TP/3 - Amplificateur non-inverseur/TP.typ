#import "@local/prepa:0.1.1": *

#show: TP.with(
    titre: "Amplificateur non-inverseur",
)

#préparatoire()[
    Lire l'énoncé du TP et ses annexes et effectuer l'@application-calcul-R1-R2, l'@application-tension-max et l'@application-GdB-Python.
]

#matériel(
    groupe: (
        "GBF et oscilloscope",
        "Platine d'essai et fils de connexion",
        "Résistances et condensateurs disponibles dans la salle de TP",
        [ALI et alimentation symétrique $plus.minus #quan[15 V]$],
    ),
)

// #évaluation(
//     appel-prof: true,
//     barème: (
//         ([les manipulations faites sont précisément décrites], 3),
//         ([les observations et résultats bruts sont consignés (papier, informatique, .. )], 2),
//         ([les traitements, calculs, ... sont explicités], 2),
//         ([une conclusion est apportée], 3),
//     ),
// )[
//     Le cahier de TP sera rendu à la fin de la séance et le compte-rendu évalué.
// ]

= Introduction

L'objectif de ce TP est d'étudier le montage amplificateur non-inverseur et sa fonction de transfert afin de la confronter à son expression théorique. On étudiera notamment son produit gain-bande et les différentes saturations.

= Réalisation et étude préliminaire
    
Le montage amplificateur non-inverseur sera réalisé avec les composants accessibles dans la salle de TP (voir @annexe-composants) de sorte que
+ son gain soit égal à #num[100] ;
+ l'ALI ne sature pas en courant.

#application()[
    Choisir des valeurs pour $R_1$ et $R_2$.

    Les composants utilisés en TP ont une incertitude-type de #quan[5 %]. Calculer l'incertitude sur le gain théorique de l'amplificateur.
]<application-calcul-R1-R2>

#évaluation(
    barème: (
        ([composants accessibles dans la salle de TP], 2),
        ([bon gain], 2),
        ([saturation courant], 2),
        ([incertitude sur le gain], 4),
    ),
)[
    Choix des valeurs de $R_1$ et $R_2$ et calcul de l'incertitude sur le gain théorique.
]

#application()[
    Quelle tension d'entrée maximale peut-on appliquer sans que la tension de sortie de l'ALI ne sature ?

    Pour une fréquence de #zi.kHz[500], quelle amplitude maximale peut-on appliquer sans que la vitesse de balayage ne sature ?
]<application-tension-max>

#manipulation()[
    Réaliser l'amplificateur non-inverseur sur une platine d'essai.

    Relier son entrée à un GBF et observer sa sortie sur un oscilloscope.

    Vérifier rapidement que la valeur du gain est conforme.
]

#évaluation(
    appel-prof: true,
    barème: (
        ([au moins toutes les connections correctes sauf 1], 2),
        ([toutes les connections correctes], 2),
        ([alimentation ALI], 2),
        ([masses], 2),
        ([vérification du gain], 2),
    ),
)[
    Vérification des connections sur la platine d'essai.
]

= Tracé et analyse du diagramme de Bode

Le diagramme de Bode (en gain et en phase) sera tracé après un relevé point par point réalisé à l'aide du GBF et de l'oscilloscope. Les tracés seront réalisés avec Python grâce à la bibliothèque pyplot, notamment la fonction `semilogx` de la bibliothèque `matplotlib.pyplot` qui fait le tracé avec les abscisses en échelle logarithmique (voir @annexe-fonctions-python).


#manipulation()[
    Mesurer pour chaque point
    - l'amplitude de la tension d'entrée ;
    - l'amplitude de la tension de sortie ;
    - la fréquence des signaux ;
    - le retard de la sortie par rapport à l'entrée.

    On répartira #num[10] points de mesure entre #quan[500 Hz] et #quan[500 kHz].

    Les données seront rentrées directement dans des variables dans Python.

    Tracer le diagramme de Bode en gain et en phase grâce à Python.
]

// #évaluation(
//     appel-prof: true,
//     barème: (
//         ([les signaux ne défilent pas], 2),
//         ([les signaux prennent toute la place], 2),
//         ([on voit quelques périodes], 2),
//         ([mesure de l'amplitude], 2),
//         ([mesure du retard], 2),
//     ),
// )[
//     L'enseignant dérègle l'oscilloscope et le binôme le re-règle sans utiliser le bouton auto-scale.

//     Le binôme montre ensuite comment il mesure les grandeurs d'intérêt.
// ]

#évaluation(appel-prof: true, barème: (
    ([courbe du gain en dB], 2),
    ([courbe de la phase], 2),
    ([titre], 2),
    ([axes], 2),
    ([points non reliés], 2),
))[
    L'enseignant regarde les courbes.
]

L'analyse manuelle du diagramme de Bode ne peut être faite qu'à partir des asymptotes. Dans ce TP, comme les données sont numérisées, on peut faire des traitements plus avancés et notamment un ajustement de la fonction de transfert théorique sur les données expérimentales.

Pour cela, il est nécessaire de définir en Python la fonction de Bode théorique du filtre de Wien.

#application()[
    Compléter le code suivant qui renvoie le gain en décibels du filtre de Wien.
    ```python
    R1 = ...
    R2 = ...
    def GdB(f, A0, tau):
        # f   : fréquence en Hz
        # A0  : gain statique de l'ALI
        # tau : temps de réponse de l'ALI
        return ...
    ```
]<application-GdB-Python>

Pour vérifier l'adéquation entre les diagrammes de Bode théorique et expérimental, et pour déterminer les paramètres $A_0$ et $tau$, on peut effectuer un ajustement (_fit_ en anglais), c'est-à-dire chercher la courbe théorique passant au plus près des points expérimentaux.

On utilisera la fonction `curve_fit` de la bibliothèque `scipy.optimize` (voir @annexe-fonctions-python).

#manipulation()[
    Écrire des instructions Python permettant d'effectuer l'ajustement de la fonction définie à l'@application-GdB-Python.

    Les instructions devront afficher les valeurs des paramètres $A_0$ et 
    $tau$ pour lesquelles la fonction de transfert théorique passe au plus près des points expérimentaux.
]

#évaluation(appel-prof: true, barème: (
    ([fonction GdB], 2),
    ([appel curve_fit], 2),
    ([récupération des paramètres optimaux dans des variables séparées], 2),
    ([print avec mise en forme], 2),
    ([unités], 2),
))[
    Évaluation du code.
]

Pour savoir si l'ajustement est correct, il est d'usage de tracer sur le même graphique les points expérimentaux et la courbe théorique obtenue avec les paramètres optimaux.

#manipulation()[
    Écrire des instructions Python permettant de tracer sur le même graphique les points expérimentaux et la courbe théorique obtenue avec les paramètres optimaux.
]

#application[
    Calculer le produit gain-bande de votre ALI.
]

= Saturations de l'ALI

Plusieurs grandeurs de l'ALI peuvent saturer. On souhaite observer l'effet de ces saturations sur un signal sinusoïdal et vérifier les indications du fabricant.

== Saturation en tension

#manipulation[
    En se plaçant à une fréquence de #zi.kHz[1], choisir une amplitude d'entrée permettant d'observer la saturation en tension de l'ALI. Mesurer la tension de saturation de l'ALI.
]

== Saturation en vitesse de balayage

#manipulation[
    À haute fréquence, augmenter l'amplitude de la tension d'entrée et observer la saturation en vitesse de balayage de l'ALI.
]

#manipulation[
    Changer la tension d'entrée en créneau et mesurer la vitesse de balayage maximale de l'ALI.
]

== Saturation en courant

#manipulation[
    Placer une résistance de #zi.ohm[10] entre la sortie de l'ALI et la masse. Observer l'effet de la saturation du courant sur la tension de sortie. Mesurer le courant de saturation.
]

= Conclusion

Le fabricant garanti dans sa notice des performances minimales pour l'ALI.

#application[
    Vérifier que le produit gain-bande, la tension de saturation, le courant de saturation et la vitesse de balayage sont conformes aux données du fabricant.
]

#évaluation(appel-prof: true, barème: (
    ([produit gain-bande], 2),
    ([tension de saturation], 2),
    ([courant de saturation], 2),
    ([vitesse de balayage], 2),
    ([au moins une notion d'incertitude], 2),
))[
    Court paragraphe argumenté sur l'adéquation ou non entre les valeurs mesurées et les valeurs constructeurs.
]

#show: appendix

= Fonctions Python utiles dans ce TP<annexe-fonctions-python>

#cheatsheet-python(
    (
        "plt.clf",
        "plt.plot",
        "matplotlib.pyplot.semilogx",
        "plt.xlabel",
        "plt.ylabel",
        "plt.title",
        "plt.show",
        "scipy.optimize.curve_fit",
        "np.pi",
        "numpy.linspace",
        "np.logspace",
        "np.random.normal",
    ),
)

= Composants disponibles dans la salle de TP<annexe-composants>

#figure(
    {
        let L = (4.7, 10., 12., 22., 33.)
        let résistances = ()

        for i in range(5) {
            for n in L {
                résistances.push(n * calc.pow(10, i))
            }
        }

        import "@preview/zero:0.7.0": *
        table(
            columns: 5,
            // align: right,
            ..for n in résistances {
                ([#num(n)],)
            }
        )
    },
    caption: [Résistances des résistors disponibles dans la salle de TP (en #unit("O"))],
)

#figure(
    {
        let L = (
            quan[100 pF],
            quan[400 pF],
            quan[1 nF],
            quan[2.2 nF],
            quan[4.7 nF],
            quan[10 nF],
            quan[22 nF],
            quan[100 nF],
            quan[220 nF],
            quan[470 nF],
        )

        import "@preview/zero:0.7.0": *
        table(
            columns: 10,
            ..for n in L {
                (n,)
            }
        )
    },
    caption: [Capacité des condensateur disponibles dans la salle de TP],
)
