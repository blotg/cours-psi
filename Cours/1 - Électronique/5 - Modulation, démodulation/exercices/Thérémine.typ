#import "@local/prepa:0.1.1": *
#import "@preview/wrap-it:0.1.1": wrap-content

#show: exercice.with(
    titre: "Thérémine",
    difficulté: 2,
)

#wrap-content(align: right)[
    #image("images/theremin.jpg", width: 6cm)
][
    On s'intéresse à un Thérémine constitué de deux oscillateurs à relaxation de périodes d'oscillation $T_1=4 R_a/R_b R C_1$ et $T_2=4 R_a/R_b R C_2$ (voir le montage étudié en cours). Le condensateur $C_2$ est constitué d'un condensateur identique à $C_1$ en parallèle d'un condensateur $C'$, lui-même constitué de la main et de l'antenne, et variant entre $0$ et #qty("10", "pF").

    Les signaux issus des deux oscillateurs sont envoyés dans un multiplieur, dont on note $s(t)$ la sortie.

    *Données :* $R_a=qty("1", "kO")$ ; $R_b=qty("2", "kO")$ ; $R=qty("100", "kO")$ ; $C' in [0, qty("10", "pF")]$.
]

#question(
    coups-de-pouce: (
        "Faire un schéma des deux condensateurs en parallèle.",
        "Écrire la loi des nœuds puis la relation tension-courant pour $C_1$ et $C'$.",
    ),
)[
    Exprimer $C_2$ en fonction de $C_1$ et $C'$.
][
    $C_1$ et $C'$ sont en parallèle : ils sont soumis à la même tension $u$, et le courant total $i$ qui traverse l'ensemble se répartit entre les deux, $i=i_1+i'$. Comme $i_1=C_1 dv(u,t)$ et $i'=C' dv(u,t)$,
    $
        i = (C_1+C') dv(u, t)
    $
    Le condensateur équivalent a donc pour capacité $C_2 = C_1+C'$.
]

#question(
    coups-de-pouce: (
        "Compte tenu de l'approximation, que peut-on dire des fréquences $1/T_1$ et $1/T_2$ ?",
        "Représenter les spectres des tensions de sortie des deux oscillateurs.",
    ),
)[
    En supposant $C' << C_1$, quelle est la fréquence la plus petite contenue dans le spectre de $s$ ? Elle sera exprimée en fonction de $R_a$, $R_b$, $R$, $C_1$ et $C'$.
][
    Les sorties des deux oscillateurs à relaxation sont des signaux créneaux, de fréquences $f_1=1/T_1$ et $f_2=1/T_2$. Comme $C' << C_1$, $C_2 approx C_1$, donc $f_1$ et $f_2$ sont très proches l'une de l'autre.

    Le multiplieur effectue le produit des deux signaux. Comme pour deux sinus, la multiplication de deux signaux périodiques de fréquences proches $f_1$ et $f_2$ fait apparaitre, en plus des sommes et différences des harmoniques des deux signaux, une composante à la fréquence $f_1-f_2$ : comme $f_1$ et $f_2$ sont proches, c'est la plus petite fréquence du spectre de $s$ (toutes les autres composantes du spectre sont proches de $f_1$, $f_2$, ou de leurs harmoniques et sommes, bien plus grandes).
    $
        f_1-f_2 = 1/T_1-1/T_2 = R_b/(4 R_a R) (1/C_1 - 1/C_2) = R_b/(4 R_a R) times C'/(C_1 (C_1+C'))
    $
    Avec $C' << C_1$,
    $
        f_1-f_2 approx R_b/(4 R_a R) times C'/C_1^2
    $
]

#question(
    coups-de-pouce: (
        "Quel filtre laisse passer les basses fréquences et coupe les hautes fréquences ?",
        "Comment peut-on réaliser ce montage avec un condensateur et un résistor ?",
    ),
)[
    Quel montage faut-il placer après $s$ pour isoler cette fréquence ? On notera $s'(t)$ la sortie de ce filtre.
][
    Il faut isoler la composante basse fréquence $f_1-f_2$ du spectre de $s$, en éliminant toutes les composantes de fréquence bien plus élevée (voisines de $f_1$, $f_2$ et de leurs harmoniques) : il faut donc placer après le multiplieur un *filtre passe-bas*, qui peut être réalisé simplement par un filtre RC série, de sortie $s'(t)$ prise aux bornes du condensateur.
]

#question()[
    Quelle valeur doit avoir $C_1$ pour que la fréquence du signal en sortie varie entre $0$ et #qty("2", "kHz") ?
][
    D'après la question 2, la fréquence de sortie est maximale lorsque $C'$ est maximal, soit $C'=#qty("10", "pF")$. On veut alors $f_1-f_2 = qty("2","kHz")$ :
    #let Ra = 1e3
    #let Rb = 2e3
    #let R = 100e3
    #let Cp = 10e-12
    #let fmax = 2e3
    #let C1 = calc.sqrt(Rb / (4 * Ra * R) * Cp / fmax)
    $
        C_1 = sqrt(R_b/(4 R_a R) times C'/(f_1-f_2)) = #qty(scientifique(C1, 2), "F") approx #qty(scientifique(C1 * 1e12, 2), "pF")
    $
]
