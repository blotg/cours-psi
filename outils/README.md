# Outils

Production des documents du cours à partir des sources typst.
Tout ce qui est produit atterrit dans `<chapitre>/build/`, ignoré par git,
sous le nom `<type> - <titre court>.<ext>`.

Le titre court vient du champ `titre-court` de l'`infos.yml` du chapitre ; à
défaut — les TP n'en ont pas — c'est le nom du dossier privé de son préfixe de
classement (`2 - Filtre de Wien` donne `Filtre de Wien`). Le type vient en tête
pour qu'un dossier de téléchargements regroupe les documents de même nature
plutôt que ceux d'un même chapitre.

## Installation

```sh
python3 -m venv outils/.venv
outils/.venv/bin/pip install -r outils/requirements.txt
```

Les notebooks demandent en plus `pandoc` dans le PATH (paquet `pandoc-cli`
sous Arch) : sans lui, l'étape `notebooks` échoue et le reste passe.

Le hook `pre-commit` utilise ce venv s'il existe, sinon le `python3` du système.
Sans les dépendances, il se contente d'un avertissement : les PDF sont quand
même produits, seules les flashcards et la copie des DM manquent.

## Ligne de commande

Depuis la racine du dépôt :

```sh
python3 -m outils build "Cours/8 - Électrochimie"           # tout ce qui suit, en une passe
python3 -m outils flashcards "Cours/8 - Électrochimie"      # .apkg et planche .pdf
python3 -m outils manipulations "Cours/8 - Électrochimie"   # manipulations - Électrochimie.pdf
python3 -m outils diapo "Cours/8 - Électrochimie"           # diapo - Électrochimie.pdf
python3 -m outils dm "Cours/8 - Électrochimie"              # DM 1 - Électrochimie.pdf, ...
python3 -m outils imprimable "Cours/8 - Électrochimie"      # poly-imprimable - Électrochimie.pdf
python3 -m outils imprimable --quadrillage "Cours/8 - ..."  # poly-quadrillé - Électrochimie.pdf
python3 -m outils colles Colles 2026-09-29 "Cours/8 - Électrochimie"
python3 -m outils questions-de-colle                # toutes les questions de colle de l'année
python3 -m outils questions-de-colle -r             # celles des révisions de PCSI
python3 -m outils tp "TP/1 - ..." péda/élèves.csv   # ou .../TP.typ ; --numéro : défaut, le 1 du dossier
python3 -m outils tp -b "TP/1 - ..." péda/élèves.csv  # les binômes seuls, sans rien compiler
python3 -m outils qcm questions.yaml dates/
python3 -m outils site                              # site/ : le cours en HTML
python3 -m outils notebooks "Cours/8 - Électrochimie"   # notebook - <exercice>.ipynb, un par exercice numérique
python3 -m outils capytale -n "Cours/8 - Électrochimie" # ce qui partirait sur Capytale, sans rien envoyer
python3 -m outils capytale "Cours/8 - Électrochimie"    # crée ou met à jour les activités Capytale
python3 -m outils animations "Cours/Systèmes de coordonnées"            # build/animations/, par vite
python3 -m outils animations --serveur "Cours/Systèmes de coordonnées"  # serveur de développement
```

Toutes ces commandes acceptent plusieurs chapitres à la suite.

`build` est ce qu'appelle le hook : il enchaine `dm`, `flashcards`,
`manipulations`, `diapo`, `imprimable`, `notebooks` et `animations` sur un même objet `Chapitre`, donc une seule
requête `typst query` par chapitre — c'est de loin le poste le plus cher.

Un chapitre de **révision** — sous `révisions/`, rangé comme `Cours/` en thèmes
puis chapitres — n'en tire que ses **flashcards** (`ÉTAPES_RÉVISION` dans
`__main__.py`). Son cours ne porte que des flashcards et des questions de
colle : ni DM, ni manipulation, ni question de début de cours. Son poly se
réduit à la page de garde — titre, compétences, questions de colle —, grâce à
l'option `résumé: false` de `full-poly` dans son `poly.typ` : le résumé n'y
serait qu'une page de titres de sections, puisque rien de ce qu'il contient ne
s'imprime.

`flashcards` produit deux fichiers : le paquet Anki (`.apkg`) et une planche à
découper (`.pdf`), quatre cartes A6 par page A4. Les rectos d'un groupe de
quatre occupent une page et leurs versos la suivante, en miroir horizontal :
imprimée en recto-verso avec **retournement sur le bord long**, chaque carte a
bien son verso derrière son recto.

Le **recto** de chaque carte est coiffé d'un bandeau qui porte le titre court
du chapitre et le rang de la carte dans le paquet : découpée, elle dit encore
d'où elle vient. C'est le titre *court* (« Électronique 2 »), le seul qui tienne
sur une ligne de 105 mm. Le verso n'en a pas — il ne répèterait que ça, et la
réponse y gagne la hauteur — et les cases vides d'une planche incomplète restent
vierges.

Le paquet Anki reprend l'arborescence de `Cours/`, `::` séparant les niveaux
comme Anki l'attend, le thème pris sous son **nom court** :

    Cours/6 - Transformations de la matière : aspects thermodynamiques
          et cinétiques/2 - Deuxième principe…
    → Physique-Chimie PSI::6 - Thermochimie::2 - Deuxième principe…

Ce nom court vient du `titre-court` du chapitre, amputé de son rang :
« Thermochimie 2 » donne « Thermochimie ». Tous les chapitres d'un thème
portent le même préfixe, ils tombent donc bien dans le même paquet. Les
préfixes de classement des dossiers, eux, sont gardés — Anki trie ses paquets
par nom, ce sont eux qui remettent les thèmes et les chapitres dans l'ordre du
cours.

Les révisions de PCSI suivent la même règle sous `révisions/`, dans un
sous-paquet qui les tient à l'écart des thèmes de PSI :

    révisions/1 - Ondes et signaux/1 - Formation des images
    → Physique-Chimie PSI::Révisions de PCSI::1 - Signaux::1 - Formation des images

Le paquet racine se règle en tête de `chapitre.py` (`PAQUET_ANKI`, et
`PAQUET_RÉVISIONS` pour celui des révisions) ;
l'identifiant du paquet étant déduit de son nom, le renommer fait apparaitre un
**nouveau** paquet dans Anki : les anciens restent à supprimer à la main.

`diapo` produit le diaporama des questions de début de cours du chapitre :
une question par diapo, en QCM, et le corrigé sur la dernière. Les réponses
sont saisies avec **la bonne en tête** ; l'ordre d'affichage est tiré au sort
par le gabarit, de façon déterministe — le tirage ne dépend que du texte de la
question, donc une recompilation redonne le même corrigé. Un chapitre sans
question ne produit rien.

Les tirages au sort du dépôt — cet ordre-là, et la personne à qui l'on explique
dans un exercice « J'explique à… » — sont ceux de
[`suiji`](https://typst.app/universe/package/suiji). Le paquet `prepa` ne garde
que la conversion du texte en graine (`graine-du-texte`) : c'est elle qui rend
le tirage reproductible d'une compilation à l'autre.

`questions-de-colle` rassemble en un seul document **toutes** les questions de
colle de l'année : celles de tous les chapitres de `Cours/`, dans l'ordre du
tri lexicographique des dossiers, groupées par chapitre. La numérotation, elle,
est continue d'un bout à l'autre — chaque question porte un numéro qui vaut
pour l'année, là où le programme de colle hebdomadaire repart à 1 à chaque
chapitre. Un chapitre encore sans question y figure quand même, signalé comme
tel : ce qui reste à écrire se voit. Le document atterrit dans
`Cours/build/questions de colle.pdf` (`--sortie` pour en changer) ; nommer des
chapitres à la suite restreint la liste à ceux-là. `-r` (`--révisions`) fait de
même pour les chapitres de `révisions/`, dans
`révisions/build/questions de colle.pdf`.

Il n'est **pas** produit par le hook : il dépend de tous les chapitres à la
fois, qu'il inclut tous en annexe, et il en coûte deux compilations de l'année
entière (cf. [D'où viennent les données](#doù-viennent-les-données)). C'est une
commande qu'on lance quand on en a besoin.

`imprimable` produit par défaut un **fascicule A3 paysage** : deux pages A4 par
face, à imprimer en recto-verso (retournement sur le bord court) puis à plier.
`--quadrillage` donne l'autre mise en page : le poly A4 tel quel, avec une page
quadrillée en regard de chaque page de cours (pour écrire face au texte).

`tp` forme les binômes — tirage aléatoire au sein de chaque groupe, mais
reproductible : la graine est le numéro du TP —, puis compile un sujet
personnalisé par élève et les impose tous en un seul PDF à imprimer. Les
binômes sont affichés au passage ; `-b` (`--binômes`) s'arrête là, sans rien
compiler, pour les consulter (ou les projeter en début de séance) sans attendre
une compilation par élève. Le sujet n'a alors pas besoin d'exister : seuls le
CSV et le numéro comptent, ce dernier venant toujours du nom du dossier à
défaut de `--numéro`.

## Notebooks et Capytale

Chaque exercice **numérique** (`numérique: true`) que le TD inclut donne un
notebook Jupyter, `build/notebook - <fichier de l'exercice>.ipynb` :

- une cellule de texte par question, et d'autres pour le texte qui les
  entoure (introduction, transitions) ;
- chaque bloc de code Python de l'énoncé dans sa propre cellule de code ;
- ni corrigé, ni coup de pouce.

Comme les pages du site, le notebook n'est pas une réécriture : c'est
l'exercice compilé en HTML, à travers `gabarits/notebook.typ`, qui retire ce
que l'élève ne doit pas voir et marque le début et la fin des questions.
pandoc lit ce HTML, traduit le MathML de typst en LaTeX pour le MathJax 2 de
Capytale, et écrit le notebook ; `notebook.py` découpe les cellules entre les
deux et retouche ce que pandoc rend mal (virgule décimale, `\text{}` vides,
soulignés, tableaux sans en-tête, schémas en SVG passés en image `data:`).

`capytale` envoie ces notebooks sur Capytale. Une activité est créée pour un
exercice qui n'en a pas, et son code de partage écrit dans l'exercice :
`capytale: "2253-2586522"`, que `exercice()` affiche sous le titre. Un exercice
qui a déjà un code voit son activité **écrasée** — c'est par ce code qu'on la
retrouve. Seul un notebook qui a changé repart : `.capytale-manifeste.json`
note l'empreinte du dernier envoi. Le premier envoi vers une activité que ce
manifeste ne connaît pas encore (faite à la main, ou manifeste effacé)
sauvegarde d'abord son contenu dans `.capytale-sauvegardes/`.

Trois limites, qui tiennent à Capytale :

- **Pas d'API publique.** On parle à celle qu'utilise l'interface de Capytale,
  dont le client est publié (`forge.apps.education.fr/capytale/activity-js`).
  Elle peut changer sans prévenir.
- **Pas de jeton d'API.** On reprend la session ouverte dans le navigateur :
  l'en-tête Cookie de `capytale2.ac-paris.fr` dans la variable d'environnement
  `CAPYTALE_COOKIE`, ou à défaut lu dans le navigateur par `browser_cookie3`
  (dans `requirements.txt`). Session expirée : se
  reconnecter à Capytale dans le navigateur.
- **Copies figées.** Une copie qu'un élève a déjà enregistrée ne suit plus le
  modèle : une mise à jour n'atteint que ceux qui n'ont pas encore commencé.

`-n` (`--simulation`) dit ce qui serait créé ou mis à jour, sans rien envoyer
ni écrire. On peut aussi nommer des fichiers d'exercices plutôt que des
chapitres, même hors TD.

Le hook `pre-commit` envoie les notebooks des chapitres du commit si on le lui
demande (`git config hooks.capytale true`) ; un code nouvellement écrit dans
un exercice part alors dans le commit en cours, sauf si l'exercice a des
modifications non indexées — le hook le signale et laisse le `git add` à
faire. Un échec d'envoi n'annule pas le commit.

## Animations

Un chapitre peut porter un dossier `animations/` : des pages HTML animées en
three.js, que `animations` construit avec vite dans `build/animations/`. Il y
faut Node.js ; les dépendances s'installent seules à la première
construction. Seul ce qui a bougé se reconstruit (`build/animations/.empreinte`),
si bien que les deux hooks peuvent s'en charger sans compter : le pre-commit
pour les chapitres du commit — tous, si la bibliothèque commune `animations/`
a bougé —, le pre-push avant de recopier les animations dans le site. Tout le
détail, et la façon d'en écrire, dans [`animations/README.md`](../animations/README.md).

## Modules

| Module | Rôle |
|---|---|
| `typst.py` | appels à `typst compile` / `typst query`, rendu HTML des flashcards d'un cours |
| `chapitre.py` | un chapitre : ses métadonnées et les documents qu'on en tire |
| `pdf.py` | imposition de PDF (mise en fascicule A3) |
| `anki.py` | écriture d'un paquet `.apkg` |
| `programme_de_colle.py` | programme de colle hebdomadaire (en typst) |
| `questions_de_colle.py` | liste de toutes les questions de colle de l'année |
| `tp.py` | sujets de TP personnalisés par binôme, mis en fascicule |
| `qcm_cam.py` | questions au format QCMCam |
| `site.py` | site statique du cours, en HTML |
| `notebook.py` | notebook Jupyter d'un exercice numérique |
| `capytale.py` | dépôt des notebooks sur Capytale, lien dans l'exercice |
| `animations.py` | animations 3D d'un chapitre, construites par vite |

`site` produit le site statique dans `site/`, ignoré par git : une page par
exercice et par cours, plus un sommaire par chapitre. L'accueil aiguille vers
trois pages : les chapitres groupés par thème (`chapitres.html`), les TP
(`tp/`), et les révisions de PCSI (`revisions/`), groupées par thème de la même
façon. Le sommaire d'un chapitre de révision n'offre que son poly et ses
flashcards : son cours n'a rien à lire en ligne, et il n'a pas d'exercices. Les pages de contenu ne sont pas une réécriture du cours
en HTML — ce sont les mêmes sources typst, compilées avec `--format html` :
les formules deviennent du MathML, les schémas cetz/zap des SVG, et la mise en
page se refait en CSS (cf. `gabarits/site.css`, noir sur blanc comme le
papier). Le sommaire d'un chapitre offre en plus le poly et les flashcards
(planche à découper et paquet Anki) au téléchargement : ce sont les fichiers
de `build/`, donc ceux qu'`outils build` a produits — un chapitre jamais
construit est signalé et son lien omis. Un chapitre qui a des animations les
offre dans une section « Animations » de son sommaire : ses pages de
`build/animations/`, recopiées dans `<chapitre>/animations/` du site, et
d'abord reconstruites si leurs sources ont bougé.

Coups de pouce et corrigés y figurent, mais floutés : il faut tenir le survol
— ou l'appui, sur écran tactile — cinq secondes pour un coup de pouce, quinze
pour un corrigé (transition CSS, aucun script ; les délais se règlent en tête
de `site.css`). C'est le hook `pre-push` qui reconstruit tout ça, et qui publie
sur la branche `gh-pages` si on le lui demande (`git config hooks.site true`).

**On ne recompile que ce qui a bougé.** Chaque page note dans
`.site-manifeste.json` (à la racine, ignoré par git) sa recette et l'empreinte
— taille et date — de tout ce dont typst dit dépendre (`--make-deps`) : la
source, le gabarit, le paquet, les paquets typst. Une page dont rien n'a bougé
n'est pas refaite. Une reconstruction complète prend une minute ; un push qui
ne touche qu'un exercice, deux secondes. `outils site` fait par ailleurs le
ménage : une page qu'il n'a pas produite — exercice retiré du TD, chapitre
renommé — disparait de `site/`. Effacer le manifeste refait tout.

Les compilations sont **menées de front** (huit à la fois par défaut, cf.
`--processus`) : dans `outils site` page par page, dans `outils build` chapitre
par chapitre, et dans le hook `pre-commit` document par document. Elles sont
indépendantes et le gain est d'un facteur trois à cinq.

Les documents qui ne viennent pas d'une source propre au chapitre sont rendus
depuis un gabarit typst de [`gabarits/`](../gabarits) — la planche de
flashcards, la liste des manipulations, le diaporama, les questions de colle
et les pages de liens du site. Les données leur arrivent en JSON par
`--input données`. La planche de flashcards et la liste des questions de colle
n'y reçoivent pas les cartes ni les questions, mais le chemin des cours, qu'elles
incluent (cf. [D'où viennent les données](#doù-viennent-les-données)).

## Unités et nombres

Les unités et les nombres du cours sont rendus par
[`zero`](https://typst.app/universe/package/zero) ; `unify` a disparu, et avec
lui la fonction maison `scientifique()`.

Une grandeur écrite en toutes lettres suit la syntaxe de zero : `#quan[1.3 T]`,
`#quan[4.7 kΩ]`, `#quan[20 °C]`, `#quan[6.0e24 kg]`. Deux pièges :

- en mode maths, le `#` est **obligatoire** : `$quan[1 s]$` n'est pas un appel
  de fonction, et s'imprime tel quel sans la moindre erreur ;
- un `;` collé derrière (`$[#quan[20 Hz]; #quan[20 kHz]]$`) termine
  l'expression et disparait : écrire `#quan[20 Hz] ;`.

Les unités seules, les nombres et les grandeurs **calculées** gardent la syntaxe
de chaine d'unify, que `zi.declare` lit aussi : `unit("m/s")`, `num("42")`,
`qty(x, "T", chiffres: 2)`. La couche de traduction tient dans
[`prepa/0.1.1/unités.typ`](../prepa/0.1.1/unités.typ) ; elle fait trois
choses :

- **Les graphies d'unify**, dans `UNITÉS-COMPLÉMENTAIRES`, pour `unit` et
  `qty` : unify écrivait l'ohm « O » et le micro « u », zero veut le symbole et
  le préfixe « mu ». Une quinzaine de jetons, plus le degré et le degré Celsius.
  Dans `quan`, on écrit directement « Ω » et « °C » ; le micro « u » y reste
  accepté (`#quan[10 uF]`).
- **Les unités hors SI**, dans `UNITÉS-HORS-SI` (bar, tr, an, cal, kcal, Pl,
  tog, USI) : zero 0.7.0 décrit chaque unité pour les lecteurs d'écran et
  arrête la compilation sur un symbole qu'il ne connait pas — dans la langue du
  document : le poiseuille passe en français mais pas dans l'export HTML des
  flashcards. Ces unités reçoivent leur description ; `quan`, qui n'en accepte
  pas, passe alors par `zi.declare`.
- **Les chiffres significatifs**, que zero ne sait pas bien arrondir.

Les chiffres significatifs se demandent à l'appel : `qty(x, "T", chiffres: 2)`
au lieu de `qty(scientifique(x, 2), "T")`. `quan` ne convient pas ici : il ne
prend qu'un texte, sans arrondi. La valeur est arrondie avant d'être passée à
zero, qui la met seul en notation scientifique (à partir de l'exposant 1 —
« 3,14 » ne devient pas « 3,14·10⁰ »). Cet arrondi préalable n'est pas un reste
de l'ancienne fonction : zero fixe l'exposant sur son entrée et ne renormalise
pas la mantisse quand l'arrondi la porte à 10, si bien que 9,96·10⁵ à deux
chiffres sortait « 10,0·10⁵ ». C'est toujours le cas avec zero 0.7.0 (0,999 à
deux chiffres : « 10·10⁻¹ »). Le même `qty` passe en chaine les flottants de
10¹⁵ et plus, sur lesquels la description de zero 0.7.0 déborde.

Trois différences de rendu par rapport à unify, toutes voulues :

- Les nombres de cinq chiffres et plus sont **groupés** : « 96 500 » et non
  « 96500 ». C'est le défaut de zero, et l'usage français.
- « 1500 tr/min » et « 8,9 an » **sortent enfin** : malgré ses `add-unit`,
  unify perdait le tour et l'année en silence. Les trois `add-unit` qui
  trainaient dans le cours (`USI`, `tog`, `cal`) ont pu disparaitre.
- Le signe de multiplication reste le point d'unify (`set-num(product:
  sym.dot.op)` dans `init-document`), et non la croix de zero.

## D'où viennent les données

Le paquet typst `@local/prepa` émet des `metadata` que les outils relisent avec
`typst query` — sauf les flashcards et les questions de colle, qui se lisent en
incluant le cours (cf. plus bas) :

| Étiquette | Source interrogée | Utilisée par |
|---|---|---|
| `<flashcard>` | `cours.typ`, inclus (la requête ne fait que compter les cartes) | `flashcards` |
| `<question-de-colle>` | `cours.typ`, inclus | `colles`, `questions-de-colle` |
| `<question-de-début-de-cours>` | `cours.typ` | `diapo` |
| `<coups-de-pouce>` | `TD.typ` | `Chapitre.coups_de_pouce` |
| `<manipulation>` | `cours.typ` | `manipulations` |
| `titre-court` (infos.yml) | — | nom des documents produits, bandeau des flashcards |
| `DM` (infos.yml) | — | `dm` |
| `<première-page-cours>`, `<dernière-page-cours>`, `<première-page>`, `<dernière-page>` | `poly.typ` | `imprimable` |

On interroge toujours le document le moins cher qui contient l'information :
compiler le poly coute bien plus que le seul cours.

Les flashcards et les questions de colle s'écrivent en **blocs de contenu** —
`#flashcard(recto: [...], verso: [...])`, `#question-de-colle[...]` —, la forme
en chaine d'avant restant acceptée. Leurs métadonnées portent donc du content,
que `typst query` sérialise avec perte : une formule `pdv(f, t)` n'y est plus
qu'un `context` vide. Les documents qui les rendent incluent donc le cours dans
leur propre compilation, et les lisent sur place :

- la planche de flashcards, la liste des questions de colle et le programme de
  colle incluent les cours **en annexe**, à leur suite, avec `cours-en-annexe`
  et `par-cours` (`prepa/0.1.1/meta.typ`), puis ne gardent que leurs propres
  pages (`typst compile --pages`). La planche sait combien elle en compte ;
  les deux listes de colles le lisent d'abord dans le repère
  `<fin-du-document>`, au prix d'une seconde compilation
  (`typst.compile_avec_annexe`) ;
- le paquet Anki inclut le cours en HTML, et découpe ses cartes dans la page
  produite (`typst.cartes_html`).

Ces compilations prennent `--root` à la racine du dépôt, où les cours
s'incluent, et `--input inclus=1`, qui dit au cours de ne pas mettre la page en
place. Le programme de colle, écrit hors du dépôt, prend la racine commune et
rappelle en tête de son `programme.typ` comment le recompiler.

Pourquoi une annexe plutôt qu'une boîte masquée, qui s'épargnerait ces pages :
les notes de bas de page des cours s'échappaient de la boîte et remontaient au
pied de la page hôte, et les y retirer faisait perdre à la liste des colles
trente-cinq questions.

Le prix de `--pages` : typst n'écrit alors ni signets ni balisage
d'accessibilité dans le PDF. La liste des questions de colle et le programme de
colle n'ont donc plus de signet par chapitre.
