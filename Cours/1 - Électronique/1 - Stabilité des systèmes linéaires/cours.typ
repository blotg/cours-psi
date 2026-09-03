#import "@local/prepa:0.1.1": *

#show: cours.with(infos: yaml("infos.yml"))

#let grandeurs = (
    "R": (signification: "résistance du résistor", unité: unit("O")),
    "C": (signification: "capacité du condensateur", unité: unit("F")),
    "p": (
        signification: "variable de Laplace, assimilable à $j omega$ dans le domaine fréquentiel",
        unité: unit("rad/s"),
    ),
)

= Introduction
#application[
    Pour chacune des deux équations différentielles ci-dessous, dire si ses solutions divergent ou non.
    $
        dv(y, t) - 2 y = 1
    $
    $
        dv(y, t, 2) + 2 dv(y, t) + 3 y= 4
    $
]

À la fin de ce chapitre, vous saurez répondre à cette question en un coup d'œil et sans calculs.

== Système linéaire
Un système est un dispositif qui traite une ou des entrées et produit une ou des sorties.

#schéma(titre: "Système", hauteur: 2cm)

#exemple[
    Vanne (angle d'un robinet $arrow.r$ débit), moteur électrique (tension $arrow.r$ vitesse de rotation).
]

Un système linéaire est un système continu dont la sortie dépend linéairement de l'entrée.

#schéma(titre: "Système linéaire", hauteur: 5cm)

= Équation différentielle et fonction de transfert
== Exemple introductif : circuit RC série
=== Point de vue temporel

#encadré(
    titre: "Équation différentielle régissant la tension dans un circuit RC",
    savoir-faire: true,
    hypothèses: "le circuit est dans l'ARQS",
    grandeurs: (
        "s(t)": (signification: "tension aux bornes du condensateur", unité: unit("V")),
        "e(t)": (signification: "tension en entrée du circuit", unité: unit("V")),
    )
        + sub-dictionary(grandeurs, ("R", "C")),
)[
    #carreaux(2cm)
    $
        dv(s, t) + 1/(R C) s(t)= 1/(R C) e(t)
    $
]

=== Point de vue spectral

#encadré(
    titre: "Fonction de transfert régissant la tension dans un circuit RC",
    savoir-faire: true,
    hypothèses: "le circuit est dans l'ARQS",
    grandeurs: (
        "S(p)": (
            signification: "grandeur de Laplace associée à la tension aux bornes du condensateur",
            unité: unit("V"),
        ),
        "E(p)": (signification: "grandeur de Laplace associée à la tension en entrée du circuit", unité: unit("V")),
    )
        + sub-dictionary(grandeurs, ("R", "C", "p")),
)[
    #carreaux(2cm)
    $
        p S(p) + 1/(R C) S(p)= 1/(R C) E(p)
    $
]

== Relation entre équation différentielle et fonction de transfert
Une forte ressemblance entre les 2 équations précédentes peut être remarquée. Cette ressemblance peut être généralisée.

#encadré(
    titre: "Correspondance entre les domaines",
    connaitre: true,
)[
    #set align(center)
    #table(
        columns: 3,
        align: center,
        inset: 10pt,
        "Temporel", "de Laplace", "Fréquentiel",
        $e(t)$, $E(p)$, $underline(e) (j omega)$,
        $s(t)$, $S(p)$, $underline(s) (j omega)$,
        $dv(, t)$, $p$, $j omega$,
        $dv(, t, 2)$, $p^2$, $(j omega)^2=-omega^2$,
    )
]

#flashcard(
    recto: "À quoi correspondent $integral$, $dv(,t)$ et $dv(,t,2)$ dans le domaine fréquentiel (ou de Fourier) ?",
    verso: "$1/(i omega)$, $i omega$ et $(i omega)^2$ respectivement",
)
#flashcard(
    recto: "À quoi correspondent $integral$, $dv(,t)$ et $dv(,t,2)$ dans le domaine de Laplace ?",
    verso: "$1/p$, $p$ et $p^2$ respectivement",
)
#flashcard(
    recto: "À quoi correspondent $1/(j omega)$, $j omega$ et $(j omega)^2$ dans le domaine temporel ?",
    verso: "$integral$, $dv(,t)$ et $dv(,t,2)$ respectivement",
)

#application[
    Déterminer la fonction de transfert associée à l'équation différentielle
    $dv(s, t) + 1/(R C) s(t) = dv(e, t)$
]

#application[
    Déterminer l'équation différentielle associée à la fonction de transfert
    $
        H(p)=1/(1+Q(p/(omega_0)+omega_0/p))
    $
]

= Stabilité
== Présentation
Un système stable a une sortie bornée si son entrée est bornée#footnote[En pratique, un système instable a sa sortie en saturation car elle ne peut pas augmenter ou diminuer indéfiniment.].

== Système du premier ordre

#encadré(
    titre: "Influence du numérateur",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        "Le système est linéaire."
    ),
)[
    Le numérateur de la fonction de transfert n'influence la stabilité du système.
]

#encadré(
    titre: "Critère de stabilité",
    savoir-faire: true,
    connaitre: true,
    hypothèses: (
        "Le système est linéaire.",
        "Le système est du 1er ordre.",
    ),
)[
    Le système est stable si les 2 coefficients du dénominateur sont de même signe.
]

#flashcard(
    recto: "Critère de stabilité d'un système d'ordre 1",
    verso: "Le système est stable si les 2 coefficients du dénominateur sont de même signe.",
)


#question-de-colle(
    "Montrer qu'un système d'ordre 1 est stable si et seulement si les 2 coefficients de la fonction de transfert sont de même signe.",
)

#application[Les fonctions de transfert suivantes correspondent-elles à des systèmes stables ?
    $
        underline(H)(j omega)=(1-j R C omega)/(1+j R C omega)
    $
    $
        H(p)=(1+R C p ) / (1-R C p )
    $
]

#application[
    Les équations différentielles suivantes correspondent-elles à des systèmes stables ?
    $
        2 dv(s, t)-R/L s=dv(e, t)-R/L e
    $
    $
        dv(s, t)+R/L s=0
    $
    $
        2 dv(s, t)-dv(e, t)=R/L e-R/L s
    $
]

== Système d'ordre 2

#encadré(
    titre: "Critère de stabilité",
    savoir-faire: true,
    connaitre: true,
    hypothèses: (
        "Le système est linéaire.",
        "Le système est du 2ème ordre.",
    ),
)[
    Le système est stable si les 3 coefficients du dénominateur sont de même signe.
]

#flashcard(
    recto: "Critère de stabilité d'un système d'ordre 2",
    verso: "Le système est stable si les 3 coefficients du dénominateur sont de même signe.",
)

#question-de-colle("Montrer qu'un système d'ordre 2 est stable si et seulement si les 3 coefficients de la fonction de transfert sont de même signe. Un seul des 3 cas (discriminant positif, nul ou négatif) sera traité, au choix du colleur.")

#application[
    Les fonctions de transfert suivantes correspondent-elles à des systèmes stables ?
    $
        underline(H)(j omega)=1/(1+j R C omega-L C omega^2)
    $
    $
        H(p)=1/(1+R C p-L C p^2)
    $
]

#application[
    Les équations différentielles suivantes correspondent-elles à des systèmes stables ?
    $
        -L C dv(s,t,2)-R C dv(s,t)-s=-e
    $
]
