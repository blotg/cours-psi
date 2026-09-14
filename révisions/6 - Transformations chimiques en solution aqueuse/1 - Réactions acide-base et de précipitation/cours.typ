#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Réactions acide-base

#flashcard(
    recto: [Réaction acidobasique],
    verso: [$ #ce("AH = A- + H+") $ #ce("A-") est la base et #ce("AH") est l'acide.],
)
#flashcard(
    recto: [constante d'acidité],
    verso: [$ K_a = (a(ce("A-"))_"éq" a(ce("H+"))_"éq")/a(ce("AH"))_"éq" $ c'est-à-dire la constante d'équilibre de la réaction acidobasique #ce("AH = A- + H+").],
)
#flashcard(
    recto: [$p K_a$],
    verso: [$ p K_a = -log K_a $ Plus $K_a$ est grand, plus l'acide est fort.],
)
#flashcard(
    recto: ["Acide fort"],
    verso: ["Un acide qui se dissocie complètement dans l'eau : la réaction #ce("AH = A- + H+") est totale."],
)
#flashcard(
    recto: [Diagramme de prédominance],
    verso: [
        #figure(canvas({
            import cetz.draw: *
            line((0, 0), (8, 0), mark: (end: ">", fill: black), name: "pH")
            content("pH.end", $"pH"$, anchor: "north-east", padding: 0.2)
            line((4, -0.15), (4, 0.15))
            content((4, -0.15), $"p"K_a$, anchor: "north", padding: 0.15)
            content((2, 0.2), ce("AH"), anchor: "south", padding: 0.1)
            content((6, 0.2), ce("A-"), anchor: "south", padding: 0.1)
        }))

        / Pour $"pH" < "p"K_a$: l'acide prédomine
        / Pour $"pH" > "p"K_a$: la base prédomine
        / À $"pH" = "p"K_a$: les deux espèces ont même concentration.
    ],
)

#flashcard(
    recto: [Produit ionique de l'eau],
    verso: [$K_e = a(ce("H3O+"))_"éq" a(ce("HO-"))_"éq" = #num("e-14")$ à #quan[25 °C]. C'est la constante d'équilibre de la réaction de autoprotolyse de l'eau #ce("2 H2O = H3O+ + HO-").],
)

#question-de-colle(
    [Définir la constante d'acidité d'un couple et construire le diagramme de prédominance associé.],
)

= Titrages

#flashcard(
    recto: [Équivalence d'un titrage],
    verso: [Point où les réactifs ont été introduits dans les proportions stœchiométriques de la réaction de titrage.],
)
#flashcard(
    recto: [Conditions pour qu'une réaction puisse être utilisée pour un titrage],
    verso: [Elle doit être *unique*, *totale* et *rapide*, et posséder un moyen de repérage de l'équivalence (indicateur coloré, saut de pH, rupture de pente conductimétrique).],
)

#question-de-colle[
    Expliquer l'allure d'une courbe de titrage conductimétrique et justifier les ruptures de pente à partir des conductivités molaires ioniques.
],


= Solubilité et précipitation

#flashcard(
    recto: [Solubilité],
    verso: [La solubilité d'un solide est la concentration maximale en ions qu'il peut atteindre dans une solution avant de précipiter.],
)
#flashcard(
    recto: [Produit de solubilité],
    verso: [C'est la constante de réaction de la réaction de dissolution $"A"_x "B"_y ("s") = x "A"^(y+) + y "B"^(x-)$ : $ K_s = a("A"^(y+))_"éq"^x a("B"^(x-))_"éq"^y $ à saturation.],
)
#flashcard(
    recto: [$p K_s$],
    verso: ["$ p K_s = -log K_s $"],
)
#flashcard(
    recto: [Condition d'existence du précipité],
    verso: [Le précipité apparait quand $Q_r$ atteint $K_s$ ; tant que $Q_r < K_s$, le solide n'existe pas et la solution est non saturée.],
)
#flashcard(
    recto: [Effet d'ion commun],
    verso: [Ajouter un ion déjà présent dans l'équilibre de solubilisation déplace l'équilibre vers le solide : la solubilité diminue.],
)

#question-de-colle(
    [Définir le produit de solubilité et établir la relation entre solubilité et $K_s$ pour un solide de type #ce("KCl") puis #ce("Fe(OH)2"). Décrire et justifier l'effet d'ion commun.],
)
