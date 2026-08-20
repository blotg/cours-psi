R = 8.314  # J/mol/K

coefs_co2_basse = [4.94e4, -6.26e2, 5.30, 2.50e-3, -2.13e-7, -7.69e-10, 2.85e-13]
coefs_co2_haute = [1.18e5, -1.79e3, 8.29, -9.22e-5, 4.86e-9, -1.89e-12, 6.33e-16]
coefs_h2o_basse = [-3.95e4, 5.76e2, 9.32e-1, 7.22e-3, -7.34e-6, 4.96e-9, -1.34e-12]
coefs_h2o_haute = [1.03e6, -2.41e3, 4.65, 2.29e-3, -6.84e-7, 9.43e-11, -4.82e-15]

def cpm_CO2(T):
    s = 0
    if T <=1000:
        for i in range(-2, 5):
            s += coefs_co2_basse[i + 2] * T**i
    else:
        for i in range(-2, 5):
            s += coefs_co2_haute[i + 2] * T**i
    return s*R

# for T in [300,1000,2000,3000]:
#     print(T, cpm_CO2(T))

def cpm_H2O(T):
    s = 0
    if T <=1000:
        for i in range(-2, 5):
            s += coefs_h2o_basse[i + 2] * T**i
    else:
        for i in range(-2, 5):
            s += coefs_h2o_haute[i + 2] * T**i
    return s*R

# for T in [300,1000,2000,3000]:
#     print(T, cpm_H2O(T))

from scipy.integrate import quad
DrH = 2 * -394e3 + 1 * -254e3 - 1 * 227e3 - 5/2 * 0
# print(DrH/1e6)

def df(theta):
    return 2 * cpm_CO2(theta) + cpm_H2O(theta)

def f(theta):
    T_i = 25 + 273.15  # K
    intégrale, _ = quad(df, T_i, theta)
    return intégrale + DrH

xk = 0
xk1 = 1000
while abs(xk1 - xk) >= 0.1:
    xk = xk1
    xk1 = xk - f(xk) / df(xk)
    # print(xk, xk1)
print(f"Température de flamme : {xk1} K")