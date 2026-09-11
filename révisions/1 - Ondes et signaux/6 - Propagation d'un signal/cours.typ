#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Onde progressive

#flashcard(
    recto: "Forme d'une onde progressive à une dimension",
    verso: "$f(t - x/c)$ ou $F(x - c t)$ pour une onde se propageant vers les $x$ croissants.

    $g(t + x/c)$ ou $G(x + c t)$ pour une onde se propageant vers les $x$ décroissants.",
)
#flashcard(
    recto: "Relation entre fréquence, longueur d'onde et célérité",
    verso: "$lambda = c T = c/f$, avec $lambda$ en #unit(\"m\"), $c$ en #unit(\"m/s\") et $f$ en #unit(\"Hz\").",
)
#flashcard(
    recto: "Déphasage dû à la propagation sur une distance $d$",
    verso: "Entre deux points distants de $d$, le retard vaut $tau = d/c$ et le déphasage $Delta phi = omega tau = 2 pi d/lambda$.",
)
#flashcard(
    recto: "Milieu dispersif",
    verso: "Un milieu est dispersif quand la célérité dépend de la fréquence : un signal non sinusoïdal s'y déforme en se propageant.",
)
#flashcard(
    recto: "Fréquences des ondes sonores du domaine audible",
    verso: "Environ de #qty(\"20\",\"Hz\") à #qty(\"20\",\"kHz\").",
)
#flashcard(
    recto: "Fréquences des ondes mécaniques",
    verso: "De quelques #unit(\"Hz\") pour les vibrations lentes à plusieurs #unit(\"kHz\").",
)
#flashcard(
    recto: "Fréquences des ondes électromagnétiques",
    verso: "De #qty(\"3\",\"kHz\") à #qty(\"300\",\"GHz\") pour les ondes radio, de #qty(\"430\",\"THz\") à #qty(\"770\",\"THz\") pour le visible, au delà pour les ultraviolets, les rayons X puis les rayons gamma.",
)
#flashcard(
    recto: "Exemples de situation de propagation dispersive",
    verso: "Fibre optique multimode, lumière blanche dans un prisme, onde de tension dans une ligne ADSL.",
)
#flashcard(
    recto: "Exemples de situation de propagation non-dispersive",
    verso: "Lumière et autres ondes EM dans l'espace, ondes sonores dans l'air dans les conditions usuelles.",
)

= Interférences

#flashcard(
    recto: "Conditions d'interférences",
    verso: "- Constructives si $Delta phi = 2 k pi$
    - Destructives si $Delta phi = pi + 2 k pi$",
)

= Ondes stationnaires

#flashcard(
    recto: "Définition d'une onde stationnaire",
    verso: "Onde pour laquelle il existe des points où l'amplitude est toujours nulle (nœuds) et des points où l'amplitude est maximale (ventres).",
)
#flashcard(
    recto: "Distance entre deux nœuds consécutifs",
    verso: "$lambda/2$",
)
#flashcard(
    recto: "Distance entre deux ventres consécutifs",
    verso: "$lambda/2$",
)
#flashcard(
    recto: "Modes propres d'une corde fixée à ses deux extrémités",
    verso: "$f_n = n c/(2L)$",
)

#question-de-colle(
    "Expliquer par un schéma le concept d'onde stationnaire, définir nœud et ventre. Pour une corde fixée à ses deux extrémités, dessiner les trois premiers modes et établir l'expression des fréquences propres.",
)
