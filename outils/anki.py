"""Fabrication d'un paquet Anki (.apkg) à partir de couples recto/verso."""

import os
import time
from hashlib import sha1
from pathlib import Path

#: 1er janvier 1980 : le format zip ne sait pas coder de date antérieure.
_ÉPOQUE_ZIP_MIN = 315532800


def _date_zip() -> tuple[int, ...]:
    """La date des entrées du paquet : SOURCE_DATE_EPOCH, bornée à 1980.

    Le hook met SOURCE_DATE_EPOCH à 0 pour rendre les PDF reproductibles ; lue
    telle quelle par zipfile, elle faisait échouer l'écriture du .apkg.

    La date est calculée ici et donnée à chaque entrée, sans toucher à
    l'environnement. La parade d'avant — relever la variable le temps de
    l'écriture — ne tenait pas à plusieurs chapitres de front (`outils build`,
    donc le hook) : un fil la remettait à 0 pendant qu'un autre écrivait son
    paquet (« 'H' format requires 0 <= number <= 65535 »), et un typst lancé
    entre-temps en héritait, ce qui changeait les octets de son PDF.
    """
    epoch = os.environ.get("SOURCE_DATE_EPOCH")
    if epoch is None:
        return time.localtime()[:6]
    return time.gmtime(max(int(epoch), _ÉPOQUE_ZIP_MIN))[:6]

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
    """Écrit le paquet `nom` contenant `cartes` (recto, verso) dans `fichier`.

    C'est ce que fait `Package.write_to_file` de genanki, à la date des entrées
    du zip près : genanki la laisse à zipfile, qui la tire de l'environnement
    (cf. `_date_zip`).
    """
    import itertools
    import sqlite3
    import zipfile
    from tempfile import TemporaryDirectory

    from genanki import Deck, Note, Package

    modèle = _modèle()
    paquet = Deck(_identifiant(nom), nom)
    for recto, verso in cartes:
        paquet.add_note(Note(model=modèle, fields=[recto, verso]))
    fichier = Path(fichier)
    fichier.parent.mkdir(parents=True, exist_ok=True)

    horodatage = time.time()
    with TemporaryDirectory() as tampon:
        base = Path(tampon) / "collection.anki2"
        connexion = sqlite3.connect(base)
        try:
            Package(paquet).write_to_db(
                connexion.cursor(), horodatage, itertools.count(int(horodatage * 1000))
            )
            connexion.commit()
        finally:
            connexion.close()
        date = _date_zip()
        with zipfile.ZipFile(fichier, "w") as archive:
            archive.writestr(zipfile.ZipInfo("collection.anki2", date), base.read_bytes())
            # Aucune image jointe : l'index des médias est vide.
            archive.writestr(zipfile.ZipInfo("media", date), "{}")
    return fichier
