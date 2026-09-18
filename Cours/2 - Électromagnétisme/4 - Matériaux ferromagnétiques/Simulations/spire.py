# -*- coding: utf-8 -*-
"""
Lignes de champ magnétique d'une spire circulaire parcourue par un courant, dans
un plan contenant son axe (Oy). Expression analytique exacte, voir lib.py.
Produit spire.svg.
"""

import matplotlib.pyplot as plt
import numpy as np

import lib

R = 1.0# rayon de la spire, qui fixe l'échelle de la figure
r_fil = 0.08# rayon du fil dessiné
I = 1/(np.pi*R**2)# intensité donnant un moment magnétique I pi R² = 1, comme dans dipole.py et aimant.py


def dessine_spire(ax):
    # moment selon +y : le courant vient vers nous à gauche et s'éloigne à droite
    lib.dessine_fils(ax, [(-R, 0, r_fil, 1), (R, 0, r_fil, -1)])


lib.figure_revolution(lambda X, Y: lib.flux_spire(X, Y, R, I), dessine_spire, __file__)

plt.show()
