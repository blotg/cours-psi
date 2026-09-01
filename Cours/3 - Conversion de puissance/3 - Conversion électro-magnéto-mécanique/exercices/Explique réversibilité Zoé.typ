#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Fonctionnement réversible d'un moteur électrique",
    explique: true,
)

Dans une voiture électrique, lors du freinage, une partie de l'énergie est récupérée pour recharger la batterie.

#question(
    coups-de-pouce: (),
)[
    Comment se fait-il que le moteur électrique puisse récupérer l'énergie ?
][
    Dans un moteur de voiture, il y a deux parties :
    - une partie qui tourne (le rotor) avec un champ magnétique fixe, tel que celui créé par un aimant.
    - une partie fixe (le stator) avec des fils dans lesquels passent un courant électrique.

    Lorsque le moteur fonctionne en mode "moteur", le courant dans les fils du stator crée un champ magnétique tournant qui entraine le rotor en rotation, comme une aiguille de boussole qui s'aligne sur un champ magnétique.

    Lorsque le moteur fonctionne en mode "générateur" (lors du freinage), le champ magnétique du rotor induit des courants dans les fils du stator, comme le champ magnétique variable des plaques à induction qui induisent des courants dans le fond des casseroles.
]
