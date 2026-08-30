#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Oscillateur à filtre RLC",
)

On considère le montage suivant, constitué d'un montage amplificateur non-inverseur et d'un filtre RLC-série.

#figure(
    zap.circuit({
        import zap: *
        import draw: *
        set-style(padding: .4em)
        opamp("ALI", (0, 0), invert: true)
        resistor("R1", (-1.5, -1.5), (-1.5, -4), label: $R_1$)
        resistor("R2", (-1.5, -1.5), (1.5, -1.5), label: (content: $R_2$, anchor: "south"))
        swire("ALI.minus", (-1.5, -1.5))
        swire("ALI.out", (1.5, -1.5))
        frame("G1", "R1.out")
        wire("ALI.out", (rel: (1.5, 0)))
        content((1.5, 0), $e$, anchor: "south", padding: .3em)
        inductor("L", (rel: (1.5, 0), to: "ALI.out"), (rel: (2, 0)), label: $L$, variant: "ieee")
        resistor("r", "L.out", (rel: (2, 0)), label: $r$)
        capacitor("C", "r.out", (rel: (2, 0)), label: $C$)
        content("C.out", $s$, anchor: "west")
        resistor("R", "C.out", (rel: (0, -4)), label: $R$)
        frame("G2", "R.out")
        swire("C.out", (rel: (0, 1.5)), (-1.5, 1.5), "ALI.plus", axis: "y")
    }),
)

#question(
    coups-de-pouce: (
        "Déterminer l'impédance équivalente de $L$, $r$ et $C$ en série puis utiliser un pont diviseur de tension.",
    ),
)[
    Déterminer la fonction de transfert $H(p)=S(p)/E(p)$ du filtre RLC-série.
][
    L'inductance $L$, la résistance $r$ et le condensateur $C$ sont parcourus par le même courant : ils sont en série et forment, avec $R$, un pont diviseur de tension entre $e$ et $s$. On a donc
    $
        H(p) = S(p)/E(p) = R/(R+r+L p+1/(C p))
    $
    En multipliant numérateur et dénominateur par $C p$, on obtient la forme canonique
    $
        H(p) = (R C p)/(1+(R+r) C p+L C p^2)
    $
]

#question()[
    Donner la fonction de transfert $G(p)=E(p)/S(p)$ du montage amplificateur non-inverseur.
][
    Le courant d'entrée de l'ALI étant négligeable, un pont diviseur de tension entre $R_1$ et $R_2$ donne la relation classique du montage amplificateur non-inverseur, sortie $e$ et entrée $s$ :
    $
        G(p) = E(p)/S(p) = 1+R_2/R_1
    $
]

#question(
    coups-de-pouce: (
        "Utiliser les deux fonctions de transfert des questions précédentes.",
        "Remplacer $E(p)$ dans la fonction de transfert du filtre en utilisant la fonction de transfert de l'amplificateur non-inverseur puis éliminer $E(p)$.",
        "Éliminer les traits de fraction puis prendre la partie réelle et la partie imaginaire.",
    ),
)[
    À quelle condition observe-t-on des oscillations quasi-sinusoïdales ?
][
    Le système est bouclé : $S(p)=H(p)E(p)$ et $E(p)=G(p)S(p)$. Pour des oscillations sinusoïdales entretenues, le critère de Barkhausen impose, en régime sinusoïdal établi ($p=j omega$),
    $
        underline(H)(j omega) underline(G)(j omega) = 1
    $
    soit
    $
        (R C j omega)/(1+(R+r) C j omega - L C omega^2) (1+R_2/R_1) = 1
    $
    En éliminant le dénominateur,
    $
        R C j omega (1+R_2/R_1) = 1 - L C omega^2 + (R+r) C j omega
    $
    En identifiant partie réelle et partie imaginaire,
    $
        cases(
            "partie réelle :" quad & 1-L C omega^2 = 0,
            "partie imaginaire :" quad & R C omega (1+R_2/R_1) = (R+r) C omega,
        )
    $
    La partie réelle donne la pulsation des oscillations
    $
        omega_0 = 1/sqrt(L C)
    $
    et la partie imaginaire donne, après simplification par $omega$,
    $
        R(1+R_2/R_1) = R+r arrow.double R_2/R_1 = r/R
    $
    Des oscillations quasi-sinusoïdales, de pulsation $omega_0=1/sqrt(L C)$, ne peuvent donc exister que si $R_2/R_1 = r/R$.
]

#question(
    coups-de-pouce: (
        "Qu'est-ce qui limite l'amplitude des oscillations ?",
        "Quelle est l'amplitude maximale de la tension de sortie d'un ALI ?",
        "Utiliser une des fonctions de transfert pour relier les amplitudes de $s$ et de $e$.",
    ),
)[
    Quelle est l'amplitude de $e(t)$ ? Quelle est celle de $s(t)$ ?
][
    La tension $e$ est directement la tension de sortie de l'ALI : c'est donc la saturation de l'ALI qui limite son amplitude, qui vaut $V_"sat"$.

    À la pulsation $omega_0$, le dénominateur de $H$ vaut, d'après la question précédente, $1-L C omega_0^2+(R+r) C j omega_0 = j(R+r) C omega_0$. On a donc
    $
        H(j omega_0) = (R C j omega_0)/(j (R+r) C omega_0) = R/(R+r)
    $
    L'amplitude de $s$ vaut donc $R/(R+r) V_"sat"$
]

#question(
    coups-de-pouce: (
        "Est-ce le filtre passe-bande ou l'ALI qui a tendance à \"purifier\" le spectre ?",
    ),
)[
    Laquelle de ces deux tensions est la « plus sinusoïdale » ?
][
    La tension $e$ est la sortie saturée de l'ALI : sa forme s'écarte d'autant plus d'une sinusoïde que la saturation est prononcée. La tension $s$, elle, est la sortie du filtre passe-bande RLC, qui atténue les harmoniques de $e$ autour de sa fréquence centrale. C'est donc $s$ qui est la tension « la plus sinusoïdale ».
]

#question(
    coups-de-pouce: (
        "Établir une équation différentielle portant sur $e$ ou $s$.",
        "Combiner les fonctions de transfert pour éliminer $E$ ou $S$, supprimer les traits de fraction puis passer en temporel.",
    ),
)[
    À quelle condition les oscillations démarrent-elles ?
][
    En reprenant $S(p)[1+(R+r)C p+L C p^2] = R C p E(p)$ et $E(p)=(1+R_2/R_1)S(p)$, on obtient
    $
        S(p)[1+(R+r)C p+L C p^2] = R C p (1+R_2/R_1)S(p)
    $
    $
        S(p)[1+((R+r)-R(1+R_2/R_1))C p+L C p^2] = 0
    $
    ce qui donne, en passant dans le domaine temporel,
    $
        L C dv(s, t, 2) + [(R+r)-R(1+R_2/R_1)]C dv(s, t) + s = 0
    $
    Pour que les oscillations démarrent spontanément à partir d'un bruit quelconque, il faut que ce système bouclé soit instable, c'est-à-dire que le coefficient de $dv(s, t)$ soit négatif :
    $
        (R+r)-R(1+R_2/R_1) < 0 arrow.double R_2/R_1 > r/R
    $
    On retrouve, sous forme d'inégalité stricte, la condition de la question 3.
]
