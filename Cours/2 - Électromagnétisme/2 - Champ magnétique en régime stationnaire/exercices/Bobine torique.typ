#import "@local/prepa:0.1.1": *

#show: exercice.with(titre: "Bobine torique", difficulté: 1)

Une bobine est constituée d'un fil conducteur bobiné en spires jointives sur un tore circulaire à section carrée de côté $a$ et de rayon moyen $R$. On désigne par $N$ le nombre total de spires et par $I$ le courant qui les parcourt. On note $(O z)$ l'axe de symétrie du tore. On s'intéresse au champ magnétique à l'intérieur du tore et on repère un point $M(r, z)$ en coordonnées cylindriques.

#figure({
    grid(
        columns: 2,
        gutter: 5em,
        image("images/bobine torique.jpg", height: 4cm),
        canvas({
            import cetz.draw: *
            // vue en coupe dans un plan méridien : chaque carré est le contour d'une spire
            line((0, -1.5), (0, 1.5), stroke: (dash: "dashed"))
            content((0, 1.5), anchor: "south", padding: 0.2em, $z$)
            for s in (-1, 1) {
                rect((s * 1.6, -0.7), (s * 3.0, 0.7))
                // courant : montant sur la face intérieure, donc vers l'extérieur en haut
                // et vers l'axe en bas
                line((s * 2.1, 0.7), (s * 2.5, 0.7), mark: (end: "stealth", fill: olive), stroke: olive + 1pt)
                line((s * 2.5, -0.7), (s * 2.1, -0.7), mark: (end: "stealth", fill: olive), stroke: olive + 1pt)
            }
            content((2.3, 0.7), anchor: "south", padding: 0.35em, text(fill: olive)[$I$])
            content((3.0, 0), anchor: "west", padding: 0.2em, text(fill: gray)[$a$])
            line((0, -1.1), (2.3, -1.1), stroke: gray, mark: (end: "stealth", fill: gray))
            line((2.3, -0.7), (2.3, -1.1), stroke: (paint: gray, dash: "dotted"))
            content((1.15, -1.1), anchor: "north", padding: 0.2em, text(fill: gray)[$R$])
            // contour d'Ampère : cercle horizontal d'axe (Oz), vu en perspective,
            // parcouru selon e_theta (vers la droite sur sa moitié avant)
            circle((0, 0.2), radius: (2.0, 0.35), stroke: (paint: blue, dash: "dashed"))
            arc((0, -0.15), start: -90deg, stop: -55deg, radius: (2.0, 0.35), stroke: blue, mark: (
                end: "stealth",
                fill: blue,
            ))
            content((-1.0, 0.5), anchor: "south", padding: 0.2em, text(fill: blue)[$cal(C)$])
            circle((2.0, 0.2), radius: 0.04, fill: black)
            content((2.0, 0.2), anchor: "west", padding: 0.2em, $M$)
        }),
    )
})

#question(coups-de-pouce: (
    "Effectuer les quatre étapes : invariances, symétries, choix du contour d'Ampère, théorème d'Ampère.",
))[
    Montrer que le champ magnétique en un point $M(r, z)$ à l'intérieur du tore se met sous la forme $B = (mu_0 N I)/(2 pi r)$.
][
    #strong[Invariances.] La distribution de courant est (quasi) invariante par rotation d'angle $theta$ ($N >> 1$) : $va(B)$ ne dépend que de $r$ et $z$.

    #strong[Symétries.] Pour un point $M$, le plan $(M, va(e_r), va(e_z))$ est plan de symétrie de la distribution de courant : $va(B)(M)$ lui est orthogonal, donc $va(B) = B(r, z) va(e_theta)$.

    #strong[Contour d'Ampère.] On choisit le cercle $cal(C)$ d'axe $(O z)$, de rayon $r$, passant par $M$ et orienté selon $va(e_theta)$.

    #strong[Théorème d'Ampère.]
    $ integral.cont_(cal(C)) va(B) dot va(dd(l)) = 2 pi r B(r, z) = mu_0 I_"enlacé" $
    Le contour enlace les $N$ spires, chacune parcourue par $I$ : $I_"enlacé" = N I$ à l'intérieur du tore (et $0$ à l'extérieur). Donc $B$ ne dépend pas de $z$ et
    $ va(B) = (mu_0 N I)/(2 pi r) va(e_theta) $
]

#question(coups-de-pouce: (
    "Sur quelles variables intégrer, et entre quelles bornes ?",
    "Un élément de surface orienté selon $va(e_theta)$ s'écrit $dd(r) dd(z)$.",
))[
    Déterminer le flux $Phi$ du champ magnétique à travers la surface d'#emph[une] spire, dont la normale est orientée dans le sens du champ.
][
    Une spire est un carré de côté $a$ situé dans un plan méridien, entre $r = R - a/2$ et $r = R + a/2$ et entre deux cotes distantes de $a$. Sa normale est $va(e_theta)$, donc $va(dd(S)) = dd(r) dd(z) va(e_theta)$ :
    $
        Phi = integral.double va(B) dot va(dd(S))
        = integral_0^a dd(z) integral_(R - a/2)^(R + a/2) (mu_0 N I)/(2 pi r) dd(r)
        = (mu_0 N I a)/(2 pi) ln((R + a/2)/(R - a/2))
    $
]
