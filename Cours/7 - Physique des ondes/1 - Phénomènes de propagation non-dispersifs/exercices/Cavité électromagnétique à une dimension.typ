#import "@local/prepa:0.1.1": *

#show: exercice.with(titre: "Cavité électromagnétique à une dimension", difficulté: 2)

On considère le vide compris entre deux plans infiniment conducteurs d'équations $x = 0$ et $x = a$. On étudie le champ électromagnétique entre les plans.

#question[
  Établir l'équation de propagation de $va(E)$ dans le vide.
][
  En combinant les équations de Maxwell dans le vide ($rho = 0$, $va(j) = va(0)$), on obtient l'équation de d'Alembert
  $ Delta va(E) - 1/c^2 pdv(va(E), t, 2) = va(0) quad "avec" quad c = 1/sqrt(epsilon_0 mu_0) $
]

#question(coups-de-pouce: (
  "Remplacer $va(E)$ par $f(x) g(t) va(e_y)$ dans l'équation de d'Alembert et séparer les variables.",
))[
  On cherche $va(E) = f(x) g(t) va(e_y)$. Établir $f''(x) = alpha f(x)$ et $g''(t) = alpha c^2 g(t)$, où $alpha$ est une constante.
][
  Le champ ne dépend que de $x$ : $Delta va(E) = f''(x) g(t) va(e_y)$. L'équation de d'Alembert donne
  $ f''(x) g(t) - 1/c^2 f(x) g''(t) = 0 quad => quad (f''(x))/(f(x)) = 1/c^2 (g''(t))/(g(t)) $
  Le membre de gauche ne dépend que de $x$, celui de droite que de $t$ : ils sont égaux à une constante $alpha$. D'où $f'' = alpha f$ et $g'' = alpha c^2 g$.
]

#question(coups-de-pouce: (
  "Dans un conducteur parfait, $va(E) = va(0)$ ; la composante tangentielle de $va(E)$ est continue.",
))[
  Quelles sont les conditions aux limites ?
][
  $va(E)$ est porté par $va(e_y)$, tangent aux plans conducteurs. Dans un conducteur parfait le champ est nul, et la composante tangentielle de $va(E)$ est continue : donc $va(E)(0, t) = va(E)(a, t) = va(0)$, soit
  $ f(0) = f(a) = 0 $
]

#question(coups-de-pouce: (
  "L'équation sur $f$ a trois familles de solutions selon le signe de $alpha$ : une seule admet des solutions non nulles compatibles avec les CL.",
))[
  Déterminer $f(x)$ et l'écrire comme une fonction de $k x$, où $k$ dépend d'un entier $n$.
][
  - Si $alpha > 0$ : $f = A e^(sqrt(alpha) x) + B e^(- sqrt(alpha) x)$ ; les CL imposent $A = B = 0$.
  - Si $alpha = 0$ : $f$ affine ; les CL imposent $f = 0$.
  - Si $alpha < 0$ : on pose $alpha = - k^2$, $f = A cos(k x) + B sin(k x)$. $f(0) = 0 => A = 0$ ; $f(a) = 0 => B sin(k a) = 0$, donc $k a = n pi$ avec $n in NN^*$.

  D'où $ f(x) = E_0 sin(k x) quad "avec" quad k = (n pi)/a $
]

#question(coups-de-pouce: (
  "Quelles sont les solutions de l'équation sur $g$ ?",
))[
  En déduire $va(E)$ en fonction de $k$, d'une constante $E_0$ et d'une phase $phi.alt$.
][
  Avec $alpha = - k^2$ : $g'' = - k^2 c^2 g = - omega^2 g$ où $omega = k c$. Donc $g(t) = cos(omega t + phi.alt)$ (à une constante près, absorbée dans $E_0$) et
  $ va(E) = E_0 sin(k x) cos(omega t + phi.alt) va(e_y), quad k = (n pi)/a, quad omega = k c $
]

#question[
  Quel est l'analogue mécanique de ce problème ?
][
  Une corde vibrante fixée à ses deux extrémités (en $x = 0$ et $x = a$) : mêmes conditions aux limites strictes, mêmes modes propres $omega_n = (n pi c)/a$, mêmes profils $sin(n pi x \/ a)$.
]

#question(coups-de-pouce: (
  "La relation de structure (démontrée pour une OPPH) ne s'applique pas ici.",
  "Utiliser l'équation de Maxwell-Faraday.",
))[
  Établir $va(B)$. Que dire des points où $va(B)$ est constamment nul par rapport à ceux où $va(E)$ l'est ?
][
  Maxwell-Faraday : $pdv(va(B), t) = - rot va(E)$. Avec $va(E) = E_y (x, t) va(e_y)$ et $E_y$ ne dépendant que de $x$ :
  $ rot va(E) = pdv(E_y, x) va(e_z) = E_0 k cos(k x) cos(omega t + phi.alt) va(e_z) $
  d'où, en intégrant en temps,
  $ va(B) = - E_0/c cos(k x) sin(omega t + phi.alt) va(e_z) $

  $va(E) prop sin(k x)$ : nœuds en $k x = m pi$. $va(B) prop cos(k x)$ : nœuds en $k x = pi/2 + m pi$. Les nœuds de $va(B)$ coïncident avec les ventres de $va(E)$ et réciproquement : les deux ondes stationnaires sont décalées d'un quart de longueur d'onde dans l'espace (et de $pi \/ 2$ dans le temps).
]
