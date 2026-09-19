// Les animations du chapitre, les mêmes pour les trois systèmes de
// coordonnées (cf. systemes.js) :
//
// - point    : les coordonnées d'un point M et la base locale en M ;
// - volume   : l'élément de volume, ses arêtes et leurs longueurs ;
// - surface  : les éléments de surface, un par coordonnée tenue constante.
//
// Une page les appelle par des sections :
//
//     <section class="animation" data-systeme="cylindriques" data-animation="volume">

import * as THREE from 'three';
import { COULEURS, Arc, Étiquette, Flèche, Trait, point, quadrillage, repère } from '#animations/objets.js';
import { cadre, lance } from '#animations/page.js';
import { Réglages } from '#animations/reglages.js';
import { Scène } from '#animations/scene.js';
import { COULEURS_COORDONNÉES as COULEUR, SYSTÈMES } from './systemes.js';

/** La vue de départ, commune aux trois animations : (O x) vient vers l'œil,
 *  (O y) part à droite, (O z) monte. */
const VUE = { taille: 8.4, position: [9, 3.5, 4.5], cible: [0, 0.9, 1.5] };

/** Chaque face se découpe en N × N quadrilatères : assez pour arrondir une
 *  portion de sphère. */
const N = 24;

/** Les valeurs des curseurs, angles en radians. */
const enRadians = (système, valeurs) =>
    valeurs.map((v, i) => (système.coordonnées[i].angle ? THREE.MathUtils.degToRad(v) : v));

function nouvelleScène(section) {
    const { vue, réglages } = cadre(section);
    const scène = new Scène(vue, VUE);
    scène.ajoute(quadrillage(9, 9), repère(4.5));
    return { scène, réglages: new Réglages(réglages) };
}

/** Un curseur par coordonnée, ou par accroissement (`accroissement`), qui
 *  écrit dans `valeurs` puis appelle `rappel`. */
function curseurs(réglages, système, valeurs, rappel, accroissement = false) {
    return système.coordonnées.map((c, i) => {
        const { min, max, pas } = accroissement ? c.d : c;
        return réglages.curseur({
            tex: accroissement ? `\\mathrm{d}${c.tex}` : c.tex,
            min,
            max,
            pas,
            valeur: valeurs[i],
            unité: c.angle ? '°' : '',
            couleur: COULEUR[i],
            auChangement: (v) => {
                valeurs[i] = v;
                rappel();
            },
        });
    });
}

// -- Un point et sa base locale ---------------------------------------------

function animationPoint(section, système) {
    const { scène, réglages } = nouvelleScène(section);
    const valeurs = [...système.départ.point];

    réglages.groupe('Coordonnées du point M');
    curseurs(réglages, système, valeurs, miseÀJour);
    réglages.groupe('Vecteur position');
    réglages.formule(système.OM);

    const M = point();
    // À gauche du point : dans la vue de départ, ses vecteurs de base partent
    // vers la droite, le haut ou l'œil.
    const nomM = new Étiquette('M', { décalage: '-0.9em -0.3em' });
    const base = COULEUR.map((couleur) => new Flèche({ couleur, rayon: 0.03, largeur: 0.09 }));
    const nomsBase = système.vecteurs.map((tex, i) => new Étiquette(tex, { couleur: COULEUR[i] }));
    // Une construction compte toujours autant de morceaux pour un même
    // système : on les crée une fois, d'après celle du point de départ.
    const départ = système.construction(enRadians(système, valeurs));
    const pointillés = départ.pointillés.map(
        () => new Trait({ couleur: COULEURS.gris, épaisseur: 1.5, pointillés: true, tiret: 0.1 }),
    );
    const cotes = départ.cotes.map(([i, tex]) => new Étiquette(tex, { couleur: COULEUR[i] }));
    const arcs = départ.arcs.map(([i, tex]) => new Arc(tex, { couleur: COULEUR[i] }));
    scène.ajoute(M, nomM, ...base, ...nomsBase, ...pointillés, ...cotes, ...arcs);

    function miseÀJour() {
        const q = enRadians(système, valeurs);
        const m = système.position(q);
        const vecteurs = système.base(q);
        M.position.copy(m);
        nomM.place(m);
        vecteurs.forEach((e, i) => {
            base[i].place(m, e, 1);
            nomsBase[i].place(m.clone().addScaledVector(e, 1.35));
        });
        const { pointillés: segments, cotes: positions, arcs: angles } = système.construction(q);
        segments.forEach((segment, k) => pointillés[k].trace(segment));
        positions.forEach(([, , position], k) => cotes[k].place(position));
        angles.forEach(([, , ...arc], k) => arcs[k].place(...arc));
        scène.redessine();
    }
    miseÀJour();
}

// -- Éléments de volume et de surface ---------------------------------------

/**
 * L'élément de volume, ou (`surface`) les éléments de surface : le domaine
 * où chaque coordonnée va de q à q + dq — la coordonnée `fixe` restant à q
 * pour une surface. Ses arêtes prennent la couleur de la coordonnée qui varie
 * le long d'elles, et celles qui partent du coin M portent leur longueur.
 */
function animationÉlément(section, système, surface) {
    const { scène, réglages } = nouvelleScène(section);
    const q = [...système.départ.élément];
    const dq = [...système.départ.accroissements];
    let fixe = système.départ.surface;

    let formule;
    if (surface) {
        réglages.groupe('Élément de surface orienté selon');
        réglages.choix({
            options: système.vecteurs.map((tex, i) => [i, tex]),
            valeur: fixe,
            auChangement: (i) => {
                fixe = Number(i);
                miseÀJour();
            },
        });
        formule = réglages.formule();
    } else {
        réglages.groupe('Volume élémentaire');
        formule = réglages.formule(système.volume);
    }
    réglages.groupe('Coin M de l’élément');
    curseurs(réglages, système, q, miseÀJour);
    réglages.groupe('Accroissements');
    const curseursAccroissements = curseurs(réglages, système, dq, miseÀJour, true);

    const faces = surface ? 1 : 6;
    const géométrie = géométrieDesFaces(faces);
    const élément = new THREE.Mesh(
        géométrie,
        new THREE.MeshStandardMaterial({
            color: '#a9bfdc',
            roughness: 0.85,
            transparent: true,
            opacity: 0.6,
            side: THREE.DoubleSide,
            depthWrite: false,
        }),
    );
    const arêtes = Array.from({ length: surface ? 4 : 12 }, () => new Trait({ épaisseur: 2.5 }));
    const cotes = système.arêtes.map(([tex], i) => new Étiquette(tex, { couleur: COULEUR[i] }));
    const coin = point(COULEURS.noir, 0.06);
    const nomCoin = new Étiquette('M', { décalage: '-0.9em -0.3em' });
    // Le vecteur surface, de la couleur de la coordonnée tenue constante :
    // une flèche par couleur, dont on ne montre qu'une.
    const normales = COULEUR.map((couleur) => new Flèche({ couleur, rayon: 0.03, largeur: 0.09 }));
    const nomNormale = new Étiquette('\\overrightarrow{\\mathrm{d}S}');
    scène.ajoute(élément, ...arêtes, ...cotes, coin, nomCoin);
    if (surface) scène.ajoute(...normales, nomNormale);

    function miseÀJour() {
        // Les coordonnées bornées (θ des sphériques) ne dépassent pas leur
        // maximum : au-delà du pôle, l'élément se replierait sur lui-même.
        const bornes = q.map((v, i) => {
            const c = système.coordonnées[i];
            return c.borné ? Math.min(v + dq[i], c.max) : v + dq[i];
        });
        const départ = enRadians(système, q);
        const arrivée = enRadians(système, bornes);
        // La i-ème coordonnée, à la fraction s de son intervalle.
        const entre = (i, s) => départ[i] + s * (arrivée[i] - départ[i]);
        // Les coordonnées qui varient sur l'élément ; la coordonnée fixe d'une
        // surface reste à q.
        const libres = [0, 1, 2].filter((i) => !surface || i !== fixe);
        const centre = système.position(départ.map((v, i) => (libres.includes(i) ? entre(i, 0.5) : v)));

        // Les faces : une coordonnée tenue à l'une de ses bornes — à q seulement
        // pour une surface —, les deux autres parcourant leur intervalle.
        let f = 0;
        for (const i of surface ? [fixe] : [0, 1, 2]) {
            const [j, k] = [0, 1, 2].filter((x) => x !== i);
            for (const tenue of surface ? [0] : [0, 1]) {
                remplitFace(géométrie, f++, (s, t) => {
                    const valeurs = [];
                    valeurs[i] = entre(i, tenue);
                    valeurs[j] = entre(j, s);
                    valeurs[k] = entre(k, t);
                    return système.position(valeurs);
                });
            }
        }
        géométrie.attributes.position.needsUpdate = true;
        géométrie.computeVertexNormals();
        géométrie.computeBoundingSphere();

        // Les arêtes : pour chaque coordonnée libre, les courbes où elle
        // parcourt son intervalle, les autres coordonnées libres à l'une ou
        // l'autre de leurs bornes. Celles où sa longueur est exacte peuvent
        // porter sa cote.
        let a = 0;
        for (const i of libres) {
            const autres = libres.filter((x) => x !== i);
            const dépend = système.arêtes[i][1];
            const candidates = [];
            for (const coins of autres.length === 2 ? [[0, 0], [0, 1], [1, 0], [1, 1]] : [[0], [1]]) {
                const courbe = Array.from({ length: N + 1 }, (_, p) => {
                    const valeurs = [...départ];
                    valeurs[i] = entre(i, p / N);
                    autres.forEach((k, m) => (valeurs[k] = entre(k, coins[m])));
                    return système.position(valeurs);
                });
                arêtes[a].material.color.set(COULEUR[i]);
                arêtes[a++].trace(courbe);
                if (autres.every((k, m) => !dépend.includes(k) || coins[m] === 0)) {
                    candidates.push([courbe[N / 2 - 1], courbe[N / 2 + 1]]);
                }
            }
            cotes[i].àCôté(candidates, centre);
        }
        cotes.forEach((cote, i) => (cote.visible = libres.includes(i)));

        const m = système.position(départ);
        coin.position.copy(m);
        nomCoin.place(m);

        if (surface) {
            const normal = système.base(départ.map((v, i) => (i === fixe ? v : entre(i, 0.5))))[fixe];
            normales.forEach((normale, i) => (normale.visible = i === fixe));
            normales[fixe].place(centre, normal, 1.2);
            nomNormale.place(centre.clone().addScaledVector(normal, 1.55));
            nomNormale.element.style.color = COULEUR[fixe];
            formule.écrit(`\\overrightarrow{\\mathrm{d}S} = ${système.surfaces[fixe]}\\;${système.vecteurs[fixe]}`);
            curseursAccroissements.forEach((c, i) => c.montre(i !== fixe));
        }
        scène.redessine();
    }
    miseÀJour();
}

/** Une géométrie de `faces` grilles de (N + 1) × (N + 1) sommets, que
 *  `remplitFace` met en place : les tampons ne changent jamais de taille. */
function géométrieDesFaces(faces) {
    const géométrie = new THREE.BufferGeometry();
    const sommets = (N + 1) * (N + 1);
    géométrie.setAttribute('position', new THREE.BufferAttribute(new Float32Array(3 * faces * sommets), 3));
    const indices = [];
    for (let f = 0; f < faces; f++) {
        for (let i = 0; i < N; i++) {
            for (let j = 0; j < N; j++) {
                const a = f * sommets + i * (N + 1) + j;
                const b = a + 1;
                const c = a + N + 2;
                const d = a + N + 1;
                indices.push(a, b, c, a, c, d);
            }
        }
    }
    géométrie.setIndex(indices);
    return géométrie;
}

/** La face `f`, image de (s, t) ∈ [0, 1]² par `nappe`. */
function remplitFace(géométrie, f, nappe) {
    const tampon = géométrie.attributes.position.array;
    let n = 3 * f * (N + 1) * (N + 1);
    for (let i = 0; i <= N; i++) {
        for (let j = 0; j <= N; j++) {
            nappe(i / N, j / N).toArray(tampon, n);
            n += 3;
        }
    }
}

lance('section.animation', (section) => {
    const système = SYSTÈMES[section.dataset.systeme];
    const animation = section.dataset.animation;
    if (animation === 'point') animationPoint(section, système);
    else animationÉlément(section, système, animation === 'surface');
});
