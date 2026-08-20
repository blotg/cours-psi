#import "@local/prepa:0.1.0": *
#show: exercice.with(
    titre: "Etude graphique d'un cycle d'hystérésis",
)

Un matériau ferromagnétique est destiné à réaliser la carcasse d'un transformateur. On se propose de visualiser le cycle d'hystérésis de ce matériau sur un écran d'oscilloscope c'est-à-dire la courbe $B(H)$ où $B$ et $H$ représentent les valeurs algébriques de $va(B)$ et $va(H)$. Pour cela, on réalise le montage suivant.

#figure[
    #zap.circuit({
        import zap: *
        import draw: *

        transformateur("transfo", (0, 0))
        vsource("e", (-4, -1), (-4, 1), u: $e$)
        resistor("R0", "transfo.P-", "e.in", label: $R_0$)
        wire("e.out", "transfo.P+", i: $i_1$)
        capacitor("C", (4, -1), (4, 1))
        resistor("R", "transfo.S+", "C.out", label: $R$)
        wire("transfo.S-", "C.in", i: $i_2$)
        frame("G", "e.in")
        frame("D", "C.in")
        vcc("voie-x", "C.out", label: $y$)
        vee("voie-y", "transfo.P-", label: $x$)
        line((-1.5, -.9), (-1.5, 0.9), mark: (end: ">", fill: black), name: "u1", stroke: 0.6pt)
        content("u1.mid", $u_1$, anchor: "east", padding: 0.1)
        line((1.5, -.9), (1.5, 0.9), mark: (end: ">", fill: black), name: "u2", stroke: 0.6pt)
        content("u2.mid", $u_2$, anchor: "west", padding: 0.1)
    })
]

Sur le noyau ferromagnétique de forme torique, de section S, de circonférence moyenne $l$ ($l^2 >> S$), on enroule $n_1$ spires constituant l'enroulement primaire et $n_2$ spires constituant l'enroulement secondaire.

#let fréquence = 50
#let pulsation = 2 * calc.pi * fréquence
Le générateur de f.é.m. $e(t) = E cos(omega t)$ est une source de tension sinusoïdale de fréquence $f = qty("50", "Hz")$.

#let R = 1e5
La résistance $R = #qty(scientifique(R, 2), "O")$ est telle que le produit $n_2i_2$ est négligeable devant le produit $n_1i_1$.

#question(
    coups-de-pouce: (
        "Prendre sous les yeux la simulation des lignes de champ dans un circuit magnétique sans entrefer (chapitre électromagnétisme 4).",
        "A quels endroits ont lieu les fuites de ligne de champ ?",
    ),
)[
    Pourquoi est-il judicieux de choisir un tore ?
][
    Le tore est une forme régulière sans angle vif, ce qui limite les fuites de lignes de champ magnétique à l'extérieur du noyau.
]

#question(
    coups-de-pouce: (
        "Exprimer la fonction de transfert du filtre RC.",
        "A quelle condition la fonction de transfert du filtre RC correspond-elle à un intégrateur ?",
    ),
)[
    Dans ce montage, le circuit $R C$ (entrée $u_2$, sortie $v_y$) fonctionne en intégrateur. Quelle condition la capacité $C$ doit-elle satisfaire pour cela ? Quelle(s) valeur(s) peut-on choisir pour $C$ parmi les valeurs usuelles suivantes : $qty("10", "nF"), qty("47", "nF"), qty("100", "nF"), qty("1", "uF")$ et $qty("4.7", "uF")$ ?
][
    $ underline(H)=1/(j C omega)/(R + 1/(j C omega)) = 1/(j C omega R + 1) $
    $underline(H) approx 1/(j C omega R)$ si $C omega R >> 1$. Donc $C >> 1/(omega R) = 1/(2 pi f R) approx #qty(scientifique(1 / (pulsation * R), 2), "F")$. Parmi les valeurs proposées, on peut choisir $C = qty("1", "uF")$ ou $C = qty("4.7", "uF")$.
]

#question(
    coups-de-pouce: (
        "Relier $H$ au courant $i_1$. Relier $i_1$ à $v_x$.",
        "Appliquer le théorème d'Ampère sur une ligne de champ moyenne.",
    ),
)[
    Exprimer $H$ en fonction de $v_x$.
][
    $ v_x = R_0 i_1 $
    Le théorème d'Ampère appliqué sur une ligne de champ moyenne dans le tore donne : $integral.cont va(H) dprod va(dd(l)) = n_1 i_1 = n_2 i_2$ soit $H l = n_1 i_1$ donc $ H = n_1 i_1 / l = n_1 / (R_0 l) v_x $
]

#question(
    coups-de-pouce: (
        "Énoncer la loi de Lens-Faraday pour l'enroulement secondaire.",
    ),
)[
    Exprimer $B$ en fonction de $v_y$ et expliquer pourquoi le montage permet de visualiser le cycle d'hystérésis.
][
    $ u_2 = dv(Phi, t) = n_2 S dv(B, t) $
    Or la tension $y$ à la sortie de l'intégrateur s'écrit
    $v_y = 1/(R C) integral_0^t u_2(x) dd(x) = (n_2 S)/(R C)$
    $ B=(R C)/(n_2 S) v_y $

    $v_x$ est proportionnel à $H$ et $v_y$ est proportionnel à $B$, le montage permet donc de visualiser le cycle d'hystérésis $B(H)$ sur l'oscilloscope en se plaçant en mode XY.
]

#let l = 50e-2
#let S = 20e-4
#let C = 1e-6
#let R0 = 5
#let n1 = 50
#let n2 = 50
Dans toute la suite, on prendra $l = qty("50", "cm")$, $S = qty("20", "cm^2")$, $C = qty("1", "uF")$, $R_0 = qty("5", "O")$ et $n_1 = n_2 = 50$ pour les applications numériques.

#let CB = (R * C) / (n2 * S)
#let CH = n1 / (l * R0)
#question(
    coups-de-pouce: (
        "Il s'agit de faire l'application numérique des coefficients de proportionnalité entre $H$ et $v_x$ et entre $B$ et $v_y$.",
    ),
)[
    Calculer, en précisant les unités, les coefficients de proportionnalité entre $H$ et $v_x$ puis entre $B$ et $v_y$.
][
    $n_1/(l R_0) = #qty(scientifique(CH, 2), "A/m/V")$

    $(R C)/(n_2 S) = #qty(scientifique(CB, 1), "T/V")$
]

On obtient l'oscillogramme suivant. $v_x$ est en ordonnée (1 graduation représente #qty("2", "V")). $v_y$ est en abscisse (1 graduation représente #qty("1", "V")).

#figure(image("../figures/hysteresis.png", width: 10cm))

#let mu0 = 4e-7 * calc.pi

#question(
    coups-de-pouce: (
        "Lire graphiquement les tensions $v_x$ et $v_y$ correspondant au champ rémanent et à l'excitation coercitive puis les convertir avec les résultats de la question précédente.",
    ),
)[
    Déduire de cet oscillogramme les valeurs approximatives du champ magnétique rémanent $B_r$, de l'aimantation rémanente $M_r$ et du champ coercitif $H_c$.
][
    Le champ magnétique rémanent est à #num("1.3") carreaux, soit $v_y = #qty("1.3", "V")$ et donc $B_r = #qty(scientifique(CB * 1.3, 1), "T")$.

    L'excitation coercitive est à #num("0.5") carreaux, soit $v_x = #qty("1", "V")$ et donc $H_c = #qty(scientifique(CH * 1, 2), "A/m")$.

    $M = B/mu_0 - H$ d'où $M_r = B/mu_0 = #qty(scientifique(CB * 1.3 / mu0, 1), "A/m")$
]

Dans le schéma du montage, on peut raisonnablement négliger la puissance dissipée par effet Joule dans les enroulements primaire et secondaire. Pour simplifier, on suppose également négligeables les pertes dues aux courants de Foucault dans le tore. Dans ces conditions, la puissance $p_H = u_1i_1$ dissipée est uniquement due aux propriétés ferromagnétiques du noyau.

#question(
    coups-de-pouce: (
        "La démo a été vue en cours.",
    ),
)[
    Établir la relation liant $P_H$, valeur moyenne de $p_H (t)$, à l'aire $cal(A)$ du cycle d'hystérésis représentant l'évolution de $B$ en fonction de $H$.
][
    Démo de cours : $P_H = V f cal(A)$.
]

#question(
    coups-de-pouce: (
        "Utiliser les relations des questions précédentes pour convertir l'aire en carreaux en #unit(\"V^2\") puis en #unit(\"A/m T\").",
    ),
)[
    Sur l'oscillogramme, on évalue l'aire du cycle à 6 carreaux. En déduire la valeur de la puissance moyenne $P_H$ dissipée à cause du phénomène d'hystérésis dans l'ensemble du tore dans l'essai réalisé.
][
    1 carreau correspond à une aire sur le cycle d'hystérésis de #qty("2", "V^2").

    #qty("1", "V^2") correspond à une aire $(R C)/(n_2 S) n_1/(l R_0)$.

    Finalement, $cal(A) = 6 times 2 times num(#scientifique(CH, 2)) times #num(scientifique(CB, 2)) = qty(#scientifique(12 * CH * CB, 1), "A/m T")$.
]

#question(
    coups-de-pouce: (
        "L'aire du cycle d'hystérésis doit-elle être faible ou importante pour réduire les pertes ?",
    ),
)[
    A-t-on intérêt pour la fabrication des transformateurs à utiliser un matériau ferromagnétique ayant un champ coercitif important ou faible au contraire ? Justifier
][
    On veut une aire la plus petite possible, donc un matériau doux.
]
