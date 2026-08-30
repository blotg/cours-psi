#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "La sélection des stations de radio",
    explique: true,
)

#question()[
    Comment peut-on diffuser plein de stations de radio sur les ondes sans qu'elles se mélangent, et comment fait mon poste de radio pour sélectionner celle que je veux écouter ?
][
    Pour envoyer plusieurs stations de radio en même temps sur les ondes, on utilise une technique appelée modulation. Le principe, c'est de mélanger la station de radio qu'on veut émettre à un autre signal, qu'on appelle la porteuse (car c'est elle qui « transporte » la station de radio). À chaque station de radio correspond sa porteuse. C'est la porteuse qu'on règle sur l'autoradio pour choisir la station qu'on veut écouter.

    Pour « décoder » la radio (on dit « démoduler »), le poste de radio mélange à son tour le signal reçu avec la porteuse de la station qu'on veut écouter (la même qu'on avait utilisée pour moduler) et, après un peu de filtrage pour enlever les signaux indésirables, on retrouve le signal de la station qu'on souhaite écouter.

    Il faut juste faire attention à ce que plusieurs stations n'aient pas des porteuses trop proches, sinon elles risqueraient de se mélanger et le poste de radio n'arriverait plus à les séparer. C'est ça qui limite le nombre de stations de radio qui peuvent être diffusées en même temps.
]
