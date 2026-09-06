#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Réflexion et transmission sur un plasma",
)

Une onde plane progressive monochromatique de pulsation $omega$, polarisée rectilignement suivant $ez$, se propage dans le sens des $x$ croissants avec le vecteur d'onde $va(k)=k ex$. Elle arrive sous incidence normale sur le plasma de densité électronique $N$. L'interface vide-plasma a pour équation $x=0$, le plasma occupe le demi-espace $x>0$.

On étudie le champ transmis $underline(va(E_t))= underline(E_(t,0))e^(i(omega t-underline(k_p) x)) ez$ dans le plasma et le champ réfléchi $underline(va(E_r))= underline(E_(r,0))e^(i(omega t+k x)) ez$ connaissant le champ incident $underline(va(E_i))= E_0 e^(i(omega t-k x)) ez$.

#figure(
    canvas({
        import cetz.draw: *
        rect((0, -2), (4, 2), fill: black.lighten(80%), stroke: none)
        line((0, -2), (0, 2))
        content((2, 1.5), "plasma")
        content((-2, 1.5), "vide")

        cetz.decorations.wave(
            line((-3, 0.5), (-0.2, 0.5)),
            amplitude: 0.5,
            segments: 4,
        )
        mark((-0.15, 0.6), 65deg, symbol: ">>", fill: black)
        content((-1.5, 0.5), $va(E_i)$, anchor: "south", padding: 0.4)

        cetz.decorations.wave(
            line((-3, -0.5), (-0.2, -0.5)),
            amplitude: 0.5,
            segments: 4,
        )
        mark((-3.05, -0.6), 180deg + 65deg, symbol: ">>", fill: black)
        content((-1.5, -0.5), $va(E_r)$, anchor: "north", padding: 0.4)

        cetz.decorations.wave(
            line((0.2, 0), (3, 0)),
            amplitude: 0.5,
            segments: 4,
        )
        mark((3.05, 0.1), 65deg, symbol: ">>", fill: black)
        content((1.5, 0), $va(E_t)$, anchor: "south", padding: 0.4)
    }),
)

#question(
    coups-de-pouce: (
        "Il s'agit d'une question de cours."
    ),
)[
    Déterminer la conductivité complexe du plasma $underline(gamma)$ à la pulsation $omega$ en fonction de $N$, $e$, $m_e$ et $omega$.
][
    Voir le cours du chapitre Physique des ondes 2.
    $
        underline(gamma) = -i (N e^2)/(m_e omega)
    $
]

#question(
    coups-de-pouce: (
        "Utiliser l'équation de Maxwell-gauss avec l'onde transmise dans le plasma."
    ),
)[
    Montrer que la densité volumique de charges est nulle dans le plasma.
][
    Maxwell-Gauss donne
    $
        rho/epsilon_0 = div(va(E_t)) = pdv(, z) underline(E_(t,0)) e^(i(omega t - underline(k_p) x)) = 0
    $
    D'où
    $
        rho = 0
    $
]

#question(
    coups-de-pouce: (
        "Il s'agit d'une question de cours."
    ),
)[
    Établir l'équation de dispersion dans le plasma en posant $omega_p=sqrt((N e^2)/(m_e epsilon_0))$.
][
    C'est une question de cours.
    $
        underline(k_p)^2 = (omega^2 - omega_p^2)/c^2
    $
]

Dans les questions suivantes, on suppose que $omega > omega_p$.

#question()[
    En déduire l'indice optique $n$ du plasma défini par $n=c/v_phi$ où $v_phi$ est la vitesse de phase.
][
    Par définition de la vitesse de phase, on a
    $
        v_phi = omega/k_p = c/sqrt(1 - (omega_p^2)/(omega^2))
    $
    D'où
    $
        n = c/v_phi = sqrt(1 - (omega_p^2)/(omega^2))
    $
]

#question()[
    Déterminer les champs magnétiques $underline(va(B_i))$, $underline(va(B_r))$ et $underline(va(B_t))$ associés aux trois champs électriques.
][
    Les champs magnétiques peuvent être déduits des champs électriques grâce à la relation de structure :
    $
        cases(
            underline(va(B_i)) = (k ex and underline(va(E_i)))/omega = -k/omega E_0 e^(i (omega t - k x)) ey = -E_0 / c e^(i (omega t - k x)) ey,
            underline(va(B_r)) = (-k ex and underline(va(E_r)))/omega = k/omega underline(E_(r,0)) e^(i (omega t + k x)) ey = underline(E_(r,0)) / c e^(i (omega t + k x)) ey,
            underline(va(B_t)) = (k_p ex and underline(va(E_t)))/omega = -k_p/omega underline(E_(t,0)) e^(i (omega t - k_p x)) ey = -n underline(E_(t,0)) / c e^(i (omega t - k_p x)) ey,
        )
    $
]

Les champs magnétique et électrique sont continus à l'interface vide-plasma.

#question()[
    En utilisant la continuité des champs à l'interface, exprimer $underline(E_(r,0))$ et $underline(E_(t,0))$ en fonction de $E_0$ et de $n$.
][
    En utilisant la continuité du champ électrique à l'interface, on trouve
    $
        E_0 + underline(E_(r,0)) = underline(E_(t,0))
    $

    En utilisant la continuité du champ magnétique à l'interface, on trouve
    $
        -E_0 + underline(E_(r,0)) = -n underline(E_(t,0))
    $
    En combinant ces deux relations, on trouve
    $
        cases(
            underline(E_(r,0)) = (1-n)/(1+n) E_0,
            underline(E_(t,0)) = 2/(1+n) E_0,
        )
    $
]

#question()[
    Définir et déterminer les coefficients de réflexion et de transmission en puissance $R$ et $T$. Que vaut leur somme ?
][
    Les champs réels s'écrivent
    $
        cases(
            va(E_i) = Re(underline(va(E_i))) = E_0 cos(omega t - k x) ez,
            va(E_r) = Re(underline(va(E_r))) = Re((1-n)/(1+n) E_0 e^(i (omega t + k x))) ez = (1-n)/(1+n) E_0 cos(omega t + k x) ez,
            va(E_t) = Re(underline(va(E_t))) = Re(2/(1+n) E_0 e^(i (omega t - k_p x))) ez = 2/(1+n) E_0 cos(omega t - k_p x) ez,
            va(B_i) = Re(underline(va(B_i))) = -E_0 / c cos(omega t - k x) ey,
            va(B_r) = Re(underline(va(B_r))) = underline(E_(r,0)) / c cos(omega t + k x) ey = (1-n)/(1+n) E_0 / c cos(omega t + k x) ey,
            va(B_t) = Re(underline(va(B_t))) = -n underline(E_(t,0)) / c cos(omega t - k_p x) ey = -2 n / (1+n) E_0 / c cos(omega t - k_p x) ey,
        )
    $
    On peut en déduire les vecteurs de Poynting associés à chaque onde :
    $
        cases(
            va(Pi_i) = (va(E_i) and va(B_i))/mu_0 = E_0^2 / (mu_0 c) cos^2(omega t - k x) ex,
            va(Pi_r) = (va(E_r) and va(B_r))/mu_0 = ((1-n)/(1+n))^2 E_0^2 / (mu_0 c) cos^2(omega t + k x) (-ex),
            va(Pi_t) = (va(E_t) and va(B_t))/mu_0 = (4 n) / (1+n)^2 E_0^2 / (mu_0 c) cos^2(omega t - k_p x) ex,
        )
    $
    On peut alors définir les coefficients de réflexion et de transmission en puissance $R$ et $T$ par
    $
        cases(
            R = (||mean(va(Pi_r))||)/(||mean(va(Pi_i))||) = ((1-n)/(1+n))^2,
            T = (||mean(va(Pi_t))||)/(||mean(va(Pi_i))||) = (4 n) / (1+n)^2,
        )
    $
    Leur somme vaut
    $
        R + T = ((1-n)/(1+n))^2 + (4 n) / (1+n)^2 = 1
    $
    Ceci est cohérent avec la conservation de l'énergie, qui impose que la somme des coefficients de réflexion et de transmission en puissance soit égale à 1.
]

Dans toute la suite, on se place dans le cas $omega < omega_p$.

#question()[
    Déterminer le nombre d'onde complexe $underline(k_p)$ dans le plasma.
][
    La relation de dispersion a pour solution
    $
        underline(k_p) = plus.minus i sqrt((omega_p^2 - omega^2)/c^2)
    $
    En remplaçant dans l'expression du champ électrique transmis, on trouve
    $
        underline(va(E_t)) = underline(E_(t,0)) e^(i omega t) e^(plus.minus sqrt((omega_p^2 - omega^2)/c^2) x) ez
    $
    La solution $underline(k_p) = + i sqrt((omega_p^2 - omega^2)/c^2)$ correspond à une onde électromagnétique qui croît exponentiellement et diverge quand $x -> infinity$, ce qui est non physique. On choisit donc la solution $underline(k_p) = - i sqrt((omega_p^2 - omega^2)/c^2)$, qui correspond à une onde électromagnétique qui décroit exponentiellement dans le plasma.
]

#question()[
    En utilisant la continuité des champs à l'interface, exprimer $underline(E_(r,0))$ et $underline(E_(t,0))$ en fonction de $E_0$.
][
    Les champs magnétiques associés sont
    $
        cases(
            underline(va(B_i)) = -E_0 / c e^(i (omega t - k x)) ey,
            underline(va(B_r)) = underline(E_(r,0)) / c e^(i (omega t + k x)) ey,
            underline(va(B_t)) = i sqrt((omega_p^2 - omega^2)/c^2) underline(E_(t,0)) / omega e^(i omega t) e^(- sqrt((omega_p^2 - omega^2)/c^2) x) ey,
        )
    $
    En utilisant la continuité des champs électrique et magnétique à l'interface, on trouve
    $
        cases(
            E_0 + underline(E_(r,0)) = underline(E_(t,0)),
            -E_0 / c + underline(E_(r,0)) / c = i sqrt((omega_p^2 - omega^2)/c^2) / omega underline(E_(t,0))
        )
    $
    On peut en déduire
    $
        cases(
            underline(E_(r,0)) = (1 + i sqrt((omega_p^2 - omega^2)/omega^2)) / (1 - i sqrt((omega_p^2 - omega^2)/omega^2)) E_0,
            underline(E_(t,0)) = 2 / (1 - i sqrt((omega_p^2 - omega^2)/omega^2)) E_0,
        )
    $
]

#question()[
    Déterminer le coefficient de réflexion en puissance $R$ et le coefficient de transmission en puissance $T$.
][
    Notons $beta = sqrt((omega_p^2 - omega^2)/omega^2)$, réel positif, de sorte que
    $
        underline(E_(r,0)) = (1 + i beta)/(1 - i beta) E_0 quad "et" quad underline(E_(t,0)) = 2/(1 - i beta) E_0
    $

    *Coefficient de réflexion.* Les nombres $1 + i beta$ et $1 - i beta$ sont conjugués l'un de l'autre, donc de même module :
    $
        abs(underline(E_(r,0))) = abs(1 + i beta)/abs(1 - i beta) E_0 = E_0
    $
    Les ondes incidente et réfléchie ont la même amplitude et se propagent toutes deux dans le vide, leurs vecteurs de Poynting moyens ont donc la même norme :
    $
        R = (||mean(va(Pi_r))||)/(||mean(va(Pi_i))||) = 1
    $

    *Coefficient de transmission.* Dans le plasma, le champ magnétique porte un facteur $i$ par rapport au champ électrique : les deux champs sont en quadrature. En écrivant $underline(E_(t,0)) = abs(underline(E_(t,0))) e^(i phi)$, les champs réels valent
    $
        va(E_t) & = abs(underline(E_(t,0))) e^(- sqrt((omega_p^2 - omega^2)/c^2) x) cos(omega t + phi) ez \
        va(B_t) & = - sqrt((omega_p^2 - omega^2)/c^2)/omega abs(underline(E_(t,0))) e^(- sqrt((omega_p^2 - omega^2)/c^2) x) sin(omega t + phi) ey
    $
    Le vecteur de Poynting transmis est donc proportionnel à $cos(omega t + phi) sin(omega t + phi)$, de valeur moyenne nulle sur une période :
    $
        mean(va(Pi_t)) = va(0) quad "d'où" quad T = 0
    $

    Toute l'énergie de l'onde incidente est réfléchie par le plasma et aucune n'est transmise. L'onde qui pénètre dans le plasma est *évanescente* : elle décroit exponentiellement et ne transporte pas d'énergie en moyenne, exactement comme lors de la réflexion sur un métal parfait.
]
