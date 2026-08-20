#import "@local/prepa:0.1.0": *

#show: exercice.with(
    titre: "Train à sustentation magnétique",
    ouvert: true,
)

Dans les trains à sustentation magnétique, le train lévite au-dessus des rails grâce à des forces magnétiques générées par des bobines supraconductrices placées dans le train. Pour que le train puisse léviter, le champ magnétique produit doit dépasser #qty("4", "T").

#question(
    coups-de-pouce: (),
)[
    Expliquer pourquoi il n'est pas possible d'utiliser des bobines constituées de fils résistifs pour générer ce champ magnétique.
][
    Si on néglige les effets de bord (un peu limite ici car #qty("0.5", "m") n'est pas très grand devant #qty("0.2", "m") mais pas le choix pour pouvoir résoudre), $B = mu_0 N/l i$.

    #let B = 4
    #let mu0 = 4 * calc.pi * 1e-7
    #let N = 10000
    #let l = 0.5
    #let i = (B * l) / (mu0 * N)
    Pour obtenir un champ magnétique de #qty("4", "T"), il faut un courant $i = (B l)/(mu_0 N) = #qty(scientifique(i, 1), "A")$.

    Pour illustrer à quel point ce courant est grand pour un cable de #qty("2", "mm") de diamètre, on va calculer le temps que mettrait ce cable à fondre sous l'effet de l'échauffement par effet Joule. Pour ce faire, on néglige tout échange thermique avec l'extérieur.

    La résistance du fil est $R = l/(gamma S)$, la puissance dissipée par effet Joule est $P = R i^2 = l/(gamma S) ((B l)/(mu_0 N))^2 = (4l)/(gamma pi d^2)((B l)/(mu_0 N))^2$.

    Le premier principe de la thermodynamique et l'équation calorique donnent $P dd(t) = mu V c dd(T) = mu pi (d/2)^2 l c dd(T)$ soit $dd(T)/dd(t) = (4P)/(mu pi d^2 l c)$. Finalement,
    $
        T(t) = T_0 + (4P)/(mu pi d^2 l c) t = T_0 + (16l)/(gamma pi^2 mu d^4 l c) ((B l)/(mu_0 N))^2 t
    $
    La fusion du cuivre a lieu lorsque $T(t) = T_f$ soit
    #let Tf = 1357
    #let T0 = 293
    #let gamma-Cu = 1/1.68e-8
    #let S = calc.pi * calc.pow(2e-3/2, 2)
    #let mu-Cu = 8.96e3
    #let c = 385
    #let d = 2e-3
    #let tf = (Tf - T0) * (gamma-Cu * mu-Cu * calc.pow(calc.pi,2) * calc.pow(d,4) *c)/16 * calc.pow((mu0 * N)/(B * l), 2)
    $
        t_f = (T_f - T_0) (gamma mu pi^2 d^4 c)/16 ((mu_0 N)/(B l))^2 = #qty(scientifique(tf, 1), "s")
    $
    Sans système de refroidissement, le fil fondrait en quelques minutes. Il est plus aisé d'utiliser des bobines supraconductrices qui n'ont pas de résistance électrique et donc pas d'échauffement par effet Joule.
]

#grid(
    columns: (1fr, 1fr),
    [
        Données sur le solénoïde
        - Diamètre : #qty("0.2", "m")
        - Longueur : #qty("0.5", "m")
        - Nombre de spires : #num("10000")
        - Diamètre du fil : #qty("2.0", "mm")
    ],
    [
        Données sur le cuivre
        - Masse volumique : #qty("8.96", "g/cm^3")
        - Capacité thermique massique : #qty("385", "J/kg K")
        - Résistivité électrique : #qty("1.68e-8", "O m")
        - Température de fusion : #qty("1357", "K")
    ],
)
