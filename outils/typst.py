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


def query(fichier: Path | str, sélecteur: str, champ: str | None = None):
    """Interroge un document et renvoie les valeurs trouvées.

    `typst query` sort du JSON : le charger avec le lecteur YAML pur python
    coûte des dizaines de secondes sur un poly (des milliers d'entrées).
    """
    commande = ["typst", "query", str(fichier), sélecteur, "--format", "json"]
    if champ:
        commande += ["--field", champ]
    return json.loads(_exécute(commande).decode("utf-8"))


def compile_fichier(source: Path | str, sortie: Path | str | None = None, entrées: dict | None = None) -> None:
    """Compile un fichier. `entrées` alimente les `--input` de typst."""
    options: list[str] = []
    for clé, valeur in (entrées or {}).items():
        options += ["--input", f"{clé}={valeur}"]
    if sortie is not None:
        Path(sortie).parent.mkdir(parents=True, exist_ok=True)
    _exécute(["typst", "compile", *options, str(source)] + ([str(sortie)] if sortie else []))


def compile_source(source: str, sortie: Path | str) -> None:
    """Compile un document passé sous forme de chaîne."""
    Path(sortie).parent.mkdir(parents=True, exist_ok=True)
    _exécute(["typst", "compile", "-", str(sortie)], entrée=source.encode("utf-8"))


_PRÉAMBULE_HTML = (
    '#import "@local/prepa:0.1.1": *;'
    "#show <canvas>: html.frame;"
    "#show math.equation.where(block: true): it => par(html.frame(it));"
    "#show math.equation.where(block: false): it => box(html.frame(it));"
)


def _dépiaute(html: str) -> str:
    return re.sub(r"<p>(?P<c>.+?)</p>", lambda m: m.group("c"), html).strip()


def vers_html_lot(fragments: list[str]) -> list[str]:
    """Rend plusieurs fragments de balisage typst en HTML (formules et schémas
    en SVG), en **une seule** compilation : typst démarre en ~0,6 s, et un
    chapitre compte plusieurs dizaines de fragments."""
    if not fragments:
        return []
    corps = "".join(
        f'#html.elem("div", attrs: (id: "frag-{i}"))[#par([{f}])]'
        for i, f in enumerate(fragments)
    )
    sortie = _exécute(
        ["typst", "compile", "-", "-", "--features", "html", "--format", "html"],
        entrée=(_PRÉAMBULE_HTML + corps).encode("utf-8"),
    ).decode("utf-8")

    morceaux = re.split(r'<div id="frag-\d+">', sortie)[1:]
    if len(morceaux) != len(fragments):
        raise ErreurTypst(
            f"{len(morceaux)} fragments rendus pour {len(fragments)} demandés"
        )
    # Chaque morceau court jusqu'au </div> qui ferme le nôtre : c'est le
    # dernier, les éventuels div internes étant équilibrés.
    return [_dépiaute(m.rsplit("</div>", 1)[0]) for m in morceaux]


def vers_html(contenu: str) -> str:
    """Rend un fragment de balisage typst en HTML."""
    return vers_html_lot([contenu])[0]
