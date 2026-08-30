# -*- coding: utf-8 -*-

import numpy as np
import matplotlib.pyplot as plt
import scipy.fftpack

R1 = 1000# Ohm
R2 = 2000# Ohm
C = 1E-6# µF
R = 1000# Ohm
w = 1/(R*C)# rad/s
Vsat = 15# V

T = 4*R*C*R1/R2# s période estimée
dt = T/100# s pas de temps
tmax = T*20# s durée de la simulation

N = int(tmax/dt)# nombre de points

t = np.linspace(0,tmax, N)
v = np.zeros(N)
u = np.zeros(N)

u[0] = Vsat

for i in range(1,N):
    v[i] = v[i-1] - dt/(R*C)*u[i-1]
    if u[i-1] == Vsat and v[i] < -R1/R2*Vsat :
        u[i] = -Vsat
    elif u[i-1] == -Vsat and v[i] > R1/R2*Vsat :
        u[i] = Vsat
    else:
        u[i] = u[i-1]

plt.figure(1)
plt.clf()
plt.plot(t,u, label="sortie du CH")
plt.plot(t,v, label="sortie de l'intégrateur")
plt.legend(loc=1)
plt.xlabel("temps (s)")
plt.ylabel("tension (V)")

vTF = np.abs(scipy.fftpack.fft(v))
vTF = vTF/vTF.max()
uTF = np.abs(scipy.fftpack.fft(u))
uTF = uTF/uTF.max()
freqs = scipy.fftpack.fftfreq(N, dt)

plt.figure(2)
plt.clf()
plt.plot(freqs[:N//2], uTF[:N//2], label="spectre de s")
plt.plot(freqs[:N//2], vTF[:N//2], label="spectre de v")
plt.legend(loc=1)
plt.xlabel("fréquence (Hz)")
plt.ylabel("spectre (sans unité)")
#plt.axis([0,w,0,1])
