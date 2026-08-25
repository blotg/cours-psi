#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Oscillateur à décharge de condensateur",
    difficulté: 1,
)

On étudie le circuit suivant, où $R_1=qty("100", "kO")$, $R_2=qty("10", "kO")$, $R_3=qty("10", "kO")$ et $C=qty("10", "nF")$.

#figure(
    zap.circuit({
        import zap: *
        import draw: *
        set-style(padding: .4em)
        opamp("ALI", (0, 0))
        resistor("R2", (-1.5, -1.5), (-1.5, -4), label: $R_2$)
        resistor("R1", (-1.5, -1.5), (1.5, -1.5), label: (content: $R_1$, anchor: "south"))
        swire("ALI.plus", "R2.in")
        swire("ALI.out", "R1.out")
        frame("G1", "R2.out")
        resistor("R3", (1.5, 0), (rel: (3, 0)), label: $R_3$)
        content("R3.in", $V_s$, anchor: "south", padding: .3em)
        capacitor("C", "R3.out", (rel: (0, -4)), label: $C$)
        frame("G2", "C.out")
        content("R3.out", $V_-$, anchor: "west", padding: .3em)
        swire("R3.out", (-1.5, 1.5), "ALI.minus", axis: "y")
    }),
)

#question(
    coups-de-pouce: (
        "Le montage est constitué d'un comparateur à hystérésis et d'un filtre qu'il s'agit d'identifier.",
        "Le filtre RC-série est-il un filtre passe-haut ou passe-bas ? Quelle est la forme canonique d'une fonction de transfert de ce type ?",
    ),
)[
    Identifier le filtre passif inclus dans ce montage. Quelle est sa fonction de transfert ? Quelle est l'équation différentielle associée ?
][
    Le montage est constitué de deux parties : un comparateur à hystérésis, réalisé avec l'ALI et $R_1$, $R_2$, et un filtre passif $R_3 C$, dont l'entrée est $V_s$ et la sortie $V_-$ (tension aux bornes de $C$).

    Ce filtre RC-série avec sortie sur $C$ est un filtre passe-bas du premier ordre, de fonction de transfert
    $
        H(p) = (V_- (p))/(V_s (p)) = 1/(1+R_3 C p)
    $
    L'équation différentielle associée s'obtient en passant dans le domaine temporel :
    $
        R_3 C dv(V_-, t) + V_- = V_s (t)
    $
]

#question()[
    Résoudre cette équation différentielle en supposant $V_s$ constant.
][
    L'équation différentielle $R_3 C dv(V_-, t)+V_- = V_s$ admet pour solution générale la somme d'une solution particulière constante, $V_-=V_s$, et de la solution de l'équation homogène, en $e^(-t/(R_3 C))$. On a donc
    $
        V_-(t) = V_s + (V_- (0)-V_s) exp(-t/(R_3 C))
    $
    Il s'agit d'une évolution exponentielle vers l'asymptote $V_s$, de constante de temps $tau=R_3 C$.
]

#question(
    coups-de-pouce: (
        "En cas d'hésitation entre comparateur à hystérésis positif et négatif, regarder où se fait l'entrée.",
    ),
)[
    Quel montage de l'ALI reconnait-on dans ce montage ? Donner sa caractéristique $(V_s,V_-)$.
][
    L'entrée $V_-$ est appliquée sur l'entrée inverseuse de l'ALI, tandis que l'entrée non-inverseuse est reliée au pont diviseur $R_1$, $R_2$ formant une rétroaction positive à partir de $V_s$. On reconnait donc un *comparateur à hystérésis inverseur* ou *comparateur à hystérésis négatif*.

    Le courant d'entrée de l'ALI étant nul, un pont diviseur de tension donne, quel que soit l'état de $V_s$,
    $
        V_+ = R_2/(R_1+R_2) V_s
    $
    L'ALI étant instable, sa sortie ne peut valoir que $plus.minus V_"sat"$, et le signe de $V_s$ est celui de $epsilon=V_+-V_-$ :
    - si $V_s=+V_"sat"$, alors $V_+=+R_2/(R_1+R_2) V_"sat"$ : cet état reste valable tant que $V_- < R_2/(R_1+R_2) V_"sat"$ ;
    - si $V_s=-V_"sat"$, alors $V_+=-R_2/(R_1+R_2) V_"sat"$ : cet état reste valable tant que $V_- > -R_2/(R_1+R_2) V_"sat"$.

    La caractéristique $(V_-,V_s)$ présente donc un cycle d'hystérésis : $V_s$ bascule de $+V_"sat"$ à $-V_"sat"$ quand $V_-$ dépasse $R_2/(R_1+R_2) V_"sat"$ par valeurs croissantes, et de $-V_"sat"$ à $+V_"sat"$ quand $V_-$ dépasse $-R_2/(R_1+R_2) V_"sat"$ par valeurs décroissantes.

    #figure(
        canvas({
            draw.set-style(axes: (shared-zero: false))
            let th = 0.8
            plot.plot(
                size: (10, 6),
                axis-style: "school-book",
                x-tick-step: none,
                y-tick-step: none,
                x-min: -1.9,
                x-max: 1.9,
                y-min: -1.5,
                y-max: 1.5,
                x-ticks: (),
                y-ticks: (),
                x-label: $V_-$,
                y-label: $V_s$,
                {
                    plot.annotate(resize: false, {
                        import draw: *
                        line((-1.9, 1), (th, 1))
                        // basculement +Vsat -> -Vsat au seuil haut
                        line((th, 1), (th, -1), mark: (end: ">>", fill: black))
                        line((-th, -1), (-th, 1), mark: (end: ">>", fill: black))
                        line((-th, -1), (1.9, -1))
                        content((-0.2, -1.2), $-V_"sat"$)
                        content((-0.2, 1.2), $+V_"sat"$)
                        content((-1.2, 0), $-R_2/(R_1+R_2) V_"sat"$, anchor: "north")
                        content((1.2, 0), $R_2/(R_1+R_2) V_"sat"$, anchor: "north")
                    })
                },
            )
        }),
    )
]

#question(
    coups-de-pouce: (
        "Tracer $V_-(t)$ en supposant que $V_s (t)=+V_\"sat\"$. Jusqu'à quand ce tracé reste-t-il valable ?",
        "À quelle condition $V_s$ passe-t-il de $+V_\"sat\"$ à $-V_\"sat\"$ ?",
    ),
)[
    En supposant qu'à $t=0$, $V_s=+V_"sat"$ et $V_-(0)=-R_2/(R_1+R_2) V_"sat"$ (juste après un basculement), tracer $V_-(t)$ et $V_s (t)$.
][
    Tant que $V_s=+V_"sat"$, $V_-$ évolue, d'après la question 2, vers l'asymptote $V_"sat"$ selon
    $
        V_-(t) = V_"sat" - (V_"sat"+R_2/(R_1+R_2) V_"sat") exp(-t/(R_3 C))
    $
    Cette évolution reste valable jusqu'à ce que $V_-$ atteigne le seuil haut $R_2/(R_1+R_2) V_"sat"$, instant auquel $V_s$ bascule à $-V_"sat"$ (cf. question 3). $V_-$ évolue alors, par symétrie, vers l'asymptote $-V_"sat"$, jusqu'à retomber au seuil bas $-R_2/(R_1+R_2) V_"sat"$, où $V_s$ rebascule à $+V_"sat"$, et le cycle recommence : $V_s$ est un signal créneau, $V_-$ un signal formé de portions d'exponentielles oscillant entre $-R_2/(R_1+R_2) V_"sat"$ et $R_2/(R_1+R_2) V_"sat"$.

    #figure(
        canvas({
            let th = 0.619
            plot.plot(
                size: (12, 6),
                axis-style: "school-book",
                x-tick-step: none,
                y-tick-step: none,
                x-ticks: ((0, $0$), (th, $T/2$), (2 * th, $T$)),
                y-ticks: (
                    (-1, $-V_"sat"$),
                    (-0.3, $-R_2/(R_1+R_2) V_"sat"$),
                    (0.3, $R_2/(R_1+R_2) V_"sat"$),
                    (1, $V_"sat"$),
                ),
                x-label: $t$,
                y-label: [],
                {
                    let f-vmoins(t) = {
                        let tt = calc.rem(t, 2 * th)
                        if tt < th { return 1 - 1.3 * calc.exp(-tt) } else { return -1 + 1.3 * calc.exp(-(tt - th)) }
                    }
                    let f-vmoins1(t) = {
                        return 1 - 1.3 * calc.exp(-t)
                    }
                    let f-vmoins2(t) = {
                        return -1 + 1.3 * calc.exp(-(t - th))
                    }
                    let f-vmoins3(t) = {
                        return return 1 - 1.3 * calc.exp(-(t - 2 * th))
                    }
                    let f-vs(t) = {
                        let tt = calc.rem(t, 2 * th)
                        if tt < th { return 1 } else { return -1 }
                    }
                    plot.add(f-vmoins, domain: (0, 4 * th), samples: 400, label: $V_-(t)$)
                    plot.add(
                        f-vs,
                        domain: (0, 4 * th),
                        samples: 4000,
                        label: $V_s(t)$,
                    )
                    plot.add(
                        f-vmoins1,
                        domain: (0, 4 * th),
                        samples: 4000,
                        style: (stroke: (dash: "dashed", paint: blue)),
                    )
                    plot.add(
                        f-vmoins2,
                        domain: (th, 4 * th),
                        samples: 4000,
                        style: (stroke: (dash: "dashed", paint: blue)),
                    )
                    plot.add(
                        f-vmoins3,
                        domain: (2 * th, 4 * th),
                        samples: 4000,
                        style: (stroke: (dash: "dashed", paint: blue)),
                    )
                },
            )
        }),
    )
    Les tracés en pointillés représentent l'évolution de $V_-$ en l'absence de commutation de $V_s$ pour aider la visualisation.
]

#question(
    coups-de-pouce: (
        "Déterminer la demi-période, c'est-à-dire le temps nécessaire pour que $V_-$ passe de $-R_2/(R_1+R_2)V_\"sat\"$ à $R_2/(R_1+R_2)V_\"sat\"$.",
        "Résoudre complètement (constante comprise) l'équation différentielle vérifiée par $V_-$ sur une demi période. On pourra appeler $t_1$ le début de cette demi-période et $t_2$ sa fin.",
    ),
)[
    Que vaut la période des signaux produits ?
][
    Sur la première demi-période (au moment du premier basculement à $V_s=-V_"sat"$, avec $V_-(T/2)=R_2/(R_1+R_2) V_"sat"$) :
    $
        V_-(t) = V_"sat" - (V_"sat"+R_2/(R_1+R_2) V_"sat") exp(-(t-t_1)/(R_3 C))
    $
    La condition $V_-(T/2)=R_2/(R_1+R_2) V_"sat"$ donne
    $
        R_2/(R_1+R_2) V_"sat" = V_"sat" - (V_"sat"+R_2/(R_1+R_2) V_"sat") exp(-(t_2-t_1)/(R_3 C))
    $
    $
        exp(-(t_2-t_1)/(R_3 C)) = (V_"sat"-R_2/(R_1+R_2) V_"sat")/(V_"sat"+R_2/(R_1+R_2) V_"sat")
    $
    $
        t_2-t_1 = R_3 C ln((V_"sat"+R_2/(R_1+R_2) V_"sat")/(V_"sat"-R_2/(R_1+R_2) V_"sat"))
    $
    Avec $R_2/(R_1+R_2) V_"sat" = R_2/(R_1+R_2) V_"sat"$, on a $V_"sat"+R_2/(R_1+R_2) V_"sat" = (R_1+2R_2)/(R_1+R_2)V_"sat"$ et $V_"sat"-R_2/(R_1+R_2) V_"sat"=R_1/(R_1+R_2)V_"sat"$, d'où
    $
        t_2-t_1 = R_3 C ln(1+2R_2/R_1)
    $
    Par symétrie, la demi-période suivante dure autant, donc la période des signaux vaut
    $
        T = 2 R_3 C ln(1+2 R_2/R_1)
    $
    #let R1 = 100e3
    #let R2 = 10e3
    #let R3 = 10e3
    #let C = 10e-9
    #let T = 2 * R3 * C * calc.ln(1 + 2 * R2 / R1)
    Application numérique : $T = #qty(scientifique(T, 2), "s") approx #qty(scientifique(T * 1e6, 2), "us")$.
]
