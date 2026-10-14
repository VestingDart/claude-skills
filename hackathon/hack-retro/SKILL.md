---
name: hack-retro
description: >
  Strukturierte Retro nach einem Hackathon: was lief gut, was hat Zeit gekostet, was würden wir
  anders machen, was ist wiederverwendbar. Leitet daraus konkrete Verbesserungen für die
  Hackathon-Skills ab, schlägt optional ein eigenes Starter-Template vor und bietet nur nach
  Rückfrage eine Notiz im Obsidian-Vault an. Nutze diesen Skill, wenn ein Hackathon vorbei ist:
  "Hackathon-Retro", "was lernen wir aus dem Hackathon", "Nachbesprechung START Hack", "was
  machen wir nächstes Mal anders", "hackathon retrospective", "hackathon post-mortem". NICHT für
  Sprint-Retros, Incident-Post-Mortems oder Rückblicke auf normale Projekte.
---

# Hackathon-Retro

## Zweck

Direkt nach dem Event weiss das Team genau, wo die Stunden verschwunden sind. Eine Woche später
nicht mehr. Dieser Skill hält das fest, sucht Ursachen statt Symptome und macht daraus
Änderungen, die beim nächsten Hackathon wirklich greifen: in den Skills, im Starter, im Ablauf.

## Wann nutzen – und wann nicht

**Nutzen:** am Tag nach dem Event oder spätestens in der Woche danach.

**Nicht nutzen:** für Sprint-Retros, Incident-Analysen oder Projektrückblicke ohne Hackathon.

## Vorgehen

1. **Material sammeln**, nur lesend:
   - Plan aus `hack-kickoff` (Gespräch oder `PLAN.md`), Pitch, Devpost-Text
   - Commit-Verlauf mit Zeit: `git log --reverse --format='%ad %an %s' --date=format:'%a %H:%M'`
   - Ergebnis und Jury-Feedback, falls vorhanden
2. **Fragen, was nicht im Repo steht** (höchstens drei): Platzierung und Jury-Feedback, was
   am meisten genervt hat, was überraschend gut ging.
3. **Plan gegen Ist.** Wann war der Feature-Freeze geplant, wann lag er tatsächlich (Commits
   danach)? Wann lief der Demo-Pfad zum ersten Mal? Gab es lange Commit-Lücken oder eine
   Häufung in der letzten Stunde? Zahlen statt Eindrücke.
4. **Die vier Fragen**, je höchstens fünf Punkte, konkret und mit Beleg:
   - Was lief gut?
   - Was hat Zeit gekostet? (mit grober Stundenzahl)
   - Was würden wir anders machen?
   - Was ist wiederverwendbar? (Code, Config, Texte, Abläufe)
5. **Ursachen statt Symptome.** "Deployment hat drei Stunden gekostet" ist ein Symptom.
   "Wir haben erst nach dem Feature-Freeze zum ersten Mal deployt" ist die Ursache, und nur
   daraus folgt eine Massnahme.
6. **Verbesserungen für die Skills.** Pro Beobachtung: welcher Hackathon-Skill, was genau im
   Text fehlt oder falsch ist, konkreter Formulierungsvorschlag. Nicht selbst ändern.
   Änderungen am Skills-Repo laufen nach Zustimmung über `git-branch-pr-workflow`.
7. **Starter-Template (optional).** Wenn dieselbe Setup-Arbeit wieder angefallen ist: was in
   ein eigenes Template gehört (z. B. Repo `hackathon-starter`), was bewusst nicht, und ob die
   Event-Regeln vorbereiteten Code erlauben. Nur Vorschlag, nichts anlegen.
8. **Vault-Notiz anbieten.** Eine Zeile am Ende, im Sinne von `obsidian-documentation`: was
   in die Notiz käme und wo sie landen würde. Erst nach einem Ja schreiben, Ort und Format
   nach `obsidian-documentation` bzw. `obsidian-vault-organizer`. Ohne Antwort nicht
   nachfragen.

## Ausgabeformat

```markdown
## Retro – ‹Event› (‹Datum›) · Ergebnis: ‹Platzierung/Feedback›

### Plan vs. Ist
| Meilenstein | Geplant | Tatsächlich |
|---|---|---|
| Demo-Pfad läuft | | |
| Feature-Freeze | | |
| Abgabe | | |

### Lief gut
- …
### Hat Zeit gekostet
- ‹was› (~‹h›) – Ursache: …
### Nächstes Mal anders
- …
### Wiederverwendbar
- …

### Vorschläge für die Skills
| Skill | Beobachtung | Vorschlag |
|---|---|---|

### Starter-Template (optional)
…
```

Danach eine einzelne Zeile mit dem Angebot einer Vault-Notiz.

## Grenzen

- Keine Schuldzuweisungen an Personen. Es geht um Ablauf und Entscheidungen.
- Ändert keine Skills, legt kein Template-Repo an und schreibt nichts in den Vault ohne
  ausdrückliche Zustimmung.
- Was nicht belegt ist (Stundenangaben, Ursachen), ist als Schätzung markiert.
