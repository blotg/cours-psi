#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Hachage sur charge inductive",
)

#figure(
    zap.circuit({
        import zap: *
        vsource("E", (0, 0), (0, 5), u: $E$)
        diode("D", (3, 0), (3, 5), u: $u_s$)
        thyristor("T", (0, 5), (3, 5), i: (content: $i_e$, anchor: "west", invert: true))
        resistor("r", (5, 0), (5, 2.5), label: $r$, u: (content: $u_r$, anchor: "south"))
        inductor("L", (5, 2.5), (5, 5), label: $L$, variant: "ieee")
        wire((0, 0), (5, 0))
        fil((3, 5), (5, 5), i: $i_s$)
    }),
)

Le hacheur ci-dessous sert à transférer de la puissance électrique depuis un générateur de tension $E$ continu vers un récepteur inductif de résistance $r$ et d'inductance $L$.

Le fonctionnement est périodique de fréquence $f=#qty("2.0", "kH")$. L'interrupteur commandé est fermé sur $[0,alpha T[$, ouvert sur $[alpha T,T[$, avec $alpha=0.3$. On précise $E=#qty("100", "V")$ et $r=#qty("10", "O")$.
#let RC = 0.3
#let E = 100
#let r = 10


#question(
    coups-de-pouce: (
        "Lorsque le transistor est passant, quel doit être l'état de la diode ? Lorsque le transistor est bloqué, quel doit être l'état de la diode ?",
    ),
)[
    Dans quel état est la diode sur $[0,alpha T[$ ? sur $[alpha T,T[$ ?
][
    L'interrupteur commandé est le transistor.

    La diode et le transistor ne peuvent pas être passants simultanément car la source de tension $E$ serait court-circuitée.

    La diode et le transistor ne peuvent pas être bloqués simultanément car le courant dans l'inductance $L$ ne pourrait pas se maintenir, or le courant ne peut pas s'annuler brutalement dans une inductance. On peut aussi le justifiant en disant que le dipole r-L est un dipole de type source de courant qui ne peut donc pas être en circuit ouvert.

    / Sur $[0,alpha T[$: le transistor est passant, donc la diode est *bloquée*.
    / Sur $[alpha T,T[$: le transistor est bloqué, donc la diode est *passante*.
]

#question(
    coups-de-pouce: (
        "Dans chacun des cas, redessiner le schéma avec les interrupteurs dans le bon état.",
        "Appliquer la loi des mailles dans chacun des cas.",
    ),
)[
    Établir les équations différentielles qui régissent l'évolution du courant $i_s$, sur $[0,alpha T[$ et $[alpha T,T[$.
][
    #grid(
        columns: (1fr, 1fr),
        figure[
            *Sur $[0,alpha T[$*
            #zap.circuit({
                import zap: *
                vsource("E", (0, 0), (0, 5), u: $E$)
                switch("D", (3, 0), (3, 5), u: $u_s$, closed: false)
                switch("T", (0, 5), (3, 5), i: (content: $i_e$, anchor: "west", invert: true), closed: true)
                resistor("r", (5, 0), (5, 2.5), label: $r$, u: (content: $u_r$, anchor: "south"))
                inductor("L", (5, 2.5), (5, 5), label: $L$, variant: "ieee")
                wire((0, 0), (5, 0))
                fil((3, 5), (5, 5), i: $i_s$)
            }),
        ],
        figure[
            *Sur $[alpha T,T[$*
            #zap.circuit({
                import zap: *
                vsource("E", (0, 0), (0, 5), u: $E$)
                switch("D", (3, 0), (3, 5), u: $u_s$, closed: true)
                switch("T", (0, 5), (3, 5), i: (content: $i_e$, anchor: "west", invert: true), closed: false)
                resistor("r", (5, 0), (5, 2.5), label: $r$, u: (content: $u_r$, anchor: "south"))
                inductor("L", (5, 2.5), (5, 5), label: $L$, variant: "ieee")
                wire((0, 0), (5, 0))
                fil((3, 5), (5, 5), i: $i_s$)
            }),
        ],
    )
    / Sur $[0,alpha T[$: la maille donne $E - r i_s - L dv(i_s, t) = 0$, soit
    $ dv(i_s, t)+ r/L i_s = E/L $
    / Sur $[alpha T,T[$: la maille donne $r i_s + L dv(i_s, t) = 0$, soit
    $ dv(i_s, t)+ r/L i_s = 0 $
]

#question(
    coups-de-pouce: (
        "A quelle condition le développement limité de l'exponentielle donne-t-il une fonction affine ?",
    ),
)[
    Résoudre les équations différentielles sur $i_s$, sans chercher à exprimer les constantes. À quelle condition sur les valeurs de $r$, $L$, et $T$, l'évolution du courant dans la charge est-elle affine par morceau ?
][
    / Sur $[0,alpha T[$ : $i_s(t) = A e^(-r/L t) + E/r$.
    / Sur $[alpha T,T[$ : $i_s(t) = B e^(-r/L t)$.
    Si $r/L T<<1$, $e^(-r/L t) approx 1 - r/L t$ et les fonctions sont affines par morceaux.
]

#question(
    coups-de-pouce: (
        "Relier les valeurs moyenne de $u_s$, $u_L$ et $u_r$.",
        "Exprimer la valeur moyenne de $u_s$ en fonction de $alpha$ et $E$. On pourra tracer un chronogramme de $u_s$.",
        "Que vaut la valeur moyenne de $u_L$ ?",
    ),
)[
    Établir l'expression de la valeur moyenne de l'intensité du courant dans la charge en fonction de $alpha$, $E$ et $r$. Effectuer l'application numérique.
][
    La loi des mailles donne $u_s = u_r + u_L$, soit en valeur moyenne 
    $alpha E = r mean(i_s) + 0$ d'où
    #let ism = (RC * E) / r
    $ mean(i_s) = (alpha E)/r = #qty(scientifique(ism,2),"A") $
]
