"""Notebook Jupyter d'un exercice numérique, pour Capytale.

L'exercice n'est pas réécrit : il est compilé en HTML par typst, comme pour le
site, à travers `gabarits/notebook.typ` qui en retire corrigés, coups de pouce
et lien Capytale, et qui pose des repères au début et à la fin de chaque
question. pandoc lit ce HTML : il traduit le MathML de typst en LaTeX, que le
MathJax 2 de Capytale sait afficher, et il écrit le notebook. Entre les deux,
on découpe les cellules :

- chaque question ouvre une cellule de texte ;
- chaque bloc de code Python part dans sa propre cellule de code ;
- le texte hors question (l'introduction, ce qui sépare deux questions) a ses
  propres cellules.

Il faut `pandoc` dans le PATH. Le paquet d'Arch s'appelle `pandoc-cli`.
"""

import base64
import json
import re
import shutil
import subprocess
from pathlib import Path

from . import typst
from .chapitre import RACINE, Chapitre
from .site import Site, arguments_exercice, hors_chaines

#: Le gabarit, en chemin absolu sous la racine du dépôt.
GABARIT = "/gabarits/notebook.typ"

#: Type de document, en tête du nom des fichiers produits dans `build/`.
TYPE = "notebook"

#: Les métadonnées d'un notebook vide de Capytale, reprises telles quelles.
#: nbformat 4.2 plutôt que la 4.5 qu'écrit pandoc : le lecteur de Capytale est
#: un Jupyter Notebook 6 remanié, qui ouvre une boîte d'avertissement devant
#: une version plus récente que la sienne.
MÉTADONNÉES = {
    "kernelspec": {"name": "python3", "display_name": "Python 3", "language": "python"},
    "language_info": {"name": "python"},
}
NBFORMAT = (4, 2)


class ErreurNotebook(RuntimeError):
    """Le notebook n'a pas pu être produit."""


def pandoc() -> str:
    chemin = shutil.which("pandoc")
    if chemin is None:
        raise ErreurNotebook("pandoc introuvable : il en faut un dans le PATH (paquet pandoc-cli)")
    return chemin


def _pandoc(entrée: str, de: str, vers: str) -> str:
    appel = subprocess.run(
        [pandoc(), "-f", de, "-t", vers, "--wrap=none"],
        input=entrée.encode("utf-8"),
        capture_output=True,
    )
    if appel.returncode != 0:
        raise ErreurNotebook(appel.stderr.decode("utf-8", "replace").strip())
    return appel.stdout.decode("utf-8")


# -- Le HTML de typst, rendu lisible par pandoc -----------------------------


def _svg_en_image(html: str) -> str:
    """Chaque SVG en ligne devient une image `data:`.

    Le Markdown d'un notebook passe au tamis d'un nettoyeur HTML qui ne connaît
    pas `<svg>` : un schéma y disparaîtrait. Une `<img>`, elle, passe, adresse
    `data:` comprise. Hors du document, le SVG doit déclarer ses espaces de
    noms, que le HTML lui passait.
    """
    morceaux, i = [], 0
    while (début := html.find("<svg", i)) != -1:
        # Le `</svg>` qui ferme celui-ci, en comptant ceux qu'il contiendrait.
        profondeur, j = 0, début
        while True:
            ouvre, ferme = html.find("<svg", j + 1), html.find("</svg>", j + 1)
            if ferme == -1:
                raise ErreurNotebook("SVG non fermé dans le HTML de typst")
            if ouvre != -1 and ouvre < ferme:
                profondeur, j = profondeur + 1, ouvre
            elif profondeur:
                profondeur, j = profondeur - 1, ferme
            else:
                fin = ferme + len("</svg>")
                break
        svg = html[début:fin]
        if "xmlns=" not in svg[: svg.find(">")]:
            svg = svg.replace("<svg", '<svg xmlns="http://www.w3.org/2000/svg"', 1)
        if "xlink:" in svg and "xmlns:xlink" not in svg[: svg.find(">")]:
            svg = svg.replace("<svg", '<svg xmlns:xlink="http://www.w3.org/1999/xlink"', 1)
        données = base64.b64encode(svg.encode("utf-8")).decode("ascii")
        morceaux += [html[i:début], f'<img src="data:image/svg+xml;base64,{données}" alt="">']
        i = fin
    return "".join(morceaux) + html[i:]


def nettoie_html(html: str) -> str:
    """Ce que pandoc ne sait pas lire dans le MathML de typst.

    - `#ce(…)` dans un indice sort en `<math>` imbriqué dans le `<math>` de la
      formule, ce qui n'est pas du MathML : pandoc abandonne alors la formule
      entière, qui reste en texte brut. On en fait un simple `<mrow>`.
    - zero glisse un `<span>` vide dans la notation scientifique, avec le même
      effet.
    - Un `<mtable>` vide traîne devant certaines unités (le « L » de
      « mol/L ») : pandoc en fait une matrice vide.
    - Le trait d'un souligné (cf. `_sous` dans le gabarit) arrive enveloppé
      dans un `<mtext>`, sous lequel pandoc ne le reconnaît plus : il écrivait
      `\\underset{}{Z}`, sans trait.
    """
    html = re.sub(
        r'<span style="display: inline-block"><math>(.*?)</math></span>',
        r"<mrow>\1</mrow>",
        html,
        flags=re.S,
    )
    html = html.replace('<span style="display: inline-block"></span>', "")
    html = re.sub(r"<mtable[^>]*></mtable>", "", html)
    html = re.sub(r"<mo><mtext>(.)</mtext></mo>", r"<mo>\1</mo>", html)
    return _svg_en_image(html)


# -- Retouches du LaTeX -------------------------------------------------------

_ESPACE_FINE = "\u2009"
_GLU = "\u2060"  # « word joiner », que typst pose entre nombre et unité


def _texte_coupé(m: re.Match) -> str:
    """`\\text{kW h}` (espace fine) devient `\\text{kW}\\,\\text{h}`."""
    return r"\,".join(r"\text{" + p + "}" for p in m.group(1).split(_ESPACE_FINE))


def latex(tex: str) -> str:
    """Les tournures que produit pandoc, rendues comme en typst.

    Les nombres arrivent de zero en morceaux : « 0,1 » en `0\\text{,1}` — la
    virgule décimale est un texte —, « 96 500 » en `\\text{96 500}`. En LaTeX,
    une virgule nue se lit comme une ponctuation et prend une espace : d'où
    `{,}`. Le signe de multiplication arrive flanqué de deux espaces.
    """
    tex = tex.replace(_GLU, "")
    tex = re.sub(r"\\text\{,(\d+)\}", r"{,}\1", tex)
    tex = re.sub(
        r"\\text\{(\d{1,3}(?:" + _ESPACE_FINE + r"\d{3})+)\}",
        lambda m: m.group(1).replace(_ESPACE_FINE, r"\,"),
        tex,
    )
    tex = re.sub(r"\\ (\\times|\\cdot)\\ ", r"\1", tex)
    tex = re.sub(r"\\text\{([^{}]*" + _ESPACE_FINE + r"[^{}]*)\}", _texte_coupé, tex)
    tex = tex.replace(_ESPACE_FINE, r"\,").replace(r"\text{}", "")
    # MathJax 2 ne charge l'extension qu'à la demande.
    if r"\cancel" in tex:
        tex = r"\require{cancel}" + tex
    return tex


# -- L'arbre de pandoc ---------------------------------------------------------


def _classes(nœud: dict) -> list[str]:
    return nœud["c"][0][1] if nœud.get("t") in ("Div", "Span", "CodeBlock") else []


def _contient(nœud, classe: str) -> bool:
    if isinstance(nœud, dict):
        if classe in _classes(nœud):
            return True
        return any(_contient(v, classe) for v in nœud.values())
    if isinstance(nœud, list):
        return any(_contient(v, classe) for v in nœud)
    return False


def _est_python(bloc: dict) -> bool:
    if bloc.get("t") != "CodeBlock":
        return False
    _, classes, attributs = bloc["c"][0]
    return "python" in classes or ("data-lang", "python") in map(tuple, attributs)


def _aplatis(liste: list) -> list:
    """Les `Div` et les `Span` cèdent la place à leur contenu.

    Ils ne portent que des classes CSS du site (grille, pile…) et des repères,
    qui n'ont pas de sens dans un notebook. Écrits en Markdown, ils sortiraient
    en `:::` et en `[…]{.classe}`, que Jupyter ne lit pas.
    """
    sortie = []
    for x in liste:
        t = x.get("t") if isinstance(x, dict) else None
        if t in ("Div", "Span"):
            sortie += _aplatis(x["c"][1])
        elif t == "Link" and x["c"][2][0].startswith("#"):
            # Un renvoi interne (`@tab-vitesse`) : sa cible n'existe plus dans
            # le notebook, reste le texte.
            sortie += _aplatis(x["c"][1])
        elif t == "Figure":
            # Une figure sort en `<figure>` HTML, que le nettoyeur du notebook
            # ne connaît pas. Son contenu, puis sa légende, suffisent.
            _, (_, légende), contenu = x["c"]
            sortie += _aplatis(contenu)
            sortie += [
                {"t": "Para", "c": [{"t": "Emph", "c": _aplatis(b["c"])}]}
                for b in légende
                if b.get("t") in ("Plain", "Para")
            ]
        elif t == "Table":
            sortie.append(_retouche(_avec_en_tête(x)))
        else:
            sortie.append(_retouche(x))
    return _soude(sortie)


def _avec_en_tête(table: dict) -> dict:
    """La première ligne d'un tableau devient son en-tête.

    typst n'en déclare jamais, or un tableau Markdown en exige un : sans lui,
    pandoc écrit le tableau en HTML, formules en MathML, et le notebook n'en
    garde que le texte.
    """
    _, _, _, (_, en_tête), corps, _ = table["c"]
    if not en_tête and corps and corps[0][3]:
        en_tête.append(corps[0][3].pop(0))
    return _sans_saut(table)


def _sans_saut(nœud):
    """Un saut de ligne forcé dans une case (`\\` en typst) devient `<br>` :
    une ligne de tableau Markdown n'en admet pas d'autre, et pandoc se
    rabattait là aussi sur le HTML."""
    if isinstance(nœud, list):
        return [_sans_saut(x) for x in nœud]
    if isinstance(nœud, dict):
        if nœud.get("t") == "LineBreak":
            return {"t": "RawInline", "c": ["html", "<br>"]}
        return {clé: _sans_saut(v) for clé, v in nœud.items()}
    return nœud


def _soude(inlines: list) -> list:
    """Une grandeur en texte courant (`#quan[298 K]`) sort en trois formules —
    nombre, espace, unité — collées par des « word joiners ». On les ressoude
    en une seule."""
    def genre(n) -> str | None:
        return n.get("t") if isinstance(n, dict) else None

    sortie = []
    for x in inlines:
        if (
            genre(x) == "Math"
            and len(sortie) >= 2
            and genre(sortie[-1]) == "Str"
            and sortie[-1]["c"].strip(_GLU) == ""
            and genre(sortie[-2]) == "Math"
            and sortie[-2]["c"][0] == x["c"][0]
        ):
            sortie.pop()
            précédente = sortie.pop()
            x = {"t": "Math", "c": [x["c"][0], précédente["c"][1] + " " + x["c"][1]]}
        sortie.append(x)
    return sortie


def _retouche(nœud):
    """Retouche récursive d'un nœud : LaTeX, titres, blocs de code."""
    if isinstance(nœud, list):
        return _aplatis(nœud)
    if not isinstance(nœud, dict):
        return nœud
    t = nœud.get("t")
    if t == "Math":
        return {"t": "Math", "c": [nœud["c"][0], latex(nœud["c"][1])]}
    if t == "Header":
        # typst réserve le <h1> au titre du document : l'exercice sort en <h2>.
        niveau, _, contenu = nœud["c"]
        return {"t": "Header", "c": [max(1, niveau - 1), ["", [], []], _aplatis(contenu)]}
    if t == "CodeBlock":
        return {"t": "CodeBlock", "c": [["", ["python"] if _est_python(nœud) else [], []], nœud["c"][1]]}
    return {clé: _retouche(v) for clé, v in nœud.items()}


def _vide(blocs: list) -> bool:
    return all(b.get("t") in ("Para", "Plain") and not b["c"] for b in blocs)


def _cellule(genre: str, blocs: list) -> dict:
    return {"t": "Div", "c": [["", ["cell", genre], []], blocs]}


def cellules(blocs: list) -> list[dict]:
    """Découpe le corps du document en cellules : des `Div` de classe `cell`,
    que l'écrivain ipynb de pandoc sait lire."""
    sortie: list[dict] = []
    texte: list = []
    dans_question = False

    def clôt():
        nonlocal texte
        texte = _aplatis(texte)
        if texte and not _vide(texte):
            sortie.append(_cellule("markdown", texte))
        texte = []

    for bloc in blocs:
        if "fin-question" in _classes(bloc):
            clôt()
            dans_question = False
        elif _est_python(bloc):
            clôt()
            sortie.append(_cellule("code", [_retouche(bloc)]))
        else:
            if not dans_question and _contient(bloc, "début-question"):
                clôt()
                dans_question = True
            texte.append(bloc)
    clôt()
    return sortie


# -- Le notebook ----------------------------------------------------------------


def html(exercice: Path) -> str:
    """L'exercice compilé à travers le gabarit du notebook, nettoyé pour pandoc."""
    inclus = "/" + exercice.resolve().relative_to(RACINE).as_posix()
    source = (
        f'#import "{GABARIT}": *\n'
        f"#show: page-notebook\n"
        f"#include {typst.chaine(inclus)}\n"
    )
    return nettoie_html(typst.html_source(source, RACINE))


def notebook(exercice: Path) -> dict:
    """Le notebook d'un exercice, en dictionnaire nbformat."""
    arbre = json.loads(_pandoc(html(exercice), "html", "json"))
    arbre["blocks"] = cellules(arbre["blocks"])
    # Le <title> de la page ne doit pas devenir une cellule de titre.
    arbre["meta"] = {}
    nb = json.loads(_pandoc(json.dumps(arbre), "json", "ipynb"))
    for cellule in nb["cells"]:
        cellule.pop("id", None)
        cellule.pop("attachments", None)
        cellule["metadata"] = {}
    nb["metadata"] = MÉTADONNÉES
    nb["nbformat"], nb["nbformat_minor"] = NBFORMAT
    return nb


def texte(nb: dict) -> str:
    """Le notebook sérialisé, toujours de la même façon : c'est ce texte-là
    dont l'empreinte dit s'il faut le renvoyer sur Capytale."""
    return json.dumps(nb, ensure_ascii=False, indent=1, sort_keys=True) + "\n"


def est_numérique(exercice: Path) -> bool:
    arguments = hors_chaines(arguments_exercice(exercice.read_text(encoding="utf-8")))
    return re.search(r"numérique:\s*true", arguments) is not None


def exercices(chapitre: Chapitre) -> list[Path]:
    """Les exercices numériques du chapitre que son TD inclut — comme le site :
    un exercice en chantier, mis en commentaire dans le TD, n'a pas à être
    distribué."""
    return [source for source, _ in Site.exercices(chapitre) if est_numérique(source)]


def cible(chapitre: Chapitre, exercice: Path) -> Path:
    """`build/notebook - <fichier de l'exercice>.ipynb`.

    Le nom du fichier plutôt que le titre : un titre peut porter des formules
    et de la mise en forme, pas le nom du fichier.
    """
    return chapitre.sortie / f"{TYPE} - {exercice.stem}.ipynb"


def écrit(chapitre: Chapitre, exercice: Path) -> Path:
    chemin = cible(chapitre, exercice)
    chemin.parent.mkdir(parents=True, exist_ok=True)
    chemin.write_text(texte(notebook(exercice)), encoding="utf-8")
    return chemin


def notebooks(chapitre: Chapitre) -> list[Path]:
    """Les notebooks de tous les exercices numériques du chapitre."""
    return [écrit(chapitre, exercice) for exercice in exercices(chapitre)]
