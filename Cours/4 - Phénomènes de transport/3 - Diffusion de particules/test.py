import numpy as np
from numpy.random import random
import matplotlib.pyplot as plt

N = 100 # nombre de balles
R = 0.01 # rayon d'une balle
dt = 0.01 # pas de temps
tf = 10 # temps final

positions = random((N, 2)) # positions initiales
vitesses = random((N, 2)) - 0.5 # vitesses initiales

def afficher(positions):
    plt.clf()
    plt.scatter(positions[:, 0], positions[:, 1])
    plt.xlim(0, 1)
    plt.ylim(0, 1)
    plt.gca().set_aspect('equal', adjustable='box')
    plt.pause(0.01)
    
def gerer_collisions_balles(positions, vitesses, R):
    """Gère les collisions élastiques entre les balles"""
    for i in range(N):
        for j in range(i+1, N):
            # Calcul de la distance entre les balles (avec conditions périodiques)
            delta = positions[j] - positions[i]
            # Distance minimale avec conditions périodiques
            delta = delta - np.round(delta)
            distance = np.linalg.norm(delta)
            
            # Collision détectée
            if distance < 2*R and i != j:
                # Vecteur normal à la collision
                n = delta / distance
                
                # Vitesses relatives
                v_rel = vitesses[j] - vitesses[i]
                v_rel_n = np.dot(v_rel, n)
                
                # Ne traiter que si les balles se rapprochent
                if v_rel_n < 0:
                    vitesses[i] += v_rel_n * n
                    vitesses[j] -= v_rel_n * n
                    
                    # Séparer légèrement les balles pour éviter les collisions multiples
                    overlap = 2*R - distance
                    positions[i] -= 0.5 * overlap * n
                    positions[j] += 0.5 * overlap * n

for _ in range(int(tf/dt)):
    positions += vitesses * dt # mise à jour des positions
    
    # conditions aux limites périodiques
    positions = np.mod(positions, 1)
    
    # gestion des collisions entre balles
    gerer_collisions_balles(positions, vitesses, R)
    
    afficher(positions)