# Données de l'exercice « Pertes par hystérésis dans une tôle de transformateur »

`cycle_GO.npy` : cycle d'hystérésis mesuré d'une tôle de FeSi à grains orientés
(GO), d'épaisseur 0,30 mm, du type utilisé dans les transformateurs. Mesure à
50 Hz sur un cadre d'Epstein de 700 spires selon la norme IEC 60404-2,
polarisation sinusoïdale de crête 1,7 T.

Tableau numpy de forme (2, 4000), en float64 :

- ligne 0 : excitation magnétique H, en A/m ;
- ligne 1 : polarisation magnétique J = μ0 M, en T.

Les 4000 points sont régulièrement répartis sur une période, dans l'ordre du
temps. On les lit avec `H, J = np.load("cycle_GO.npy")`.

Le fichier est téléchargé par les élèves depuis GitHub, à l'adresse écrite dans
l'exercice (référence `HEAD`, donc la branche par défaut du dépôt) : il ne
faut ni le renommer ni le déplacer sans corriger ce lien.

## Source

M. Pasquale (INRIM), *EMPIR 19ENG06 HEFMAG hysteresis loops NO and GO dataset
example*, Zenodo, 2022, doi:10.5281/zenodo.5910893, licence CC BY 4.0.
Projet Euramet EMPIR 19ENG06 HEFMAG, « Metrology of magnetic losses in
electrical steel sheets for high-efficiency energy conversion ».

Archive d'origine : `EMPIR 19ENG06 HEFMAG dataset loops NO and GO.zip`
(sha256 `062b143310370de0d2edd54f8188a4d45d9e5928cb0f7781a27893e3f6211862`).
Son fichier `GO.dat` contient trois cycles, de crêtes 1,5 T, 1,7 T et 1,8 T,
séparés par des lignes `--` ; `cycle_GO.npy` est le deuxième, valeurs
inchangées, transposé :

```python
blocs, courant = [], []
for ligne in open("GO.dat").read().splitlines():
    if ligne.startswith("--"):
        blocs.append(courant)
        courant = []
    else:
        courant.append([float(x) for x in ligne.split()])
blocs.append(courant)
np.save("cycle_GO.npy", np.array(blocs[1]).T)
```

Valeurs de contrôle : aire ∮H dB = 152 J/m³, soit 0,99 W/kg à 50 Hz pour
ρ = 7650 kg/m³ (1,5 T : 0,75 W/kg ; 1,8 T : 1,23 W/kg).
