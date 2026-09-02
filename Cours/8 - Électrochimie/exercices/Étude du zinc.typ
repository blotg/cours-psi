#import "@local/prepa:0.1.1": *
#let cpl(a, b) = [#ce(a)\/#ce(b)]

#show: exercice.with(titre: "Étude du zinc", difficulté: 2)

Une solution contient des ions #ce("Zn^2+") accompagnés d'impuretés cationiques : #ce("Cd^2+"), #ce("Cu^2+") et #ce("Ni^2+"). On ajoute du zinc solide en poudre pour purifier la solution.

#question(coups-de-pouce: (
  "Quelle réaction si on met du zinc solide en contact avec une solution d'ions $ce(\"Cd^2+\")$ ? Idem pour $ce(\"Ni^2+\")$ et $ce(\"Cu^2+\")$.",
))[
  Justifier le procédé de purification en écrivant les bilans des réactions. Sous quelle forme sont alors les impuretés ? Comment les éliminer ?
][
  Le zinc est le plus réducteur des quatre métaux ($E^circ(cpl("Zn^2+", "Zn"))$ est le plus bas). Il réduit donc les cations métalliques plus nobles :
  $ ce("Zn") + ce("Cd^2+") &-> ce("Zn^2+") + ce("Cd(s)") \
    ce("Zn") + ce("Ni^2+") &-> ce("Zn^2+") + ce("Ni(s)") \
    ce("Zn") + ce("Cu^2+") &-> ce("Zn^2+") + ce("Cu(s)") $
  Les impuretés se retrouvent sous forme de métaux solides (#ce("Cd"), #ce("Ni"), #ce("Cu")), que l'on élimine par #strong[filtration]. Les seuls ions ajoutés en solution sont des #ce("Zn^2+"), c'est-à-dire l'espèce désirée.
]

On acidifie la solution de sulfate de zinc ($qty("2", "mol/L")$) par de l'acide sulfurique ($qty("1.5", "mol/L")$). Les activités de #ce("H+"), #ce("O2") et #ce("H2") sont prises égales à $1$. Pour obtenir du zinc métallique, on électrolyse cette solution : cathodes en aluminium, anodes en plomb (inattaquable en milieu sulfate). Les ions sulfate ne participent à aucune réaction.

#question(coups-de-pouce: (
  "Lister tous les réducteurs présents et les couples associés.",
  "Comparer les potentiels de Nernst : quelle réaction est la moins défavorable à forcer ?",
))[
  D'un point de vue thermodynamique, quelles réactions peuvent avoir lieu à la cathode ? À l'anode ? En déduire la réaction d'électrolyse attendue et la différence de potentiel à appliquer.
][
  #strong[Anode (oxydation).] Seule l'eau peut être oxydée (Pb et #ce("SO4^2-") inertes) :
  $ 2 ce("H2O") -> ce("O2") + 4 ce("H+") + 4 e^-, quad E_"eq" = E^circ(ce("O2/H2O")) = qty("1.23", "V") $

  #strong[Cathode (réduction).] Oxydants présents : #ce("Zn^2+") ($E_"eq" approx qty("-0.76", "V")$) et #ce("H+") ($E_"eq" = qty("0", "V")$ car $a(ce("H+")) = 1$). La réduction de #ce("H+") est thermodynamiquement la plus facile :
  $ 2 ce("H+") + 2 e^- -> ce("H2") $

  #strong[Électrolyse attendue] : $2 ce("H2O") -> 2 ce("H2") + ce("O2")$ (électrolyse de l'eau), avec
  $ Delta V_min = E_"eq"("anode") - E_"eq"("cathode") = 1.23 - 0 = qty("1.23", "V") $
]

#question(coups-de-pouce: (
  "Pourquoi la réaction $ce(\"H+\") -> ce(\"H2\")$ ne démarre-t-elle pas à $qty(\"0\", \"V\")$ sur l'aluminium ?",
  "Quel potentiel imposer à l'aluminium pour que son courant total vaille $qty(\"-500\", \"A/m^2\")$ ? Quelle proportion sert à la réaction voulue ?",
))[
  À l'aide de la figure ci-dessous, donner l'équation d'électrolyse réellement observée. À quoi sont dus ces changements ? Pour une densité de courant de $qty("500", "A/m^2")$, quelle différence de potentiel appliquer ? Estimer le rendement faradique du dépôt de zinc.
  #figure(image("../figures/3.png", width: 80%))
][
  Sur l'aluminium, le dégagement de #ce("H2") présente une forte surtension cathodique : la réduction de #ce("H+") ne débute qu'à un potentiel bien plus négatif que $qty("0", "V")$. Au potentiel de travail de la cathode, la réduction $ce("Zn^2+") + 2 e^- -> ce("Zn")$ devient alors majoritaire : c'est ce qui rend l'électro-extraction du zinc possible.

  #strong[Électrolyse réelle] : $ce("Zn^2+") + ce("H2O") -> ce("Zn(s)") + 1/2 ce("O2") + 2 ce("H+")$.

  #strong[Différence de potentiel] : on lit sur les courbes le potentiel anodique $E_A$ donnant une densité de courant $qty("500", "A/m^2")$ (dégagement de #ce("O2") sur Pb) et le potentiel cathodique $E_C$ donnant un courant total de $- qty("500", "A/m^2")$ sur Al ; alors $Delta V = E_A - E_C$ (de l'ordre de $qty("3.5", "V")$ pour l'électro-extraction du zinc).

  #strong[Rendement faradique] : au potentiel $E_C$, le courant total se répartit entre $ce("Zn^2+") -> ce("Zn")$ et $ce("H+") -> ce("H2")$. Le rendement est la fraction $i_(ce("Zn")) \/ i_"tot"$ lue sur la figure (typiquement $qty("90", "%")$ environ en pratique industrielle).
]
