"""Animations 3D d'un chapitre : les pages de son dossier `animations/`.

Chaque page HTML de `<chapitre>/animations/` est une animation, écrite en
JavaScript avec three.js. vite les construit en pages autonomes dans
`<chapitre>/build/animations/`, d'où `outils site` les recopie dans le site.
La bibliothèque commune, la configuration de vite et la mise en page vivent
dans `animations/` à la racine du dépôt (cf. animations/README.md).

On ne reconstruit que ce qui a bougé : `build/animations/.empreinte` garde le
condensé de tout ce dont la construction dépend. Le hook pre-commit (par
`outils build`) et le hook pre-push (par `outils site`) peuvent donc appeler
`construit` sans compter : quand rien n'a changé, il ne coûte qu'une lecture
de quelques dizaines de fichiers.
"""

import hashlib
import json
import os
import re
import shutil
import subprocess
from dataclasses import dataclass
from html import unescape
from pathlib import Path
from threading import Lock

from .chapitre import GABARITS, RACINE, Chapitre

#: Le dossier des animations, dans un chapitre comme dans son `build/`.
DOSSIER = "animations"

#: La bibliothèque commune et la configuration de vite.
BIBLIOTHÈQUE = RACINE / "animations"
CONFIG = BIBLIOTHÈQUE / "vite.config.js"

#: Hors des dossiers d'animations, ce qu'une construction lit : les
#: dépendances npm, figées par le verrou, et la feuille du site, que la mise en
#: page commune importe.
AUTRES_DÉPENDANCES = (RACINE / "package-lock.json", GABARITS / "site.css")

#: Dans `build/animations/`, le condensé de la dernière construction.
EMPREINTE = ".empreinte"

#: Deux chapitres construits de front ne doivent pas lancer `npm ci` en même
#: temps : le second effacerait `node_modules/` sous les pieds du premier.
_verrou_npm = Lock()


class ErreurAnimations(Exception):
    pass


class NodeAbsent(ErreurAnimations):
    """Pas de Node.js sur cette machine : rien ne peut se construire."""


@dataclass(frozen=True)
class Page:
    fichier: str
    titre: str
    description: str


def source(chapitre: Chapitre) -> Path | None:
    """Le dossier `animations/` du chapitre, s'il porte au moins une page."""
    dossier = chapitre.chemin / DOSSIER
    return dossier if dossier.is_dir() and any(dossier.glob("*.html")) else None


def sortie(chapitre: Chapitre) -> Path:
    return chapitre.sortie / DOSSIER


def pages(chapitre: Chapitre) -> list[Page]:
    """Les animations du chapitre, lues dans leurs sources : titre (`<title>`)
    et description (`<meta name="description">`). Dans l'ordre des noms de
    fichiers, qui est celui du sommaire."""
    dossier = source(chapitre)
    if dossier is None:
        return []
    trouvées = []
    for fichier in sorted(dossier.glob("*.html")):
        html = fichier.read_text(encoding="utf-8")
        titre = re.search(r"<title>([^<]*)</title>", html)
        description = re.search(r'<meta\s+name="description"\s+content="([^"]*)"', html)
        trouvées.append(Page(
            fichier=fichier.name,
            titre=unescape(titre.group(1)).strip() if titre else fichier.stem,
            description=unescape(description.group(1)).strip() if description else "",
        ))
    return trouvées


def fil(chapitre: Chapitre) -> list[list[str]]:
    """Le fil d'Ariane d'une animation jusqu'à son chapitre, tel que le site
    l'écrit : ses adresses sont relatives à `<chapitre>/animations/`."""
    # Import tardif : le site importe ce module.
    from .site import fil_du_chapitre

    return [[texte, "../" + url] for texte, url in fil_du_chapitre(chapitre)]


def _condensé(chapitre: Chapitre, fil_json: str) -> str:
    """Tout ce dont dépend la construction : les sources du chapitre, la
    bibliothèque commune, le verrou npm, la feuille du site, le fil d'Ariane.
    Les contenus et non les dates : un `git checkout` change les dates."""
    h = hashlib.sha256(fil_json.encode("utf-8"))
    fichiers = [
        f
        for dossier in (source(chapitre).resolve(), BIBLIOTHÈQUE)
        for f in sorted(dossier.rglob("*"))
        if f.is_file()
    ] + [f for f in AUTRES_DÉPENDANCES if f.is_file()]
    for f in fichiers:
        h.update(b"\x00" + str(f.relative_to(RACINE)).encode("utf-8") + b"\x00")
        h.update(f.read_bytes())
    return h.hexdigest()


def _vite() -> Path:
    """Le vite du dépôt, installé d'après `package-lock.json` s'il manque ou
    si le verrou a changé depuis (`npm ci` réécrit `node_modules/`)."""
    vite = RACINE / "node_modules" / ".bin" / "vite"
    verrou = RACINE / "package-lock.json"
    # npm écrit ce double du verrou à la fin de chaque installation.
    installé = RACINE / "node_modules" / ".package-lock.json"
    with _verrou_npm:
        if vite.is_file() and installé.is_file() and installé.stat().st_mtime >= verrou.stat().st_mtime:
            return vite
        npm = shutil.which("npm")
        if npm is None or shutil.which("node") is None:
            raise NodeAbsent("Node.js introuvable : il faut node et npm dans le PATH (cf. animations/README.md)")
        r = subprocess.run(
            [npm, "ci", "--no-audit", "--no-fund"], cwd=RACINE, capture_output=True, text=True
        )
        if r.returncode:
            raise ErreurAnimations(f"npm ci a échoué :\n{r.stderr or r.stdout}")
    return vite


def _environnement(chapitre: Chapitre, fil_json: str) -> dict[str, str]:
    return dict(
        os.environ,
        ANIMATIONS_SOURCE=str(source(chapitre).resolve()),
        ANIMATIONS_SORTIE=str(sortie(chapitre).resolve()),
        ANIMATIONS_FIL=fil_json,
    )


def construit(chapitre: Chapitre, forcer: bool = False) -> list[Path]:
    """Construit les animations du chapitre dans `build/animations/`, sauf si
    rien n'a bougé depuis la dernière fois (`forcer` pour passer outre).

    Renvoie les pages produites — celles de la construction précédente si
    elle est encore bonne —, une liste vide pour un chapitre sans animation.
    """
    if source(chapitre) is None:
        return []
    dossier = sortie(chapitre)
    fil_json = json.dumps(fil(chapitre), ensure_ascii=False)
    condensé = _condensé(chapitre, fil_json)
    témoin = dossier / EMPREINTE
    if forcer or not (témoin.is_file() and témoin.read_text(encoding="utf-8") == condensé):
        r = subprocess.run(
            [str(_vite()), "build", "--config", str(CONFIG)],
            cwd=RACINE,
            env=_environnement(chapitre, fil_json),
            capture_output=True,
            text=True,
        )
        if r.returncode:
            raise ErreurAnimations(f"vite a échoué :\n{r.stderr or r.stdout}")
        # vite vide le dossier avant d'écrire : le témoin s'écrit après.
        témoin.write_text(condensé, encoding="utf-8")
    return sorted(dossier.glob("*.html"))


def fichiers(chapitre: Chapitre) -> list[Path]:
    """Tout ce que la construction a produit, à recopier dans le site."""
    dossier = sortie(chapitre)
    if not dossier.is_dir():
        return []
    return sorted(f for f in dossier.rglob("*") if f.is_file() and f.name != EMPREINTE)


def serveur(chapitre: Chapitre) -> int:
    """Le serveur de développement de vite sur les animations du chapitre :
    chaque modification se voit aussitôt dans le navigateur."""
    if source(chapitre) is None:
        raise ErreurAnimations(f"{chapitre.chemin} : pas de page dans {DOSSIER}/")
    fil_json = json.dumps(fil(chapitre), ensure_ascii=False)
    return subprocess.run(
        [str(_vite()), "--config", str(CONFIG)],
        cwd=RACINE,
        env=_environnement(chapitre, fil_json),
    ).returncode
