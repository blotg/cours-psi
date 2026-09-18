# -*- coding: utf-8 -*-
"""
Lignes de champ magnétique d'un aimant droit cylindrique, d'aimantation uniforme
dirigée vers le haut, dans un plan contenant son axe (Oy) : l'aimant y apparaît
comme un rectangle, pôle nord en haut. Expression analytique, voir lib.py.
Produit aimant.svg.
"""

import matplotlib.pyplot as plt
import numpy as np

import lib

R = 0.4# rayon de l'aimant
L = 2.0# hauteur de l'aimant
M = 1/(np.pi*R**2*L)# aimantation donnant un moment M pi R² L = 1, comme dans spire.py et dipole.py

lib.figure_revolution(lambda X, Y: lib.flux_aimant(X, Y, R, L, M), lambda ax: lib.dessine_aimant(ax, R, L),
                      __file__)

plt.show()
