#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Forme canonique

#flashcard(
    recto: "Équation canonique d'un oscillateur du deuxième ordre en nommant les constantes",
    verso: "$ dv(u,t,2) + omega_0/Q dv(u,t) + omega_0^2 u = f(t) $ où $omega_0$ est la pulsation propre (#unit(\"rad/s\")) et $Q$ le facteur de qualité (sans unité).",
)
#flashcard(
    recto: "Les trois régimes libres du deuxième ordre en fonction du facteur de qualité",
    verso: "
      - $Q < 1/2$ : apériodique.
      - $Q = 1/2$ : critique, le retour à l'équilibre est le plus rapide.
      - $Q > 1/2$ : pseudo-périodique, oscillations amorties.",
)
#flashcard(
  recto: "Lien entre durée du régime transitoire et facteur de qualité",
  verso: "La durée du régime transitoire est proportionnelle à $Q/omega_0$.",
)
#flashcard(
    recto: "Équation différentielle de l'oscillateur harmonique",
    verso: "$dv(u,t,2) + omega_0^2 u = 0$, de solution $u(t) = A cos(omega_0 t + phi)$ : l'énergie se conserve.",
)
#flashcard(
  recto: "Solutions de $A dv(u,t,2) + B dv(u,t) + C u = 0$ dans le cas $Delta > 0$",
  verso: "Les solutions sont de la forme $u(t) = K_1 e^(r_1 t) + K_2 e^(r_2 t)$, où $r_1$ et $r_2$ sont les racines réelles et distinctes du polynôme caractéristique $A r^2 + B r + C = 0$.",
)
#flashcard(
  recto: "Solutions de $A dv(u,t,2) + B dv(u,t) + C u = 0$ dans le cas $Delta = 0$",
  verso: "Les solutions sont de la forme $u(t) = (K_1 + K_2 t) e^(r t)$, où $r$ est la racine double du polynôme caractéristique $A r^2 + B r + C = 0$.",
)
#flashcard(
  recto: "Solutions de $A dv(u,t,2) + B dv(u,t) + C u = 0$ dans le cas $Delta < 0$",
  verso: "Les solutions sont de la forme $u(t) = e^(alpha t) (K_1 cos(beta t) + K_2 sin(beta t))$, où $alpha = -B/(2A)$ et $beta = sqrt(-Delta)/(2A)$ sont les parties réelle et imaginaire des racines complexes conjuguées du polynôme caractéristique $A r^2 + B r + C = 0$.",
)

#question-de-colle(
    "Circuit $R L C$ série en régime libre, condensateur initialement chargé : établir l'équation différentielle vérifiée par $u_C$, l'identifier à la forme canonique, exprimer $omega_0$ et $Q$, puis donner et tracer la forme des solutions selon la valeur de $Q$.",
)

// = Analogie électromécanique

// #flashcard(
//     recto: "Analogie entre un $R L C$ série et un système masse-ressort amorti",
//     verso: "
//     #table(
//     columns: 2,
//     $L$, $m$,
//     $R$, [$alpha$ (coefficient de frottement fluide)],
//     $1/C$, $k$,
//     $q$, $x$,
//     $i$, $v$
//     )"
// )

= Régime sinusoïdal forcé

#flashcard(
    recto: "Impédances complexes d'un résistor",
    verso: "$ underline(Z)_R = R $",
)
#flashcard(
    recto: "Impédances complexes d'un condensateur",
    verso: "$underline(Z)_C = 1/(j C omega)$",
)
#flashcard(
    recto: "Impédances complexes d'une bobine",
    verso: "$underline(Z)_L = j L omega$",
)
#flashcard(
    recto: "Définition de la résonance et lien avec $Q$",
    verso: "Il y a résonance quand l'amplitude de la réponse passe par un maximum en fonction de la fréquence d'excitation. Plus $Q$ est grand, plus la résonance est aigüe.",
)

#question-de-colle(
    "Énoncer la loi d'Ohm en notation complexe et établir les expressions des impédances complexes de la résistance, du condensateur et de la bobine.",
)