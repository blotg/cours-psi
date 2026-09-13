#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Réactions acide-base

#flashcard(
    recto: "Couple acide-base et constante d'acidité",
    verso: "#ce(\"AH = A- + H+\"), $K_a = (a(ce(\"A-\")) a(ce(\"H+\")))/a(ce(\"AH\"))$ et $\"p\"K_a = -log K_a$. Plus $K_a$ est grand, plus l'acide est fort.",
)
#flashcard(
    recto: "Diagramme de prédominance",
    verso: "Pour $\"pH\" < \"p\"K_a$ l'acide prédomine, pour $\"pH\" > \"p\"K_a$ la base prédomine ; à $\"pH\" = \"p\"K_a$ les deux espèces ont même concentration.",
)
#flashcard(
    recto: "Produit ionique de l'eau",
    verso: "$K_e = a(ce(\"H3O+\")) a(ce(\"HO-\")) = 10^(-14)$ à #qty(\"25\", \"Celsius\"), d'où $\"pH\" + \"pOH\" = 14$.",
)

#question-de-colle(
    "Définir la constante d'acidité d'un couple et construire le diagramme de prédominance associé. L'utiliser pour prévoir la réaction prépondérante lors du mélange de deux couples.",
)

= Titrages

#flashcard(
    recto: "Équivalence d'un titrage",
    verso: "Point où les réactifs ont été introduits dans les proportions stœchiométriques de la réaction de titrage : $n_(\"titré\") = n_(\"titrant\")\\/nu$.",
)
#flashcard(
    recto: "Réaction de titrage",
    verso: "Elle doit être unique, totale et rapide, et posséder un moyen de repérage de l'équivalence (indicateur coloré, saut de pH, rupture de pente conductimétrique).",
)

#question-de-colle(
    "Décrire un titrage pH-métrique acide fort – base forte : allure de la courbe, repérage de l'équivalence, et exploitation pour déterminer la concentration cherchée.",
)
#question-de-colle(
    "Expliquer l'allure d'une courbe de titrage conductimétrique et justifier les ruptures de pente à partir des conductivités molaires ioniques.",
)

= Solubilité et précipitation

#flashcard(
    recto: "Produit de solubilité",
    verso: "Pour $\"A\"_x \"B\"_y (\"s\") = x \"A\"^(y+) + y \"B\"^(x-)$, $K_s = a(\"A\"^(y+))^x a(\"B\"^(x-))^y$ à saturation, et $\"p\"K_s = -log K_s$.",
)
#flashcard(
    recto: "Condition d'existence du précipité",
    verso: "Le précipité apparait quand $Q_r$ atteint $K_s$ ; tant que $Q_r < K_s$, le solide n'existe pas et la solution est non saturée.",
)
#flashcard(
    recto: "Effet d'ion commun",
    verso: "Ajouter un ion déjà présent dans l'équilibre de solubilisation déplace l'équilibre vers le solide : la solubilité diminue.",
)

#question-de-colle(
    "Définir le produit de solubilité et établir la relation entre solubilité et $K_s$ pour un solide de type #ce(\"AB\") puis #ce(\"AB2\"). Décrire et justifier l'effet d'ion commun.",
)
