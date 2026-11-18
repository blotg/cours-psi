#import "@local/prepa:0.1.1": *

#show: exercice.with(titre: "Couple de mutuelle et règle du flux maximal")

Une spire rectangulaire de centre $O$, de section $S$, parcourue par un courant d'intensité $I$ et qui peut tourner librement autour de l'axe $(O z)$ est représentée ci-contre. La position angulaire de la spire est repérée par l'angle $theta$ entre $va(e_x)$ et $va(n)$, vecteur normal à la spire, orienté conjointement à $I$.

#figure(
    canvas({
        import cetz.draw: *
        // projection oblique : x vers la droite, z vers le haut, y vers l'arrière gauche
        let p((x, y, z)) = (x - 0.6 * y, z + 0.5 * y)
        let th = 30deg
        let (w, h) = (1.6, 1.6)
        let u = (-calc.sin(th), calc.cos(th))
        let coin(a, b) = p((a * w * u.at(0), a * w * u.at(1), b * h))
        line((-2.6, 0), (2.8, 0), mark: (end: ">>", fill: black), name: "x")
        content("x.end", $x$, anchor: "north-east", padding: 3pt)
        line((0, -2.4), (0, 2.6), mark: (end: ">>", fill: black), name: "z")
        content("z.end", $z$, anchor: "south-west", padding: 3pt)
        line(coin(1, 1), coin(-1, 1), coin(-1, -1), coin(1, -1), close: true, stroke: 0.9pt)
        line(coin(0.6, 1), coin(-0.4, 1), mark: (end: ">>", fill: black), stroke: 0.9pt)
        content(coin(-0.2, 1), $I$, anchor: "south-west", padding: 3pt)
        let n = p((1.9 * calc.cos(th), 1.9 * calc.sin(th), 0))
        line((0, 0), n, mark: (end: ">>", fill: black), stroke: 0.9pt, name: "n")
        content("n.end", $va(n)$, anchor: "south", padding: 4pt)
        let ang = calc.atan2(n.at(0), n.at(1))
        arc((1.3, 0), radius: 1.3, start: 0deg, stop: ang, mark: (end: ">>", fill: black), name: "theta")
        content((ang / 2, 1.55), $theta$)
        content((0, 0), $O$, anchor: "north-east", padding: 3pt)
    }),
)

Cette spire est située à l'intérieur d'un solénoïde de grande dimension, comportant $n$ spires par unité de longueur parcourues par un courant d'intensité $I'$, non représenté sur la figure, dont l'axe de symétrie de révolution est confondu avec l'axe $(O x)$.

#question(
    coups-de-pouce: (
        "Donner le champ magnétique créé par le solénoïde. Déterminer le flux de ce champ sur le cadre.",
        "Quelle est la direction du champ créé par le solénoïde ? Quelle est celle de la surface élémentaire du cadre ?",
        "Quelle relation relie le flux mutuel et l'inductance mutuelle ?",
    ),
)[
    Déterminer l'inductance mutuelle $M$ entre les deux circuits.
][
    Le champ magnétique créé par le solénoïde est uniforme à l'intérieur de celui-ci et vaut $va(B')= mu_0 n I' va(e_x)$.

    Le flux de ce champ à travers la spire est donc $Phi= va(B') dot va(S)= mu_0 n I' S cos(theta)$.

    Par définition de l'inductance mutuelle, on a $Phi= M I'$, d'où
    $ M= mu_0 n S cos(theta) $
]

#question(
    coups-de-pouce: (),
)[
    On note $L$ et $L'$, les inductances propres respectives de la spire et du solénoïde. Donner l'énergie électromagnétique $cal(E)_"ém"$ stockée dans ces deux circuits.
][
    L'énergie électromagnétique stockée dans un système de deux circuits inducteurs est donnée par la relation $cal(E)_"ém"= 1/2 L I^2 + 1/2 L' I'^2 + M I I'$.

    En remplaçant $M$ par sa valeur, on obtient
    $ cal(E)_"ém"= 1/2 L I^2 + 1/2 L' I'^2 + mu_0 n S cos(theta) I I' $
]

#question(
    coups-de-pouce: (),
)[
    Le solénoïde étant fixe, calculer le couple électromagnétique $Gamma= lr(pdv(cal(E)_"ém", theta)\))_(I,I')$ que subit la spire.
][
    Le couple électromagnétique s'obtient en dérivant l'énergie électromagnétique par rapport à l'angle $theta$ :
    $ Gamma= lr(pdv(cal(E)_"ém", theta)\))_(I,I')= - mu_0 n S I I' sin(theta) $
]

#question(
    coups-de-pouce: (
        "Vers quelle position d'équilibre le couple électromagnétique ramène-t-il le cadre ? Pour quelle position du cadre le flux est-il maximal ?",
    ),
)[
    La règle du flux maximal stipule que les actions électromagnétiques agissent sur un circuit mobile de telle sorte qu'il soit traversé par un flux maximal. Vérifier que le système formé par la spire et le solénoïde suit bien cette règle.
][
    Le couple électromagnétique $Gamma$ est nul pour $theta= 0 [pi]$, c'est-à-dire lorsque le vecteur normal à la spire est colinéaire au champ magnétique créé par le solénoïde. Pour $I I' > 0$, si $theta$ est légèrement positif, $Gamma < 0$ ramène la spire vers $theta = 0$ : cette position est stable. Autour de $theta = pi$, au contraire, le couple éloigne la spire de sa position : cet équilibre est instable.

    Or, dans la position stable $theta = 0$, le flux $Phi= mu_0 n I' S cos(theta)$ est maximal. Le système formé par la spire et le solénoïde suit donc bien la règle du flux maximal.
]
