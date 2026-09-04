#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: TD.with(infos: infos)

#include "exercices/Pince ampère-métrique.typ";
#include "exercices/Permanent magnet.typ";
#include "exercices/Disque dur.typ";
#include "exercices/Boussole.typ"
// TODO: ajouter un exercice numérique : mesure de cycle d'hystérésis
