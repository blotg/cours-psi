// Page de liens du site : l'accueil et le sommaire de chaque chapitre.
//
// Alimenté par `outils site`, qui passe en `--input données` :
//
//     {"titre": "...", "fil": [["texte", "url ou null"], ...],
//      "sections": [{"titre": "...",
//                    "liens": [{"texte": "...", "url": "...", "détail": "..."}]}]}

#import "site.typ": *

#page-liens(json(bytes(sys.inputs.données)))
