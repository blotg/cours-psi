# -*- coding: utf-8 -*-
"""
Lignes de champ magnétique d'un dipôle magnétique de moment dirigé vers le haut,
dans un plan contenant le moment. Expression analytique exacte, voir lib.py.
Produit dipole.svg.
"""

import matplotlib.pyplot as plt

import lib

r_dipole = 0.4# rayon du disque qui représente le dipôle

# niveaux prolongés jusqu'à la ligne qui coupe le plan équatorial au bord du disque :
# pas de lobe vide entre le disque et la plus petite ligne tracée
lib.figure_revolution(lib.flux_dipole, lambda ax: lib.dessine_dipole(ax, r_dipole), __file__,
                      rayon_objet=r_dipole, n_niveaux=round(lib.R_EQ/r_dipole))

plt.show()
