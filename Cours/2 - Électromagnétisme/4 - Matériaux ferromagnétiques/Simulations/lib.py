# -*- coding: utf-8 -*-
"""
Outils communs aux simulations de lignes de champ magnétique.

Dans les deux modèles utilisés, les lignes de champ sont les lignes de niveau
d'une fonction F(x, y) :
- modèle 2D plan (invariance selon z, courants selon z) : F = A_z, calculé par
  différences finies, ce qui permet de prendre en compte un matériau
  ferromagnétique (circuits magnétiques) ;
- symétrie de révolution autour de l'axe (Oy) : F = x A_phi, calculé
  analytiquement (spire, dipôle, aimant).
Dans les deux cas, le flux de B entre les lignes de niveau F1 et F2 est
proportionnel à F2 - F1 : avec des niveaux équidistants, deux lignes voisines
délimitent toujours le même flux.
"""

from pathlib import Path

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.path import Path as Chemin
from matplotlib.patches import Circle, PathPatch
import scipy.sparse as sp
import scipy.sparse.linalg as spla
from scipy.special import ellipe, ellipk

mu0 = 4e-7*np.pi# H/m

# ---------- Style commun des figures ----------
LARGEUR = 8/2.54# in, largeur des figures enregistrées
EPAISSEUR = 0.8# pt, épaisseur des traits
POINTE = 7# pt, taille des pointes de flèches
GRIS = "lightgrey"# matériau ferromagnétique
NORD, SUD = "#f4a3a3", "#a8dca8"# pôles d'un aimant
AXES = False# True : axes gradués (notebook) ; False : dessin seul (figures du poly)
plt.rcParams["svg.hashsalt"] = "cours-psi"# identifiants fixes : le SVG ne change que si la figure change


# ---------- Grille et géométrie ----------
def grille(xmax, ymax, h):
    """Centres des cellules carrées de côté h qui couvrent [-xmax, xmax] x [-ymax, ymax].
    Le nombre de cellules est pair dans chaque direction : aucun centre n'est sur
    les axes, et la grille est symétrique par rapport à eux."""
    nx, ny = 2*int(np.ceil(xmax/h)), 2*int(np.ceil(ymax/h))
    x = (np.arange(nx) - (nx - 1)/2)*h
    y = (np.arange(ny) - (ny - 1)/2)*h
    X, Y = np.meshgrid(x, y)# tableaux indexés [ligne selon y, colonne selon x]
    return x, y, X, Y


def dans_rectangles(X, Y, rectangles):
    """Cellules situées dans l'un des rectangles (x1, x2, y1, y2).
    Les intervalles sont semi-ouverts, [x1, x2[ : un rectangle dont les côtés
    sont des multiples du pas couvre le bon nombre de cellules même quand ses
    bords tombent sur des centres (sinon un entrefer de 5 mm en ferait 6 avec
    un pas de 1 mm). eps absorbe les erreurs d'arrondi sur ces égalités."""
    eps = 1e-9*(X[0, 1] - X[0, 0])
    masque = np.zeros(X.shape, dtype=bool)
    for x1, x2, y1, y2 in rectangles:
        masque |= (X >= x1 - eps) & (X < x2 - eps) & (Y >= y1 - eps) & (Y < y2 - eps)
    return masque


def rangee_fils(debut, fin, n, r, I):
    """n fils (x0, y0, r, I) de rayon r, régulièrement espacés du point debut au
    point fin, parcourus chacun par I selon z (I > 0 : courant vers nous)."""
    return [(x0, y0, r, I) for x0, y0 in np.linspace(debut, fin, n)]


def cadre_bobine(a, b, d, e, Ni, N_fils=10, r_fil=2e-3, L_bob=0.06, g=2e-3):
    """Circuit magnétique rectangulaire centré sur l'origine, de largeur a, de
    hauteur b et de branches de largeur d, avec un entrefer d'épaisseur e au
    milieu de la branche de droite (e = 0 : sans entrefer).
    Le bobinage entoure la branche de gauche : N_fils fils de rayon r_fil de
    chaque côté, sur une hauteur L_bob (entre les centres des fils extrêmes), à
    la distance g du fer. Le courant vient vers nous à gauche de la branche.
    Renvoie la liste des rectangles de fer et la liste des fils."""
    fer = [(-a/2, a/2, b/2 - d, b/2),# branche du haut
           (-a/2, a/2, -b/2, -b/2 + d),# branche du bas
           (-a/2, -a/2 + d, -b/2 + d, b/2 - d)]# branche de gauche
    if e > 0:
        fer += [(a/2 - d, a/2, e/2, b/2 - d), (a/2 - d, a/2, -b/2 + d, -e/2)]
    else:
        fer += [(a/2 - d, a/2, -b/2 + d, b/2 - d)]
    x_ext, x_int = -a/2 - g - r_fil, -a/2 + d + g + r_fil
    fils = (rangee_fils((x_ext, -L_bob/2), (x_ext, L_bob/2), N_fils, r_fil, Ni/N_fils)
            + rangee_fils((x_int, -L_bob/2), (x_int, L_bob/2), N_fils, r_fil, -Ni/N_fils))
    return fer, fils


def densite_courant(X, Y, fils):
    """Densité de courant J (A/m²) des fils (x0, y0, r, I). Elle tient compte de
    l'aire réelle de chaque fil sur la grille, pour que son intensité soit exacte."""
    h = X[0, 1] - X[0, 0]
    J = np.zeros(X.shape)
    for x0, y0, r, I in fils:
        dans_fil = (X - x0)**2 + (Y - y0)**2 < r**2
        J[dans_fil] = I/(dans_fil.sum()*h**2)
    return J


# ---------- Modèle 2D plan : différences finies ----------
def potentiel_plan(X, Y, mu_r, J):
    """Composante A_z (T.m) du potentiel vecteur, solution de
        div( (1/mu) grad A ) = -J
    avec A = 0 juste au-delà du bord de la grille. mu_r et J sont donnés dans
    chaque cellule."""
    h = X[0, 1] - X[0, 0]
    nu = 1/mu_r# mu0/mu
    # Chaque face entre deux cellules voisines p et q laisse passer le « flux »
    # k (A_p - A_q), où k est la moyenne harmonique de nu des deux cellules :
    # c'est ce qui assure la continuité de H tangentiel à l'interface fer/air.
    ny, nx = X.shape
    n = nx*ny
    num = np.arange(n).reshape(ny, nx)
    kx = 2*nu[:, :-1]*nu[:, 1:]/(nu[:, :-1] + nu[:, 1:])# faces verticales
    ky = 2*nu[:-1, :]*nu[1:, :]/(nu[:-1, :] + nu[1:, :])# faces horizontales
    p = np.concatenate([num[:, :-1].ravel(), num[:-1, :].ravel()])
    q = np.concatenate([num[:, 1:].ravel(), num[1:, :].ravel()])
    k = np.concatenate([kx.ravel(), ky.ravel()])
    M = sp.coo_matrix((np.concatenate([k, k, -k, -k]),
                       (np.concatenate([p, q, p, q]), np.concatenate([p, q, q, p]))),
                      shape=(n, n)).tocsr()

    # A = 0 dans une cellule fictive au-delà du bord : un terme de plus sur la diagonale
    bord = np.zeros((ny, nx))
    bord[:, 0] += 1
    bord[:, -1] += 1
    bord[0, :] += 1
    bord[-1, :] += 1
    M = M + sp.diags(bord.ravel())

    # M est symétrique : cette numérotation des inconnues accélère la résolution
    A = spla.spsolve(M.tocsc(), mu0*h**2*J.ravel(), permc_spec="MMD_AT_PLUS_A")
    return A.reshape(ny, nx)


def champ(F, x, y, revolution=False):
    """Composantes (Bx, By) du champ associé à F : B = rot(A_z ez) en 2D plan
    (F = A_z), ou B = rot(A_phi e_phi) avec F = x A_phi en symétrie de révolution
    autour de (Oy)."""
    dFdy, dFdx = np.gradient(F, y, x)
    if revolution:
        return -dFdy/x, dFdx/x
    return dFdy, -dFdx


def electroaimant(a, b, d, e, Ni, N_fils=10, r_fil=2e-3, L_bob=0.05, g=2e-3):
    """Électroaimant centré sur l'origine : une pièce en U retournée, de largeur a,
    de hauteur b et de branches de largeur d, fait face à un barreau d'épaisseur
    d, avec un entrefer d'épaisseur e sous chaque branche du U.
    Le bobinage entoure la branche horizontale du U : N_fils fils de rayon r_fil
    de chaque côté, sur une longueur L_bob (entre les centres des fils extrêmes),
    à la distance g du fer. Le courant vient vers nous au-dessus de la branche.
    Renvoie la liste des rectangles de fer, la liste des fils et l'ordonnée du
    milieu des entrefers."""
    haut = (b + e + d)/2# ordonnée du haut du U
    bas = haut - b# ordonnée du bas des branches du U
    fer = [(-a/2, a/2, haut - d, haut),# branche horizontale du U
           (-a/2, -a/2 + d, bas, haut - d),# branche gauche du U
           (a/2 - d, a/2, bas, haut - d),# branche droite du U
           (-a/2, a/2, -haut, -haut + d)]# barreau
    y_dessus, y_dessous = haut + g + r_fil, haut - d - g - r_fil
    fils = (rangee_fils((-L_bob/2, y_dessus), (L_bob/2, y_dessus), N_fils, r_fil, Ni/N_fils)
            + rangee_fils((-L_bob/2, y_dessous), (L_bob/2, y_dessous), N_fils, r_fil, -Ni/N_fils))
    return fer, fils, bas - e/2


def figure_circuit(fer, fils, mu_r, fichier=None, h=0.25e-3, marge=0.06, n_lignes=10,
                   d_fleches=4e-3, y_fleches=0.0):
    """Lignes de champ d'un circuit magnétique (rectangles de fer de perméabilité
    relative mu_r) bobiné par des fils (x0, y0, r, I), en 2D plan. La grille de
    pas h s'étend à la distance marge autour du circuit, où A = 0. On trace
    n_lignes lignes et des flèches là où elles coupent la droite y = y_fleches,
    espacées d'au moins d_fleches. Si fichier est donné, la figure est
    enregistrée en SVG à côté de lui.
    Renvoie x, y, A, Bx, By pour d'éventuelles comparaisons."""
    xs = [abs(v) for x1, x2, y1, y2 in fer for v in (x1, x2)] + [abs(x0) + r for x0, y0, r, I in fils]
    ys = [abs(v) for x1, x2, y1, y2 in fer for v in (y1, y2)] + [abs(y0) + r for x0, y0, r, I in fils]
    x, y, X, Y = grille(max(xs) + marge, max(ys) + marge, h)
    A = potentiel_plan(X, Y, np.where(dans_rectangles(X, Y, fer), mu_r, 1.0), densite_courant(X, Y, fils))
    Bx, By = champ(A, x, y)

    fig, ax = nouvelle_figure("m")
    dessine_rectangles(ax, fer)
    dessine_fils(ax, fils)
    segments = lignes_de_champ(ax, x, y, A, np.linspace(A.min(), A.max(), n_lignes + 2)[1:-1])
    fleches(ax, segments, x, y, Bx, By, d_fleches, y0=y_fleches)
    enregistre(fig, ax, segments, fichier)
    return x, y, A, Bx, By


# ---------- Symétrie de révolution autour de (Oy) : expressions analytiques ----------
def flux_spire(X, Y, R, I=1.0, y0=0.0):
    """F = x A_phi (T.m²) d'une spire de rayon R, d'axe (Oy) et de centre (0, y0),
    parcourue par I : le moment magnétique I pi R² est selon +y."""
    rho, z = abs(X), Y - y0
    D2 = (R + rho)**2 + z**2
    m = 4*R*rho/D2
    return mu0*I/(2*np.pi)*np.sqrt(D2)*((1 - m/2)*ellipk(m) - ellipe(m))


def flux_dipole(X, Y, m=1.0):
    """F = x A_phi (T.m²) d'un dipôle placé à l'origine, de moment m selon +y."""
    return mu0*m/(4*np.pi)*X**2/np.hypot(X, Y)**3


def flux_aimant(X, Y, R, L, M=1.0, n=150):
    """F = x A_phi (T.m²) d'un aimant cylindrique de rayon R et de hauteur L centré
    sur l'origine, d'aimantation uniforme M selon +y. L'aimant est équivalent à
    une nappe de courant M sur sa surface latérale, découpée ici en n spires
    (méthode d'intégration de Gauss-Legendre)."""
    z, poids = np.polynomial.legendre.leggauss(n)
    F = np.zeros(X.shape)
    for zk, pk in zip(z, poids):
        F += flux_spire(X, Y, R, M*L/2*pk, zk*L/2)
    return F


# Spire, dipôle et aimant ont le même moment magnétique m = 1 et sont tracés avec
# les mêmes niveaux, donc le même flux entre deux lignes voisines : loin des
# objets, leurs lignes de champ coïncident.
DEMI_COTE = 3.0# demi-côté de la fenêtre carrée (le rayon de la spire vaut 1)
PAS_REVOLUTION = 7.5e-3# pas de la grille de calcul
R_EQ = 12.0# la k-ième ligne du dipôle coupe le plan équatorial à la distance R_EQ/k
N_REVOLUTION = 16# nombre de niveaux


def figure_revolution(flux, dessine_objet, fichier=None, rayon_objet=0.0, d_fleches=0.3,
                       n_niveaux=N_REVOLUTION, pas=PAS_REVOLUTION):
    """Lignes de champ d'un objet de moment m = 1 selon +y, à symétrie de
    révolution autour de (Oy) : flux(X, Y) donne F = x A_phi sur une grille de
    pas pas, dessine_objet(ax) dessine l'objet. L'axe (Oy) est aussi une ligne
    de champ : on le trace, sauf à moins de rayon_objet de l'origine. Les
    flèches sont sur l'axe (Ox), espacées d'au moins d_fleches. On trace les
    n_niveaux premiers niveaux communs aux trois figures. Si fichier est donné,
    la figure est enregistrée en SVG à côté de lui."""
    x, y, X, Y = grille(DEMI_COTE, DEMI_COTE, pas)
    # F est paire en x : on ne la calcule que pour x > 0
    droite = x > 0
    F_droite = flux(X[:, droite], Y[:, droite])
    F = np.hstack([F_droite[:, ::-1], F_droite])
    Bx, By = champ(F, x, y, revolution=True)

    fig, ax = nouvelle_figure("u.a.")
    dessine_objet(ax)
    segments = lignes_de_champ(ax, x, y, F, mu0/(4*np.pi*R_EQ)*np.arange(1, n_niveaux + 1))
    if rayon_objet > 0:
        axe = [[(0, -DEMI_COTE), (0, -rayon_objet)], [(0, rayon_objet), (0, DEMI_COTE)]]
    else:
        axe = [[(0, -DEMI_COTE), (0, DEMI_COTE)]]
    segments += [trace_ligne(ax, points) for points in axe]
    fleches(ax, segments, x, y, Bx, By, d_fleches)
    enregistre(fig, ax, segments, fichier, limites=(-DEMI_COTE, DEMI_COTE, -DEMI_COTE, DEMI_COTE), marge=0)
    return fig, ax


# ---------- Tracés ----------
def nouvelle_figure(unite):
    """Figure pour les lignes de champ. Si AXES est vrai, les axes sont gradués
    (longueurs en unite) ; sinon, ils sont invisibles et occupent toute la
    surface."""
    fig = plt.figure(figsize=(LARGEUR, LARGEUR))
    if AXES:
        ax = fig.add_subplot()
        ax.set_xlabel(f"x ({unite})")
        ax.set_ylabel(f"y ({unite})")
    else:
        ax = fig.add_axes((0, 0, 1, 1))
        ax.set_axis_off()
    return fig, ax


def dessine_rectangles(ax, rectangles, couleur=GRIS, contour="none"):
    """Dessine les rectangles (x1, x2, y1, y2) comme une seule forme : pas de
    liseré entre deux rectangles accolés."""
    sommets, codes = [], []
    for x1, x2, y1, y2 in rectangles:
        sommets += [(x1, y1), (x2, y1), (x2, y2), (x1, y2), (x1, y1)]
        codes += [Chemin.MOVETO] + 3*[Chemin.LINETO] + [Chemin.CLOSEPOLY]
    ax.add_patch(PathPatch(Chemin(sommets, codes), fc=couleur, ec=contour, lw=EPAISSEUR))


def dessine_fils(ax, fils):
    """Fils (x0, y0, r, I) vus en coupe : un point si le courant vient vers nous
    (I > 0), une croix sinon."""
    for x0, y0, r, I in fils:
        ax.add_patch(Circle((x0, y0), r, fc="w", ec="k", lw=EPAISSEUR, zorder=3))
        if I > 0:
            ax.add_patch(Circle((x0, y0), r/4, fc="k", ec="none", zorder=4))
        else:
            c = r/np.sqrt(2)
            ax.plot([x0 - c, x0 + c, np.nan, x0 - c, x0 + c], [y0 - c, y0 + c, np.nan, y0 + c, y0 - c],
                    "k", lw=EPAISSEUR, zorder=4)


def dessine_dipole(ax, r):
    """Dipôle de moment selon +y : un disque blanc de rayon r, et dedans une
    flèche dans le sens du moment."""
    ax.add_patch(Circle((0, 0), r, fc="w", ec="k", lw=EPAISSEUR, zorder=3))
    ax.annotate("", xy=(0, 0.7*r), xytext=(0, -0.7*r), zorder=4,
                arrowprops=dict(arrowstyle="-|>", color="k", lw=2*EPAISSEUR,
                                mutation_scale=POINTE, shrinkA=0, shrinkB=0))


def dessine_aimant(ax, R, L):
    """Aimant de largeur 2R et de hauteur L centré sur l'origine, aimanté selon
    +y : pôle nord en haut, pôle sud en bas."""
    dessine_rectangles(ax, [(-R, R, 0, L/2)], couleur=NORD)
    dessine_rectangles(ax, [(-R, R, -L/2, 0)], couleur=SUD)
    dessine_rectangles(ax, [(-R, R, -L/2, L/2)], couleur="none", contour="k")
    for pole, y0, couleur in (("N", L/2 - 0.25, NORD), ("S", -L/2 + 0.25, SUD)):
        ax.text(0, y0, pole, ha="center", va="center", fontsize=9, fontweight="bold", zorder=3,
                bbox=dict(fc=couleur, ec="none", pad=1))


def lignes_de_champ(ax, x, y, F, niveaux):
    """Trace les lignes de niveau de F et renvoie la liste de leurs segments."""
    lignes = ax.contour(x, y, F, levels=niveaux, colors="k", linewidths=EPAISSEUR, linestyles="solid")
    return [segment for niveau in lignes.allsegs for segment in niveau]


def trace_ligne(ax, points):
    """Trace une ligne de champ connue par ses points (un axe par exemple) et
    renvoie son segment."""
    points = np.asarray(points, dtype=float)
    ax.plot(points[:, 0], points[:, 1], "k", lw=EPAISSEUR)
    return points


def fleches(ax, segments, x, y, Bx, By, d_min, x0=None, y0=0.0):
    """Flèches dans le sens de B là où les lignes coupent la droite y = y0 (ou la
    droite x = x0 si x0 est donné). On parcourt la droite et on saute les lignes
    à moins de d_min de la dernière flèche tracée."""
    coupee, le_long = (0, 1) if x0 is not None else (1, 0)
    valeur = x0 if x0 is not None else y0
    coupures = []
    for segment in segments:
        ecart = segment[:, coupee] - valeur
        for m in np.nonzero(ecart[:-1]*ecart[1:] < 0)[0]:
            t = segment[m + 1] - segment[m]
            coupures.append((segment[m] - ecart[m]/(ecart[m + 1] - ecart[m])*t, t))
    derniere = -np.inf
    longueur = 1e-3*(x[-1] - x[0])
    for point, t in sorted(coupures, key=lambda coupure: coupure[0][le_long]):
        if point[le_long] - derniere < d_min:
            continue
        derniere = point[le_long]
        i, j = np.argmin(abs(y - point[1])), np.argmin(abs(x - point[0]))
        if t[0]*Bx[i, j] + t[1]*By[i, j] < 0:
            t = -t
        # sous les fils (zorder 3) : une flèche qui tomberait dans un fil reste cachée
        ax.annotate("", xy=point + longueur*t/np.hypot(*t), xytext=point, zorder=2.5,
                    arrowprops=dict(arrowstyle="-|>", color="k", lw=EPAISSEUR, mutation_scale=POINTE))


def enregistre(fig, ax, segments, fichier=None, limites=None, marge=0.02):
    """Cadre la figure sur les lignes de champ et les objets dessinés, ou sur
    limites = (xmin, xmax, ymin, ymax), avec une marge relative. Si fichier est
    donné, l'enregistre en SVG à côté de lui, sous le même nom."""
    if limites is None:
        points = np.concatenate(segments + [p.get_path().get_extents(p.get_patch_transform()).get_points()
                                            for p in ax.patches])
        (xmin, ymin), (xmax, ymax) = points.min(axis=0), points.max(axis=0)
    else:
        xmin, xmax, ymin, ymax = limites
    dx, dy = xmax - xmin, ymax - ymin
    ax.set_xlim(xmin - marge*dx, xmax + marge*dx)
    ax.set_ylim(ymin - marge*dy, ymax + marge*dy)
    fig.set_size_inches(LARGEUR, LARGEUR*dy/dx)
    if AXES:
        ax.set_aspect("equal")
        fig.tight_layout()
    if fichier is not None:
        fig.savefig(Path(fichier).with_suffix(".svg"), metadata={"Date": None})
