#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: full-poly.with(infos: infos)

#include "competences.typ"; <compétences>
#include "cours.typ"; <cours>
#include "méthodes.typ"; <méthodes>
#include "TD.typ"; <TD>