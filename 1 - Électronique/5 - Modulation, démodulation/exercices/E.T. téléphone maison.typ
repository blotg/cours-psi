#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "E.T. téléphone maison",
    difficulté: 3,
    numérique: true,
    ouvert: true,
)

L'antenne radioélectrique de la zone 51 a reçu un mystérieux signal radio. Votre collègue chargé de l'enquête a mystérieusement disparu et c'est à vous que revient l'enquête. Vos seuls indices sont le signal reçu (téléchargeable ici : #link("https://nuage03.apps.education.fr/index.php/s/5Kj4bFWCHtcD2Pf")) et les notes de votre collègue ci-dessous.

#figure(
    block(
        stroke: black,
        image("images/notes.png", height: 20cm),
    ),
)

#question()[
    Déchiffrez le message.
][
    On peut commencer par charger le signal et l'afficher.
    ```python
    import numpy as np
    import matplotlib.pyplot as plt
    data = np.load("E.T. téléphone maison.npz")
    t = data["t"] # temps
    sAM = data["s"] # signal modulé en amplitude

    plt.plot(t, sAM)
    plt.xlabel("Temps (s)")
    plt.ylabel("Amplitude")
    plt.show()
    ```

    Une lecture graphique au tout début du signal permet de trouver la fréquence de la porteuse : #qty("2", "kHz"). On peut alors reconstruire la porteuse puis effectuer la première étape de la démodulation par détection d'enveloppe : la multiplication par la porteuse.
    ```python
    fp = 2000 # fréquence de la porteuse en Hz
    sp = np.cos(2 * np.pi * fp *t)
    s2 = sAM * sp
    ```

    Il reste à faire le filtrage passe-bas. Les notes indiquent comment faire mais il manque la fréquence d'échantillonnage qu'on récupère à partir du tableau `t`.
    ```python
    fe = 1 / (t[1] - t[0]) # fréquence d'échantillonnage en Hz
    from scipy.signal import butter, lfilter
    L = butter(5, 200, btype='low', fs=fe)
    s = lfilter(*L, s2) # signal filtré
    ```

    Normalement il faut encore faire un filtre passe-haut mais les notes disent que ce n'est pas nécessaire ici. En revanche, les notes précisent qu'il faut retirer les premières #qty("0.05", "s") du signal filtré. On peut le faire ainsi :
    ```python
    i0 = int( 0.05 / (t[1] - t[0]) ) # nombre d'échantillons à retirer
    t = t[i0:]
    s = s[i0:]
    ```

    Il ne reste plus qu'à tracer le signal démodulé pour voir apparaitre le message.
    ```python
    plt.plot(t, s)
    plt.xlabel("Temps (s)")
    plt.ylabel("Amplitude")
    plt.show()
    ```
]
