#import "@local/prepa:0.1.0": *

#show: cours.with(infos: yaml("infos.yml"))

#let grandeurs = (
    "va(j_N)": (signification: "le vecteur densité de courant de particule", unité: unit("/m^2/s")),
    "delta^2 N": (signification: "le nombre de particules traversant $dd(S)$", unité: "sans unité"),
    "dd(S)": (signification: "la surface élémentaire", unité: unit("m^2")),
    "Phi": (signification: "le débit de particules", unité: unit("/s")),
    "n": (signification: "la densité particulaire", unité: unit("/m^3")),
    "D": (signification: "le coefficient de diffusion", unité: unit("m^2/s")),
    "a": (signification: "le nombre de particules créées par unité de temps et de volume", unité: unit("/m^3/s")),
    "va(v)": (signification: "la vitesse moyenne des particules", unité: unit("m/s")),
)

= Transfert de masse
== Particules
Une particule est un petit élément d'un système. Toutes les particules ont une masse, à part les photons.

#exemple[
    Neutron, électron, atome, molécule, ion, grain de pollen, grain de sable
]

Dans ce chapitre, on s'intéresse aux particules neutres. Les particules chargées sont traitées dans le chapitre "Transport de charge".

#application[
    Dans l'exemple ci-dessus, quelles particules sont neutres ?
]

== Transfert de masse
Transférer de la masse implique transporter des particules massives#footnote[Une particule massive est une particule qui a une masse non nulle, c'est-à-dire une particule qui n'est pas un photon.].

Deux phénomènes contribuent à transférer de la masse

/ Transfert par convection:
    Le transfert par convection a lieu lorsqu'un mouvement macroscopique existe dans un fluide. Les particules présentes dans le fluide sont transportées avec lui.

    #exemple[
        Plancton transporté par les courants marins, particules fines transportées par le courants atmosphériques.]

/ Transfert par diffusion:
    #lien("https://www.youtube.com/watch?v=cD3dOlcxVmE")

    Même en l'absence de mouvement macroscopique, les particules ont un mouvement d'agitation. L'agitation des particules fait migrer les particules des zones de plus forte concentration vers les zones de plus faible concentration.

    #exemple[
        Parfum dans une pièce sans courant d'air, encre dans de l'eau au repos.
    ]

= Vecteur densité de courant de particule et densité particulaire $va(j_N)$
== Définition
La norme du vecteur densité de courant de particule $va(j_N)$ est le nombre de particules transportées par unité d'aire et de temps.

Le sens et la direction du vecteur densité de courant de particule $va(j_N)$ sont le sens et la direction de transport des particules.

#encadré(
    titre: "Nombre de particules traversant une surface élémentaire",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("va(j_N)", "delta^2 N", "dd(S)")),
)[
    $ delta^2 N = va(j_N) dot va(dd(S)) dd(t) $
]

#flashcard(
    recto: "Nombre de particules traversant une surface élémentaire.",
    verso: "$delta^2 N = delta Phi dd(t) = va(j_N) dot va(dd(S)) dd(t)$",
)

#encadré(
    titre: "Lien avec la vitesse moyenne",
    savoir-faire: true,
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("va(j_N)", "va(v)"))
)[
    $ va(j_N) = n va(v) $
]

== Débit de particules

Le débit de particules est l'intégrale du vecteur densité de courant de particule sur une surface orientée.

#encadré(
    titre: "Débit de particules",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("Phi", "va(j_N)")),
)[
    $ Phi = integral.double_S va(j_N) dot va(dd(S)) $
]

== Densité particulaire
La densité particulaire (ou densité de particules) est le nombre de particules par unité de volume. La densité particulaire se mesure en #unit("/m^3").

La densité particulaire est une grandeur intensive.

== Loi de Fick
La loi de Fick relie la densité particulaire au vecteur densité de courant de particules diffusées.

#encadré(
    titre: "Loi de Fick",
    hypothèses: (
        "Le transport de particules se fait par diffusion.",
    ),
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("va(j_N)", "D", "n")),
)[
    $ va(j_N) = -D grad n $
]

#flashcard(
    recto: "Loi de Fick.",
    verso: "$ va(j_N) = -D grad n $",
)

Le signe "$-$" dans la loi de Fick correspond à un sens de diffusion des zones où il y a le plus de particules vers les zones où il y a le moins de particules.

= Équation de diffusion
== Bilan de particules
On peut faire le bilan du nombre de particules dans un système : la variation du nombre de particules dans un système est égale au nombre de particule rentrant dans le système plus le nombre de particules créées#footnote[Souvent, les particules ne sont pas créées de rien mais sont le résultat de réactions chimiques ou nucléaires.] dans le système#footnote[On compte négativement les particules qui sortent du système ou qui y sont détruites.].

#exemple[
    Dans un hôpital, en une journée, 253 personnes sont rentrées, 243 sont sorties, 5 sont nées et 2 sont décédées. Le nombre de personnes dans l’hôpital a varié de $253-243+5-2=#(253 - 243 + 5 - 2)$.
]

Faire le bilan de particules sur un système infinitésimal permet de démontrer l'équation locale de conservation du nombre de particules.


#encadré(
    titre: "Équation locale de conservation du nombre de particules",
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("n", "va(j_N)", "a")),
)[
    $ pdv(n, t) = - div va(j_N) + a $
]

#flashcard(
    recto: "Équation locale de conservation du nombre de particules.",
    verso: "$pdv(n,t) = - div va(j_N) + a$",
)

== Équation de diffusion
Si on remplace le vecteur densité de courant de particules $va(j_N)$ grâce à la loi de Fick dans l'équation locale de conservation du nombre de particules, on obtient l'équation de diffusion.

#encadré(
    titre: "Équation de diffusion",
    hypothèses: (
        [Les particules sont transportées par diffusion],
    ),
    connaitre: true,
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, ("n", "D", "a")),
)[
    $ pdv(n, t) - D Delta n = a $
]

#flashcard(
    recto: "Équation de diffusion de particules.",
    verso: "$pdv(n,t) - D Delta n=a$",
)

== Irréversibilité
L'équation de diffusion n'est pas invariante par renversement du temps. L'équation de diffusion est donc irréversible.
