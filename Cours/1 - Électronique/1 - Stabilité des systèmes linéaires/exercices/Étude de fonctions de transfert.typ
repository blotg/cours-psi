#import "@local/prepa:0.1.0": *

#show: exercice.with(
    titre: "Étude de fonctions de transfert",
)

Pour chacune des fonctions de transfert ci-dessous, donner l'équation différentielle associée et dire si elles décrivent un système stable ou instable.

#question()[
    $H=p/(1+p)$
][
    $
        H(p) = (S(p))/(E(p)) = p/(1+p)\
        (1+p)S(p) = E(p)\
        S(p)+p S(p)=E(p)\
        s(t)+dv(s, t)=e(t)\
        bold(1) s(t) + bold(1) dv(s, t)=e(t)
    $
    Les deux coefficient (*1* et *1*) sont de même signe, le système est donc stable.
]

#question()[
    $H=(p^2)/(1-p+p^2)$
][
    $
        H(p) = (S(p))/(E(p)) = p^2/(1-p+p^2)\
        (1-p+p^2)S(p) = E(p)\
        S(p)-p S(p)+p^2 S(p)=E(p)\
        s(t)-dv(s, t)+dv(s, t, 2)=e(t)\
        bold(1) s(t) + bold((-1)) dv(s, t)+bold(1) d^2v(s, t)=e(t)
    $
    Les coefficients sont de signes différents (*1*, *-1* et *1*), le système est donc instable.
]

#question()[
    $underline(H)=1/(1+j Q(omega/omega_0 - omega_0/omega))$
][
    $
        underline(H)(j omega) = (underline(S)(j omega))/(underline(E)(j omega)) = 1/(1+j Q(omega/omega_0 - omega_0/omega))\
        (1+j Q(omega/omega_0 - omega_0/omega))underline(S)(j omega) = underline(E)(j omega)\
        underline(S)(j omega)+j Q omega/omega_0 underline(S) - j Q omega_0/omega underline(S)(j omega)=underline(E)(j omega)\
    $
    Pour passer en temporel, il est plus commode de faire disparaitre les $j omega$ au dénominateur. On multiplie donc par $j omega$:
    $
        j omega underline(S)(j omega)+j^2 Q omega^2/omega_0 underline(S) - j^2 Q omega_0 underline(S)(j omega)=j omega underline(E)(j omega)\
        j omega underline(S)(j omega) + Q (j omega)^2/omega_0 underline(S) + Q omega_0 underline(S)(j omega)=j omega underline(E)(j omega)\
    $
    $
      dv(s, t)+Q/omega_0 dv(s, t,2)+Q omega_0 s(t)=dv(e, t)\
    $
    Les coefficients sont de même signe ($1$, $Q/omega_0$ et $Q omega_0$), le système est donc stable.
]
