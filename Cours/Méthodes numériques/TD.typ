#import "@local/prepa:0.1.0": *

#let infos = yaml("infos.yml")
#show: TD.with(infos: infos)

#include "exercices/Wien.typ"
#include "exercices/chaleur.typ"