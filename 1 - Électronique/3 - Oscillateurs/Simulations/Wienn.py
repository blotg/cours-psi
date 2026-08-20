# -*- coding: utf-8 -*-

import numpy as np
import matplotlib.pyplot as plt
import scipy.fftpack

R1 = 1000# Ohm
R2 = 2001# Ohm
A = 1 + R2/R1# Gain de l'ANI
C = 1E-6# F
R = 1000# Ohm
w = 1/(R*C)# rad/s pulsation caractéristique du passe bande
Vsat = 15# V

T = 2*np.pi/w# s période présumée

dt = T/100# s pas de temps^
tmax = 100*T# s durée de la simulation

N = int(tmax//dt)# nombre de points de la simulation

t = np.linspace(0,tmax, N)# tableau des temps
v = np.zeros(N)# V tableau des tensions v
vp = np.zeros(N)# V/s dérivée de v
s = np.zeros(N)# V tableau des tensions s
sp = np.zeros(N)# V/s dérivée de s

v[0] = 0.1

for i in range(1,N):# Calcul de s et v au cours du temps grace à l'algorithme d'
    s[i] = A*v[i-1]
    if s[i] > Vsat :
        s[i] = Vsat
    elif s[i] < -Vsat :
        s[i] = -Vsat
    sp[i] = (s[i] - s[i-1])/dt
    vp[i] = vp[i-1] + dt*(-3/(R*C)*vp[i-1] - 1/(R*C)**2*v[i-1] + 1/(R*C)*sp[i])
    v[i] = v[i-1] + dt*vp[i-1]

plt.figure(1)
plt.clf()
plt.plot(t,s, label="sortie de l'ANI")
plt.plot(t,v, label="sortie du basse-bande")
plt.legend(loc=1)
plt.xlabel("temps (s)")
plt.ylabel("tension (V)")
plt.show()

vTF = np.abs(scipy.fftpack.fft(v))
vTF = vTF/vTF.max()
sTF = np.abs(scipy.fftpack.fft(s))
sTF = sTF/sTF.max()
freqs = scipy.fftpack.fftfreq(N, dt)

plt.figure(2)
plt.clf()
plt.plot(freqs[:N//2], sTF[:N//2], label="spectre de s")
plt.plot(freqs[:N//2], vTF[:N//2], label="spectre de v")
plt.legend(loc=1)
plt.xlabel("fréquence (Hz)")
plt.ylabel("spectre (sans unité)")
plt.show()
#plt.axis([0,w,0,1])
