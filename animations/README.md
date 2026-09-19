# Animations

Les animations 3D du cours, écrites en JavaScript avec
[three.js](https://threejs.org) et construites par [vite](https://vite.dev).
Sur le site, le sommaire d'un chapitre les propose dans une section
« Animations ».

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
| `objets.js` | ce qui se dessine : `Étiquette` (LaTeX), `Flèche`, `Trait`, `Arc`, `repère`, `quadrillage`, la palette `COULEURS` |
| `reglages.js` | `Réglages` : curseurs, cases, choix et formules, nommés en LaTeX |
| `vite.config.js` | la construction d'un chapitre, l'habillage des pages |

Quelques partis pris :

- **Rendu à la demande.** Une `Scène` ne redessine que si la caméra a bougé,
  si l'on a appelé `redessine()` après un réglage, ou si elle est animée
  (`àChaqueImage(dt => …)`). Hors de l'écran, elle s'arrête ; et `lance` ne
  crée une scène qu'à l'approche de l'écran : un téléphone limite le nombre de
  contextes WebGL ouverts.
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
- **Rien ne cache une étiquette** : c'est du HTML posé sur l'image. Celle qui
  nomme un dessin posé sur une face prend l'option `face` (la normale de la
  face) et s'efface quand on la regarde de dos.
- `THREE.Clock` est déprécié : `Scène` emploie `THREE.Timer`, qu'il faut
  mettre à jour (`update()`) à chaque image.

## Les animations du cours

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
conventions sont celles du cours : l'enroulement 1 d'axe θ = 0, l'enroulement
2 d'axe θ = −90°, parcourus par i₁ = I cos(ωt) et i₂ = I cos(ωt + π/2), ce qui
donne le champ glissant B_s ∝ cos(ωt − θ) ; le rotor à θ_r = Ωt − α, son champ
B_r ∝ cos(θ − θ_r), et le couple Γ = Γ_max sin(ωt − θ_r). Le rotor est lisse,
comme le veut l'hypothèse d'un entrefer constant.
