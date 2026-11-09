#import "@local/prepa:0.1.1": *

// Fiche d'entraînement de mécanique de PCSI : un recto-verso, exercices tirés
// du Cahier d'entraînement (numéros « CdE » de la version 1.2.6), réponses à
// l'envers en bas du verso. Les exercices « hors cahier » comblent ce que le
// cahier ne traite pas : lois de Kepler et dynamique du solide en rotation.
//
// Se compile seule, hors du hook (aucun chapitre ici) :
//     typst compile "Fiche d'entraînement.typ" "build/Fiche d'entraînement.pdf"

#show: init-document.with(titre: "Mécanique de PCSI — fiche d'entraînement")
#set text(size: 10pt)
#set par(spacing: 0.55em, leading: 0.5em)
#set enum(numbering: "a)", tight: true, spacing: 0.45em, indent: 0.3em, body-indent: 0.4em)
#set math.equation(numbering: none)

// -- Exercices et réponses ----------------------------------------------------

#let réponses = state("réponses", ())
#let n-exo = counter("exo")

// Un exercice ne se coupe pas : il tient dans sa colonne.
#let exo(titre, source: none, réponse: none, corps) = {
    n-exo.step()
    block(breakable: false, above: 0.7em, below: 0em, {
        block(above: 0em, below: 0.35em)[
            #strong[#context n-exo.display()~~#titre]
            #h(1fr)
            #text(size: 7.5pt, fill: luma(40%), if source == none [_hors cahier_] else [CdE #source])
        ]
        corps
    })
    if réponse != none {
        context {
            let n = n-exo.get().first()
            réponses.update(r => r + ((n, réponse),))
        }
    }
}

#let thème(intitulé) = block(
    above: 0.9em,
    below: 0.45em,
    width: 100%,
    fill: luma(90%),
    inset: (x: 0.5em, y: 0.3em),
    radius: 2pt,
    sticky: true,
    text(weight: "bold", intitulé),
)

// Les réponses, tête-bêche en bas du verso, en trois colonnes. `columns` ne
// s'équilibre pas seul : il remplirait la première jusqu'en bas. On mesure donc
// chaque réponse et on les répartit pour que les colonnes aient à peu près la
// même hauteur, chaque réponse allant à la colonne où tombe son milieu.
#let bloc-réponses = context {
    let rs = réponses.final()
    rotate(180deg, block(
        width: 100%,
        stroke: 0.5pt + luma(50%),
        radius: 2pt,
        inset: (x: 0.6em, y: 0.5em),
        {
            set text(size: 8.5pt)
            set par(justify: false, leading: 0.45em)
            align(center, strong[Réponses])
            v(0.1em)
            layout(taille => {
                let gouttière = 5mm
                let largeur = (taille.width - 2 * gouttière) / 3
                let écart = 0.45em.to-absolute()
                let items = rs.map(((n, r)) => block(width: largeur)[*#n.* #r])
                let hauteurs = items.map(it => measure(it).height + écart)
                // À la première passe, l'état est encore vide.
                let total = calc.max(hauteurs.sum(default: 0pt), 1pt)
                let colonnes = ((), (), ())
                let cumul = 0pt
                for (k, it) in items.enumerate() {
                    let i = calc.min(2, int(3 * (cumul + hauteurs.at(k) / 2) / total))
                    colonnes.at(i).push(it)
                    cumul += hauteurs.at(k)
                }
                // Sans `align`, les cellules héritent du `bottom` de `place`.
                grid(
                    columns: (largeur,) * 3,
                    column-gutter: gouttière,
                    align: top + left,
                    ..colonnes.map(c => stack(spacing: écart, ..c)),
                )
            })
        },
    ))
}

// -- Document -----------------------------------------------------------------

#titre-document[Révisions de mécanique de PCSI]
#align(center, text(size: 8.5pt)[
    Exercices tirés du _Cahier d'entraînement en physique-chimie_ (C. Bardavid, J. Roussel et coll., version 1.2.6)
])

#columns(2, gutter: 6mm)[

#thème[Cinématique]

#exo(
    [Pauvre gazelle],
    source: "10.15",
    réponse: [a) $t = #quan[1.7 s]$ ; b) $d = #quan[2.9 m]$],
)[
    Un lion court à la vitesse constante de #quan[5.0 m/s]. Quand il n'est plus qu'à #quan[10 m] d'une gazelle, celle-ci s'enfuit en accélérant à #quan[2.0 m/s^2] ; le lion se met au même instant à accélérer à #quan[3.0 m/s^2].
    + En combien de temps le lion rattrape-t-il la gazelle ?
    + Quelle distance la gazelle a-t-elle parcourue ?
]

#exo(
    [Chute libre],
    source: "10.14",
    réponse: [a) $x = v_(0x) t$ ; b) $z = -1/2 g t^2 + v_(0z) t$ ; c) $z = -g/(2 v_(0x)^2) x^2 + v_(0z)/v_(0x) x$],
)[
    Un point $M$ est lancé depuis l'origine $O$ avec la vitesse $va(v_0) = v_(0x) va(e_x) + v_(0z) va(e_z)$ dans le champ de pesanteur uniforme $va(g) = -g va(e_z)$, sans frottement.
    + Exprimer $x(t)$, puis $z(t)$.
    + En déduire l'équation $z(x)$ de la trajectoire.
]

#exo(
    [Mouvement en spirale],
    source: "10.12",
    réponse: [a) $va(v) = r_0 e^(-t\/tau) (-1/tau va(e_r) + omega va(e_theta))$ ; b) $va(a) = r_0 e^(-t\/tau) [(1/tau^2 - omega^2) va(e_r) - (2 omega)/tau va(e_theta)]$ ; c) orthoradiale ($omega tau = 1$) ; d) décéléré ($va(a) dot va(v) < 0$) ; e) $r = r_0 e^(-theta)$],
)[
    Un point $M$ a pour coordonnées polaires $r(t) = r_0 e^(-t\/tau)$ et $theta(t) = omega t$, où $r_0$, $tau$ et $omega$ sont des constantes positives.
    + Exprimer la vitesse $va(v)(M)$ dans la base polaire.
    + Exprimer l'accélération $va(a)(M)$.
    + Pour $r_0 = #quan[4.0 cm]$, $tau = #quan[2.0 s]$ et $omega = #quan[4.78 tr/min]$, l'accélération est-elle radiale ou orthoradiale ?
    + Le mouvement est-il accéléré ou décéléré ?
    + Donner l'équation polaire $r(theta)$ de la trajectoire.
]

#thème[Lois de Newton]

#exo(
    [Masse suspendue],
    source: "11.14",
    réponse: [a) $R_x = (T' - T) cos theta$ ; b) $R_y = (T + T') sin theta - F$ ; c) $T = F/(2 sin theta) = #quan[1.17 kN]$],
)[
    Un objet de poids #quan[800 N] est suspendu en $A$ à deux cordes symétriques faisant chacune l'angle $theta = 20 degree$ avec l'horizontale. $A$ subit les tensions $va(T)$ (corde de gauche) et $va(T')$ (corde de droite) et la force verticale $va(F)$ de l'objet. Avec $va(e_x)$ horizontal vers la droite et $va(e_y)$ vertical vers le haut, on note $va(R) = R_x va(e_x) + R_y va(e_y)$ la résultante de ces forces.
    + Exprimer $R_x$ en fonction de $T$, $T'$ et $theta$, puis $R_y$ en fonction de $T$, $T'$, $F$ et $theta$.
    + Calculer $T$ en résolvant $va(R) = va(0)$.
]

#exo(
    [Contact dans un ascenseur],
    source: "11.16",
    réponse: [$F = m (g + a) = #quan[864 N]$],
)[
    Un homme de masse $m = #quan[80 kg]$ est dans un ascenseur qui monte avec l'accélération $a = #quan[1 m/s^2]$. Que vaut la force $F$ qu'il exerce sur le plancher ? On prendra $g = #quan[9.8 m/s^2]$.
]

#exo(
    [Deux blocs et une poulie],
    source: "11.18",
    réponse: [a) $a_1 = T_1/(2m)$ ; b) $a_2 = g - T_2/m$ ; c) $a = g/3$],
)[
    Deux blocs $B_1$ (masse $2m$) et $B_2$ (masse $m$) sont reliés par un fil qui passe dans la gorge d'une poulie : $B_1$ glisse sans frottement sur une table horizontale, $B_2$ pend verticalement. On note $T_1$ et $T_2$ les normes des tensions exercées par le fil sur les blocs, $a_1$ et $a_2$ celles de leurs accélérations.
    + Exprimer $a_1$ en fonction de $m$ et $T_1$.
    + Exprimer $a_2$ en fonction de $m$, $g$ et $T_2$.
    + Le fil étant inextensible et sans masse, $a_1 = a_2$ et $T_1 = T_2$. En déduire l'accélération en fonction de $g$ seulement.
]

#thème[Approche énergétique]

#exo(
    [Freinage],
    source: "12.6",
    réponse: [c) (théorème de l'énergie cinétique)],
)[
    Une voiture, assimilée à un point de masse $m$, roule en ligne droite sur une route horizontale à la vitesse $v_0$. En freinant, elle subit la force $va(F) = -h va(e_x)$, $h$ constant. Sa distance d'arrêt vaut :
    #align(center)[(a) $(2 m v_0^2)/h$ #h(2.5em) (b) $(m v_0^2)/h$ #h(2.5em) (c) $(m v_0^2)/(2 h)$]
]

#exo(
    [Travail d'un frottement],
    source: "12.5",
    réponse: [a) $-h ell$ ; b) $-h R alpha$ ; c) $-2(a + b) h$ ; d) $-(a + b + c) h$ ; e) non : son travail sur un contour fermé n'est pas nul],
)[
    Une force de frottement de norme constante $h$ s'oppose toujours à la vitesse : $va(F) = -h va(v) \/ norm(va(v))$. Calculer son travail $W = integral va(F) dot dd(va(ell))$ le long : a) d'un segment de longueur $ell$ ; b) d'un arc de cercle de rayon $R$ et d'angle $alpha$ ; c) du tour d'un rectangle de côtés $a$ et $b$ ; d) du tour d'un triangle de côtés $a$, $b$ et $c$. \
    e) Cette force est-elle conservative ?
]

#exo(
    [Pendule simple],
    source: "12.7",
    réponse: [a) $cos theta_0 = 1 - v_0^2/(2 g ell)$ ; b) $theta_0 = #quan[0.65 rad] = 37 degree$],
)[
    Un pendule simple est formé d'un fil de longueur $ell = #quan[1.0 m]$ et d'une masse $m = #quan[100 g]$. Au repos à la verticale du point d'attache, la masse reçoit à $t = 0$ une vitesse horizontale $v_0 = #quan[2.0 m/s]$ ; elle rebrousse chemin à l'angle $theta_0$. \
    a) Exprimer $cos theta_0$. #h(1.5em) b) Calculer $theta_0$.
]

#exo(
    [Trampoline simplifié],
    source: "12.8",
    réponse: [a) $v = sqrt(2 g (H - ell_0)) = #quan[5.8 m/s]$ ; b) $z_"min" = #quan[0.11 m]$ ; c) $z_"max" = H = #quan[2.0 m]$],
)[
    Un ressort sans masse, de longueur à vide $ell_0 = #quan[30 cm]$ et de raideur $k = #quan[1.0e3 N/m]$, est posé verticalement sur le sol. On lâche sans vitesse, d'une hauteur $H = #quan[2.0 m]$, une masse ponctuelle $m = #quan[1.0 kg]$ : elle tombe sur le ressort, le comprime, puis est renvoyée vers le haut. On admet qu'elle quitte le ressort quand $z = ell_0$. Calculer :
    + sa vitesse au contact du ressort ;
    + l'altitude minimale qu'elle atteint ;
    + son altitude maximale en fin de remontée.
]

#exo(
    [Oscillateur vertical amorti],
    source: "12.9",
    réponse: [a) $dot.double(z) + alpha/m dot(z) + k/m z = g + (k ell_0)/m$ ; b) $dot.double(zeta) + alpha/m dot(zeta) + k/m zeta = 0$],
)[
    Un point $M$ de masse $m$ est suspendu à un point fixe $O$ par un ressort de raideur $k$ et de longueur à vide $ell_0$. Il se déplace verticalement dans un liquide qui exerce la force $va(F) = -alpha va(v)$, avec $alpha > 0$ ; on néglige la poussée d'Archimède. On repère $M$ par $z = O M$ sur un axe vertical descendant.
    + Établir, par une méthode énergétique, l'équation différentielle vérifiée par $z$.
    + Même question pour $zeta = z - z_"éq"$, écart à l'équilibre.
]

#exo(
    [Positions d'équilibre],
    source: "12.11",
    réponse: [a) $theta_"éq" = 0$ ; b) $z_"éq" = 0$ ; c) $x_"éq" = 0$ ; d) $phi_"éq" = a$],
)[
    Donner la position d'équilibre stable d'un point matériel dans chacune des énergies potentielles suivantes :
    + $E_p (theta) = m g ell (1 - cos theta)$ ;
    + $E_p (z) = 1/2 kappa z^2 + 1/4 lambda z^4$, avec $kappa > 0$ et $lambda < 0$ ;
    + $E_p (x) = U_0 e^(beta x^2)$, avec $U_0 > 0$ et $beta > 0$ ;
    + $E_p (phi) = E_0 sin^2 (phi - a)$ sur $[0, pi[$, où $E_0 > 0$, $0 < a < pi\/2$.
]

#thème[Particules chargées]

#exo(
    [Particule dans un champ magnétique],
    source: "15.10",
    réponse: [a) $va(a) = q/m va(v) and va(B)$ ; b) $R = (m v_0)/(|q| B)$ ; c) $T = (2 pi m)/(|q| B)$],
)[
    Une particule de masse $m$ et de charge $q < 0$ entre avec la vitesse $va(v_0)$, orthogonale à $va(e_z)$, dans un champ magnétique uniforme $va(B) = B va(e_z)$. On néglige son poids.
    + Exprimer son accélération $va(a)$ en fonction de $q$, $m$, $va(v)$ et $va(B)$.
    + On admet que le mouvement est circulaire, de rayon $R$. Par le principe fondamental en coordonnées polaires, exprimer $R$.
    + Calculer la période $T$ du mouvement.
]

#exo(
    [Filtre de vitesse],
    source: "15.11",
    réponse: [a) $va(F_L) = q (E - v_0 B) va(e_y)$ ; b) $v_0 = E\/B$],
)[
    Un électron (charge $q < 0$) se déplace à la vitesse $va(v_0) = v_0 va(e_x)$ dans une zone où règnent les champs $va(E) = E va(e_y)$ et $va(B) = B va(e_z)$.
    + Exprimer la force de Lorentz $va(F_L)$ dans la base cartésienne.
    + À quelle condition le mouvement est-il rectiligne uniforme ?
]

#thème[Moment cinétique]

#exo(
    [Produits vectoriels],
    source: "13.4",
    réponse: [a) $(-7, 14, -7)$ ; b) $(7, -14, 7)$ ; c) et d) $(-6, -33, 24)$],
)[
    Avec $va(A) = (1, 2, 3)$, $va(B) = (6, 5, 4)$ et $va(C) = (0, 1, -1)$ dans une base orthonormée directe, calculer :
    #grid(
        columns: (1fr, 1.4fr),
        row-gutter: 0.6em,
        [a) $va(A) and va(B)$], [b) $(va(B) + va(A)) and va(A)$],
        [c) $va(A) and (va(B) and va(C))$], [d) $(va(A) dot va(C)) va(B) - (va(A) dot va(B)) va(C)$],
    )
]

#exo(
    [Bataille de moments cinétiques],
    source: "13.5",
    réponse: [la Terre : #quan[2.7e40 kg m^2/s] (Vénus : #quan[1.9e40 kg m^2/s])],
)[
    Laquelle de ces planètes, sur une orbite supposée circulaire, a le plus grand moment cinétique par rapport au Soleil ?
    #align(center, text(size: 8.5pt, table(
        columns: 4,
        inset: (x: 4pt, y: 2.5pt),
        stroke: 0.4pt + luma(60%),
        align: (left, right, right, right),
        table.header[][*Masse*][*Distance au Soleil*][*Vitesse*],
        [Mercure], [#quan[3e26 g]], [#quan[58e9 m]], [#quan[170e3 km/h]],
        [Vénus], [#quan[5e27 g]], [#quan[1.1e13 cm]], [#quan[35e3 m/s]],
        [Terre], [#quan[6e21 t]], [#quan[150e6 km]], [#quan[30 km/s]],
        [Mars], [#quan[6e23 kg]], [#quan[230e6 km]], [#quan[87e8 cm/h]],
    )))
]

#exo(
    [Un moustique],
    source: "13.6",
    réponse: [$va(L)_O = m r v sin alpha va(e_z)$],
)[
    Un moustique $M$ de masse $m$ vole dans le plan $(O x y)$ à la distance $r$ de $O$. Sa vitesse, de norme $v$, fait l'angle $alpha$ avec $va(e_r)$, compté de $va(e_r)$ vers $va(e_theta)$. Exprimer son moment cinétique $va(L)_O$ par rapport à $O$.
]

#exo(
    [Fil accroché au mur],
    source: "13.10",
    réponse: [a) $M_(O z) = -ell F sin alpha cos alpha$ ; b) $M_(A z) = 0$ (la droite d'action passe par $A$)],
)[
    Un filin tendu, de longueur $ell$, relie un point $M$ d'un mur vertical, de pied $O$, à un point $A$ du sol ; il fait l'angle $alpha$ avec le sol et exerce en $M$ la force $va(F)$, de norme $F$, dirigée de $M$ vers $A$. Avec $va(e_x)$ de $O$ vers $A$, $va(e_y)$ vertical ascendant et $va(e_z) = va(e_x) and va(e_y)$, calculer le moment de $va(F)$ par rapport à l'axe : a) $(O z)$ ; b) $(A z)$.
]

#thème[Force centrale et lois de Kepler]

#exo(
    [Satellite géostationnaire],
    réponse: [a) $r dot.double(theta) = 0$ donc $dot(theta)$ constant ; $v^2 = (cal(G) M_T)/r$ ; b) $T^2/r^3 = (4 pi^2)/(cal(G) M_T)$, $r = #quan[42164 km]$, $h = #quan[35786 km]$ ; c) $v = #quan[3.07 km/s]$],
)[
    Un satellite géostationnaire décrit, dans le référentiel géocentrique, une orbite circulaire de rayon $r$ dans le plan de l'équateur, en $T =$ 23~h~56~min~4~s (rotation propre de la Terre). On donne $cal(G) M_T = #quan[3.986e14 m^3/s^2]$ et le rayon équatorial $R_T = #quan[6378 km]$.
    + Par le principe fondamental en coordonnées polaires, montrer que le mouvement est uniforme et exprimer $v$ en fonction de $r$.
    + En déduire la troisième loi de Kepler et l'altitude $h$.
    + Calculer $v$.
]

#exo(
    [Comète de Halley],
    réponse: [a) $T approx 75$ ans ; b) $r_A = 2a - r_P = #num(35.0)$~ua ; c) $v_P / v_A = r_A / r_P = 60$ ; d) $v_P = sqrt(cal(G) M_S (2/r_P - 1/a)) = #quan[54.6 km/s]$],
)[
    La comète de Halley décrit autour du Soleil une ellipse de demi-grand axe $a = #num(17.8)$~ua ; son périhélie, point le plus proche du Soleil, est à $r_P = #num(0.586)$~ua. La Terre parcourt en un an son orbite, presque circulaire, de rayon 1~ua. On donne $cal(G) M_S = #quan[1.327e20 m^3/s^2]$ et 1~ua $= #quan[1.496e11 m]$.
    + Calculer la période de la comète.
    + Calculer sa distance $r_A$ au Soleil à l'aphélie.
    + Au périhélie et à l'aphélie, $va(v) perp va(S M)$ : en déduire $v_P \/ v_A$.
    + L'énergie mécanique sur une ellipse vaut $E_m = -(cal(G) M_S m)\/(2 a)$. Exprimer puis calculer $v_P$.
]

#place(bottom, scope: "parent", float: true, clearance: 4mm, bloc-réponses)

#thème[Solide en rotation]

#exo(
    [Moments d'inertie],
    source: "13.7 à 13.9",
    réponse: [a) $J_Delta = 1/3 M L^2$ ; b) $J_Delta = 1/12 M L^2$ ; c) $J_Delta = 2/5 M R^2$],
)[
    Calculer le moment d'inertie de ces solides homogènes de masse $M$.
    + Une porte (largeur $L$, hauteur $h$, épaisseur $e$) autour de l'axe de ses gonds : $J_Delta = rho integral_0^L x^2 dd(x) integral_0^e dd(y) integral_0^h dd(z)$, avec $rho = M \/ (L h e)$.
    + Un bâton de longueur $L$, autour d'un axe orthogonal passant par son milieu : $J_Delta = integral_(-L\/2)^(L\/2) M/L x^2 dd(x)$.
    + Une boule de rayon $R$, autour d'un diamètre : $J_Delta = rho integral_0^R r^4 dd(r) integral_0^pi sin^3 theta dd(theta) integral_0^(2 pi) dd(phi)$, avec $rho = M\/(4/3 pi R^3)$.
]

#exo(
    [Pendule pesant],
    réponse: [a) $dot.double(theta) + (3 g)/(2 L) sin theta = 0$ ; b) $T_0 = 2 pi sqrt((2 L)/(3 g)) = #quan[1.64 s]$ ; c) $omega = sqrt((3 g)/L) = #quan[5.4 rad/s]$],
)[
    Une règle homogène, de masse $M$ et de longueur $L = #quan[1.00 m]$, tourne sans frottement autour d'un axe horizontal $Delta$ passant par une de ses extrémités (liaison pivot idéale) ; $J_Delta = 1/3 M L^2$, comme pour la porte. On note $theta$ son angle avec la verticale descendante.
    + Établir l'équation du mouvement par le théorème du moment cinétique.
    + En déduire la période $T_0$ des petites oscillations.
    + La règle est lâchée sans vitesse depuis l'horizontale. Par un théorème énergétique, calculer sa vitesse angulaire $omega$ au passage à la verticale.
]

]
