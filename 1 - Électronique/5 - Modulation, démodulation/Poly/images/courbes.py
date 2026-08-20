# -*- coding: utf-8 -*-

import numpy as np
import matplotlib
import matplotlib.pyplot as plt
from scipy import signal

matplotlib.use("pgf")
matplotlib.rcParams.update({
    "pgf.texsystem": "pdflatex",
    'font.family': 'serif',
    'text.usetex': True,
    'pgf.rcfonts': False,
})

f_porteuse = 1000
f_signal = 100

N = 1000
tmax = 2/f_signal

t = np.linspace(0,tmax,N)
signal = signal.square(2*np.pi*f_signal*t)
mod_amplitude = (1+0.3*signal) * np.cos(2*np.pi*f_porteuse*t)
mod_frequence = np.cos(2*np.pi*f_porteuse*(1+0.3*signal)*t)
mod_phase = np.cos(2*np.pi*f_porteuse*t+4*(1+0.3*signal))

a = plt.figure(1)
plt.clf()
plt.subplot(211)
plt.title("Modulation en amplitude")
plt.plot(t,signal,label="signal modulant")
plt.xticks(ticks=[])
plt.yticks(ticks=[])
plt.ylabel("signal modulant")
plt.subplot(212)
plt.plot(t,mod_amplitude, label="signal modulé")
plt.xticks(ticks=[])
plt.yticks(ticks=[])
plt.ylabel("signal modulé")
plt.xlabel("temps (s)")
a.set_figwidth(4)
a.set_figheight(2)
plt.savefig("amplitude.pgf")

a=plt.figure(2)
plt.clf()
plt.subplot(211)
plt.title("Modulation en fréquence")
plt.plot(t,signal,label="signal modulant")
plt.xticks(ticks=[])
plt.yticks(ticks=[])
plt.ylabel("signal modulant")
plt.subplot(212)
plt.plot(t,mod_frequence, label="signal modulé")
plt.xticks(ticks=[])
plt.yticks(ticks=[])
plt.ylabel("signal modulé")
plt.xlabel("temps (s)")
a.set_figwidth(4)
a.set_figheight(2)
plt.savefig("frequence.pgf")

a=plt.figure(3)
plt.clf()
plt.subplot(211)
plt.title("Modulation en phase")
plt.plot(t,signal,label="signal modulant")
plt.xticks(ticks=[])
plt.yticks(ticks=[])
plt.ylabel("signal modulant")
plt.subplot(212)
plt.plot(t,mod_phase, label="signal modulé")
plt.xticks(ticks=[])
plt.yticks(ticks=[])
plt.ylabel("signal modulé")
plt.xlabel("temps (s)")
a.set_figwidth(4)
a.set_figheight(2)
plt.savefig("phase.pgf")
