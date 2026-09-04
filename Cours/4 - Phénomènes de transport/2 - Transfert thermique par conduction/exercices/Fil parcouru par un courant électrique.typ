#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Fil parcouru par un courant électrique",
)

Un fil de rayon $R$, de longueur infinie, de conductivité thermique $lambda$, de conductivité électrique $gamma$, de capacité thermique massique $c$, de masse volumique $mu$ est parcouru par un courant électrique constant et uniforme d'intensité $I$.

On note $va(j_"élec")$ le vecteur densité de courant électrique et $va(j_Q)$ le vecteur densité de courant thermique.

On suppose que la température ne dépend que de $r$ et que le potentiel que de $z$.

On se placera en coordonnées cylindriques et on supposera le régime stationnaire.

// \begin{center}
// \begin{tikzpicture}
// \draw[fill=lightgray] (0,0) circle (1.5);
// \draw[->,>=latex] (0,0) -- (0,1.5) node[midway,left] {$R$};
// \draw[->,>=latex] (0,0) -- (45:0.75) node[midway,below right] {$r$};
// \draw (0,-0.75) node {Métal};
// \draw (0,-2) node {Air};
// \draw[->] (2,0) -- (3,0) node[below] {$\vv{e_r}$};
// \draw[->] (2,0) -- (2,1) node[left] {$\vv{e_\theta}$};
// \draw[fill=white] (2,0) circle (0.1);
// \draw[fill=black] (2,0) circle (0.05);
// \draw (2,0) node[below] {$\vv{e_z}$};
// \end{tikzpicture}
// \end{center}

#figure(
    canvas({
        import cetz.draw: *
        circle((0, 0), radius: 1, fill: black.lighten(70%))
        line((0, 1), (10, 1))
        line((0, -1), (10, -1))
        line((0, -1.5), (rel: (0, -1)), mark: (end: ">>", fill: black))
        content((), $er$, anchor: "north", padding: .4em)
        line((0, -1.5), (rel: (1, 0)), mark: (end: ">>", fill: black))
        content((), $ez$, anchor: "west", padding: .4em)
    }),
)


#question(
    coups-de-pouce: (
        "Utiliser la loi de Fourier et la loi d'Ohm locale.",
    ),
)[
    Dans quelle direction de déplace les charges ? Même question pour la chaleur.
][
    $j_"élec" = - gamma grad V$. Comme $V$ ne dépend que de $z$, $va(j_"élec")$ est dirigé selon $ez$.

    $j_Q = - lambda grad T$. Comme $T$ ne dépend que de $r$, $va(j_Q)$ est dirigé selon $er$.
]

#question(
    coups-de-pouce: (
        "Faire un bilan d'énergie sur un cylindre creux ou un volume infinitésimal.",
    ),
)[
    Établir l'équation de la diffusion thermique en prenant en compte la puissance produite par effet Joule.
][
    En régime stationnaire, le premier principe de la thermodynamique sur un cylindre creux de rayon intérieur $r$ et extérieur $r + dd(r)$ de longueur $L$ donne :

    $
        dd(U, 2) + cancel(dd(E_c, 2)) = cancel(delta^2 W) + delta^2 Q
    $

    $
        mu (u(t+dd(t)) - u(t))dd(V) = integral.double_(S_r) va(j_Q) dot va(dd(S_r))dd(t) + integral.double_(S_(r+dd(r))) va(j_Q) dot va(dd(S)_(r+dd(r)))dd(t) + va(j_"élec").va(E) dd(V)dd(t)
    $

    $
        mu pdv(u, t)dd(t)2 pi r dd(r) L = j_Q (r) 2 pi r L dd(t) - j_Q (r + dd(r)) 2 pi (r + dd(r)) L dd(t) + j_"élec"^2/gamma 2 pi r dd(r) L dd(t)
    $

    En notant $f: r arrow.bar j_Q (r) r$ et en utilisant la relation de Taylor, on obtient :

    $
        mu pdv(u, t) 2 pi r dd(r) L = -pdv(f, r) dd(r) 2 pi L + j_"élec"^2/gamma 2 pi r dd(r) L
    $
    soit
    $
        mu pdv(u, t) + 1/r pdv(r j_Q (r), r) = j_"élec"^2/gamma
    $

    On utilise la loi de Fourier et l'équation calorique :

    $
        mu c pdv(T, t)- lambda 1/r pdv(r pdv(T, r), r) = j_"élec"^2/gamma
    $

    Soit, sous forme canonique :
    $
        pdv(T, t) - D_"th" 1/r pdv(r pdv(T, r), r) = j_"élec"^2/(gamma mu c)
    $
    avec $D_"th" = lambda/(mu c)$.
]

#question(
    coups-de-pouce: (
        "Utiliser comme condition aux limites le fait que $j$ et $T$ ne divergent pas en $0$.",
    ),
)[
    Intégrer l'équation de diffusion en régime stationnaire et pour une température extérieure du fil $T_0$ connue. Tracer $T(r)$.
][
    En régime stationnaire, l'équation de diffusion s'écrit :

    $
        pdv(r pdv(T, r), r) = - r j_"élec"^2/(lambda gamma)
    $

    On intègre  :

    $
        r pdv(T, r) = -r^2/2 j_"élec"^2/(lambda gamma) + C_1
    $

    $
        pdv(T, r) = -r/2 j_"élec"^2/(lambda gamma) + C_1/r
    $

    $
        T(r) = - r^2/4 j_"élec"^2/(lambda gamma) + C_1 ln(r) + C_2
    $

    Pour que $T(r)$ ne diverge pas en $0$, il faut que $C_1 = 0$.

    En utilisant la condition aux limites $T(R) = T_0$, on trouve :

    $
        T(r) = T_0 + j_"élec"^2/(4 lambda gamma) (R^2 - r^2)
    $

    #figure(
        canvas({
            import plot: *
            let K = 1
            let R = 1
            let T0 = 20
            let T(r) = T0 + K * (R * R - r * r)
            plot(
                size: (6, 4),
                x-tick-step: none,
                y-tick-step: none,
                x-ticks: (0, (R, $R$)),
                y-ticks: ((T0, $T_0$), (T(0), $T_0 + j_"élec"^2/(4 lambda gamma) R^2$)),
                y-min: T0 - .2,
                axis-style: "school-book",
                x-label: "r",
                y-label: "T(r)",
                {
                    add(T, domain: (0, R))
                },
            )
        }),
    )
]

#question(
    coups-de-pouce: (),
)[
    Intégrer l'équation de diffusion en régime stationnaire et avec comme condition aux limites la loi de Newton : $va(j_Q) = h (T(R)-T_"air") va(e)$ où $va(e)$ est un vecteur unitaire dirigé vers l'extérieur du fil. Calculer la température de surface du fil et la température maximale atteinte en son sein.
][
    La solution est là-encore de la forme $T(r) = -r^2/4 j_"élec"^2/(lambda gamma) + C_2$.

    $
        va(j_Q) = - lambda grad T = lambda r/2 j_"élec"^2/(lambda gamma) er
    $

    Il y a continuité de $va(j_Q)$ en $r = R$ :
    $
        lambda R/2 j_"élec"^2/(lambda gamma) er = h(-R^2/4 j_"élec"^2/(lambda gamma) + C_2 - T_"air") er
    $

    d'où
    $
        C_2 = T_"air" + j_"élec"^2/(lambda gamma) (R^2/4 + lambda R/(2 h))
    $

    La température maximale est atteinte en $r = 0$ :
    $
        T(0) = C_2 = T_"air" + j_"élec"^2/(lambda gamma) (R^2/4 + lambda R/(2 h))
    $

    La température de surface est :
    $
        T(R) = T_"air" + lambda R/(2 h) j_"élec"^2/(lambda gamma)
    $
]
