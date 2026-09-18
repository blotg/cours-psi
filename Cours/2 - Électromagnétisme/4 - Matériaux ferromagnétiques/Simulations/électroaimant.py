# -*- coding: utf-8 -*-
"""
Lignes de champ magnétique dans un électroaimant (modèle 2D plan, voir lib.py) :
une pièce en U retournée, bobinée sur sa branche horizontale, fait face à un
barreau, avec un entrefer sous chaque branche du U. Produit électroaimant.svg.
"""

import matplotlib.pyplot as plt
import numpy as np

import lib

# ---------- Paramètres ----------
a = 0.10# m, largeur du U et du barreau
b = 0.08# m, hauteur du U
d = 0.02# m, largeur des branches du U et épaisseur du barreau
e = 5e-3# m, épaisseur de chaque entrefer
Ni = 500# A, nombre de spires x intensité
mu_r = 1e5# perméabilité relative du fer

# ---------- Simulation et figure (flèches à mi-hauteur des entrefers) ----------
fer, fils, y_entrefers = lib.electroaimant(a, b, d, e, Ni)
x, y, A, Bx, By = lib.figure_circuit(fer, fils, mu_r, __file__, y_fleches=y_entrefers)

# ---------- Comparaison avec le cours (les deux entrefers sont en série) ----------
l = 2*(a - d) + 2*b# m, longueur de la ligne moyenne dans le fer
i, j = np.argmin(abs(y - y_entrefers)), np.argmin(abs(x - (a/2 - d/2)))
print(f"B au centre d'un entrefer (simulation)      : {np.hypot(Bx[i, j], By[i, j])*1e3:.1f} mT")
print(f"mu0 N i / (2e + l/mu_r) (fer de mu_r fini)  : {lib.mu0*Ni/(2*e + l/mu_r)*1e3:.1f} mT")
print(f"mu0 N i / 2e            (formule du cours)  : {lib.mu0*Ni/(2*e)*1e3:.1f} mT")

plt.show()
