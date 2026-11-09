#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Mise à poste d'un satellite géostationnaire",
)

// GSAT-18 : lancé par Ariane 5 (VA-231) depuis Kourou le 5 octobre 2016,
// 3 404 kg au lancement, 1 480 kg à vide, mis à poste par son propre moteur
// d'apogée. Depuis l'orbite de transfert standard d'Ariane (périgée vers
// 250 km, inclinaison 6°), la circularisation demande environ 1,5 km/s.
#let G = 6.674e-11
#let MT = 5.972e24
#let RT = 6378e3
#let Ts = 86164
#let h1 = 250e3
#let r1 = RT + h1
#let r2 = calc.root(G * MT * Ts * Ts / (4 * calc.pi * calc.pi), 3)
#let v1 = calc.sqrt(G * MT / r1)
#let v2 = calc.sqrt(G * MT / r2)
#let demi-grand-axe = (r1 + r2) / 2
#let vP = calc.sqrt(2 * G * MT * r2 / (r1 * (r1 + r2)))
#let vA = calc.sqrt(2 * G * MT * r1 / (r2 * (r1 + r2)))
#let durée = calc.pi * calc.sqrt(calc.pow(demi-grand-axe, 3) / (G * MT))
#let masse = 3404
#let masse-à-vide = 1480
#let u = 3.0e3
#let ergols = masse * (1 - calc.exp(-(v2 - vA) / u))

#grid(
    columns: (1fr, auto),
    column-gutter: 1em,
    align: horizon,
    [
        En octobre 2016, une fusée Ariane 5 a lancé depuis Kourou le satellite de télécommunications GSAT-18, de masse $m = #quan[3.40 t]$, à destination de l'orbite géostationnaire. On modélise sa mise à poste par un transfert de Hohmann : depuis une orbite circulaire basse de rayon $r_1$, à l'altitude $h_1 = #quan[250 km]$, le satellite rejoint l'orbite géostationnaire, circulaire de rayon $r_2$, en parcourant une demi-ellipse tangente aux deux cercles, de périgée $P$ et d'apogée $A$. Le lanceur donne une brève poussée en $P$, le moteur du satellite une autre en $A$ ; on les assimile à des variations instantanées de la vitesse.

        On travaille dans le référentiel géocentrique, supposé galiléen. Hors des poussées, le satellite n'est soumis qu'à l'attraction de la Terre, sphérique et homogène.
    ],
    canvas({
        import cetz.draw: *
        // Pas à l'échelle : r₂ vaut en réalité 6,4 r₁.
        let (rT, ra, rb) = (0.42, 0.7, 2.1)
        let a = (ra + rb) / 2
        let b = calc.sqrt(ra * rb)
        circle((0, 0), radius: rT, fill: luma(85%), stroke: none)
        content((0, 0), text(size: 8pt)[Terre])
        circle((0, 0), radius: ra, stroke: 0.6pt)
        circle((0, 0), radius: rb, stroke: 0.6pt)
        arc(
            (ra, 0),
            start: 0deg,
            stop: 180deg,
            radius: (a, b),
            stroke: (dash: "dashed"),
        )
        mark((ra - a + a * calc.cos(100deg), b * calc.sin(100deg)), (ra - a + a * calc.cos(105deg), b * calc.sin(105deg)), symbol: ">", fill: black, scale: 0.8)
        circle((ra, 0), radius: 0.05, fill: black)
        content((ra, 0), $P$, anchor: "west", padding: 0.12)
        circle((-rb, 0), radius: 0.05, fill: black)
        content((-rb, 0), $A$, anchor: "east", padding: 0.12)
        line((ra, 0), (ra, 0.75), mark: (end: ">", fill: black))
        content((ra, 0.75), $va(v)_P$, anchor: "west", padding: 0.08)
        line((-rb, 0), (-rb, -0.45), mark: (end: ">", fill: black))
        content((-rb, -0.45), $va(v)_A$, anchor: "west", padding: 0.08)
    }),
)

Données : $cal(G) = #quan[6.674e-11 m^3/kg/s^2]$, masse de la Terre $M_T = #quan[5.972e24 kg]$, rayon équatorial $R_T = #quan[6378 km]$, jour sidéral (période de rotation de la Terre dans le référentiel géocentrique) $T_s = #quan[86164 s]$.

#question(
    coups-de-pouce: (
        "Écrire la seconde loi de Newton dans la base polaire, sur une trajectoire circulaire.",
    ),
)[
    Montrer que le mouvement d'un satellite sur une orbite circulaire de rayon $r$ est uniforme et exprimer sa vitesse $v$. Calculer la vitesse $v_1$ sur l'orbite basse.
][
    Sur un cercle de rayon $r$, l'accélération s'écrit $va(a) = -r dot(theta)^2 er + r dot.double(theta) etheta$. La seule force est l'attraction de la Terre, $va(F) = -(cal(G) M_T m)/r^2 er$. La seconde loi de Newton projetée sur $etheta$ donne $r dot.double(theta) = 0$ : la vitesse $v = r dot(theta)$ est constante. Projetée sur $er$, elle donne $m v^2 / r = (cal(G) M_T m) / r^2$, d'où
    $ v = sqrt((cal(G) M_T) / r) quad "et" quad v_1 = sqrt((cal(G) M_T) / (R_T + h_1)) = #qty(v1 / 1e3, "km/s", chiffres: 3) $
]

#question(
    coups-de-pouce: (
        "Un satellite géostationnaire tourne avec la Terre autour de l'axe des pôles. Que dire du plan de son orbite, sachant que la force qu'il subit est centrale ?",
        "Exprimer la période d'un mouvement circulaire uniforme en fonction de $r$ et $v$.",
    ),
)[
    Justifier qu'un satellite géostationnaire décrit une orbite circulaire dans le plan de l'équateur. Calculer le rayon $r_2$ de cette orbite, son altitude $h_2$ et la vitesse $v_2$ du satellite.
][
    Immobile pour un observateur terrestre, le satellite tourne avec la Terre autour de l'axe des pôles : il décrit en une période $T_s$ un cercle centré sur cet axe. La force étant centrale, le plan de ce cercle contient le centre de la Terre : c'est le plan équatorial. Le mouvement est uniforme, donc $T_s = (2 pi r_2) / v_2 = 2 pi sqrt(r_2^3 / (cal(G) M_T))$ (troisième loi de Kepler), d'où
    $ r_2 = ((cal(G) M_T T_s^2) / (4 pi^2))^(1 / 3) = #qty(r2 / 1e3, "km", chiffres: 4), quad h_2 = r_2 - R_T = #qty((r2 - RT) / 1e3, "km", chiffres: 4), quad v_2 = sqrt((cal(G) M_T) / r_2) = #qty(v2 / 1e3, "km/s", chiffres: 3) $
]

#question(
    coups-de-pouce: (
        "Le périgée et l'apogée sont les deux extrémités du grand axe.",
        "Sur une orbite elliptique, $E_m = -(cal(G) M_T m)/(2 a)$.",
        "En $P$ et en $A$, la vitesse est perpendiculaire au rayon vecteur.",
    ),
)[
    Exprimer le demi-grand axe $a$ de l'orbite de transfert. À l'aide de l'énergie mécanique, exprimer puis calculer les vitesses $v_P$ et $v_A$ du satellite en $P$ et en $A$ sur cette orbite. Vérifier que $r_1 v_P = r_2 v_A$ : quelle loi cette égalité traduit-elle ?
][
    Le périgée et l'apogée sont les extrémités du grand axe, de part et d'autre de la Terre : $2 a = r_1 + r_2$, soit $a = #qty(demi-grand-axe / 1e3, "km", chiffres: 3)$. L'énergie mécanique $E_m = -(cal(G) M_T m) / (2 a)$ se conserve, la force étant conservative. En $P$,
    $ 1 / 2 m v_P^2 - (cal(G) M_T m) / r_1 = -(cal(G) M_T m) / (r_1 + r_2) quad ==> quad v_P = sqrt((2 cal(G) M_T r_2) / (r_1 (r_1 + r_2))) = #qty(vP / 1e3, "km/s", chiffres: 3, exponent: auto) $
    et de même en $A$, $v_A = sqrt((2 cal(G) M_T r_1) / (r_2 (r_1 + r_2))) = #qty(vA / 1e3, "km/s", chiffres: 3)$. On a bien $v_P / v_A = r_2 / r_1$. La vitesse étant perpendiculaire au rayon vecteur en $P$ et en $A$, $m r v$ y est la norme du moment cinétique en $O$, conservé car la force est centrale : c'est la loi des aires.
]

#question(
    coups-de-pouce: (
        "Comparer, en $P$ puis en $A$, la vitesse sur l'orbite circulaire et la vitesse sur l'orbite de transfert.",
    ),
)[
    En déduire les sur-vitesses $Delta v_1$ et $Delta v_2$ à communiquer au satellite en $P$ puis en $A$. Dans quelle direction la poussée doit-elle s'exercer ?
][
    $Delta v_1 = v_P - v_1 = #qty((vP - v1) / 1e3, "km/s", chiffres: 3)$ et $Delta v_2 = v_2 - v_A = #qty((v2 - vA) / 1e3, "km/s", chiffres: 3)$ : il faut accélérer deux fois. Avant comme après chaque poussée, la vitesse est orthoradiale : la poussée est tangente à la trajectoire, dans le sens du mouvement. Depuis l'orbite de transfert d'Ariane, de périgée voisin de #quan[250 km], un satellite doit en réalité fournir près de #quan[1.5 km/s] : il lui faut aussi ramener son orbite, inclinée d'environ #quan[6 °] (Kourou est à #quan[5 °] de latitude), dans le plan équatorial.
]

#question(
    coups-de-pouce: (
        "La troisième loi de Kepler vaut pour une orbite elliptique, en remplaçant le rayon par le demi-grand axe.",
    ),
)[
    Combien de temps dure le transfert ?
][
    Il dure une demi-période de l'orbite de transfert. D'après la troisième loi de Kepler, $T^2 / a^3 = (4 pi^2) / (cal(G) M_T)$, d'où
    $ Delta t = T / 2 = pi sqrt(a^3 / (cal(G) M_T)) = #qty(durée, "s", chiffres: 2) approx #qty(durée / 3600, "h", chiffres: 2) $
]

#question(
    coups-de-pouce: (
        "Reprendre le bilan de quantité de mouvement de la fusée du chapitre Bilans macroscopiques, sans la pesanteur : la poussée est brève.",
    ),
)[
    Le moteur du satellite éjecte ses gaz à la vitesse $u = #quan[3.0 km/s]$ par rapport à lui. Quelle masse d'ergols brûle-t-il pour la poussée en $A$ ? Sachant que GSAT-18 pèse #quan[1.48 t] à vide, commenter.
][
    Comme pour la fusée, le bilan de quantité de mouvement du système fermé {satellite + gaz éjectés entre $t$ et $t + dd(t)$} donne $m dd(v) = -u dd(m)$, la pesanteur ne jouant pas sur une poussée brève. Donc $Delta v_2 = u ln(m_i / m_f)$ et
    $ m_"ergols" = m (1 - e^(-Delta v_2 \/ u)) = #qty(ergols / 1e3, "t", chiffres: 2) $
    soit #qty(100 * ergols / masse, "%", chiffres: 2, exponent: auto) de la masse du satellite, et les deux tiers des #qty((masse - masse-à-vide) / 1e3, "t", chiffres: 3) d'ergols qu'il emportait. Le reste sert à le maintenir à poste pendant sa durée de service.
]
