#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Inductance propre d'un tore",
)

On considère un tore de rayon interne $R$, de section carrée de côté $a$, sur lequel on enroule un fil en formant $N$ spires carrées jointives.

#figure[
    #canvas({
        import cetz.draw: *
        set-style(stroke: (thickness: 0.5pt))
        set-style(content: (padding: .1))
        ortho(x: 25deg, y: 0deg, z: 0deg, {
            on-xz(y: 0, {
                line(
                    (0, 0, -2.5),
                    (0, 0, 1.5),
                    name: "z",
                    stroke: (dash: "dotted"),
                    mark: (start: ">>", stroke: (dash: none), fill: black),
                )
                content("z.start", $z$, anchor: "north")
                arc((2, 0), start: 0deg, delta: 180deg, radius: 2)
                arc((2, 0), start: 0deg, delta: -180deg, radius: 2, stroke: (dash: "dashed"))
                circle((0, 0), radius: 1, stroke: (dash: "dashed"))
            })
            on-xz(y: 1, {
                circle((0, 0), radius: 1)
                circle((0, 0), radius: 2)
                line((0, 0), (-180deg, 1), name: "R", mark: (symbol: ">>", fill: black))
                content("R", $R$, anchor: "north")
            })
            line((1, 1, 0), (2, 1, 0), (2, 0, 0), stroke: (thickness: 1pt))
            line(
                (1, 1, 0),
                (1.65, 1, 0),
                stroke: (thickness: 1pt),
                mark: (end: ">>", stroke: (dash: none), fill: black),
            )
            content((), $i$, anchor: "north-east")
            line((1, 1, 0), (1, 0, 0), (2, 0, 0), stroke: (thickness: 1pt, dash: "dashed"))
            line((-2, 1, 0), (-2, 0, 0))
            line((-1, 1, 0), (-1, 0, 0), stroke: (dash: "dashed"))
            line((-2.2, 1, 0), (-2.2, 1, 2), name: "a1", mark: (symbol: ">>", fill: black))
            content("a1", $a$, anchor: "east")
            line((-2, 1, 0), (-1, 1, 0), name: "a2", mark: (symbol: ">>", fill: black))
            content("a2", $a$, anchor: "north")
        })
    })
]

L'espace est repéré par le système de coordonnées cylindriques $(O, va(e_r), va(e_theta), va(e_z))$, l'origine étant prise sur l'axe du tore. Chaque spire carrée appartient à un plan passant par l'axe.

Le circuit ainsi constitué est parcouru par un courant d'intensité $i(t)$, orienté selon le sens indiqué sur la figure.

On se place dans le cadre de l'ARQS.

#question(
    coups-de-pouce: (
        "Effectuer les 4 étapes : analyse des invariances, des symétries, choix de la courbe d'Ampère et théorème d'Ampère.",
    ),
)[
    Calculer le champ magnétique créé par le courant d'intensité $i(t)$ dans tout l'espace.
][
    Démo faite dans le cours. $ va(B)=cases((mu_0 N i)/(2 pi r) va(e_theta) "à l'intérieur", va(0) "à l'extérieur") $
]

#question(coups-de-pouce: (
    "Quelle relation relie le flux propre et l'inductance propre ?",
))[
    En déduire l'expression de l'inductance propre $L$. Calculer numériquement $L$ pour $N=num("100")$ et $N=num("1000")$. On donne $a=#quan[1 cm]$ et $R=#quan[5 cm]$.
][
    $
        Phi_(1 "spire")=integral.double_S va(B).va(dd(S)) = integral_(r=R)^(R+a)dd(r) integral_(z=0)^a dd(z) B = (mu_0 N i a)/(2 pi) ln((R+a)/R)
    $
    $ Phi_"tot" = N Phi_(1 "spire") = (mu_0 N^2 i a)/(2 pi) ln((R+a)/R) $
    or $Phi_"tot" = L i$ d'où $ L = (mu_0 N^2 a)/(2 pi) ln((R+a)/R) $
    #let mu0 = 4 * calc.pi * 1e-7
    #let a = 1e-2
    #let R = 5e-2
    #let N = 100
    #let L = (mu0 * N * N * a) / (2 * calc.pi) * calc.ln((R + a) / R)
    Pour $N=100$, $L=#qty(L, "H", chiffres: 1)$,
    #let N = 1000
    #let L = (mu0 * N * N * a) / (2 * calc.pi) * calc.ln((R + a) / R)
    pour $N=1000$, $L=#qty(L, "H", chiffres: 1)$
]

#question(
    coups-de-pouce: (
        "Intégrer la densité d'énergie électromagnétique sur tout l'espace pour obtenir l'énergie totale stockée.",
        "Comment l'énergie stockée dans une bobine s'écrit-elle en fonction de l'inductance et du courant ?",
    ),
)[
    Déterminer la densité d'énergie électromagnétique puis l'énergie totale stockée dans tout l'espace. L'expression est-elle cohérente avec l'expression de l'énergie stockée dans une bobine ?
][
    Dans l'ARQS, l'énergie électrique est négligeable : la densité d'énergie électromagnétique se réduit à la densité d'énergie magnétique.
    $ w = B^2/(2 mu_0) = cases((mu_0 N^2 i^2)/(8 pi^2 r^2) "à l'intérieur", 0 "à l'extérieur") $
    On intègre sur le volume du tore avec $dd(V) = r dd(r) dd(theta) dd(z)$ :
    $
        cal(E) = integral.triple w dd(V) = integral_(r=R)^(R+a) integral_(theta=0)^(2 pi) integral_(z=0)^a (mu_0 N^2 i^2)/(8 pi^2 r^2) r dd(r) dd(theta) dd(z) = (mu_0 N^2 i^2 a)/(4 pi) ln((R+a)/R)
    $
    On reconnait $cal(E) = 1/2 L i^2$ avec l'inductance trouvée à la question précédente.
]
