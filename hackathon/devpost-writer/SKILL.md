---
name: devpost-writer
description: >
  Schreibt die Projektbeschreibung für Devpost oder eine andere Hackathon-Abgabeplattform aus
  Repo, README und Commit-Verlauf, mit den üblichen Abschnitten (Inspiration, What it does,
  How we built it, Challenges, Accomplishments, What we learned, What's next, Built With). Fragt
  nach Sprache und Zeichenlimit und schreibt nur, was im Repo belegbar ist oder vom Team
  bestätigt wurde. Nutze diesen Skill, wenn im Hackathon die Abgabe geschrieben wird:
  "Devpost-Text", "Projektbeschreibung für die Abgabe", "Submission schreiben", "Abgabeformular
  ausfüllen", "write our devpost", "hackathon submission text". NICHT für READMEs (dafür
  readme-quick), Release Notes, Blogposts oder Notizen im Obsidian-Vault.
---

# Devpost-Text schreiben

## Zweck

Die Jury liest die Abgabe oft vor oder nach der Demo und gleicht sie mit dem Repo ab. Ein Text,
der mehr verspricht als der Code hält, kostet Glaubwürdigkeit. Dieser Skill baut die
Beschreibung aus dem, was nachweislich gebaut wurde, und fragt nach dem, was nur das Team
wissen kann.

## Wann nutzen – und wann nicht

**Nutzen:** in den letzten Stunden vor der Abgabe, für Devpost oder vergleichbare Formulare.

**Nicht nutzen:** für die README im Repo (→ `readme-quick`), den Pitch (→ `pitch-builder`),
Release Notes, Blogposts oder Vault-Notizen.

## Vorgehen

1. **Rahmen klären** (gebündelt, höchstens drei Fragen):
   - Sprache (Devpost meist Englisch) und Zeichenlimit pro Feld oder gesamt
   - Plattform und Pflichtfelder. Viele Challenges stellen eigene Fragen, die gehen vor
   - Links: Video, Live-URL, Repo; Teammitglieder
2. **Quellen lesen**, nur lesend:
   - README, `PLAN.md`, Pitch, falls vorhanden
   - Abhängigkeiten (`package.json`, `requirements.txt`, `pyproject.toml` o. Ä.) für *Built With*
   - `git log --no-merges --format='%ad %s' --date=short` im Event-Zeitraum
   - Ordnerstruktur für Architektur-Aussagen
3. **Fakten-Inventar anlegen.** Jede Aussage über Funktion oder Technik braucht einen Beleg
   (Datei, Commit) oder eine Bestätigung des Teams. Ohne Beleg kommt sie unter "Offene
   Fragen", nicht in den Text.
4. **Gebaut, gemockt und geplant trennen.** Gemocktes wird als solches benannt ("Die
   Zahlungsanbindung ist in der Demo simuliert"). Geplantes erscheint nur unter *What's next*.
5. **Subjektives erfragen.** *Inspiration*, *Challenges* und *What we learned* kann das Repo
   nur andeuten (z. B. Revert-Ketten, viele `fix`-Commits an einer Stelle). Pro Abschnitt
   ein, zwei Stichworte vom Team holen, sonst Platzhalter `[vom Team ergänzen]`.
6. **Schreiben.** Pro Abschnitt 2–5 Sätze, aktiv, konkret, in "wir"-Form. *Built With* als
   Liste der tatsächlich genutzten Technologien. Reine Dev-Werkzeuge wie Linter weglassen.
7. **Längen prüfen.** Zeichen pro Feld zählen (z. B. `wc -m`) und gegen das Limit halten.
   Bei Überlänge zuerst Adjektive und Wiederholungen streichen, nicht Fakten.

## Ausgabeformat

Markdown, direkt kopierbar (Devpost rendert Markdown):

```markdown
## Inspiration
## What it does
## How we built it
## Challenges we ran into
## Accomplishments that we're proud of
## What we learned
## What's next for ‹Projekt›
## Built With
‹tech›, ‹tech›, …
```

Danach, getrennt vom kopierbaren Text:

```markdown
**Zeichen:** ‹n› / ‹Limit›
**Belege:** ‹Aussage› → ‹Datei/Commit›   (nur die wichtigsten)
**Offene Fragen:** …
```

## Grenzen

- Erfindet keine Features, Nutzerzahlen, Partner oder Ergebnisse.
- Reicht nichts ein und postet nichts. Kopieren und Abschicken macht das Team.
- Keine Secrets, internen URLs oder privaten Teamdaten im Text.
- Verlangen die Event-Regeln eine Angabe zu genutzten KI-Werkzeugen, darauf hinweisen. Was
  angegeben wird, entscheidet das Team.
