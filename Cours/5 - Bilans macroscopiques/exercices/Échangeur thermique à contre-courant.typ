#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Échangeur thermique à contre-courant",
)

On considère une machine thermique ouverte dans laquelle circule lentement et horizontalement un fluide en régime stationnaire avec le débit massique $D$. Il y reçoit les puissances thermique $P_"th"$ et mécanique $P_"m"$.

#figure(
    canvas({
        import draw: *
        line((0, 0.5), (2, .5), (2, 1.5), (6, 1.5), (6, 0.5), (8, 0.5))
        line((0, -0.5), (2, -.5), (2, -1.5), (6, -1.5), (6, -0.5), (8, -0.5))
        line((0, 0), (1, 0), mark: (end: ">>", fill: black))
        line((7, 0), (8, 0), mark: (end: ">>", fill: black))
        content((0, 0), $h_1$, anchor: "east", padding: .4em)
        content((8, 0), $h_2$, anchor: "west", padding: .4em)
        bezier((2.5, 2.5), (3.5, 1), (3.5, 2.1), mark: (end: ">>", fill: black))
        content((2, 2.5), $P_"th"$, padding: .4em)
        bezier((5.5, 2.5), (4.5, 1), (4.5, 2.1), mark: (end: ">>", fill: black))
        content((6, 2.5), $P_"m"$, padding: .4em)
    }),
)

#question(
    coups-de-pouce: (
        "Il s'agit de la démonstration du PPI du cours, avec quelques hypothèses qui simplifient un peu les calculs.",
        "Le PPI ainsi obtenu doit être multiplié par le débit massique pour faire apparaitre les puissance demandées.",
    ),
)[
    À l'aide du premier principe de la thermodynamique, établir un lien entre ces deux puissances, $D$ et les enthalpies massiques du fluide en entrée et en sortie.
][
    Le premier principe industriel donne
    $
        D(h_2+e_(c,2)+g z_2 - h_1 - e_(c,1) - g z_1) = P_"th" + P_"m"
    $
    Or $e_(c,1) approx 0$ et $e_(c,2) approx 0$ car le fluide circule lentement, et $z_2 = z_1$ car le tuyau est horizontal. On en déduit donc
    $
        D(h_2 - h_1) = P_"th" + P_"m"
    $
]

On considère maintenant un échangeur thermique isobare et adiabatique. Dans le tuyau circule un gaz, supposé parfait, de coefficient $gamma= 7/5$, et de masse molaire $M=qty("29", "g/mol")$. Il entre à $T_1=qty("520", "K")$ et ressort à $T_2=qty("300", "K")$. Le fluide réfrigérant est de l'eau, de capacité thermique massique $c=qty("4.18", "kJ/kg/K")$, entrant à $theta_1=qty("12", "Celsius")$ et sortant à $theta_2$. Le régime est stationnaire de débit $D_g=qty("1.0", "kg/s")$ pour le gaz et $D_e=qty("4.0", "kg/s")$ pour l'eau.


#figure(
    canvas({
        import draw: *
        rect((1.8, 1.7), (6.2, -3.7), fill: hachure(10pt), stroke: none)
        rect((2, 1.5), (6, -3.5), fill: white, stroke: none)
        rect((0, 0.5), (8, -0.5), fill: white, stroke: none)
        rect((0, -1.5), (8, -2.5), fill: white, stroke: none)
        line((0, 0.5), (2, .5), (2, 1.5), (6, 1.5), (6, 0.5), (8, 0.5))
        line((0, -0.5), (2, -.5), (2, -1.5))
        line((6, -1.5), (6, -0.5), (8, -0.5))
        line((2, -2.5), (2, -3.5), (6, -3.5), (6, -2.5))
        line((0, -1.5), (8, -1.5))
        line((0, -2.5), (8, -2.5))
        line((0, 0), (rel: (1, 0)), mark: (end: ">>", fill: black))
        line((7, 0), (rel: (1, 0)), mark: (end: ">>", fill: black))
        line((0, -2), (rel: (1, 0)), mark: (end: ">>", fill: black))
        line((7, -2), (rel: (1, 0)), mark: (end: ">>", fill: black))
        content((0, 0), $theta_1$, anchor: "east", padding: .4em)
        content((8, 0), $theta_2$, anchor: "west", padding: .4em)
        content((0, -2), $T_1$, anchor: "east", padding: .4em)
        content((8, -2), $T_2$, anchor: "west", padding: .4em)
        content((4, 0), [eau])
        content((4, -2), [gaz])
    }),
)

#let theta-1 = 12
#let T-1 = 520
#let T-2 = 300
#let D-g = 1
#let D-e = 4.0
#let R = 8.3145
#let c = 4180
#let gamma-air = 7 / 5
#let M = 29e-3

#let theta-2 = theta-1 - D-g / D-e * (gamma-air * R) / ((gamma-air - 1) * c * M) * (T-2 - T-1)
#question(
    coups-de-pouce: (
        "Donner un nom à la puissance allant du gaz vers le fluide.",
        "Appliquer le PPI en termes de puissances d'une part au gaz et d'autre part au fluides.",
        "Utiliser la seconde loi de Joule.",
    ),
)[
    Exprimer puis calculer $theta_2$.
][
    On note $P$ la puissance cédée par le gaz à l'eau.

    On applique la relation trouvée précédemment au gaz et à l'eau :
    $
        cases(
            D_g (h_(2,g) - h_(1,g)) = -P,
            D_e (h_(2,e) - h_(1,e)) = P
        )
    $
    On a donc
    $
        D_g (h_(2,g) - h_(1,g)) + D_e (h_(2,e) - h_(1,e)) = 0
    $
    On peut remplacer les variations d'enthalpie avec la seconde loi de Joule (échange isobare) :
    $
        D_e c (theta_2 - theta_1) + D_g c_p (T_2 - T_1) = 0
    $
    où $c_p = C_p/m = ((gamma n R)/(gamma - 1))/m = (gamma R)/(M (gamma - 1))$ est la capacité thermique massique à pression constante du gaz parfait.
    On en déduit
    $
        theta_2 = theta_1 - D_g/D_e (gamma R)/((gamma -1)c M) (T_2 - T_1)
        = #zi.degreeCelsius(theta-2, round: (precision: 2))
    $
]

#question(
    coups-de-pouce: (
        "Écrire le second principe de la thermodynamique pour un système ouvert en écoulement stationnaire. Comment le transformer pour faire apparaitre le taux de création d'entropie ?",
        "Il faut utiliser la même méthode que pour faire apparaitre des puissances dans le PPI.",
        "Appliquer cette relation tantôt au gaz, tantôt à l'eau, puis faire la somme des deux.",
        "L'entropie échangée reçue par le gaz est celle cédée par l'eau.",
    ),
)[
    Exprimer le taux de création d'entropie $(delta S_c)/dd(t)$ en fonction de la différence d'entropie massique entre la sortie et l'entrée pour l'eau $s_(2,e) - s_(1,e)$ et de gaz $s_(2,g)-s_(1,g)$ et des débits massiques.
][
    Le second principe pour un système ouvert en écoulement stationnaire s'écrit
    $
        s_2 - s_1 = s_c + s_c
    $
    En multipliant par le débit massique, on obtient
    $
        D (s_2 - s_1) = (delta S_c)/dd(t) + (delta S_e)/dd(t)
    $
    En appliquant cette relation au gaz et à l'eau, on obtient
    $
        cases(
            D_g (s_(2,g) - s_(1,g)) = (delta S_(c,g))/dd(t) + (delta S_(e,g))/dd(t),
            D_e (s_(2,e) - s_(1,e)) = (delta S_(c,e))/dd(t) + (delta S_(e,e))/dd(t)
        )
    $
    Or l'entropie échangée reçue par le gaz $delta S_(e,g)$ est celle cédée par l'eau $-delta S_(e,e)$, donc
    En sommant les deux, on trouve finalement
    $
        (delta S_c)/dd(t) = (delta S_(c,e))/dd(t) + (delta S_(c,g))/dd(t) = D_g (s_(2,g) - s_(1,g)) + D_e (s_(2,e) - s_(1,e))
    $
]

#let Delta-s-g = (gamma-air * R) / (M * (gamma-air - 1)) * calc.ln(T-2 / T-1)
#let Delta-s-e = c * calc.ln(theta-2 / theta-1)
#question(
    coups-de-pouce: (
        "Comment s'écrit la variation d'enthalpie pour une transformation isobare ?",
        "Écrire la seconde loi de Joule.",
        "Exprimer la variation d'entropie massique en fonction de la capacité thermique massique et de la température.",
        "Pour un gaz parfait, comment la capacité thermique massique à pression constant s'exprime-t-elle en fonction du coefficient de Laplace ?",
    ),
)[
    En utilisant l'identité thermodynamique $dd(H) = T dd(S) + V dd(P)$, montrer que $s_(2,e)-s_(1,e)=c ln(theta_2/theta_1)$ et que $s_(2,g)-s_(1,g)=(gamma R)/(M(gamma-1)) ln T_2/T_1$. Calculer leur valeur.
][
    Pour une transformation isobare, on a $dd(P)=0$, donc l'identité thermodynamique devient $dd(H) = T dd(S)$. On en déduit que
    $
        dd(S) = dd(H)/T
    $
    En intégrant entre l'état 1 et l'état 2, on obtient
    $
        s_2 - s_1 = integral_(1)^(2) dd(H)/T
    $
    Pour l'eau, on utilise la seconde loi de Joule isobare $dd(H) = c dd(theta)$, ce qui donne
    
    $
        s_(2,e) - s_(1,e) = integral_(theta_1)^(theta_2) c dd(theta)/theta = c ln(theta_2/theta_1)
        = #qty(scientifique(Delta-s-e,2), "J/kg/K")
    $
    Pour le gaz parfait, on utilise la seconde loi de Joule isobare $dd(H) = c_p dd(T)$ avec $c_p = (gamma R)/(M (gamma - 1))$, ce qui donne
    
    $
        s_(2,g) - s_(1,g) = integral_(T_1)^(T_2) (gamma R)/(M (gamma - 1)) dd(T)/T = (gamma R)/(M (gamma - 1)) ln(T_2/T_1)
        = #qty(scientifique(Delta-s-g,2), "J/kg/K")
    $
]

#question[
    Quel est le signe de $(delta S_C)/dd(t)$ ? Est-ce conforme avec le second principe de la thermodynamique ?
][
    En utilisant les valeurs numériques précédentes, on trouve
    #let Delta-S-c = D-g * Delta-s-g + D-e * Delta-s-e
    $
        (delta S_c)/dd(t) = D_g (s_(2,g) - s_(1,g)) + D_e (s_(2,e) - s_(1,e)) = #qty(scientifique(Delta-S-c,2), "W/K") >0
    $
    Ceci est conforme avec le second principe de la thermodynamique qui impose que le taux de création d'entropie soit positif ou nul.
]
