# -*- coding: utf-8 -*-
"""
Lignes de champ magnétique dans un circuit magnétique rectangulaire bobiné,
sans entrefer (modèle 2D plan, voir lib.py). Produit « sans entrefer.svg ».
"""

import matplotlib.pyplot as plt

import lib

# ---------- Paramètres ----------
a = 0.10# m, largeur extérieure du circuit
b = 0.12# m, hauteur extérieure du circuit
d = 0.02# m, largeur des branches du circuit
Ni = 500# A, nombre de spires x intensité
mu_r = 1e5# perméabilité relative du fer

# ---------- Simulation et figure ----------
fer, fils = lib.cadre_bobine(a, b, d, 0, Ni)
lib.figure_circuit(fer, fils, mu_r, __file__)

plt.show()
