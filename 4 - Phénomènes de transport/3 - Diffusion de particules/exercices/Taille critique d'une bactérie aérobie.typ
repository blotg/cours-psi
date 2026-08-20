#import "@local/prepa:0.1.0": *

#show: exercice.with(
    titre: "Taille critique d'une bactérie aérobie",
)

On étudie les conditions de survie d'une bactérie dans un lac de très grande taille à la température $T_0=#qty("297", "K")$. Pour vivre, elle a besoin de consommer le dioxygène dissous dans l'eau au voisinage de sa surface.

La bactérie est modélisée par une boule de centre $O$ fixe, de rayon $R$, de masse volumique $mu$ identique à celle de l'eau.

#add-unit("USI", "USI", "upright(\"U.S.I.\")")

On se place en régime stationnaire et on note $n(r)$ la densité particulaire, exprimée en #unit("/m^3"), de #ce("O2") dissous à la distance $r$ de $O$ ($r>R$). La diffusion de #ce("O2") obéit à la loi de Fick avec un coefficient de diffusion de $D=qty("2E-9", "USI")$. Loin de la bactérie, la concentration molaire volumique de #ce("O2") dissous dans le lac vaut $c_0=#qty("0.2", "mol/L")$.

La consommation en #ce("O2") de la bactérie est proportionnelle à sa masse. On introduit le taux horaire de consommation de #ce("O2") par unité de masse, noté $a$ et mesuré en #unit("mol/kg/s").

#question(
    coups-de-pouce: (),
)[
    Rappeler la loi de Fick reliant le vecteur densité de courant particulaire $va(j)=j(r) er$ à la densité particulaire $n(r)$.
][
    La loi de Fick s'écrit $va(j) = -D grad n$.
]

#question()[
    Quelle est l'unité de $D$.
][
    L'unité de $D$ est #unit("m^2/s").
]

#question(
    coups-de-pouce: (
        "Faire un bilan de particules sur un volume infinitésimal ou sur une boule creuse d'épaisseur infinitésimale.",
    ),
)[
    Établir l'équation de diffusion de particules en coordonnées sphériques.
]

#question(
    coups-de-pouce: (),
)[
    Exprimer $Phi$, le nombre de molécules de #ce("O2") qui traversent par unité de temps une sphère de rayon $r$ ($r>R$) en fonction de $j(r)$ et de $r$. Justifier que $Phi$ ne dépend pas du rayon $r$ de la sphère considérée.
][
    Le flux particulaire est $Phi = 4 pi r^2 j(r)$. En régime stationnaire et en l'absence de terme source, le vecteur densité de courant de particules est à flux conservatif, donc $Phi$ est le même sur toute sphère de rayon $r>R$
]

#question(
    coups-de-pouce: (
        "Insérer la loi de Fick dans l'équation obtenue à la question précédente.",
        "Déterminer les constantes en utilisant la densité particulaire à l'infini et le flux particulaire.",
    ),
)[
    Déterminer l'expression de la densité particulaire $n(r)$ en #ce("O2") dissous dans l'eau. On exprimera les deux constantes d'intégration en fonction de $D$, $Phi$, $Na$ et $c_0$. En déduire la densité particulaire $n_R$ en surface de la bactérie, en $r=R$.
][
    $
        Phi = 4 pi r^2 j(r) = -4 pi r^2 D dv(n, r)
    $
    Soit
    $
        dv(n, r) = -Phi / (4 pi D ) 1/r^2
    $
    En primitivant, on obtient
    $
        n(r) = Phi / (4 pi D ) 1/r + C
    $
    Avec la condition à l'infini $n(r -> +infinity) = c_0 Na$, on trouve $C = c_0 Na$.
    Donc
    $
        n(r) = Phi / (4 pi D ) 1/r + c_0 Na
    $
    En $r=R$, on a donc
    $
        n_R = n(R) = Phi / (4 pi D ) 1/R + c_0 Na
    $
]

#question(
    coups-de-pouce: (
        "La consommation de #ce(\"O2\") de la bactérie est le flux particulaire d'#ce(\"O2\") arrivant à la bactérie.",
    ),
)[
    En étudiant la consommation en #ce("O2") de la bactérie pendant une durée $dd(t)$, exprimer $Phi$ en fonction de $a$, $Na$, de la masse volumique $mu$ de la bactérie et de son rayon $R$.
][
    La masse de la bactérie est $m = 4/3 pi R^3 mu$. Le nombre de molécules de #ce("O2") consommées pendant une durée $dd(t)$ est donc $a m dd(t) Na = a 4/3 pi R^3 mu dd(t) Na$. En regime stationnaire, le dioxygène consommé par la bactérie est égal au dioxygène arrivant à elle. Donc le flux particulaire est
    $
        Phi = -4/3 a pi R^3 mu Na
    $
]

#question[
    En déduire l'expression de $n_R$. Comment varie $n_R$ en fonction de $R$.
][
    En remplaçant $Phi$ dans l'expression de $n_R$, on obtient
    $
        n_R = -4/3 a pi R^3 mu Na / (4 pi D ) 1/R + c_0 Na = (-a R^2 mu Na) / (3 D ) + c_0 Na
    $
    Donc $n_R$ décroît quand $R$ augmente.
]

#question(
    coups-de-pouce: (
        "La densité particulaire ne peut pas être négative.",
    ),
)[
    Quelle inégalité doit vérifier $n_R$ pour que la bactérie ne suffoque pas. En déduire l'expression du rayon critique $R_c$ d'une bactérie aérobie. Effectuer l'application pour $a=qty("1e-3", "mol/kg/s")$ et sachant que la bactérie une masse volumique comparable a celle de l'eau. Comparer ce résultat à la dimension caractéristique $R=1$ à $qty("10", "um")$ d'une bactérie réelle.
][
    Pour que la bactérie ne suffoque pas, il faut que $n_R > 0$. Donc
    $
        -a R^2 mu Na / (3 D ) + c_0 Na > 0
    $
    Soit
    $
        R^2 < 3 D c_0 / (a mu)
    $
    Donc le rayon critique est
    #let D = 2e-9
    #let c0 = 0.2 * 1e3
    #let a = 1e-3
    #let mv = 1e3
    #let Rc = calc.sqrt(3 * D * c0 / (a * mv))
    $
        R_c = sqrt(3 D c_0 / (a mu)) = #qty(scientifique(Rc, 2), "m")
    $
    Les bactéries réelles ont bien un rayon inférieur à ce rayon critique.
]
