---
name: trainingsplan-format
description: Trainingspläne für die Fitness-App von VestingDart im Format plan-v1 schreiben, prüfen und das Format selbst ändern. Nutze diesen Skill, wenn ein Trainingsplan erstellt, verlängert oder angepasst werden soll ("mach mir einen Trainingsplan", "neuer Plan für die nächsten 4 Wochen", "plan.md", "pass den Plan an"), wenn der Nutzer einen Trainings-Export aus der App einfügt (beginnt mit "# Trainings-Export vom"), wenn eine plan.md vor dem Import geprüft werden soll, oder wenn im Code des Fitness-Trackers am Plan-Format, am Import oder am Export gearbeitet wird. Nicht für allgemeine Trainingsfragen ohne Plan und nicht für den ICS-Kalender-Feed.
---

# Trainingsplan-Format plan-v1

Die Fitness-App (Repo `fitness-tracker`, auf GitHub `VestingDart/fitness-trancker`) liest Trainingspläne nur als
Markdown-Datei im Format **plan-v1**. Der Weg ist immer gleich:

1. In der App: **Plan → «Neuen Plan mit Claude erstellen» → Export**. Der Export ist Markdown mit den Abschnitten
   Auftrag, Athlet (Puls-Eckwerte, Zonen aus Strava, Ziele), Form, Plan-Erfüllung, bestehender Plan, belegte Zeiten,
   Coach-Feedback, gemerkte Hinweise und am Ende «9. Ausgabeformat».
2. Der Nutzer gibt den Export an Claude (Chat oder Claude Code) und bespricht den Plan.
3. Claude gibt eine `plan.md` zurück. Der Nutzer importiert sie in der App, die App zeigt Fehler und Warnungen und
   ersetzt dann alle geplanten Einheiten im Zeitraum.

## Wo die Regeln stehen

- **Massgebend** ist `PLAN_FORMAT_SPEC` in `api/_lib/plan/format.ts` im Repo. Der Parser `parsePlan` in derselben
  Datei setzt genau diese Regeln um.
- `docs/plan-format.md` im Repo wird daraus erzeugt.
- **Im Export** steht dieselbe Beschreibung als Abschnitt «9. Ausgabeformat». Liegt ein Export vor, gilt dieser
  Abschnitt, weil er immer zur installierten App-Version passt.
- `references/plan-v1.md` in diesem Skill ist eine Kopie für den Fall, dass weder Repo noch Export da sind (z.B. im
  claude.ai-Chat ohne Export). Wenn das Repo da ist, kurz vergleichen:
  `diff ~/.claude/skills/trainingsplan-format/references/plan-v1.md <repo>/docs/plan-format.md`.
  Weicht sie ab, gilt das Repo, und die Kopie im Skill-Repo nachziehen.

Vor dem Schreiben eines Plans die Regeln aus einer dieser Quellen lesen, nicht aus dem Gedächtnis schreiben.

## Einen Plan schreiben

**Ausgabe:** nur die `plan.md`, ohne Text davor oder danach. Im Chat als ein Markdown-Codeblock, in Claude Code als
Datei. Erklärungen zum Plan gehören vorher ins Gespräch oder in den Abschnitt `## Hinweise für den Coach`.

**Inhaltliche Regeln, die der Nutzer festgelegt hat:**

- **Pulszonen genau aus Strava.** Die Grenzen stehen im Export unter «Athlet». Keine eigenen Zonen ausrechnen, keine
  Formeln mit Maximalpuls. Fehlen die Zonen, nachfragen statt raten.
- Der Puls einer Einheit liegt ganz innerhalb der angegebenen Zone.
- Bei Ausdauer-Einheiten immer Zone und Puls angeben, bei Laufen und Schwimmen zusätzlich die Pace.
- **Der Import ersetzt alles im Zeitraum.** Feste Termine (Turnverein und alles aus «Belegte Zeiten») wieder
  hineinschreiben bzw. um sie herum planen.
- Zeitraum von Montag bis Sonntag. Wochentag in der Überschrift muss zum Datum passen.
- Pendeln (E-Bike-Arbeitsweg) ist kein Training und kommt nicht in den Plan.
- Den Inhalt des Plans klärt der Nutzer mit dem grossen Modell im Gespräch. Der Coach in der App (Haiku) passt nur im
  Kleinen an und ändert den Plan nicht selbst. `## Hinweise für den Coach` ist der Ort, ihm zu sagen, worauf es in
  diesem Plan ankommt.
- Coach-Feedback und gemerkte Hinweise aus dem Export (Abschnitte 7 und 8) berücksichtigen und im Gespräch sagen,
  was davon in den Plan eingeflossen ist.

**Häufige Fehler, die zum Ablehnen führen:** falscher Wochentag zum Datum, Sportart ausserhalb von Laufen, Rad,
Schwimmen, Kraft, Turnverein, fehlende `Dauer`, Einheit ausserhalb des Zeitraums, überlappende Blöcke, zwei
Einheiten zur selben Zeit, zusätzliche Felder, Tabellen oder verschachtelte Listen in einer Einheit.

**Warnungen (Import geht trotzdem):** mehr als 30 % mehr Trainingszeit als in der Vorwoche, eine Woche ohne freien
Tag, Puls nicht ganz in der Zone. Solche Stellen nur bewusst stehen lassen und im Gespräch begründen.

## Einen Plan prüfen

Wenn das Repo da ist (Claude Code), jeden Plan vor der Übergabe mit dem Parser der App prüfen:

```bash
cd <repo-fitness-tracker>
npx tsx ~/.claude/skills/trainingsplan-format/scripts/check-plan.mts plan.md --zonen 124,154,169,184 --hrmax 194
```

- `--zonen` sind die Obergrenzen der Zonen 1–4 aus dem Export (Abschnitt «Athlet»), `--hrmax` der Maximalpuls.
  Ohne sie fällt die Prüfung Puls gegen Zone weg. Die Werte oben sind nur ein Beispiel: immer die aus dem aktuellen
  Export nehmen.
- Ausserhalb des Repos: `--repo <pfad>` angeben und `npx --prefix <pfad> tsx …` verwenden.
- Ausgabe: Fehler und Warnungen mit Zeilennummer, dann eine Übersicht pro Woche (Einheiten, Stunden, Sportarten).
  Exit 0 heisst importierbar, 1 heisst Fehler im Plan.

Fehler beheben und erneut prüfen, bis keine mehr kommen. Die Wochenübersicht dem Nutzer zeigen, sie ist die
schnellste Kontrolle, ob der Umfang stimmt.

Ohne Repo (claude.ai-Chat): die Liste «Häufige Fehler» oben Punkt für Punkt durchgehen, vor allem die Wochentage
gegen die Daten. Dem Nutzer sagen, dass der Plan nicht maschinell geprüft ist und die App beim Import prüft.

## Das Format im Code ändern

Gilt, wenn im Repo am Format, am Import (`api/_lib/plan/import.ts`) oder am Export (`api/_lib/plan/export.ts`)
gearbeitet wird.

1. **Nur an einer Stelle ändern:** Regeln in `PLAN_FORMAT_SPEC` und im Parser `parsePlan` gemeinsam anpassen. Nie
   nur die Doku oder nur den Parser.
2. Doku neu schreiben: `npx tsx scripts/write-plan-format.ts`. Ein Test vergleicht `docs/plan-format.md` mit der
   Quelle und schlägt sonst fehl.
3. Tests für die neue Regel in `api/_lib/plan/format.test.ts` ergänzen (ein gültiger und ein abgelehnter Fall),
   dann `npx vitest run`.
4. **Abwärtskompatibilität:** Pläne, die schon in der App liegen oder beim Nutzer gespeichert sind, müssen weiter
   importierbar bleiben. Neue Felder deshalb optional machen. Wird eine bestehende Regel strenger oder ändert sich
   die Bedeutung eines Felds, das Format auf `plan-v2` hochzählen und `plan-v1` weiter lesen können. Vorher mit dem
   Nutzer klären.
5. Braucht ein neues Feld eine neue Spalte in `planned_sessions`, eine Migration in `supabase/migrations/` anlegen.
   Der Nutzer führt sie im Supabase SQL-Editor aus, **bevor** der PR gemergt wird.
6. Danach `references/plan-v1.md` in diesem Skill aus `docs/plan-format.md` aktualisieren (Skill-Repo
   `~/claude-skills`, eigener Branch und PR).

## Melden

Nach einem Plan kurz sagen: Zeitraum, Blöcke, Stunden pro Woche aus der Übersicht, welche festen Termine übernommen
wurden, ob er mit dem Skript geprüft ist (mit Ergebnis) oder nur von Hand.
