// La machine synchrone diphasée et bipolaire du cours, en fonctionnement.
//
// Dans l'entrefer, les deux champs, en flèches radiales dont la longueur suit
// leur valeur : le champ statorique B_s, créé par les courants i₁ = I cos(ωt)
// et i₂ = I cos(ωt + π/2), et le champ rotorique B_r, créé par le courant
// continu I_e du rotor. Chaque circuit a N spires, dans N encoches de part et
// d'autre de son axe : ses champs sont en marches — le théorème d'Ampère les
// fait sauter d'un cran à chaque conducteur. Quand N → ∞, ils tendent vers
// ceux du cours : B_s ∝ cos(ωt − θ), le champ glissant, et B_r ∝ cos(θ − θ_r).
// Le curseur de N finit sur cette limite.
//
// Le rotor tourne au synchronisme : θ_r = ωt − α, l'angle α entre le maximum
// du champ glissant et l'axe du rotor reste constant, et le couple vaut
// Γ_ém = Γ_max sin α.
//
// Une seconde animation donne au rotor son inertie et une charge à entraîner :
// α n'est plus un réglage, il s'ajuste au couple résistant — jusqu'à ce que
// celui-ci dépasse Γ_max, et que le moteur décroche.

import * as THREE from 'three';
import { Graphe, échantillons } from '#animations/graphe.js';
import { Arc, COULEURS, Étiquette, Flèche, Trait, vecteur } from '#animations/objets.js';
import { cadre, lance } from '#animations/page.js';
import { Réglages } from '#animations/reglages.js';
import { COULEUR_CHARGE, chronogramme, fraction, tourne, virgule } from './charge.js';
import { Courant, R_ARBRE, R_ENTREFER, R_ROTOR, R_STATOR, angleSigné, machine, scèneDeMachine } from './machine.js';

/** Une couleur par circuit — celle de ses fils, de son courant, et du champ
 *  qu'il crée seul —, et une par champ total. */
const COULEUR = {
    1: '#1e9a3c',
    2: COULEURS.bleu,
    rotor: COULEURS.vermillon,
    Bs: COULEURS.violet,
    Br: COULEURS.orange,
};

const deg = THREE.MathUtils.degToRad;
/** Une graduation en degrés, et celles d'un tour. */
const degrés = (a) => [a, a ? `${a}^\\circ` : '0'];
const TOUR = [0, 90, 180, 270, 360].map(degrés);
const DEUX_PI = 2 * Math.PI;
const direction = (a) => vecteur(Math.cos(a), Math.sin(a), 0);

/** Ce qui se dessine par-dessus le plan de coupe, juste devant lui, et les
 *  étiquettes qui ne se lisent que devant lui. */
const Z_SCHÉMA = 0.03;
const DEVANT = vecteur(0, 0, 1);
/** Des flèches de champ tous les 10° pour chaque champ, celles des uns
 *  entre celles des autres : aucune ne tombe sur une autre. */
const FLÈCHES = 36;
/** L'amplitude de la limite sinusoïdale de chaque champ, celle de B_s pour
 *  unité. Rien ne lie les deux : B_s suit I_s, B_r suit I_e. */
const AMPLITUDE = { Bs: 1, Br: 0.6 };
/** La longueur d'une flèche pour un champ égal à l'amplitude de B_s. */
const LONGUEUR_MAX = 0.85;
/** Les points du contour qui relie les pointes des flèches. */
const ÉCHANTILLONS = 720;
const N_DÉPART = 5;
/** Le plus grand nombre d'encoches dessinées ; le cran suivant du curseur est
 *  la limite N → ∞. */
const N_MAX = 20;

const VUE = { taille: 12.6, troisQuarts: { position: [9, 14, 26], cible: [0, 0.3, -1.5] } };

/**
 * Le champ dans l'entrefer en θ, créé par des conducteurs parcourus par
 * `courant(c)` (positif s'il sort du plan de coupe) : quand on franchit un
 * conducteur dans le sens trigonométrique, le champ baisse de son courant
 * (théorème d'Ampère), et il est de moyenne nulle (conservation du flux).
 * Les courants d'un circuit étant de somme nulle, cela donne
 * B(θ) = Σ I_c · frac((θ − θ_c) / 2π). `décalage` tourne les conducteurs :
 * ceux du rotor, de θ_r.
 */
function champEnMarches(conducteurs, courant, θ, décalage = 0) {
    let B = 0;
    for (const c of conducteurs) B += courant(c) * THREE.MathUtils.euclideanModulo((θ - c.angle - décalage) / DEUX_PI, 1);
    return B;
}

/** Le même champ, marche par marche : les points [θ, B] de sa courbe, de 0 à
 *  2π, qui saute d'un coup à chaque conducteur. */
function marches(conducteurs, courant, décalage = 0) {
    const sauts = conducteurs.map((c) => THREE.MathUtils.euclideanModulo(c.angle + décalage, DEUX_PI));
    const bornes = [0, ...sauts.sort((a, b) => a - b), DEUX_PI];
    return bornes.slice(1).flatMap((fin, k) => {
        const B = champEnMarches(conducteurs, courant, (bornes[k] + fin) / 2, décalage);
        return [
            [bornes[k], B],
            [fin, B],
        ];
    });
}

// -- Ce que les deux animations dessinent ----------------------------------------

/**
 * Monte dans la scène la machine à `encoches` encoches par côté de chaque
 * circuit, et le sens des courants sur la section de ses conducteurs.
 * `démonte` l'en retire et rend sa mémoire.
 */
function monte(scène, encoches) {
    const modèle = machine(encoches, { 1: COULEUR[1], 2: COULEUR[2], rotor: COULEUR.rotor });
    const symboles = [];
    for (const partie of ['stator', 'rotor']) {
        const disque = new THREE.CircleGeometry(modèle.symboles[partie], 32);
        for (const c of modèle.conducteurs[partie]) {
            const symbole = new Courant(COULEUR[c.circuit], disque);
            symbole.position.copy(direction(c.angle).multiplyScalar(c.rayon)).setZ(0.01);
            modèle.enroulements[partie].add(symbole);
            symboles.push({ symbole, c });
        }
    }
    scène.ajoute(modèle.stator, modèle.rotor);
    return {
        modèle,
        symboles,
        démonte() {
            scène.scène.remove(modèle.stator, modèle.rotor);
            modèle.libère();
            for (const { symbole } of symboles) symbole.material.dispose();
        },
    };
}

/** Le nom des bandes de conducteurs des circuits statoriques. */
function nomsDesBandes() {
    return new THREE.Group().add(
        ...[
            ['1', 90, 1],
            ["1'", 270, 1],
            ['2', 0, 2],
            ["2'", 180, 2],
        ].map(([tex, a, circuit]) =>
            new Étiquette(tex, { couleur: COULEUR[circuit], face: DEVANT }).place(
                direction(deg(a)).multiplyScalar(R_STATOR + 0.55),
            ),
        ),
    );
}

/** Les pôles du rotor, à faire tourner avec lui. */
function nomsDesPôles() {
    return new THREE.Group().add(
        new Étiquette('\\mathrm{N}', { couleur: COULEURS.gris, face: DEVANT }).place(vecteur(1.55, 0, Z_SCHÉMA)),
        new Étiquette('\\mathrm{S}', { couleur: COULEURS.gris, face: DEVANT }).place(vecteur(-1.55, 0, Z_SCHÉMA)),
    );
}

/**
 * Un champ dans l'entrefer : ses flèches, tous les 10°, décalées de
 * `décalage` pas pour ne pas tomber sur celles d'un autre champ, et le
 * contour qui relie leurs pointes — fin et translucide : ce sont les flèches
 * qu'on lit. `dessineChamp` le met à jour.
 */
function champDEntrefer(couleur, décalage, visible = true) {
    const flèches = Array.from({ length: FLÈCHES }, (_, k) => ({
        θ: (DEUX_PI * (k + décalage)) / FLÈCHES,
        flèche: new Flèche({ couleur, rayon: 0.026, tête: 0.18, largeur: 0.07 }),
    }));
    const contour = new Trait({ couleur, épaisseur: 1.2, opacité: 0.5 });
    const groupe = new THREE.Group().add(...flèches.map((f) => f.flèche), contour);
    groupe.visible = visible;
    return { flèches, contour, groupe, visible };
}

/** Les deux rayons en pointillés — l'axe du rotor et le maximum du champ
 *  glissant —, et l'arc de l'angle α qui va de l'un à l'autre. */
function angleInterne() {
    const axeRotor = new Trait({ couleur: COULEUR.rotor, épaisseur: 2, pointillés: true, tiret: 0.15 });
    const maximumBs = new Trait({ couleur: COULEUR.Bs, épaisseur: 2, pointillés: true, tiret: 0.15 });
    const arc = new Arc('\\alpha', { face: DEVANT });
    const rayon = (a) => [R_ARBRE + 0.15, R_ROTOR - 0.1].map((r) => direction(a).multiplyScalar(r).setZ(Z_SCHÉMA));
    return {
        objets: [axeRotor, maximumBs, arc],
        /** Le rotor en θr, le maximum du champ glissant en ωt : α va de l'un
         *  à l'autre, par le plus court si on ne le donne pas. */
        place(θr, ωt, α = angleSigné(ωt - θr)) {
            axeRotor.trace(rayon(θr));
            maximumBs.trace(rayon(ωt));
            arc.place(vecteur(0, 0, Z_SCHÉMA), direction(θr), direction(θr + Math.PI / 2), α, 2.05);
        },
    };
}

// -- Champ glissant et champ rotorique ---------------------------------------------

function machineSynchrone(section) {
    const { vue, réglages: panneau } = cadre(section);
    const scène = scèneDeMachine(vue, VUE);

    const état = {
        N: N_DÉPART,
        ωt: 0,
        α: 45,
        f: 0.15,
        pause: false,
        conducteurs: true,
    };

    // La machine, reconstruite quand N change, et le sens des courants sur
    // la section de ses conducteurs.
    let montage = null;
    let modèle = null;
    let symboles = [];
    // Le nombre d'encoches dessinées : N, ou N_MAX à la limite N → ∞.
    let encoches = 0;
    function construis() {
        montage?.démonte();
        encoches = Math.min(état.N, N_MAX);
        montage = monte(scène, encoches);
        ({ modèle, symboles } = montage);
        modèle.montreLesConducteurs(état.conducteurs);
    }
    construis();

    // Le nom des bandes de conducteurs des circuits statoriques, et les pôles
    // du rotor, qui tournent avec lui.
    const bandes = nomsDesBandes();
    const pôles = nomsDesPôles();

    // Les champs dans l'entrefer. Chaque champ a ses flèches, décalées d'un
    // quart de pas de celles du suivant.
    const champs = {
        Bs: champDEntrefer(COULEUR.Bs, 0),
        1: champDEntrefer(COULEUR[1], 0.25, false),
        2: champDEntrefer(COULEUR[2], 0.75, false),
        Br: champDEntrefer(COULEUR.Br, 0.5),
    };

    // L'angle α, du rotor au maximum du champ glissant, et le couple.
    const schéma = new THREE.Group();
    const angle = angleInterne();
    const arcΓ = new Arc('\\Gamma_{\\text{ém}}', { face: DEVANT });
    schéma.add(...angle.objets, arcΓ, pôles);
    scène.ajoute(bandes, ...Object.values(champs).map((champ) => champ.groupe), schéma);

    // -- Réglages --------------------------------------------------------------

    // Le panneau est plus haut que la scène : ses groupes se replient, et
    // ceux qui ne servent qu'à l'occasion le sont au départ.
    const réglages = new Réglages(panneau, { rétractables: true });

    réglages.groupe('Courants statoriques');
    const courants = new Graphe({
        x: { min: 0, max: 360, nom: '\\omega t', graduations: TOUR },
        y: {
            min: -1.15,
            max: 1.15,
            nom: `{\\color{${COULEUR[1]}} i_1}, {\\color{${COULEUR[2]}} i_2}`,
            graduations: [
                [1, 'I'],
                [-1, '-I'],
            ],
        },
    });
    courants.trace((x) => Math.cos(deg(x)), { couleur: COULEUR[1] });
    courants.trace((x) => Math.cos(deg(x) + Math.PI / 2), { couleur: COULEUR[2] });
    const curseurTemps = courants.verticale();
    const points = [1, 2].map((circuit) => courants.point({ couleur: COULEUR[circuit] }));
    réglages.ajoute(courants.élément);
    réglages.formule(
        `\\begin{gathered} {\\color{${COULEUR[1]}} i_1 = I\\cos(\\omega t)} \\\\ ` +
            `{\\color{${COULEUR[2]}} i_2 = I\\cos(\\omega t + \\pi/2)} \\end{gathered}`,
    );
    réglages.texte(
        'Dans les encoches, ⊙ : le courant sort du plan de coupe, ⊗ : il y entre ; le symbole pâlit avec ' +
            'l’intensité. En vert le circuit statorique 1 (conducteurs 1 et 1′), en bleu le circuit 2 (2 et 2′), ' +
            'en rouge le circuit rotorique, parcouru par le courant continu Iₑ.',
    ).className = 'note';

    réglages.groupe('Fonctionnement');
    réglages.curseur({
        tex: '\\alpha',
        min: -180,
        max: 180,
        pas: 1,
        valeur: état.α,
        unité: '°',
        auChangement: (v) => (état.α = v),
    });
    réglages.curseur({
        tex: 'f',
        min: 0.05,
        max: 1,
        pas: 0.05,
        valeur: état.f,
        unité: ' Hz',
        auChangement: (v) => (état.f = v),
    });
    const pause = réglages.bouton('Pause', () => {
        état.pause = !état.pause;
        pause.textContent = état.pause ? 'Reprendre' : 'Pause';
    });

    réglages.groupe('Enroulements');
    // Le dernier cran du curseur est la limite N → ∞ : les champs y sont
    // sinusoïdaux, la machine garde ses N_MAX encoches.
    réglages.curseur({
        tex: 'N',
        min: 1,
        max: N_MAX + 1,
        pas: 1,
        valeur: état.N,
        formate: (v) => (v > N_MAX ? '∞' : String(v)),
        auChangement: (v) => {
            état.N = v > N_MAX ? Infinity : v;
            if (Math.min(état.N, N_MAX) !== encoches) construis();
        },
    });

    // Le graphique des champs, en fonction de θ : ceux qui sont cochés.
    const champsEnθ = new Graphe({
        x: { min: 0, max: 360, nom: '\\theta', graduations: TOUR },
        y: {
            // Pour N = 1, B_s monte jusqu'à √2 : les créneaux des deux
            // circuits s'ajoutent.
            min: -1.5,
            max: 1.5,
            nom: `{\\color{${COULEUR.Bs}} B_s}, {\\color{${COULEUR.Br}} B_r}`,
            graduations: [
                [AMPLITUDE.Bs, `{\\color{${COULEUR.Bs}} B_{s,\\max}}`],
                [AMPLITUDE.Br, `{\\color{${COULEUR.Br}} B_{r,\\max}}`],
                [-AMPLITUDE.Br, `{\\color{${COULEUR.Br}} -B_{r,\\max}}`],
                [-AMPLITUDE.Bs, `{\\color{${COULEUR.Bs}} -B_{s,\\max}}`],
            ],
        },
        hauteur: 170,
    });
    // Les champs des circuits sous les champs totaux, en trait plus fin.
    for (const nom of [1, 2, 'Bs', 'Br']) {
        const total = typeof nom === 'string';
        champs[nom].courbe = champsEnθ.courbe({
            couleur: COULEUR[nom],
            épaisseur: total ? 2 : 1.2,
            visible: champs[nom].visible,
        });
    }

    réglages.groupe('Afficher');
    const montre = (objets) => (visible) => {
        objets.forEach((o) => (o.visible = visible));
        scène.redessine();
    };
    // Un champ décoché quitte la scène et le graphique.
    for (const [nom, texte, tex] of [
        ['Bs', 'Champ statorique ', 'B_s'],
        [1, 'Champ du circuit 1 ', 'B_{s1}'],
        [2, 'Champ du circuit 2 ', 'B_{s2}'],
        ['Br', 'Champ rotorique ', 'B_r'],
    ]) {
        const champ = champs[nom];
        réglages.case({
            texte,
            tex,
            couleur: COULEUR[nom],
            valeur: champ.visible,
            auChangement: (visible) => {
                champ.visible = champ.groupe.visible = visible;
                champ.courbe.montre(visible);
                scène.redessine();
            },
        });
    }
    // Sans ses conducteurs — ni leurs encoches, ni le sens de leurs
    // courants, ni leurs noms —, la machine laisse voir les champs seuls.
    réglages.case({
        texte: 'Conducteurs',
        auChangement: (visible) => {
            état.conducteurs = visible;
            modèle.montreLesConducteurs(visible);
            montre([bandes])(visible);
        },
    });
    réglages.case({ texte: 'Angle α et couple', auChangement: montre([schéma]) });

    réglages.groupe('Champs dans l’entrefer');
    réglages.ajoute(champsEnθ.élément);
    réglages.texte(
        'Rien ne lie les amplitudes des deux champs : celle du champ statorique suit l’amplitude I des ' +
            'courants statoriques, celle du champ rotorique le courant d’excitation Iₑ.',
    ).className = 'note';

    réglages.groupe('Couple électromagnétique', { ouvert: false });
    réglages.formule('\\Gamma_{\\text{ém}} = \\Gamma_{\\max} \\sin\\alpha');
    const couple = new Graphe({
        x: { min: -180, max: 180, nom: '\\alpha', graduations: [-180, -90, 0, 90, 180].map(degrés) },
        y: {
            min: -1.15,
            max: 1.15,
            nom: '\\Gamma_{\\text{ém}}',
            graduations: [
                [1, '\\Gamma_{\\max}'],
                [-1, '-\\Gamma_{\\max}'],
            ],
        },
        hauteur: 150,
    });
    // La zone stable, |α| < 90° : le couple y croît avec α. Le signe de α
    // sépare les deux fonctionnements, de part et d'autre du pointillé.
    couple.zone().place(-90, 90);
    couple.verticale({ couleur: COULEURS.noir }).place(0);
    couple.légende('\\text{générateur}', { x: -90, y: 1.3, couleur: COULEURS.noir });
    couple.légende('\\text{moteur}', { x: 90, y: 1.3, couleur: COULEURS.noir });
    // Chaque zone nommée là où la courbe n'est pas : du côté opposé au signe
    // du couple.
    for (const [α, y, tex] of [
        [-135, 0.55, 'instable'],
        [-45, 0.55, 'stable'],
        [45, -0.55, 'stable'],
        [135, -0.55, 'instable'],
    ]) {
        couple.légende(`\\text{${tex}}`, { x: α, y });
    }
    couple.trace((α) => Math.sin(deg(α)), { couleur: COULEURS.noir });
    const pointCouple = couple.point({ couleur: COULEURS.noir });
    réglages.ajoute(couple.élément);
    const bilan = réglages.texte();

    // -- À chaque image ----------------------------------------------------------

    scène.àChaqueImage((dt) => {
        if (!état.pause) état.ωt += DEUX_PI * état.f * dt;
        // Au synchronisme, le rotor garde son retard α sur le champ glissant.
        const ωt = état.ωt;
        const θr = ωt - deg(état.α);
        const i = { 1: Math.cos(ωt), 2: Math.cos(ωt + Math.PI / 2), rotor: 1 };

        modèle.rotor.rotation.z = θr;
        pôles.rotation.z = θr;
        for (const { symbole, c } of symboles) symbole.montre(c.sens * i[c.circuit]);

        // Chaque conducteur porte 2/N du courant de son circuit : la limite
        // sinusoïdale a pour amplitude 1, quel que soit N.
        const poids = 2 / encoches;
        const { stator, rotor } = modèle.conducteurs;
        const courantStator = (c) => poids * AMPLITUDE.Bs * c.sens * i[c.circuit];
        const courantRotor = (c) => poids * AMPLITUDE.Br * c.sens;
        const duCircuit = (n) => stator.filter((c) => c.circuit === n);
        // Ce qui crée chaque champ : ses conducteurs, leur courant, et l'angle
        // dont ils ont tourné.
        const sources = {
            Bs: [stator, courantStator, 0],
            1: [duCircuit(1), courantStator, 0],
            2: [duCircuit(2), courantStator, 0],
            Br: [rotor, courantRotor, θr],
        };
        // Leur limite quand N → ∞, celle du cours. Chaque circuit seul donne
        // B_s1 ∝ i₁ cos θ et B_s2 ∝ i₂ cos(θ + π/2), son axe étant en
        // θ = −90° ; leur somme est le champ glissant.
        const sinusoïdes = {
            Bs: (θ) => AMPLITUDE.Bs * Math.cos(ωt - θ),
            1: (θ) => AMPLITUDE.Bs * i[1] * Math.cos(θ),
            2: (θ) => AMPLITUDE.Bs * i[2] * Math.cos(θ + Math.PI / 2),
            Br: (θ) => AMPLITUDE.Br * Math.cos(θ - θr),
        };
        const infini = état.N === Infinity;
        // Les mêmes champs sur le graphique, θ en degrés.
        const enDegrés = (points) => points.map(([θ, B]) => [THREE.MathUtils.radToDeg(θ), B]);
        for (const [nom, champ] of Object.entries(champs)) {
            if (!champ.visible) continue;
            const [conducteurs, courant, décalage] = sources[nom];
            const B = infini ? sinusoïdes[nom] : (θ) => champEnMarches(conducteurs, courant, θ, décalage);
            dessineChamp(champ, B);
            champ.courbe.place(
                enDegrés(
                    infini
                        ? échantillons(0, DEUX_PI, 120).map((θ) => [θ, B(θ)])
                        : marches(conducteurs, courant, décalage),
                ),
            );
        }

        angle.place(θr, ωt, deg(état.α));
        // Le couple, en arc autour de l'arbre : dans le sens de rotation
        // quand il entraîne le rotor.
        const Γ = Math.sin(deg(état.α));
        arcΓ.place(vecteur(0, 0, Z_SCHÉMA), direction(θr + Math.PI), direction(θr + (3 * Math.PI) / 2), 1.7 * Γ, 1.05);

        pointCouple.place(état.α, Γ);
        const t = THREE.MathUtils.radToDeg(THREE.MathUtils.euclideanModulo(ωt, DEUX_PI));
        curseurTemps.place(t);
        points.forEach((p, k) => p.place(t, i[k + 1]));
        const texte = régime(état.α);
        if (bilan.textContent !== texte) bilan.textContent = texte;
    });
}

/**
 * Un champ dans l'entrefer : ses flèches, radiales, vers l'extérieur s'il est
 * positif, partant du milieu de l'entrefer, et le contour qui relie leurs
 * pointes.
 */
function dessineChamp({ flèches, contour }, champ) {
    for (const { θ, flèche } of flèches) {
        const valeur = champ(θ);
        const e = direction(θ);
        const origine = e.clone().multiplyScalar(R_ENTREFER).setZ(Z_SCHÉMA);
        flèche.place(origine, e.multiplyScalar(Math.sign(valeur) || 1), LONGUEUR_MAX * Math.abs(valeur));
    }
    contour.trace(autour(champ));
}

/** Le contour d'un champ `f(θ)` dans l'entrefer : la courbe qui relie les
 *  pointes de ses flèches. */
function autour(f) {
    return Array.from({ length: ÉCHANTILLONS + 1 }, (_, k) => {
        const θ = (DEUX_PI * k) / ÉCHANTILLONS;
        return direction(θ).multiplyScalar(R_ENTREFER + LONGUEUR_MAX * f(θ)).setZ(Z_SCHÉMA);
    });
}

/** Ce que le cours dit du régime de fonctionnement. */
function régime(α) {
    if (α === 0) return 'α = 0 : le couple est nul, la machine tourne à vide.';
    const sens =
        α > 0
            ? 'Moteur (α > 0) : le champ glissant est en avance sur le rotor'
            : 'Générateur (α < 0) : le rotor est en avance sur le champ glissant';
    const stabilité =
        Math.abs(α) < 90 ? 'fonctionnement stable.' : 'fonctionnement instable, le rotor décroche si la charge augmente.';
    return `${sens} ; ${stabilité}`;
}

// -- Le moteur en charge -------------------------------------------------------------

/**
 * Le moteur entraîne une charge qui lui oppose le couple Γ_r. Les courants
 * statoriques ont la pulsation ω, que l'on règle : le champ statorique tourne
 * à ω, quoi que fasse le rotor. Celui-ci, de moment d'inertie J, suit le
 * théorème du moment cinétique,
 *     J dΩ/dt = Γ_max sin α − Γ_r,    avec dα/dt = ω − Ω.
 * Les couples se comptent en Γ_max, les pulsations en rad/s. La machine est
 * celle du cours, à la limite N → ∞ : champs sinusoïdaux, conducteurs cachés.
 */
const CHARGE = {
    /** La pulsation des courants au départ — près d'un tour de champ par
     *  seconde : l'œil le suit — et la plus grande que propose le curseur. */
    ω: 6,
    ωMax: 10,
    /** La pulsation √(Γ_max/J) des petites oscillations de α. Elle fixe ce
     *  que le rotor peut suivre : à vide, il n'accélère pas de plus de
     *  `propre`² rad/s², et, arrêté, il ne s'accroche de lui-même au champ
     *  statorique que si ω est assez petite (sous 3 rad/s environ pour
     *  Γ_r = 0,3 Γ_max). Au-delà, le couple change de signe avant que le
     *  rotor ait pris de la vitesse : il vibre sur place. On démarre donc le
     *  moteur en partant d'une petite ω, que l'on monte peu à peu. */
    propre: 1.9,
    /** Sans amortissement, α oscillerait sans fin autour de son équilibre.
     *  Une machine réelle a des amortisseurs — une cage dans le rotor —, qui
     *  exercent un couple proportionnel au glissement ω − Ω près du
     *  synchronisme : `ζ` est le taux d'amortissement qu'ils donnent. Loin
     *  du synchronisme, leur couple s'efface : au-delà du glissement
     *  `fenêtre`, il est nul, et le rotor décroché ne repart pas. */
    ζ: 0.5,
    fenêtre: 3,
    /** Sous ce glissement, tenu deux secondes, le rotor est accroché. */
    synchrone: 0.05,
    /** Ce que retient le chronogramme, en secondes. */
    durée: 20,
    /** La longueur de l'arc d'un couple égal à Γ_max, en radians. */
    arc: 1.7,
};

function décrochage(section) {
    const { vue, réglages: panneau } = cadre(section);
    const scène = scèneDeMachine(vue, VUE);
    const ω0 = CHARGE.propre;

    const état = { Γr: 0.3, ω: CHARGE.ω, ωt: 0, θr: 0, Ω: 0, pause: false, décroché: false, calme: 0 };
    /** Le rotor au synchronisme, à l'angle α d'équilibre — s'il y en a un. */
    function synchronise() {
        état.ωt = THREE.MathUtils.euclideanModulo(état.ωt, DEUX_PI);
        état.θr = état.ωt - Math.asin(Math.min(état.Γr, 1));
        état.Ω = état.ω;
        état.décroché = false;
    }
    synchronise();

    // La machine sans ses conducteurs : un stator et un rotor lisses, et les
    // deux champs.
    const modèle = machine(1, { 1: COULEUR[1], 2: COULEUR[2], rotor: COULEUR.rotor });
    modèle.montreLesConducteurs(false);
    const pôles = nomsDesPôles();
    const champs = { Bs: champDEntrefer(COULEUR.Bs, 0), Br: champDEntrefer(COULEUR.Br, 0.5) };
    const angle = angleInterne();
    // Les deux couples, en arcs autour de l'arbre : celui du moteur dans le
    // sens de rotation, celui de la charge en face, dans l'autre sens.
    const arcΓ = new Arc('\\Gamma_{\\text{ém}}', { face: DEVANT });
    const arcΓr = new Arc('\\Gamma_r', { couleur: COULEUR_CHARGE, face: DEVANT });
    scène.ajoute(modèle.stator, modèle.rotor, champs.Bs.groupe, champs.Br.groupe, ...angle.objets, arcΓ, arcΓr, pôles);

    // -- Réglages --------------------------------------------------------------

    const réglages = new Réglages(panneau);

    réglages.groupe('Fonctionnement');
    fraction(
        réglages.curseur({
            tex: '\\dfrac{\\Gamma_r}{\\Gamma_{\\max}}',
            couleur: COULEUR_CHARGE,
            min: 0,
            max: 1.5,
            pas: 0.01,
            valeur: état.Γr,
            auChangement: (v) => (état.Γr = v),
        }),
    );
    réglages.curseur({
        tex: '\\omega',
        couleur: COULEUR.Bs,
        min: 0,
        max: CHARGE.ωMax,
        pas: 0.1,
        valeur: état.ω,
        unité: ' rad/s',
        auChangement: (v) => (état.ω = v),
    });
    const pause = réglages.bouton('Pause', () => {
        état.pause = !état.pause;
        pause.textContent = état.pause ? 'Reprendre' : 'Pause';
    });
    const relance = réglages.bouton('Relancer au synchronisme', synchronise);
    relance.style.marginLeft = '0.4rem';

    réglages.groupe('Couple');
    réglages.formule('J\\,\\frac{\\mathrm{d}\\Omega}{\\mathrm{d}t} = \\Gamma_{\\max}\\sin\\alpha - \\Gamma_r');
    const couple = new Graphe({
        x: { min: -180, max: 180, nom: '\\alpha', graduations: [-180, -90, 0, 90, 180].map(degrés) },
        y: {
            min: -1.15,
            max: 1.7,
            nom: '\\Gamma_{\\text{ém}}',
            graduations: [
                [1, '\\Gamma_{\\max}'],
                [-1, '-\\Gamma_{\\max}'],
            ],
        },
        hauteur: 170,
    });
    // La zone stable, |α| < 90° : le couple y croît avec α.
    couple.zone().place(-90, 90);
    couple.trace((α) => Math.sin(deg(α)), { couleur: COULEURS.noir });
    const niveau = couple.courbe({ couleur: COULEUR_CHARGE, pointillés: true });
    const nomDuNiveau = couple.légende('\\Gamma_r', { couleur: COULEUR_CHARGE, ancre: 'gauche', décalage: [3, -7] });
    const pointCouple = couple.point({ couleur: COULEURS.noir });
    réglages.ajoute(couple.élément);
    const valeurs = réglages.formule();
    const bilan = réglages.texte();

    // La vitesse du rotor, et en pointillés celle du champ statorique, qu'il
    // suit ou non.
    réglages.groupe('Vitesses du champ statorique et du rotor');
    const vitesse = new Graphe({
        x: { min: -CHARGE.durée, max: 0, nom: 't', graduations: [-20, -10, 0].map((t) => [t, t ? `${t}\\,\\text{s}` : '0']) },
        y: {
            min: -1,
            max: CHARGE.ωMax + 2,
            nom: `{\\color{${COULEUR.Bs}} \\omega}, \\Omega`,
            // En rad/s, comme le curseur de ω.
            graduations: [5, 10],
        },
        hauteur: 130,
        coupe: true,
    });
    const chrono = { Ω: chronogramme(vitesse), ω: chronogramme(vitesse, { couleur: COULEUR.Bs, pointillés: true }) };
    réglages.ajoute(vitesse.élément);
    réglages.texte('Un amortissement, absent du modèle du cours, calme les oscillations de α.').className = 'note';

    // -- À chaque image ----------------------------------------------------------

    /** Le couple des amortisseurs, pour le glissement Δ = ω − Ω. */
    const amortisseurs = (Δ) => {
        const x = Δ / CHARGE.fenêtre;
        return Math.abs(x) < 1 ? ((2 * CHARGE.ζ) / ω0) * Δ * (1 - x * x) ** 2 : 0;
    };
    let couples = { Γm: 0, Γcharge: 0 };

    scène.àChaqueImage((dt) => {
        const { ω } = état;
        if (!état.pause) {
            couples = tourne(état, dt, {
                J: 1 / ω0 ** 2,
                Γr: état.Γr,
                couple: () => Math.sin(état.ωt - état.θr) + amortisseurs(ω - état.Ω),
                avance: (h) => {
                    état.θr += état.Ω * h;
                    état.ωt += ω * h;
                },
            });
            chrono.Ω.ajoute(dt, état.Ω);
            chrono.ω.ajoute(dt, ω);
            // Le rotor a décroché quand le champ statorique a pris sur lui un
            // demi-tour d'avance — ou de retard, si ω a baissé d'un coup ; il
            // n'est de nouveau accroché que s'il tourne un moment à la
            // vitesse du champ.
            if (Math.abs(état.ωt - état.θr) > Math.PI) état.décroché = true;
            état.calme = Math.abs(ω - état.Ω) < CHARGE.synchrone ? état.calme + dt : 0;
            if (état.décroché && état.calme > 2) {
                état.ωt -= DEUX_PI * Math.round((état.ωt - état.θr) / DEUX_PI);
                état.décroché = false;
            }
        }
        const { ωt, θr } = état;
        const α = angleSigné(ωt - θr);

        modèle.rotor.rotation.z = θr;
        pôles.rotation.z = θr;
        dessineChamp(champs.Bs, (θ) => AMPLITUDE.Bs * Math.cos(ωt - θ));
        dessineChamp(champs.Br, (θ) => AMPLITUDE.Br * Math.cos(θ - θr));
        angle.place(θr, ωt);

        const centre = vecteur(0, 0, Z_SCHÉMA);
        arcΓ.place(centre, direction(deg(200)), direction(deg(290)), CHARGE.arc * Math.sin(α), 1.05);
        arcΓr.place(centre, direction(deg(20)), direction(deg(110)), -CHARGE.arc * couples.Γcharge, 1.45);

        niveau.place([
            [-180, état.Γr],
            [180, état.Γr],
        ]);
        nomDuNiveau.place(-180, état.Γr);
        pointCouple.place(THREE.MathUtils.radToDeg(α), Math.sin(α));
        valeurs.écrit(
            `\\alpha = ${Math.round(THREE.MathUtils.radToDeg(α))}^\\circ \\qquad \\Omega = ${virgule(état.Ω, 1)}\\,\\text{rad/s}`,
        );
        const texte = !état.décroché ? '' : état.Ω === 0 ? 'Le moteur a décroché : il est à l’arrêt.' : 'Le moteur a décroché.';
        if (bilan.textContent !== texte) bilan.textContent = texte;
    });
}

const ANIMATIONS = { champs: machineSynchrone, charge: décrochage };

lance('section.animation', (section) => ANIMATIONS[section.dataset.animation](section));
