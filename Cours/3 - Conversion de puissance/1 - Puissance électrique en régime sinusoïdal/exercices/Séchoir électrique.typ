#import "@local/prepa:0.1.0": *

#show: exercice.with(
    titre: "Séchoir électrique",
    difficulté: 1,
)

Le circuit d'alimentation d'un séchoir électrique est composé d'une résistance $R$ branchée en parallèle avec une branche comprenant une bobine d'inductance $L$ et d'une résistance $r$. Le circuit est alimenté avec le secteur (#qty("230", "V") efficace, #qty("50", "Hz")). Le séchoir admet 3 modes de fonctionnement : mode froid F, mode I et mode II. On donne le tableau suivant :

#figure[
    #table(
        columns: (auto, auto, auto, auto),
        align: (left, center, center, center),
        table.header([Mode], [F], [I], [II]),
        [Puissance moyenne absorbée (#unit("W"))], num("520"), num("2800"), num("10000"),
        [Déphasage de la tension par rapport au courant total], $phi_"F"$, $phi_"I"$, $phi_"II"=qty("5", "deg")$,
        $R$, $infinity$, $R_"I"$, $R_"II"$,
    )
]

#question(
    coups-de-pouce: (),
)[
    Faire le schéma du montage.
][
    #figure(
        zap.circuit({
            import zap: *

            resistor("R", (-2, 0), (2, 0), label: "R")
            resistor("r", (-2, 1), (0, 1), label: "r")
            inductor("L", (0, 1), (2, 1), variant: "ieee", label: "L")
            vsource("V", (2, -1), (-2, -1), u: "")
            wire("V.out", "R.in")
            wire("R.out", "V.in")
            wire("V.out", "r.in")
            wire("r.out", "L.in")
            wire("L.out", "V.in")
        }),
    )
]

#question(
    coups-de-pouce: (
        "Le séchoir est-il un dipole inductif ou capacitif ? Le courant est-il en avance ou en retard sur la tension ?",
    ),
)[
    Tracer les chronogrammes de $u(t)$ et $i(t)$ pour les trois modes de fonctionnement, $i(t)$ représentant le courant total.
][
    Quel que soit le mode, le dipole global est inductif. Le courant sera donc en retard sur la tension.

    Plus $R$ est grand, moins de courant y passe dont plus l'amplitude du courant est faible.

    Difficile de justifier les phases pour l'instant, on le fera plus tard dans l'exercice.
    #figure(
        cetz.canvas({
            let f(S: 0, t, phi: 0) = S * calc.cos(2 * calc.pi * t + phi)
            plot.plot(
                size: (8, 4),
                x-tick-step: none,
                y-tick-step: none,
                x-label: $t$,
                y-label: [$u(t)$ et $i(t)$],
                axis-style: "school-book",
                {
                    plot.add(domain: (0, 2), f.with(S: 2, phi: 0), label: $u$)
                    plot.add(domain: (0, 2), f.with(S: 2.5, phi: -0.5), label: $i_"II"$)
                    plot.add(domain: (0, 2), f.with(S: 1.5, phi: -1), label: $i_"I"$)
                    plot.add(domain: (0, 2), f.with(S: 1, phi: -1.5), label: $i_"F"$)
                },
            )
        }),
    )
]

#question(
    coups-de-pouce: (
        "Quelle puissance est consommée par $R$ dans les modes I et II ?",
        "La puissance consommée par $r$ et $L$ dépend-elle du mode ?",
        "Quelle relation relie puissance reçue et tension efficace pour un résistor ?",
    ),
)[
    Déterminer $R_"I"$ et $R_"II"$, et les calculer numériquement.
][
    $P_"moteur" = P_"F" = qty("520", "W")$ donc $P_(R_"I") = P_"I" - P_"F" = qty("2800", "W") - qty("520", "W") = qty("2280", "W")$.

    Or $P_(R_"I") = U_"eff"^2/R_"I"$. Donc $R_"I" = U_"eff"^2/P_(R_"I") = (qty("230", "V"))^2/qty("2280", "W") approx qty("23", "ohm")$.

    De même, $P_(R_"II") = P_"II" - P_"F" = qty("10000", "W") - qty("520", "W") = qty("9480", "W")$.

    Or $P_(R_"II") = U_"eff"^2/R_"II"$. Donc $R_"II" = U_"eff"^2/P_(R_"II") = (qty("230", "V"))^2/qty("9480", "W") approx qty("5.6", "ohm")$.
]

#question(
    coups-de-pouce: (
        "Représenter $underline(Z)$ l'impédance équivalente de $r$ et $L$, sur un diagramme de Fresnel. En déduire une relation entre le facteur de puissance, $r$, $L$ et $omega$.",
        "Comment la puissance moyenne reçue par $r$ et $L$ s'exprime-t-elle en fonction du facteur de puissance ?",
    ),
)[
    En utilisant le mode $F$, montrer que $(L omega)^2+r^2=102r$.
][
    $ P_"F" = U_"eff" I_"F" cos phi_"F" $ avec $ |underline(Z)_"F"| = |underline(u)/underline(i)| = U_"eff"/I_"F" $ donc $ P_"F" = U_"eff"^2/(|underline(Z)_"F"|) cos phi_"F" $

    #figure[
        #canvas({
            import draw: *
            // Axes
            line((-1, 0), (2.5, 0), mark: (end: ">>", fill: black))
            content((), anchor: "north", $Re(underline(Z))$, padding: 0.1)
            line((0, -1), (0, 2), mark: (end: ">>", fill: black))
            content((), anchor: "east", $Im(underline(Z))$, padding: 0.1)

            // Impédance
            line((0, 0), (30deg, 2), mark: (end: ">>"), stroke: red.darken(20%))
            content((), anchor: "south-west", $underline(Z)_"F"$, padding: 0.1)
            line((), (2 * calc.cos(30deg), 0), stroke: (dash: "dashed"))
            arc((1, 0), radius: 1, start: 0deg, stop: 30deg, mark: (end: ">>", fill: black), name: "phi")
            content("phi.mid", anchor: "west", $phi_"F"$, at: (15deg, 0.2), padding: 0.1)
        })
    ]
    $ cos(phi_"F") = Re(underline(Z)_"F")/(|underline(Z)_"F"|) $ or $ underline(Z)=r + j L omega $ donc $ cos(phi_"F") = r/sqrt(r^2 + (L omega)^2) $

    On a donc $ P_"F" = U_"eff"^2 Re(underline(Z)_"F")/(|underline(Z)_"F"^2|)=U_"eff"^2 r/(r^2 + (L omega)^2) $ et finalement
    $ (L omega)^2 + r^2 = U_"eff"^2 r/P_"F" = (qty("230", "V"))^2/qty("520", "W") r approx 102 r $
]

#question(
    coups-de-pouce: (
        "Exprimer l'impédance équivalente totale en fonction de $r$, $L$ et $R$.",
        "Représenter l'impédance équivalente totale sur un diagramme de Fresnel.",
    ),
)[
    Montrer que $tan phi = (L omega R)/(R r+r^2+L^2 omega^2)$.
][
    $
        underline(Z)_"éq" & = ((r+j L omega)R)/(r + R + j L omega) \
                          & = ((r + j L omega) R(r+R-j L omega))/((r + R + j L omega)(r+R-j L omega)) \
                          & = (R(r^2 + r R + L^2 omega^2) + j L omega R^2)/( (r + R)^2 + (L omega)^2 ) \
    $
    On a donc
    $
        tan phi & = Im(underline(Z)_"éq")/Re(underline(Z)_"éq") \
                & = (L omega R^2)/(R(r^2 + r R + L^2 omega^2)) \
                & = (L omega R)/(r^2 + r R + L^2 omega^2) \
    $
]

#question(
    coups-de-pouce: (
        "Exprimer $tan phi$ dans les modes II et F et utiliser $L omega^2 + r^2 = 102r$.",
    ),
)[
    Calculer $phi_"F"$ puis $phi_"I"$.
][
    On utilise la connaissance de $phi_"II"$ pour calculer les autres.
    $ tan(phi_"II") = (L omega R_"II")/(R_"II" r + 102r) $
    On en déduit
    $ (L omega)/r = (R_"II" + 102)/R_"II" tan(phi_"II") $

    On a alors
    $ tan(phi_"F") = (L omega)/r = (R_"II" + 102)/R_"II" tan(phi_"II") $
    d'où $ phi_"F" = arctan((R_"II" + 102)/R_"II" tan(phi_"II")) = qty("59", "deg") $

    Et
    $ tan(phi_"I") = (L omega)/r (R_"I")/(R_"I" + 102) = (R_"II"+102)/(R_"II") tan(phi_"II") R_"I"/(R_"I" + 102) $

    d'où $ phi_"I" = arctan((R_"II"+102)/(R_"II") tan(phi_"II") R_"I"/(R_"I" + 102)) = qty("17", "deg") $
]
