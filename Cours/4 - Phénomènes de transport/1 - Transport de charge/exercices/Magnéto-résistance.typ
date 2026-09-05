#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Magnéto-résistance",
    difficulté: 2,
)

On considère un cylindre creux plongé dans un champ magnétique uniforme et stationnaire $va(B_0)=B_0 ez$. Le cylindre est un conducteur ohmique de conductivité $gamma$ et de potentiel $V_1$ à l'intérieur (rayon $R_1$) et $V_2 < V_1$ à l'extérieur (rayon $R_2$). Le courant total est $I$. Le champ électrique est supposé purement radial : $va(E) = E er$.

#figure(
    canvas({
        import cetz.draw: *
        projection-de-face()
        on-xy(z: 0, {
            circle((0, 0), radius: 1)
            circle((0, 0), radius: 2)
            content((0, 1), $V_1$, anchor: "east", padding: 0.4em)
            content((0, 2), $V_2$, anchor: "west", padding: 0.4em)
        })
        on-xy(z: -2, {
            circle((0, 0), radius: 1, stroke: (dash: "dashed"))
            arc((0, -2), radius: 2, start: -90deg, stop: 90deg)
            arc((0, -2), radius: 2, start: -90deg, stop: -270deg, stroke: (dash: "dashed"))
        })
        line((0, -2, 0), (0, -2, -2))
        line((0, 2, 0), (0, 2, -2))
        line((0, -1, 0), (0, -1, -2), stroke: (dash: "dashed"))
        line((0, 1, 0), (0, 1, -2), stroke: (dash: "dashed"))
        line((0, 0, -3), (0, 0, 0), stroke: (dash: "dotted"))
        line((0, 0, 0), (0, 0, 1.5), mark: (end: ">>", fill: black))
        content((0, 0, 1.5), $z$, anchor: "south", padding: 0.4em)
        line((0, 0, -2.8), (0, -1, -2.8), mark: (symbol: ">>", fill: black))
        content((0, -0.5, -2.8), $R_1$, anchor: "north", padding: 0.4em)
        line((0, 0, -2.9), (0, 2, -2.9), mark: (symbol: ">>", fill: black))
        content((0, 1, -2.9), $R_2$, anchor: "north", padding: 0.4em)
        line((0, -2.2, -2), (0, -2.2, 0), mark: (symbol: ">>", fill: black))
        content((0, -2.2, -1), $l$, anchor: "east", padding: 0.4em)
    }),
)

#question(
    coups-de-pouce: (
        "Justifier pourquoi le champ de vitesses $va(v)$ des porteurs de charges n'a pas de composante selon $z$.",
    ),
)[
    On suppose le problème invariant par translation selon $z$. En s'intéressant aux bords supérieurs du cylindre, quelle conséquence cela a-t-il sur le champ de vitesses $va(v)$ des porteurs de charges ?
][
    Les porteurs de charges ne peuvent pas avoir de composante de vitesse selon $z$, sinon ils sortiraient du cylindre.
]

On note $va(v) = v_r er + v_theta etheta$.

#question(
    coups-de-pouce: (
        "Écrire la seconde loi de Newton en régime stationnaire. Les forces sont la force de frottement fluide modélisant les chocs avec le réseau cristallin et la force de Lorentz (partie magnétique et partie électrique).",
        "Projeter la seconde loi de Newton selon $r$ et $theta$. Combiner ces équations pour isoler les composantes de $va(v)$ selon $er$ et $etheta$.",
    ),
)[
    En reprenant le modèle de Drude, déterminer l'expression de la vitesse $va(v)$ des porteurs de charges puis $va(j)$.
][
    La loi de la quantité de mouvement s'écrit, en régime stationnaire,
    $
        va(0) = -e va(E) - e va(v) and va(B_0) - m_e/tau va(v)
    $
    $
        va(0) = -e E er - e (v_r er + v_theta etheta) and B_0 ez - m_e/tau (v_r er + v_theta etheta)
    $
    $
        cases(
            -e E - e v_theta B_0 - m_e/tau v_r = 0,
            e v_r B_0 - m_e/tau v_theta = 0,
        )
    $
    En combinant ces deux équations, on trouve
    $
        cases(
            v_r = -(e m_e tau)/(m_e^2+e^2 tau^2 B_0^2) E,
            v_theta = -(e^2 tau^2 B_0)/(m_e^2 + e^2 tau^2 B_0^2) E
        )
    $
    Or $j=n (-e) v$, donc
    $
        cases(
            j_r = (n e^2 m_e tau)/(m_e^2+e^2 tau^2 B_0^2) E,
            j_theta = (n e^3 tau^2 B_0)/(m_e^2 + e^2 tau^2 B_0^2) E
        )
    $
]

#question(
    coups-de-pouce: (
        "Exprimer la circulation de $E$ puis celle de $j$ entre $R_1$ et $R_2$.",
        "Relier la composante de $va(j)$ selon $r$ à $I$.",
    ),
)[
    Déterminer l'expression de la résistance $R$ du système.
][
    $
      I = integral.double_S_r va(j) dot dd(S) er = 2 pi l r j_r (r)
    $
    $
        V_1 - V_2 = integral_(R_1)^(R_2) va(E) dot dd(r) er = integral_(R_1)^(R_2) (m_e^2 + e^2 tau^2 B_0^2)/(n e^2 m_e tau) j_r (r) dd(r)\
    = (m_e^2 + e^2 tau^2 B_0^2)/(n e^2 m_e tau) integral_(R_1)^(R_2) I/(2 pi l r) dd(r)\
    = (m_e^2 + e^2 tau^2 B_0^2)/(n e^2 m_e tau) I/(2 pi l) ln(R_2/R_1)
     = R I
    $
    Avec $ R = (m_e^2 + e^2 tau^2 B_0^2)/(n e^2 m_e tau 2 pi l) ln(R_2/R_1) $
]
