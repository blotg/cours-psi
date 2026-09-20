# Animations

Les animations du cours, écrites en JavaScript et construites par
[vite](https://vite.dev). Sur le site, le sommaire d'un chapitre les propose
dans une section « Animations ».

Trois façons de dessiner, selon ce que le chapitre demande :

- une **scène en trois dimensions** ([three.js](https://threejs.org)), pour ce
  qui ne se comprend que dans l'espace — un élément de volume, une machine,
  un plan de symétrie ;
- une **vue plane** (un canevas), pour une carte de champ, un écoulement, un
  schéma que l'on manipule ;
- des **graphiques** (SVG), pour les chronogrammes, les spectres et les
  cycles, dans le panneau de réglages comme à la place d'une scène.

Les trois se ressemblent à dessein : même façon de se construire une fois
pour toutes puis de tout replacer à chaque réglage, mêmes couleurs, mêmes
étiquettes en LaTeX.

## Où elles vivent

- **Dans les chapitres** : le dossier `animations/` d'un chapitre, à côté de
  son `cours.typ`. Chaque page HTML y est une animation, et un lien du
  sommaire : son `<title>` en donne l'intitulé, sa
  `<meta name="description">` la mention grise en regard — à garder courte,
  « point, volume, surfaces ». Les liens suivent l'ordre des noms de fichiers.
- **Ici, à la racine** : la bibliothèque commune, la mise en page et la
  configuration de vite. Les chapitres l'importent par `#animations/…`, que le
  champ `imports` du `package.json` de la racine fait pointer ici.

Les dépendances (vite, three.js, KaTeX) sont figées par le
`package-lock.json` de la racine ; `node_modules/` est ignoré par git.

## Construire

```sh
python3 -m outils animations "Cours/Systèmes de coordonnées"            # → build/animations/
python3 -m outils animations --forcer "Cours/Systèmes de coordonnées"   # même si rien n'a bougé
python3 -m outils animations --serveur "Cours/Systèmes de coordonnées"  # serveur de développement
```

Il faut [Node.js](https://nodejs.org) 20.19 ou plus (celui de vite 8), `node`
et `npm` dans le PATH. La première construction installe les dépendances
(`npm ci`), et les réinstalle quand le verrou change.

Le **serveur de développement** recharge la page à chaque enregistrement ; il
indique son adresse en démarrant.

On ne reconstruit que ce qui a bougé : `build/animations/.empreinte` garde le
condensé de tout ce dont la construction dépend — les sources du chapitre,
cette bibliothèque, le verrou npm, la feuille du site, le fil d'Ariane. C'est
ce qui permet aux deux hooks de s'en charger sans rien coûter quand rien n'a
changé :

- **pre-commit** : `outils build` construit les animations des chapitres du
  commit, et `outils animations` celles des chapitres dont seules les
  animations ont bougé — toutes, si le commit touche cette bibliothèque, le
  verrou npm ou `gabarits/site.css`. Un échec n'annule pas le commit.
- **pre-push** : `outils site` reconstruit ce qui n'est plus à jour avant de
  recopier `build/animations/` dans le site. Sans Node.js, il publie la
  dernière construction que garde `build/` et le signale, plutôt que de
  retirer du site des animations qui y sont déjà.

## Écrire une page

```html
<!doctype html>
<html lang="fr">
<head>
<meta charset="utf-8">
<title>Machine synchrone</title>
<meta name="description" content="champ glissant, couple">
<script type="module" src="./machine-synchrone.js"></script>
</head>
<body>
<h1>Machine synchrone</h1>
<section class="animation">
<h2>Champ glissant et champ rotorique</h2>
<p>Un paragraphe d'introduction, facultatif.</p>
</section>
</body>
</html>
```

La page n'écrit que son titre et son contenu. `vite.config.js` lui ajoute le
fil d'Ariane et le pied de page du site ; la mise en page vient de
`#animations/page.js`, qu'importe son script :

```js
import { cadre, lance } from '#animations/page.js';
import { Réglages } from '#animations/reglages.js';
import { Scène } from '#animations/scene.js';

lance('section.animation', (section) => {
    const { vue, réglages } = cadre(section); // la scène, et ses réglages à côté
    const scène = new Scène(vue, { position: [10, 4, 5] });
    const panneau = new Réglages(réglages);
    // …
});
```

Le titre et la description sont lus aussi par le site, qui les **évalue en
markup typst** dans le sommaire : ni `_`, ni `*`, ni `#`, ni `$`.

## La bibliothèque

| Module | Rôle |
|---|---|
| `page.js`, `page.css` | la mise en page : celle du site (`gabarits/site.css`), élargie ; `cadre` et `lance` |
| `scene.js` | `Scène` : rendu WebGL, étiquettes, caméra à la souris ou au doigt |
| `objets.js` | ce qui se dessine dans l'espace : `Étiquette` (LaTeX), `Flèche`, `Trait`, `Arc`, `repère`, `quadrillage`, la palette `COULEURS` |
| `plan.js` | `Plan` : la même chose à deux dimensions — un canevas aux coordonnées du problème, des étiquettes, des poignées que l'on déplace ; et de quoi dessiner (`chemin`, `disque`, `flèche`, `pointe`, `aplat`) |
| `graphe.js` | `Graphe` : un graphique en SVG — axes, graduations mobiles, courbes, spectres, zones, cotes |
| `reglages.js` | `Réglages` : curseurs, cases, choix et formules, nommés en LaTeX |
| `vite.config.js` | la construction d'un chapitre, l'habillage des pages |

`Plan` reprend les partis pris de `Scène` : rendu à la demande, rien hors de
l'écran, tout se replace. Une animation plane n'a pas besoin de WebGL, et
tient donc sur les machines qui ne l'ont pas.

Un `Graphe` se construit avec ses deux axes, puis distribue des tracés à
replacer :

```js
const spectre = new Graphe({
    x: { min: 0, max: 2.4, nom: 'f', graduations: [0, [1, 'f_p']] },
    y: { min: 0, max: 1.25, graduations: [[1, 'A_p']] },
    grand: true,          // dans une vue plutôt que dans le panneau
});
const raies = spectre.raies({ couleur: COULEURS.vermillon });
raies.place([[1, 1], [1 - fs, h / 2], [1 + fs, h / 2]]);   // à chaque réglage
spectre.grilleX.place([0, [fs, 'f_s'], [1, 'f_p']]);       // même les graduations
```

Quelques partis pris :

- **Rendu à la demande.** Une `Scène` ne redessine que si la caméra a bougé,
  si l'on a appelé `redessine()` après un réglage, ou si elle est animée
  (`àChaqueImage(dt => …)`). Hors de l'écran, elle ne dessine plus ; une
  scène animée continue pourtant de tourner tant que son cadre — la scène et
  son panneau — est à l'écran : sur un téléphone, les courbes sont sous la
  scène, et doivent suivre quand on y descend. `lance` ne crée une scène qu'à
  l'approche de l'écran : un téléphone limite le nombre de contextes WebGL
  ouverts.
- **Des couleurs de schéma.** La palette d'Okabe et Ito, lisible par les
  daltoniens. Les tracés (flèches, traits, points) échappent au rendu
  photographique qu'une scène peut choisir pour ses objets réalistes
  (`toneMapped: false`) : leur couleur reste franche.
- **Tout se replace, rien ne se recrée.** `Flèche.place`, `Trait.trace`,
  `Arc.place`, `Étiquette.place` se rappellent à chaque réglage.

## Pièges rencontrés

- **La feuille du site efface les flèches de KaTeX** : `\vec` est un SVG, et
  `svg { max-width: 100% }` le rapporte à un bloc de largeur nulle. D'où
  `.katex svg { max-width: none; margin: 0 }` dans `page.css`.
- **`LineGeometry.setPositions` fuit** : chaque appel crée de nouveaux tampons
  dans la carte graphique sans libérer les anciens. `Trait.trace` écrit dans
  les siens.
- **Le `CSS2DRenderer` place une étiquette avant d'appeler son
  `onBeforeRender`** : la déplacer là ne prend effet qu'à l'image suivante.
  `Étiquette.àCôté` la décale donc à l'écran, par un `translate` CSS.
- **Un graphique ne prend pas de remplissage** : ses légendes sont du HTML
  placé en proportion de sa taille, et un `padding` les décalerait par rapport
  au dessin. On l'espace par des marges (cf. `.vue > .graphique`).
- **Rien ne cache une étiquette** : c'est du HTML posé sur l'image. Celle qui
  nomme un dessin posé sur une face prend l'option `face` (la normale de la
  face) et s'efface quand on la regarde de dos.
- **`hidden` ne cache pas un contrôle du panneau** : ses règles lui donnent
  un `display` qui l'emporte sur celui de l'attribut. `page.css` le rétablit
  (`.panneau [hidden]`).
- `THREE.Clock` est déprécié : `Scène` emploie `THREE.Timer`, qu'il faut
  mettre à jour (`update()`) à chaque image.

## Les animations du cours

**Électronique 5** — `modulation.js` montre les trois modulations sur les
mêmes signaux (seul change, en couleur dans la formule, le paramètre de la
porteuse qui varie), puis le signal modulé en amplitude avec son enveloppe et
son spectre — dont les graduations suivent f_s —, puis les quatre spectres de
la chaîne de démodulation synchrone. Les filtres sont du premier ordre, leur
gain est tracé par-dessus le spectre qu'ils reçoivent, et le panneau dit ce
qui ressort du signal utile et ce qui reste des raies autour de 2 f_p.

**Électromagnétisme 1** — deux pages, qui partagent `champ.js` : la physique
d'un jeu de charges vues comme des fils rectilignes infinis, pour que le plan
de l'écran soit un plan de coupe où tout est exact — le champ d'un fil
décroît en 1/r, et le flux se conserve dans le plan.

`cartes-de-champ.js` (vues planes) trace les lignes de champ — une par part
égale de flux, d'où « une charge double en émet deux fois plus » —, les
équipotentielles par carrés marchants, toujours du même écart de potentiel
(c'est leur resserrement qui dit le champ), et un dégradé peint sur la grille
du potentiel. Le tube de champ s'appuie sur deux lignes ; le flux à travers
chacune de ses deux sections est *calculé*, non supposé, et on le retrouve le
même. Le condensateur plan est fait de fils, ce qui donne ses effets de bord.

`symetries.js` (scènes 3D) travaille les obstacles de la vision dans
l'espace, et sa tête de fichier dit lesquels : le plan y est une surface
quadrillée et non un trait, des boutons ramènent à des vues toutes faites
sans avoir à tourner la scène, la symétrie se joue (un fantôme glisse de M
jusqu'à M′), le vecteur se décompose en part parallèle et part normale, et le
cas limite — M dans le plan — s'atteint au curseur, où la conclusion s'écrit.
On regarde toujours la distribution avant le champ : l'image de chaque charge
est dessinée en fil de fer, et c'est elle qui décide si le plan est de
symétrie, d'antisymétrie, ou ni l'un ni l'autre.

**Systèmes de coordonnées** — `systemes.js` décrit les trois systèmes par des
données : coordonnées et bornes, position, base locale, longueurs des arêtes,
formules des éléments de surface et de volume, construction du point.
`coordonnees.js` en tire trois animations, les mêmes pour tous : `point`,
`volume` et `surface` (un élément par coordonnée tenue constante). Chaque
coordonnée a sa couleur, celle de son curseur, de son vecteur de base et des
arêtes le long desquelles elle varie. Les cotes des arêtes (r dθ…) se placent
à chaque image sur une arête du contour où la formule est exacte : r dθ sur
l'arc de rayon r, pas sur celui de rayon r + dr.

**Conversion 3** — `machine.js` dessine la machine synchrone diphasée et
bipolaire, coupée en son milieu ; `machine-synchrone.js` la fait tourner. Les
conventions sont celles du cours : le circuit statorique 1 d'axe θ = 0, le
circuit 2 d'axe θ = −90°, parcourus par i₁ = I cos(ωt) et i₂ = I cos(ωt + π/2) ;
le rotor tourne toujours au synchronisme, θ_r = ωt − α. Il est lisse, comme le
veut l'hypothèse d'un entrefer constant.

Chaque circuit a N spires (curseur, 5 au départ), logées dans N encoches de
part et d'autre de son axe. Les champs ne sont pas supposés sinusoïdaux : ils
se calculent à partir des conducteurs, par le théorème d'Ampère — le champ
saute d'un cran à chaque conducteur et reste de moyenne nulle —, et sont donc
en marches. Les spires sont placées pour que ces marches soient égales et
épousent un cosinus (cos φ_k = 1 − (2k + 1)/N) : pour N = 1, c'est la spire
unique du cours et son champ en créneau ; quand N → ∞, on retrouve le champ
glissant B_s ∝ cos(ωt − θ) et B_r ∝ cos(θ − θ_r), que la case « Limite
sinusoïdale » trace en pointillés. Le couple affiché reste celui du cours,
Γ_max sin α : avec des champs en marches, il ondule autour d'une moyenne
proportionnelle à sin α.

À leur place exacte, des conducteurs des deux circuits statoriques
tomberaient presque les uns sur les autres (à 0,2° pour N = 17), et la
largeur des encoches, réglée sur les deux plus proches, sautait d'un N à
l'autre. On garde leur ordre autour de l'alésage, mais on les espace selon
leur densité moyenne, N/2 (|sin θ| + |cos θ|) par radian : deux encoches
voisines sont toujours à √2/N radian au moins, la largeur ne dépend plus que
de N, et aucun conducteur ne bouge de plus d'un écart entre encoches — les
champs tendent toujours vers la sinusoïde. Les fils des têtes de bobines ont
un diamètre en 1/N.

Le panneau trace aussi B_s et B_r en fonction de θ, avec des amplitudes
différentes (B_r vaut 0,6 B_s) : rien ne les lie, B_s suit I, B_r suit I_e.

Chaque circuit a sa couleur, celle de ses fils et de son courant : vert pour
le circuit 1, bleu pour le 2, rouge pour le rotor ; les champs, violet (B_s)
et orange (B_r). La caméra est orthographique, de face au départ.
