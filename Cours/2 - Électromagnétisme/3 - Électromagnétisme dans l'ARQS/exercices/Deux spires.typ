#import "@local/prepa:0.1.1": *

#exercice(
  titre: "Inductance mutuelle entre deux spires",
  numérique: true,
  capytale: "6e41-7604729",
)[

#figure[
  #canvas({
    import cetz.draw: *
    set-style(stroke: (thickness: 0.5pt))
    set-style(content: (padding: .1))
    circle( (0,0), radius: 1, stroke: (thickness: 1pt))
    arc( (0.2588,0.9659), start: 75deg, delta: 30deg, radius: 1, stroke: (thickness: 1pt), mark: (end: ">>", fill: black))
    content( (0,-1), [spire 1], anchor: "north")
    line( (0,0), (-1,0), name: "R1", mark: (symbol: ">>", fill: black))
    content( "R1.mid", $R$, anchor: "north")
    line( (4,0), (3,0), name: "R2", mark: (symbol: ">>", fill: black))
    content( "R2.mid", $R$, anchor: "north")
    line( (0,0), (3,0), name: "d", mark: (symbol: ">>", fill: black))
    content( "d.mid", $d$, anchor: "north")
    circle( (3,0), radius: 1, name: "spire2", stroke: (thickness: 1pt))
    arc( (2.7412,0.9659), start: 105deg, delta: -30deg, radius: 1, stroke: (thickness: 1pt), mark: (end: ">>", fill: black))
    content( (3,-1), [spire 2], anchor: "north")
  })
]

On cherche à calculer numériquement l'inductance mutuelle entre deux spires circulaires coplanaires de même rayon $R$, dont les centres $O_1$ et $O_2$ sont distants de $d$. On note $va(e_z)$ le vecteur unitaire normal au plan des spires, dirigé vers le lecteur sur la figure. Les deux spires sont orientées en sens inverse l'une de l'autre (voir figure) : la spire 1 est orientée selon $va(e_z)$, la spire 2 selon $-va(e_z)$. On se place dans le régime quasi-stationnaire.

#question(coups-de-pouce: (
  "Quel système de coordonnées est le plus adapté pour étudier ce problème ?",
))[
  Déterminer les invariances du champ magnétique créé par une des spires.
][
  La distribution de courant dans la spire 1 est invariante par rotation autour de l'axe perpendiculaire au plan des spires passant par leur centre $O_1$, donc d'après le principe de Curie, le champ magnétique ne dépend pas de $theta$ : $va(B_1)(r, cancel(theta), z)$.
]

#question(coups-de-pouce: (
  "On s'intéresse uniquement à un point $M$ situé dans le plan des spires.",
  "Chercher un plan de symétrie passant par $M$.",
))[
  Quelle est la direction du champ magnétique dans le plan des spires ?
][
  Le plan contenant les deux spires est un plan de symétrie de la distribution de courant. Donc le champ magnétique dans ce plan est perpendiculaire à ce plan, c'est-à-dire selon $va(e_z)$.
]

Pour $d >> R$, on peut approximer le champ magnétique créé dans le plan des spires par la spire 1, parcourue par un courant $I_1$, par celui d'un dipôle magnétique de moment $va(m) = pi R^2 I_1 va(e_z)$. Dans ce plan et hors de la spire 1, ce champ est opposé au moment : $va(B_1) = -B_1 va(e_z)$ avec $B_1=mu_0/(4 pi) (pi R^2 I_1)/(r_1^3)$, où $r_1 = O_1 M$.

#figure[
  #canvas({
    import cetz.draw: *
    scale(1.6)
    set-style(stroke: (thickness: 0.5pt))
    set-style(content: (padding: .1))
    circle( (0,0), radius: 1, stroke: (thickness: 1pt))
    circle( (3,0), radius: 1, name: "spire2", stroke: (thickness: 1pt))
    line( (-2,0), (5,0), stroke: (dash: "dashed"))
    line( (0,0), (3.5,0.7), name: "R1", mark: (end: ">>", fill: black))
    content( "R1.mid", $r_1$, anchor: "south")
    line( (3,0), (3.5,0.7), name: "R2", mark: (end: ">>", fill: black))
    content( "R2.mid", $r_2$, anchor: "east")
    arc( (3.3,0), radius: 0.3, start: 0deg, delta: 54deg, name: "theta2", mark: (end: ">>", fill: black))
    content( (3.3,0.12), $theta_2$, anchor: "west")
    content( (0,0), $O_1$, anchor: "north-east")
    content( (3,0), $O_2$, anchor: "north-east")
    circle( (3.5,0.7), radius: 0.03, fill: black)
    content( (3.5,0.7), $M$, anchor: "south-west")
  })
]

#question(coups-de-pouce: (
  "Décomposer $va(O_1M)$ avec la relation de Chasles en fonction de $va(O_1O_2)$ et $va(O_2M)$.",
  "Quelle relation lie $r_1$ et $va(O_1M)$ ?",
))[
  Exprimer $r_1$ en fonction de $r_2$, $theta_2$ et $d$.
][
  $ r_1 = norm(va(O_1M)) = norm(va(O_1O_2) + va(O_2M)) = sqrt(d^2 + r_2^2 + 2 d r_2 cos theta_2) $
]

#question(coups-de-pouce: (
  "Utiliser la définition du flux magnétique à travers une surface comme une intégrale.",
))[
  Montrer que le flux du champ magnétique $va(B_1)$ à travers la spire 2 est donné par $Phi_(1 arrow 2) = A integral_0^(2 pi)dd(theta_2) integral_0^R dd(r_2) r_2/ ((d^2+r_2^2+2 d r_2 cos theta_2)^(3/2))$
][
  La spire 2 est orientée selon $-va(e_z)$, comme le champ $va(B_1)$ dans le plan des spires : $va(B_1) dot va(dd(S)) = B_1 dd(S)$. Le flux du champ magnétique à travers la spire 2 est $ Phi_(1 arrow 2) = integral_("spire" 2) va(B_1) dot va(dd(S)) = integral_0^(2 pi) dd(theta_2) integral_0^R dd(r_2) r_2 B_1(r_2, theta_2) $ avec $B_1(r_2, theta_2) = mu_0/(4 pi) (pi R^2 I_1)/(d^2 + r_2^2 + 2 d r_2 cos theta_2)^(3/2)$. On en déduit l'expression demandée avec $A = mu_0/(4) R^2 I_1$.
]

La fonction ```python dblquad``` de la bibliothèque ```python scipy.integrate``` permet de calculer numériquement des intégrales doubles. L'appel ```python dblquad(func, a, b, c, d)``` calcule $integral_a^b dd(x) integral_c^d dd(y) "func"(y, x)$. Attention à l'ordre : ```python func``` prend d'abord la variable `y` de l'intégrale intérieure, qui va de `c` à `d`, puis la variable `x` de l'intégrale extérieure, qui va de `a` à `b`. ```python dblquad``` retourne un couple dont le premier élément est la valeur de l'intégrale.

#question()[
  Compléter le programme Python suivant pour calculer numériquement l'inductance mutuelle.
  ```python
  from scipy.integrate import dblquad
  from math import cos, pi

  mu_0 = ...  # Perméabilité du vide en H/m
  R = 1e-2    # Rayon des spires en m

  def M(d):
      """Inductance mutuelle (en H) de deux spires dont les centres sont distants de d (en m)."""
      def f(r_2, theta_2):
          return ...  # Fonction à intégrer

      intégrale, _ = dblquad(f, ..., ..., ..., ...)
      return ...
  ```
][
  ```python
  from scipy.integrate import dblquad
  from math import cos, pi

  mu_0 = 4e-7 * pi  # Perméabilité du vide en H/m
  R = 1e-2          # Rayon des spires en m

  A = mu_0 / 4 * R**2

  def M(d):
      # dblquad intègre func(y, x) : r_2 est la variable interne
      def f(r_2, theta_2):
          return r_2 / ((d**2 + r_2**2 + 2 * d * r_2 * cos(theta_2))**(3/2))

      intégrale, _ = dblquad(f, 0, 2 * pi, 0, R)
      return A * intégrale
  ```
]

#question()[
  Tracer l'évolution de l'inductance mutuelle $M$ en fonction de la distance $d$ entre les deux spires. On prendra $20$ points avec $d$ variant de $5 R$ à $50 R$.
  ```python
  import numpy as np
  import matplotlib.pyplot as plt

  distances = np.linspace(..., ..., ...)  # Distances en m
  inductances = [... for d in distances]  # Inductances mutuelles en H
  plt.plot(..., ...)
  plt.xlabel('Distance d (m)')
  plt.ylabel('Inductance mutuelle M (H)')
  plt.show()
  ```
][
  ```python
  import numpy as np
  import matplotlib.pyplot as plt
  distances = np.linspace(5*R, 50*R, 20) # Distances en m
  inductances = [M(d) for d in distances] # Calcul des inductances mutuelles
  plt.plot(distances, inductances)
  plt.xlabel('Distance d (m)')
  plt.ylabel('Inductance mutuelle M (H)')
  plt.title('Inductance mutuelle entre deux spires en fonction de la distance')
  plt.show()
  ```
]

]