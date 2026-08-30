




    







import matplotlib.pyplot as plt
plt.figure()
plt.plot(sol.t, sol.y[0], label='F_N2')
plt.plot(sol.t, sol.y[1], label='F_H2')
plt.plot(sol.t, sol.y[2], label='F_NH3')
plt.legend()
plt.figure()
plt.plot(sol.t, sol.y[3], label='T')
plt.xlabel('Position dans le réacteur (m)')
plt.show()