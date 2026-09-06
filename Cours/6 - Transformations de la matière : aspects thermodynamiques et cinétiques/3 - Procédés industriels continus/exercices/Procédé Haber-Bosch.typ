#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Procédé Haber-Bosch",
    numérique: true,
    difficulté: 2,
)

On s'intéresse à la synthèse de l'ammoniac #ce("NH3") par le procédé Haber-Bosch, qui combine l'azote #ce("N2") et l'hydrogène #ce("H2") selon la réaction chimique
$ ce("N2 + 3H2 -> 2NH3") $

La réaction est réalisée dans un réacteur piston adiabatique de section $S = #qty("5", "cm^2")$, de longueur $L = #qty("6", "m")$ à la pression $P=qty("200", "bar")$.

La vitesse volumique de réaction à la position $x$ dans le réacteur dépend des pressions partielles et s'écrit
$ r = k(T) (P_ce("N2")P_ce("H2")^3-(P_ce("NH3")^2 standard(P)^2)/(K^circ (T))) $

On se place dans l'approximation d'Ellingham. L'écoulement est supposé lent et horizontal. Le réacteur ne comporte aucune pièce mobile.

#question(
    coups-de-pouce: "Énoncer la loi d’Arrhenius.",
)[
    Exprimer la constante de vitesse de réaction $k(T)$ en fonction de l'énergie d'activation $E_a$ et de la température $T$.
][
    La loi d'Arrhenius s'écrit
    $
        k(T) = A exp(- E_a / (R T))
    $
    où $A$ est le facteur préexponentiel.
]

#question(
    coups-de-pouce: (
        "Exprimer la pression partielle en fonction de la fraction molaire.",
        "Diviser les quantités de matière par le volume pour faire apparaitre des concentrations. Comment faire apparaitre des débits molaires ?",
        "Quel est le lien entre la constante d'équilibre et l'enthalpie libre standard de réaction ?",
    ),
)[
    Exprimer les pressions partielles des différentes espèces en fonction des débits molaires et de la pression $P$. En déduire l'écriture d'une fonction Python `r(F_N2, F_H2, F_NH3, T)` qui calcule la vitesse volumique de réaction.
][
    $
        cases(
            P_ce("N2") = F_ce("N2") / (F_ce("N2") + F_ce("H2") + F_ce("NH3")) P,
            P_ce("H2") = F_ce("H2") / (F_ce("N2") + F_ce("H2") + F_ce("NH3")) P,
            P_ce("NH3") = F_ce("NH3") / (F_ce("N2") + F_ce("H2") + F_ce("NH3")) P,
        )
    $
    La constante d'équilibre s'écrit
    $
        K^circ (T) = exp(- (Delta_r G^circ) / (R T)) = exp(- (Delta_r H^circ - T Delta_r S^circ) / (R T))
    $
    ```python
    import numpy as np
    R = 8.314  # J/(mol·K)
    DrH = -92.2e3
    DrS = -198
    P = 200e5  # en Pa
    A = 1e-8   # facteur préexponentiel
    E_a = 160e3  # en J/mol
    def r(F_N2, F_H2, F_NH3, T):
        P_N2 = F_N2 / (F_N2 + F_H2 + F_NH3) * P
        P_H2 = F_H2 / (F_N2 + F_H2 + F_NH3) * P
        P_NH3 = F_NH3 / (F_N2 + F_H2 + F_NH3) * P
        k = A * np.exp(-E_a / (R * T))
        K = np.exp(- (DrH - T * DrS) / (R * T))
        return k * (P_N2 * P_H2**3 - P_NH3**2 * 1e5**2 / K)
    ```
]

#question[
    En effectuant des bilans de matière sur une tranche élémentaire du réacteur, montrer que les débits molaires des différentes espèces vérifient
    $
        cases(
            dv(F_ce("N2"), x) = - S r(x),
            dv(F_ce("H2"), x) = - 3 S r(x),
            dv(F_ce("NH3"), x) = 2 S r(x),
        )
    $
][
    On fait un bilan de matière de #ce("N2") sur une tranche d'épaisseur $dd(x)$ de réacteur en régime stationnaire :
    $
        0 = F_ce("N2")(x) cancel(dd(t)) - F_ce("N2")(x + dd(x)) cancel(dd(t)) - r(x) dd(V) cancel(dd(t))
    $
    $
        0 = -dv(F_ce("N2"), x) cancel(dd(x)) - r(x) S cancel(dd(x))
    $
    D'où l'équation demandée
    $
        dv(F_ce("N2"), x) = - S r(x)
    $
    C'est le même principe pour #ce("H2") et #ce("NH3"), avec les coefficients stœchiométriques appropriés.
]

#question[
    En effectuant un bilan d'enthalpie sur une tranche élémentaire du réacteur, montrer que la température dans le réacteur vérifie
    $
        dv(T, x) = (- r(x) S Delta_r H^circ) / (F_ce("N2")(x) M_ce("N2") c_(P,ce("N2")) + F_ce("H2")(x) M_ce("H2") c_(P,ce("H2")) + F_ce("NH3")(x) M_ce("NH3") c_(P,ce("NH3")))
    $
][
    Le réacteur est adiabatique et sans pièce mobile : le PPI appliqué à une tranche d'épaisseur $dd(x)$ en régime stationnaire annule le flux d'enthalpie total,
    $
        0 = (sum_i F_ce("i") M_ce("i") c_(P,ce("i"))) dd(T) + Delta_r H^circ dv(xi, t)
    $
    Le premier terme est l'échauffement du mélange à composition figée (seconde loi de Joule, le débit massique de l'espèce $i$ valant $F_ce("i") M_ce("i")$), le second l'effet thermique de la réaction. Sur la tranche, $dv(xi, t) = r(x) S dd(x)$, d'où
    $
        dv(T, x) = (- r(x) S Delta_r H^circ) / (F_ce("N2")(x) M_ce("N2") c_(P,ce("N2")) + F_ce("H2")(x) M_ce("H2") c_(P,ce("H2")) + F_ce("NH3")(x) M_ce("NH3") c_(P,ce("NH3")))
    $
]

On souhaite déterminer numériquement les profils de débits molaires et de température dans le réacteur. Le problème est sous la forme d'un problème d'Euler, on le résout en utilisant la fonction `solve_ivp` du module `scipy.integrate`. Cette fonction renvoie un objet `solution` contenant notamment `solution.t` (les positions dans le réacteur) et `solution.y` (les valeurs des variables d'état aux différentes positions).

#question()[
    Compléter le code Python suivant.
    ```python
    S = 5e-4  # m^2
    M_N2 = 28e-3  # kg/mol
    M_H2 = 2e-3  # kg/mol
    M_NH3 = 17e-3  # kg/mol
    c_P_N2 = 1040  # J/(kg·K)
    c_P_H2 = 2230  # J/(kg·K)
    c_P_NH3 = 2175  # J/(kg·K)
    def f(t,Y):
        F_N2, F_H2, F_NH3, T = Y
        dF_N2 = ...
        dF_H2 = ...
        dF_NH3 = ...
        dT = ...
        return [dF_N2, dF_H2, dF_NH3, dT]
    ```
][
    ```python
    S = 5e-4  # m^2
    M_N2 = 28e-3  # kg/mol
    M_H2 = 2e-3  # kg/mol
    M_NH3 = 17e-3  # kg/mol
    c_P_N2 = 1040  # J/(kg·K)
    c_P_H2 = 2230  # J/(kg·K)
    c_P_NH3 = 2175  # J/(kg·K)
    def f(t,Y):
        F_N2, F_H2, F_NH3, T = Y
        r_val = r(F_N2, F_H2, F_NH3, T)
        dF_N2 = - S * r_val
        dF_H2 = - 3 * S * r_val
        dF_NH3 = 2 * S * r_val
        dT = (- r_val * S * DrH) / (F_N2 * M_N2 * c_P_N2 + F_H2 * M_H2 * c_P_H2 + F_NH3 * M_NH3 * c_P_NH3)
        return [dF_N2, dF_H2, dF_NH3, dT]
    ```
]

Les réactifs sont introduits dans le réacteur dans les proportions stœchiométriques, sans ammoniac initialement et avec un débit volumique total de #qty("4000", "m^3/h") et une température de $#qty("500", "K")$.

#question[
    Compléter le code Python suivant pour résoudre numériquement le problème.
    ```python
    T_0 = ...
    F_N2_0 = ...
    F_H2_0 = ...
    F_NH3_0 = ...
    L = 6
    Y0 = [F_N2_0, F_H2_0, F_NH3_0, T_0]
    from scipy.integrate import solve_ivp
    solution = solve_ivp(f, [0, L], Y0, "BDF")
    ```
][
    D'après l'équation d'état des gaz parfaits, le débit molaire en entrée est
    $
        F_"tot" = (P D_V)/(R T)
    $
    On en déduit les débits molaires initiaux
    $
        cases(
            F_ce("N2")_0 = F_"tot" / 4 = (P D_V)/(4 R T),
            F_ce("H2")_0 = 3 F_"tot" / 4 = (3 P D_V)/(4 R T),
            F_ce("NH3")_0 = 0,
        )
    $
    ```python
    T_0 = 500
    D_V = 4000 / 3600  # en m^3/s
    F_N2_0 = P * D_V / (4 * R * T_0)
    F_H2_0 = 3 * P * D_V / (4 * R * T_0)
    F_NH3_0 = 0
    ```
]

#question()[
    Que vaut le taux de conversion de l'azote dans le réacteur ? Quelle température est atteinte à la sortie du réacteur ?
][
    Le taux de conversion de l'azote est
    $
        X_ce("N2") = (F_ce("N2")_0 - F_ce("N2")_L) / F_ce("N2")_0
    $
    ```python
    F_N2_L = solution.y[0,-1]
    X_N2 = (F_N2_0 - F_N2_L) / F_N2_0
    print("Taux de conversion de l'azote :", X_N2)
    T_L = solution.y[3,-1]
    print("Température à la sortie du réacteur :", T_L)
    ```
]

*Données*
- $R = qty("8.314", "J/mol/K")$
- $E_a = #qty("160", "kJ/mol")$
- $A = #qty("1e-8", "mol/s/m^3/Pa^4")$ le facteur préexponentiel
- $Delta_r H^circ = #qty("-92.2", "kJ/mol")$
- $Delta_r S^circ = #qty("-198", "J/mol/K")$

#figure(
    table(
        columns: 4,
        align: (left,) + (center + horizon,) * 3,
        [Espèce], ce("N2"), ce("H2"), ce("NH3"),
        [Masse molaire (#unit("g/mol"))], num("28"), num("2"), num("17"),
        [Capacité thermique massique\ à pression constante (#unit("J/kg/K"))], num("1040"), num("2230"), num("2175"),
    ),
)
