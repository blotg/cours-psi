#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Relèvement du facteur de puissance",
    difficulté: 2,
)

Une installation industrielle comporte en parallèle deux machines assimilées à des impédances inductives qui consomment respectivement les puissances $P_1=qty("2000", "W")$ avec un facteur de puissance $cos phi_1=0,6$ et $P_2=qty("3000", "W")$ avec un facteur de puissance $cos phi_2=0,7$, en parallèle desquelles sont branchées des lampes consommant au total une puissance $P_L=qty("2000", "W")$. Les lampes sont assimilées à des résistances.

La tension aux bornes de l'installation est sinusoïdale de fréquence $f=qty("50", "Hz")$ et sa valeur efficace est $U_"eff"=qty("230", "V")$.

#question(
    coups-de-pouce: (
        "Déterminer l'admittance de chaque machine  et des lampes, puis l'admittance totale.",
        "Déterminer la partie réelle de l'admittance grâce à la puissance. Représenter l'admittance sur un diagramme de Fresnel et en déduire une relation entre $phi$, la partie réelle et la partie imaginaire de m'admittance.",
    ),
)[
    Calculer le facteur de puissance et la valeur efficace du courant consommé par l'installation complète et commenter le résultat.
][
    On calcule les admittances des deux machines et des lampes : $Y_1$, $Y_2$ et $Y_L$.

    Les lampes sont purement résistives donc $ Y_L=P_L/U_"eff"^2 = qty("38", "mS") $

    Pour la machine 1, on a $P_1=U_"eff"^2 Re(underline(Y_1))$ donc $Re(underline(Y_1))=P_1/(U_"eff"^2)$.

    De plus, $phi_1 = arccos(cos(phi_1))$. Connaissant la partie réelle de $underline(Y_1)$ et son argument, on le donc connait complètement :
    $
        underline(Y_1) = Re(underline(Y_1)) + j Im(underline(Y_1)) &= Re(underline(Y_1)) - j Re(underline(Y_1)) tan(phi_1)\
        &= P_1/(U_"eff"^2) - j P_1/(U_"eff"^2) tan(arccos(cos(phi_1)))\
        &= 38 - 50j unit("mS")
    $

    De même, on trouve $underline(Y_2) = 57 - 58j unit("mS")$.

    On peut en déduire l'admittance totale : $underline(Y_"tot") = underline(Y_1) + underline(Y_2) + underline(Y_L) = #(38 + 57 + 38) - #(50 + 58) j unit("mS")$, puis le déphasage totale :
    $ phi_"tot" = arctan(Im(underline(Y_"tot"))/Re(underline(Y_"tot"))) = arctan(-#(50 + 58)/#(38 + 57 + 38)) = qty("39","deg") $
    et le facteur de puissance $cos(phi_"tot") = num("0,77")$.

    Ce facteur de puissance est assez faible, ce qui signifie que l'installation consomme beaucoup de puissance réactive, engendrant des pertes en lignes importantes.
]

#question(
    coups-de-pouce: (
        "Il faut que les machines continuent à fonctionner normalement, donc que la tension à leur bornes ne soit pas modifiée par l'ajout du condensateur.",
    ),
)[
    Pour réduire les pertes en lignes, on ajoute un condensateur à l'installation. Doit-on l'ajouter en parallèle ou en série ?
][
    Le condensateur doit être ajouté en parallèle, de façon à ne pas modifier la tension aux bornes des machines, afin qu'elles continuent à fonctionner normalement.
]

#question(
    coups-de-pouce: (
        "Que peut-on dire de l'admittance totale si le facteur de puissance est égal à 1 ?",
    ),
)[
    Calculer la valeur du condensateur pour ramener le facteur de puissance à $1$.
][
    Comme le condensateur est en parallèle, l'admittance totale devient $underline(Y_"global") = underline(Y_"tot") + j omega C$.

    On veut $cos(phi_"global") = 1$, c'est-à-dire $phi_"global" = 0$ autrement dit $Im(underline(Y_"global")) = 0$.

    On a donc $ 0 = Im(underline(Y_"tot")) + omega C $ d'où $ C = -Im(underline(Y_"tot"))/omega = (#(50 + 58) unit("mS"))/(2 pi #(50) ) = qty("258", "uF") $
]
