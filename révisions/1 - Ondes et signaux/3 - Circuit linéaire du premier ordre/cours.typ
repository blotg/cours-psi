#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Mise en équation

#flashcard(
    recto: "Conditions de continuité pour un condensateur",
    verso: "La tension aux bornes d'un condensateur est continue : sa discontinuité demanderait une puissance $p = u i = u C dv(u,t)$ infinie.",
)
#flashcard(
    recto: "Conditions de continuité pour une bobine",
    verso: "L'intensité traversant une bobine est continue : sa discontinuité demanderait une puissance $p = u i = L i dv(i,t)$ infinie.",
)
#flashcard(
    recto: "Temps caractéristique d'un circuit du premier ordre",
    verso: "$tau = R C$ pour un circuit $R C$, $tau = L/R$ pour un circuit $R L$.",
)
#flashcard(
    recto: "Forme des solutions de $dv(y,t) + 1/tau y = f(t)$",
    verso: "$ y(t) =  K e^(-t/tau) + \"solution particulière\"$",
)

#question-de-colle(
    "Circuit $R C$ série soumis à un échelon de tension, condensateur initialement déchargé : faire le schéma, établir l'équation différentielle vérifiée par $u_C$, la résoudre, exprimer $i(t)$ et tracer les deux graphes en faisant apparaitre $tau$.",
)
#question-de-colle(
    "Circuit $R C$ série en régime libre, condensateur initialement chargé : faire le schéma, établir l'équation différentielle vérifiée par $u_C$, la résoudre, exprimer $i(t)$ et tracer les deux graphes en faisant apparaitre $tau$.",
)
#question-de-colle(
    "Circuit $R L$ série en régime libre, bobine initialement parcourue par un courant $i_0$ : établir l'équation différentielle vérifiée par $i$, la résoudre, exprimer $u_L(t)$ et tracer les graphes.",
)

= Aspect énergétique

#question-de-colle(
    "Pour un circuit $R C$ série soumis à un échelon de tension $E$ (condensateur initialement déchargé), la tension aux bornes du condensateur s'écrit $u_C(t) = E(1-e^(-t/(R C)))$. Établir la puissance instantanée reçue par le condensateur puis celle fournie par le générateur. Établir l'énergie totale reçue par le condensateur pour une charge complète et montrer que c'est la moitié de l'énergie totale fournie par le générateur.",
)
