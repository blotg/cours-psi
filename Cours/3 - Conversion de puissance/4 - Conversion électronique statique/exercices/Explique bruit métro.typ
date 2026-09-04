#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Le bruit aigu quand le métro démarre",
    explique: true,
)

Lors du démarrage et du ralentissement de certains métros, on peut entendre un bruit aigu.

#lien("https://www.youtube.com/shorts/LRoi3NtIZE4")

#question(
    coups-de-pouce: (),
)[
    D'où vient ce bruit ?
][
    Pour faire tourner les moteurs électriques du métro à vitesse réduite, on pourrait avoir l'idée d'utiliser une tension plus faible. Il se trouve que faire ceci n'est pas facile et pose de nombreux problèmes. Il est plus facile de "hacher" la tension des moteurs : on va très rapidement les allumer et les éteindre, comme ils n'auront pas le temps d'accélérer et de décélérer, ils vont tourner à vitesse réduite.

    Ce "hachage" fait qu'il va y avoir alternativement du courant qui passe puis qui ne passe plus. Cette variation du courant va induire des vibrations dans les parties métalliques et parfois dans les haut parleurs du métro, causant un bruit aigu.
]
