"""Dépôt des notebooks sur Capytale, et lien vers eux dans les exercices.

Capytale n'a pas d'API publique. On parle à celle qu'utilise sa propre
interface, dont le client est publié sur la forge de l'Éducation nationale
(forge.apps.education.fr/capytale/activity-js) :

- `POST /web/c-act/api/activity` crée une activité ;
- `PUT /web/c-act/api/n/<nid>/fields/content` en remplace le notebook ;
- `GET /web/node/<nid>?_format=json` en donne le code de partage.

Elle peut changer sans prévenir : c'est le prix de l'automatisme.

**Connexion.** Capytale ne connaît que l'ENT et ÉduConnect : pas de jeton
d'API. On reprend la session ouverte dans le navigateur, soit par la variable
d'environnement CAPYTALE_COOKIE (l'en-tête Cookie de capytale2.ac-paris.fr,
copié depuis les outils de développement), soit, à défaut, en la lisant dans
le navigateur avec browser_cookie3 s'il est installé. Session expirée : se
reconnecter à Capytale dans le navigateur.

**Lien.** Le code de partage d'une activité créée est écrit dans l'exercice
(`capytale: "2253-2586522"`), qui l'affiche sous son titre. C'est aussi par lui
que l'on retrouve l'activité : Capytale lit son numéro après le cinquième
caractère.

**Ce qui part.** Seul un notebook qui a changé est renvoyé : le manifeste
(.capytale-manifeste.json, ignoré par git) note l'empreinte du dernier envoi.

**Écrasement.** Une activité existante est écrasée, sans fusion. Le premier
envoi vers une activité que le manifeste ne connaît pas encore — une activité
faite à la main, avant cet outil — sauvegarde d'abord son contenu dans
.capytale-sauvegardes/.

**Copies des élèves.** Une copie qu'un élève a déjà enregistrée ne suit plus le
modèle : une mise à jour n'atteint que ceux qui n'ont pas encore commencé.
"""

import glob
import hashlib
import json
import os
import re
import shutil
import sqlite3
import subprocess
import sys
import tempfile
import threading
import urllib.error
import urllib.request
from datetime import datetime
from pathlib import Path

from . import notebook
from .chapitre import RACINE, Chapitre
from .site import _infos_exercice, bornes_arguments, hors_chaines

ADRESSE = "https://capytale2.ac-paris.fr"

#: L'identifiant du type « notebook Python » chez Capytale.
TYPE_ACTIVITÉ = "notebook.python3"

MANIFESTE = RACINE / ".capytale-manifeste.json"
SAUVEGARDES = RACINE / ".capytale-sauvegardes"

#: Secondes avant d'abandonner une requête.
DÉLAI = 30

_EXPLICATIONS = {
    400: "requête refusée (l'API de Capytale a-t-elle changé ?)",
    403: "accès refusé : session expirée, ou activité d'un autre compte",
    404: "introuvable",
    413: "notebook trop gros pour Capytale",
}


class ErreurCapytale(RuntimeError):
    """Capytale n'a pas fait ce qu'on lui demandait."""


# -- Session ------------------------------------------------------------------


#: Où les navigateurs dérivés de Firefox rangent leurs profils, un
#: `cookies.sqlite` par profil. Firefox est passé à ~/.config/mozilla en 2026 ;
#: browser_cookie3 ne connaît que l'ancien dossier.
PROFILS_FIREFOX = (
    "~/.config/mozilla/firefox/*/cookies.sqlite",
    "~/.mozilla/firefox/*/cookies.sqlite",
    "~/.var/app/org.mozilla.firefox/config/mozilla/firefox/*/cookies.sqlite",
    "~/.var/app/org.mozilla.firefox/.mozilla/firefox/*/cookies.sqlite",
    "~/snap/firefox/common/.mozilla/firefox/*/cookies.sqlite",
    "~/.cachy/*/cookies.sqlite",  # Cachy-Browser, celui de CachyOS
    "~/.librewolf/*/cookies.sqlite",
    "~/.var/app/io.gitlab.librewolf-community/.librewolf/*/cookies.sqlite",
    "~/.zen/*/cookies.sqlite",
    "~/.floorp/*/cookies.sqlite",
    "~/.waterfox/*/cookies.sqlite",
    "~/.var/app/net.waterfox.waterfox/.waterfox/*/cookies.sqlite",
)

#: Les navigateurs dérivés de Chromium, sous leur nom chez browser_cookie3,
#: avec les dossiers où chercher leurs fichiers `Cookies`.
CHROMIUMS = {
    "chrome": ("~/.config/google-chrome", "~/.var/app/com.google.Chrome/config/google-chrome"),
    "chromium": (
        "~/.config/chromium",
        "~/.var/app/org.chromium.Chromium/config/chromium",
        "~/.var/app/io.github.ungoogled_software.ungoogled_chromium/config/chromium",
    ),
    "brave": ("~/.config/BraveSoftware/Brave-Browser", "~/.var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser"),
    "vivaldi": ("~/.config/vivaldi",),
    "edge": ("~/.config/microsoft-edge",),
    "opera": ("~/.config/opera",),
}


def _fraicheur(fichier: str) -> float:
    """Date de la dernière écriture dans une base de cookies, journal compris."""
    return max((os.path.getmtime(f) for f in (fichier, fichier + "-wal") if os.path.exists(f)), default=0)


def _du_domaine(domaine: str, hôte: str) -> bool:
    """Le navigateur enverrait-il à `hôte` un cookie posé pour `domaine` ?"""
    return domaine.lstrip(".") == hôte or (domaine.startswith(".") and hôte.endswith(domaine))


def cookies_firefox(fichier: str, hôte: str) -> str:
    """L'en-tête Cookie qu'un profil Firefox enverrait à `hôte`.

    Sans browser_cookie3 : les cookies de Firefox ne sont pas chiffrés. Tant
    que Firefox tourne, sa base est verrouillée, et la seule lecture possible
    en place (`immutable`) ignore le journal `cookies.sqlite-wal` — là où sont
    les écritures récentes, la session d'une connexion du jour comprise : on
    envoyait alors une session périmée. On lit donc une copie de la base et de
    son journal, que SQLite rejoue à l'ouverture.
    """
    with tempfile.TemporaryDirectory() as tampon:
        for suffixe in ("", "-wal"):
            if os.path.exists(fichier + suffixe):
                shutil.copyfile(fichier + suffixe, os.path.join(tampon, "cookies.sqlite" + suffixe))
        connexion = sqlite3.connect(os.path.join(tampon, "cookies.sqlite"))
        try:
            lignes = connexion.execute("select name, value, host from moz_cookies").fetchall()
        finally:
            connexion.close()
    cookies = {nom: valeur for nom, valeur, domaine in lignes if _du_domaine(domaine, hôte)}
    return "; ".join(f"{nom}={valeur}" for nom, valeur in cookies.items())


def sessions_du_navigateur() -> tuple[list[tuple[str, str]], list[str]]:
    """Les sessions Capytale trouvées, (provenance, en-tête Cookie), de la
    plus récente à la plus ancienne ; et ce qui n'a pas pu être lu.

    CAPYTALE_COOKIE d'abord, s'il est défini. Puis les profils Firefox, lus
    directement (cf. `cookies_firefox`). Puis les Chromium, dont les cookies
    sont chiffrés : il faut browser_cookie3, qu'on appelle navigateur par
    navigateur et fichier par fichier, jamais par son `load()`. Celui-ci
    abandonne tout dès qu'un navigateur plante, et en 0.20.1 Arc, qui n'existe
    que sous macOS, plante toujours sous Linux (`expanduser(None)`). Sous
    Linux, il interroge aussi le trousseau (KWallet, GNOME Keyring) avant même
    de chercher le navigateur : on ne l'appelle que sur un fichier qui existe.
    """
    hôte = ADRESSE.split("//", 1)[1]
    trouvées: list[tuple[float, str, str]] = []
    illisibles: list[str] = []

    fichiers = {f for motif in PROFILS_FIREFOX for f in glob.glob(os.path.expanduser(motif))}
    for fichier in fichiers:
        try:
            valeur = cookies_firefox(fichier, hôte)
        except (OSError, sqlite3.Error) as e:
            illisibles.append(f"{fichier} : {e}")
            continue
        if valeur:
            trouvées.append((_fraicheur(fichier), fichier, valeur))

    chromiums = [
        (nom, fichier)
        for nom, dossiers in CHROMIUMS.items()
        for dossier in dossiers
        for motif in ("*/Cookies", "*/Network/Cookies")
        for fichier in glob.glob(os.path.join(os.path.expanduser(dossier), motif))
    ]
    if chromiums:
        try:
            import browser_cookie3
        except ImportError:
            # Le cas courant : `python3 -m outils` lancé avec le python du
            # système, alors que browser_cookie3 est dans le venv du dépôt.
            browser_cookie3 = None
            illisibles.append(
                f"{len(chromiums)} profil(s) Chromium : browser_cookie3 manque à ce python "
                f"({sys.executable}), lancer outils/.venv/bin/python -m outils capytale …"
            )
        for nom, fichier in chromiums if browser_cookie3 else []:
            try:
                jarre = getattr(browser_cookie3, nom)(cookie_file=fichier, domain_name=hôte)
                valeur = "; ".join(f"{c.name}={c.value}" for c in jarre if _du_domaine(c.domain, hôte))
            except Exception as e:  # noqa: BLE001 - trousseau fermé, base illisible… : au suivant
                illisibles.append(f"{fichier} : {e}")
                continue
            if valeur:
                trouvées.append((_fraicheur(fichier), fichier, valeur))

    trouvées.sort(reverse=True)
    sessions = [(provenance, valeur) for _, provenance, valeur in trouvées]
    valeur = os.environ.get("CAPYTALE_COOKIE", "").strip()
    if valeur:
        sessions.insert(0, ("CAPYTALE_COOKIE", valeur))
    return sessions, illisibles


class Session:
    """Les requêtes à Capytale, au nom de l'enseignant connecté."""

    def __init__(self, cookies: str, adresse: str = ADRESSE):
        self.adresse = adresse.rstrip("/")
        self._cookies = cookies
        self._jeton: str | None = None

    def _requête(
        self,
        méthode: str,
        chemin: str,
        corps: bytes | None = None,
        type: str | None = None,
        attendus: tuple[int, ...] = (200,),
    ) -> tuple[int, bytes]:
        entêtes = {
            "Cookie": self._cookies,
            # Sans lui, Capytale refuse de lire le contenu d'une activité.
            "X-API-ACCESS": "capytale",
        }
        if méthode != "GET":
            entêtes["X-CSRF-Token"] = self.jeton()
        if type:
            entêtes["Content-Type"] = type
        requête = urllib.request.Request(self.adresse + chemin, data=corps, method=méthode, headers=entêtes)
        try:
            with urllib.request.urlopen(requête, timeout=DÉLAI) as réponse:
                statut, contenu = réponse.status, réponse.read()
        except urllib.error.HTTPError as e:
            statut, contenu = e.code, e.read()
        except (urllib.error.URLError, TimeoutError) as e:
            raise ErreurCapytale(f"{méthode} {chemin} : {getattr(e, 'reason', e)}") from None
        if statut not in attendus:
            raise ErreurCapytale(f"{méthode} {chemin} : HTTP {statut}, {_EXPLICATIONS.get(statut, 'erreur')}")
        return statut, contenu

    def _json(self, méthode: str, chemin: str, données=None, attendus=(200,)):
        corps = None if données is None else json.dumps(données).encode("utf-8")
        _, contenu = self._requête(méthode, chemin, corps, "application/json" if corps else None, attendus)
        try:
            return json.loads(contenu) if contenu else None
        except ValueError:
            # Une page HTML à la place du JSON : la connexion, le plus souvent.
            raise ErreurCapytale(f"{méthode} {chemin} : réponse illisible (session expirée ?)") from None

    def jeton(self) -> str:
        """Le jeton CSRF que Drupal exige de toute écriture."""
        if self._jeton is None:
            _, contenu = self._requête("GET", "/web/session/token")
            self._jeton = contenu.decode("ascii").strip()
        return self._jeton

    def moi(self) -> dict:
        """L'enseignant connecté. Refuse une session d'élève ou expirée."""
        moi = self._json("GET", "/web/c-auth/api/me", attendus=(200, 204))
        if not moi:
            raise ErreurCapytale("session Capytale expirée : se reconnecter dans le navigateur")
        if moi.get("profil") != "teacher":
            raise ErreurCapytale(f"la session Capytale est celle d'un profil « {moi.get('profil')} »")
        return moi

    def crée(self, titre: str) -> int:
        """Crée une activité notebook vide et renvoie son numéro."""
        propriétés = self._json(
            "POST",
            "/web/c-act/api/activity",
            {"type": TYPE_ACTIVITÉ, "title": titre},
            attendus=(200, 201),
        )
        return int(propriétés["nid"])

    def contenu(self, nid: int) -> bytes | None:
        """Le notebook d'une activité, None si elle n'en a pas encore."""
        statut, contenu = self._requête("GET", f"/web/c-act/api/n/{nid}/fields/content", attendus=(200, 204))
        return None if statut == 204 else contenu

    def dépose(self, nid: int, texte: str) -> None:
        """Remplace le notebook d'une activité — comme le fait le lecteur de
        notebook de Capytale lui-même : le .ipynb brut, en texte."""
        self._requête(
            "PUT",
            f"/web/c-act/api/n/{nid}/fields/content",
            texte.encode("utf-8"),
            "text/plain",
            attendus=(200, 204),
        )

    def code(self, nid: int) -> str:
        """Le code de partage d'une activité."""
        nœud = self._json("GET", f"/web/node/{nid}?_format=json")
        try:
            return nœud["field_code"][0]["value"]
        except (KeyError, IndexError, TypeError):
            raise ErreurCapytale(f"l'activité {nid} n'a pas de code de partage") from None


# -- Le lien dans l'exercice ----------------------------------------------------


def code_de(texte: str) -> str | None:
    """Le code Capytale déjà écrit dans les arguments de l'exercice."""
    bornes = bornes_arguments(texte)
    if bornes is None:
        return None
    arguments = texte[bornes[0] : bornes[1]]
    trouvé = re.search(r'capytale:\s*"([^"]*)"', arguments)
    # Hors chaines : un titre qui contiendrait « capytale: » ne compte pas.
    if trouvé is None or hors_chaines(arguments)[trouvé.start()] != "c":
        return None
    return trouvé.group(1) or None


def numéro(code: str) -> int:
    """Le numéro de l'activité : ce qui suit « xxxx- » dans le code."""
    if not re.fullmatch(r"[0-9a-z]{4}-\d+", code):
        raise ErreurCapytale(f"code Capytale mal formé : « {code} »")
    return int(code[5:])


def avec_code(texte: str, code: str) -> str:
    """La source de l'exercice, avec `capytale: "<code>"` dans ses arguments.

    Remplace le code s'il y en a un ; sinon ajoute l'argument en dernier, à
    l'indentation des autres.
    """
    bornes = bornes_arguments(texte)
    if bornes is None:
        raise ErreurCapytale("pas d'appel à exercice() dans la source")
    début, fin = bornes
    arguments = texte[début:fin]
    argument = f'capytale: "{code}"'
    trouvé = re.search(r'capytale:\s*"[^"]*"', arguments)
    if trouvé and hors_chaines(arguments)[trouvé.start()] == "c":
        arguments = arguments[: trouvé.start()] + argument + arguments[trouvé.end() :]
    else:
        corps = arguments.rstrip()
        reste = arguments[len(corps) :]
        virgule = "" if corps.endswith(",") or not corps.strip() else ","
        if "\n" in arguments:
            retrait = re.search(r"\n([ \t]*)\S", arguments)
            arguments = f"{corps}{virgule}\n{retrait.group(1) if retrait else '    '}{argument},{reste}"
        else:
            arguments = f"{corps}{virgule}{' ' if corps.strip() else ''}{argument}{reste}"
    return texte[:début] + arguments + texte[fin:]


# -- Envois -------------------------------------------------------------------


def _empreinte(texte: str) -> str:
    return hashlib.sha256(texte.encode("utf-8")).hexdigest()


def _clé(exercice: Path) -> str:
    return exercice.resolve().relative_to(RACINE).as_posix()


def _git(*arguments: str) -> subprocess.CompletedProcess:
    return subprocess.run(["git", *arguments], cwd=RACINE, capture_output=True, text=True)


class Capytale:
    """Envoie les notebooks, en ne renvoyant que ce qui a changé.

    Partagé par les chapitres, qui passent de front : une seule session, un
    seul manifeste, gardés par un verrou.

    `simulation` : rien n'est envoyé ni écrit, on dit seulement ce qui le
    serait. `indexer` : un code écrit dans un exercice est ajouté à l'index de
    git — c'est le cas du hook pre-commit, pour que le lien parte dans le
    commit en cours —, sauf si l'exercice a des modifications non indexées,
    qu'on emporterait avec lui.
    """

    def __init__(self, simulation: bool = False, indexer: bool = False, session: Session | None = None):
        self.simulation = simulation
        self.indexer = indexer
        self._session = session
        self._verrou = threading.RLock()
        try:
            self._manifeste: dict[str, dict] = json.loads(MANIFESTE.read_text(encoding="utf-8"))
        except (OSError, ValueError):
            self._manifeste = {}

    @property
    def session(self) -> Session:
        """La première session trouvée que Capytale reconnaît comme celle d'un
        enseignant : un profil peut garder une session expirée, un autre la
        bonne."""
        with self._verrou:
            if self._session is not None:
                return self._session
            sessions, refus = sessions_du_navigateur()
            for provenance, cookies in sessions:
                session = Session(cookies)
                try:
                    session.moi()
                except ErreurCapytale as e:
                    refus.append(f"{provenance} : {e}")
                    continue
                self._session = session
                return session
            if not sessions:
                refus.append("aucun cookie de capytale2.ac-paris.fr dans les profils de navigateur connus")
            détail = "".join(f"\n    {r}" for r in refus)
            raise ErreurCapytale(f"aucune session Capytale valable : se connecter à Capytale dans le navigateur{détail}")

    def _note(self, exercice: Path, nid: int, empreinte: str) -> None:
        with self._verrou:
            self._manifeste[_clé(exercice)] = {"nid": nid, "empreinte": empreinte}
            MANIFESTE.write_text(
                json.dumps(self._manifeste, ensure_ascii=False, indent=1, sort_keys=True) + "\n",
                encoding="utf-8",
            )

    def _sauvegarde(self, exercice: Path, nid: int) -> Path | None:
        """Garde le contenu actuel d'une activité avant de l'écraser."""
        ancien = self.session.contenu(nid)
        if not ancien:
            return None
        SAUVEGARDES.mkdir(exist_ok=True)
        chemin = SAUVEGARDES / f"{exercice.stem} - {nid} - {datetime.now():%Y-%m-%d %H%M%S}.ipynb"
        chemin.write_bytes(ancien)
        return chemin

    def _écrit_code(self, exercice: Path, code: str) -> str:
        """Écrit le code dans l'exercice ; dit ce qu'il en est de l'index."""
        with self._verrou:
            propre = _git("diff", "--quiet", "--", str(exercice)).returncode == 0
            exercice.write_text(avec_code(exercice.read_text(encoding="utf-8"), code), encoding="utf-8")
            if not self.indexer:
                return ""
            if propre and _git("add", "--", str(exercice)).returncode == 0:
                return ", lien ajouté au commit"
            return ", lien écrit mais PAS indexé (modifications non indexées) : git add à faire"

    def envoie(self, exercice: Path, texte: str) -> str:
        """Crée ou met à jour l'activité d'un exercice. Renvoie ce qui a été fait."""
        empreinte = _empreinte(texte)
        code = code_de(exercice.read_text(encoding="utf-8"))
        note = self._manifeste.get(_clé(exercice))

        if code is None:
            if self.simulation:
                return "créerait l'activité et écrirait son code dans l'exercice"
            titre = _infos_exercice(exercice, appel=True)["titre"]
            nid = self.session.crée(titre)
            self.session.dépose(nid, texte)
            code = self.session.code(nid)
            self._note(exercice, nid, empreinte)
            return f"activité créée : {code}{self._écrit_code(exercice, code)}"

        nid = numéro(code)
        connue = note is not None and note.get("nid") == nid
        if connue and note.get("empreinte") == empreinte:
            return f"à jour ({code})"
        if self.simulation:
            return f"mettrait à jour {code}" + ("" if connue else ", après avoir sauvegardé son contenu actuel")
        sauvegarde = None if connue else self._sauvegarde(exercice, nid)
        self.session.dépose(nid, texte)
        self._note(exercice, nid, empreinte)
        return f"mis à jour : {code}" + (
            f", ancien contenu dans {sauvegarde.parent.name}/{sauvegarde.name}" if sauvegarde else ""
        )


def envoie_chapitre(capytale: Capytale, chapitre: Chapitre, exercices: list[Path] | None = None) -> list[str]:
    """Envoie les notebooks des exercices numériques d'un chapitre.

    Les notebooks sont ceux de `build/` : l'étape `notebooks` les produit juste
    avant, dans la même file.
    """
    lignes = []
    for exercice in exercices if exercices is not None else notebook.exercices(chapitre):
        fichier = notebook.cible(chapitre, exercice)
        if not fichier.is_file():
            raise ErreurCapytale(f"{fichier} manque : produire d'abord les notebooks")
        lignes.append(f"{exercice.stem} : {capytale.envoie(exercice, fichier.read_text(encoding='utf-8'))}")
    return lignes
