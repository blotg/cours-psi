# -*- coding: utf-8 -*-
"""
Lignes de champ magnétique dans un circuit magnétique rectangulaire bobiné,
avec un entrefer dans la branche de droite (modèle 2D plan, voir lib.py).
Produit entrefer.svg.
"""

import matplotlib.pyplot as plt
import numpy as np

import lib

# ---------- Paramètres ----------
a = 0.10# m, largeur extérieure du circuit
b = 0.12# m, hauteur extérieure du circuit
d = 0.02# m, largeur des branches du circuit
e = 5e-3# m, épaisseur de l'entrefer
Ni = 500# A, nombre de spires x intensité
mu_r = 1e5# perméabilité relative du fer

# ---------- Simulation et figure ----------
fer, fils = lib.cadre_bobine(a, b, d, e, Ni)
x, y, A, Bx, By = lib.figure_circuit(fer, fils, mu_r, __file__)

# ---------- Comparaison avec le cours ----------
l = 2*(a - d) + 2*(b - d) - e# m, longueur de la ligne moyenne dans le fer
i, j = np.argmin(abs(y)), np.argmin(abs(x - (a/2 - d/2)))
print(f"B au centre de l'entrefer (simulation)   : {np.hypot(Bx[i, j], By[i, j])*1e3:.1f} mT")
print(f"mu0 N i / (e + l/mu_r) (fer de mu_r fini) : {lib.mu0*Ni/(e + l/mu_r)*1e3:.1f} mT")
print(f"mu0 N i / e            (formule du cours) : {lib.mu0*Ni/e*1e3:.1f} mT")

plt.show()
