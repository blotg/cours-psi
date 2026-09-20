#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Spectre d'un signal musical",
    numérique: true,
    capytale: "3411-11693103",
)

Dans cet exercice, on étudie le spectre d'un signal musical réel ainsi que les effets d'une limitation de spectre sur son écoute.

Cet exercice peut être fait avec votre musique favorite au format WAV. A défaut, vous pouvez télécharger une musique libre de droit au lien suivant : #link("https://www.free-stock-music.com/fsm-team-escp-enlia-take-me-to-the-moon.html")

La première étape consiste à charger votre fichier dans Python grace aux instructions suivantes.

```python
from scipy.io import wavfile

fe, son = wavfile.read('nom_de_votre_fichier.wav')
```

`fe` contient alors la fréquence d'échantillonnage du signal, et `son` contient les échantillons du signal audio.

La plupart des fichiers musicaux sont stéréo et contiennent donc deux canaux. La variable `son` est alors un tableau numpy avec deux colonnes, une pour chaque canal.

#question(
    coups-de-pouce: (
        "Conventionnellement, on note `s[i,j]` pour la valeur de `s` à la `i`-ème ligne et la `j`-ème colonne.",
        "On peut utiliser les notation `[:]`",
    )
)[
    Définir une variable `signal` qui contient le signal d'un seul canal (par exemple le canal gauche) du fichier audio.
][
    ```python
    signal = son[:, 0]
    ```
]

#question(
    coups-de-pouce: (
        "La première étape est de définir le tableau des temps à partir de la fréquence d'échantillonnage et du nombre de points du signal.",
        "On peut utiliser la fonction `np.arange(N)` qui génère un tableau de N valeurs allant de 0 à N-1.",
    )
)[
    Tracer le signal en fonction du temps.
][
    La première étape est de recréer le tableau des temps. La période d'échantillonnage est l'inverse de la fréquence d'échantillonnage. Les temps sont des valeurs espacées de la période d'échantillonnage et sont au même nombre que les points du signal.

    ```python
    import numpy as np
    Te = 1 / fe
    t = np.arange(len(signal)) * Te
    ```

    On peut ensuite tracer le signal en fonction du temps grace à la bibliothèque matplotlib.

    ```python
    import matplotlib.pyplot as plt
    plt.figure("Signal")
    plt.clf()
    plt.plot(t, signal)
    plt.xlabel('Temps (s)')
    plt.ylabel('Amplitude')
    plt.show()
    ```
]

Pour écouter le signal audio dans Python, on peut utiliser la bibliothèque `IPython.display` comme suit :

```python
from IPython.display import Audio, display
display(Audio(signal, rate=fe))
```

#question(
    coups-de-pouce: (
        "Quand on trace un spectre, on ne prend que son module, obtenu avec la fonction `np.abs`."
    )
)[
    Calculer et tracer le spectre du signal audio en utilisant les fonctions #link("https://numpy.org/doc/stable/reference/generated/numpy.fft.rfft.html")[`np.fft.rfft`] et #link("https://numpy.org/doc/stable/reference/generated/numpy.fft.fftfreq.html")[`np.fft.rfftfreq`]. Le spectre sera stocké dans un tableau nommé `spectre`.
][
    Le spectre est calculé avec
    ```python
    spectre = np.fft.rfft(signal)
    fréquences = np.fft.rfftfreq(len(signal), Te)
    ```

    On peut ensuite tracer le spectre en utilisant matplotlib.
    ```python
    plt.figure("Spectre")
    plt.clf()
    plt.plot(fréquences, np.abs(spectre), label='signal original')
    plt.legend()
    plt.xlabel('Fréquence (Hz)')
    plt.ylabel('Amplitude')
    plt.show()
    ```
]

Les grandes ondes ont des bandes de #quan[9 kHz] de large.

#question(
    coups-de-pouce: "Quelle est le lien entre la largeur de bande et la fréquence maximale du signal ?"
)[
    Calculer la fréquence maximale d'un signal émis sur les grandes ondes.
][
    La largeur de bande est le double de la fréquence maximale d'où
    $
        f_"max" = l/2 = #zi.kHz(9/2)
    $
]

#question(
    coups-de-pouce: (
        "On peut commencer d'un tableau ne contenant que des 0 et remplir les valeurs correspondant aux fréquences que l'on souhaite conserver.",
        "Initialiser un tableau de zéros avec `np.zeros`. Parcourir le spectre original et recopier les valeurs si la fréquence est inférieure à #zi.kHz(9/2)."
    )
)[
    Pour simuler l'effet de ce filtrage, définir un signal `spectre_filtré` qui correspond à `spectre` pour les fréquences inférieurs à #zi.kHz(9/2) et nul pour les fréquences supérieures. `spectre_filtré` aura autant d'éléments que `spectre`.
][
    ```python
    spectre_filtré = np.zeros(len(spectre))
    for i in range(len(spectre)):
        if fréquences[i] <= 9/2e3:
            spectre_filtré[i] = spectre[i]
    ```
]

#question()[
    Recomposer le signal temporel à partir du spectre filtré en utilisant #link("https://numpy.org/doc/stable/reference/generated/numpy.fft.irfft.html")[`np.fft.irfft`]. Écouter le son correspondant et le comparer au son non filtré.
][
    ```python
    signal_filtré = np.fft.irfft(spectre_filtré)
    display(Audio(signal_filtré, rate=fe))
    ```
    L'altération du signal est perceptible, il parait moins précis et n'est pas fidèle à l'original.
]

#question()[
    Reprendre les questions précédentes pour une diffusion sur la bande FM, avec un spectre audio limité à #zi.kHz(15).
][
    ```python
    spectre_filtré_FM = np.zeros(len(spectre))
    for i in range(len(spectre)):
        if fréquences[i] <= 15e3:
            spectre_filtré_FM[i] = spectre[i]

    signal_filtré_FM = np.fft.irfft(spectre_filtré_FM)
    display(Audio(signal_filtré_FM, rate=fe))
    ```
    L'altération du signal est imperceptible (par moi en tous cas), la diffusion en FM préserve mieux l'intégrité du signal
]
