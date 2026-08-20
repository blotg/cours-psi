#import "@local/prepa:0.1.0": *

#show: exercice.with(
    titre: "Conduite plate",
)

On s'intéresse à une conduite plate d'épaisseur $e$, de largeur $l>>e$ et de longueur $L$ dans laquelle circule un fluide incompressible et homogène de viscosité dynamique $eta$ et de masse volumique $mu$.

Le champ de vitesse est noté $va(v) = v ey$

La conduite est délimitée par les plans d'équation $x=l/2$, $x=-l/2$, $z=e/2$ et $z=-e/2$.

Les effets de la gravité sont négligés et on suppose que le gradient de pression est uniforme et selon $ey$

#figure(
    canvas({
        import draw: *
        projection-cabinet()
        let e = .7
        let l = 3
        let L = 9
        let A = (l / 2, 0, -e / 2)
        let B = (l / 2, 0, e / 2)
        let C = (-l / 2, 0, e / 2)
        let D = (-l / 2, 0, -e / 2)
        let E = (l / 2, L, -e / 2)
        let F = (l / 2, L, e / 2)
        let G = (-l / 2, L, e / 2)
        let H = (-l / 2, L, -e / 2)

        line(A, E)
        line(B, F)
        line(C, G)
        line(D, H, stroke: (dash: "dashed"))
        line(A, B, C)
        line(C, D, A, stroke: (dash: "dashed"))
        line(E, F, G, H, E)

        line((0, L / 2, 0), (rel: (0, 1, 0)), mark: (end: ">>", fill: black))
        content((), $va(v)$, padding: .4em, anchor: "south")

        line((l / 2, 0, -e / 2 - 0.3), (rel: (0, L, 0)), mark: (symbol: ">>", fill: black), name: "L")
        content("L.mid", $L$, anchor: "north", padding: .4em)

        line((l / 2, -.3, -e / 2), (rel: (0, 0, e)), mark: (symbol: ">>", fill: black), name: "L")
        content("L.mid", $e$, anchor: "east", padding: .4em)

        line((l / 2, -.3, e / 2), (rel: (-l, 0, 0)), mark: (symbol: ">>", fill: black), name: "L")
        content("L.mid", $l$, anchor: "south-east", padding: .4em)

        line((0, L, 0), (rel: (4, 0, 0)), mark: (end: ">>", fill: black))
        content((), $x$, anchor: "north-east", padding: .2em)
        line((0, L, 0), (rel: (0, 4, 0)), mark: (end: ">>", fill: black))
        content((), $y$, anchor: "west", padding: .4em)
        line((0, L, 0), (rel: (0, 0, 4)), mark: (end: ">>", fill: black))
        content((), $z$, anchor: "south", padding: .4em)
    }),
)

#question(
    coups-de-pouce: (
        "Appliquer la loi de la quantité de mouvement à une particule de fluide.",
        "Comment s'exprime l'accélération d'une particule de fluide à partir du champ de vitesse ?",
    ),
)[
    Déterminer l'équation aux dérivées partielles vérifiée par le champ de vitesse dans la conduite.
][
    La loi de la quantité de mouvement appliquée à une particule de fluide s'écrit
    $
        mu dd(V) partdv(va(v)) = - grad P dd(V) + eta va(Delta) va(v) dd(V)
    $
    $
        mu pdv(va(v), t) + mu (va(v) dot grad) va(v) = -grad(P) + eta va(Delta) va(v)
    $
]

#question(
    coups-de-pouce: (
        "Écrire la condition d'adhérence sur les 4 parois de la conduite."
    ),
)[
    Quelles sont les conditions aux limites vérifiées par le champ de vitesse ?
][
    La condition d'adhérence sur les quatre parois d'équation $x=l/2$, $x=-l/2$, $z=e/2$ et $z=-e/2$ s'écrit
    $
        cases(
            forall y\,z\,t quad va(v)(x=-l/2,y,z,t) = va(0),
            forall y\,z\,t quad va(v)(x=l/2,y,z,t) = va(0),
            forall x\,y\,t quad va(v)(x,y,z=e/2,t) = va(0),
            forall x\,y\,t quad va(v)(x,y,z=-e/2,t) = va(0),
        )
    $
]

#question(
    coups-de-pouce: (
        "En négligeant les effets de bord, quelles sont les invariances du problème ?",
        "Utiliser le principe de Curie."
    ),
)[
    On suppose l'écoulement laminaire et en régime stationnaire. Les effets de bord sont négligés. Justifier que $va(v)=v(z)ey$
][
    En régime stationnaire, le champ de vitesse ne dépend pas du temps. De plus, les effets de bord sont négligés, la situation est donc invariante par translation selon $x$ et $y$. D'après le principe de Curie, il en va de même pour $va(v)$ : $va(v)(z)$.
]

#question(
    coups-de-pouce: (
        "Simplifier l'équation aux dérivées partielles vérifiée par le champ de vitesse en utilisant la question précédente.",
        "Primitiver deux fois $pdv(v,z)$. On introduira deux constantes.",
        "Pour déterminer les constantes, on utilise les conditions aux limites en $z= plus.minus e/2$."
    ),
)[
    Établir le profil de vitesse dans la conduite.
][
    La loi de la quantité de mouvement appliquée à un particule de fluide peut être simplifiée :
    $
        - pdv(P, y) + eta pdv(v, z, 2) = 0
    $
    soit
    $
        pdv(v, z) = 1/eta pdv(P, y) z + A
    $
    et finalement
    $
        v = 1/eta pdv(P, y) z^2/2 + A z + B
    $
    Pour trouver les constantes $A$ et $B$, on utilise les conditions aux limites
    $
        cases(
            0 & = v(z=e/2) & = 1/eta pdv(P, y) e^2/8 + A e/2 + B,
            0 & =v(z=-e/2) & = 1/eta pdv(P, y) e^2/8 - A e/2 + B
        )\
        cases(
            0 - 0 & = A e,
            0 + 0 & = 1/eta pdv(P, y) e^2/4 + 2B
        )
        cases(
            A & = 0,
            B & = -1/eta pdv(P, y) e^2/8
        )
    $
    Ainsi,
    $
        va(v) = 1/eta pdv(P, y) (z^2/2 - e^2/8) ey
    $
]

#question(
    coups-de-pouce: (
        "Quelle relation relie le champ de vitesse au débit volumique ?"
    ),
)[
    Exprimer le débit volumique dans la conduite en fonction de $l$, $e$, $eta$ et $pdv(P, y)$.
][
    $
        D_V & = integral_(z=-e/2)^(e/2) integral_(x=-l/2)^(l/2) va(v) dot dd(x) dd(z) ey \
            & = 1/eta pdv(P, y) l [z^3/6-e^2/8z]_(-e/2)^(e/2) \
            & = 1/eta pdv(P, y) l (e^3/48 - e^3/16 +e^3/48-e^3/16) \
            & = - pdv(P, y) (l e^3)/(12 eta)
    $
]

#question(
    coups-de-pouce: (
        "Relier la différence de pression entre les deux extrémités de la conduite à la dérivée de la pression (l'énoncé précise que le gradient de pression est uniforme)."
    ),
)[
    Calculer la résistance hydraulique de cette conduite plate pour $e=qty("1", "mm")$, $L = qty("2", "m")$ et $l = qty("2", "cm")$ et dans laquelle circule de l'eau à #qty("20", "Celsius").
][
    $
        R_h = (Delta P)/D_V
    $
    avec $Delta P = P(0) - P(L) = - L pdv(P, y)$
    #let L = 2
    #let l = 2e-2
    #let e = 1e-3
    #let visc = 1e-3
    #let Rh = 12 * L * visc / (l * calc.pow(e, 3))
    $
        R_h = (12 L eta)/(l e^3) = #qty(scientifique(Rh, 1), "Pa s/m^3")
    $
]

