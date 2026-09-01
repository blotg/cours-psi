#import "@local/prepa:0.1.1": *

#show: cours.with(infos: yaml("infos.yml"))

#let grandeurs = (
    "F_ce(\"A\")": (signification: "le débit molaire de l'espèce #ce(\"A\")", unité: unit("mol/s")),
    "[ce(\"A\")]": (signification: "la concentration de l'espèce #ce(\"A\")", unité: unit("mol/L")),
    "D_V": (signification: "le débit volumique", unité: unit("L/s")),
    "Q_ce(\"A\")": (signification: "le débit massique de l'espèce #ce(\"A\")", unité: unit("kg/s")),
    "M_ce(\"A\")": (signification: "la masse molaire de l'espèce #ce(\"A\")", unité: unit("kg/mol")),
    "nu_ce(\"A\")": (
        signification: "le coefficient stœchiométrique de l'espèce #ce(\"A\") dans la réaction",
        unité: "sans unité",
    ),
    "dv(xi,t)": (signification: "la vitesse extensive de réaction", unité: unit("mol/s")),
    "X_ce(\"A\")": (signification: "le taux de conversion de l'espèce #ce(\"A\")", unité: "sans unité"),
    "tau": (signification: "le temps de passage", unité: unit("s")),
    "V": (signification: "le volume du réacteur", unité: unit("L")),
    "R_ce(\"A\")": (
        signification: "$=nu_ce(\"A\")1/V dv(xi,t)$ la vitesse volumique d'apparition de l'espèce #ce(\"A\")",
        unité: unit("mol/s/L"),
    ),
    "v": (signification: "$=1/V dv(xi,t)$ la vitesse volumique de réaction", unité: unit("mol/s/L")),
    "S": (signification: "la section du réacteur", unité: unit("m^2")),
    "P_\"th\"": (signification: "la puissance thermique fournie par le réacteur", unité: unit("W")),
    "c_P": (signification: "la capacité thermique massique à pression constante", unité: unit("J/K/kg")),
    "mu": (signification: "la masse volumique", unité: unit("kg/m^3")),
    "T_s": (signification: "la température en sortie", unité: unit("K")),
    "T_e": (signification: "la température en entrée", unité: unit("K")),
    "Delta_r H^circ": (signification: "l'enthalpie de réaction", unité: unit("J/mol")),
    "[ce(\"A\")]_e": (signification: "la concentration de l'espèce #ce(\"A\") en entrée", unité: unit("mol/L")),
)

= Procédé continu
== Classification des procédés industriels
Un réacteur est un appareillage dans lequel se déroule une transformation chimique : des réactifs sont transformés en produits.

Dans un réacteur fermé, le procédé est discontinu : on introduit les réactif en une seule fois et on laisse le système évoluer. C'est ce qu'on fait la grande majorité du temps en TP.

Dans un réacteur ouvert, le procédé est continu : les réactifs sont introduits en continu et les produits sont retirés en continu également. La plupart des procédés industriels utilisent des réacteurs ouverts.

#exemple[
    Pot catalytique d'une voiture
]

#exemple[
    Le procédé Haber-Bosch est un procédé continu de synthèse de l'ammoniac. Il comporte plusieurs réacteurs ouverts et de nombreuses opérations élémentaires telles que la compression, le chauffage ou la production de dihydrogène à partir de méthane et d'eau.

    #image("images/Haber-Bosch.png", width: 100%)
    #lien("https://youtu.be/EvknN89JoWo")
]

== Débits et bilans
Le débit molaire $F_ce("A")$ de l'espèce #ce("A") est la quantité de matière traversant une section par unité de temps. Il se mesure en #unit("mol/s").

#encadré(
    titre: "Débit molaire et concentration",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("F_ce(\"A\")", "[ce(\"A\")]", "D_V")),
)[
    $ F_ce("A") = [ce("A")] D_V $
]

#flashcard(
    recto: "Lien entre débit molaire et concentration",
    verso: "$ F_ce(\"A\") = [ce(\"A\")] D_V $",
)

#encadré(
    titre: "Débit molaire et débit massique",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("Q_ce(\"A\")", "F_ce(\"A\")", "M_ce(\"A\")")),
)[
    $ Q_ce("A") = F_ce("A") M_ce("A") $
]

Le débit massique total traversant une section est la somme des débits massiques pour toutes les espèces chimiques constituant le mélange.

#encadré(
    titre: "Bilan de quantité de matière sur un réacteur ouvert en régime stationnaire",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [Le régime est stationnaire],
    ),
    grandeurs: sub-dictionary(grandeurs, ("F_ce(\"A\")", "nu_ce(\"A\")", "dv(xi,t)")),
)[
    $ F_(ce("A"),"sortie") - F_(ce("A"),"entrée") = nu_ce("A") dv(xi, t) $
]

== Taux de conversion et concentration
Le taux de conversion $X_ce("A")$ d'un réactif désigne la proportion de la quantité de matière de ce réactif qui a réagit.

#encadré(
    titre: "Taux de conversion",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("F_ce(\"A\")", "X_ce(\"A\")")),
)[
    $ X_ce("A") = frac(F_(ce("A"),"entrée") - F_(ce("A"),"sortie"), F_(ce("A"),"entrée")) $
]

#flashcard(
    recto: "Taux de conversion",
    verso: "$ X_ce(\"A\") = frac(F_(ce(\"A\"),\"entrée\") - F_(ce(\"A\"),\"sortie\"), F_(ce(\"A\"),\"entrée\")) $",
)

#application[
    Exprimer $[ce("A")]_"sortie"$ en fonction de $[ce("A")]_"entrée"$ et $X_ce("A")$. On supposera $D_(V,e)=D_(V,s) =: D_V$.
]

= Cinétique des transformations en réacteur ouvert
== Réacteur parfaitement agité continu en régime stationnaire
Un réacteur ouvert parfaitement agité continu (RPAC) est un réacteur ouvert dans lequel toutes les grandeurs sont uniformes.

#figure(
    image("images/RPAC.jpg", width: 7cm),
)

#schéma(titre: "Réacteur parfaitement agité continu", hauteur: 4cm)

Pour un RPAC, la concentration en sortie est la concentration à l'intérieur du réacteur.

#encadré(
    titre: "Temps de passage",
    connaitre: true,
    grandeurs: sub-dictionary(grandeurs, ("tau", "V", "D_V")),
)[
    $ tau = V/D_V $
]

#flashcard(
    recto: "Temps de passage",
    verso: "$ tau = V/D_V $",
)

Le temps de passage représente le temps moyen qu'un réactif passe dans le réacteur.

#encadré(
    titre: "Concentrations et vitesse de réaction",
    connaitre: true,
    savoir-faire: true,
    hypothèses: (
        [Le régime est stationnaire.],
        [Le volume se conserve.],
    ),
    grandeurs: sub-dictionary(grandeurs, ("D_V", "[ce(\"A\")]", "R_ce(\"A\")", "V")),
)[
    $ D_V ( [ce("A")]_"entrée" - [ce("A")]_"sortie" ) + R_ce("A") V = 0 $
]

#flashcard(
    recto: "En effectuant un bilan de matière, déterminer une relation entre concentrations et vitesse d'apparition pour un RPAC",
    verso: "$ D_V ( [ce(\"A\")]_\"entrée\" - [ce(\"A\")]_\"sortie\" ) + R_ce(\"A\") V = 0 $",
)

#question-de-colle(
    "À partir d'un bilan de matière, établir le lien entre les concentrations d'entrée et de sortie et la vitesse d'apparition pour un réacteur continu parfaitement agité.",
)

#application[
    On s'intéresse à la solvolyse du tert-butylchlorure #ce("(CH3)3CCl + H2O <=> (CH3)3COH + H+ + Cl-") dont le loi de vitesse est $v=k[ce("(CH3)3CCl")]$. Exprimer le taux de conversion de #ce("(CH3)3CCl") en fonction de la constante de vitesse $k$ et du temps de passage $tau$. Quel temps de passage faut-il prévoir pour avoir un taux de conversion de #qty("95", "%") sachant que $k=qty("1.0e-3", "/s")$ ?
]

== Réacteur en écoulement piston
Dans un réacteur en écoulement piston (RP), le fluide progresse dans le réacteur sans se mélanger. Deux "tranches" de fluides successives, bien qu'en contact, n'échangent pas de matière.

#schéma(titre: "Réacteur en écoulement piston", hauteur: 4cm)

#figure(
    image("images/RP.jpg", width: 7cm),
)

#encadré(
    titre: "Évolution du débit molaire",
    savoir-faire: true,
    hypothèses: (
        [Le régime est stationnaire],
    ),
    grandeurs: sub-dictionary(grandeurs, ("F_ce(\"A\")", "nu_ce(\"A\")", "v", "S")),
)[
    $ dv(F_ce("A"), x) = nu_ce("A") v(x) S $
]

#encadré(
    titre: "Évolution de la concentration",
    savoir-faire: true,
    connaitre: true,
    hypothèses: (
        [Le régime est stationnaire],
        [Le débit volumique est uniforme],
    ),
    grandeurs: sub-dictionary(grandeurs, ("[ce(\"A\")]", "nu_ce(\"A\")", "v", "tau")),
)[
    $ dd(\[ce("A")\]) = nu_ce("A") v(x) dd(tau) $
]

#flashcard(
    recto: "Évolution de la concentration en fonction du temps de passage pour un réacteur piston",
    verso: "$ dd(\[ce(\"A\")\]) = nu_ce(\"A\") v(x) dd(tau) $",
)

#question-de-colle(
    "En effectuant un bilan de matière, établir une équation différentielle liant concentration et temps de passage pour un réacteur piston.",
)

#application[
    On s'intéresse à la solvolyse du tert-butylchlorure #ce("(CH3)3CCl + H2O <=> (CH3)3COH + H+ + Cl-") dont le loi de vitesse est $v=k[ce("(CH3)3CCl")]$. Exprimer le taux de conversion de #ce("(CH3)3CCl") en fonction de la constante de vitesse $k$ et du temps de passage $tau$. Quel temps de passage faut-il prévoir pour avoir un taux de conversion de #qty("95", "%") sachant que $k=qty("1.0e-3", "/s")$ ?
]

== Comparaison RPAC et RP

#application[
    On s'intéresse à la solvolyse du tert-butylchlorure #ce("(CH3)3CCl + H2O <=> (CH3)3COH + H+ + Cl-") dont le loi de vitesse est $v=k[ce("(CH3)3CCl")]$. En posant $x=k tau$, montrer que
    $
        X_(ce("(CH3)3CCl"),"RP")/X_(ce("A(CH3)3CCl"),"RPAC") - 1 = 1/x e^(-x) (e^x - 1 - x)
    $
    En étudiant le signe de $(e^x-1-x)$ sur $RR^+$, en déduire que le RP a un meilleur taux de conversion qu'un RPAC.
]

#question-de-colle(
    "Pour une réaction d'ordre 1, déterminer le taux de conversion en fonction du temps de passage et de la constante de vitesse pour un réacteur continu parfaitement agité puis pour un réacteur piston. Comparer ces deux taux de conversion.",
)

De manière générale, pour les réactions d'ordre positif#footnote[La grande majorité des réactions a un ordre positif ou nul.], les RP ont un meilleur taux de conversion que les RPAC.

= Étude thermique d’un réacteur ouvert

L'avancement d'une réaction chimique peut s'accompagner d'un dégagement ou d'une absorption de chaleur. Il est possible de relier le taux de conversion, la puissance thermique échangée et la variation de température dans un RPAC.

#encadré(
    titre: "Conservation de l'énergie dans un RPAC",
    hypothèses: (
        [Le réacteur est un RPAC.],
        [Le régime est stationnaire.],
        [Le volume se conserve.],
        [Le fluide ne reçoit aucun travail.],
        [Les variations d'énergie cinétique et potentielle sont négligeables.],
        [La réaction est isobare.],
        [Le réacteur ne comporte pas de parties mobiles.],
    ),
    savoir-faire: true,
    grandeurs: sub-dictionary(grandeurs, (
        "P_\"th\"",
        "c_P",
        "mu",
        "D_V",
        "T_s",
        "T_e",
        "Delta_r H^circ",
        "[ce(\"A\")]_e",
        "X_ce(\"A\")",
        "nu_ce(\"A\")",
    )),
)[
    $ P_"th" = c_P mu D_V (T_s - T_e) - Delta_r H^circ ([ce("A")]_e X_ce("A")) / nu_ce("A") D_V $
]

#question-de-colle(
    "En effectuant un bilan d'énergie, exprimer la puissance thermique fournie par un réacteur continu parfaitement agité en faisant apparaitre les températures d'entrée et de sortie ainsi que l'enthalpie de réaction.",
)

#application[
    Certains procédés textiles comme la tanneries, le dégraissage des textiles, ou  la blanchisseries produisent des effluents basiques qu'il est nécessaire de neutraliser avant de les rejeter dans le milieu naturel. Celle-ci peut être faite par ajout d'acide chlorhydrique #ce("HCl") :
    $
        ce("HCl + HO- -> Cl- + H2O")
    $
    Cette réaction est exothermique avec une enthalpie de réaction $Delta_r H^circ = qty("-57", "kJ/mol")$.

    Les effluents sont traités dans un réacteur adiabatique. Calculer l'élévation de température lors de cette opération pour des effluents de $pH = num("14")$.

    La capacité thermique massique de l'eau est $c_P = qty("4.18e3", "J/kg/K")$. On supposera que la présence de solutés n'influence pas la capacité thermique massique et la masse volumique que l'eau.
]
