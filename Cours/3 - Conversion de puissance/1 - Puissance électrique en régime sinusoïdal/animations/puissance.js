// La puissance reçue par un dipôle d'impédance Z = R + jX, sous une tension
// sinusoïdale imposée : u(t) = U cos(ωt), i(t) = I cos(ωt − φ), avec
// I = U/|Z| et φ = arg Z, le déphasage de la tension sur le courant.
//
// À gauche, les chronogrammes : u et i sur le même graphique, chacun avec
// son échelle (u à gauche, i à droite), puis p = u i, dont l'aire est
// hachurée sur une période — « / » au-dessus de l'axe, « \ » dessous —, et
// sa moyenne P en pointillés. À droite, le diagramme de Fresnel de Z : la
// pointe se déplace à la main, comme les deux curseurs.
//
// Rien ne défile : le temps se compte en périodes, et l'on montre les deux
// premières.

import { Graphe, échantillons } from '#animations/graphe.js';
import { COULEURS, écritTex } from '#animations/objets.js';
import { cadre, lance } from '#animations/page.js';
import { Plan, chemin, disque, flèche, pointe } from '#animations/plan.js';
import { Réglages } from '#animations/reglages.js';

/** La tension imposée : sa valeur efficace, son amplitude, et le haut de son
 *  échelle, en volts. */
const U_EFF = 230;
const U = U_EFF * Math.SQRT2;
const U_AXE = 400;

/** Les bornes des curseurs, en ohms : le dipôle est passif, R ≥ 0. */
const R_MAX = 100;
const X_MAX = 100;

const COULEUR = {
    u: COULEURS.vert,
    i: COULEURS.vermillon,
    p: COULEURS.bleu,
    P: COULEURS.noir,
    R: COULEURS.violet,
    X: COULEURS.orange,
    Z: COULEURS.noir,
    φ: COULEURS.noir,
};
const GRIS_GRILLE = '#e3e3e3';
const GRIS_AXE = '#555';

const chiffres = (n, exacts = false) =>
    new Intl.NumberFormat('fr-FR', { maximumSignificantDigits: n, ...(exacts ? { minimumSignificantDigits: n } : {}) });
const décimales = (n) => new Intl.NumberFormat('fr-FR', { minimumFractionDigits: n, maximumFractionDigits: n });
const TROIS = chiffres(3);
const TROIS_EXACTS = chiffres(3, true);

/** Un nombre écrit à la française et lisible par KaTeX : la virgule garde
 *  l'espacement d'un séparateur, l'espace des milliers devient `\,` — dans
 *  cet ordre, sans quoi la virgule de `\,` serait prise pour la décimale. */
function nombre(x, format = TROIS) {
    if (x === 0) return '0';
    return format
        .format(x)
        .replace('−', '-')
        .replace(',', '{,}')
        .replace(/[\u202f\u00a0 ]/g, '\\,');
}

/** La plus petite valeur ronde qui dépasse x, et dont la moitié se lit
 *  aussi (cf. bobine.js, Électromagnétisme 4). */
function rondeAuDessus(x) {
    const décade = 10 ** Math.floor(Math.log10(x));
    return décade * [1, 1.2, 1.5, 2, 2.5, 3, 4, 5, 6, 8, 10].find((m) => m * décade >= x * (1 - 1e-9));
}

/**
 * La part positive (signe > 0) ou négative d'une courbe [[t, y], …], ramenée
 * à zéro ailleurs : une aire qui ne compte que ce qui est d'un côté de l'axe.
 * Les passages par zéro s'interpolent, pour que l'aire épouse la courbe.
 */
function part(points, signe) {
    const garde = signe > 0 ? (y) => Math.max(y, 0) : (y) => Math.min(y, 0);
    const résultat = [];
    points.forEach(([t, y], k) => {
        if (k > 0) {
            const [t0, y0] = points[k - 1];
            if (y0 * y < 0) résultat.push([t0 + ((t - t0) * y0) / (y0 - y), 0]);
        }
        résultat.push([t, garde(y)]);
    });
    return résultat;
}

function puissance(section) {
    const { vue, réglages: panneau } = cadre(section);
    const état = { R: 40, X: 30 };

    // -- Les chronogrammes ----------------------------------------------------

    const marges = { gauche: 60, droite: 50, haut: 24, bas: 22 };
    const temps = {
        min: 0,
        max: 2,
        nom: 't',
        graduations: [
            [0, '0'],
            [0.5, 'T/2'],
            [1, 'T'],
            [1.5, '3T/2'],
            [2, '2T'],
        ],
    };
    const NIVEAUX = [-1, -0.5, 0, 0.5, 1];

    // u et i : l'ordonnée est rapportée au haut de chaque échelle, U_AXE pour
    // u, une valeur ronde au-dessus de I pour i.
    const ui = new Graphe({
        largeur: 560,
        hauteur: 235,
        grand: true,
        marges,
        x: temps,
        y: {
            min: -1.15,
            max: 1.15,
            nom: 'u\\ (\\mathrm{V})',
            couleur: COULEUR.u,
            graduations: NIVEAUX.map((v) => [v, nombre(v * U_AXE)]),
        },
    });
    // L'échelle de i, à droite ; le zéro est commun.
    const à_droite = { ancre: 'gauche', couleur: COULEUR.i, décalage: [5, 0] };
    ui.légende('i\\ (\\mathrm{A})', { ...à_droite, x: temps.max, y: 1.15, décalage: [5, 9 - marges.haut] });
    const graduationsI = NIVEAUX.filter((v) => v !== 0).map((v) => [v, ui.légende('', { ...à_droite, x: temps.max, y: v })]);
    const courbeU = ui.courbe({ couleur: COULEUR.u, épaisseur: 2.2 });
    const courbeI = ui.courbe({ couleur: COULEUR.i, épaisseur: 2.2 });
    // Le retard du courant sur la tension, d'un maximum à l'autre : φ/ω.
    const retard = ui.cote('\\varphi/\\omega', { couleur: COULEURS.gris });

    // p : l'ordonnée est rapportée à une valeur ronde au-dessus de U I, qui
    // borne p par le haut ; par le bas, p ne descend pas sous −U I/2.
    const gp = new Graphe({
        largeur: 560,
        hauteur: 235,
        grand: true,
        marges,
        x: { ...temps, nom: '' },
        y: { min: -0.62, max: 1.12, couleur: COULEUR.p },
    });
    const nomP = gp.légende('', { x: 0, y: 1.12, ancre: 'droite', couleur: COULEUR.p, décalage: [-5, 9 - marges.haut] });
    const aires = [
        gp.aire({ couleur: COULEUR.p, bord: false, hachures: { angle: 45 } }),
        gp.aire({ couleur: COULEUR.p, bord: false, hachures: { angle: -45 } }),
    ];
    const courbeP = gp.courbe({ couleur: COULEUR.p, épaisseur: 2.2 });
    const moyenne = gp.courbe({ couleur: COULEUR.P, épaisseur: 1.6, pointillés: true });
    const nomMoyenne = gp.légende('P', { ancre: 'gauche', couleur: COULEUR.P, décalage: [5, 0] });

    // -- Le diagramme de Fresnel ----------------------------------------------

    const chronogrammes = document.createElement('div');
    const caseFresnel = document.createElement('div');
    for (const g of [ui, gp]) g.élément.style.margin = '0.7rem 0.6rem';
    chronogrammes.append(ui.élément, gp.élément);
    const grille = document.createElement('div');
    Object.assign(grille.style, { display: 'grid', alignItems: 'center' });
    grille.append(chronogrammes, caseFresnel);
    vue.append(grille);

    // Le domaine des curseurs, quadrillé, et un peu d'air autour.
    const bord = { x0: -22, x1: R_MAX + 22, y0: -X_MAX - 18, y1: X_MAX + 18 };
    const fresnel = new Plan(caseFresnel, {
        rapport: (bord.x1 - bord.x0) / (bord.y1 - bord.y0),
        étendue: bord.x1 - bord.x0,
        centre: [(bord.x0 + bord.x1) / 2, (bord.y0 + bord.y1) / 2],
        aide: 'Glisser la pointe de Z pour régler l’impédance.',
    });
    const étiquettes = {
        Re: fresnel.étiquette('\\mathrm{Re}', { couleur: GRIS_AXE, taille: '0.9rem', ancre: 'droite' }),
        Im: fresnel.étiquette('\\mathrm{Im}', { couleur: GRIS_AXE, taille: '0.9rem', ancre: 'gauche' }),
        R: fresnel.étiquette('R', { couleur: COULEUR.R }),
        X: fresnel.étiquette('X', { couleur: COULEUR.X, ancre: 'gauche' }),
        Z: fresnel.étiquette('\\underline{Z}', { couleur: COULEUR.Z }),
        φ: fresnel.étiquette('\\varphi', { couleur: COULEUR.φ }),
    };

    fresnel.poignée({
        position: () => [état.R, état.X],
        rayon: 18,
        auDéplacement: (x, y) => {
            état.R = Math.min(Math.max(Math.round(x), 0), R_MAX);
            état.X = Math.min(Math.max(Math.round(y), -X_MAX), X_MAX);
            curseurs.R.valeur = état.R;
            curseurs.X.valeur = état.X;
            recalcule();
        },
    });

    fresnel.dessine((c, plan) => {
        const { R, X } = état;
        const Z = Math.hypot(R, X);
        const φ = Math.atan2(X, R);
        const px = plan.échelle;

        // Le quadrillage, tous les 25 Ω, sur le domaine des curseurs.
        for (let v = -X_MAX; v <= X_MAX; v += 25) chemin(c, [plan.vers(0, v), plan.vers(R_MAX, v)], { couleur: GRIS_GRILLE, épaisseur: 1 });
        for (let v = 0; v <= R_MAX; v += 25) chemin(c, [plan.vers(v, -X_MAX), plan.vers(v, X_MAX)], { couleur: GRIS_GRILLE, épaisseur: 1 });

        // Les axes.
        const axe = { couleur: GRIS_AXE, épaisseur: 1.2, tête: 8 };
        flèche(c, plan.vers(bord.x0 + 6, 0), [1, 0], (bord.x1 - bord.x0 - 10) * px, axe);
        flèche(c, plan.vers(0, bord.y0 + 6), [0, -1], (bord.y1 - bord.y0 - 10) * px, axe);
        étiquettes.Re.place(bord.x1 - 4, 0, [0, 13]);
        étiquettes.Im.place(0, bord.y1 - 6, [7, 2]);

        const O = plan.vers(0, 0);
        const bout = plan.vers(R, X);
        const pied = plan.vers(R, 0);
        const visibles = { R: R > 0, X: X !== 0, Z: Z > 0, φ: false };
        const rayon = Math.min(46, 0.5 * Z * px);

        if (Z > 0) {
            // L'angle droit, quand le triangle en a un.
            const d = 7;
            const s = Math.sign(X);
            if (R * px > 2 * d && Math.abs(X) * px > 2 * d) {
                chemin(c, [[pied[0] - d, pied[1]], [pied[0] - d, pied[1] - s * d], [pied[0], pied[1] - s * d]], {
                    couleur: GRIS_AXE,
                    épaisseur: 1,
                });
            }
            // R le long de l'axe réel, X à sa suite.
            if (R > 0) chemin(c, [O, pied], { couleur: COULEUR.R, épaisseur: 4 });
            if (X !== 0) chemin(c, [pied, bout], { couleur: COULEUR.X, épaisseur: 4 });

            // L'angle φ, de l'axe réel à Z, orienté.
            if (rayon > 14 && Math.abs(φ) > 0.03) {
                visibles.φ = true;
                c.save();
                c.beginPath();
                c.arc(O[0], O[1], rayon, 0, -φ, φ > 0);
                Object.assign(c, { strokeStyle: COULEUR.φ, lineWidth: 1.4 });
                c.stroke();
                c.restore();
                // La pointe, un peu en deçà de l'extrémité de l'arc, tangente.
                const s = Math.sign(φ);
                const θ = φ - (s * 4) / rayon;
                pointe(c, [O[0] + rayon * Math.cos(θ), O[1] - rayon * Math.sin(θ)], [-s * Math.sin(θ), -s * Math.cos(θ)], {
                    couleur: COULEUR.φ,
                    taille: 8,
                });
                étiquettes.φ.place(0, 0, [(rayon + 12) * Math.cos(φ / 2), -(rayon + 12) * Math.sin(φ / 2)]);
            }

            // Z, et le disque discret qui dit qu'on peut le prendre.
            disque(c, bout, 11, { couleur: 'rgba(0, 0, 0, 0.07)' });
            flèche(c, O, [bout[0] - O[0], bout[1] - O[1]], Z * px, { couleur: COULEUR.Z, épaisseur: 2.6, tête: 12 });

            // Les noms : R du côté de l'axe opposé au triangle, X à droite de
            // son côté, Z de l'autre côté de l'hypoténuse.
            étiquettes.R.place(R / 2, 0, [0, X >= 0 ? 14 : -14]);
            // Quand R est petit, X longe l'axe imaginaire, et son nom, à
            // mi-hauteur, tomberait sur l'arc de φ : on le monte au-dessus.
            let hX = Math.abs(X) / 2;
            if (R * px < rayon + 10) hX = Math.max(hX, Math.min(Math.abs(X) - 10 / px, (rayon + 16) / px));
            étiquettes.X.place(R, Math.sign(X) * hX, [8, 0]);
            const signe = X >= 0 ? 1 : -1;
            const [nx, ny] = [(-signe * X) / Z, (signe * R) / Z];
            étiquettes.Z.place(R / 2, X / 2, [16 * nx, -16 * ny]);
        } else {
            // Un court-circuit : Z est nul.
            disque(c, O, 4.5, { couleur: COULEUR.Z });
            disque(c, O, 11, { couleur: 'rgba(0, 0, 0, 0.07)' });
            étiquettes.Z.place(0, 0, [-14, -14]);
        }
        for (const [nom, oui] of Object.entries(visibles)) étiquettes[nom].montre(oui);
        étiquettes.Z.montre(true);
    });

    // Côte à côte sur un écran large, l'un sous l'autre sur un écran étroit,
    // où les légendes reprennent la taille du panneau.
    new ResizeObserver(() => {
        const étroit = grille.clientWidth < 620;
        grille.style.gridTemplateColumns = étroit ? 'minmax(0, 1fr)' : 'minmax(0, 2fr) minmax(0, 1fr)';
        Object.assign(caseFresnel.style, {
            maxWidth: étroit ? '22rem' : '',
            width: '100%',
            justifySelf: 'center',
            borderLeft: étroit ? '' : '1px solid var(--filet-clair)',
            borderTop: étroit ? '1px solid var(--filet-clair)' : '',
        });
        for (const g of [ui, gp]) g.élément.classList.toggle('grand', g.élément.clientWidth >= 440);
    }).observe(grille);

    // -- Réglages -------------------------------------------------------------

    const réglages = new Réglages(panneau);
    réglages.groupe('Impédance');
    const curseurs = {
        R: réglages.curseur({
            tex: 'R',
            min: 0,
            max: R_MAX,
            pas: 1,
            valeur: état.R,
            unité: ' Ω',
            couleur: COULEUR.R,
            auChangement: (v) => {
                état.R = v;
                recalcule();
            },
        }),
        X: réglages.curseur({
            tex: 'X',
            min: -X_MAX,
            max: X_MAX,
            pas: 1,
            valeur: état.X,
            unité: ' Ω',
            couleur: COULEUR.X,
            auChangement: (v) => {
                état.X = v;
                recalcule();
            },
        }),
    };
    const formuleZ = réglages.formule();
    const nature = réglages.texte();
    nature.className = 'note';

    réglages.groupe('Courant et puissance');
    const tension = réglages.texte();
    tension.className = 'note';
    tension.append(écritTex(document.createElement('span'), `U_\\text{eff} = ${U_EFF}\\,\\mathrm{V}`), '.');
    const mesures = { I: réglages.formule(), cos: réglages.formule(), P: réglages.formule() };

    // -- Le calcul, à chaque réglage ------------------------------------------

    const τ = échantillons(0, 2, 480);
    const unePériode = τ.filter((t) => t <= 1 + 1e-9);

    function recalcule() {
        const { R, X } = état;
        const Z = Math.hypot(R, X);
        const φ = Math.atan2(X, R);
        const court = Z === 0;

        courbeU.place(τ.map((t) => [t, (U / U_AXE) * Math.cos(2 * Math.PI * t)]));
        for (const tracé of [courbeI, courbeP, moyenne, ...aires]) tracé.montre(!court);
        for (const [, légende] of graduationsI) légende.montre(!court);
        nomMoyenne.montre(!court);
        retard.montre(!court && Math.abs(φ) > 0.06);

        if (court) {
            formuleZ.écrit('\\underline{Z} = 0');
            nature.textContent = 'Court-circuit : le courant n’est pas borné.';
            mesures.I.écrit('I_\\text{eff} \\to \\infty');
            mesures.cos.écrit('');
            mesures.P.écrit('');
            gp.grilleY.place([]);
            nomP.écrit('');
            fresnel.redessine();
            return;
        }

        // Le courant, sur son échelle.
        const I = U / Z;
        const iAxe = rondeAuDessus(1.3 * I);
        courbeI.place(τ.map((t) => [t, (I / iAxe) * Math.cos(2 * Math.PI * t - φ)]));
        for (const [v, légende] of graduationsI) légende.écrit(nombre(v * iAxe));
        if (Math.abs(φ) > 0.06) retard.place(1, 1 + φ / (2 * Math.PI), 1);

        // La puissance instantanée, en W ou en kW.
        const pAxe = rondeAuDessus(U * I);
        const [unité, k] = pAxe >= 1e4 ? ['kW', 1e3] : ['W', 1];
        nomP.écrit(`p\\ (\\mathrm{${unité}})`);
        gp.grilleY.place([-0.5, 0, 0.5, 1].map((v) => [v, nombre((v * pAxe) / k)]));
        const p = (t) => (U * I * Math.cos(2 * Math.PI * t) * Math.cos(2 * Math.PI * t - φ)) / pAxe;
        courbeP.place(τ.map((t) => [t, p(t)]));
        const sur1 = unePériode.map((t) => [t, p(t)]);
        aires[0].place(part(sur1, 1));
        aires[1].place(part(sur1, -1));

        // La puissance moyenne : P = U_eff I_eff cos φ, et cos φ = R/|Z|,
        // exactement nul pour un dipôle purement réactif.
        const Ieff = U_EFF / Z;
        const cosφ = R / Z;
        const P = U_EFF * Ieff * cosφ;
        moyenne.place([
            [0, P / pAxe],
            [2, P / pAxe],
        ]);
        nomMoyenne.place(2, P / pAxe);

        formuleZ.écrit(
            `|\\underline{Z}| = ${nombre(Z, TROIS_EXACTS)}\\,\\Omega,\\quad \\varphi = ${nombre((φ * 180) / Math.PI, décimales(1))}^\\circ`,
        );
        nature.textContent =
            R === 0
                ? `Dipôle purement réactif, ${X > 0 ? 'inductif' : 'capacitif'}.`
                : X === 0
                  ? 'Dipôle résistif.'
                  : `Dipôle ${X > 0 ? 'inductif' : 'capacitif'}.`;
        mesures.I.écrit(
            `{\\color{${COULEUR.i}}I_\\text{eff}} = \\dfrac{U_\\text{eff}}{|\\underline{Z}|} = ${nombre(Ieff, TROIS_EXACTS)}\\,\\mathrm{A}`,
        );
        mesures.cos.écrit(`\\cos\\varphi = \\dfrac{R}{|\\underline{Z}|} = ${nombre(cosφ, TROIS_EXACTS)}`);
        const enW = P < 1e4;
        mesures.P.écrit(
            `P = U_\\text{eff} {\\color{${COULEUR.i}}I_\\text{eff}} \\cos\\varphi = ${nombre(enW ? P : P / 1e3)}\\,\\mathrm{${enW ? 'W' : 'kW'}}`,
        );
        fresnel.redessine();
    }

    recalcule();
}

lance('section.animation', puissance);
