#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Ondes sonores dans un fluide visqueux",
)

On étudie une onde sonore dans un fluide. L'onde est plane, progressive et se déplace dans le sens des $x$ croissants. Au repos, la masse volumique du fluide est $rho_0$ et la pression $P_0$. Le coefficient de compressibilité adiabatique est $chi_S$. L'effet de la pesanteur est négligé. On se place dans le cadre de l'approximation acoustique.

On tient compte de la viscosité du fluide. La résultante volumique des forces de viscosité est $eta Delta va(v)$, où $v$ est le champ des vitesses dans le fluide. On note $P_1$ le champ de surpression.

#question(
    coups-de-pouce: (
        "Reprendre le PDF sur une particule de fluide du cours, en ajoutant cette fois ci la force de viscosité.",
        "L'énoncé précise que l'onde se propage selon $x$. Simplifier les opérateurs vectoriels dans ce cas.",
    ),
)[
    Montrer que le théorème de la résultante cinétique appliqué à une particule de fluide, dans l'approximation acoustique, en projection sur l'axe $(O x)$ donne
    $
        rho_0 pdv(v, t) = - pdv(P_1, x) + eta pdv(v, x, 2)
    $
][
    Le TRC appliqué à une particule de fluide s'écrit
    $
        rho_0 dd(V) pdv(va(v), t) = - grad(P_1) dd(V) + eta Delta va(v) dd(V)
    $
    En projection sur l'axe $(O x)$, on trouve l'équation donnée dans l'énoncé.
]


#question(
    coups-de-pouce: (
        "L'équation thermodynamique et l'équation locale de conservation de la masse restent inchangées.",
        "Dériver l'équation locale de conservation de la masse d'une part par rapport à $x$ et d'autre part par rapport à $t$ afin d'éliminer les $v_1$ de l'équation de la question 1.",
    ),
)[
    Montrer que l'équation d'onde dans ce fluide visqueux s'écrit
    $
        pdv(P_1, x, 2) - 1/c^2 pdv(P_1, t, 2) = eta pdv(v, x, 3)
    $
][
    L'équation locale de conservation de la masse s'écrit
    $
        pdv(rho_1, t) = -rho_0 div va(v) = -rho_0 pdv(v, x)
    $
    L'équation thermodynamique s'écrit
    $
        rho_1 = rho_0 chi_S P_1
    $
    On obtient alors
    $
        pdv(rho_1, t) = rho_0 chi_S pdv(P_1, t) = -rho_0 pdv(v, x)
    $
    D'où
    $
        chi_S pdv(P_1, t) = - pdv(v, x)
    $
    En dérivant l'équation de la question 1 par rapport à $x$ et celle ci par rapport à $t$, on trouve
    $
        cases(
            rho_0 pdv(v, x, t) = - pdv(P_1, x, 2) + eta pdv(v, x, 3),
            rho_0 chi_S pdv(P_1, t, 2) = -rho_0 pdv(v, t, x)
        )
    $
    On peut alors appliquer le théorème Schwarz et combiner ces équations :
    $
        rho_0 chi_S pdv(P_1, t, 2) = pdv(P_1, x, 2) - eta pdv(v, x, 3) = pdv(P_1, x, 2) + eta chi_S pdv(, x, 2) pdv(P_1, t)
    $
    Soit, en introduisant la célérité du son $c = 1/sqrt(rho_0 chi_S)$,
    $
        pdv(P_1, x, 2) - 1/c^2 pdv(P_1, t, 2) = - eta chi_S pdv(, x, 2) pdv(P_1, t)
    $
]

#let c = 340
#let f = 1e3
#let n = 1.85e-5
#let mv = 1
#let d = (2 * c) / (4 * calc.pow(calc.pi, 2) * calc.pow(f, 2) * n * 1 / (mv * calc.pow(c, 2)))

#question(
    coups-de-pouce: (
        "Passer en complexes l'équation d'onde.",
        "Simplifier l'équation de dispersion compte tenu de l'hypothèse pour obtenir $underline(k)^2 approx omega^2/c^2 e^(j (eta chi_S omega))$.",
        "Quelle relation relie l'épaisseur de peau avec le nombre d'onde complexe ?"
    ),
)[
    L'onde est plane, progressive et harmonique de fréquence $f=qty("1.0e3", "Hz")$ et se propage dans le sens des $x$ croissants. On suppose le milieu faiblement dispersif, c'est-à-dire $eta chi_S omega << 1$. Établir l'équation de dispersion puis l'épaisseur dont on effectuera l'application numérique pour l'air à #qty("20", "celsius"). On donne la viscosité de l'air $eta = qty("1.85e-5", "Pl")$
][
    En complexe l'équation d'onde donne
    $
        - underline(k)^2 underline(P_1) + 1/c^2 omega^2 underline(P_1) = - eta chi_S (-underline(k)^2) (j omega) underline(P_1)
    $
    On en déduit la relation de dispersion :
    $
        underline(k)^2(1+j eta chi_S omega) = omega^2/c^2
    $
    d'où
    $
        underline(k)^2=omega^2/c^2 1/(1+j eta chi_S omega)
        = omega^2/c^2 (1-j eta chi_S omega)/(1+eta^2chi_S^2 omega^2) approx omega^2/c^2 (1-j eta chi_S omega)
        approx omega^2/c^2 e^(-j eta chi_S omega)
    $
    On en déduit $underline(k) approx omega/c e^(-j (eta chi_S omega)/2)$ d'où, en décomposant partie réelle et partie imaginaire :
    $
        k_r + j k_i approx omega/c (1-j (eta chi_S omega)/2 )
    $
    Et donc
    $
        cases(
            k_r approx omega/c,
            k_i approx - (omega^2 eta chi_S)/(2c)
        )
    $
    Finalement
    $
        delta = 1/(|k_i|) = (2c)/(omega^2 eta chi_S) = (2 c)/(4 pi^2 f^2 eta 1/(rho_0 c^2))
    $
    Avec $c = qty("340", "m/s")$, $rho_0=qty("1", "kg/m^3")$, on obtient
    $
        delta = #qty(scientifique(d, 2), "m")
    $
]

#question(
    coups-de-pouce: (
        "Après avoir parcourue une distance égale à l'épaisseur de peau, par combien est divisée l'amplitude de l'onde ?",
        "À part l'absorption, quel autre phénomène peut être responsable de l'atténuation de l'amplitude d'une onde ?",
    ),
)[
    Est-ce la raison pour laquelle on entend moins bien un son quand on s'éloigne de sa source ?
][
    Si la seule cause d'atténuation était l’absorption décrite dans cet exercice, au bout de $delta approx #qty(scientifique(d, 2), "m")$, l'amplitude de l'onde serait divisée par $e approx #num(scientifique(calc.e, 2))$. Or, l'amplitude est bien plus faible à une si longue distance.

    Les ondes sonores du quotidien ne sont pas planes mais souvent sphériques et leur atténuation est due majoritairement à un étalement de leur puissance sur des surfaces d'ondes de plus en plus grandes au fur et à mesure de leur propagation.
]
