#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Échelles et libre parcours moyen

#flashcard(
    recto: [Libre parcours moyen : définition et ordres de grandeur],
    verso: [Distance moyenne parcourue par une particule entre deux chocs.

        Dans un gaz aux conditions usuelles, de l'ordre de #quan[100 nm] ; dans un liquide, de l'ordre de la distance intermoléculaire.],
)
#flashcard(
    recto: [Vitesse quadratique moyenne],
    verso: [$ v^* = sqrt(mean(v^2)) $],
)
#flashcard(
    recto: [Vitesse quadratique moyenne pour un gaz parfait monoatomique],
    verso: [$ 1/2 m v^(*2) = 3/2 k_B T $],
)

= Système et équation d'état

#flashcard(
    recto: [Définition d'un système ouvert],
    verso: [Système pouvant échanger matière et énergie.],
)
#flashcard(
    recto: [Définition d'un système fermé],
    verso: [Système pouvant échanger uniquement de l'énergie avec l'extérieur.],
)
#flashcard(
    recto: [Définition d'un système isolé],
    verso: [Système ne pouvant échanger ni matière ni énergie avec l'extérieur.],
)
#flashcard(
    recto: [Équation d'état du gaz parfait (avec unités)],
    verso: [$ P V = n R T $ avec $P$ en #unit("Pa"), $V$ en #unit("m^3"), $n$ en #unit("mol"), $R = #quan[8.314 J/K/mol]$ et $T$ en #unit("K"). $P V$ et $n R T$ sont des énergies, en #unit("J").],
)
#flashcard(
    recto: [Modèle de la phase condensée],
    verso: [Incompressible et indilatable : le volume massique est constant, et l'énergie interne ne dépend que de la température.],
)

#question-de-colle(
    [Citer l'équation d'état des gaz parfaits en précisant le nom et l'unité de chaque grandeur. Définir un système ouvert, fermé et isolé.],
)

= Énergie interne

#flashcard(
    recto: [Première loi de Joule],
    verso: [L'énergie interne d'un gaz parfait ne dépend que de la température.],
)
#flashcard(
    recto: [Énergie interne d'un gaz parfait monoatomique],
    verso: [$ U = 3/2 n R T $],
)
#flashcard(
    recto: [Énergie interne d'un gaz parfait diatomique],
    verso: [$ U = 5/2 n R T $],
)
#flashcard(
    recto: [Capacité thermique à volume constant],
    verso: [$C_V = lr(pdv(U, T)\))_V$, en en #unit("J/K").],
)

#question-de-colle(
    [Définir le modèle du gaz parfait. Exprimer l'énergie interne d'un gaz parfait monoatomique à partir de la vitesse quadratique moyenne. En déduire la capacité thermique à volume constant d'un gaz parfait monoatomique. Citer la première loi de Joule.],
)

= Corps pur diphasé

#let diagramme-PT(pente-fusion) = canvas({
    import cetz.draw: *
    let Tr = (2.5, 1.5)
    let Cr = (6, 4.3)
    line((0, 0), (7.5, 0), mark: (end: ">", fill: black), name: "T")
    line((0, 0), (0, 6), mark: (end: ">", fill: black), name: "P")
    content("T.end", $T$, anchor: "north-east", padding: 0.15)
    content("P.end", $P$, anchor: "north-east", padding: 0.15)

    bezier((0.5, 0.08), Tr, (2, 0.25), name: "sub")
    bezier(Tr, Cr, (4.6, 2), name: "vap")
    line(Tr, (rel: (pente-fusion, 4.2)), name: "fus")

    circle(Tr, radius: 0.07, fill: black)
    circle(Cr, radius: 0.07, fill: black)
    content(Tr, [point triple], anchor: "north-west", padding: 0.2)
    content(Cr, [point critique], anchor: "south", padding: 0.2)

    content((1.2, 3.8), [*Solide*])
    content((3.9, 5.2), [*Liquide*])
    content((6, 0.8), [*Vapeur*])

    set-style(content: (padding: 0.1))
    content("sub.75%", text(size: 8pt)[sublimation], anchor: "south-east", angle: 20deg)
    content("vap.50%", text(size: 8pt)[vaporisation], anchor: "north-west", angle: 38deg)
    content("fus.60%", text(size: 8pt)[fusion], anchor: "south", angle: calc.atan2(pente-fusion, 4.2))
})


#flashcard(
    recto: [Diagramme $(P,T)$ d'un corps pur (cas général)],
    verso: [#diagramme-PT(0.6)],
)
#flashcard(
    recto: [Diagramme $(P,T)$ de l'eau pure],
    verso: [
        #diagramme-PT(-0.6)

        La courbe de fusion a une pente *négative* : la glace est moins dense que l'eau liquide.
    ],
)
#flashcard(
    recto: [Théorème des moments],
    verso: [
        #figure(canvas({
            import cetz.draw: *
            line((0, 0), (7.5, 0), mark: (end: ">", fill: black), name: "v")
            line((0, 0), (0, 5.6), mark: (end: ">", fill: black), name: "P")
            content("v.end", $v$, anchor: "north-east", padding: 0.15)
            content("P.end", $P$, anchor: "north-east", padding: 0.15)

            // Courbe de saturation : gaussienne en ln v, plus étroite côté liquide.
            let (vc, Pc, sl, sv) = (2.5, 4.6, 0.25, 0.55)
            let cloche(v) = {
                let s = if v < vc { sl } else { sv }
                Pc * calc.exp(-calc.pow(calc.ln(v / vc), 2) / s)
            }
            line(..range(0, 61).map(k => {
                let v = 1 + k * (7 - 1) / 60
                (v, cloche(v))
            }))
            circle((vc, Pc), radius: 0.07, fill: black)
            content((vc, Pc), $C$, anchor: "south", padding: 0.15)

            // Isotherme : palier entre L et V, liquide raide, vapeur en hyperbole.
            let y = 1.7
            let vL = vc * calc.exp(-calc.sqrt(sl * calc.ln(Pc / y)))
            let vV = vc * calc.exp(calc.sqrt(sv * calc.ln(Pc / y)))
            set-style(stroke: 1.2pt + blue)
            line((vL - 0.3, 5), (vL, y), (vV, y))
            line(..range(0, 21).map(k => {
                let v = vV + k * (7.3 - vV) / 20
                (v, y * vV / v)
            }))

            let (L, V) = ((vL, y), (vV, y))
            let M = (L, 35%, V)
            for (p, nom, ancre) in ((L, "L", "north-east"), (M, "M", "north"), (V, "V", "south-west")) {
                circle(p, radius: 0.06, fill: black, stroke: none)
                content(p, $#nom$, anchor: ancre, padding: 0.15)
            }

            content((0.5, 3.4), text(size: 9pt)[liquide], angle: 90deg)
            content((2.9, 2.6), text(size: 9pt)[liquide \ + vapeur])
            content((5.8, 3.2), text(size: 9pt)[vapeur])
        }))

        Sur un palier de changement d'état : $ x_v = (overline(L M))/(overline(L V)) quad "et" quad x_l = (overline(M V))/(overline(L V)) $
    ],
)

#question-de-colle(
    [Tracer le diagramme de phases $(P,T)$ de l'eau en indiquant les trois domaines, le point triple, le point critique et les trois courbes d'équilibre.],
)
#question-de-colle(
    [Tracer le diagramme de Clapeyron $(P,v)$ de l'eau pour l'équilibre liquide-vapeur, en y plaçant la courbe d'ébullition, la courbe de rosée, le point critique et quelques isothermes. Énoncer le théorème des moments.],
)
