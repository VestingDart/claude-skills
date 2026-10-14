---
name: mock-data-gen
description: >
  Erzeugt für eine Hackathon-Demo realistische, deterministische Testdaten und ein
  Seed-Skript passend zum Datenmodell: plausible Namen und Zeitstempel, ein paar Randfälle und
  einige gezielt schöne Demo-Datensätze, mit festem Seed reproduzierbar und ohne echte
  personenbezogene Daten. Nutze diesen Skill im Hackathon-Kontext, wenn für Demo oder Pitch
  Daten fehlen: "Demo-Daten", "Seed-Daten für die Demo", "Fake-Daten für den Hackathon", "die
  App sieht leer aus", "mock data for the demo", "seed script for the hackathon". NICHT für
  Unit-Test-Fixtures, Datenbank-Migrationen oder Daten in normalen Projekten ausserhalb eines
  Hackathons.
---

# Demo-Daten erzeugen

## Zweck

Eine leere App überzeugt keine Jury, und zufällige Daten, die bei jedem Start anders
aussehen, machen die Demo unberechenbar. Dieser Skill liefert ein Seed-Skript, das immer
dieselben, glaubwürdigen Daten erzeugt, inklusive der paar Datensätze, um die herum die Demo
erzählt wird.

## Wann nutzen – und wann nicht

**Nutzen:** sobald das Datenmodell steht und die Demo Inhalte braucht; oder vor der Demo, wenn
die Daten "zu sehr nach Test" aussehen.

**Nicht nutzen:** für Test-Fixtures, Migrationen oder Produktionsdaten; ausserhalb eines
Hackathons.

## Vorgehen

1. **Datenmodell lesen, dann fragen.** Zuerst im Repo nachsehen (ORM-Models, SQL-Schema,
   Migrationen, TypeScript-Typen). Danach nur das Fehlende fragen, gebündelt:
   - Entities und Beziehungen (falls nicht im Repo)
   - Sprache und Region der Daten (z. B. Deutsch, Schweiz, CHF, Zeitzone `Europe/Zurich`)
   - Menge pro Entity
   - Zielform: Seed-Skript für das ORM, SQL-Datei oder JSON
   - Demo-Story: Wer ist die Hauptfigur der Demo, was soll man sehen?
2. **Reihenfolge festlegen.** Nach Fremdschlüsseln sortieren; IDs stabil und vorhersagbar.
3. **Deterministisch generieren.**
   - Faker-Bibliothek der Projektsprache (z. B. `@faker-js/faker`, Python `Faker`) mit
     festem Seed als Konstante oben im Skript (`SEED = 42`). Jeder Zufall läuft über diesen
     Seed, auch eigene Zufallszahlen.
   - Zeitstempel relativ zu einem festen `REFERENCE_DATE` statt `now()`. Optional ein Schalter,
     der die Daten relativ zu heute verschiebt ("vor 2 Stunden"), wobei die Abstände
     deterministisch bleiben.
   - Realistische Verteilungen: nicht alle Werte gleich, Wochentage und Tageszeiten plausibel,
     ein paar Ausreisser.
4. **Randfälle, sparsam.** Leere optionale Felder, sehr lange Namen, Umlaute und Akzente
   (Müller, Zoë), ein Emoji, Grenzwerte, doppelte Namen. Hinter einem Schalter
   (`INCLUDE_EDGE_CASES`), damit sie die Demo nicht verunstalten.
5. **Demo-Datensätze von Hand.** Zwei bis fünf Datensätze, die die Demo-Story tragen
   (z. B. "Lea, drei offene Aufgaben, eine davon überfällig"). Feste IDs, oben im Skript,
   kommentiert. Sie sind der Grund, warum die Demo funktioniert.
6. **Keine echten Personendaten.** Keine realen Namen bekannter Personen, keine echten
   E-Mails. Nur reservierte Domains (`example.com`, `.test`), offensichtlich fiktive
   Telefonnummern, keine Fotos echter Menschen (Initialen oder generierte Platzhalter).
7. **Seed-Skript bauen.** Ein Befehl (z. B. `npm run seed`), idempotent per Upsert. Löscht
   nur mit ausdrücklichem Flag (`--reset`) und sagt vorher, was es leert. Gibt am Ende eine
   Zusammenfassung aus (Anzahl pro Entity).
8. **Reproduzierbarkeit prüfen.** Gegen eine lokale Wegwerf-DB zweimal laufen lassen und
   vergleichen (Anzahl und Hash bzw. Export). Ausführen nur nach Rückfrage, und nie gegen eine
   geteilte oder deployte DB ohne ausdrückliche Zustimmung.

## Ausgabeformat

1. Die Seed-Datei(en), nach Rückfrage im Repo abgelegt (z. B. `scripts/seed.ts`).
2. Kurzübersicht:

```markdown
| Entity | Anzahl | Besonderheiten |
|---|---|---|

**Demo-Datensätze:** ‹ID – Kurzbeschreibung, wofür in der Demo›
**Seed:** 42 · **Referenzdatum:** ‹Datum›
**Starten:** ‹Befehl› · **Zurücksetzen:** ‹Befehl› --reset
**Reproduzierbar geprüft:** ja / nein (‹wie›)
```

## Grenzen

- Nie echte personenbezogene Daten, auch nicht "nur kurz" aus einem echten Export.
- Führt das Skript nicht ohne Rückfrage aus; löscht keine Daten ohne `--reset` und Zustimmung.
- Keine Keys oder Verbindungs-Strings im Skript. Die kommen aus `.env`.
- Das Datenmodell ändert dieser Skill nicht. Passt das Schema nicht zur Demo-Story, das melden.
