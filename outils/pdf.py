"""Imposition de PDF : mise en fascicule prête à l'impression."""

from pathlib import Path


def fascicule(source: Path | str, destination: Path | str) -> Path:
    """Impose un PDF A4 portrait en fascicule sur des feuilles A3 paysage.

    Le nombre de pages est complété à un multiple de 4 par des pages
    blanches. Le PDF produit contient une face de feuille par page (recto puis
    verso de la feuille 1, recto puis verso de la feuille 2, …). Il est prêt
    pour une impression **recto-verso, retournement sur le bord court**, puis
    pliage au centre : les pages se lisent alors dans l'ordre 1, 2, 3, …
    """
    from pypdf import PdfReader, PdfWriter
    from pypdf.generic import ArrayObject, DecodedStreamObject, DictionaryObject, FloatObject, NameObject

    lecteur = PdfReader(source)
    n = len(lecteur.pages)
    total = n + (-n) % 4  # arrondi au multiple de 4 supérieur

    gabarit = lecteur.pages[0]
    largeur = float(gabarit.mediabox.width)
    hauteur = float(gabarit.mediabox.height)

    écrivain = PdfWriter()

    def forme(indice: int):
        """Page 1-indexée du document, faite « Form XObject » de l'écrivain,
        ou ``None`` pour une page blanche.

        Une feuille A3 n'a plus qu'à placer ses deux formes, sans relire leur
        contenu : `merge_transformed_page` le décortiquait opérateur par
        opérateur, et y passait l'essentiel du temps. Les liens ne suivent pas,
        inutiles sur papier.
        """
        if not 1 <= indice <= n:
            return None
        p = lecteur.pages[indice - 1]
        f = DecodedStreamObject()
        contenu = p.get_contents()
        f.set_data(contenu.get_data() if contenu is not None else b"")
        f[NameObject("/Type")] = NameObject("/XObject")
        f[NameObject("/Subtype")] = NameObject("/Form")
        f[NameObject("/BBox")] = ArrayObject(FloatObject(x) for x in p.mediabox)
        ressources = p.get("/Resources")
        f[NameObject("/Resources")] = (
            ressources.get_object().clone(écrivain) if ressources is not None else DictionaryObject()
        )
        return écrivain._add_object(f.flate_encode()), p.mediabox

    formes = {}
    for feuille in range(total // 4):
        recto = (total - 2 * feuille, 2 * feuille + 1)
        verso = (2 * feuille + 2, total - 2 * feuille - 1)
        for gauche, droite in (recto, verso):
            a3 = écrivain.add_blank_page(width=2 * largeur, height=hauteur)
            xobjets = DictionaryObject()
            opérations = []
            for décalage, indice in ((0.0, gauche), (largeur, droite)):
                if indice not in formes:
                    formes[indice] = forme(indice)
                if formes[indice] is None:
                    continue
                réf, boite = formes[indice]
                nom = f"/P{indice}"
                xobjets[NameObject(nom)] = réf
                dx = décalage - float(boite.left)
                dy = -float(boite.bottom)
                opérations.append(f"q 1 0 0 1 {dx:g} {dy:g} cm {nom} Do Q")
            a3[NameObject("/Resources")] = DictionaryObject({NameObject("/XObject"): xobjets})
            contenu = DecodedStreamObject()
            contenu.set_data("\n".join(opérations).encode("ascii"))
            a3[NameObject("/Contents")] = écrivain._add_object(contenu)

    destination = Path(destination)
    destination.parent.mkdir(parents=True, exist_ok=True)
    with open(destination, "wb") as f:
        écrivain.write(f)
    return destination


def dédoublonne(écrivain) -> None:
    """Ne garde qu'un exemplaire de chaque objet en plusieurs copies dans un
    ``PdfWriter`` : les photos et polices de documents concaténés.

    `compress_identical_objects` ne fusionne que les objets déjà identiques.
    Une image d'une copie diffère pourtant de celle de la suivante par la
    référence à son profil colorimétrique, lui-même propre à chaque copie : il
    faut qu'une passe fusionne les profils pour qu'une suivante fusionne les
    images. On répète donc tant que des objets disparaissent.
    """
    restants = None
    while True:
        écrivain.compress_identical_objects()
        nombre = sum(o is not None for o in écrivain._objects)
        if nombre == restants:
            return
        restants = nombre
