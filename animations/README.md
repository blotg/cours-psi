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
indique son adresse en démarrant, et sert à la racine le sommaire des
animations du chapitre (un dossier `animations/` n'a pas d'`index.html`).

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
| `scene.js` | `Scène` : rendu WebGL, étiquettes, caméra à la souris ou au doigt, poignées que l'on déplace dans l'espace |
| `objets.js` | ce qui se dessine dans l'espace : `Étiquette` (LaTeX), `Flèche`, `Trait`, `Arc`, `repère`, `quadrillage`, la palette `COULEURS` |
| `plan.js` | `Plan` : la même chose à deux dimensions — un canevas aux coordonnées du problème, des étiquettes, des poignées que l'on déplace ; et de quoi dessiner (`chemin`, `disque`, `flèche`, `pointe`, `aplat`) |
| `graphe.js` | `Graphe` : un graphique en SVG — axes, graduations mobiles, courbes, spectres en raies ou en aires, zones, cotes |
| `carte.js` | la carte d'un champ scalaire : ses valeurs sur une grille, ses lignes de niveau par carrés marchants, l'écart rond entre deux niveaux |
| `reglages.js` | `Réglages` : curseurs (avec leurs aimants), cases, choix et formules, nommés en LaTeX |
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
- **Des phases en progression arithmétique ne font pas un signal
  quelconque** : ajouter le même écart de phase d'une composante à la
  suivante ne fait que décaler la somme dans le temps. Les composantes
  restent en phase au même instant et leur somme est une impulsion bien
  lisse. Il faut un vrai tirage pseudo-aléatoire, de graine fixe pour que le
  signal ne change pas d'un chargement à l'autre (`modulation.js`).
- **Une matrice qui retourne l'espace efface les traits épais** : un `Trait`
  est un ruban tourné vers l'œil, et un ruban a un endroit ; sous la symétrie
  par un plan (déterminant négatif), il était présenté par l'envers et le
  rendu l'écartait. D'où `side: DoubleSide` dans `LineMaterial` — un trait
  n'a pas d'envers. Les `Mesh`, eux, n'en souffraient pas.
- **Les contrôles de la caméra attrapent le pointeur les premiers** :
  `OrbitControls` écoute sur le canevas. Les poignées de `Scène` écoutent
  donc sur le cadre, **en capture**, et arrêtent l'événement avant qu'il
  n'atteigne le canevas quand le pointeur en tient une.
- `THREE.Clock` est déprécié : `Scène` emploie `THREE.Timer`, qu'il faut
  mettre à jour (`update()`) à chaque image.

## Les animations du cours

**Électronique 5** — `modulation.js` montre les trois modulations sur les
mêmes signaux (seul change, en couleur dans la formule, le paramètre de la
porteuse qui varie), puis le signal modulé en amplitude avec son enveloppe et
son spectre, puis les quatre spectres de la chaîne de démodulation synchrone.

La modulation de fréquence s'écrit avec la **primitive** du signal, et non
avec le produit f(t)·t du cours : la fréquence instantanée est la dérivée de
la phase, et la formule abrégée ferait sauter la phase à chaque alternance
d'un créneau. Une note le dit dans le panneau, sous la formule du cours.

Le temps se compte en périodes de porteuse : l'écran en garde toujours trente,
de sorte que le curseur f_s ne fasse varier que la période du signal à
transmettre — une cote la mesure sur le tracé. Sur le signal modulé, la
**modulante** 1 + k s(t) est tracée en bleu de part et d'autre, et
l'**enveloppe** |1 + k s(t)| par-dessus, en pointillés rouges : les deux se
confondent jusqu'à h = 1, au-delà la modulante passe sous zéro et l'enveloppe
la reflète. L'enveloppe n'est tracée qu'en haut — ±|A| et ±A sont le même
couple de courbes, les tracer toutes les deux ne montrerait jamais rien.

Le signal à transmettre est au choix sinusoïdal (deux raies latérales) ou
quelconque : on se donne son spectre, une bande continue, et le signal en est
la somme des composantes — une transformée de Fourier inverse. Son tracé
temporel est normalisé sur la fenêtre affichée, pour que l'enveloppe touche
zéro exactement à h = 1 ; la hauteur de sa bande est celle qu'aurait une raie,
comme dans le poly — une densité spectrale ne se compte pas en volts, et les
amplitudes des composantes d'une bande dense sont bien plus petites que cela.
Le profil de la bande est volontairement **dissymétrique** (deux bosses
inégales) : on voit ainsi, sur le spectre du signal modulé, que la bande du
bas est renversée et celle du haut non, et on suit chacune le long de la
chaîne de démodulation.

À la démodulation, un curseur déplace aussi la porteuse : rapprocher f_p de
f_s fait se chevaucher ce que les filtres doivent séparer. Les filtres sont du
premier ordre, leur gain est tracé par-dessus le spectre qu'ils reçoivent, et
le panneau dit ce qui ressort du signal utile et ce qui reste des raies autour
de 2 f_p.

**Électromagnétisme 1** — deux pages, dont une s'appuie sur `champ.js` : la
physique d'un jeu de charges dans le plan de l'écran, sous deux lois au choix.
Des charges **ponctuelles** (`PONCTUELLES`), celles du cours, comptées en
nanocoulombs et placées à quelques centimètres : le champ sort alors en volts
par mètre et le potentiel en volts, que la carte affiche tels quels sous une
règle de 5 cm. Ou des **fils** infinis perpendiculaires à l'écran (`FILS`),
que l'on juxtapose pour faire une plaque vue par la tranche — c'est le
condensateur plan, et rien d'autre ne donnerait un champ uniforme entre deux
armatures.

`cartes-de-champ.js` (vues planes) trace les lignes de champ — une par part
égale de charge, d'où « une charge double en émet deux fois plus » —, les
équipotentielles par carrés marchants, toujours du même écart de potentiel
(c'est leur resserrement qui dit le champ), et un dégradé peint sur la grille
du potentiel. Le condensateur plan est fait de fils, ce qui donne ses effets
de bord.

Deux écueils, qui ont chacun leur remède dans `champ.js` :

- **Une ligne coupée au bord du cadre part sans jamais revenir.** Entre deux
  charges opposées, celle qui s'élance à l'opposé de sa partenaire s'éloigne
  de cent fois la vue avant de revenir s'y poser — plus de six mètres pour
  deux charges de 3 nC distantes de 5 cm. Hors de la vue, le pas grandit donc
  avec la distance : la ligne y va et en revient en quelques centaines de pas,
  et ce qu'elle fait là-bas ne se voit pas. Une ligne qui s'échappe pour de
  bon s'arrête dès que la charge totale, seule chose qui compte de si loin,
  la pousse vers le dehors.
- **Le potentiel d'une charge ponctuelle varie en 1/r.** À écart fixé, les
  équipotentielles se tassent en un pâté autour des charges, ou désertent la
  carte quand la charge est faible. L'écart suit donc la plus forte des
  charges (une valeur ronde, 1, 2 ou 5 fois une puissance de dix), et le
  panneau l'annonce : c'est lui l'échelle du potentiel.

`symetries.js` (scènes 3D) porte les deux gestes du chapitre, sur les mêmes
six distributions (charge, boule, fil, plan, spire, deux charges opposées) et
les mêmes trois systèmes de coordonnées.

**Invariances** : chaque curseur applique à la distribution la transformation
qui fait varier une coordonnée — la translation selon x, la rotation autour
de (Oz)… Les coordonnées qui ne correspondent à aucune isométrie (r) n'ont
pas de curseur : hors des cartésiennes, il n'y en a donc que deux. La
position de départ reste en fil de fer, le geste lui-même est dessiné (une
flèche, un arc), et le panneau écrit ce qu'on en déduit : les invariances
trouvées, puis les variables dont le champ dépend encore, `E(M) = E(r)`.

**Plans de symétrie** : un point M que l'on déplace à la main (poignée de
`Scène`), sa base locale, et les trois plans passant par M que dirigent ses
vecteurs de base. Le plan choisi s'affiche et le symétrique de la
distribution est tracé par-dessus. Le panneau donne la nature des trois
plans, puis les composantes qui survivent — le champ est contenu dans tout
plan de symétrie passant par M, et perpendiculaire à tout plan
d'antisymétrie. La scène ne dessine pas le champ : c'est au lecteur de
conclure, et une flèche donnerait d'ailleurs un sens que la symétrie ne
donne pas.

Trois partis pris, sans lesquels rien ne se verrait :

- **Aucun bord ne doit bouger quand la distribution ne bouge pas.** Le fil
  est dessiné bien au-delà de la vue ; le plan, qui ne saurait en sortir de
  tous les côtés, est posé autour de **son point le plus proche de l'origine**
  et s'efface vers le bord. Ce point et cette normale ne dépendent que du
  plan : le glisser le long de lui-même ou le tourner autour de sa normale ne
  déplace alors pas un pixel — ce qui est exactement ce qu'une invariance
  doit donner à voir.
- **Une image posée sur son original doit se voir**, sans changer de couleur —
  c'est la couleur qui dit le signe de la charge. Elle est donc en fil de fer,
  de la même couleur en plus sombre, et rien ne la cache (`depthTest: false`).
  Sa carcasse est plus large que ce qu'elle recouvre et à peine maillée : une
  carcasse serrée ferait une boule pleine, et cacherait la couleur d'en
  dessous.
- **Les positions remarquables s'atteignent exactement.** Une symétrie se
  calcule, sur les formes qui décrivent la distribution (un point, une
  droite, un plan, une sphère, un cercle) ; à un millième près, ce n'en est
  plus une. La main n'y arriverait jamais : M se pose donc de lui-même sur
  l'axe (Oz) et dans le plan (O x y), qui sont le plan médiateur des deux
  charges, celui de la spire et le plan chargé.

**Analyse vectorielle** — `operateurs.js` applique les opérateurs à des
champs plans (`champs.js`) : le gradient et le laplacien à un champ scalaire,
peint en dégradé d'une seule teinte, la divergence, le rotationnel et le
laplacien vectoriel à un champ de flèches. On déplace un point M, et
l'opérateur y est dessiné selon ce qu'il rend : un disque marqué de son signe
pour un scalaire — rouge et +, comme une charge positive, car une divergence
positive est une source —, une flèche pour un vecteur du plan, ⊙ ou ⊗ pour le
rotationnel, seul vecteur qui sorte de l'écran. La case « dans tout le plan »
répète ce dessin sur une grille.

Les champs sont choisis pour ce qu'ils démentent : une source radiale partout,
mais de divergence nulle hors des charges (le champ électrique d'un cylindre
chargé) ; un tourbillon dont le rotationnel n'est non nul qu'au cœur (le champ
magnétique d'un fil épais) ; un cisaillement aux lignes droites qui fait
pourtant tourner la roue à aubes ; un col, courbé dans les deux sens, de
laplacien nul. Les deux tubes ont un profil gaussien plutôt qu'une densité
uniforme, qui ferait une arête à leur bord, où le laplacien vectoriel serait
infini.

Le contour autour de M fait le lien avec les théorèmes du chapitre : sur un
cercle de rayon ρ, la composante normale (un flux) ou tangentielle (une
circulation), et le rapport Φ/V ou C/S, qui tend vers l'opérateur quand ρ tend
vers zéro — Ostrogradski et Stokes sur un cylindre d'axe (Mz). Ses flèches se
mesurent à la plus longue d'entre elles, non au champ sur toute la carte :
elles montrent l'équilibre d'un côté du cercle à l'autre, qui doit se lire
même là où le champ est faible. Le laplacien vectoriel se décompose, sur
demande, en grad(div A) et −rot(rot A), tracés en M avec leur parallélogramme.

Tous les opérateurs se calculent par différences finies, sur n'importe quel
champ : en ajouter un ne demande que sa formule. Ils ne s'annulent donc jamais
tout à fait, et le seuil en deçà duquel ils sont nuls (`SEUIL`) se prend sur
**l'échelle du champ**, jamais sur celle de l'opérateur : la divergence d'un
tourbillon n'est que du bruit, et, rapportée à son propre maximum — du bruit
lui aussi —, elle couvrait la carte de disques.

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
