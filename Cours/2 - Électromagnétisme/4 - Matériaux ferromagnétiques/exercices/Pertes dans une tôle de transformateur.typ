#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Pertes par hystérésis dans une tôle de transformateur",
    numérique: true,
    capytale: "280e-12571000",
)

Le circuit magnétique d'un transformateur est un empilement de tôles minces d'acier au silicium à grains orientés : leurs cristaux sont alignés dans le sens du laminage, ce qui réduit les pertes. Dans le cadre d'un projet européen de métrologie, l'institut italien de métrologie (INRIM) a mesuré le cycle d'hystérésis d'une telle tôle, d'épaisseur #quan[0.30 mm], à la fréquence $f = #quan[50 Hz]$. La mesure est faite sur un cadre d'Epstein, banc normalisé qui fonctionne comme un transformateur à vide dont le circuit magnétique, sans entrefer, est fait des tôles à étudier. Le champ magnétique y est imposé sinusoïdal, d'amplitude #quan[1.7 T].

Les mesures sont téléchargeables à l'adresse suivante.

#lien("https://raw.githubusercontent.com/blotg/cours-psi/HEAD/Cours/2%20-%20%C3%89lectromagn%C3%A9tisme/4%20-%20Mat%C3%A9riaux%20ferromagn%C3%A9tiques/exercices/donn%C3%A9es/cycle_GO.npy")

_Source des données : M. Pasquale (INRIM), projet EMPIR 19ENG06 HEFMAG, licence CC BY 4.0, #link("https://doi.org/10.5281/zenodo.5910893")[doi:10.5281/zenodo.5910893]._

Le fichier `cycle_GO.npy` contient un tableau numpy de deux lignes : l'excitation magnétique $H$, en #unit("A/m"), et la polarisation magnétique $J = mu_0 M$, en #unit("T"), mesurées en $4000$ instants régulièrement répartis sur une période. Une fois le fichier placé dans le même dossier que le programme, on le charge ainsi :

```python
import numpy as np
import matplotlib.pyplot as plt

H, J = np.load("cycle_GO.npy")
```

#question(coups-de-pouce: (
    "Utiliser la définition de l'excitation magnétique.",
    "La fonction `np.abs` renvoie le tableau des valeurs absolues, et `np.max` la plus grande valeur d'un tableau.",
))[
    Exprimer le champ magnétique $B$ en fonction de $H$ et de $J$. Calculer le tableau `B` des valeurs du champ magnétique, puis la plus grande valeur de $abs(B - J)$. Commenter.
][
    Par définition de l'excitation magnétique, $H = B/mu_0 - M$, d'où $B = mu_0 (H + M) = mu_0 H + J$.

    ```python
    mu0 = 4e-7 * np.pi
    B = mu0 * H + J
    print(np.max(np.abs(B - J)))
    ```

    L'écart entre $B$ et $J$ ne dépasse pas #quan[6e-5 T], quand $B$ atteint #quan[1.7 T] : dans ce matériau très perméable, la quasi-totalité du champ magnétique est créée par l'aimantation.
]

#question(coups-de-pouce: (
    "Le champ magnétique rémanent est la valeur de $B$ pour $H = 0$.",
    "L'excitation coercitive est la valeur de $H$ pour $B = 0$.",
))[
    Tracer le cycle d'hystérésis $B(H)$. Lire le champ magnétique rémanent $B_r$ et l'excitation coercitive $H_c$. Le matériau est-il doux ou dur ?
][
    ```python
    plt.figure("Cycle d'hystérésis")
    plt.plot(H, B)
    plt.xlabel("H (A/m)")
    plt.ylabel("B (T)")
    plt.grid()
    plt.show()
    ```

    On lit $B_r approx #quan[1.6 T]$ et $H_c approx #quan[23 A/m]$. L'excitation coercitive est de l'ordre de $10^4$ fois plus faible que celle d'un aimant permanent : le matériau est doux, comme il se doit pour un transformateur.
]

#question(coups-de-pouce: (
    "`trapezoid(y, x)` calcule l'intégrale de `y` par rapport à `x` : attention à l'ordre des arguments.",
    "`trapezoid` suit les points dans l'ordre des tableaux, même si `x` n'est pas croissant : sur un cycle, elle calcule donc une intégrale curviligne.",
    "Une aire négative signale des arguments inversés.",
))[
    L'aire du cycle vaut $cal(A) = integral.cont H dd(B)$. La calculer par la méthode des trapèzes, à l'aide de la fonction `trapezoid` du module `scipy.integrate`, dont voici l'essentiel de la #link("https://docs.scipy.org/doc/scipy/reference/generated/scipy.integrate.trapezoid.html")[documentation].

    #cheatsheet-python("trapezoid")
][
    ```python
    from scipy.integrate import trapezoid

    A = trapezoid(H, B)
    print(A)
    ```

    On trouve $cal(A) approx #quan[152 J/m^3]$. Le cycle est parcouru dans le sens trigonométrique ($B$ croît sur la branche de droite, où $H$ est le plus grand) : l'intégrale est positive.

    Le dernier point mesuré est presque confondu avec le premier : ajouter le segment qui ferme le cycle ne changerait l'aire qu'au septième chiffre.
]

#question(coups-de-pouce: (
    "Utiliser la relation entre l'aire du cycle et la puissance moyenne dissipée par hystérésis.",
    "Le volume d'un kilogramme de tôle est $1 slash rho$.",
))[
    En déduire la puissance moyenne dissipée par hystérésis dans un kilogramme de tôle, de masse volumique $rho = #quan[7650 kg/m^3]$.

    Les tôles à grains orientés sont vendues sous une désignation normalisée qui donne leurs pertes maximales garanties à #quan[1.7 T] et #quan[50 Hz] : une tôle M105-30P, d'épaisseur #quan[0.30 mm], perd au plus #quan[1.05 W/kg]. Le résultat est-il cohérent ?
][
    La puissance moyenne dissipée dans un volume $V$ de tôle vaut $mean(cal(P)) = V f cal(A)$. Pour un kilogramme, $V = 1 slash rho$, d'où

    ```python
    f, rho = 50, 7650
    print(f * A / rho)
    ```

    $ mean(cal(P))_"1 kg" = (f cal(A))/rho approx #quan[0.99 W/kg] $

    C'est bien l'ordre de grandeur garanti pour une tôle de cette épaisseur : la tôle mesurée satisferait la nuance M105-30P.

    Remarque : le cycle étant mesuré à #quan[50 Hz], son aire comprend aussi l'énergie dissipée par les courants de Foucault qui circulent dans la tôle. La puissance obtenue est l'ensemble des pertes fer, dont les pertes par hystérésis proprement dites ne sont qu'une partie. Il faudrait tracer le cycle à très basse fréquence pour les isoler.
]

#question(coups-de-pouce: (
    "Les pertes à vide sont les pertes fer.",
))[
    Les pertes à vide d'un transformateur, presque entièrement dues à son circuit magnétique, sont limitées par la réglementation européenne : au plus #quan[387 W] pour un transformateur de distribution de 400~kVA, comme ceux qui alimentent un quartier. Si son circuit magnétique est fait de cette tôle et fonctionne à #quan[1.7 T], quelle masse de tôle peut-il contenir au plus ? Quelle fraction de la puissance nominale du transformateur les pertes à vide représentent-elles ?
][
    La masse de tôle est au plus $m = #quan[387 W] / #quan[0.99 W/kg] approx #quan[3.9e2 kg]$.

    Les pertes à vide représentent $387 / (400 times 10^3) approx 10^(-3)$, un millième de la puissance nominale : un transformateur est une machine très efficace, et ses pertes fer, présentes dès qu'il est sous tension, sont réduites au minimum par le choix des tôles.
]
