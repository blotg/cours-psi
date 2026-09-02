#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)

= Coordonnées cartésiennes
== Définition
En coordonnées cartésiennes, un point est repéré par la distance entre son projeté sur chacun des axes et l'origine du repère.

Les coordonnées d'un point sont notées $x in RR$, $y in RR$ et $z in RR$

#flashcard(
    recto: "Bornes des coordonnées $x$, $y$, $z$ en coordonnées cartésiennes",
    verso: "$x in RR$, $y in RR$, $z in RR$"
)

Les vecteurs de base sont les mêmes en tout point de l'espace.

#figure[
    #grid(columns: 2,
        include("schemas/cartésiennes_coordonnées.typ"),
        include("schemas/cartésiennes_vecteurs.typ")
    )
]

Le vecteur $va(O M)$ s'exprime comme $va(O M)=x va(e_x)+y va(e_y)+z va(e_z)$.

#flashcard(
    recto: "Vecteur $va(O M)$ en coordonnées cartésiennes",
    verso: "$ va(O M)=x va(e_x)+y va(e_y)+z va(e_z) $"
)

#flashcard(
    recto: "Quels vecteurs de la base cartésienne sont mobiles ?",
    verso: "Aucun : les vecteurs de la base cartésienne sont fixes et ne dépendent pas du point considéré. #linebreak();" + read("schemas/cartésiennes_vecteurs.typ")
)

== Élément de volume
L'élément de volume a pour volume $dd(V)=dd(x) dot dd(y) dot dd(z)$.

#flashcard(
    recto: "Élément de volume cartésien",
    verso: "$ dd(V)=dd(x) dot dd(y) dot dd(z) $" + read("schemas/cartésiennes_element_volume.typ")
)

#figure[
    #include("schemas/cartésiennes_element_volume.typ")
]

#application[
    Déterminer le volume d'un parallélépipède rectangle de hauteur $h$, de largeur $l$ et de profondeur $p$ grâce à un calcul d'intégrale.
]

#flashcard(
    recto: "Volume d'un parallélépipède rectangle de hauteur $h$, de largeur $l$ et de profondeur $p$",
    verso: "$ V = l dot p dot h $"
)

#application[
    Déterminer la masse du parallélépipède précédent dont le sommet inférieur gauche derrière est à l'origine du repère. On donne sa masse volumique $mu=mu_0(1+x y)$.
]

== Élément de surface
Les éléments de surface sont représentés sur la figure suivante.

#figure[
    #grid(columns: 3, column-gutter: 1fr,
        include("schemas/cartésiennes_dS_x.typ"),
        include("schemas/cartésiennes_dS_y.typ"),
        include("schemas/cartésiennes_dS_z.typ")
    )
]

#flashcard(
    recto: "Élément de surface $va(dd(S))=dd(S)va(e_x)$ en coordonnées cartésiennes",
    verso: "$ va(dd(S))=dd(y) dot dd(z) va(e_x) $" + read("schemas/cartésiennes_dS_x.typ")
)

#flashcard(
    recto: "Élément de surface $va(dd(S))=dd(S)va(e_y)$ en coordonnées cartésiennes",
    verso: "$ va(dd(S))=dd(x) dot dd(z) va(e_y) $" + read("schemas/cartésiennes_dS_y.typ")
)
#flashcard(
    recto: "Élément de surface $va(dd(S))=dd(S)va(e_z)$ en coordonnées cartésiennes",
    verso: "$ va(dd(S))=dd(x) dot dd(y) va(e_z) $" + read("schemas/cartésiennes_dS_z.typ")
)

#application[
    Déterminer grâce à un calcul d'intégrale l'aire d'un triangle rectangle isocèle de hauteur $l$ situé dans le plan $(O y z)$.
]

= Coordonnées cylindriques
== Définition
En coordonnées cylindriques, un point est repéré par sa distance à l'axe $(O z)$, l'angle entre son projeté dans le plan $(O x y)$ et l'axe $(O x)$ et la distance entre son projeté sur l'axe $z$ et l'origine du repère.

Les coordonnées d'un point sont notées $r in RR^+$, $theta in [0,2pi[$ et $z in RR$.

#flashcard(
    recto: "Bornes des coordonnées $r$, $theta$, $z$ en coordonnées cylindriques",
    verso: "$r in RR^+$, $theta in [0,2 pi[$, $z in RR$"
)

Les vecteurs de base dépendent du point considéré. La base est donc appelée base mobile.

#flashcard(
    recto: "Quels vecteurs de la base cylindrique sont mobiles ?",
    verso: "Les vecteurs $va(e_r)$ et $va(e_theta)$ sont mobiles et dépendent de l'angle $theta$. Le vecteur $va(e_z)$ est fixe et identique au vecteur $va(e_z)$ de la base cartésienne. #linebreak();" + read("schemas/cylindriques_vecteurs.typ")
)

#figure[
    // #include("schemas/cylindriques_coordonnées.typ")
    #include("schemas/cylindriques_vecteurs.typ")
]

#application[
    Représenter la base mobile aux points de l'exemple suivant.
    #figure[
       #include "schemas/cylindriques_application.typ"
    ]
]

Le vecteur $va(O M)$ s'exprime comme $va(O M)=r va(e_r)+z va(e_z)$.

#flashcard(
    recto: "Vecteur $va(O M)$ en coordonnées cylindriques",
    verso: "$ va(O M)=r va(e_r)+z va(e_z) $"
)

== Élément de volume
L'élément de volume a pour volume $dd(V)=dd(r) dot r dot dd(theta) dot dd(z)$.

#flashcard(
    recto: "Élément de volume cylindrique",
    verso: "$ dd(V)=dd(r) dot r dot dd(theta) dot dd(z) $" + read("schemas/cylindriques_element_volume.typ")
)

#figure[
    #include("schemas/cylindriques_element_volume.typ")
]

#application[
    Déterminer le volume d'un cylindre de rayon $R$ et de hauteur $h$.
]

#flashcard(
    recto: "Volume d'un cylindre de rayon $R$ et de hauteur $h$",
    verso: "$ V = pi R^2 h $"
)

== Éléments de surface
Les éléments de surface sont représentés sur la figure suivante.

#figure[
    #grid(columns: 3, column-gutter: 1fr,
        include("schemas/cylindriques_dS_r.typ"),
        include("schemas/cylindriques_dS_theta.typ"),
        include("schemas/cylindriques_dS_z.typ")
    )
]

#flashcard(
    recto: "Élément de surface $va(dd(S))=dd(S)va(e_r)$ en coordonnées cylindriques",
    verso: "$ va(dd(S))=r dot dd(theta) dot dd(z) va(e_r) $" + read("schemas/cylindriques_dS_r.typ")
)

#flashcard(
    recto: "Élément de surface $va(dd(S))=dd(S)va(e_theta)$ en coordonnées cylindriques",
    verso: "$ va(dd(S))=dd(r) dot dd(z) va(e_theta) $" + read("schemas/cylindriques_dS_theta.typ")
)

#flashcard(
    recto: "Élément de surface $va(dd(S))=dd(S)va(e_z)$ en coordonnées cylindriques",
    verso: "$ va(dd(S))=dd(r) dot r dot dd(theta) va(e_z) $" + read("schemas/cylindriques_dS_z.typ")
)

#application[
    Déterminer grâce à un calcul d'intégrale l'aire d'un disque.
]

#flashcard(
    recto: "Aire d'un disque de rayon $R$",
    verso: "$ A = pi R^2 $"
)

#application[
    Déterminer grâce à un calcul d'intégrale l'aire latérale d'un cylindre.
]

#flashcard(
    recto: "Aire latérale d'un cylindre de rayon $R$ et de hauteur $h$",
    verso: "$ A = 2 pi R h $"
)

== Coquille cylindrique
Lorsque le problème étudié est invariant par rotation selon $theta$, il peut être plus aisé d'utiliser une coquille cylindrique.

Une coquille cylindrique est un volume infinitésimal contenu entre deux cylindres concentriques de rayons $r$ et $r+dd(r)$.

#figure[
    #include("schemas/cylindriques_coquille.typ")
]

L'aire intérieure de la coquille est $2 pi r h$, son aire extérieure est $2 pi (r+dd(r)) h$ et son volume est $ dd(V)= pi (r+dd(r))^2 h - pi r^2 h = pi h (r^2+2r dd(r) + dd(r)^2 - r^2) approx 2 pi r h dd(r) $

On peut aussi retrouver ce résultat en intégrant l'élément de volume cylindrique sur l'angle $theta$ : $ dd(V) = integral_0^(2 pi) r dd(r) dd(theta) dd(z) = 2 pi r dd(r) h $

#flashcard(
    recto: "Volume d'une coquille cylindrique",
    verso: "$ dd(V) = 2 pi r h dd(r) $" + read("schemas/cylindriques_coquille.typ")
)

#application[
    Déterminer le volume d'un cylindre de rayon $R$ et de hauteur $h$ en utilisant une coquille cylindrique.
]

= Coordonnées sphériques
== Définition
En coordonnées sphériques, un point est repéré par sa distance à l'origine du repère, l'angle entre l'axe $O z$ et $va(O M)$ et l'angle entre son projeté dans le plan $(O x y)$ et l'axe $(O x)$.

Les coordonnées d'un point sont notées $r in RR^+$, $theta in [0,pi[$ et $phi in [0,2 pi[$

#flashcard(
    recto: "Bornes des coordonnées $r$, $theta$, $phi$ en coordonnées sphériques",
    verso: "$r in RR^+$, $theta in [0,pi[$, $phi in [0,2 pi[$"
)

Les vecteurs de base dépendent du point considéré. La base est donc appelée base mobile.

#figure[
    #grid(columns: 2,
        include "schemas/sphériques_coordonnées.typ",
        include "schemas/sphériques_vecteurs.typ"
    )
]

#flashcard(
    recto: "Quels vecteurs de la base sphérique sont mobiles ?",
    verso: "Les vecteurs $va(e_r)$, $va(e_theta)$ et $va(e_phi)$ sont tous mobiles et dépendent des angles $theta$ et $phi$. #linebreak();" + read("schemas/sphériques_vecteurs.typ")
)

#application[
    Représenter la base mobile aux points de l'exemple suivant.
    #figure[
       #include "schemas/sphériques_application.typ"
    ]
]

Le vecteur $va(O M)$ s'exprime comme $va(O M)=r va(e_r)$.

#flashcard(
    recto: "Vecteur $va(O M)$ en coordonnées sphériques",
    verso: "$ va(O M)=r va(e_r) $"
)

== Élément de volume
L'élément de volume a pour volume $dd(V)=r^2 sin(theta) dot dd(r) dot dd(theta) dot dd(phi)$.

#figure[
    #include("schemas/sphériques_element_volume.typ")
]

#flashcard(
    recto: "Élément de volume sphérique",
    verso: "$ dd(V)=r^2 sin(theta) dot dd(r) dot dd(theta) dot dd(phi) $" + read("schemas/sphériques_element_volume.typ")
)

#application[
    Déterminer le volume d'une boule de rayon $R$.
]

#flashcard(
    recto: "Volume d'une boule de rayon $R$",
    verso: "$ V = 4/3 pi R^3 $"
)

== Éléments de surface
Les éléments de surface sont représentés sur la figure suivante.

#figure[
    #grid(columns: 3, column-gutter: 1fr,
        include("schemas/sphériques_dS_r.typ"),
        include("schemas/sphériques_dS_theta.typ"),
        include("schemas/sphériques_dS_phi.typ")
    )
]

#flashcard(
    recto: "Élément de surface $va(dd(S))=dd(S)va(e_r)$ en coordonnées sphériques",
    verso: "$ va(dd(S))=r^2 sin(theta) dot dd(theta) dot dd(phi) va(e_r) $" + read("schemas/sphériques_dS_r.typ")
)

#flashcard(
    recto: "Élément de surface $va(dd(S))=dd(S)va(e_theta)$ en coordonnées sphériques",
    verso: "$ va(dd(S))=r dot sin(theta) dot dd(r) dot dd(phi) va(e_theta) $" + read("schemas/sphériques_dS_theta.typ")
)

#flashcard(
    recto: "Élément de surface $va(dd(S))=dd(S)va(e_phi)$ en coordonnées sphériques",
    verso: "$ va(dd(S))=r dot dd(r) dot dd(theta) va(e_phi) $" + read("schemas/sphériques_dS_phi.typ")
)

#application[
    Déterminer grâce à un calcul d'intégrale l'aire d'une sphère de rayon $R$.
]

#flashcard(
    recto: "Aire d'une sphère de rayon $R$",
    verso: "$ 4 pi R^2 $"
)

#application[
    Déterminer grâce à un calcul d'intégrale l'aire latérale d'un cône d'angle au sommet $pi/2$ et de hauteur $h$.
]

== Coquille sphérique
Lorsque le problème étudié est invariant par rotation selon $theta$ et $phi$, il peut être plus aisé d'utiliser une coquille sphérique

Une coquille sphérique est un volume infinitésimale contenu entre deux sphères concentriques de rayons $r$ et $r+dd(r)$.

#figure[
    #include("schemas/sphériques_coquille.typ")
]

L'aire intérieure de la coquille est $4 pi r^2$, son aire extérieure est $4 pi (r+dd(r))^2$ et son volume est $ dd(V)= 4/3 pi (r+dd(r))^3 - 4/3 pi r^3 = 4/3 pi (r^3 + 3r^2 dd(r) + 3r dd(r)^3 + dd(r)^3-r^3) approx 4 pi ^2 dd(r) $

#flashcard(
    recto: "Volume d'une coquille sphérique",
    verso: "$ dd(V) = 4 pi r^2 dd(r) $" + read("schemas/sphériques_coquille.typ")
)

On peut aussi retrouver ce résultat en intégrant l'élément de volume sphérique sur les angles $theta$ et $phi$ : $ dd(V) = integral_0^(2 pi) integral_0^(pi) r^2 sin(theta) dd(r) dd(theta) dd(phi) = 4 pi r^2 dd(r) $

#application[
    Déterminer le volume d'une boule de rayon $R$ en utilisant une coquille sphérique.
]
