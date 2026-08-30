#import "@local/prepa:0.1.0": *

#let infos = yaml("infos.yml")
#show: full-poly.with(infos: infos)

#include "compétences.typ"; <compétences>
#include "cours.typ"; <cours>
#include "méthodes.typ"; <méthodes>
#include "TD.typ"; <TD>