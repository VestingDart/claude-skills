---
name: scope-guard
description: >
  Schneller Scope-Check während eines laufenden Hackathons: prüft jede neue Idee und jeden
  Änderungswunsch mit drei festen Fragen (bringt es Jury-Punkte, passt es in die Restzeit,
  gefährdet es MVP oder Demo) und antwortet mit Go / Später / Streichen plus zwei Sätzen
  Begründung. Blockiert nie, empfiehlt nur. Nutze diesen Skill nur, wenn ein Hackathon gerade
  läuft und das Team mittendrin etwas ergänzen oder umbauen will: "sollen wir noch X
  einbauen", "schaffen wir das noch bis zur Abgabe", "noch schnell ein Feature", "lohnt sich das
  für die Jury", "should we add this before the deadline", "scope creep hackathon". NICHT vor
  oder ausserhalb eines Hackathons und nicht für grundsätzliches Ideen-Sparring ohne Deadline
  (dafür idea-challenger).
---

# Scope-Guard

## Zweck

Mitten im Hackathon kommt alle zwanzig Minuten eine gute Idee. Jede einzelne ist klein, und
zusammen kosten sie die Demo. Dieser Skill trifft in Sekunden eine Empfehlung mit immer
denselben drei Fragen, damit das Team nicht jedes Mal neu diskutiert.

## Abgrenzung zu idea-challenger

| | idea-challenger | scope-guard |
|---|---|---|
| Situation | Idee oder Konzept, ohne harte Deadline | laufender Hackathon, Uhr läuft |
| Ziel | bessere Idee durch kritische Fragen | Entscheidung in einer Minute |
| Form | Spiegeln, Fragen, Haken, Vorschlag | drei feste Fragen, ein Urteil |

Ist die "Idee" in Wahrheit ein Pivot (Problem oder Zielgruppe ändern sich), ist scope-guard
das falsche Werkzeug: kurz idea-challenger, dann den Plan mit `hack-kickoff` neu schneiden.

## Wann nutzen – und wann nicht

**Nutzen:** während des Events, bei jedem neuen Feature, Umbau oder "nur noch schnell".

**Nicht nutzen:** vor dem Start (→ hack-kickoff), ausserhalb von Hackathons, bei Bugfixes am
Demo-Pfad. Die sind kein Scope, sondern Pflicht.

## Vorgehen

1. **Kontext holen.** Restzeit bis Feature-Freeze und Abgabe, Stand des Demo-Pfads, Jury-
   Kriterien. Aus dem Plan von `hack-kickoff` (Gespräch oder `PLAN.md`), falls vorhanden.
   Fehlt es, *eine* gebündelte Frage: "Wie viel Zeit bis zur Abgabe, und läuft der Demo-Pfad
   schon?" Keine Antwort: konservativ annehmen und die Annahme nennen.
2. **Die drei Fragen.**
   - **Punkte:** Welches Jury-Kriterium bedient es, und *sieht* die Jury es in der Demo?
     Refactoring, Tests, Edge Cases und Settings sieht sie fast nie.
   - **Zeit:** Schätzung des Teams mal zwei (Hackathon-Schätzungen sind optimistisch). Passt
     das vor den Feature-Freeze, ohne den Puffer anzugreifen?
   - **Risiko:** Berührt es Demo-Pfad, DB-Schema, Auth oder Deployment? Lässt es sich
     sauber abbrechen (eigener Branch, Feature-Flag)?
3. **Urteil.**
   - **Go:** Punkte ja, Zeit ja, Risiko gering.
   - **Später:** bringt Punkte, aber MVP noch nicht stabil oder Zeit knapp. Kommt auf die
     Stretch-Liste, mit Bedingung ("wenn der Demo-Pfad bis 14:00 läuft").
   - **Streichen:** keine sichtbaren Punkte, oder Zeit passt nicht, oder hohes Demo-Risiko
     ohne sicheren Rückweg.
   - Nach dem Feature-Freeze gilt grundsätzlich Später oder Streichen.
4. **Empfehlen, nicht blockieren.** Das Team entscheidet. Bei Widerspruch einmal das Risiko
   nennen, dann mithelfen. Dasselbe Argument zweimal zu bringen kostet nur Zeit.

## Ausgabeformat

Eine Idee:

```
**Go | Später | Streichen** – ‹Idee in 3–5 Wörtern›
Punkte ✓/✗ · Zeit ✓/✗ · Risiko niedrig/hoch
‹Satz 1: der entscheidende Grund.› ‹Satz 2: was stattdessen oder unter welcher Bedingung.›
```

Mehrere Ideen auf einmal: eine Tabelle `Idee | Urteil | Begründung (2 Sätze)`, sortiert nach
Go, Später, Streichen.

## Grenzen

- Nur Empfehlung, keine Entscheidung und kein Veto.
- Schreibt keinen Code und ändert keinen Plan, solange das Team nichts anderes sagt.
- Zeitschätzungen sind grob. Bei "Go" mit knapper Zeit einen Abbruchpunkt nennen
  ("läuft es bis 16:00 nicht, zurück auf den Stand davor").
