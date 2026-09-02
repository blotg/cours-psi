#import "@local/prepa:0.1.1": *

#show: exercice.with(titre: "Dipôle électrostatique", difficulté: 2)

Un dipôle est constitué d'une charge $q$ au point $A$ de coordonnées $(a/2, 0, 0)$ et d'une charge $-q$ au point $A'$ de coordonnées $(-a/2, 0, 0)$. On étudie le champ et le potentiel électriques en un point $M$. On note $d = A M$, $d' = A' M$ et $r = O M$, et $theta$ l'angle entre $va(e_x)$ et $va(O M)$. On rappelle le gradient en coordonnées sphériques :
$ grad f = pdv(f, r) va(e_r) + 1/r pdv(f, theta) va(e_theta) + 1/(r sin theta) pdv(f, phi) va(e_phi) $

#question(coups-de-pouce: (
  "Quel est le potentiel créé par une charge ponctuelle ?",
))[
  Déterminer le potentiel créé par chacune des charges en fonction de $d$ et $d'$ (potentiel nul à l'infini). En déduire le potentiel total du dipôle.
][
  Une charge ponctuelle $q_i$ à la distance $d_i$ crée le potentiel $q_i \/ (4 pi epsilon_0 d_i)$. Par superposition :
  $ V(M) = q/(4 pi epsilon_0 d) - q/(4 pi epsilon_0 d') = q/(4 pi epsilon_0) (1/d - 1/d') $
]

#question(coups-de-pouce: (
  "Développement limité de $1/d$ et $1/d'$ au premier ordre en $a/r$.",
  "Loi des cosinus : $d^2 = r^2 + (a/2)^2 - 2 r (a/2) cos theta$.",
))[
  Dans l'approximation $r >> a$, montrer que $ V(M) = 1/(4 pi epsilon_0 r^2) va(p) dot va(e_r) $ où l'on exprimera le moment dipolaire $va(p)$.
][
  Loi des cosinus : $d^2 = r^2 + a^2/4 - r a cos theta approx r^2 (1 - (a cos theta)/r)$, donc
  $ 1/d approx 1/r (1 + (a cos theta)/(2 r)) $
  De même avec $A'$ (angle $pi - theta$) : $1/d' approx 1/r (1 - (a cos theta)/(2 r))$. Ainsi
  $ 1/d - 1/d' approx (a cos theta)/r^2 quad => quad V(M) approx (q a cos theta)/(4 pi epsilon_0 r^2) $
  En posant $va(p) = q a va(e_x)$, on a $va(p) dot va(e_r) = q a cos theta$, d'où
  $ V(M) = (va(p) dot va(e_r))/(4 pi epsilon_0 r^2) $
]

#question(coups-de-pouce: (
  "Utiliser $va(E) = - grad V$ et l'expression fournie du gradient sphérique.",
))[
  En déduire l'expression du champ électrique dans la même approximation.
][
  $V = (q a cos theta)/(4 pi epsilon_0 r^2)$ ne dépend pas de $phi$. Donc
  $ va(E) = - grad V = (q a)/(4 pi epsilon_0 r^3) (2 cos theta va(e_r) + sin theta va(e_theta)) = 1/(4 pi epsilon_0 r^3) (2 p cos theta va(e_r) + p sin theta va(e_theta)) $
]
