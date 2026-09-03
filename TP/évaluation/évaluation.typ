#import "@local/prepa:0.1.1": *

#show: évaluation-TP

#grid(
    columns: 5,
    row-gutter: 5mm,
    column-gutter: 2mm,
    [
        Cette feuille est à coller dans le cahier de laboratoire à la fin de chaque compte-rendu de TP.
        
        Vous vous auto-évaluerez en fin de séance en entourant en *bleu* le niveau atteint pour chaque critère.

        À chaque séance, un binôme tiré au sort verra ses compte-rendus notés (les notes sont individuelles).
    ],
    grid.cell(rotate(-90deg, reflow: true, [Très insuffisant]),align:bottom),
    grid.cell(rotate(-90deg, reflow: true, [Insuffisant]),align:bottom),
    grid.cell(rotate(-90deg, reflow: true, [Correct]),align:bottom),
    grid.cell(rotate(-90deg, reflow: true, [Très bien]),align:bottom),
    [
        = Méthodologie
        Les manipulations effectuées sont décrites (par des schémas et/ou du texte) suffisamment clairement et précisément pour être reproduites à l'identique par un tiers. Les appareils utilisés et leurs éventuels réglages sont indiqués.
    ],
    [0],
    [2],
    [4],
    [6],
    [
        = Résultats
        Les données expérimentales brutes (tels que donnés par les appareils de mesure) sont tous consignés (dans le cahier de laboratoire ou sur Capytale#footnote[Penser à faire un renvoi dans le cahier de laboratoire]). Les unités sont précisées.
    ],
    [0],
    [1],
    [2],
    [3],
    [
        = Discussion
        Les données expérimentales sont traitées pour obtenir les grandeurs d'intérêt. D'éventuelles courbes sont tracées. Des incertitudes sont estimées et propagées.

        Les résultats obtenus sont comparés aux valeurs théoriques ou attendues. Les écarts normalisés (Aussi appelés "z-scores") sont calculés.
    ],
    [0],
    [2],
    [4],
    [6],
    [
        = Conclusion
        Une réponse précise et argumentée est apportée à la problématique. En cas de divergence entre les résultats expérimentaux et les valeurs théoriques ou attendues, des pistes d'explications sont proposées.
    ],
    [0],
    [1],
    [2],
    [3],
    [
        = Forme
        Les éventuels graphes comprennent un titre, les noms des axes avec unités ainsi que, si plusieurs courbes apparaissent, une légende.

        Les différentes parties sont clairement identifiées. Vous auriez envie de relire votre compte-rendu.
    ],
    [0],
    [1],
    [2],
    [3],
    [
        = Total
    ],
    grid.cell(align: right, colspan: 4)[/20],
)
