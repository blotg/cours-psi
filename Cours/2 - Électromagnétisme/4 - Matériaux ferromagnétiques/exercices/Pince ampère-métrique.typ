#import "@local/prepa:0.1.1": *

#exercice(
    titre: "Pince ampère-métrique",
)[

    Une pince ampère-métrique sert à mesurer l'intensité d'un courant sans ouvrir le circuit. Elle est schématiquement constituée d'un tore ferromagnétique à base carrée, de coté $a$, milieu doux, non saturé, linéaire de perméabilité $mu$, sur lequel sont entourées $N$ spire jointives. La figure montre une coupe transversale du dispositif.

    Les spires sont électriquement branchées aux bornes d'une résistance $R$, de valeur très supérieure à celle du bobinage. On note $u(t)$ la tension aux bornes de $R$ et $i(t)$ le courant circulant dans le bobinage et $R$. Le tore est centré sur le fil infiniment long dont on mesure l'intensité $I(t)$.

    #figure[
        #canvas({
            import cetz.draw: *
            set-style(stroke: (thickness: 0.5pt))
            set-style(content: (padding: .1))
            ortho(x: 25deg, y: 0deg, z: 0deg, {
                on-xz(y: 0, {
                    line((0, 0, -2.5), (0, 0, 1.5), name: "I", mark: (start: ">>", fill: black))
                    line((0, 0, -2), (0, 0, -3))
                    content("I.start", $I(t)$, anchor: "west")
                    arc((2, 0), start: 0deg, delta: 180deg, radius: 2)
                    arc((2, 0), start: 0deg, delta: -180deg, radius: 2, stroke: (dash: "dashed"))
                    circle((0, 0), radius: 1, stroke: (dash: "dashed"))
                })
                on-xz(y: 1, {
                    circle((0, 0), radius: 1)
                    circle((0, 0), radius: 2)
                    line((0, 0), (-180deg, 1), name: "b", mark: (symbol: ">>", fill: black))
                    content("b", $b$, anchor: "north")
                })
                line((1, 1, 0), (2, 1, 0), (2, 0, 0), stroke: (thickness: 1pt))
                line(
                    (1, 1, 0),
                    (1.65, 1, 0),
                    stroke: (thickness: 1pt),
                    mark: (end: ">>", stroke: (dash: none), fill: black),
                )
                content((), $i(t)$, anchor: "north")
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

    #question(coups-de-pouce: (
        "Effectuer les 4 étapes : analyse de invariances, des symétries, choix de la courbe d'Ampère et théorème d'Ampère (dans un milieu magnétique).",
        "Sur quelle surface doit-on intégrer B ? Cette surface est-elle dans le tore ou en dehors ?",
        "Quelle relation existe-t-il entre $B$ et $H$ dans un matériau doux ?",
        "La surface d'une spire est orientée selon $va(e)_theta$.",
    ))[
        Déterminer le champ $va(H)_I$ créé dans tout l'espace par $I(t)$. En déduire le flux magnétique $phi_I$ reçu par le bobinage.
    ][
        *Invariances*
        Le système est invariant par translation le long de l'axe du fil ($z$), et par rotation autour de cet axe ($theta$) donc, d'après le principe de Curie, $va(H)(r, cancel(theta), cancel(z))$

        *Symétries*
        Soit $M$ un point. Le plan $(M, va(e_r), va(e_z))$ est un plan de symétrie donc $va(H) = H va(e_theta)$

        *Choix de la courbe d'Ampère*
        On choisit une courbe circulaire de rayon $r$ centré sur l'axe du fil.

        *Théorème d'Ampère*
        On applique le théorème d'Ampère sur cette courbe :
        $integral.cont va(H) dot va(dd(l)) = integral.cont H va(e_theta) dot r dd(theta) va(e_theta) = 2 pi r H = I_"enlacé" = I(t)$ d'où $ va(H) = I(t)/(2 pi r) va(e_theta) $

        Dans le tore (matériaux doux hors saturation), on a $va(B) = mu_0 mu va(H)$ donc $ va(B)_I = (mu I(t))/(2 pi r) va(e_theta) $

        On peut alors exprimer le flux sur une spire du bobinage :
        $
            Phi_(1 "spire") = integral.double va(B)_I dot va(dd(S)) = integral_(z=0)^a dd(z) integral_(r=b)^(b+a) dd(r) (mu I(t))/(2 pi r) va(e_theta) dot va(e_theta) = (mu I(t) a)/(2 pi) ln(1+a/b)
        $

        $ Phi_I = N Phi_(1 "spire") = N (mu I(t) a)/(2 pi) ln(1+a/b) $
    ]

    #question(coups-de-pouce: (
        "La méthode est très similaire à la question précédente.",
    ))[
        Déterminer le flux $Phi_i$ créé par $i(t)$ et reçu par le bobinage.
    ][
        *Analyse des invariances*
        Le système est invariant par rotation selon $theta$ donc, d'après le principe de Curie, $va(H)(r, cancel(theta), z)$

        *Analyse des symétries*
        Soit $M$ un point. Le plan $(M, va(e_r), va(e_z))$ est un plan de symétrie donc $va(H) = H va(e_theta)$

        *Choix de la courbe d'Ampère*
        On choisit une courbe circulaire de rayon $r$ centré sur l'axe du tore.

        *Théorème d'Ampère*
        On applique le théorème d'Ampère sur cette courbe :
        $integral.cont va(H) dot va(dd(l)) = integral.cont H va(e_theta) dot dd(l) va(e_theta) = 2 pi r H = I_"enlacé"$. Le courant enlacé est nul pour une courbe d'ampère en dehors du tore. A l'intérieur, il vaut  $I_"enlacé" = i(t) N$ d'où l'excitation à l'intérieur du tore : $ va(H) = (i(t) N)/(2 pi r) va(e_theta) $

        Dans le tore (matériaux doux hors saturation), on a $va(B) = mu_0 mu va(H)$ donc $ va(B)_i = (mu N i(t))/(2 pi r) va(e_theta) $

        On peut alors exprimer le flux sur une spire du bobinage :
        $
            Phi_(1 "spire") = integral.double va(B)_i dot va(dd(S)) = integral_(z=0)^a dd(z) integral_(r=b)^(b+a) dd(r) (mu N i(t))/(2 pi r) va(e_theta) dot va(e_theta) = (mu N i(t) a)/(2 pi) ln(1+a/b)
        $

        $ Phi_i = N Phi_(1 "spire") = N (mu N i(t) a)/(2 pi) ln(1+a/b) = (mu N^2 a)/(2 pi) ln(1+a/b) i(t) $
    ]

    #question(coups-de-pouce: (
        "Utiliser la loi de Faraday.",
        "Représenter le schéma électrique équivalent.",
    ))[
        Établir une équation différentielle liant $u(t)$ et $I(t)$
    ][
        Le flux magnétique sur le tore est $Phi = Phi_i+Phi_I$. On peut représenter le schéma électrique équivalent suivant :
        #figure[

            #zap.circuit({
                import zap: *

                vsource("V", (0, 0), (0, 2), u: $-dv(Phi, t)$)
                resistor("R", (2, 0), (2, 2), label: $R$)
                fil((0, 2), (2, 2), i: $i$)
                wire((0, 0), (2, 0))
            })
        ]
        On peut en déduire que $u(t) = R i(t)$ et que $u(t) = -d(Phi,t) = -d(Phi_i+Phi_I,t)$ d'où l'équation différentielle :
        $ u(t) = - (mu N^2 a)/(2 pi R) ln(1+a/b) dv(u(t), t) - (mu N a)/(2 pi) ln(1+a/b) dv(I(t), t) $
    ]

    #question(coups-de-pouce: (
        "Passer l'équation différentielle en complexes.",
        "$u$ est proportionnel à $I$ si la fonction de transfert est indépendante de $p$.",
    ))[
        Quelle est la fonction de transfert $H(p)=(U(p))/(I(p))$ ? En déduire comment choisir les paramètres constitutifs de la pince afin que $u$ soit directement proportionnel à $I$.
    ][
        En passant en domaine de Laplace, on obtient :
        $ U(p) = - (mu N^2 a)/(2 pi R) ln(1+a/b) p U(p) - (mu N a)/(2 pi) ln(1+a/b) p I(p) $
        D'où la fonction de transfert :
        $ H(p) = (U(p))/(I(p)) = ((a N)/(2 pi) ln(1+a/b)p)/(1+(a N^2 mu)/(2 pi R) ln(1+a/b)p ) $

        Pour que $u$ soit proportionnel à $I$, il faut que la fonction de transfert soit indépendante de $p$, i.e. que $1 << (a N^2 mu)/(2 pi R) ln(1+a/b)p$ soit $a N^2 mu ln(1+b/a) omega >> 2 pi R$.
    ]

]
