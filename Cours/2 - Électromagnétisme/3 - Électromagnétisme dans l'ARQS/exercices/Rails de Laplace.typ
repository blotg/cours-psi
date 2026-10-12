#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Rails de Laplace alimentés par un générateur",
)

#let champ-vers-le-lecteur(position) = {
    import cetz.draw: *
    circle(position, radius: 0.12)
    circle(position, radius: 0.03, fill: black)
}

#figure[
    #circuit({
        import zap: *
        import cetz.draw: *
        set-style(content: (padding: .1))
        champ-vers-le-lecteur((3, 1.5))
        content((3, 1.5), $va(B)$, anchor: "south-west")
        vsource("E", (0, 3), (0, 0), u: $E$)
        switch("K", (0, 3), (1.5, 3), label: $K$)
        line((1.5, 3), (10, 3), stroke: 1pt)
        line((0, 0), (10, 0), stroke: 1pt)
        line((6, -0.3), (6, 3.3), stroke: 3pt)
        line((6, 1.5), (7.2, 1.5), mark: (end: ">>", fill: black), name: "v")
        content("v.end", $va(v)$, anchor: "west")
        line((0, -0.6), (6, -0.6), mark: (symbol: ">>", fill: black), name: "x")
        content("x.mid", $x$, anchor: "north")
        line((10.4, 0), (10.4, 3), mark: (symbol: ">>", fill: black), name: "a")
        content("a.mid", $a$, anchor: "west")
        set-origin((11.5, 0.3))
        line((0, 0), (0.8, 0), mark: (end: ">>", fill: black))
        content((), $va(e_x)$, anchor: "west")
        line((0, 0), (0, 0.8), mark: (end: ">>", fill: black))
        content((), $va(e_y)$, anchor: "south")
        champ-vers-le-lecteur((0, 0))
        content((0, 0), $va(e_z)$, anchor: "north-east")
    })
]

Deux rails conducteurs horizontaux, parallèles et distants de $a$, sont reliés à une extrémité par un générateur idéal de force électromotrice $E > 0$ constante et un interrupteur $K$. Une barre conductrice de masse $m$ est posée perpendiculairement aux rails, sur lesquels elle glisse sans frottement. On repère sa position par son abscisse $x(t)$ et on note $va(v) = v va(e_x)$ sa vitesse. L'ensemble est plongé dans un champ magnétique uniforme et stationnaire $va(B) = B va(e_z)$ vertical, avec $B > 0$ : la figure est une vue de dessus.

On note $R$ la résistance totale du circuit (générateur, rails et barre) et on néglige son inductance propre.

À l'instant $t = 0$, la barre est immobile et on ferme l'interrupteur.

#question(coups-de-pouce: (
    "Le courant sort du générateur par sa borne $+$, vers laquelle pointe la flèche de $E$.",
    "La force de Laplace élémentaire s'écrit $va(dd(F)) = i va(dd(l)) and va(B)$, où $va(dd(l))$ est orienté dans le sens du courant.",
))[
    Juste après la fermeture de l'interrupteur, la barre est encore immobile. Indiquer le sens du courant dans le circuit, puis la direction et le sens de la force de Laplace que subit la barre. Dans quel sens la barre se met-elle en mouvement ?
][
    Le courant sort du générateur par sa borne $+$ : il descend dans le générateur, parcourt le rail du bas vers la droite, remonte dans la barre selon $+va(e_y)$ et revient par le rail du haut.

    En sommant les forces de Laplace élémentaires le long de la barre, de longueur $a$, parcourue par le courant $i > 0$ :
    $ va(F) = i a va(e_y) and B va(e_z) = i a B va(e_x) $

    La barre se met en mouvement vers la droite, dans le sens des $x$ croissants.
]

#question(coups-de-pouce: (
    "Comment évolue la surface du circuit quand la barre avance ? Et le flux de $va(B)$ à travers le circuit ?",
    "Quelle est la cause de l'induction ? À quoi doivent s'opposer ses conséquences ?",
    "Que vaut la force de Laplace lorsque le courant s'annule ?",
))[
    Une fois la barre en mouvement, un phénomène d'induction apparait dans le circuit. Expliquer pourquoi. À l'aide de la loi de Lenz, prévoir si l'induction augmente ou diminue l'intensité du courant. En déduire l'allure de l'évolution de la vitesse de la barre. Peut-elle accélérer indéfiniment ?
][
    En avançant, la barre agrandit la surface du circuit : le flux du champ magnétique à travers le circuit augmente. Cette variation de flux induit une force électromotrice dans le circuit.

    D'après la loi de Lenz, les conséquences de l'induction s'opposent à la cause qui leur a donné naissance, ici le mouvement de la barre. Le courant induit doit donc créer sur la barre une force de Laplace qui la freine, dirigée selon $-va(e_x)$ : il circule dans la barre selon $-va(e_y)$, en sens inverse du courant imposé par le générateur. L'induction diminue l'intensité du courant.

    Plus la barre va vite, plus le courant est faible, et plus la force qui l'entraine est faible : sa vitesse augmente de moins en moins vite. Elle ne peut pas accélérer indéfiniment : la vitesse tend vers une vitesse limite, pour laquelle la force électromotrice induite compense exactement celle du générateur. Le courant, et donc la force de Laplace, s'annulent alors.
]

#question(coups-de-pouce: (
    "Appliquer la méthode « Représenter le circuit équivalent en présence d'un flux magnétique variable ».",
    "Orienter la surface par la règle de la main droite : selon $+va(e_z)$ ou $-va(e_z)$ ?",
    "La surface du circuit vaut $a x$.",
))[
    On oriente le circuit dans le sens du courant trouvé à la question 1. Exprimer le flux $Phi$ du champ magnétique à travers le circuit, puis la force électromotrice induite $e$. Représenter le circuit électrique équivalent et en déduire une relation entre $i$, $v$, $E$, $R$, $a$ et $B$.
][
    Le circuit est parcouru dans le sens trigonométrique en vue de dessus : d'après la règle de la main droite, la surface est orientée selon $+va(e_z)$. Le champ étant uniforme,
    $ Phi = B a x $
    La loi de Faraday donne
    $ e = - dv(Phi, t) = - a B v $

    #figure(
        circuit({
            import zap: *
            import cetz.draw: *
            vsource("E", (0, 3), (0, 0), u: $E$)
            fil((0, 0), (4, 0), i: $i$)
            vsource("e", (4, 0), (4, 3), u: $e$)
            resistor("R", (4, 3), (0, 3), label: $R$)
        }),
    )

    La loi des mailles s'écrit $E + e = R i$, soit
    $ R i = E - a B v $

    Pour $v > 0$, $e < 0$ : la force électromotrice induite s'oppose à celle du générateur, comme prévu à la question 2.
]

#question(coups-de-pouce: (
    "Faire le bilan des forces subies par la barre. Lesquelles ont une composante selon $va(e_x)$ ?",
))[
    Établir l'équation mécanique, qui relie $dv(v, t)$ à $i$.
][
    On étudie la barre dans le référentiel terrestre, supposé galiléen. Elle subit son poids et la réaction des rails, tous deux verticaux en l'absence de frottement, et la force de Laplace $va(F) = i a B va(e_x)$. Le principe fondamental de la dynamique projeté sur $va(e_x)$ donne
    $ m dv(v, t) = i a B $
]

#question(coups-de-pouce: (
    "Éliminer $i$ entre l'équation électrique et l'équation mécanique.",
    "Mettre l'équation sous la forme $dv(v, t) + v/tau = v_text(\"lim\")/tau$.",
))[
    En déduire l'équation différentielle vérifiée par $v(t)$. Faire apparaitre une durée caractéristique $tau$ et une vitesse limite $v_text("lim")$, puis exprimer $v(t)$ et $i(t)$. Tracer leur allure et comparer avec les prévisions de la question 2.
][
    On remplace $i = (E - a B v)/R$ dans l'équation mécanique :
    $ m dv(v, t) = (a B)/R (E - a B v) quad "soit" quad dv(v, t) + v/tau = v_text("lim")/tau $
    avec
    $ tau = (m R)/(a B)^2 quad "et" quad v_text("lim") = E/(a B) $

    Avec $v(0) = 0$ :
    $ v(t) = v_text("lim") (1 - exp(-t/tau)) quad "et" quad i(t) = (E - a B v)/R = E/R exp(-t/tau) $

    #let t-max = 5
    #figure(
        canvas({
            import cetz.draw: *
            plot.plot(
                size: (5, 2.5),
                x-label: $t$,
                y-label: $v$,
                x-tick-step: none,
                y-tick-step: none,
                x-ticks: ((1, $tau$),),
                y-ticks: ((1, $v_text("lim")$),),
                axis-style: "left",
                y-min: 0,
                y-max: 1.2,
                {
                    plot.add(domain: (0, t-max), samples: 100, t => 1 - calc.exp(-t), style: (stroke: blue + 1.5pt))
                    plot.add-hline(1, style: (stroke: (dash: "dashed")))
                    plot.add(((0, 0), (1, 1)), style: (stroke: (dash: "dotted")))
                },
            )
            set-origin((7, 0))
            plot.plot(
                size: (5, 2.5),
                x-label: $t$,
                y-label: $i$,
                x-tick-step: none,
                y-tick-step: none,
                x-ticks: ((1, $tau$),),
                y-ticks: ((1, $E/R$),),
                axis-style: "left",
                y-min: 0,
                y-max: 1.2,
                {
                    plot.add(domain: (0, t-max), samples: 100, t => calc.exp(-t), style: (stroke: red + 1.5pt))
                    plot.add(((0, 1), (1, 0)), style: (stroke: (dash: "dotted")))
                },
            )
        }),
    )

    Comme prévu, l'induction fait décroitre le courant, de $E\/R$ à la fermeture de l'interrupteur jusqu'à zéro, et la vitesse tend vers une vitesse limite. Celle-ci est atteinte quand la force électromotrice induite compense celle du générateur : $a B v_text("lim") = E$.
]

#question(coups-de-pouce: (
    "Multiplier l'équation électrique par $i$ et l'équation mécanique par $v$.",
    "L'énergie fournie par le générateur entre $t = 0$ et $t -> oo$ vaut $integral_0^oo E i dd(t)$.",
))[
    Effectuer un bilan de puissance. Quelle fraction de l'énergie fournie par le générateur est finalement convertie en énergie cinétique de la barre ?
][
    En multipliant l'équation électrique par $i$ et l'équation mécanique par $v$ :
    $ E i = R i^2 + a B v i quad "et" quad dv(, t)(1/2 m v^2) = a B i v $
    d'où
    $ E i = R i^2 + dv(, t)(1/2 m v^2) $
    La puissance fournie par le générateur se répartit entre l'effet Joule et l'énergie cinétique de la barre. La puissance de la force de Laplace, $a B i v$, est exactement l'opposé de la puissance $e i$ de la force électromotrice induite : la conversion électromécanique se fait sans perte.

    Entre $t = 0$ et $t -> oo$, le générateur fournit
    $ W = integral_0^oo E i dd(t) = E^2/R integral_0^oo exp(-t/tau) dd(t) = (E^2 tau)/R = (m E^2)/(a B)^2 = m v_text("lim")^2 $
    tandis que la barre acquiert l'énergie cinétique $1/2 m v_text("lim")^2$. La moitié seulement de l'énergie fournie est convertie en énergie cinétique : l'autre moitié est dissipée par effet Joule, quelle que soit la valeur de $R$.
]
