#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Différence de vitesse entre la fibre optique et l'ADSL",
    explique: true,
)

L'ADSL utilise des câbles en cuivre pour transmettre les données, tandis que la fibre optique utilise des fibres de verre ou de plastique. La fibre optique permet une transmission de données à des vitesses beaucoup plus élevées que l'ADSL.

#question()[
    Pourquoi la fibre optique est-elle plus rapide que l'ADSL ?
][
    Si la fibre optique est plus rapide que l'ADSL, ce n'est pas parce que le signal arrive plus vite à destination (les vitesses sont de l'ordre de la vitesse de la lumière dans les deux cas). De toute façon, un temps de trajet plus court ne changerait que le "ping" (temps mis par un signal pour faire un aller-retour).

    Quand on dit que la fibre est plus rapide, cela concerne les débits : le nombre d'informations échangées par seconde.

    Quand un signal se propage, il a tendance à s'étaler. S'il s'étale trop et "bave" sur le signal d'après, les deux signaux peuvent être mélangés et impossibles à traiter par le récepteur. Pour éviter cela, on doit espacer les signaux, et ce d'autant plus qu'ils s'étalent.

    Dans un câble en cuivre, les signaux s'étalent beaucoup plus que dans une fibre optique, ce qui oblige à les espacer davantage. On a donc moins de signaux par seconde dans les câbles en cuivre, et donc un débit plus faible.
]