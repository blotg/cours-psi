#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Câble coaxial et pertes résistives",
)

Les pertes dans un câble coaxial sont prises en compte en considérant la résistance linéique $r$ du conducteur et la conductance linéique $g$ de l'isolant séparant l'âme et la gaine. Le modèle à constantes réparties correspondant est représenté sur le schéma ci-dessous correspondant à une portion de câble de longueur $dd(x)$.

#figure(
    zap.circuit({
        import zap: *
        import cetz.draw: *
        resistor("r", (0, 0), (2.5, 0), label: $r dd(x)$)
        inductor("L", (2.5, 0), (5, 0), label: $Lambda dd(x)$, variant: "ieee")
        resistor("g", (5, 0), (5, -2.5), label: $1/(g dd(x))$)
        capacitor("C", (7, 0), (7, -2.5), label: $Gamma dd(x)$)
        fil((5, 0), (9, 0), i: (content: $i(x+dd(x),t)$, position: 3))
        wire((0, -2.5), (9, -2.5))
        fil((-1, 0), (0, 0), i: (content: $i(x,t)$, position: 0.8))
        wire((-1, -2.5), (0, -2.5))
        line((-.8, -.1), (-.8, -2.4), mark: (start: ">>", fill: black), name: "u(x)")
        content("u(x)", $u(x,t)$, anchor: "east", padding: .4em)
        line((8.8, -.1), (8.8, -2.4), mark: (start: ">>", fill: black), name: "u(x+dd(x))")
        content("u(x+dd(x))", $u(x+dd(x),t)$, anchor: "west", padding: .4em)
    }),
)

#question(
    coups-de-pouce: (
        "Appliquer la loi des nœuds."
    ),
)[
    Établir une relation entre $u(x,t)$, $i(x,t)$ faisant intervenir $Gamma$ et $g$.
][
    La loi des nœuds s'écrit
    $
        i(x,t) = i(x+dd(x),t) + g dd(x) u + Gamma dd(x) pdv(u, t)
    $
    En utilisant la relation de Taylor, on obtient
    $
        pdv(i, x) = -g u - Gamma pdv(u, t)
    $
]

#question(
    coups-de-pouce: (
        "Appliquer la loi des mailles."
    ),
)[
    Établir une relation entre $u(x,t)$, $i(x,t)$ faisant intervenir $Lambda$ et $r$.
][
    La loi des mailles s'écrit
    $
        u(x,t) - r dd(x) i - Lambda dd(x) pdv(i, t) - u(x+dd(x),t) = 0
    $
    En utilisant la relation de Taylor, on obtient
    $
        pdv(u, x) = -r i - Lambda pdv(i, t)
    $
]

#question(
    coups-de-pouce: (
        "Il faut combiner les équations des question précédentes.",
        "Dériver l'équation de la question 1 par rapport à $t$ et celle de la question 2 par rapport à $x$. Appliquer le théorème de Schwarz.",
    ),
)[
    En déduire que $u(x,t)$ satisfait à l'équation dite des télégraphistes
    $ pdv(u, x, 2)-alpha pdv(u, t, 2) - beta pdv(u, t) - mu u(x,t)=0 $
    Préciser l'expression de $alpha$, $beta$, et $mu$ en fonction des paramètres de l'énoncé. On admet que $i$ obéit à la même équation.
][
    Si on dérive l'équation de la question 1 par rapport à $t$ et celle de la question 2 par rapport à $x$, on obtient
    $
        cases(
            pdv(i, t, x) = -g pdv(u, t) - Gamma pdv(u, t, 2),
            pdv(u, x, 2) = -r pdv(i, x) - Lambda pdv(i, x, t)
        )
    $
    Or, d'après le théorème de Schwarz, $pdv(i, t, x) = pdv(i, x, t)$, d'où
    $
        pdv(u, x, 2) & = -r(-g u - Gamma pdv(u, t)) - Lambda (-g pdv(u, t) - Gamma pdv(u, t, 2)) \
                     & = Lambda Gamma pdv(u, t, 2) + (r Gamma + g Lambda) pdv(u, t) + r g u
    $
    soit
    $
        pdv(u, x, 2) - Lambda Gamma pdv(u, t, 2) - (r Gamma + g Lambda) pdv(u, t) - r g u = 0
    $
    On trouve ainsi $alpha = Lambda Gamma$, $beta = r Gamma + g Lambda$ et $mu = r g$.
]

#question(
    coups-de-pouce: "Passer en complexe l'équation d'onde de la question précédente.",
)[
    On considère une onde qui se propage dans le sens de $x$ croissants : $underline(u)^+(x,t) = underline(u)_0^+ e^(j(omega t-underline(k) x))$. Établir l'équation de dispersion.
][
    En injectant l'OPPH dans l'équation des télégraphistes, on trouve que $underline(k)$ doit vérifier l'équation de dispersion suivante :
    $
        - underline(k)^2 + alpha omega^2 - j beta omega - mu = 0
    $
    Soit
    $
        underline(k)^2 = alpha omega^2 - j beta omega - mu
    $
]

#question()[
    On pose $underline(k)=k'+j k''$. Qu'implique le fait que $underline(k)$ soit complexe ?
][
    La partie imaginaire de $underline(k)$ entraine une décroissance exponentielle de l'amplitude de l'onde au cours de la propagation, ce qui correspond à des pertes résistives dans le câble coaxial.
]

#question(
    coups-de-pouce: (
        "Dans l'hypothèse de l'énoncé, que peut-on dire sur $k'$ et $k''$ ?",
        "Développer $underline(k)^2 = (k' + j k'')^2$. Quel terme peut être négligé dans l'hypothèse de l'énoncé ?",
    ),
)[
    On suppose les pertes faibles et donc la profondeur de peau très grande devant la longueur d'onde. Résoudre l'équation de dispersion dans ce cas et exprimer $k'$ et $k''$ en fonction de $alpha$, $beta$, $mu$ et $omega$.
][
    Si la profondeur de peau $delta=1/k''$ est très grande devant la longueur d'onde $lambda = (2 pi)/k'$, alors $k''$ est très petit devant $k'$.
    $
        underline(k)^2 = (k'+j k'')^2 = k'^2 + 2 j k' k'' - k''^2 approx k'^2 + 2 j k' k''
    $
    On peut alors identifier
    $
        cases(
            k'^2 = alpha omega^2 - mu,
            2 k' k'' = -beta omega
        )
    $
    d'où
    $
        cases(
            k' = sqrt(alpha omega^2 - mu),
            k'' = -beta omega / (2 k') = -beta omega / (2 sqrt(alpha omega^2 - mu))
        )
    $
]

#question()[
    Exprimer la vitesse de phase et la vitesse de groupe en fonction de $omega$ et des constantes $alpha$, $beta$, et $mu$. Le milieu est-il dispersif ?
][
    La vitesse de phase est donnée par
    $v_phi = omega / k' = omega / sqrt(alpha omega^2 - mu)$

    La vitesse de phase dépend de la pulsation $omega$, ce qui signifie que le milieu est dispersif.

    La vitesse de groupe est donnée par
    $
        v_g = dv(omega, k') = 1/dv(k', omega) = 1 / ((2 alpha omega) / (2 sqrt(alpha omega^2 - mu))) = sqrt(alpha omega^2 - mu) / (alpha omega)
    $
]
