#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Germination des lys",
    ouvert: true,
    difficulté: 2,
)

On a planté des bulbes de lys à une quinzaine de centimètres dans du terreau (diffusivité thermique de l'ordre de #qty("1e-7", "m^2/s")). Pour commencer leur germination, les bulbes ont besoin d'une température d'environ #qty("10", "Celsius").

#let D = 1e-7
#let d = 0.15

#image("../images/graphique_infoclimat.fr_quimper.svg")

#question(
    coups-de-pouce: (),
)[
    À quelle date la germination commence-t-elle ?
][
    #let d1j = calc.sqrt((D * 24 * 3600) / calc.pi)
    Pour une période $T_"jour" = qty("24", "h")$, la profondeur de peau est $delta_"jour" = sqrt((2 D)/omega) = sqrt((D T_"jour")/pi) = #qty(scientifique(d1j, 1), "m")$.

    À une profondeur de #qty("15", "cm"), l'onde de température journalière est atténuée d'un facteur $exp(-d/delta) = #num(scientifique(calc.exp(-d / d1j), 1))$. Les variations journalières de température ne se font donc quasiment pas sentir à cette profondeur.

    On modélise la température en surface par $T(0,t) = - A cos(omega t) + T_0$ avec $A = (19-7)/2 = qty("6", "Celsius")$, $T_0 = (19+7)/2 = qty("13", "Celsius")$ et $omega = (2 pi)/ T_"année" = #qty(scientifique((2 * calc.pi) / (365 * 24 * 3600), 1), "rad/s")$. L'origine des temps est prise au 1er janvier.

    En complexes, cette température devient $underline(T)(0,t) = T_0 - A e^(i omega t)$.

    La relation de dispersion $underline(k)^2 = -i omega / D$ se résout en $underline(k) = k_r + i k_i$ avec $k_r = sqrt(omega/(2D))$ et $k_i = -sqrt(omega/(2D))$.

    La température à la profondeur $d$ est donnée par
    $
        underline(T)(d,t) = T_0 - A e^(k_i d) e^(i (omega t - k_r d))
    $

    D'où
    $
        T(d,t) = T_0 - A e^(-k_i d) cos(omega t - k_r d)
    $

    Pour trouver la date de germination, on résout l'équation (en notant $T_g$ la température de germination) :
    #let T-g = 10
    #let T-0 = 13
    #let A = 6
    #let w = (2 * calc.pi) / (365 * 24 * 3600)
    #let k-r = calc.sqrt(w / (2 * D))
    #let k-i = -calc.sqrt(w / (2 * D))
    #let d = 0.15
    #let t = (calc.acos((T-0 - T-g) / (A * calc.exp(-k-i * d))).rad() + k-r * d) / w
    $
        T(d,t) = T_g\
        T_0 - A e^(-k_i d) cos(omega t - k_r d) = T_g\
        cos(omega t - k_r d) = (T_0 - T_g) / (A e^(-k_i d))\
        omega t - k_r d = arccos((T_0 - T_g) / (A e^(-k_i d)))\
        t = (arccos((T_0 - T_g) / (A e^(-k_i d))) + k_r d) / omega
        approx #num(scientifique(t / (24 * 3600), 1))  "jours"\
    $
    La germination commence donc $#num(scientifique(t / (24 * 3600), 1))  "jours"$ après le 1er janvier, soit vers la mi-mars.
]
