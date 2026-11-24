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

import * as THREE from 'three';
import { RoomEnvironment } from 'three/addons/environments/RoomEnvironment.js';
import { Graphe, échantillons } from '#animations/graphe.js';
import { Arc, COULEURS, Étiquette, Flèche, Trait, vecteur } from '#animations/objets.js';
import { cadre, lance } from '#animations/page.js';
import { Réglages } from '#animations/reglages.js';
import { Scène } from '#animations/scene.js';
import { Courant, R_ARBRE, R_ENTREFER, R_ROTOR, R_STATOR, machine } from './machine.js';

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

const VUE_DE_FACE = { position: [0, 0, 30], cible: [0, 0, 0] };
const VUE_DE_TROIS_QUARTS = { position: [9, 14, 26], cible: [0, 0.3, -1.5] };

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

// -- L'animation -------------------------------------------------------------------

function machineSynchrone(section) {
    const { vue, réglages: panneau } = cadre(section);
    const scène = new Scène(vue, { rapport: 1.12, taille: 12.6, haut: [0, 1, 0], ...VUE_DE_FACE, éclairage: 0.45 });
    scène.bouton('Vue de trois quarts', () => scène.regarde(VUE_DE_TROIS_QUARTS));
    // Un rendu photographique pour la machine : des reflets pour les métaux —
    // une pièce éclairée, que les tôles, les fils et l'arbre renvoient —, et
    // une exposition qui ne brûle pas les faces claires.
    const pmrem = new THREE.PMREMGenerator(scène.rendu);
    scène.scène.environment = pmrem.fromScene(new RoomEnvironment(), 0.04).texture;
    scène.scène.environmentIntensity = 0.35;
    scène.rendu.toneMapping = THREE.NeutralToneMapping;

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
    let modèle = null;
    let symboles = [];
    // Le nombre d'encoches dessinées : N, ou N_MAX à la limite N → ∞.
    let encoches = 0;
    function construis() {
        if (modèle) {
            scène.scène.remove(modèle.stator, modèle.rotor);
            modèle.libère();
            for (const { symbole } of symboles) symbole.material.dispose();
        }
        encoches = Math.min(état.N, N_MAX);
        modèle = machine(encoches, { 1: COULEUR[1], 2: COULEUR[2], rotor: COULEUR.rotor });
        symboles = [];
        for (const partie of ['stator', 'rotor']) {
            const disque = new THREE.CircleGeometry(modèle.symboles[partie], 32);
            for (const c of modèle.conducteurs[partie]) {
                const symbole = new Courant(COULEUR[c.circuit], disque);
                symbole.position.copy(direction(c.angle).multiplyScalar(c.rayon)).setZ(0.01);
                modèle.enroulements[partie].add(symbole);
                symboles.push({ symbole, c });
            }
        }
        modèle.montreLesConducteurs(état.conducteurs);
        scène.ajoute(modèle.stator, modèle.rotor);
    }
    construis();

    // Le nom des bandes de conducteurs des circuits statoriques, et les pôles
    // du rotor, qui tournent avec lui.
    const bandes = new THREE.Group().add(
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
    const pôles = new THREE.Group().add(
        new Étiquette('\\mathrm{N}', { couleur: COULEURS.gris, face: DEVANT }).place(vecteur(1.55, 0, Z_SCHÉMA)),
        new Étiquette('\\mathrm{S}', { couleur: COULEURS.gris, face: DEVANT }).place(vecteur(-1.55, 0, Z_SCHÉMA)),
    );

    // Les champs dans l'entrefer : des flèches, et le contour qui relie
    // leurs pointes. Chaque champ a les siennes, décalées d'un quart de pas
    // de celles du suivant.
    const flèches = (couleur, décalage) =>
        Array.from({ length: FLÈCHES }, (_, k) => ({
            θ: (DEUX_PI * (k + décalage)) / FLÈCHES,
            flèche: new Flèche({ couleur, rayon: 0.026, tête: 0.18, largeur: 0.07 }),
        }));
    const champs = {
        Bs: { flèches: flèches(COULEUR.Bs, 0), visible: true },
        1: { flèches: flèches(COULEUR[1], 0.25), visible: false },
        2: { flèches: flèches(COULEUR[2], 0.75), visible: false },
        Br: { flèches: flèches(COULEUR.Br, 0.5), visible: true },
    };
    for (const [nom, champ] of Object.entries(champs)) {
        // Le contour, fin et translucide : ce sont les flèches qu'on lit.
        champ.contour = new Trait({ couleur: COULEUR[nom], épaisseur: 1.2, opacité: 0.5 });
        champ.groupe = new THREE.Group().add(...champ.flèches.map((f) => f.flèche), champ.contour);
        champ.groupe.visible = champ.visible;
    }

    // L'angle α, du rotor au maximum du champ glissant, et le couple.
    const schéma = new THREE.Group();
    const axeRotor = new Trait({ couleur: COULEUR.rotor, épaisseur: 2, pointillés: true, tiret: 0.15 });
    const maximumBs = new Trait({ couleur: COULEUR.Bs, épaisseur: 2, pointillés: true, tiret: 0.15 });
    const arcα = new Arc('\\alpha', { face: DEVANT });
    const arcΓ = new Arc('\\Gamma_{\\text{ém}}', { face: DEVANT });
    schéma.add(axeRotor, maximumBs, arcα, arcΓ, pôles);
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

        const centre = vecteur(0, 0, Z_SCHÉMA);
        const rayon = (a) => [R_ARBRE + 0.15, R_ROTOR - 0.1].map((r) => direction(a).multiplyScalar(r).setZ(Z_SCHÉMA));
        axeRotor.trace(rayon(θr));
        maximumBs.trace(rayon(ωt));
        const α = deg(état.α);
        arcα.place(centre, direction(θr), direction(θr + Math.PI / 2), α, 2.05);
        // Le couple, en arc autour de l'arbre : dans le sens de rotation
        // quand il entraîne le rotor.
        const Γ = Math.sin(α);
        arcΓ.place(centre, direction(θr + Math.PI), direction(θr + (3 * Math.PI) / 2), 1.7 * Γ, 1.05);

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

lance('section.animation', machineSynchrone);
