#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Mar 16 16:34:01 2021

@author: guillaume
"""

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

f=1
omega = 2*np.pi*f
c = 1
k = omega/c
sigma = 5

x = np.arange(0,10,0.01)

gaussienne = np.vectorize(lambda x: np.exp(-x**2/(2*sigma**2)))

def onde():
    for t in np.arange(0,100,0.008):
        y = np.cos(omega*t-k*x)*gaussienne(omega*t-k*x)
        yield x,y
        
fig, ax = plt.subplots()
line, = ax.plot(x,0*x, lw=2)
ax.set_xlim(0,10)
ax.set_ylim(-2,2)

def metAJourCourbe(donnees):
    x,y = donnees
    line.set_ydata(y)
    return line,

ani = FuncAnimation(fig, metAJourCourbe, onde, blit=True, interval=8)
plt.show()
