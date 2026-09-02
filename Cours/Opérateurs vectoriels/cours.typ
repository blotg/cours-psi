#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)

#let grandeurs = (
    "arrow(A)": (signification: $=A_x va(e_x) + A_y va(e_y) + A_z va(e_z)$, unité: none),
)

= Gradient
== Définition
Les opérateurs vectoriels ont une expression simple en fonction de $va(nabla)$.

#encadré(
    titre: "Notation nabla",
    connaitre: true,
)[
    $ va(nabla) = vec(pdv(, x), pdv(, y), pdv(, z)) $
]

#flashcard(
    recto: "Notation nabla",
    verso: "$ va(nabla) = vec( pdv(,x), pdv(,y), pdv(,z) ) $",
)

Le gradient est un opérateur s'applicant aux champs scalaires et renvoyant un vecteur.
#encadré(
    titre: "Gradient",
    connaitre: true,
    hypothèses: (
        [$f$ est une fonction de $RR^3$ dérivable.],
        [les variables de $f$ sont les coordonnées cartésiennes.],
    ),
)[
    $ grad f = va(nabla) f = vec(pdv(f, x), pdv(f, y), pdv(f, z)) $
]

#flashcard(
    recto: "Gradient",
    verso: "$ grad f = va(nabla) f = vec(pdv(f, x), pdv(f, y), pdv(f, z)) $",
)

#flashcard(
    recto: "À quoi s'applique le gradient ? Que renvoie-t-il ?",
    verso: "Le gradient s'applique aux champs scalaires et renvoie un champ vectoriel.",
)

#application[Exprimer le gradient du champ $1/sqrt(x^2+y^2+z^2)$.]

En coordonnées cylindriques ou sphériques, la première coordonnée (i.e. selon $va(e_r)$) de $grad f$ est la dérivée par rapport à $r$.

#application[
    Exprimer le gradient du champ $1/r$ en coordonnées sphériques. Est-ce cohérent avec l'application précédente ? On pourra utiliser l'expression de $va(O M)$ dans les bases cartésiennes et sphérique pour comparer les deux expressions.
]

= Divergence
== Définition
La divergence est un opérateur s'applicant aux champs vectoriels et renvoyant un scalaire.

#encadré(
    titre: "Divergence",
    connaitre: true,
    hypothèses: (
        [$va(A)$ est une fonction de $RR^3$ dérivable.],
        [les variables de $va(A)$ sont les coordonnées cartésiennes.],
    ),
    grandeurs: grandeurs,
)[
    $ div arrow(A) = va(nabla) dprod va(A) = pdv(A_x, x) + pdv(A_y, y) + pdv(A_z, z) $
]

#flashcard(
    recto: "Divergence",
    verso: "$ div va(A) = va(nabla) dprod va(A) = pdv(A_x, x) + pdv(A_y, y) + pdv(A_z, z) $",
)

#flashcard(
    recto: "À quoi s'applique la divergence ? Que renvoie-t-elle ?",
    verso: "La divergence s'applique aux champs vectoriels et renvoie un champ scalaire.",
)

#application[
    Exprimer la divergence du champ $x va(e_x)+ 1/x va(e_y) + 1/z va(e_z)$.
]

== Théorème d'Ostrogradski

Le théorème d'Ostrogradski est parfois appelé théorème de Green-Ostrogradski ou théorème de la divergence.
#encadré(
    titre: "Théorème d'Ostrogradski",
    connaitre: true,
    hypothèses: (
        [$va(A)$ est une fonction de $RR^3$ dérivable.],
        [$V$ est le volume délimité par la surface fermée, orientée vers l'extérieur, $S$.],
    ),
    grandeurs: grandeurs,
)[
    $ integral.triple_V div va(A) dd(V) = integral.surf_S va(A) dprod va(dd(S)) $
]

#flashcard(
    recto: "Théorème d'Ostrogradski",
    verso: "$ integral.triple_V div va(A) dd(V) = integral.surf_S va(A) dprod va(dd(S)) $",
)

#application[Parmi les surfaces suivantes, lesquelles sont fermées :
    #grid(
        columns: 6,
        column-gutter: 1fr,
        [une sphère], [un disque], [un cube], [une pyramide], [un trapèze], [une demi-sphère],
    )]

= Rotationnel
== Définition
Le rotationnel est un opérateur s'applicant aux champs vectoriels et renvoyant un vecteur.

#encadré(
    titre: "Rotationnel",
    connaitre: true,
    hypothèses: (
        [$va(A)$ est une fonction de $RR^3$ dérivable.],
        [les variables de $va(A)$ sont les coordonnées cartésiennes.],
    ),
    grandeurs: grandeurs,
)[
    $
        rot arrow(A) = va(nabla) and va(A) = vec(pdv(A_z, y)-pdv(A_y, z), pdv(A_x, z)-pdv(A_z, x), pdv(A_y, x)-pdv(A_x, y))
    $
]

#flashcard(
    recto: "Rotationnel",
    verso: "$
        rot va(A) = va(nabla) and va(A) = vec(pdv(A_z, y)-pdv(A_y, z), pdv(A_x, z)-pdv(A_z, x), pdv(A_y, x)-pdv(A_x, y))
    $",
)

#flashcard(
    recto: "À quoi s'applique le rotationnel ? Que renvoie-t-il ?",
    verso: "Le rotationnel s'applique aux champs vectoriels et renvoie un champ vectoriel.",
)

== Théorème de Stockes
#encadré(
    titre: "Théorème de Stockes",
    connaitre: true,
    hypothèses: (
        [$va(A)$ est une fonction de $RR^3$ dérivable.],
        [$S$ est une surface s'appuyant sur la courbe fermée $cal(C)$, orientée dans le sens positif par rapport à $cal(C)$.],
    ),
    grandeurs: grandeurs,
)[
    $ integral.surf_S rot va(A) dprod va(dd(S)) = integral.cont_C va(A) dprod va(dd(l)) $
]

#flashcard(
    recto: "Théorème de Stockes",
    verso: "$ integral.surf_S rot va(A) dprod va(dd(S)) = integral.cont_C va(A) dprod va(dd(l)) $",
)

#schéma(titre: "Orientation relative entre une surface et sa frontière")[#box(height: 3cm)]

== Champ irrotationnel
Un champ dont le rotationnel est nul est dit irrotationnel.
Un champ irrotationnel peut s'écrire comme un gradient.
#encadré(
    titre: "Champ irrotationnel",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [$va(A)$ est une fonction de $RR^3$ dérivable.],
    ),
    grandeurs: grandeurs,
)[
    $ rot va(A) = va(0) arrow.l.r.double exists f | va(A) = grad f $
]

#flashcard(
    recto: "Champ irrotationnel",
    verso: "Champ dont le rotationnel est nul.",
)

#flashcard(
    recto: "Comment peut-on écrire un champ irrotationnel ?",
    verso: "$ rot va(A) = va(0) arrow.l.r.double exists f | va(A) = grad f $",
)

#application[
    Démontrer le sens $exists f | va(A) = grad(f) arrow.double div va(A)=0$
]
#application[
    $va(E)=-grad V$ est-il compatible avec les équations de Maxwell en régime stationnaire ? L'est-il en régime variable ?
]

== Divergence d'un produit vectoriel

#encadré(
    titre: "Divergence d'un produit vectoriel",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [$va(A)$ et $va(B)$ sont des fonctions de $RR^3$ dérivables.],
    ),
    grandeurs: grandeurs,
)[
    $ div(va(A) and va(B)) = ( rot va(A) ) dprod va(B) - va(A) dprod ( rot va(B) ) $
]

#flashcard(
    recto: "Divergence d'un produit vectoriel",
    verso: "$ div(va(A) and va(B)) = ( rot va(A) ) dprod va(B) - va(A) dprod ( rot va(B) ) $",
)

= Laplacien scalaire
Le laplacien scalaire est un opérateur s'applicant aux champs scalaires et renvoyant un scalaire.
#encadré(
    titre: "Laplacien scalaire",
    connaitre: true,
    hypothèses: (
        [$f$ est une fonctions de classe $cal(C)^2$ de $RR^3$.],
    ),
)[
    $ Delta f = div(grad f) = pdv(f, x, 2) + pdv(f, y, 2) + pdv(f, z, 2) $
]

#flashcard(
    recto: "Laplacien scalaire",
    verso: "$ Delta f = div(grad f) = pdv(f, x, 2) + pdv(f, y, 2) + pdv(f, z, 2) $",
)

#flashcard(
    recto: "À quoi s'applique le laplacien scalaire ? Que renvoie-t-il ?",
    verso: "Le laplacien scalaire s'applique aux champs scalaires et renvoie un champ scalaire.",
)

= $va(A) dprod grad$
L'opérateur $va(A) dprod grad$ peut s'appliquer à un champ scalaire, il renvoie alors un scalaire.

L'opérateur $va(A) dprod grad$ peut s'appliquer à un champ vectoriel, il renvoie alors un vecteur.

#encadré(
    titre: $va(A) dprod grad$,
    connaitre: true,
    hypothèses: (
        [$va(A)$ et $f$ sont des fonctions de $RR^3$ dérivables.],
    ),
    grandeurs: grandeurs,
)[
    $ ( va(A).grad ) f = A_x pdv(f, x) + A_y pdv(f, y) + A_z pdv(f, z) $
    $ ( va(A).grad ) va(B) = A_x pdv(va(B), x) + A_y pdv(va(B), y) + A_z pdv(va(B), z) $
]

#flashcard(
    recto: "$va(A) dprod grad$",
    verso: "$ ( va(A).grad ) = A_x pdv(, x) + A_y pdv(, y) + A_z pdv(, z) $",
)

#flashcard(
    recto: "À quoi s'applique l'opérateur $va(A) dprod grad$ ? Que renvoie-t-il ?",
    verso: "L'opérateur $va(A) dprod grad$ s'applique aux champs scalaires et vectoriels, et renvoie respectivement un scalaire et un vecteur.",
)

= Laplacien vectoriel
Le laplacien vectoriel est un opérateur s'appliquant aux champs vectoriels et renvoyant un vecteur.

#encadré(
    titre: "Laplacien vectoriel",
    connaitre: true,
    hypothèses: (
        [$va(A)$ est une fonctions de classe $cal(C)^2$ de $RR^3$.],
    ),
    grandeurs: grandeurs,
)[
    $ arrow(Delta) va(A) = grad(div va(A)) - rot(rot va(A)) = vec(Delta A_x, Delta A_y, Delta A_z) $
]

#flashcard(
    recto: "Laplacien vectoriel",
    verso: "$ arrow(Delta) va(A) = grad(div va(A)) - rot(rot va(A)) = vec(Delta A_x, Delta A_y, Delta A_z) $",
)

#flashcard(
    recto: "À quoi s'applique le laplacien vectoriel ? Que renvoie-t-il ?",
    verso: "Le laplacien vectoriel s'applique aux champs vectoriels et renvoie un champ vectoriel.",
)

Le laplacien vectoriel est parfois noté simplement $Delta$ (sans flèche), le contexte permettant de le distinguer du laplacien scalaire.

#application[
    Montrer que la première composante de $grad (div va(A)) - rot (rot va(A))$ est bien $Delta A_x$.
]
