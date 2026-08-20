#import "@local/prepa:0.1.0": *

#show: exercice.with(
    titre: "Pompe à chaleur air/air",
)

On s'intéresse à une pompe à chaleur utilisée pour chauffer une habitation. La pompe à chaleur fonctionne en faisant circuler du propane dans un circuit fermé. Le propane (noté R290 et dont le diagramme $(P,h)$ est donné ci-dessous) passe successivement dans un compresseur, un condenseur situé dans l'habitation, un détendeur, puis un évaporateur situé à l'extérieur de l'habitation avant de revenir au compresseur.

#figure(
    image("/images/R290.pdf"),
    placement: auto,
)

La température et la pression sont mesurées à chaque étape du cycle :
#table(
    columns: 3,
    [Étape], [Température (#unit("Celsius"))], [Pression (#unit("bar"))],
    [Sortie du compresseur], num("65"), num("19"),
    [Sortie du condenseur], num("27"), num("19"),
    [Sortie du détendeur], num("2"), num("5"),
    [Sortie de l'évaporateur], num("10"), num("5"),
)

Le détendeur ne comporte pas de pièces mobiles.

La détente dans le détendeur et la compression dans le compresseur s'effectuent très rapidement, de sorte que les transferts thermiques sont négligeables durant ces deux étapes.

#question[
    Montrer que la détente dans le détendeur peut être considérée comme isenthalpique.
][
    Le PPI appliqué au détendeur s'écrit
    $
        Delta h = w_u + q
    $
    où $q = 0$ car les transferts thermiques sont négligeables et $w_u = 0$ car il n'y a pas de pièces mobiles dans le détendeur.
]

#question[
    Tracer le cycle sur le diagramme $(P,h)$.
][
    Pour la sortie du compresseur, (#qty("19", "bar") et #qty("65", "Celsius")), on place le point à l'intersection de l'isotherme #qty("65", "Celsius") et de l'isobare #qty("19", "bar").

    Pour la sortie du condenseur, (#qty("19", "bar") et #qty("27", "Celsius")), on place le point à l'intersection de l'isotherme (quasiment verticale sur le diagramme) #qty("27", "Celsius") et de l'isobare #qty("19", "bar").

    Pour la sortie du détendeur, (#qty("5", "bar") et #qty("2", "Celsius")), l'isobare et l'isotherme sont confondues sur le diagramme, on ne peut donc pas utiliser leur intersection. La détente est isenthalpique, donc la courbe est verticale jusqu'à atteindre l'isobare #qty("5", "bar").

    Pour la sortie de l'évaporateur, (#qty("5", "bar") et #qty("10", "Celsius")), on place le point à l'intersection de l'isotherme #qty("10", "Celsius") et de l'isobare #qty("5", "bar").

    #figure(
        image("/images/R290 - corrigé.pdf"),
    )
]

#question[
    Justifier que la compression dans le compresseur peut être considérée comme réversible.
][
    Le point de départ et d'arrivée de la compression sont sur la même isentropique donc $Delta S =$. De plus, la compression est rapide donc les échanges thermiques sont négligeables, $Q = 0$, d'où l'entropie échangée est nulle. On en déduit $S_c = Delta S - S_e = 0$ : la compression est réversible.
]

#let Dh-cond = 270 - 650
#let Dm = -4000 / (Dh-cond * 1000)
#question[
    Calculer la chaleur massique reçue par le propane dans le condenseur. Quel débit massique le propane doit-il avoir pour fournir une puissance de chauffage de #qty("4", "kW") à l'habitation ?
][
    Pour la condensation, on lit une variation d'enthalpie massique
    $
        Delta h_"condensation" = #num("270") - #num("650") = #qty(scientifique(Dh-cond, 2), "kJ/kg")
    $
    Le PPI donne
    $
        Delta h_"condensation" + cancel(Delta e_c) + cancel(Delta e_p) = q_c + cancel(w_u)
    $
    Soit
    $
        q_c = Delta h_"condensation" = #qty(scientifique(Dh-cond, 2), "kJ/kg")
    $
    La puissance thermique *fournie* à l'habitation est $P = -q_c D_m$, soit
    $
        D_m = - P/q_c = #qty(scientifique(Dm, 2), "kg/s")
    $
]

#let Dh-comp = 650 - 590
#question[
    Calculer le travail util reçu par le propane dans le compresseur. Quel est la puissance électrique consommée par le compresseur ?
][
    On utilise la même méthode que précédemment :
    $
        Delta h_"compression" = #num("650") - #num("590") = #qty(Dh-comp, "kJ/kg")
    $
    Durant la compression, le PPI donne
    $
        Delta h_"compression" + cancel(Delta e_c) + cancel(Delta e_p) = cancel(q_c) + w_u
    $
    Soit
    $
        w_u = Delta h_"compression" = #qty(Dh-comp, "kJ/kg")
    $
    La puissance utile est
    $
        P_u = w_u D_m = #qty(scientifique(Dh-comp * 1e3 * Dm, 2), "W")
    $
]

#question[
    Calculer l'efficacité, aussi appelée COP (pour Coefficient Of Performance), de la pompe à chaleur. 
][
    $
      e = -Q_c / W_u = q_c / w_u = #num(scientifique(-Dh-cond / Dh-comp, 1))
    $
]