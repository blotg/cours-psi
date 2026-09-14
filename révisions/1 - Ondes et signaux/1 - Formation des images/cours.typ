#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)

#flashcard(
    recto: [Indice d'un milieu transparent],
    verso: [$n = c/v$, où $v$ est la vitesse de la lumière dans le milieu. $n=1$ dans le vide, $n approx num("1.5")$ pour le verre.],
)
#flashcard(
    recto: [Indice optique du vide],
    verso: [$n = 1$.],
)
#flashcard(
    recto: [Indice optique de l'eau],
    verso: [$n approx num("1.33")$.],
)
#flashcard(
    recto: [Indice optique du verre],
    verso: [$n approx num("1.5")$.],
)
#flashcard(
    recto: [Modèle de l'optique géométrique],
    verso: [La lumière se propage en ligne droite dans un milieu homogène et isotrope, et les rayons sont indépendants les uns des autres. Le modèle cesse de valoir quand les dimensions du dispositif approchent la longueur d'onde : la diffraction apparait.],
)
#flashcard(
    recto: [Diffraction par une ouverture],
    verso: [$sin theta approx lambda/d$ : plus l'ouverture $d$ est petite devant $lambda$, plus le faisceau s'ouvre.],
)

#flashcard(
    recto: [Lois de Snell-Descartes],
    verso: [
        - Les rayons incident, réfléchi et réfracté sont dans le plan d'incidence.
        - Réflexion : $i'_1 = i_1$
        - Réfraction : $n_1 sin i_1 = n_2 sin i_2$
    ],
)
#flashcard(
    recto: [Condition de réflexion totale],
    verso: [Elle n'existe qu'en passant d'un milieu plus réfringent à un milieu moins réfringent ($n_1 > n_2$), au-delà de l'angle limite $i_"lim" = arcsin(n_2/n_1)$.],
)

#question-de-colle(
    [Citer les 3 lois de Snell-Descartes et définir les angles sur un schéma. Établir la condition de réflexion totale.],
)
#question-de-colle(
    [Pour une fibre à saut d'indice, établir l'expression de l'angle d'acceptance à l'entrée de la fibre, puis celle de la dispersion intermodale.],
)

#flashcard(
    recto: [Conditions de Gauss],
    verso: [Les rayons sont peu inclinés et proches de l'axe optique.],
)
#flashcard(
    recto: [Qu'apportent les conditions de Gauss ?],
    verso: [Elles assurent un stigmatisme et un aplanétisme approchés.],
)
#flashcard(
    recto: [Définition du foyer objet],
    verso: [Point où se croisent les rayons incidents qui émergent de la lentille parallèles à l'axe optique.],
)
#flashcard(
    recto: [Définition du foyer image],
    verso: [Point où se croisent les rayons émergents de la lentille lorsqu'ils arrivent parallèles à l'axe optique.],
)
#flashcard(
    recto: [Grandissement d'une lentille mince],
    verso: [$ gamma = (overline(A'B'))/(overline(A B)) = (overline(O A'))/(overline(O A)) $],
)
#flashcard(
    recto: [Théorème de Thalès],
    verso: [
        #grid(
            columns: (1fr, 1fr),
            [#figure(
                canvas({
                    import cetz.draw: *
                    let (A, B, C) = ((0, 2.6), (-2, 0), (2.4, 0))
                    let (M, N) = ((-1, 1.3), (1.2, 1.3))
                    line(B, A, C)
                    line(B, C, stroke: 1.2pt + blue)
                    line(M, N, stroke: 1.2pt + blue)
                    for (p, nom, ancre) in (
                        (A, "A", "south"),
                        (B, "B", "north-east"),
                        (C, "C", "north-west"),
                        (M, "M", "east"),
                        (N, "N", "west"),
                    ) {
                        circle(p, radius: 0.04, fill: black)
                        content(p, $#nom$, anchor: ancre, padding: 0.15)
                    }
                }),

                caption: [Configuration emboîtée],
            )],

            [#figure(
                canvas({
                    import cetz.draw: *
                    let (A, B, C) = ((0, 0), (2.2, 1.6), (2.2, -1.1))
                    let (M, N) = ((-1.1, -0.8), (-1.1, 0.55))
                    line(M, B)
                    line(N, C)
                    line(B, C, stroke: 1.2pt + blue)
                    line(M, N, stroke: 1.2pt + blue)
                    for (p, nom, ancre) in (
                        (A, "A", "north"),
                        (B, "B", "south-west"),
                        (C, "C", "north-west"),
                        (M, "M", "north-east"),
                        (N, "N", "south-east"),
                    ) {
                        circle(p, radius: 0.04, fill: black)
                        content(p, $#nom$, anchor: ancre, padding: 0.15)
                    }
                }),
                caption: [Configuration papillon],
            )],
        )

        $ (M N) parallel (B C) => (A M)/(A B) = (A N)/(A C) = (M N)/(B C) $
    ],
)


#question-de-colle(
    [Construire géométriquement l'image d'un objet $A B$ perpendiculaire à l'axe optique par une lentille convergente ou divergente (au choix du colleur), dans quatre cas suivant la position de l'objet $A B$ par rapport aux foyers et au centre optique. Les propriétés permettant le tracé (foyers, centre optique, aplanétisme, stigmatisme) seront explicitées.],
)
#question-de-colle(
    [Pour une lentille convergente ou divergente (au choix du colleur), tracer l'image d'un objet $A B$ situé à l'infini puis dans le plan focal objet. Les propriétés permettant le tracé (foyers, centre optique, stigmatisme) seront explicitées.],
)
#question-de-colle(
    [Pour une lentille convergente puis divergente, tracer le rayon émergent correspondant à un rayon incident quelconque. Les propriétés permettant le tracé (foyers, centre optique, stigmatisme) seront explicitées.],
)

#flashcard(
    recto: [Modèle de l'œil],
    verso: [Une lentille convergente de distance focale variable (le cristallin) et un écran fixe (la rétine).],
)
#flashcard(
    recto: [Limite de résolution de l'œil],
    verso: [La limite de résolution angulaire de l'œil est de l'ordre de la minute d'arc, soit #quan[3e-4 rad].],
)
#flashcard(
    recto: [Plage d'accommodation de l'œil],
    verso: [Ponctum proximum à #quan[25 cm], ponctum remotum à l'infini.],
)
#flashcard(
    recto: [Modèle de l'appareil photographique],
    verso: [Une lentille convergente de distance focale fixe et un capteur dont la distance à la lentille est réglable.],
)

#question-de-colle(
    [Présenter un modèle de l'œil. Donner la plage d'accommodation d'un œil emmétrope. Donner l'ordre de grandeur de sa limite de résolution angulaire et en déduire la taille du plus petit détail visible au ponctum proximum.],
)
