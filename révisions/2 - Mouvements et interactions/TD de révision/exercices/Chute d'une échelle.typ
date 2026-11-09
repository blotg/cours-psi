#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Chute d'une échelle",
    ouvert: true,
)

// |T|/N le long de la chute, θ angle à la verticale. Il vaut au plus 0,37
// (vers 35°) tant que θ < arccos(2/3), puis croît jusqu'à l'infini quand N
// s'annule, en θ = arccos(1/3) : au-delà de f = 0,37, le glissement a lieu
// entre ces deux angles, où on le cherche par dichotomie.
#let rapport(θ) = 3 * calc.sin(θ) * calc.abs(3 * calc.cos(θ) - 2) / calc.pow(3 * calc.cos(θ) - 1, 2)
#let angle-de-glissement(f) = {
    let (bas, haut) = (calc.acos(2 / 3), calc.acos(1 / 3))
    for _ in range(40) {
        let milieu = (bas + haut) / 2
        if rapport(milieu) < f { bas = milieu } else { haut = milieu }
    }
    bas.deg()
}

Une échelle droite, dressée presque verticalement sur un sol en béton sec, sans rien contre quoi s'appuyer, se met à basculer. Ses patins en caoutchouc retiennent d'abord son pied, qui finit pourtant par glisser.

Données : moment d'inertie d'une tige homogène de masse $m$ et de longueur $L$ par rapport à un axe perpendiculaire passant par une de ses extrémités, $J = 1 / 3 m L^2$ ; coefficient de frottement statique du caoutchouc sur le béton sec, $f$ compris entre #num("0.6") et #num("0.8").

#question(
    coups-de-pouce: (
        "Tant que le pied ne glisse pas, l'échelle est un solide en rotation autour d'un axe fixe passant par son pied.",
        "Le théorème de l'énergie cinétique, ou celui du moment cinétique, donne la vitesse angulaire et l'accélération angulaire en fonction de l'inclinaison.",
        "Le centre de masse décrit un cercle autour du pied : exprimer son accélération dans la base polaire.",
        "La seconde loi de Newton appliquée à l'échelle donne les composantes tangentielle $T$ et normale $N$ de la réaction du sol.",
        "Le pied glisse dès que $abs(T) = f N$. Attention : $T$ change de signe au cours de la chute.",
        "L'équation obtenue se résout numériquement.",
    ),
)[
    Quelle est l'inclinaison de l'échelle quand son pied commence à glisser ?
][
    On assimile l'échelle à une tige homogène de masse $m$, de longueur $L$, de centre de masse $G$, inclinée d'un angle $theta$ sur la verticale ; elle part de $theta approx 0$ sans vitesse. Tant que son pied $O$ ne glisse pas, elle tourne autour de l'axe horizontal passant par $O$, où le sol exerce la réaction $va(R) = T ex + N ey$ ($ex$ horizontal dans le sens de la chute, $ey$ vertical ascendant).

    *Mouvement.* La réaction ne travaille pas, son point d'application étant fixe. Le théorème de l'énergie cinétique donne $1 / 2 J dot(theta)^2 = m g L / 2 (1 - cos theta)$, soit $dot(theta)^2 = (3 g) / L (1 - cos theta)$. En dérivant, ou par le théorème du moment cinétique en $O$, $dot.double(theta) = (3 g) / (2 L) sin theta$.

    *Réaction du sol.* $G$ décrit un cercle de rayon $L \/ 2$ autour de $O$ : $va(a)(G) = -L / 2 dot(theta)^2 er + L / 2 dot.double(theta) etheta$, avec $er = sin theta ex + cos theta ey$ et $etheta = cos theta ex - sin theta ey$. La seconde loi de Newton, $m va(a)(G) = m va(g) + va(R)$, projetée sur $ex$ et $ey$, donne
    $ T = m L / 2 (dot.double(theta) cos theta - dot(theta)^2 sin theta) = (3 m g) / 4 sin theta (3 cos theta - 2) quad "et" quad N = m g - m L / 2 (dot.double(theta) sin theta + dot(theta)^2 cos theta) = (m g) / 4 (3 cos theta - 1)^2 $

    #grid(
        columns: (1fr, auto),
        column-gutter: 1em,
        align: horizon,
        [
            *Glissement.* D'après les lois de Coulomb, le pied tient tant que $abs(T) < f N$, soit tant que $(3 sin theta abs(3 cos theta - 2)) / (3 cos theta - 1)^2 < f$, rapport qui ne dépend ni de $m$ ni de $L$. Jusqu'à $theta = arccos(2 \/ 3) = #quan[48 °]$, $T > 0$ : le pied tend à reculer, mais le rapport ne dépasse pas #num("0.37") (vers #quan[35 °]). Au-delà, $T < 0$ et $N$ s'annule en $theta = arccos(1 \/ 3) = #quan[71 °]$ : le rapport croît sans limite et le pied finit par glisser, *vers l'avant*. Numériquement, $theta = #qty(angle-de-glissement(0.6), "°", chiffres: 2, exponent: auto)$ pour $f = #num("0.6")$ et $theta = #qty(angle-de-glissement(0.8), "°", chiffres: 2, exponent: auto)$ pour $f = #num("0.8")$.

            Le pied glisse donc vers l'avant quand l'échelle fait #quan[52] à #quan[53 °] avec la verticale, presque indépendamment de $f$ : $N$ s'effondre trop vite pour que la valeur du frottement compte. Sur un sol glissant ($f < #num("0.37")$), il partirait au contraire en arrière, dès le début de la chute.
        ],
        canvas({
            import cetz.draw: *
            set-style(axes: (tick: (length: 0.08)))
            plot.plot(
                size: (4.6, 2.4),
                axis-style: "left",
                x-label: $theta$,
                y-label: $abs(T) \/ N$,
                x-min: 0,
                x-max: 70,
                x-tick-step: 10,
                x-format: x => [#x°],
                y-min: 0,
                y-max: 1,
                y-tick-step: 0.2,
                y-format: y => num(y),
                {
                    plot.add-hline(0.6, 0.8, style: (stroke: (paint: luma(55%), dash: "dashed", thickness: 0.5pt)))
                    plot.add(
                        domain: (0, 59),
                        samples: 300,
                        x => rapport(x * 1deg),
                        style: (stroke: 1pt + black),
                    )
                },
            )
        }),
    )
]
