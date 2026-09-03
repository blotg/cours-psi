"""Fabrication d'un paquet Anki (.apkg) à partir de couples recto/verso."""

import os
from contextlib import contextmanager
from hashlib import sha1
from pathlib import Path

#: 1er janvier 1980 : le format zip ne sait pas coder de date antérieure, et
#: zipfile lit SOURCE_DATE_EPOCH. Le hook le met à 0 pour rendre les PDF
#: reproductibles, ce qui ferait échouer l'écriture du .apkg.
_ÉPOQUE_ZIP_MIN = 315532800


@contextmanager
def _date_zip_valide():
    epoch = os.environ.get("SOURCE_DATE_EPOCH")
    if epoch is None or int(epoch) >= _ÉPOQUE_ZIP_MIN:
        yield
        return
    os.environ["SOURCE_DATE_EPOCH"] = str(_ÉPOQUE_ZIP_MIN)
    try:
        yield
    finally:
        os.environ["SOURCE_DATE_EPOCH"] = epoch

_CSS = """
.card {
    font-family: arial;
    font-size: 20px;
    text-align: center;
    color: black;
    background-color: white;
}

.night-mode [fill="#000000"] { fill: white; }
.night-mode [stroke="#000000"] { stroke: white; }
"""


def _identifiant(nom: str) -> int:
    """Identifiant stable déduit du nom : régénérer un paquet met à jour
    l'ancien dans Anki au lieu d'en créer un doublon."""
    return int.from_bytes(sha1(nom.encode()).digest()) // 10**30


def _modèle():
    from genanki import Model

    return Model(
        _identifiant("Modèle des cartes Blot-Teyssedre"),
        "Modèle des cartes de Blot-Teyssedre",
        fields=[{"name": "Recto"}, {"name": "Verso"}],
        templates=[
            {
                "name": "Card 1",
                "qfmt": "{{Recto}}",
                "afmt": '{{FrontSide}}\n\n<hr id="answer">\n\n{{Verso}}',
            }
        ],
        css=_CSS,
    )


def écrit_paquet(nom: str, cartes: list[tuple[str, str]], fichier: Path | str) -> Path:
    """Écrit le paquet `nom` contenant `cartes` (recto, verso) dans `fichier`."""
    from genanki import Deck, Note, Package

    modèle = _modèle()
    paquet = Deck(_identifiant(nom), nom)
    for recto, verso in cartes:
        paquet.add_note(Note(model=modèle, fields=[recto, verso]))
    fichier = Path(fichier)
    fichier.parent.mkdir(parents=True, exist_ok=True)
    with _date_zip_valide():
        Package(paquet).write_to_file(fichier)
    return fichier
