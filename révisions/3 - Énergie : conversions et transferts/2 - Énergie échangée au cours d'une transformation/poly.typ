#import "@local/prepa:0.1.1": *

#let infos = yaml("infos.yml")
#show: full-poly.with(infos: infos, révision: true)

#include "compétences.typ"; <compétences>
#include "cours.typ"; <cours>
