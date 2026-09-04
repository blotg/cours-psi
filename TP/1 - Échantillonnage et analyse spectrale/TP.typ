#import "@local/prepa:0.1.1": *

#show: TP.with(
    titre: "Échantillonnage et analyse spectrale",
)

#préparatoire[
    Lire l'introduction, le début de la partie #ref(<partie>, supplement: none) et faire l'application #ref(<application-à-préparer>, supplement: none).
]

#matériel(
    groupe: ("GBF", "Carte d'acquisition campus"),
    classe: ("Moteur avec roue rouge marquée d'un trait noir", "Alimentation stabilisée", "Stroboscope à lampe Xénon"),
)

= Introduction

La mesure d’un signal, qualifié "d’analogique", se réalise en général à l’aide d’un "capteur" auquel il
faut souvent ajouter un "adaptateur". Par exemple un microphone ne délivrera une tension que de l’ordre
du #unit("mV"), il faudra donc l’amplifier.

Si l’on désire réaliser un traitement numérique de ce signal, une conversion "analogique-numérique" ("CAN") doit être réalisée. C’est par exemple ce que réalise une carte d’acquisition.
On peut représenter l’ensemble de la chaine d’acquisition ainsi :

#figure(image("images/1.png", width: 90%), caption: [Chaine d'acquisition d'un signal analogique])

#évaluation(
    barème: (
        ([Signification des réglages Latis], 2),
        ([Comment choisir les réglages Latis], 2),
        ([Tracé spectre Latis], 2),
        ([Tracé spectre Python], 2),
        ([Fiche qui donne envie d'être lue], 2),
    ),
)[
    Au cours de ce TP, vous rédigerez, en plus du compte-rendu habituel, une fiche méthode à la fin de votre cahier de TP. Cette fiche méthode devra contenir les points suivants :
    - Comment régler LatisPro quand on fait une acquisition
    - Comment tracer un spectre avec LatisPro
    - Comment tracer un spectre avec Python
]

= Première approche du critère de Shannon
L’échantillonnage est l’opération qui consiste à mesurer un signal en capturant des valeurs à intervalles réguliers.

L’intervalle de mesure s’appelle la période d’échantillonnage, notée $T_e$. Se pose alors la question de savoir si les échantillons sont représentatifs du signal initial.

Parfois, dans les vidéos montrant des objets tournant (roues de voiture, pales d'hélicoptère, ...), ceux-ci ne semblent pas tourner à la "bonne" vitesse, voire dans le mauvais sens. Cela est dû à une inadéquation entre la fréquence de rafraichissement des images (24 images par seconde en général), la vitesse de rotation
et le nombre de barreaux des roues. Voir par exemple : #link("https://youtu.be/C6f0tTdba8Y?feature=shared&t=107")

#manipulation(titre: "Roue éclairée par un stroboscope")[
    Observer un disque en rotation à vitesse constante, éclairé par un stroboscope.

    Quelle relation doivent vérifier la fréquence du stroboscope (fréquence d'échantillonnage) et la fréquence de rotation de la roue (fréquence du signal) pour que le mouvement de la roue soit correctement observé ?
]

#application[
    En supposant que la roue tourne dans le sens horaire, compléter les schémas ci-dessous en représentant la position du trait sur la roue.

    #let roues(N: 1, divisions: 1) = {
        import cetz.draw: *
        let sep = 3
        let portion = 20deg
        for i in array.range(0, N) {
            circle((i * sep, 0), radius: 1)
            // arc(
            //     (rel: (angle: -portion / 2 + 360deg * i / divisions, radius: 1), to: (i * sep, 0)),
            //     start: -portion / 2 + 360deg * i / divisions,
            //     delta: portion,
            //     mode: "PIE",
            //     fill: red,
            // )
            content(
                (i * sep, -1),
                if (i == 0) { [$0$ tour] } else { [$#{ i / divisions }$ tour] },
                anchor: "north",
                padding: 0.6em,
            )
        }
    }

    #figure(
        canvas({
            import cetz.draw: *
            scale(0.6)
            roues(N: 9, divisions: 8)
        }),
        caption: [Roue tous les $1/8$ de tours],
    )

    #figure(
        canvas({
            import cetz.draw: *
            scale(0.6)
            roues(N: 5, divisions: 4 / 3)
        }),
        caption: [Roue éclairée tous les $3/4$ de tours],
    )
    Dans les deux cas, dire si le mouvement de la roue est correctement observé.
]

À la suite des constatations précédentes, on admet le théorème de Nyquist-Shannon :
#encadré(
    titre: "Théorème de Nyquist-Shannon",
    connaitre: true,
    grandeurs: (
        "f_e": (signification: "la fréquence d'échantillonnage", unité: "Hz"),
        "f_\"max\"": (signification: "la fréquence maximale présente dans le spectre du signal", unité: "Hz"),
    ),
)[
    Un signal est correctement représenté à partir de ses échantillons ssi $f_e>2f_"max"$
]

#application[
    Quelle fréquence d'échantillonnage minimale faut-il pour représenter correctement un signal audio ? Est-ce cohérent avec la fréquence utilisée par les CD musicaux (#qty("44100", "Hz")) ?
]

= Choix d'une fréquence d'échantillonnage

Pour visualiser l'influence de la fréquence d'échantillonnage sur l'acquisition, on va acquérir un signal sinusoïdal de fréquence #qty("10", "kHz") connue produit par un GBF puis en tracer le spectre grâce à LatisPro (voir @annexe-spectre-latis-pro).

#manipulation(titre: "Acquisition correcte")[
    Réaliser une acquisition d'un signal sinusoïdal de fréquence #qty("10", "kHz") produit par un GBF en respectant *largement* le critère de Shannon.

    En tracer le spectre et vérifier que la fréquence observée est bien la fréquence réelle.

    Conserver cette acquisition qui resservira par la suite.
]

#manipulation(titre: "Acquisition incorrecte")[
    Réaliser une acquisition d'un signal sinusoïdal de fréquence #qty("10", "kHz") produit par un GBF en ne respectant pas le critère de Shannon.

    En tracer le spectre et vérifier que la fréquence observée est bien différente de la fréquence réelle.
]

Lorsque la fréquence d'échantillonnage n'est pas suffisante, la fréquence mesurée sur le spectre n'est pas la fréquence réelle du signal. On dit qu'il y a *repliement du spectre*.

= Lien entre paramètres d'acquisition et paramètres du spectre<partie>
L'acquisition est réglée par 3 nombres :
- le nombre de points $N$
- la période d’échantillonnage (durée entre deux points) $T_e$
- la durée de l’acquisition $D$

#application[
    Quelle relation lie ces 3 nombres ?
]<application-à-préparer>

On a donc 2 "degrés de liberté" sur l'acquisition. Lorsqu'on change un des trois paramètres dans le logiciel d'acquisition, un des deux autres est nécessairement modifié.


== Durée d'acquisition et résolution spectrale
La résolution spectrale (écart de fréquence entre 2 points successifs sur le spectre) est liée à la durée de l'acquisition.

#encadré(
    titre: "Résolution spectrale",
    connaitre: true,
    grandeurs: (
        "Delta f": (signification: "la résolution spectrale", unité: "Hz"),
        "D": (signification: "la durée d'acquisition", unité: "s"),
    ),
)[
    $
        Delta f = 1 / D
    $
]

*Si on veut plus de détails sur le spectre, il faut acquérir plus longtemps*.

#manipulation(titre: "Lien entre durée d'acquisition et résolution spectrale")[
    Vérifier cette relation sur l'acquisition réalisée précédemment.
]

== Période d'échantillonnage et étendue spectrale
La fréquence la plus grande observable sur le spectre est la fréquence donnée par le critère de Shannon : $f_e/2$.

#manipulation(titre: "Fréquence maximale présente sur le spectre")[
    Vérifier cette relation sur l'acquisition réalisée précédemment.
]

*Si on veut observer des fréquences plus élevées, il faut acquérir plus vite*.

= Calcul de spectre avec Python
Le calcul du spectre à partir du signal est effectué avec un algorithme appelé FFT (Fast Fourier Transform). Cet algorithme, de complexité quasi-linéaire et utilisant le principe "diviser pour régner", est implanté par exemple dans les oscilloscopes numériques, dans LatisPro et dans la bibliothèque numpy de Python, notamment les fonctions #link("https://numpy.org/doc/stable/reference/generated/numpy.fft.rfft.html")[`np.fft.rfft`] et #link("https://numpy.org/doc/stable/reference/generated/numpy.fft.rfftfreq.html")[`np.fft.rfftfreq`].

Le spectre d'un signal peut être calculé à partir des lignes suivantes, à supposer que le signal soit dans la variable `s` et la période d’échantillonnage dans la variable `Te`.
```python
import numpy as np
s_fourier = np.abs(np.fft.rfft(s)) # Calcul de spectre
freqs = np.fft.rfftfreq(len(s), Te) # Calcul des fréquences en Hz
```

#manipulation(titre: "Tracé du spectre avec Python")[
    Exporter les données de l'acquisition dans un fichier texte, les importer dans Python et tracer le spectre. Ce spectre est-il cohérent avec celui tracé par LatisPro ?
]

= Visualisation du critère de Shannon avec Python
On souhaite tracer le signal $cos(2 pi f t)$ avec $f = #qty("100", "Hz")$ sur une durée de $#qty("0.5", "s")$.
Réaliser le tracé pour des périodes d'échantillonnage de #qty("0.001", "s"), #qty("0.01", "s") et #qty("0.011", "s").
On pourra utiliser les fonctions #link("https://numpy.org/doc/stable/reference/generated/numpy.arange.html")[`arange`] ou #link("https://numpy.org/doc/stable/reference/generated/numpy.linspace.html")[`linspace`] pour créer les vecteurs de temps.

#manipulation(titre: "Simulation numérique d'un repliement de spectre")[
    Avec Python, définir les variables `t1`, `t2` et `t3` correspondant aux 3 périodes d'échantillonnage, puis tracer les 3 signaux sur le même graphique. Lequel est fidèle au signal réel ? Est-ce cohérent avec le critère de Shannon ? Les signaux seront affichés par des points non reliés.

    Tracer ensuite le spectre de ces 3 signaux. Lequel est fidèle au signal réel ? Est-ce cohérent avec le critère de Shannon ?
]

#show: appendix

= Tracé de spectre avec LATIS-Pro<annexe-spectre-latis-pro>

Pour tracer le spectre avec LATIS-Pro, il faut cliquer sur "Traitements" puis "Calculs spécifiques" puis "Analyse de Fourier" ou appuyer sur la touche F6 du clavier. Une fenêtre s'ouvre alors. On peut alors ouvrir le menu "Avancé" et mettre le niveau de validité#footnote[Par défaut, LATIS-Pro retire du spectre tous les points inférieurs à ce seuil ce qui n'est généralement pas un comportement désiré.] à #qty("0", "%"). Il ne reste alors plus qu'à faire glisser la courbe dont on souhaite tracer le spectre dans le cadre "Courbe".

#figure(
    grid(
        columns: (1fr, 1fr),
        align: horizon,
        image("images/capture latis menu.png", width: 70%), image("images/capture latis.png", width: 70%),
    ),
    caption: [Fenêtre de calcul du spectre avec LATIS-Pro],
)
