#import "@local/prepa:0.1.1": *

#show: simulation.with(
    titre: "Onduleur en MLI",
    capytale: "c90e-2976695",
)

Les deux programmes ci-dessous tracent la tension $u_s (t)$ en sortie d'un onduleur commandé en MLI et le courant $i_s (t)$ dans une charge R-L. Sur chaque période de MLI, la tension vaut $E$ pendant $alpha T_"MLI"$, puis $-E$ ; le rapport cyclique $alpha(t) = (1 + cos((2 pi) / T t)) / 2$ donne à sa valeur moyenne la forme $E cos((2 pi) / T t)$.

La première version résout numériquement l'équation différentielle $L dv(i_s, t) + R i_s = u_s (t)$ avec `solve_ivp`.

```python
import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp

R = 10  # résistance du résistor en ohm
L = 0.1  # inductance de la bobine en H
tau = L / R  # constante de temps de la charge R-L
E = 10  # tension de la source de tension en V

T = 20e-3  # période du signal sinusoïdal voulu en s
n = 2  # nombre de périodes à tracer
T_MLI = T / 50  # période de la MLI
N_MLI = 200  # nombre de pas de temps par période de MLI
dt = T_MLI / N_MLI  # pas de temps de la simulation

temps = np.arange(0, n * T, dt)  # liste de tous les temps
# rapport cyclique pour obtenir une tension de sortie « en moyenne » sinusoïdale
alpha = (1 + np.cos(2 * np.pi * temps / T)) / 2

# Calcul de la tension de sortie en MLI
u_s = np.zeros(len(temps))
for i in range(0, len(temps), N_MLI):
    deb = i
    mil = min(i + int(alpha[i] * N_MLI), len(temps))
    fin = min(i + N_MLI, len(temps))
    u_s[deb:mil] = E  # première partie de la période de MLI
    u_s[mil:fin] = -E  # seconde partie de la période de MLI

# Résolution numérique de di/dt + i/tau = u_s/L
def f(t, i):
    return u_s[min(int(t / dt), len(temps) - 1)] / L - i / tau

solution_i = solve_ivp(f, (temps[0], temps[-1]), [0], t_eval=temps, max_step=dt)

# Tracé
plt.figure("Onduleur avec MLI")
plt.clf()
plt.subplot(2, 1, 1)
plt.title("Tension et courant en sortie d'un onduleur avec MLI")
plt.plot(temps, u_s, label="$u_s(t)$")
plt.plot(temps, E * np.cos(2 * np.pi * temps / T), "--", label="valeur moyenne visée")
plt.ylabel("Tension (V)")
plt.legend()
plt.subplot(2, 1, 2)
plt.plot(solution_i.t, solution_i.y[0], label="$i_s(t)$")
plt.ylabel("Courant (A)")
plt.xlabel("Temps (s)")
plt.legend()
plt.show()
```

La seconde version n'a pas besoin de résolution numérique. Sur chaque intervalle où la tension est constante, égale à $plus.minus E$, le courant est une portion d'exponentielle de constante de temps $tau = L / R$, qui tend vers $plus.minus E / R$ :
$
    i_s (t) = (i_s (t_0) minus.plus E / R) e^(-(t - t_0) / tau) plus.minus E / R
$
où $t_0$ est le début de l'intervalle. Elle est bien plus rapide.

```python
import numpy as np
import matplotlib.pyplot as plt

R = 10  # résistance du résistor en ohm
L = 0.1  # inductance de la bobine en H
tau = L / R  # constante de temps de la charge R-L
E = 10  # tension de la source de tension en V

T = 20e-3  # période du signal sinusoïdal voulu en s
n = 2  # nombre de périodes à tracer
T_MLI = T / 50  # période de la MLI
N_MLI = 200  # nombre de pas de temps par période de MLI
dt = T_MLI / N_MLI  # pas de temps de la simulation

temps = np.arange(0, n * T, dt)  # liste de tous les temps
# rapport cyclique pour obtenir une tension de sortie « en moyenne » sinusoïdale
alpha = (1 + np.cos(2 * np.pi * temps / T)) / 2

# Calcul de la tension et du courant de sortie en MLI
u_s = np.zeros(len(temps))
i_s = np.zeros(len(temps))
for i in range(0, len(temps), N_MLI):
    deb = max(i, 1)
    mil = min(i + int(alpha[i] * N_MLI), len(temps))
    fin = min(i + N_MLI, len(temps))
    # première partie de la période de MLI
    u_s[deb:mil] = E
    i_s[deb:mil] = (i_s[deb - 1] - E / R) * np.exp(-(temps[deb:mil] - temps[deb - 1]) / tau) + E / R
    # seconde partie de la période de MLI
    u_s[mil:fin] = -E
    i_s[mil:fin] = (i_s[mil - 1] + E / R) * np.exp(-(temps[mil:fin] - temps[mil - 1]) / tau) - E / R

# Tracé
plt.figure("Onduleur avec MLI, version exacte")
plt.clf()
plt.subplot(2, 1, 1)
plt.title("Tension et courant en sortie d'un onduleur avec MLI")
plt.plot(temps, u_s, label="$u_s(t)$")
plt.plot(temps, E * np.cos(2 * np.pi * temps / T), "--", label="valeur moyenne visée")
plt.ylabel("Tension (V)")
plt.legend()
plt.subplot(2, 1, 2)
plt.plot(temps, i_s, label="$i_s(t)$")
plt.ylabel("Courant (A)")
plt.xlabel("Temps (s)")
plt.legend()
plt.show()
```

Le courant n'est quasi sinusoïdal que si $T_"MLI"$ est très petite devant $tau$. Augmenter `T_MLI` jusqu'à $tau$ pour voir sa forme se dégrader.
