#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Oscillateur RLC",
    difficulté: 1,
)

Dans le montage ci-dessous, le générateur impose une tension $U$ proportionnelle au courant $i$ qui le traverse. On note $alpha$ le coefficient de proportionnalité, de sorte que $u=alpha i$.

#figure(
    zap.circuit({
        import zap: *
        vsource("u", (0, -3), (0, 0), u: $u$, i: $i$)
        resistor("R", (0, 0), (3, 0), label: (content: $R$))
        capacitor("C", (3, 0), (3, -3), label: $C$)
        inductor("L", (3, -3), (0, -3), label: (content: $L$, anchor: "south"))
    }),
)

#question(
    coups-de-pouce: (
        "Il peut être plus simple de passer par le domaine fréquentiel avant de revenir au domaine temporel.",
        "Écrire la loi des mailles dans le domaine fréquentiel.",
    ),
)[
    Établir l'équation différentielle vérifiée par le courant $i$.
][
    Si on passe en complexes, on a le circuit suivant
    #figure(
        zap.circuit({
            import zap: *
            vsource("u", (0, -3), (0, 0), u: $u$, i: $i$)
            resistor("R", (0, 0), (3, 0), label: (content: $R$))
            resistor("C", (3, 0), (3, -3), label: $1/(j C omega)$)
            resistor("L", (3, -3), (0, -3), label: (content: $j L omega$, anchor: "south"))
        }),
    )
    La loi des mailles s'écrit alors
    $
      underline(u) - R underline(i) - 1/(j C omega) underline(i) - j L omega underline(i) = 0
    $
    soit, en multipliant par $j C omega$,
    $
      j C omega underline(u) - j R C omega underline(i) - underline(i) - L C (j omega)^2 underline(i) = 0
    $
    or $underline(u) = alpha underline(i)$, on a donc
    $
      j C omega alpha underline(i) - j R C omega underline(i) - underline(i) - L C (j omega)^2 underline(i) = 0
    $
    $
      j (R - alpha) C omega underline(i) + underline(i) + L C (j omega)^2 underline(i) = 0
    $

    ce qui donne en revenant au domaine temporel
    $
        L C dv(i,t,2) + (R - alpha) C dv(i,t) + i = 0
    $
]

#question()[
    À quelle condition sur $alpha$ le système est-il stable ?
][
    Le système est stable si le coefficient de $dv(i,t)$ est positif, c'est-à-dire si $alpha < R$.
]