#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)

= Résolution numérique d'équations différentielles

La méthode d'Euler est une procédure permettant de résoudre numériquement et approximativement des équations différentielles à partir d'une condition initiale.

== Discrétisation

La mémoire des ordinateurs étant finie, il est indispensable de discrétiser le problème pour le résoudre numériquement. Discrétiser consiste à associer à une fonction $y(t)$ une suite $y_i=y(i dot Delta t)$ où $Delta t$ est appelé pas de temps. Le pas de temps est l'équivalent de la période d'échantillonnage.

== Problème d'Euler

Un problème d'Euler est une équation différentielle d'ordre 1 munie d'une condition initiale : on cherche la fonction $y$ telle que $y'(t) = f(y, t)$ et $y(t=0) = y_0$. La fonction recherchée peut éventuellement être un vecteur et donc avoir plusieurs composantes.

#exemple[$ dv(u,t) =- 1/tau u $ $ dv(va(v),t)=va(g)-k/m va(v) $]

Les équations différentielles d'ordre supérieur peuvent être mises sous la forme de problème d'Euler en introduisant un vecteur dont les coordonnées sont des dérivées successives.

#application[
    Mettre sous forme de problème d'Euler les équations différentielles suivantes.
    $ m dv(x,t,2) = -k v^2 $
    $ m dv(va(O M),t,2) =-k va(v)+m va(g) $
    $ a dv(y,t,3)+b dv(y,t,2)+c dv(y,t)+d y=e $
]

== Méthode d'Euler

#figure[
    #canvas({
        import cetz.draw: *
        set-style(stroke: (thickness: 0.5pt))
        set-style(content: (padding: .1))
        import plot: *
        plot(
            name: "plot",
            size: (5, 3),
            axis-style: "left",
            x-tick-step: none,
            y-tick-step: none,
            x-label:$t$,
            y-label:$y$,
            x-ticks: ((0, $t_i$), (1, $t_(i+1)$)), {
                add(t => 1-calc.exp(-t), domain: (-0.5, 1.5))
                add(t => t, domain: (0, 1))
                add-vline(0, max: 0, style:(stroke:(dash: "dashed")))
                add-vline(1, max: 1-calc.exp(-1), style: (stroke:(dash: "dashed")))
            add-anchor("yi", (0,0))
            add-anchor("y-i", (1,1))
        })
        circle(("plot.yi"), radius:2pt, fill: red, stroke: none)
        circle(("plot.y-i"), radius:2pt, fill: red, stroke: none)
        content("plot.yi", text(red,$y_i$), anchor:"south-east")
        content("plot.y-i", text(red,$y_(i+1)$), anchor:"south-west")
    })
]

La méthode d'Euler consiste à approximer la courbe localement par sa tangente. Cette approximation s'appuie sur la formule de Taylor à l'ordre 1.

#encadré(
    titre: "Schéma d'Euler",
    connaitre: true,
    savoir-faire: true,
)[
    $ y_(i+1) = y_i + Delta t dot f(y_i, t_i) $
]

#flashcard(
    recto: "Schéma d'Euler explicite",
    verso: "$ y_(i+1) = y_i + Delta t dot f(y_i, t_i) $",
)

= Résolution numérique d'équations aux dérivées partielles

Il est possible d'adapter la méthode d'Euler pour résoudre des équations aux dérivées partielles.

== Discrétisation
Une double discrétisation, spatiale et temporelle, est nécessaire pour résoudre numériquement une équation aux dérivées partielles. On pose $f_(i,j)=f(i dot Delta t, j dot Delta x)$ où $Delta t$ est le pas de temps et $Delta x$ le pas d'espace.

== Résolution numérique de l'équation de diffusion

Dans cette partie, on s'appuie sur l'exemple de l'équation de diffusion $pdv(T,t)=D pdv(T,x,2)$ mais la méthode peut être adaptée à toute équation aux dérivées partielles.

Dans l'équation de diffusion, une dérivée seconde spatiale est présente. On l'approxime en utilisant une formule de Taylor à l'ordre 2.

#encadré(
    titre: "Approximation de la dérivée seconde spatiale",
    connaitre: true,
    savoir-faire: true,
)[
    $ pdv(T,x,2)_(i,j) approx (T_(i,j+1)-2 T_(i,j)+T_(i,j-1))/(Delta x^2) $
]

#flashcard(
    recto: "Approximation de la dérivée seconde spatiale",
    verso: "$ pdv(T,x,2)_(i,j) approx (T_(i,j+1)-2 T_(i,j)+T_(i,j-1))/(Delta x^2) $",
)

#encadré(
    titre: "Schéma pour résoudre numériquement une équation de diffusion",
    connaitre: false,
    savoir-faire: true,
)[
    $ T_(i+1,j)=D (Delta t)/(Delta x^2) T_(i,j+1) + D (Delta t)/(Delta x^2) T_(i,j-1) + (1-2 D(Delta t)/(Delta x^2))T_(i,j) $
]

Afin que ce schéma soit stable, il est nécessaire que $2 D (Delta t)/(Delta x^2) < 1$.

On peut interpréter $T_(i,j)$ sous la forme d'une matrice. Chaque ligne $i$ correspond alors à la température à un instant $i dot Delta t$ partout dans le milieu. Chaque colonne $j$ correspond à la température à une position $j dot Delta x$ à tous les instants.