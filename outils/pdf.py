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
    from pypdf import PdfReader, PdfWriter, Transformation

    lecteur = PdfReader(source)
    n = len(lecteur.pages)
    total = n + (-n) % 4  # arrondi au multiple de 4 supérieur

    gabarit = lecteur.pages[0]
    largeur = float(gabarit.mediabox.width)
    hauteur = float(gabarit.mediabox.height)

    def page(indice: int):
        """Page 1-indexée du document, ou ``None`` pour une page blanche."""
        if not 1 <= indice <= n:
            return None
        p = lecteur.pages[indice - 1]
        p.pop("/Annots", None)  # liens inutiles sur papier, et mal reportés à l'échelle
        return p

    écrivain = PdfWriter()
    for feuille in range(total // 4):
        recto = (total - 2 * feuille, 2 * feuille + 1)
        verso = (2 * feuille + 2, total - 2 * feuille - 1)
        for gauche, droite in (recto, verso):
            a3 = écrivain.add_blank_page(width=2 * largeur, height=hauteur)
            for décalage, indice in ((0.0, gauche), (largeur, droite)):
                p = page(indice)
                if p is None:
                    continue
                a3.merge_transformed_page(
                    p,
                    Transformation().translate(
                        décalage - float(p.mediabox.left), -float(p.mediabox.bottom)
                    ),
                )

    destination = Path(destination)
    destination.parent.mkdir(parents=True, exist_ok=True)
    with open(destination, "wb") as f:
        écrivain.write(f)
    return destination
