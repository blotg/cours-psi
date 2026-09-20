#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Spectre d'un signal musical",
    numérique: true
)

Dans cet exercice, on étudie le spectre d'un signal musical réel ainsi que les effets d'une limitation de spectre sur son écoute.

Cet exercice peut être fait avec votre musique favorite au format WAV. A défaut, vous pouvez télécharger une musique libre de droit au lien suivant : #link("https://www.free-stock-music.com/fsm-team-escp-enlia-take-me-to-the-moon.html")

La première étape consiste à charger votre fichier dans Python grace aux instructions suivantes.

```python
from scipy.io import wavfile

fe, son = wavfile.read('nom_de_votre_fichier.wav')
```



