#import "@local/prepa:0.1.1": *

#show: exercice.with(titre: "Câble coaxial alimenté par un générateur", difficulté: 2)

Un câble coaxial sans pertes, de longueur $L$, d'impédance caractéristique $Z_c$ et de célérité $c$, est alimenté en $x = 0$ par une source de tension $e(t) = E_0 cos(omega t)$. L'autre extrémité ($x = L$) est laissée ouverte. On note $k = omega \/ c$.

#question(coups-de-pouce: (
  "Deux méthodes : solution $f(x) g(t)$ (milieu fini), ou somme d'une onde incidente et d'une onde réfléchie.",
  "Conditions aux limites : en $x = 0$ ? en $x = L$ ?",
))[
  Déterminer l'onde de tension $u(x, t)$ et l'onde de courant $i(x, t)$.
][
  On cherche $u(x, t) = Re[underline(U)(x) e^(j omega t)]$ avec $underline(U)(x) = underline(U)_+ e^(- j k x) + underline(U)_- e^(j k x)$. Les équations des télégraphistes donnent
  $ underline(I)(x) = 1/Z_c (underline(U)_+ e^(- j k x) - underline(U)_- e^(j k x)) $

  #strong[Condition en $x = L$] (extrémité ouverte, $i(L, t) = 0$) : $underline(U)_+ e^(- j k L) = underline(U)_- e^(j k L)$.

  #strong[Condition en $x = 0$] (source, $u(0, t) = e(t)$) : $underline(U)_+ + underline(U)_- = E_0$.

  On en tire $underline(U)_+ e^(- j k L) = underline(U)_- e^(j k L) = E_0 \/ (2 cos(k L))$, puis
  $
    u(x, t) &= E_0 (cos(k(L - x)))/(cos(k L)) cos(omega t) \
    i(x, t) &= - E_0/Z_c (sin(k(L - x)))/(cos(k L)) sin(omega t)
  $
  (tension : ventre en $x = L$, nœud possible ailleurs ; courant : nœud en $x = L$, conforme à l'extrémité ouverte).
]

#question[
  Pour certaines valeurs de $omega$, les amplitudes de $u$ et $i$ deviennent très grandes. Expliquer et déterminer ces pulsations.
][
  Les amplitudes sont proportionnelles à $1 \/ cos(k L)$ : elles divergent quand
  $ cos(k L) = 0 quad <=> quad k L = pi/2 + n pi quad <=> quad omega_n = (2 n + 1) (pi c)/(2 L), quad n in NN $
  Ce sont les #strong[résonances] du câble « ouvert d'un côté, alimenté de l'autre » : elles correspondent à $L = (2 n + 1) lambda \/ 4$ (résonances quart d'onde). En pratique, les pertes (négligées ici) limitent l'amplitude à une valeur finie.
]
