#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "Traitement antireflet",
    numérique: true,
)

On réalise un traitement antireflet sur un verre d'indice de réfraction $n = 1.5$ en déposant une couche d'indice optique $n_c in ]1, n[$ et d'épaisseur $e$ de l'ordre de la centaine de #unit("nm"). Le but de ce traitement est d'annuler la réflexion à dans l'air pour la longueur d'onde $lambda = qty("500", "nm")$ (longueur d'onde pour laquelle l'œil est le plus sensible).

#figure(
    canvas({
        import draw: *
        line((0, 0), (0, 4), stroke: 2pt)
        line((4, 0), (4, 4), stroke: 2pt)
        line((-4, 0), (8, 0), mark: (end: ">>", fill: black))
        content((), $x$, anchor: "west", padding: .2em)
        content((4, 0), $e$, anchor: "north", padding: .2em)
        content((0, 0), $0$, anchor: "north", padding: .2em)
        content((-2, 3.5), $n_"air"=1$)
        content((2, 3.5), $n_c$)
        content((6, 3.5), $n=1$)
        cetz.decorations.wave(
            line((-3.5, 1.5), (-0.5, 1.5)),
            amplitude: 0.5,
            segments: 4,
        )
        mark((-0.45, 1.65), 70deg, symbol: ">>", fill: black)
        cetz.decorations.wave(
            line((0.5, 2), (3.5, 2)),
            amplitude: 0.5,
            segments: 4,
        )
        mark((3.55, 2.15), 70deg, symbol: ">>", fill: black)
        cetz.decorations.wave(
            line((0.5, 0.5), (3.5, 0.5)),
            amplitude: 0.5,
            segments: 4,
        )
        mark((0.45, 0.35), 180deg + 70deg, symbol: ">>", fill: black)
        cetz.decorations.wave(
            line((4.5, 1.5), (7.5, 1.5)),
            amplitude: 0.5,
            segments: 4,
        )
        mark((7.55, 1.65), 70deg, symbol: ">>", fill: black)
        content((-2, 1.5), $va(E_i)$, anchor: "south", padding: 1em)
        content((2, 2), $va(E_c)$, anchor: "south", padding: 1em)
        content((2, 0.5), $va(E_c) '$, anchor: "south", padding: 1em)
        content((6, 1.5), $va(E_t)$, anchor: "south", padding: 1em)
    }),
)

Les 4 ondes sont des OPPH de même fréquence :
$
    cases(
        underline(va(E_i)) = underline(E_(i,0)) e^(i (omega t - k_i x)),
        underline(va(E_c)) = underline(E_(c,0)) e^(i (omega t - k_c x)),
        underline(va(E_c)') = underline(E_(c,0) ') e^(i (omega t + k_c x)),
        underline(va(E_t)) = underline(E_(t,0)) e^(i (omega t - k_t x))
    )
$

Les champs électrique et magnétique sont continus à chacune des deux interfaces.

L'objectif de cet exercice est de déterminer l'épaisseur $e$ et l'indice optique $n_c$ de la couche anti-reflet.

#question()[
    Donner l'expression de l'indice optique en fonction de la vitesse de phase et de la célérité de la lumière dans le vide. En déduire les expressions de $k_i$, $k_c$ et $k_t$ en fonction de $n$, $n_c$, $omega$ et de la célérité de la lumière dans le vide.
][
    $
        n = v_phi / c
    $
    On en déduit
    $
        cases(
            k_i = n_"air" omega / c = omega / c,
            k_c = n_c omega / c,
            k_t = n omega / c
        )
    $
]

#question()[
    Déterminer les champs magnétiques associés à chacune des ondes.
][
    On utilise la relation de structure $underline(va(B)) = (va(k) and underline(va(E))) / omega$
    $
        cases(
            underline(va(B_i)) = omega/c underline(E_(i,0)) e^(i (omega t - k_i x)),
            underline(va(B_c)) = n_c omega/c underline(E_(c,0)) e^(i (omega t - k_c x)),
            underline(va(B_c)') = - n_c omega/c underline(E_(c,0) ') e^(i (omega t + k_c x)),
            underline(va(B_t)) = n omega/c underline(E_(t,0)) e^(i (omega t - k_t x))
        )
    $
]

#question()[
    En utilisant la continuité des champs, établir un système de 4 équations reliant les amplitudes $underline(E_(i,0))$, $underline(E_(c,0))$, $underline(E_(c,0) ')$ et $underline(E_(t,0))$. Mettre ce système sous la forme $M vec(underline(E_(i,0)), underline(E_(c,0)), underline(E_(c,0) '), underline(E_(t,0))) = vec(0, 0, 0, 0)$ où $M$ est une matrice $4 times 4$ à déterminer.
][
    $
        cases(
            underline(E_(i,0)) = underline(E_(c,0)) + underline(E_(c,0) '),
            underline(E_(i,0)) = n_c underline(E_(c,0)) - n_c underline(E_(c,0) '),
            underline(E_(c,0)) e^(-i k_c e) + underline(E_(c,0) ') e^(i k_c e) = underline(E_(t,0)) e^(-i k_t e),
            n_c underline(E_(c,0)) e^(-i k_c e) - n_c underline(E_(c,0) ') e^(i k_c e) = n underline(E_(t,0)) e^(-i k_t e)
        )
    $
    $
        cases(
            underline(E_(i,0)) - underline(E_(c,0)) - underline(E_(c,0) ') + 0 underline(E_(t,0)) = 0,
            underline(E_(i,0)) - n_c underline(E_(c,0)) + n_c underline(E_(c,0) ') + 0 underline(E_(t,0)) = 0,
            0 underline(E_(i,0)) + e^(-i k_c e) underline(E_(c,0)) + e^(i k_c e) underline(E_(c,0) ') - e^(-i k_t e) underline(E_(t,0)) = 0,
            0 underline(E_(i,0)) + n_c e^(-i k_c e) underline(E_(c,0)) - n_c e^(i k_c e) underline(E_(c,0) ') - n e^(-i k_t e) underline(E_(t,0)) = 0
        )
    $
    On en déduit
    $
        M = mat(
            1, -1, -1, 0;
            1, -n_c, n_c, 0;
            0, e^(-i k_c e), e^(i k_c e), -e^(-i k_t e);
            0, n_c e^(-i k_c e), -n_c e^(i k_c e), -n e^(-i k_t e)
        )
    $
]

#question()[
    Donner une solution de l'équation $M vec(underline(E_(i,0)), underline(E_(c,0)), underline(E_(c,0) '), underline(E_(t,0))) = vec(0, 0, 0, 0)$. En déduire que pour que le traitement antireflet fonctionne, il faut que $det(M) = 0$.
][
    $vec(underline(E_(i,0)), underline(E_(c,0)), underline(E_(c,0) '), underline(E_(t,0))) = vec(0, 0, 0, 0)$ est une solution de l'équation. C'est une solution triviale, avec des ondes identiquement nulles dans les trois milieux. Cette solution est unique si $M$ est inversible, c'est-à-dire sir $det(M) != 0$.

    Pour que le traitement antireflet fonctionne, il faut qu'il existe une solution non triviale, c'est-à-dire que $M$ ne soit pas inversible, c'est-à-dire que $det(M) = 0$.
]

#question()[
    La fonction `np.linalg.det` de la bibliothèque `numpy` permet de calculer le déterminant d'une matrice. Écrire une fonction `D(e,n)` qui renvoie le déterminant de la matrice $M$ en fonction de $e$ et $n_c$.
][
    ```python
    import numpy as np
    n = 1.5
    lam = 500e-9
    c = 3e8
    omega = 2 * np.pi * c / lam
    def D(e,nc):
        kt = n * omega / c
        kc = nc * omega / c
        M = np.array([
            [1, -1,                  -1,                  0],
            [1, -nc,                 nc,                  0],
            [0, np.exp(-1j*kc*e),    np.exp(1j*kc*e),     -np.exp(-1j*kt*e)],
            [0, nc*np.exp(-1j*kc*e), -nc*np.exp(1j*kc*e), -n*np.exp(-1j*kt*e)]
        ])
        return np.linalg.det(M)
    ```
]

Pour résoudre numériquement l'équation $D(e, n_c) = 0$, on peut utiliser la fonction `root` de la bibliothèque `scipy.optimize` qui permet de trouver les racines d'une fonction.

La fonction dont `root` doit trouver les racines doit prendre en argument un tableau numpy de réels et renvoyer un tableau numpy de réels.

On définit la fonction
```python
def f(X):
    e, nc = X
    d = D(e, nc)
    return [d.real, d.imag]
```

#question()[
    Expliquer pourquoi la fonction `f` est adaptée pour être utilisée avec la fonction `root` de `scipy.optimize`.
][
    La fonction `f` prend bien en argument un tableau numpy de réels (le tableau `X` qui contient les valeurs de `e` et `nc`) et renvoie un tableau numpy de réels (le tableau `[d.real, d.imag]`).

    Trouver les $0$ de la fonction `f` est bien ce qu'on veut car le complexe $d$ est nul si et seulement si sa partie réelle et sa partie imaginaire sont nulles, c'est-à-dire si et seulement si `f(X) == [0, 0]`.
]

On trouve une solution avec les instructions suivantes :
```python
from scipy.optimize import root
solution = root(f, [1e-7, 1.3] ) # on fournit une estimation initiale pour e et nc
print(solution.x)
```

