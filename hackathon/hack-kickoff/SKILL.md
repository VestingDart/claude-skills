---
name: hack-kickoff
description: >
  Startplan für einen Hackathon: übersetzt Challenge-Text und Jury-Kriterien in eine Gewichtung,
  formuliert das Problem in einem Satz, trennt MVP von Stretch, streicht Features ohne
  Kriterium, verteilt Rollen nach Teamstärken und plant rückwärts ab der Abgabe (mit Puffer und
  Feature-Freeze). Nutze diesen Skill, wenn ein Hackathon oder eine Challenge mit Jury gerade
  beginnt oder kurz bevorsteht und geplant werden soll: "Hackathon startet", "wir haben die
  Challenge", "Kickoff", "wie teilen wir das auf", "Zeitplan bis zur Abgabe", "hackathon plan",
  "challenge brief", "judging criteria", "START Hack", "Game Jam". Nur im Hackathon-Kontext.
  NICHT für normale Projekt- oder Sprintplanung und nicht für allgemeine Ideenkritik (dafür
  idea-challenger).
---

# Hackathon-Kickoff

## Zweck

Die erste Stunde entscheidet, ob am Ende eine laufende Demo steht oder drei halbe Features.
Dieser Skill macht aus Challenge-Text und Jury-Kriterien einen einseitigen Plan, bevor die
erste Zeile Code entsteht. Der Massstab ist immer die Jury: Was sie in der Demo nicht sieht,
bringt keine Punkte.

## Wann nutzen – und wann nicht

**Nutzen:** zu Beginn eines Hackathons, sobald die Challenge bekannt ist; oder wenn ein Team
nach einem Pivot mitten im Event neu planen muss.

**Nicht nutzen:** für Sprint- oder Projektplanung ohne Jury und Abgabefrist; für die Frage,
ob eine Idee grundsätzlich taugt (→ idea-challenger); für einzelne Ideen während des Events
(→ scope-guard).

## Vorgehen

1. **Input sammeln.** Gebraucht werden: Challenge-Text, Jury-Kriterien (mit Gewichtung, falls
   genannt), Teamgrösse und echte Skills pro Person, Zeitrahmen (Start, Abgabe, Pitch), Regeln
   (vorbereiteter Code erlaubt? Pflicht-APIs? Abgabeformat?). Fehlt etwas, höchstens drei
   gebündelte Rückfragen. Danach mit benannten Annahmen weiter (z. B. "Kriterien gleich
   gewichtet", "Abgabe = Ende des Events").
2. **Kriterien gewichten.** Nennt die Jury Prozente, übernehmen. Sonst schätzen und als Annahme
   markieren. Pro Kriterium eine Zeile: *Was muss die Jury in der Demo sehen, damit es Punkte
   gibt?* Das ist die eigentliche Übersetzung, die Gewichtung allein hilft beim Bauen nicht.
3. **Problem in einem Satz.** Form: "Für ‹wen› löst ‹Projekt› ‹Problem›, indem ‹Kern›." Passt
   es nicht in einen Satz, ist der Scope zu gross. Dann zuerst das kürzen.
4. **Features gegen Kriterien prüfen.** Alle Ideen sammeln und jedem Feature ein Kriterium
   zuordnen. Ein Feature ohne Kriterium kommt auf die Streichliste, mit Grund. Unsichtbares
   (eigene Auth, Admin-Panel, Einstellungen) landet fast immer dort.
5. **MVP von Stretch trennen.** MVP = der kleinste Satz an Features, der *einen* Demo-Pfad
   durchgehend trägt: vom Einstieg bis zum Moment, in dem die Jury versteht, warum es
   funktioniert. Stretch nach Punkte pro Aufwand sortieren, jeweils mit Bedingung ("nur wenn
   der Demo-Pfad bis Checkpoint 2 läuft").
6. **Rollen nach Stärken verteilen**, nicht nach Wunsch. Jede Person hat eine Hauptaufgabe und
   eine Zweitaufgabe. Von Anfang an je eine Person benennen für: Pitch/Demo und Abgabe
   (Devpost, Video, README). Bei zwei oder weniger Personen Rollen zusammenlegen und das sagen.
7. **Zeitplan rückwärts ab Abgabe.** Reihenfolge von hinten:
   Abgabe ← **Puffer** (10–15 % der Gesamtzeit, mindestens 1 h) ← Abgabe-Material (Pitch,
   Video, Devpost, README) ← **Feature-Freeze** (bei etwa 70–75 % der Zeit) ← Bauen ← Setup.
   Checkpoints alle 3–4 Stunden mit derselben Frage: Läuft der Demo-Pfad? Bei Events über
   24 h Schlaf einplanen. Übermüdete Teams bauen in der letzten Nacht die meisten Bugs.
8. **Top-3-Risiken** mit Gegenmassnahme benennen. Typisch: unbekannte API, Zugang zu Daten,
   Deployment, Person fällt aus, Sponsor-Key kommt zu spät.

## Ausgabeformat

Eine Seite, als Markdown. Auf Wunsch als `PLAN.md` ins Projekt-Repo, aber nur nach Rückfrage.

```markdown
# ‹Projekt› – Hackathon-Plan
**Challenge:** … · **Abgabe:** ‹Datum, Uhrzeit› · **Team:** ‹n› Personen

## Problem
‹ein Satz›

## Jury-Kriterien
| Kriterium | Gewicht | Was die Jury sehen muss |
|---|---|---|

## MVP (muss in der Demo laufen)
- …

## Stretch (in dieser Reihenfolge, mit Bedingung)
1. … – nur wenn …

## Gestrichen
- ‹Feature› – bedient kein Kriterium

## Rollen
| Person | Hauptaufgabe | Zweitaufgabe |
|---|---|---|

## Zeitplan (rückwärts ab Abgabe)
| Bis | Block | Ergebnis |
|---|---|---|
| ‹Zeit› | Setup | Hello World läuft bei allen |
| ‹Zeit› | Checkpoint 1 | Demo-Pfad als Skelett |
| ‹Zeit› | Feature-Freeze | nur noch Bugfixes am Demo-Pfad |
| ‹Zeit› | Abgabe-Material | Pitch, Video, Devpost, README |
| ‹Zeit› | Puffer | – |
| ‹Zeit› | **Abgabe** | |

## Risiken (Top 3)
| Risiko | Gegenmassnahme |
|---|---|

## Annahmen
- …
```

Danach in einem Satz auf die nächsten Schritte verweisen: Stack mit `hack-stack-picker`,
Grundgerüst mit `hack-scaffold`. Die Gesamtübersicht steht in `hackathon/README.md`.

## Grenzen

- Plant nur. Schreibt keinen Code und legt keine Dateien an, ausser nach Rückfrage.
- Event-Regeln gehen vor. Ist unklar, ob vorbereiteter Code oder bestimmte Tools erlaubt
  sind, nachfragen statt annehmen.
- Geschätzte Gewichtungen und Zeiten sind als Schätzung markiert, nie als Fakt.
