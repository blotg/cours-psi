#import "@local/prepa:0.1.1": *

#show: cours.with(infos: yaml("infos.yml"))

#let grandeurs = (
    "pdv(,t)": (signification: "le terme local"),
    "va(v) dot grad": (signification: "le terme convectif"),
    "v": (signification: "le champ de vitesse du fluide", unité: unit("m/s")),
    "mu": (signification: "la masse volumique", unité: unit("kg/m^3")),
    "va(j_m)": (signification: "le vecteur densité de courant de masse", unité: unit("kg/m^2/s")),
    "va(j_V)": (signification: "le vecteur densité de courant de volume", unité: unit("m/s")),
    "D_m": (signification: "le débit massique", unité: unit("kg/s")),
    "D_V": (signification: "le débit volumique", unité: unit("m^3/s")),
    "delta^2 F_P": (signification: "la force de pression s'exerçant sur une surface élémentaire", unité: unit("N")),
    "delta^3 F_P": (signification: "la force de pression s'exerçant sur un volume élémentaire", unité: unit("N")),
    "P": (signification: "la pression", unité: unit("Pa")),
    "g": (signification: "l'accélération de la pesanteur", unité: unit("m/s^2")),
    "delta^2 F_v": (signification: "la force de viscosité s'exerçant sur une surface élémentaire", unité: unit("N")),
    "eta": (signification: "la viscosité dynamique", unité: $unit("Pl") = unit("Pa s")$),
    "delta^3 F_v": (signification: "la résultante de viscosité s'exerçant sur un volume élémentaire", unité: unit("N")),
    "U": (signification: "la vitesse débitante", unité: unit("m/s")),
    "S": (signification: "la section de la conduite", unité: unit("m^2")),
    "va(j_(p,\"diff\"))": (
        signification: "le vecteur densité de courant de quantité de mouvement diffusée",
        unité: unit("kg m/s /m^2/s"),
    ),
    "nu": (signification: "$=eta/mu$ la viscosité cinématique", unité: unit("m^2/s")),
    "tau_\"diff\"": (signification: "la durée caractéristique associée à la diffusion", unité: unit("s")),
    "L": (signification: "une longueur caractéristique du problème", unité: unit("m")),
    "va(j_(p,\"conv\"))": (
        signification: "le vecteur densité de courant de quantité de mouvement convectée",
        unité: unit("kg m/s^2/m^2/s"),
    ),
    "tau_\"conv\"": (signification: "la durée caractéristique associée à la convection", unité: unit("s")),
    "R_e": (signification: "le nombre de Reynolds", unité: "sans unité"),
    "scr(V)": (signification: "un ordre de grandeur de la vitesse de l'écoulement", unité: unit("m/s")),
    "R": (signification: "le rayon de la conduite", unité: unit("m")),
    "l": (signification: "la longueur de la conduite", unité: unit("m")),
    "Delta P": (signification: "la différence de pression entre les extrémités de la conduite", unité: unit("Pa")),
    "R_H": (signification: "la résistance hydraulique", unité: unit("Pa s/m^3")),
    "F_x": (signification: "la force de traînée", unité: unit("N")),
    "S_x": (signification: "le maître-couple selon $x$", unité: unit("m^2")),
    "C_x": (signification: "le coefficient de traînée", unité: "sans unité"),
    "alpha": (signification: "le coefficient de frottement", unité: unit("N s /m")),
    "beta": (signification: "le coefficient de frottement", unité: unit("N s^2/m^2")),
    "F_z": (signification: "la force de portance", unité: unit("N")),
    "C_z": (signification: "le coefficient de portance", unité: "sans unité"),
    "S_z": (signification: "le maitre couple selon $z$", unité: unit("m^2")),
    "v_x": (signification: "la vitesse du mobile par rapport au fluide", unité: unit("m/s")),
)

= Description de l'écoulement d'un fluide
Un fluide est un milieu matériel parfaitement déformable. Les liquides et les gaz sont des fluides.

== Notion de particule de fluide
À l'échelle microscopique, les particules qui composent un fluide sont animés de mouvements erratiques#footnote[Erratique signifie aléatoire, qui vont dans tous les sens.].

Il y a deux façons de définir un système mésoscopique :

- On peut définir un volume mésoscopique immobile, comme on l'a fait dans le chapitre diffusion de particules. Un tel volume peut contenir un nombre de particules variable au cours du temps.
- On peut définir un volume mésoscopique qui contient toujours le même nombre de particules (en moyenne) et qui se déplace avec le fluide#footnote[Plus précisément, dont la vitesse est la vitesse moyenne des particules qui la composent.]. Ce système est appelé *particule de fluide*. Une particule de fluide est un système fermé.

La masse d'une particule de fluide est donc constante.

== Description eulérienne et champ de vitesse
La description eulérienne consiste à décrire le champ de vitesse, c'est-à-dire la vitesse du fluide à chaque endroit de l'espace : $va(v)(M,t)$

La vitesse en un même point et à des instants différents $va(v)(M,t_1)$ et $va(v)(M,t_2)$ est la vitesse de particules de fluide différentes.

== Tube de courant
Une ligne de courant est une courbe en tout point tangente au vecteur vitesse $va(v)(M,t)$ et orientée dans le même sens.
#schéma(titre: "Ligne de courant", hauteur: 3cm)

En régime stationnaire, les lignes de courant sont immobiles. En régime stationnaire, les lignes de courant sont les trajectoires des particules de fluide.

Attention : de manière générale, les lignes de courant ne sont pas forcément les trajectoires des particules de fluide.

== Dérivée particulaire

#encadré(
    titre: "Dérivée particulaire",
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("pdv(,t)", "va(v) dot grad", "v")),
)[
    $ partdv(f) = pdv(f, t)+ (va(v) dot grad) f $
]

#question-de-colle(
    "Dans le cas unidimensionnel, déterminer la dérivée particulaire d'une fonction scalaire. Généraliser à 3D.",
)

#flashcard(
    recto: "Dérivée particulaire",
    verso: "$partdv(f) = pdv(f,t) + (va(v) dot grad) f$",
)

== Débit massique
#encadré(
    titre: "Masses volumiques à connaitre",
    connaitre: true,
    hypothèses: "Dans les conditions normales de température et de pression",
    grandeurs: sub-dictionary(grandeurs, ("mu",)),
)[
    - $mu_"eau"=qty("1e3", "kg/m^3")$
    - $mu_"air"=qty("1", "kg/m^3")$
]

#flashcard(
    recto: "Masse volumique de l'eau et de l'air",
    verso: "$ mu_\"eau\" = qty(\"1e3\", \"kg/m^3\") $ $mu_\"air\"=qty(\"1\", \"kg/m^3\")$",
)

#encadré(
    titre: "Vecteur densité de courant de masse",
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("va(j_m)", "v", "mu")),
)[
    $ va(j_m) = mu va(v) $
]

#encadré(
    titre: "Débit massique",
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("D_m", "mu", "v")),
)[
    $ D_m = integral.double_S mu va(v) dot va(dd(S)) $
]

#flashcard(
    recto: "Débit massique",
    verso: "$ D_m= integral.double_S mu va(v) dot va(dd(S))$",
)

#application[
    Le débit maximal de l'Odet a été mesuré le 13 décembre 2000. La vitesse (supposée uniforme) valait #qty("4", "m/s"). Sa largeur est de #qty("10", "m") et sa profondeur #qty("4", "m"). Déterminer le débit massique.
]

== Débit volumique
#encadré(
    titre: "Vecteur densité de courant de volume",
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("va(j_V)", "v")),
)[
    $ va(j_V) = va(v) $
]

#encadré(
    titre: "Débit volumique",
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("D_V", "v")),
)[
    $ D_V = integral.double_S va(v) dot va(dd(S)) $
]

#flashcard(
    recto: "Débit volumique",
    verso: "$ D_V = integral.double_S va(v) dot va(dd(S))$",
)

#application[
    Le débit maximal de l'Odet a été mesuré le 13 décembre 2000. La vitesse (supposée uniforme) valait #qty("4", "m/s"). Sa largeur est de #qty("10", "m") et sa profondeur #qty("4", "m"). Déterminer le débit volumique.
]

== Conservation de la masse
La masse est une grandeur physique conservative.

#encadré(
    titre: "Équation locale de conservation de la masse",
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("mu",)),
)[
    $ pdv(mu, t) = - div (mu va(v)) $
]

#question-de-colle("Établir l'équation locale de conservation de la masse.")

#flashcard(
    recto: "Équation locale de conservation de la masse",
    verso: "$ pdv(mu, t) = - div (mu va(v)) $",
)

#encadré(
    titre: "Conservation du débit massique",
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("D_m", "mu", "v")),
    hypothèses: "Le régime est stationnaire",
)[
    Le débit massique est le même sur chaque section d'un tube de courant.
]

== Écoulement incompressible et homogène
Le volume n'est pas nécessairement une grandeur conservative.

#exemple[
    Si on compresse une seringue contenant un gaz, son volume diminue.
]

Dans un écoulement incompressible, le volume des particules de fluides ne change pas au cours du temps.

Dans un écoulement homogène, toutes les particules de fluide ont la même masse volumique.

Dans un écoulement incompressible et homogène, la masse volumique $mu$ est uniforme#footnote[Uniforme signifie qui ne dépend pas de la position : c'est le même partout.] et stationnaire#footnote[Stationnaire signifie qui ne dépend pas du temps : c'est le même tout le temps.].

#encadré(
    titre: "Conservation du volume",
    connaitre: true,
    hypothèses: ("L'écoulement est incompressible", "L'écoulement est homogène"),
)[
    Le volume se conserve.
]

#flashcard(
    recto: "Condition à laquelle le volume se conserve",
    verso: "Régime stationnaire, écoulement incompressible et homogène.",
)

#encadré(
    titre: "Conservation du débit volumique",
    connaitre: true,
    savoir-faire: true,
    hypothèses: ("L'écoulement est incompressible", "L'écoulement est homogène"),
)[
    Le débit volumique est le même sur chaque section d'un tube de courant.
]

= Actions de contact sur un fluide
== Action normale et tangentielle
Les forces de contact s'exerçant sur la surface d'une particule de fluide sont proportionnelles à sa surface. Elles peuvent se décompose en
- une composante orthogonale à la surface (normale) appelée force de pression
- une composante tangentielle à la surface appelée force de viscosité

== Forces de pression
#encadré(
    titre: "Forces de pression",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("delta^2 F_P", "P")),
)[
    $ va(delta^2 F_P) = P va(dd(S)) $
]

#encadré(
    titre: "Résultante volumique des forces de pression",
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("delta^3 F_P", "P")),
)[
    $ va(delta^3 F_P) = - grad P dd(V) $
]

#flashcard(
    recto: "Résultante volumique des forces de pression",
    verso: "$ va(delta^3 F_P) = - grad P dd(V) $",
)
#question-de-colle(
    "Exprimer la résultante volumique des forces de pression dans le cas unidimensionnel. Généraliser à 3D.",
)

#encadré(
    titre: "Relation fondamentale de l'hydrostatique",
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("P", "mu", "g")),
    hypothèses: (
        "Le fluide est au repos.",
        "Les seules forces sont les forces de pression et le poids.",
    ),
)[
    $ grad P = mu va(g) $
]

#flashcard(
    recto: "Relation fondamentale de l'hydrostatique",
    verso: "$grad P = mu va(g)$",
)

#question-de-colle(
    "Établir l'équation fondamentale de l'hydrostatique. Établir le champ de pression dans un fluide homogène et incompressible au repos.",
)
#question-de-colle(
    "Établir l'équation fondamentale de l'hydrostatique. Établir le champ de pression dans l'atmosphère en la supposant isotherme etn assimilant l'air à un gaz parfait.",
)

#application[
    Déterminer le champ de pression dans l'océan en le supposant homogène, incompressible et au repos.
]

#application[
    Déterminer le champ de pression dans l'atmosphère la supposant immobile et isotherme et en assimilant l'air à un gaz parfait.
]

== Forces tangentielles
La force tangentielle est due à la viscosité du fluide.

#schéma(titre: "Forces de viscosité sur une surface élémentaire", hauteur: 3cm)

#encadré(
    titre: "Forces de viscosité",
    hypothèses: (
        "Le fluide est newtonien.",
        [Le champ de vitesse est $va(v)=v(y) ex$.],
        [La surface sur laquelle s'exerce la force est orientée selon $va(e_y)$.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("delta^2 F_v", "eta", "v")),
)[
    $ va(delta^2 F_v) = eta pdv(v, y) dd(S) ex $
]

#flashcard(
    recto: "Forces de viscosité sur une surface infinitésimale",
    verso: "$ va(delta^2 F_v) = eta pdv(v, y) dd(S) ex $",
)

Cette formule doit être adaptée en fonction des axes du problème.

#application[
    Vérifier l'homogénéité de cette relation.
]

#encadré(
    titre: "Viscosité de l'eau",
    connaitre: true,
    hypothèses: [À #qty("20", "Celsius")],
    grandeurs: sub-dictionary(grandeurs, ("eta",)),
)[
    $ eta_"eau" = qty("1e-3", "Pl") $
]

#flashcard(
    recto: "Viscosité dynamique de l'eau",
    verso: "$ eta_\"eau\" = qty(\"1e-3\", \"Pl\") $",
)

#encadré(
    titre: "Résultante volumique des forces de viscosité",
    connaitre: true,
    savoir-faire: true,
    hypothèses: "Le fluide est newtonien.",
    grandeurs: sub-dictionary(grandeurs, ("delta^3 F_v", "eta", "v")),
)[

    $ va(delta^3 F_v) = eta va(Delta) va(v) dd(V) $
]

Comme la force ne peut pas diverger, le champ de vitesse est dérivable donc continu.

En particulier, la vitesse d'un fluide au voisinage immédiat d'un solide est la vitesse du solide. Cette condition est appelée condition d'adhérence fluide-solide.

#application[
    Appliquer la loi de la quantité de mouvement sur une particule de fluide soumise aux forces de pression, de viscosité (fluide newtonien) et au poids. Cette équation (simplifiée par $dd(V)$) est appelée équation de Navier-Stockes.
]

#application[
    Écoulement de Couette-plan : un fluide est en écoulement stationnaire entre deux plaques parallèles, l'une immobile (en $z=0$) et l'autre animée d'une vitesse $va(V)=V ex$ (en $z=a$). On néglige les effets de la gravité et on suppose la pression uniforme. Déterminer le champ de vitesse dans le fluide. On supposera que la vitesse ne dépend que de $z$ et qu'elle est selon $x$ : $va(v)=v(z) ex$.
]

= Écoulement interne incompressible et homogène dans une conduite cylindrique

On s'intéresse à un écoulement à l'intérieur d'une conduite cylindrique.
#exemple[
    Eau dans le réseau d'eau potable.
]

== Vitesse débitante
La vitesse débitante est la vitesse qu'aurait le fluide si le champ de vitesse était uniforme tout en conservant le même débit volumique.

#encadré(
    titre: "Vitesse débitante",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("U", "D_V", "S")),
)[
    $ U = D_V / S $
]
#flashcard(
    recto: "Vitesse débitante",
    verso: "$ U = D_V / S $",
)

La vitesse débitante peut être vue comme la moyenne de la vitesse sur une section de la conduite : $ U=(integral.double_S va(v) dot va(dd(S))) / S $

== Régimes d'écoulement
#lien("https://youtu.be/eD7LdS6bfOQ")

Reynolds a mis en évidence expérimentalement deux régimes d'écoulement.

#schéma(titre: "Expérience de Reynolds", hauteur: 4cm)

En fonction du débit, on peut observer

/ le régiment laminaire: dans lequel les lignes de courant sont stationnaires, pour des vitesses débitantes faibles
/ le régime turbulent: dans lequel les lignes de courant se déforment, pour des vitesses débitantes importantes.

Les deux régimes d'écoulement diffèrent par le mode de transport de quantité de mouvement prépondérant.

== Transport de quantité de mouvement par diffusion
Dans le régime laminaire, la quantité de mouvement est essentiellement transportée par diffusion.

#encadré(
    titre: "Vecteur densité de courant de quantité de mouvement diffusé",
    savoir-faire: true,
    hypothèses: "Le fluide est newtonien.",
    grandeurs: sub-dictionary(grandeurs, ("va(j_(p,\"diff\"))", "nu", "mu", "v")),
)[
    $ va(j_(p,"diff")) = - nu grad (mu v) $
]

#encadré(
    titre: "Temps caractéristique de diffusion de quantité de mouvement",
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("tau_\"diff\"", "L", "nu")),
)[
    $ tau_"dif" tilde L^2 / nu $
]

== Transport de quantité de mouvement par convection
Dans le régime turbulent, la quantité de mouvement est essentiellement transportée par convection.

#encadré(
    titre: "Vecteur densité de courant de quantité de mouvement",
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("va(j_(p,\"conv\"))", "mu", "v")),
)[
    $ va(j_(p,"conv")) = mu v va(v) $
]

#encadré(
    titre: "Temps caractéristique de convection de quantité de mouvement",
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("tau_\"conv\"", "L", "scr(V)")),
)[
    $ tau_"conv" tilde L / scr(V) $
]

== Nombre de Reynolds
Le nombre de Reynolds est une grandeur adimensionnée qui sert à comparer l'importance relative du transport de quantité de mouvement par convection et par diffusion.

#encadré(
    titre: "Nombre de Reynolds",
    connaitre: true,
    hypothèses: [le fluide est newtonien],
    grandeurs: sub-dictionary(grandeurs, ("R_e", "L", "scr(V)", "nu")),
)[
    $ R_e = (scr(V) L)/nu $
]

Dans le cas d'un écoulement interne, $L$ désigne le *diamètre* de la conduite.
#flashcard(
    recto: "Nombre de Reynolds",
    verso: "$ R_e= (scr(V) L)/nu $",
)

Dans le cadre d'un écoulement interne à une conduite cylindrique, la longueur caractéristique $d$ est le diamètre de la conduite et l'ordre de grandeur de la vitesse est la vitesse débitante.

#application[
    De l'eau à #qty("20", "Celsius") circule dans une conduite de diamètre #qty("5", "cm") et de longueur #qty("30", "m") à la vitesse débitante de #qty("0.1", "m/s"). Calculer le nombre de Reynolds.
]

#encadré(
    titre: "Diffusion vs convection",
    savoir-faire: true,
    hypothèses: [le fluide est newtonien],
    grandeurs: sub-dictionary(grandeurs, ("R_e", "tau_\"diff\"", "tau_\"conv\"")),
)[
    $ R_e tilde tau_"diff" / tau_"conv"  tilde norm(va(j_(p,"conv"))) / norm(va(j_(p,"conv"))) $
]

Expérimentalement, on peut établir le seuil de passage d'un régime laminaire à un régime turbulent.

#encadré(
    titre: "Seuil de turbulence",
    connaitre: true,
    hypothèses: (
        "Le fluide est newtonien",
        "L'écoulement est interne à une conduite",
    ),
    grandeurs: sub-dictionary(grandeurs, ("R_e",)),
)[
    - Si $R_e < 2000$ l'écoulement est laminaire
    - Si $R_e > 2000$ l'écoulement est turbulent
]

#flashcard(
    recto: "Seuil de turbulence pour un écoulement interne",
    verso: "Si $R_e<2000$ l'écoulement est laminaire.\nSi $R_e>2000$ l'écoulement est turbulent",
)

#application[
    De l'eau à #qty("20", "Celsius") circule dans une conduite de diamètre #qty("5", "cm") et de longueur #qty("30", "m") à la vitesse débitante de #qty("0.1", "m/s"). L'écoulement est-il laminaire ou turbulent ?
]

== Chute de pression dans une conduite horizontale à faible nombre de Reynolds

Dans un écoulement interne laminaire, la chute de pression entre les deux extrémités d'une conduite cylindrique est donnée par la loi de Hagen–Poiseuille.

#encadré(
    titre: "Loi de Hagen–Poiseuille",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "Le fluide est newtonien.",
        "La conduite est horizontale.",
        "L'effet de la gravité est négligé.",
        "L'écoulement est laminaire.",
        "Le régime est stationnaire.",
        [Le champ de pression ne dépend que de $x$.],
        "Les effets de bord sont négligés.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("D_V", "R", "eta", "l", "Delta P")),
)[
    $ D_V = (pi R^4)/(8 eta l) Delta P $
]
#flashcard(
    recto: "Loi de Hagen–Poiseuille",
    verso: "$ D_V = (pi R^4)/(8 eta l) Delta P $",
)
#question-de-colle("Établir la loi de Hagen–Poiseuille.")

Par analogie avec l'électrocinétique, on peut définir la résistance hydraulique.

#encadré(
    titre: "Résistance hydraulique",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "Le fluide est newtonien.",
        "La conduite est horizontale.",
        "L'effet de la gravité est négligé.",
        "L'écoulement est laminaire.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("Delta P", "R_H", "D_V", "eta", "l", "R", "Delta P")),
)[
    $ Delta P = R_H D_V $
    avec
    $ R_H = (8 eta l)/(pi R^4) $
]

#application[
    De l'eau à #qty("20", "Celsius") circule dans une conduite de diamètre #qty("5", "cm") et de longueur #qty("30", "m") à la vitesse débitante de #qty("0.01", "m/s"). Quelle est la chute de pression entre les deux extrémités de la conduite ?
]

== Chute de pression pour un écoulement quelconque
Lorsque l'écoulement n'est pas laminaire, la loi de Hagen-Poiseuille n'est plus vraie. Il est alors nécessaire de s'en remettre aux données expérimentales qui sont résumées sur un diagramme appelé diagramme de Moody.

#figure(image("images/Moody.png", width: 100%))

#application[
    De l'eau à #qty("20", "Celsius") circule dans une conduite en fonte de diamètre #qty("1.5", "cm") et de longueur #qty("3", "m") à la vitesse débitante de #qty("2", "m/s"). Quelle est la chute de pression entre les deux extrémités de la conduite ?
]

= Écoulement externe incompressible et homogène autour d’un obstacle
== Force et coefficient de trainée
Lorsqu'un objet est en mouvement rectiligne uniforme dans un fluide, il subit des forces de pression et de viscosité. La résultante de ces forces, exceptée la poussée d'Archimède, dans la direction du mouvement est appelée trainée.

Le maitre-couple (ou surface apparente) est la surface projetée dans une certaine direction.

#schéma(titre: "Maître couple", hauteur: 3cm)

#application[
    Calculer le maitre couple dans la direction du mouvement pour la voiture ci-dessous. On pourra approximer la voiture à un parallélépipède rectangle pour faire les calculs.

    #figure(image("images/voiture.jpg", width: 8cm))
]

#encadré(
    titre: "Force de traînée",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "Le fluide est newtonien.",
        "L'écoulement est stationnaire.",
        "L'objet est en mouvement rectiligne uniforme.",
    ),
    grandeurs: sub-dictionary(grandeurs, ("F_x", "mu", "v", "S_x", "C_x")),
)[
    $ va(F_x) = - 1/2 mu v^2 S_x C_x va(u) $
]

#flashcard(
    recto: "Force de traînée",
    verso: "$ va(F_x) = - 1/2 mu v^2 S_x C_x va(u) $",
)

Le coefficient de trainée dépend de la forme de l'objet et du nombre de Reynolds.

== Cas d'une sphère

#figure(image("images/Cx_sphere.png", width: 100%))

Le coefficient de trainée de la sphère est tracé en fonction du nombre de Reynolds dans la courbe en annexe. On peut y voir plusieurs parties.

=== Faible Reynolds
Pour $R_e<1$, le graphe s'approche d'une droite (en échelle logarithmique) d'équation $C_x=24/R_e$.

#encadré(
    titre: "Force de trainée linéaire",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [Le fluide est newtonien.],
        [$R_e<1$],
    ),
    grandeurs: sub-dictionary(grandeurs, ("F_x", "alpha", "v")),
)[
    $ va(F_x) = - alpha va(v) $
]
#flashcard(
    recto: "Plage de Reynolds pour une traînée linéaire",
    verso: "$ R_e < 1 $",
)

=== Haut Reynolds
Pour $R_e in [num("2000"), num("200000")]$, $C_x$ est constant.

#encadré(
    titre: "Force de trainée quadratique",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [Le fluide est newtonien],
        [$R_e in [num("2000"), num("200000")]$],
    ),
    grandeurs: sub-dictionary(grandeurs, ("F_x", "beta", "v")),
)[
    $ va(F_x) = - beta v^2 va(u) $
]
#flashcard(
    recto: "Plage de Reynolds pour une traînée quadratique",
    verso: "$R_e in [num(\"2000\"), num(\"200000\")]$",
)

== Forces de trainée et de portance sur une aile d'avion
Sur certains objets, la force de trainée s'accompagne d'une force de portance.

#encadré(
    titre: "Force de portance",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("F_z", "mu", "v", "S_z", "C_z")),
)[
    $ va(F_z) = 1/2 mu v^2 S_z C_z va(u) $
]
#exemple[
    Aile d'avion, voile de bateau.
]

La force de trainée est colinéaire à la vitesse de l'objet. La force de portance est orthogonale à la vitesse de l'objet.

#schéma(titre: "Traînée, portance et angle d'incidence", hauteur: 5cm)

La trainée et la portance dépendent de l'angle d'incidence. Les courbes ci-dessous présentent un exemple de dépendance pour une aile d'avion.

#figure(image("images/Cx_Cz.png", width: 10cm))

== Couche limite
Dans un écoulement à haut nombre de Reynolds, où le transport de quantité de mouvement se fait essentiellement par convection, la viscosité du fluide a une influence sur la force subie par un objet. Pour expliquer cet apparent paradoxe, on introduit la couche limite.

Dans un écoulement à haut nombre de Reynolds, il existe des zones où le transport de quantité de mouvement se fait essentiellement par diffusion. Ces zones sont appelées couches limites. Ces zones sont de faible épaisseur et situées à proximité immédiate des objets.

#schéma(titre: "Couche limite", hauteur: 4cm)
