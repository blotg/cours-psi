#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Lubrification",
)

Le but de cet exercice est de comprendre l'intérêt de la lubrification. On considère un mobile parallélépipédique de masse $M=qty("30", "kg")$ en translation sur un support horizontal.

#figure(
    canvas({
        import cetz.draw: *
        line((0, 0), (4, 0))
        line((0, 0), (4.5, 0), mark: (end: ">>", fill: black))
        content((), $ex$, anchor: "west", padding: .4em)
        line((0, 0), (0, 2), mark: (end: ">>", fill: black))
        content((), $ey$, anchor: "south", padding: .4em)
        rect((1, 0), (3, 1))
        line((2.5, .5), (rel: (1, 0)), mark: (end: ">>", fill: black))
        content((), $va(v_m)$, anchor: "south", padding: .4em)
    }),
    caption: "Mobile en frottement solide avec son support.",
)

Dans un premier temps, on étudie le contact sec entre le pavé et la surface. La force de frottement est de type frottement solide. Il obéit à la loi de Coulomb : $R_T=f R_N$ avec un coefficient $f=num("0.20")$. En $x=0$, $v=v_0=qty("10", "km/h")$.

#question(
    coups-de-pouce: (
        "Calculer la composante normale de la réaction puis utiliser la loi de Coulomb.",
        "Projeter le théorème de la résultante cinétique sur l'axe verticale pour relier la réaction normale au poids.",
    ),
)[
    Calculer la valeur numérique de la réaction tangentielle.
][
    #let g = 9.81
    #let M = 30
    #let f = 0.2
    #let RT = f * M * g
    La projection du théorème de la résultante cinétique sur $ey$ donne $R_N - M g = 0$, soit $R_N = M g$. On en déduit
    $ R_T=f R_N = f M g = #qty(scientifique(RT, 2), "N") $
]

#question(
    coups-de-pouce: (
        "Résoudre la projection sur l'axe horizontal du théorème de la résultante cinétique.",
        "Quel est le temps d'arrêt, c'est-à-dire le temps auquel la vitesse est nulle.",
        "La distance d'arrêt correspond à la position du solide au temps d'arrêt.",
    ),
)[
    Calculer la distance d'arrêt du mobile et faire l'application numérique.
][
    La projection du théorème de la résultante cinétique selon $ex$ donne
    $ M dv(v, t) = -R_T = - f M g $
    La vitesse s'écrit donc
    $ v(t) = v_0 - f g t $
    soit $t = (v_0 - v)/(f g)$. Le temps d'arrêt est le temps auquel la vitesse est nul, c'est donc
    $ t_"arrêt" = v_0 / (f g) $
    La distance parcourue est
    $ x(t) = v_0 t - 1/2 f g t^2 $
    La distance d'arrêt est donc
    #let v0 = 10 * 1000 / 3600
    #let f = 0.2
    #let g = 9.81
    #let d-arrêt = calc.pow(v0, 2) / (2 * f * g)
    $
        d_"arrêt" = x(t_"arrêt") = v_0 v_0/(f g) - 1/2 f g (v_0/(f g))^2 = v_0^2/(2 f g) = #qty(scientifique(d-arrêt, 2), "m")
    $
]

#figure(
    canvas({
        import cetz.draw: *
        rect((0, 0), (4, .5), fill: black.lighten(70%), stroke: none)
        line((0, 0), (4.5, 0), mark: (end: ">>", fill: black))
        content((), $ex$, anchor: "west", padding: .4em)
        line((0, 0), (0, 2), mark: (end: ">>", fill: black))
        content((), $ey$, anchor: "south", padding: .4em)
        rect((1, .5), (3, 1.5))
        line((2.5, 1), (rel: (1, 0)), mark: (end: ">>", fill: black))
        content((), $va(v_m)$, anchor: "south", padding: .4em)
    }),
    caption: "Mobile sur une couche de fluide.",
)

On introduit maintenant une couche d'huile d'épaisseur $e=#qty("1.0", "mm")$ entre la mobile et la surface. On suppose que le régime est permanent (un opérateur maintient la vitesse du palet constante) et que la vitesse du fluide s'écrit $va(v)=v(x,y) ex$. On néglige les effets de bords. La surface du mobile en contact avec l'huile est $S=qty("400", "cm^2")$. Le mobile a une vitesse $v_m=v_0=qty("10", "km/h")$.

La densité de l'huile est #num("0.9") et sa viscosité cinématique est $qty("60e-6", "m^2/s")$.
#let viscosité = 60e-6 * 0.9e3

#question[
    Calculer la viscosité dynamique de l'huile.
][
    La masse volumique de l'huile est $mu = #num("0.9") mu_"eau"$
    La viscosité dynamique de l'huile est $eta= mu nu = #qty(scientifique(viscosité,1), "Pa s")$.
]

#question(
    coups-de-pouce: (
        "Utiliser un argument d'invariance.",
        "Que signifie l'expression de l'énoncé \"on néglige les effets de bord\" ?",
    ),
)[
    Montrer que $v(x,y)$ est indépendant de $x$.
][
    On néglige les effets de bord, c'est-à-dire qu'on suppose la situation invariante par translation selon $x$. Ainsi, $v(x,y)=v(y)$.
]


#question(
    coups-de-pouce: (
        "Utiliser la condition d'adhérence en $z=0$ et $z=e$.",
    ),
)[
    On admet que la vitesse s'écrit $v(y)=a y+b$. Déterminer $a$ et $b$ en exploitant la description du problème.
][
    La condition d'adhérence en $y=0$ impose $v(0)=0$ donc $b=0$. La condition d'adhérence en $y=e$ impose $v(e)=v_m$ donc $a=v_m/e$. On en déduit
    $ v(y) = v_m/e y $
]

#question[
    Donner l'expression de la force surfacique de cisaillement au sein de l'eau.
][
    La force surfacique de cisaillement est donnée par
    $ (delta^2 F)/dd(S) = eta dv(v, y) = eta v_m/e $
]

#question(
    coups-de-pouce: (
        "La force exercée sur le pavé et l'opposé de la force exercée par le pavé sur la couche supérieure de fluide.",
    ),
)[
    Exprimer la force de frottement à laquelle est soumis la pavé.
][
    La force de frottement est
    #let vm = 10 * 1000 / 3600
    #let e = 1.0e-3
    #let S = 400 * 1.0e-4
    #let FT = viscosité * vm / e * S
    $
        F_T = - (delta^2 F)/dd(S) * S = - eta v_m / e S = #qty(scientifique(FT, 2), "N")
    $
]

#question(
    coups-de-pouce: (
        "Résoudre la projection sur l'axe horizontal du théorème de la résultante cinétique.",
        "La distance d'arrêt peut être définie comme la valeur maximale atteinte par la position.",
    ),
)[
    On admet qu'en l'absence d'action de l'opérateur pour maintenir la vitesse constante, l'expression de la vitesse établie précédemment reste valable, mais avec $a$ fonction du temps. Que devient la distance d'arrêt du palet ?
][
    La projection du théorème de la résultante cinétique selon $ex$ donne
    $ M dv(v_m, t) = F_T = - eta v_m / e S $
    soit
    $ dv(v_m, t) + (eta S)/(M e) v_m = 0 $
    La vitesse s'écrit donc
    $ v_m (t) = v_0 exp(-(eta S)/(M e) t) $
    La distance parcourue est obtenue en primitivant la vitesse :
    $ x(t) = (M e)/(eta S) v_0 (1 - exp(-(eta S)/(M e) t)) $
    La distance d'arrêt est donc
    #let M = 30
    #let e = 1.0e-3
    #let viscosité = 60e-3
    #let S = 400e-4
    #let v0 = 10 * 1000 / 3600
    #let d-arrêt = (M * e) / (viscosité * S) * v0
    $ d_"arrêt" = lim_(t-> infinity) x(t) = (M e)/(eta S) v_0 = #qty(scientifique(d-arrêt,1),"m") $
]
