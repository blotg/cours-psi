#import "@local/prepa:0.1.0": *

#show: exercice.with(
    titre: "Transport de l'électricité en haute tension",
    explique: true,
)

#question(
    coups-de-pouce: (),
)[
    Pourquoi l'électricité est-elle transportée en haute tension sur de longues distances ?
][
    Quand de l'électricité passe dans un cable, celui-ci chauffe. Ceci constitue une perte d'énergie. Plus le courant est important, plus ça chauffe et plus il y a de pertes.

    La puissance électrique est la multiplication entre la tension et le courant : $P = U times I$. Pour transporter une puissance de #qty("1000","W"), on peut par exemple utiliser une tension de #qty("100", "V") et un courant de #qty("10", "A"), ou bien une tension de #qty("1000", "V") et un courant de #qty("1", "A"). Dans le second cas, il y a moins de courant, donc moins de pertes dans le câble.
]
