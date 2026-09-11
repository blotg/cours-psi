#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: cours.with(infos: infos)


= Cinématique du solide

#flashcard(
    recto: "Solide en rotation autour d'un axe fixe",
    verso: "Chaque point décrit un cercle centré sur l'axe ; sa vitesse vaut $v = r omega$, où $r$ est la distance à l'axe en #unit(\"m\") et $omega$ la vitesse angulaire en #unit(\"rad/s\").",
)
#flashcard(
    recto: "Liaison pivot idéale",
    verso: "Une liaison pivot idéale exerce un moment par rapport à l'axe la traversant nul. Elle bloque tout autre mouvement (translations et rotations autour d'autres axes).",
)
#flashcard(
    recto: "Définition d'un couple",
    verso: "Un couple est un ensemble de forces de résultante nulle mais de moment non nul.",
)
#flashcard(
    recto: "Définition d'une translation rectiligne",
    verso: "Une translation est un mouvement où tous les points du solide décrivent des droites parallèles.",
)
#flashcard(
    recto: "Définition d'une translation circulaire",
    verso: "Une translation circulaire est un mouvement où tous les points du solide décrivent des cercles de même rayon. Pour deux points $A$ et $B$ du solide, la droite $A B$ reste parallèle à elle-même au cours du mouvement.",
)

= Dynamique du solide en rotation

#flashcard(
    recto: "Moment cinétique d'un solide en rotation",
    verso: "$ L_Delta = J_Delta omega $, où $J_Delta$ est le moment d'inertie par rapport à l'axe, en #unit(\"kgm^2\").",
)
#flashcard(
    recto: "Énergie cinétique d'un solide en rotation autour de l'axe $Delta$",
    verso: "$E_c = 1/2 J_Delta omega^2$.",
)

// #question-de-colle(
//     "Donner l'expression du moment cinétique d'un solide en rotation autour d'un axe fixe, celle du moment d'une force par rapport à cet axe, puis énoncer le théorème du moment cinétique scalaire.",
// )
#question-de-colle(
    "Établir l'équation du mouvement d'un pendule pesant à l'aide du théorème du moment cinétique scalaire, puis la retrouver par le théorème de l'énergie cinétique.",
)
#question-de-colle(
    "Établir l'équation du mouvement d'un pendule de torsion. En déduire une intégrale première du mouvement.",
)
