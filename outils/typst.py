"""Appels à la ligne de commande `typst`."""

import json
import re
import subprocess
from pathlib import Path


class ErreurTypst(RuntimeError):
    """La compilation ou la requête typst a échoué."""


def _exécute(commande: list[str], entrée: bytes | None = None) -> bytes:
    appel = subprocess.run(commande, input=entrée, capture_output=True)
    if appel.returncode != 0:
        raise ErreurTypst(appel.stderr.decode("utf-8", "replace").strip())
    return appel.stdout


def chaine(valeur: str) -> str:
    """Une chaîne littérale typst."""
    return '"' + valeur.replace("\\", "\\\\").replace('"', '\\"') + '"'


def query(
    fichier: Path | str,
    sélecteur: str,
    champ: str | None = None,
    entrées: dict | None = None,
    racine: Path | str | None = None,
):
    """Interroge un document et renvoie les valeurs trouvées.

    `typst query` sort du JSON : le charger avec le lecteur YAML pur python
    coûte des dizaines de secondes sur un poly (des milliers d'entrées).

    Du content n'y survit pas : une formule n'y est plus qu'un arbre dont les
    appels de fonction du paquet (`pdv`, `ce`…) sont vides. Les flashcards et
    les questions de colle se lisent donc autrement (cf. `cartes_html`).
    """
    commande = ["typst", "query", str(fichier), sélecteur, "--format", "json"]
    if champ:
        commande += ["--field", champ]
    for clé, valeur in (entrées or {}).items():
        commande += ["--input", f"{clé}={valeur}"]
    if racine is not None:
        commande += ["--root", str(racine)]
    return json.loads(_exécute(commande).decode("utf-8"))


#: Ce qu'il faut ajouter à `typst compile` pour viser le HTML plutôt que le PDF.
_HTML = ("--features", "html", "--format", "html")


def compile_fichier(
    source: Path | str,
    sortie: Path | str | None = None,
    entrées: dict | None = None,
    html: bool = False,
    dépendances: Path | str | None = None,
    racine: Path | str | None = None,
    pages: str | None = None,
) -> None:
    """Compile un fichier. `entrées` alimente les `--input` de typst.

    `racine` est nécessaire dès que le fichier inclut un document hors de son
    dossier : les chemins absolus s'y résolvent. `pages` restreint le PDF
    produit, dans la syntaxe de `--pages` (« 1-4 »).
    """
    options: list[str] = list(_HTML) if html else []
    for clé, valeur in (entrées or {}).items():
        options += ["--input", f"{clé}={valeur}"]
    if racine is not None:
        options += ["--root", str(racine)]
    if dépendances is not None:
        options += ["--make-deps", str(dépendances)]
    if pages is not None:
        options += ["--pages", pages]
    if sortie is not None:
        Path(sortie).parent.mkdir(parents=True, exist_ok=True)
    _exécute(["typst", "compile", *options, str(source)] + ([str(sortie)] if sortie else []))


def compile_avec_annexe(source: Path | str, sortie: Path | str, entrées: dict, racine: Path | str) -> None:
    """Compile un document qui inclut des cours en annexe (cf. `cours-en-annexe`
    dans le paquet), sans les pages de l'annexe.

    Où s'arrête le document ne se sait qu'une fois tout composé : une première
    passe lit le repère <fin-du-document>, une seconde ne produit que ces
    pages-là. C'est le prix d'une annexe plutôt que d'une boîte masquée, dont
    les notes de bas de page des cours s'échappaient.
    """
    (fin,) = query(source, "<fin-du-document>", "value", entrées=entrées, racine=racine)
    compile_fichier(source, sortie, entrées=entrées, racine=racine, pages=f"1-{fin}")


def compile_source(
    source: str,
    sortie: Path | str,
    html: bool = False,
    racine: Path | str | None = None,
    dépendances: Path | str | None = None,
) -> None:
    """Compile un document passé sous forme de chaîne.

    `racine` est nécessaire dès que la source contient un `#include` : les
    chemins absolus d'un document lu sur l'entrée standard s'y résolvent.
    """
    Path(sortie).parent.mkdir(parents=True, exist_ok=True)
    options = list(_HTML) if html else []
    if racine is not None:
        options += ["--root", str(racine)]
    if dépendances is not None:
        options += ["--make-deps", str(dépendances)]
    _exécute(["typst", "compile", *options, "-", str(sortie)], entrée=source.encode("utf-8"))


def html_source(source: str, racine: Path | str) -> str:
    """Le HTML d'un document passé sous forme de chaîne, sans fichier de sortie."""
    commande = ["typst", "compile", "--root", str(racine), *_HTML, "-", "-"]
    return _exécute(commande, entrée=source.encode("utf-8")).decode("utf-8")


def lit_dépendances(fichier: Path | str) -> list[str]:
    """Les chemins listés par `--make-deps`, au format Makefile.

    « cible: dep dep … », une espace dans un chemin étant échappée par une
    barre oblique inverse, et une longue ligne coupée par « \\ » en fin de
    ligne. La cible elle-même n'en fait évidemment pas partie.
    """
    texte = Path(fichier).read_text(encoding="utf-8")
    if ":" not in texte:
        return []
    corps = texte.split(":", 1)[1].replace("\\\n", " ")
    # On met les espaces échappées à l'abri le temps de découper sur les vraies.
    return [d.replace("\x00", " ") for d in corps.replace("\\ ", "\x00").split()]


_PRÉAMBULE_HTML = (
    '#import "@local/prepa:0.1.1": *;'
    "#show <canvas>: html.frame;"
    "#show math.equation.where(block: true): it => par(html.frame(it));"
    "#show math.equation.where(block: false): it => box(html.frame(it));"
)

#: Après le cours inclus, chaque face de carte dans son `div` numéroté, puis un
#: `div` de fin : c'est lui qui borne la dernière face, le reste du document —
#: les notes de bas de page du cours — sortant encore après.
_FACES_HTML = """
#context for (i, carte) in query(<flashcard>).enumerate() {
    for (j, face) in (carte.value.recto, carte.value.verso).enumerate() {
        html.elem("div", attrs: (id: "face-" + str(2 * i + j)), par(face))
    }
}
#html.elem("div", attrs: (id: "face-fin"))
"""


def _dépiaute(html: str) -> str:
    return re.sub(r"<p>(?P<c>.+?)</p>", lambda m: m.group("c"), html).strip()


def cartes_html(cours: str, racine: Path | str) -> list[tuple[str, str]]:
    """Recto et verso de chaque flashcard d'un cours, rendus en HTML (formules
    et schémas en SVG), en **une seule** compilation.

    `cours` est le chemin du cours sous `racine`, en « /Cours/… ». Les cartes
    portent du content, que `typst query` ne restitue qu'avec perte : le cours
    est donc inclus, et ses cartes rendues à sa suite. Tout le cours sort aussi
    dans le HTML ; on n'en garde que les faces.
    """
    source = f"{_PRÉAMBULE_HTML}\n#html.elem(\"div\")[#include {chaine(cours)}]\n{_FACES_HTML}"
    sortie = _exécute(
        ["typst", "compile", "--root", str(racine), "--input", "inclus=1", *_HTML, "-", "-"],
        entrée=source.encode("utf-8"),
    ).decode("utf-8")

    morceaux = re.split(r'<div id="face-(?:\d+|fin)">', sortie)[1:-1]
    if len(morceaux) % 2:
        raise ErreurTypst(f"{len(morceaux)} faces rendues : il en faut deux par carte")
    # Chaque morceau court jusqu'au </div> qui ferme le nôtre : c'est le
    # dernier, les éventuels div internes étant équilibrés.
    faces = [_dépiaute(m.rsplit("</div>", 1)[0]) for m in morceaux]
    return list(zip(faces[::2], faces[1::2]))
