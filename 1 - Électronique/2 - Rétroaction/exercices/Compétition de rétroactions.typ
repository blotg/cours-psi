#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Compétition de rétroactions",
    difficulté: 2,
)


On s'intéresse au montage ci-dessous. L'ALI est supposé *non idéal*, de fonction de transfert
$ H(p)=S(p)/epsilon(p)=A_0/(1+tau p) $

#figure(
    zap.circuit({
        import zap: *
        import draw: *
        set-style(padding: .4em)
        opamp("ALI", (0, 0))
        resistor("R", (-1.5, -1.5), (-1.5, -4), label: $R$)
        resistor("kR", (-1.5, -1.5), (1.5, -1.5), label: (content: $k R$, anchor: "south"))
        resistor("R2", (-1.5, 1.5), (1.5, 1.5), label: $R$)
        resistor("R3", "ALI.minus", (rel: (-4, 0)), label: $R$)
        swire("ALI.plus", (-1.5, -1.5))
        swire("ALI.out", (1.5, -1.5))
        swire("ALI.minus", "R2.in")
        swire("ALI.out", "R2.out")
        wire("ALI.out", (rel: (1.5, 0)))
        content((rel: (1.5, 0), to: "ALI.out"), $s$, anchor: "west")
        content("R3.out", $e$, anchor: "east")
        frame("G2", (-1.5, -4))
        line(
            (rel: (-0.5, -0.1), to: "ALI.minus"),
            (rel: (-0.5, 0.1), to: "ALI.plus"),
            mark: (start: ">", fill: black),
            name: "epsilon",
        )
        content("epsilon.mid", $epsilon$, anchor: "east")
    }),
)
#question(
    coups-de-pouce: (
        "Grâce à un pont diviseur de tension, relier le potentiel de l'entrée inverseuse à s et e.",
        "Grâce à un pont diviseur de tension, relier le potentiel de l'entrée non-inverseuse à s.",
        "À partir des deux ponts diviseurs de tension, relier l'entrée différentielle à s et e.",
        "Utiliser la fonction de transfert de l'ALI pour éliminer l'entrée différentielle de l'équation.",
    ),
)[
    Établir la fonction de transfert du système.
][
    Les courants d'entrée de l'ALI sont supposés négligeables, on peut donc appliquer le pont diviseur de tension à chacune des deux entrées de l'ALI :
    $
        V_+ = R/(R+k R) s = 1/(1+k) s
    $
    et
    $
        V_- - e = R/(R+R) (s - e) = 1/2 (s - e)
    $
    soit
    $
        V_- = (s+e)/2
    $
    On a alors
    $
        epsilon = V_+ - V_- = 1/(1+k) s - 1/2 (s + e) = (1/(1+k) - 1/2) s - 1/2 e
    $
    ce qui donne dans le domaine de Laplace
    $
        epsilon(p) = (1/(1+k) - 1/2) S(p) - 1/2 E(p)
    $
    On peut alors replacer $epsilon(p)$ en utilisant la fonction de transfert de l'ALI : $epsilon(p) = (1+tau p)/A_0 S(p)$
    $
        (1+tau p)/A_0 S(p) = (1/(1+k) - 1/2) S(p) - 1/2 E(p)
    $
    $
        S(p) ((1+tau p)/A_0 - (1/(1+k) - 1/2)) = - 1/2 E(p)
    $
    On obtient alors la fonction de transfert du système
    $
        H(p) = S(p)/E(p) = (-1/2) / ((1/2 - 1/(1+k) + 1/A_0) + tau/A_0 p)
    $
    $A_0$ étant très grand devant $1$, on peut simplifier la fonction de transfert en
    $
        H(p) = S(p)/E(p) = (-1/2) / ((1/2 - 1/(1+k)) + tau/A_0 p)
    $
]

#question(
    coups-de-pouce: "Regrouper les termes de même ordre du dénominateur de la fonction de transfert. Comparer leur signe.",
)[
    Sous quelle condition sur $k$ le système est-il stable ?
][
    Le système est d'ordre 1, le système est donc stable si et seulement si les coefficients du dénominateur sont de même signe, c'est-à-dire si et seulement si
    $
        &1/2 - 1/(1+k) > 0\
        <==> quad &1/2 > 1/(1+k)\
        <==> quad &2 < 1+k\
        <==> quad &1 < k
    $
]

