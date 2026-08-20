#import "@local/prepa:0.1.0": *

= Transformer un système ouvert $Sigma^0$ en système fermé

+ On définit $delta Sigma_1$ le système qui rentre dans $Sigma^0$ entre $t$ et $t+dd(t)$. On définit $delta Sigma_2$ le système qui sort de $Sigma^0$ entre $t$ et $t+dd(t)$.
+ On définit le système fermé $Sigma^*$ tel que $Sigma^*(t) = Sigma^0(t) union delta Sigma_1$.
+ Comme $Sigma^*$ est fermé par définition, à l'instant $t+dd(t)$, $Sigma^*(t+dd(t)) = Sigma^0(t+dd(t)) union delta Sigma_2$.
Comme $Sigma^*$ est fermé, on peut lui appliquer les bilans connus pour les systèmes fermés (1er et 2ème principes de la thermodynamique, TRC, TMC, ...).

= Faire un bilan d'une grandeur additive sur un système ouvert en régime stationnaire

+ Définir un système fermé $Sigma^*$ à partir du système ouvert $Sigma^0$ (cf méthode précédente).
+ Écrire la bilan sur le système fermé $Sigma^*$.
+ Utiliser l'additivité de la grandeur considérée pour décomposer entre la grandeur de $Sigma^0$, celle de $delta Sigma_1$ et celle de $delta Sigma_2$.
+ En régime stationnaire, les grandeurs d'état de $Sigma^0$ ne varient pas au cours du temps.