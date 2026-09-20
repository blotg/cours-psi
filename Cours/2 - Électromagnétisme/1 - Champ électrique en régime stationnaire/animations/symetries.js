// Symétries, antisymétries et invariances — les trois pages les plus
// difficiles à se figurer du chapitre, parce qu'elles demandent de voir dans
// l'espace une transformation que la figure du tableau réduit à un trait.
//
// Ce qui est fait ici pour s'en passer :
//
//   - le plan est une surface, quadrillée, et non une droite ; sa trace et
//     le pied de la perpendiculaire sont dessinés ;
//   - des vues toutes faites (de face, de côté, en perspective) dispensent
//     de faire tourner la scène pour comprendre ;
//   - la symétrie se joue au lieu de s'imaginer : un fantôme glisse de M
//     jusqu'à M′ en traversant le plan ;
//   - le vecteur est décomposé en sa part parallèle au plan (conservée) et
//     sa part normale (retournée), chacune de sa couleur ;
//   - le cas limite, M dans le plan, s'atteint au curseur, et la conclusion
//     s'écrit alors en toutes lettres ;
//   - on regarde toujours la distribution avant le champ : son image est
//     dessinée en fantôme, et c'est elle qui décide de tout.

import * as THREE from 'three';
import { COULEURS, Étiquette, Flèche, Trait, point, repère, vecteur, X, Y, Z } from '#animations/objets.js';
import { cadre, lance } from '#animations/page.js';
import { Réglages } from '#animations/reglages.js';
import { Scène } from '#animations/scene.js';

const COULEUR = {
    plan: COULEURS.violet,
    parallèle: COULEURS.vert,
    normale: COULEURS.orange,
    ici: COULEURS.noir,
    image: COULEURS.gris,
    positive: COULEURS.vermillon,
    négative: COULEURS.bleu,
};

const deg = THREE.MathUtils.degToRad;
const format = new Intl.NumberFormat('fr-FR', { maximumSignificantDigits: 3 });
const nombre = (x) => format.format(x).replace('−', '-').replace(',', '{,}');

/** Les vues toutes faites, communes aux trois scènes : le plan de face, le
 *  plan par la tranche, et la perspective de départ. */
const DÉPART = { position: [9, -11, 7], cible: [0, 0, 0] };

/** Le symétrique d'un vecteur (ou d'un point) par le plan de normale `n`
 *  passant par l'origine : la part parallèle reste, la part normale change
 *  de signe. */
const symétrique = (v, n) => v.clone().addScaledVector(n, -2 * v.dot(n));

/** Un plan de symétrie : une surface teintée, son quadrillage, et son bord.
 *  `oriente` le tourne pour lui donner la normale demandée. */
function planDeSymétrie(taille = 6) {
    const groupe = new THREE.Group();
    const surface = new THREE.Mesh(
        new THREE.PlaneGeometry(taille, taille).rotateX(-Math.PI / 2),
        new THREE.MeshBasicMaterial({
            color: COULEUR.plan,
            transparent: true,
            opacity: 0.1,
            side: THREE.DoubleSide,
            depthWrite: false,
            toneMapped: false,
        }),
    );
    const quadrillage = new THREE.GridHelper(taille, 6, COULEUR.plan, COULEUR.plan);
    quadrillage.material.transparent = true;
    quadrillage.material.opacity = 0.3;
    quadrillage.material.depthWrite = false;
    groupe.add(surface, quadrillage);
    groupe.oriente = (normale) => groupe.quaternion.setFromUnitVectors(Y, normale);
    return groupe;
}

/** Une flèche et son nom, qui se placent ensemble. */
function flèche(tex, couleur, options = {}) {
    const objet = new Flèche({ couleur, ...options });
    objet.nom = new Étiquette(tex, { couleur });
    objet.montre = (visible) => {
        objet.visible = visible;
        objet.nom.visible = visible;
        return objet;
    };
    objet.pose = (origine, v, échelle = 1) => {
        const longueur = v.length() * échelle;
        objet.place(origine, v.clone().normalize(), longueur);
        objet.nom.place(origine.clone().addScaledVector(v.clone().normalize(), longueur + 0.35));
        return objet;
    };
    return objet;
}

/** Les boutons de vue, sous la scène, et le repère sans lequel les curseurs
 *  ne nommeraient rien. */
function vues(scène, liste) {
    scène.ajoute(repère(3.6, ['x', 'y', 'z'], COULEURS.grisClair));
    for (const [texte, position] of liste) scène.bouton(texte, () => scène.regarde({ position, cible: [0, 0, 0] }));
}

// -- Le symétrique d'un vecteur ------------------------------------------------

function symétriqueDUnVecteur(section) {
    const { vue, réglages: panneau } = cadre(section);
    const scène = new Scène(vue, { rapport: 4 / 3, taille: 8.5, ...DÉPART });
    vues(scène, [
        ['Le plan de face', [0, -14, 0.01]],
        ['Le plan par la tranche', [-14, -0.5, 0.01]],
    ]);

    // Le plan de symétrie est le plan (xOz) : sa normale est ĵ, et la
    // distance de M au plan est son ordonnée.
    const NORMALE = Y;
    const état = { d: 1.8, u: [1.5, 1.2, 0.8], décompose: true, trajet: null };

    const plan = planDeSymétrie();
    plan.oriente(NORMALE);
    const nomDuPlan = new Étiquette('\\text{plan}', { couleur: COULEUR.plan }).place(vecteur(2.6, 0, 2.5));

    const points = {
        M: point(COULEUR.ici, 0.12),
        image: point(COULEUR.image, 0.12),
        pied: point(COULEUR.image, 0.07),
        fantôme: point(COULEUR.image, 0.1),
    };
    const noms = {
        M: new Étiquette('M', { couleur: COULEUR.ici }),
        image: new Étiquette("M'", { couleur: COULEUR.image }),
        d: new Étiquette('d', { couleur: COULEUR.image }),
        dImage: new Étiquette('d', { couleur: COULEUR.image }),
    };
    const perpendiculaire = new Trait({ couleur: COULEUR.image, épaisseur: 1.5, pointillés: true, tiret: 0.18 });

    const flèches = {
        u: flèche('\\vec{u}', COULEUR.ici, { dessus: true }),
        image: flèche("\\vec{u}\\,'", COULEUR.image, { dessus: true }),
        parallèle: flèche('\\vec{u}_\\parallel', COULEUR.parallèle),
        normale: flèche('\\vec{u}_\\perp', COULEUR.normale),
        parallèleImage: flèche('\\vec{u}_\\parallel', COULEUR.parallèle),
        normaleImage: flèche('-\\vec{u}_\\perp', COULEUR.normale),
        fantôme: flèche('', COULEUR.image, { dessus: true }),
    };
    scène.ajoute(
        plan,
        nomDuPlan,
        perpendiculaire,
        ...Object.values(points),
        ...Object.values(noms),
        ...Object.values(flèches).flatMap((f) => [f, f.nom]),
    );

    function place() {
        const M = vecteur(-1.2, état.d, 1.1);
        const image = symétrique(M, NORMALE);
        const pied = M.clone().addScaledVector(NORMALE, -M.dot(NORMALE));
        const u = vecteur(...état.u);
        const uNormale = NORMALE.clone().multiplyScalar(u.dot(NORMALE));
        const uParallèle = u.clone().sub(uNormale);

        points.M.position.copy(M);
        points.image.position.copy(image);
        points.pied.position.copy(pied);
        points.image.visible = état.d > 1e-6;
        points.pied.visible = état.d > 1e-6;
        perpendiculaire.visible = état.d > 1e-6;
        perpendiculaire.trace([M, image]);
        noms.M.place(M.clone().addScaledVector(NORMALE, 0.35));
        noms.image.place(image.clone().addScaledVector(NORMALE, -0.35));
        noms.d.place(M.clone().add(pied).multiplyScalar(0.5).add(vecteur(0.3, 0, 0)));
        noms.dImage.place(image.clone().add(pied).multiplyScalar(0.5).add(vecteur(0.3, 0, 0)));
        noms.d.visible = noms.dImage.visible = état.d > 0.3;

        flèches.u.pose(M, u);
        flèches.image.pose(image, symétrique(u, NORMALE));
        flèches.parallèle.pose(M, uParallèle).montre(état.décompose);
        flèches.normale.pose(M, uNormale).montre(état.décompose);
        flèches.parallèleImage.pose(image, uParallèle).montre(état.décompose);
        flèches.normaleImage.pose(image, uNormale.clone().negate()).montre(état.décompose);

        // Le fantôme, pendant que la symétrie se joue.
        const t = état.trajet;
        const enRoute = t !== null;
        points.fantôme.visible = enRoute;
        flèches.fantôme.montre(enRoute);
        if (enRoute) {
            const position = M.clone().lerp(image, t);
            points.fantôme.position.copy(position);
            flèches.fantôme.pose(position, u.clone().lerp(symétrique(u, NORMALE), t));
        }

        verdict.textContent =
            état.d > 1e-6
                ? 'M′ est de l’autre côté du plan, à la même distance. Le vecteur garde sa part parallèle au plan et retourne sa part normale.'
                : 'M est dans le plan : M′ = M. Le symétrique de u ne peut être u lui-même que si sa part normale est nulle — c’est-à-dire si u est contenu dans le plan.';
        scène.redessine();
    }

    /** La symétrie jouée : un fantôme glisse de M jusqu'à M′ en traversant
     *  le plan, et son vecteur se retourne en chemin. */
    function joue(dt) {
        état.trajet += dt / 1.6;
        if (état.trajet >= 1) {
            état.trajet = null;
            scène.àChaqueImage(null);
        }
        place();
    }

    // -- Réglages -------------------------------------------------------------

    const réglages = new Réglages(panneau);
    réglages.groupe('Le point M');
    réglages.curseur({
        tex: 'd',
        min: 0,
        max: 3,
        pas: 0.1,
        valeur: état.d,
        auChangement: (v) => {
            état.d = v;
            place();
        },
    });
    réglages.texte('Sa distance au plan. En 0, M est dans le plan.').className = 'note';
    réglages.bouton('Montrer la symétrie', () => {
        état.trajet = 0;
        scène.àChaqueImage(joue);
    });

    réglages.groupe('Le vecteur');
    for (const [k, tex, couleur] of [
        [0, 'u_x', COULEUR.parallèle],
        [1, 'u_y', COULEUR.normale],
        [2, 'u_z', COULEUR.parallèle],
    ]) {
        réglages.curseur({
            tex,
            min: -2,
            max: 2,
            pas: 0.1,
            valeur: état.u[k],
            couleur,
            auChangement: (v) => {
                état.u[k] = v;
                place();
            },
        });
    }
    réglages.texte(
        'Le plan est le plan (xOz) : x et z y sont parallèles (en vert), y lui est normal (en orange).',
    ).className = 'note';
    réglages.case({
        texte: 'Décomposer le vecteur',
        valeur: état.décompose,
        auChangement: (v) => {
            état.décompose = v;
            place();
        },
    });

    réglages.groupe('Ce qu’on lit');
    réglages.formule("\\vec{u}\\,' = \\vec{u}_\\parallel - \\vec{u}_\\perp");
    const verdict = réglages.texte();

    place();
}

// -- Plans de symétrie et d'antisymétrie ---------------------------------------

/** Le champ de charges ponctuelles, en unités où 1/(4πε₀) = 1. */
function champ(charges, M) {
    const E = vecteur();
    for (const charge of charges) {
        const d = M.clone().sub(charge.position);
        const r = d.length();
        if (r < 1e-6) continue;
        E.addScaledVector(d, charge.q / (r * r * r));
    }
    return E;
}

/** Ce que le plan est pour la distribution : la distribution image
 *  est-elle la distribution elle-même, son opposée, ou une autre ? */
function natureDuPlan(charges, normale) {
    let symétrie = true;
    let antisymétrie = true;
    for (const charge of charges) {
        const image = symétrique(charge.position, normale);
        const jumelle = charges.find((autre) => autre.position.distanceTo(image) < 1e-6);
        if (!jumelle || Math.abs(jumelle.q - charge.q) > 1e-6) symétrie = false;
        if (!jumelle || Math.abs(jumelle.q + charge.q) > 1e-6) antisymétrie = false;
    }
    return symétrie ? 'symétrie' : antisymétrie ? 'antisymétrie' : 'aucune';
}

/** Les deux plans remarquables de deux charges portées par l'axe (Oy) : leur
 *  plan médiateur, et un plan qui les contient. */
const PLANS = {
    médiateur: { normale: Y, base: X, origine: vecteur(0, 0, 1.3), nom: '\\text{plan médiateur}' },
    contenant: { normale: Z, base: X, origine: vecteur(0, 1.3, 0), nom: '\\text{plan des charges}' },
};

const DEMI_ÉCART = 1.6;

function plansDeSymétrie(section) {
    const { vue, réglages: panneau } = cadre(section);
    const scène = new Scène(vue, { rapport: 4 / 3, taille: 8.5, ...DÉPART });
    vues(scène, [
        ['Le plan de face', [0, -14, 0.01]],
        ['Le plan par la tranche', [-14, -0.5, 0.01]],
    ]);

    const état = { plan: 'médiateur', q2: 1, d: 1.6, s: -1.4 };
    const charges = [
        { position: vecteur(0, DEMI_ÉCART, 0), q: 1 },
        { position: vecteur(0, -DEMI_ÉCART, 0), q: 1 },
    ];

    const plan = planDeSymétrie();
    const nomDuPlan = new Étiquette('', { couleur: COULEUR.plan });

    // Les charges, et leurs images par le plan : une bille pleine pour la
    // charge, une sphère creuse pour son image. Si les deux se superposent
    // et sont de la même couleur, le plan est un plan de symétrie.
    const billes = charges.map(() => point(COULEUR.positive, 0.26));
    const fantômes = charges.map(
        () =>
            new THREE.Mesh(
                new THREE.SphereGeometry(0.5, 10, 6),
                new THREE.MeshBasicMaterial({ wireframe: true, transparent: true, opacity: 0.5, toneMapped: false }),
            ),
    );

    const points = { M: point(COULEUR.ici, 0.12), image: point(COULEUR.image, 0.12) };
    const noms = {
        M: new Étiquette('M', { couleur: COULEUR.ici }),
        image: new Étiquette("M'", { couleur: COULEUR.image }),
    };
    const perpendiculaire = new Trait({ couleur: COULEUR.image, épaisseur: 1.5, pointillés: true, tiret: 0.18 });
    const flèches = {
        E: flèche('\\vec{E}(M)', COULEUR.ici, { dessus: true }),
        EImage: flèche("\\vec{E}(M')", COULEUR.image, { dessus: true, rayon: 0.05, largeur: 0.14, tête: 0.3 }),
        symétrique: flèche('', COULEUR.plan, { dessus: true, rayon: 0.012, largeur: 0.05, tête: 0.18 }),
    };

    scène.ajoute(
        plan,
        nomDuPlan,
        perpendiculaire,
        ...billes,
        ...fantômes,
        ...Object.values(points),
        ...Object.values(noms),
        ...Object.values(flèches).flatMap((f) => [f, f.nom]),
    );

    function place() {
        const { normale, base, origine, nom } = PLANS[état.plan];
        charges[1].q = état.q2;
        plan.oriente(normale);
        nomDuPlan.écrit(nom).place(normale === Y ? vecteur(2.6, 0, 2.5) : vecteur(2.6, 2.5, 0));

        for (const [k, charge] of charges.entries()) {
            const couleur = charge.q >= 0 ? COULEUR.positive : COULEUR.négative;
            billes[k].position.copy(charge.position);
            billes[k].material.color.set(couleur);
            billes[k].visible = Math.abs(charge.q) > 1e-6;
            billes[k].scale.setScalar(0.6 + 0.4 * Math.min(2, Math.abs(charge.q)));
            // L'image de cette charge : là où le plan l'envoie, avec sa charge.
            fantômes[k].position.copy(symétrique(charge.position, normale));
            fantômes[k].material.color.set(couleur);
            fantômes[k].visible = billes[k].visible;
        }

        const M = origine.clone().addScaledVector(base, état.s).addScaledVector(normale, état.d);
        const image = symétrique(M, normale);
        points.M.position.copy(M);
        points.image.position.copy(image);
        points.image.visible = état.d > 1e-6;
        perpendiculaire.visible = état.d > 1e-6;
        perpendiculaire.trace([M, image]);
        noms.M.place(M.clone().addScaledVector(normale, 0.35));
        noms.image.place(image.clone().addScaledVector(normale, -0.35));

        // Les champs, à la même échelle : celle qui rend lisible le plus grand.
        const E = champ(charges, M);
        const EImage = champ(charges, image);
        const échelle = 1.6 / Math.max(0.2, E.length());
        flèches.E.pose(M, E, échelle).montre(E.length() > 1e-9);
        flèches.EImage.pose(image, EImage, échelle).montre(état.d > 1e-6 && EImage.length() > 1e-9);
        // Le symétrique de E(M), posé en M′ : c'est lui qu'on compare.
        flèches.symétrique.pose(image, symétrique(E, normale), échelle).montre(état.d > 1e-6);

        const nature = natureDuPlan(charges, normale);
        const dansLePlan = état.d <= 1e-6;
        nature_.écrit(
            {
                symétrie: '\\text{plan de symétrie}',
                antisymétrie: '\\text{plan d’antisymétrie}',
                aucune: '\\text{ni symétrie, ni antisymétrie}',
            }[nature],
        );
        relation.écrit(
            {
                symétrie: "\\vec{E}(M') = \\mathrm{sym}\\,\\vec{E}(M)",
                antisymétrie: "\\vec{E}(M') = -\\,\\mathrm{sym}\\,\\vec{E}(M)",
                aucune: '\\text{aucune relation imposée}',
            }[nature],
        );
        verdict.textContent = !dansLePlan
            ? {
                  symétrie:
                      'La distribution image est la distribution elle-même. Le champ en M′ est donc le symétrique du champ en M : la flèche violette tombe sur la grise.',
                  antisymétrie:
                      'La distribution image est l’opposée de la distribution. Le champ en M′ est l’opposé du symétrique du champ en M : la flèche violette est à l’opposé de la grise.',
                  aucune: 'La distribution image est une autre distribution : le plan n’impose rien au champ.',
              }[nature]
            : {
                  symétrie:
                      'M est dans le plan, donc M′ = M : le champ en M est son propre symétrique. Sa composante normale est nulle — le champ est contenu dans le plan de symétrie.',
                  antisymétrie:
                      'M est dans le plan, donc M′ = M : le champ en M est l’opposé de son symétrique. Sa composante parallèle est nulle — le champ est orthogonal au plan d’antisymétrie.',
                  aucune: 'M est dans le plan, mais le plan n’est ni de symétrie ni d’antisymétrie : rien n’est imposé.',
              }[nature];
        scène.redessine();
    }

    // -- Réglages -------------------------------------------------------------

    const réglages = new Réglages(panneau);
    réglages.groupe('Le plan');
    réglages.choix({
        options: [
            ['médiateur', '\\text{médiateur}'],
            ['contenant', '\\text{des charges}'],
        ],
        valeur: état.plan,
        auChangement: (v) => {
            état.plan = v;
            place();
        },
    });

    réglages.groupe('La distribution');
    réglages.curseur({
        tex: 'q_2',
        min: -2,
        max: 2,
        pas: 0.5,
        valeur: état.q2,
        auChangement: (v) => {
            état.q2 = v;
            place();
        },
    });
    réglages.texte(
        'La charge du bas ; celle du haut vaut q₁ = 1. En fil de fer, l’image de chaque charge par le plan : '  +
            'si les images redonnent la distribution, le plan en est un plan de symétrie ; si elles en donnent '  +
            'l’opposée, un plan d’antisymétrie.',
    ).className = 'note';
    const nature_ = réglages.formule();

    réglages.groupe('Le point M');
    for (const [clé, options] of [
        ['d', { tex: 'd', min: 0, max: 3, pas: 0.1 }],
        ['s', { tex: 's', min: -3, max: 3, pas: 0.1 }],
    ]) {
        réglages.curseur({
            ...options,
            valeur: état[clé],
            auChangement: (v) => {
                état[clé] = v;
                place();
            },
        });
    }
    réglages.texte('d est la distance de M au plan, s sa position le long du plan.').className = 'note';

    réglages.groupe('Ce qu’on lit');
    const relation = réglages.formule();
    const verdict = réglages.texte();

    place();
}

// -- Invariances ---------------------------------------------------------------

/** Trois distributions, et pour chacune : les coordonnées de M, celle dont le
 *  champ dépend, celles qui laissent la distribution inchangée, et ce que le
 *  cours en conclut. */
const DISTRIBUTIONS = {
    fil: {
        nom: 'Fil infini',
        variables: [
            { clé: 'r', tex: 'r', min: 0.7, max: 4, pas: 0.1, valeur: 2.2, dépend: true },
            { clé: 'θ', tex: '\\theta', min: 0, max: 360, pas: 1, valeur: 35, unité: '°' },
            { clé: 'z', tex: 'z', min: -3, max: 3, pas: 0.1, valeur: 1.2 },
        ],
        position: ({ r, θ, z }) => vecteur(r * Math.cos(deg(θ)), r * Math.sin(deg(θ)), z),
        champ: ({ r, θ }) => vecteur(Math.cos(deg(θ)), Math.sin(deg(θ)), 0).multiplyScalar(2.6 / r),
        formule: '\\vec{E} = E(r, \\cancel{\\theta}, \\cancel{z})\\;\\vec{e_r}',
        invariances: 'Invariante par translation le long de (Oz) et par rotation autour de (Oz) : le champ ne dépend ni de θ ni de z.',
    },
    plan: {
        nom: 'Plan infini',
        variables: [
            { clé: 'z', tex: 'z', min: -3.5, max: 3.5, pas: 0.1, valeur: 1.6, dépend: true },
            { clé: 'x', tex: 'x', min: -3.5, max: 3.5, pas: 0.1, valeur: -1.4 },
            { clé: 'y', tex: 'y', min: -3.5, max: 3.5, pas: 0.1, valeur: 1 },
        ],
        position: ({ x, y, z }) => vecteur(x, y, z),
        champ: ({ z }) => vecteur(0, 0, Math.sign(z) || 1).multiplyScalar(1.7),
        formule: '\\vec{E} = E(\\cancel{x}, \\cancel{y}, z)\\;\\vec{e_z}',
        invariances:
            'Invariant par toute translation parallèle au plan : le champ ne dépend ni de x ni de y. Il ne dépend même pas de z, sauf par son signe.',
    },
    boule: {
        nom: 'Boule',
        variables: [
            { clé: 'r', tex: 'r', min: 0.3, max: 4, pas: 0.1, valeur: 2.6, dépend: true },
            { clé: 'θ', tex: '\\theta', min: 0, max: 180, pas: 1, valeur: 55, unité: '°' },
            { clé: 'φ', tex: '\\varphi', min: 0, max: 360, pas: 1, valeur: 40, unité: '°' },
        ],
        position: ({ r, θ, φ }) =>
            vecteur(
                r * Math.sin(deg(θ)) * Math.cos(deg(φ)),
                r * Math.sin(deg(θ)) * Math.sin(deg(φ)),
                r * Math.cos(deg(θ)),
            ),
        champ: (v, distribution) => {
            const u = distribution.position(v).normalize();
            const { r } = v;
            // À l'intérieur de la boule, le champ croît avec r ; au dehors,
            // il décroît en 1/r².
            return u.multiplyScalar(r < 1.5 ? (3 * r) / 1.5 ** 2 : 3 / r ** 2);
        },
        formule: '\\vec{E} = E(r, \\cancel{\\theta}, \\cancel{\\varphi})\\;\\vec{e_r}',
        invariances: 'Invariante par toute rotation autour de son centre : le champ ne dépend ni de θ ni de φ.',
    },
};

function invariances(section) {
    const { vue, réglages: panneau } = cadre(section);
    const scène = new Scène(vue, { rapport: 4 / 3, taille: 11, ...DÉPART });
    vues(scène, [
        ['De face', [0, -14, 0.01]],
        ['De dessus', [0, -5, 12]],
    ]);

    const état = { distribution: 'fil', valeurs: {} };
    const corps = {
        fil: new THREE.Mesh(
            new THREE.CylinderGeometry(0.1, 0.1, 14, 16).rotateX(Math.PI / 2),
            new THREE.MeshBasicMaterial({ color: COULEUR.positive, toneMapped: false }),
        ),
        plan: new THREE.Mesh(
            new THREE.PlaneGeometry(11, 11),
            new THREE.MeshBasicMaterial({
                color: COULEUR.positive,
                transparent: true,
                opacity: 0.3,
                side: THREE.DoubleSide,
                toneMapped: false,
            }),
        ),
        boule: new THREE.Mesh(
            new THREE.SphereGeometry(1.5, 32, 20),
            new THREE.MeshBasicMaterial({ color: COULEUR.positive, transparent: true, opacity: 0.45, toneMapped: false }),
        ),
    };
    const M = point(COULEUR.ici, 0.13);
    const nomM = new Étiquette('M', { couleur: COULEUR.ici });
    const E = flèche('\\vec{E}(M)', COULEUR.ici, { dessus: true });
    const rayon = new Trait({ couleur: COULEUR.image, épaisseur: 1.2, pointillés: true, tiret: 0.15 });
    scène.ajoute(...Object.values(corps), M, nomM, E, E.nom, rayon);

    function place() {
        const distribution = DISTRIBUTIONS[état.distribution];
        for (const [clé, objet] of Object.entries(corps)) objet.visible = clé === état.distribution;
        const valeurs = état.valeurs[état.distribution];
        const position = distribution.position(valeurs);
        const champ = distribution.champ(valeurs, distribution);
        M.position.copy(position);
        nomM.place(position.clone().add(vecteur(0, 0, 0.4)));
        E.pose(position, champ, 1.1);
        // Le trait qui rappelle d'où se compte la variable dont le champ dépend.
        const pied =
            état.distribution === 'plan' ? vecteur(position.x, position.y, 0) : état.distribution === 'fil' ? vecteur(0, 0, position.z) : vecteur();
        rayon.trace([pied, position]);

        formule.écrit(distribution.formule);
        mesure.écrit(`\\lVert\\vec{E}\\rVert = ${nombre(champ.length())}`);
        scène.redessine();
    }

    // -- Réglages -------------------------------------------------------------

    const réglages = new Réglages(panneau);
    réglages.groupe('Distribution');
    const curseurs = {};
    réglages.choix({
        options: Object.entries(DISTRIBUTIONS).map(([clé, d]) => [clé, `\\text{${d.nom.toLowerCase()}}`]),
        valeur: état.distribution,
        auChangement: (v) => {
            état.distribution = v;
            for (const [clé, liste] of Object.entries(curseurs)) {
                for (const curseur of liste) curseur.montre(clé === v);
            }
            note.textContent = DISTRIBUTIONS[v].invariances;
            place();
        },
    });

    réglages.groupe('Le point M');
    for (const [clé, distribution] of Object.entries(DISTRIBUTIONS)) {
        état.valeurs[clé] = Object.fromEntries(distribution.variables.map((v) => [v.clé, v.valeur]));
        curseurs[clé] = distribution.variables.map((variable) => {
            const curseur = réglages.curseur({
                ...variable,
                couleur: variable.dépend ? COULEUR.normale : COULEUR.parallèle,
                auChangement: (v) => {
                    état.valeurs[clé][variable.clé] = v;
                    place();
                },
            });
            curseur.montre(clé === état.distribution);
            return curseur;
        });
    }
    réglages.texte(
        'En orange, la variable dont le champ dépend : elle seule change sa norme. En vert, celles que la ' +
            'distribution laisse indifférentes — les faire varier ne change rien à la norme du champ.',
    ).className = 'note';

    réglages.groupe('Ce qu’on lit');
    const mesure = réglages.formule();
    const formule = réglages.formule();
    const note = réglages.texte(DISTRIBUTIONS[état.distribution].invariances);

    place();
}

const ANIMATIONS = { vecteur: symétriqueDUnVecteur, plans: plansDeSymétrie, invariances };

lance('section.animation', (section) => ANIMATIONS[section.dataset.animation](section));
