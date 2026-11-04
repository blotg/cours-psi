#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Écran tactile : où est la seconde armature ?",
    difficulté: 2,
)

#let eps0 = 8.854e-12
// Doigt sur le verre : électrode de 5 mm × 5 mm, verre de 0,5 mm, ε_r = 7.
#let Cd = eps0 * 7 * 25e-6 / 0.5e-3
// Corps humain : valeur du Human Body Model (JS-001).
#let Cc = 100e-12
// Téléphone posé : sphère de rayon 7 cm.
#let Ct = 4 * calc.pi * eps0 * 0.07
// Gant de laine : 2 mm, ε_r = 1,5.
#let Cgant-doigt = eps0 * 1.5 * 25e-6 / 2e-3
#let Cgant-main = eps0 * 1.5 * 20e-4 / 2e-3
#let série(..c) = 1 / c.pos().map(x => 1 / x).sum()
// Deux chiffres significatifs sans puissance de dix (« 28 pF », pas « 2,8·10¹ pF »).
#let pF(x) = {
    let v = x * 1e12
    if v >= 10 { qty(int(calc.round(v)), "pF") } else { qty(calc.round(v, digits: if v >= 1 { 1 } else { 2 }), "pF") }
}

Dans l'écran d'un smartphone, un réseau d'électrodes transparentes est placé sous une plaque de verre. Un doigt posé sur le verre forme avec l'électrode située en dessous un condensateur plan de capacité $C_d approx #pF(Cd)$. L'électronique de l'écran détecte cette capacité en mesurant la charge qu'elle doit apporter à l'électrode pour porter celle-ci à une tension donnée *par rapport à la masse du téléphone*.

Un condensateur a pourtant deux armatures. L'électrode en est une, le doigt est l'autre ; mais le doigt n'est relié ni à la masse du téléphone, ni à la Terre. Cet exercice cherche par où le circuit se referme.

#question(coups-de-pouce: (
    "Effectuer une analyse des symétries et des invariances, puis appliquer le théorème de Gauss sur une sphère de rayon $r > R$.",
    "Le potentiel est pris nul à l'infini.",
    "On peut aussi partir du résultat de l'exercice « Condensateur sphérique » et faire tendre $R_2$ vers l'infini.",
))[
    Une sphère conductrice de rayon $R$, isolée dans le vide, porte la charge $Q$. Sa capacité est définie par $Q = C V$, où $V$ est son potentiel, pris nul à l'infini. Montrer que
    $ C = 4 pi epsilon_0 R $
][
    *Invariances et symétries.* La distribution est invariante par toute rotation autour du centre $O$, et tout plan contenant $O$ et $M$ est plan de symétrie : $va(E) = E(r) va(e_r)$.

    *Théorème de Gauss.* Pour $r > R$, la sphère de rayon $r$ contient toute la charge $Q$ : $E(r) times 4 pi r^2 = Q \/ epsilon_0$, soit
    $ va(E) = Q / (4 pi epsilon_0 r^2) va(e_r) $

    *Potentiel.* Avec $V(infinity) = 0$ :
    $ V(R) = integral_R^(infinity) E(r) dd(r) = Q / (4 pi epsilon_0 R) $
    d'où $C = Q \/ V(R) = 4 pi epsilon_0 R$.

    On retrouve la limite $R_2 -> infinity$ du condensateur sphérique, $C = 4 pi epsilon_0 R_1 R_2 \/ (R_2 - R_1) -> 4 pi epsilon_0 R_1$ : la seconde armature est « à l'infini ».
]

#let R-corps = calc.pow(3 * 0.070 / (4 * calc.pi), 1 / 3)
#let C-sphère = 4 * calc.pi * eps0 * R-corps

#question(coups-de-pouce: (
    "La masse volumique du corps humain est proche de celle de l'eau.",
    "Où se trouvent les conducteurs les plus proches du corps d'une personne debout ?",
))[
    Modéliser le corps d'une personne de #quan[70 kg] par une sphère conductrice de même volume et estimer sa capacité par rapport à la Terre. Les normes de protection des composants électroniques contre les décharges électrostatiques (norme JS-001, « Human Body Model ») représentent le corps humain par un condensateur de #quan[100 pF]. Commenter.
][
    Avec $rho approx #quan[1000 kg/m^3]$, le volume du corps est $cal(V) = #quan[0.070 m^3]$, d'où
    $ R = ((3 cal(V)) / (4 pi))^(1\/3) approx #qty(int(calc.round(R-corps * 100)), "cm") quad "et" quad C = 4 pi epsilon_0 R approx #pF(C-sphère) $

    Le modèle donne le bon ordre de grandeur (quelques dizaines de picofarads), mais sous-estime la valeur normée d'un facteur 3 à 4. La sphère est supposée isolée, avec sa seconde armature à l'infini. Une personne debout a les pieds à quelques millimètres du sol, à travers ses semelles : le sol joue le rôle d'une armature très proche, et une armature proche augmente la capacité (comme l'inverse de l'écart entre les armatures pour un condensateur plan). Les mesures donnent d'ailleurs 100 à #quan[200 pF] selon les chaussures et le sol. On retient $C_c approx #quan[100 pF]$.
]

#question(coups-de-pouce: (
    "Les armatures de $C_1$ et $C_2$ reliées entre elles, isolées du reste, forment un conducteur de charge totale nulle.",
    "Les tensions aux bornes de condensateurs en série s'additionnent.",
))[
    Deux condensateurs de capacités $C_1$ et $C_2$ sont placés en série. Montrer qu'ils sont équivalents à un condensateur unique de capacité $C$ telle que
    $ 1/C = 1/C_1 + 1/C_2 $
    Que vaut $C$ lorsque $C_2 gt.double C_1$ ?
][
    Si $C_1$ porte la charge $Q$ sur son armature extérieure, son autre armature porte $-Q$. L'armature de $C_2$ qui lui est reliée forme avec elle un conducteur isolé, de charge totale nulle : elle porte donc $+Q$, et l'autre armature de $C_2$ porte $-Q$. Les deux condensateurs ont la même charge et
    $ U = U_1 + U_2 = Q/C_1 + Q/C_2 = Q (1/C_1 + 1/C_2) $
    ce qui définit $1\/C = 1\/C_1 + 1\/C_2$.

    Si $C_2 gt.double C_1$, alors $1\/C_2 << 1\/C_1$ et $C approx C_1$ : c'est la plus petite capacité qui impose la capacité de l'ensemble.
]

#question(coups-de-pouce: (
    "Le chemin part de l'électrode et doit revenir à la masse du téléphone.",
    "Utiliser la question 3 avec $C_2 gt.double C_1$.",
))[
    On tient le téléphone dans une main et on touche l'écran avec un doigt de l'autre main. Décrire le chemin qui va de l'électrode à la masse du téléphone en passant par le corps. Dans ce cas, la main est en contact étroit avec le boitier, et on peut considérer que la capacité entre le corps et la masse du téléphone est très grande devant $C_d$. Quelle capacité l'électronique mesure-t-elle ?

    Est-il nécessaire d'être relié à la Terre pour utiliser un écran tactile ?
][
    Le chemin est : électrode → (verre) → doigt → corps → (main) → boitier, c'est-à-dire la masse du téléphone. Le corps est conducteur : c'est l'armature commune de deux condensateurs en série, $C_d$ entre l'électrode et le doigt, et un condensateur de très grande capacité entre la main et le boitier. D'après la question précédente, la capacité mesurée est $C approx C_d approx #pF(Cd)$.

    La Terre n'intervient pas : le corps sert seulement de conducteur intermédiaire qui ramène le circuit à la masse du téléphone. Même sans tenir le téléphone, il suffit que la capacité qui ramène le corps à la masse du téléphone soit grande devant $C_d$.
]

#let C-table = série(Cd, Cc, Ct)

#question(coups-de-pouce: (
    "Le chemin passe maintenant par la Terre : il comporte trois condensateurs en série.",
    "La relation de la question 3 se généralise à $n$ condensateurs en série.",
))[
    Le téléphone est maintenant posé sur une table en bois, sans chargeur branché, et on le touche d'un doigt, sans le tenir. Le chemin de retour passe par la Terre. On prend $C_c = #quan[100 pF]$ pour la capacité du corps par rapport à la Terre, et on modélise le téléphone par une sphère conductrice isolée de rayon #quan[7 cm]. Calculer la capacité mesurée et la comparer à celle de la question précédente.
][
    Le chemin est : électrode → doigt → corps → Terre → téléphone. Il comporte trois condensateurs en série : $C_d$, $C_c approx #quan[100 pF]$ entre le corps et la Terre et $C_t = 4 pi epsilon_0 times #quan[7 cm] approx #pF(Ct)$ entre la Terre et le téléphone. Alors
    $ 1/C = 1/C_d + 1/C_c + 1/C_t quad "soit" quad C approx #pF(C-table) $

    Le signal ne vaut plus que #qty(calc.round(100 * C-table / Cd), "%") de celui de la question précédente. La capacité du téléphone vers la Terre n'est pas grande devant $C_d$ : elle limite le signal. Les fabricants nomment cette situation _low ground mass_ et doivent la compenser par le réglage du seuil de détection ou par la géométrie des électrodes. Un téléphone posé sur une table est un peu moins sensible qu'un téléphone tenu en main.
]

#let C-doigt-ganté = série(Cd, Cgant-doigt)
#let C-saucisse = série(Cd, Cgant-main)

#question(coups-de-pouce: (
    "Un doigt ganté, c'est le condensateur du verre en série avec celui de la laine.",
    "Avec la saucisse, le gant est toujours là, mais entre quelles surfaces ?",
    "La surface de contact entre la main et la saucisse est grande devant celle de l'électrode.",
))[
    Le téléphone est tenu en main, comme à la question 4. Un gant de laine a une épaisseur $e = #quan[2 mm]$ et une permittivité relative $epsilon_r = #num[1.5]$ ; l'électrode a une surface $S = #quan[5 mm] times #quan[5 mm]$.

    + Estimer la capacité mesurée lorsqu'on touche l'écran avec un doigt ganté.
    + Pendant l'hiver 2010, très froid en Corée du Sud, des utilisateurs d'iPhone ont pris l'habitude de toucher leur écran avec une saucisse-snack en bâtonnet, tenue dans leur main gantée. Dans les supérettes, les ventes de ces saucisses ont augmenté de #quan[39 %] par rapport à l'année précédente. La saucisse, salée, est conductrice ; on estime à #quan[20 cm^2] la surface de contact entre la main gantée et la saucisse. Estimer la capacité mesurée et expliquer pourquoi la saucisse fonctionne alors que le doigt ganté ne fonctionne pas.
][
    + Le doigt ganté ajoute en série un condensateur de laine de même surface que l'électrode :
        $ C_"laine" = (epsilon_0 epsilon_r S)/e = #pF(Cgant-doigt) quad "et" quad C = (1/C_d + 1/C_"laine")^(-1) approx #pF(C-doigt-ganté) $
        C'est la plus petite capacité qui impose la capacité de l'ensemble : celle de la laine, dont l'épaisseur et la faible permittivité réduisent le signal d'un facteur #calc.round(Cd / C-doigt-ganté). Le contact n'est pas détecté.
    + La saucisse est un conducteur intermédiaire. Elle forme avec l'électrode, côté écran, le même condensateur $C_d$ qu'un doigt nu, et avec la main, à travers le gant, un condensateur de laine de grande surface :
        $ C_"main" = (epsilon_0 epsilon_r times #quan[20 cm^2])/e approx #pF(Cgant-main) quad "d’où" quad C approx #pF(C-saucisse) $
        Le gant est toujours dans le circuit, mais il sépare maintenant deux surfaces 80 fois plus grandes que l'électrode : sa capacité, environ quatre fois plus grande que $C_d$, ne limite presque plus le signal, qui retrouve #qty(calc.round(100 * C-saucisse / Cd), "%") de sa valeur avec un doigt nu.

        Les gants « tactiles » poussent l'idée plus loin : des fils conducteurs cousus au bout des doigts traversent la laine et relient la peau à l'écran, ce qui court-circuite le condensateur de laine.
]
