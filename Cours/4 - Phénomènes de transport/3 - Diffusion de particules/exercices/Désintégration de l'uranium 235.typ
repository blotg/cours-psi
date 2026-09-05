#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Désintégration de l'uranium 235",
    difficulté: 2,
)

On étudie une boule de rayon $R$ constituée d'uranium 235.

L'uranium 235 n'a pas un noyau stable, celui-ci peut se fissionner en "captant" un neutron selon la réaction nucléaire

#ce[$""^235_92$U] + 1 neutron $->$ #ce("X") + #ce("Y") + $nu$ neutrons

où #ce("X") et #ce("Y") sont deux noyaux plus légers. La valeur moyenne de $nu$ est #num("2.5"). Cette réaction a une probabilité $n/tau$ de se produire par unité de temps et de volume.

On se place en coordonnées sphériques, note $n(r,t)$ le nombre de neutrons par unité de volume et $va(j)(r,t)$ le vecteur densité de courant de neutrons.

On donne, en sphériques, pour des grandeurs ne dépendant que de $r$ et de $t$ :
- $grad n=pdv(n, r) er$
- $div va(j)=1/r^2 pdv(, r)(r^2j)$
- $Delta n = 1/r^2pdv(, r)(r^2 pdv(n, r))$

On prend pour condition aux limites $n(r=R)=0$

#question(
    coups-de-pouce: (
        "Combien de neutrons sont captés durant $dd(t)$ dans le volume considéré ? Combien sont émis ?",
    ),
)[
    En faisant un bilan de neutron sur un volume mésoscopique, démontrer l'équation fondamentale de la neutronique :
    $ pdv(n, t) = -div j + (nu-1)/tau n $
][
    On fait un bilan de neutrons sur une coquille sphérique de rayon intérieur $r$ et d'épaisseur $dd(r)$.
    $dd(N, 2) = delta^2 N$
    $
        dd(N, 2) = pdv(n, t) dd(V) dd(t)
    $
    À chaque fois que le réaction se produit, $nu$ neutrons sont émis et un neutron est capté, donc $nu-1$ neutrons supplémentaires apparaissent. Le nombre de réactions dans le volume élémentaire durant $dd(t)$ est $n/tau dd(V) dd(t)$. Donc
    $
        delta^2 N & = (nu-1)/tau n dd(V) dd(t) + (j(r) 4 pi r^2 - j(r+dd(r)) 4 pi (r+dd(r))^2) dd(t) \
                  & = (nu-1)/tau n dd(V) dd(t) - 4 pi pdv(, r) (r^2 j(r)) dd(r) dd(t) \
    $
    Or $dd(V) = 4 pi r^2 dd(r)$, donc en divisant par $dd(V) dd(t)$ on trouve l'équation
    $
        pdv(n, t) & = (nu-1)/tau n - 1/r^2 pdv(, r) (r^2 j(r)) \
                  & = -div va(j) + (nu-1)/tau n \
    $
]

#question(
    coups-de-pouce: (
        "Il faut procéder par séparation des variables.",
        "Remplacer $j$ par la loi de Fick dans l'équation obtenue précédemment.",
    ),
)[
    On recherche une solution de l'équation ci-dessus sous la forme $N(r,t) = ( f(t)g(r) )/r$. Montrer que $f$ et $g$ vérifient les équations différentielles suivantes :
    $
        dv(f, t) = K f(t) \
        D dv(g, r, 2) + ( (nu-1)/tau - K ) g(r) = 0 \
    $
    où $K$ est une constante qu'on ne cherchera pas à déterminer pour l'instant.
][
    La loi de Fick donne $va(j) = -D grad n = -D pdv(n, r) er = -D f(t) pdv(, r)g(r)/r$, avec $D$ la diffusivité des neutrons dans l'uranium 235. Donc
    En replaçant dans l'équation, on trouve
    $
        g(r)/r dv(f, t) & = D f(t) 1/r^2 dv(, r) (r^2 dv(g(r)/r, r)) + (nu-1)/tau f(t)g(r)/r \
        g(r)/r dv(f, t) & = D f(t) 1/r^2 dv(, r) (r^cancel(2) 1/cancel(r) dv(g, r) - cancel(r^2)/cancel(r^2)g(r)) + (nu-1)/tau f(t)g(r)/r \
        g(r)/r dv(f, t) & = D f(t) 1/r^2 ( r dv(g, r, 2) + cancel(dv(g, r)) - cancel(dv(g, r)) ) + (nu-1)/tau f(t)g(r)/r \
    $
    On sépare les variables :
    $
        1/f(t) dv(f, t) = D 1/g(r) dv(g, r, 2) + (nu-1)/tau
    $
    Le terme de gauche ne dépend pas de $r$, donc le terme de droite non plus (car ils sont égaux).

    Le terme de droite ne dépend pas de $t$, donc le terme de gauche non plus (car ils sont égaux).

    Il en résulte que les deux termes sont égaux à une constante que l'on note $K$.

    On obtient ainsi les deux équations différentielles :
    $
        dv(f, t) = K f(t) \
        D dv(g, r, 2) + ( (nu-1)/tau - K ) g(r) = 0 \
    $
]

#question(
    coups-de-pouce: (
        "Distinguer les cas sur le discriminant et utiliser les conditions aux limites pour trouver les constantes.",
        "La densité particulaire est une grandeur positive et finie.",
    ),
)[
    Quelles sont les différentes formes de solution pour $g(r)$. Lesquelles sont compatibles avec les conditions aux limites ? Résoudre l'équation différentielle sur $g(r)$.
][
    Le discriminant de l'équation caractéristique est
    $
        Delta & = 0^2 - 4 D ( (nu-1)/tau - K ) \
              & = -4 D ( (nu-1)/tau - K ) \
    $
    - Si $Delta > 0$, c'est-à-dire si $K > (nu-1)/tau$, les solutions sont de la forme
    $ g(r) = A exp(r sqrt((K-(nu-1)/tau)/D)) + B exp(-r sqrt((K-(nu-1)/tau)/D)) $
    La condition $n(R)=0$ impose $g(R)=0$, donc $A exp(R sqrt((K-(nu-1)/tau)/D)) + B exp(-R sqrt((K-(nu-1)/tau)/D)) = 0$. Or la première exponentielle diverge pour $r -> +infinity$, donc pour que $g(r)$ reste finie pour tout $r$, il faut que $A=0$. Il en résulte que $B exp(-R sqrt((K-(nu-1)/tau)/D)) = 0$, donc $B=0$. La seule solution est la solution triviale.
    - Si $Delta = 0$, c'est-à-dire si $K = (nu-1)/tau$, les solutions sont de la forme $g(r) = A + B r$. La condition $g(R)=0$ impose $A + B R = 0$. Pour que $g(r)$ ne diverge pas en $0$, il faut que $B=0$ et donc $A=0$. La seule solution est la solution triviale.
    - Si $Delta < 0$, c'est-à-dire si $K < (nu-1)/tau$, les solutions sont de la forme $g(r) = A cos(r sqrt(((nu-1)/tau - K)/D)) + B sin(r sqrt(((nu-1)/tau - K)/D))$. La condition $g(R)=0$ impose $A cos(R sqrt(((nu-1)/tau - K)/D)) + B sin(R sqrt(((nu-1)/tau - K)/D)) = 0$. Pour que $g(r)$ reste finie en $0$, il faut que $A=0$. Il en résulte que $B sin(R sqrt(((nu-1)/tau - K)/D)) = 0$. Pour une solution non triviale, il faut que $sin(R sqrt(((nu-1)/tau - K)/D)) = 0$, donc $R sqrt(((nu-1)/tau - K)/D) = k pi$ avec $k in NN^*$. Les valeurs de $k$ différentes de $1$ donnent lieu à des densité particulaires positives.

    On en déduit finalement que la seule solution non triviale est obtenue pour $k=1$ :
    $ g(r) = B sin(pi r / R) $
    avec
    $
        R sqrt(((nu-1)/tau - K)/D) = pi\
        ((nu-1)/tau - K)/D = (pi/R)^2 \
        K = (nu-1)/tau - D (pi/R)^2 \
    $
]

#question(
    coups-de-pouce: (),
)[
    Quelle est la forme de la solution de l'équation sur $f(t)$.
][
    L'équation différentielle sur $f(t)$ est $dv(f, t) = K f(t)$. La solution est
    $ f(t) = f(0) exp(K t) $
]

#question(
    coups-de-pouce: (
        "À quelle condition la densité particulaire croît-elle exponentiellement avec le temps ?",
    ),
)[
    Sous quelle condition sur le rayon la réaction s’emballe-t-elle ?
][
    La réaction s'emballe lorsque la densité particulaire croît exponentiellement avec le temps, c'est-à-dire lorsque $K > 0$, c'est-à-dire lorsque
    $
        (nu-1)/tau - D (pi/R)^2 > 0 \
        <=> (nu-1)/tau > D (pi/R)^2 \
        <=> R^2 > D tau (pi^2)/(nu-1) \
        <=> R > pi sqrt(D tau/(nu-1)) \
    $
]

#question(
    coups-de-pouce: (),
)[
    En déduire la masse critique d'uranium 235 nécessaire pour qu'une réaction en chaîne puisse se produire. La masse volumique de l'uranium 235 est #qty("19.1", "g/cm^3"), le coefficient de diffusion des neutrons dans l'uranium 235 est #qty("2e5", "m^2/s") et le temps moyen avant capture d'un neutron est #qty("5.4e-9", "s").
][
    #let D = 2e5
    #let ta = 5.4e-9
    #let nu-moyen = 2.5
    #let Rc = calc.pi*calc.sqrt(D * ta/(nu-moyen - 1))
    #let mv = 19.1e3
    #let mc = mv * 4/3 * calc.pi * calc.pow(Rc,3)
    $
        m_c & = mu 4/3 pi R_c^3 \
            & = mu 4/3 pi (pi sqrt(D tau/(nu-1)))^3 \
            & = #qty(scientifique(mc,1), "kg")
    $
]
