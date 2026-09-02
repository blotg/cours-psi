#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Chauffe-eau électrique instantané",
    ouvert: true,
)

Les chauffes-eaux électriques instantanés permettent de chauffer l'eau à la demande, sans réservoir de stockage.

Le chauffe-eau ci-dessous peut soutirer une puissance électrique maximale de #qty("4.4", "kW").

#grid(
    columns: (1fr, 1fr),
    align: horizon,
    figure(image("../images/chauffe-eau-2.jpg", width: 70%)), figure(image("../images/chauffe-eau-1.jpg")),
)

Le débit d'eau dans une douche est typiquement compris entre #qty("12", "L/min") et #qty("20", "L/min").

La capacité thermique maintenant de l'eau est $c_p = #qty("4.18", "kJ/kg/K")$.

#question()[
    Ce chauffe-eau est-il adapté pour une douche ?
][
    On applique le PPI à l'eau dans le chauffe-eau, en considérant la vitesse d'entrée égale à celle de sortie et la sortie à la même altitude que l'entrée.
    $
        P_"th" = D_m (h_"sortie" - h_"entrée") = D_m c_p (T_"sortie" - T_"entrée")
    $
    $
        D_m = P_"th" / (c_p (T_"sortie" - T_"entrée"))
    $
    En supposant une température d'entrée de #qty("10", "Celsius") et une température de sortie de #qty("37", "Celsius"), on trouve que le chauffe-eau peut fournir un débit maximal de 
    #let P = 4400
    #let mv = 1e3
    #let capa = 4.18e3
    #let Tentree = 10
    #let Tsortie = 37
    #let DV = P/(mv * capa * (Tsortie - Tentree))
    $
      D_(V,"max") = D_(m,"max")/mu = P_"th" / (mu c_p (T_"sortie" - T_"entrée")) = #qty(scientifique(DV,1), "m^3/s") = #qty(scientifique(DV*60*1000,1), "L/min")
    $
    Ce qui est suffisant pour une douche.
]
