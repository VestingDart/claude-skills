---
name: pitch-builder
description: >
  Baut den Pitch für die Hackathon-Jury: Struktur (Problem, Lösung, Live-Demo, Technik,
  Impact/Ausblick, Team), Sprechtext mit Zeit pro Abschnitt, 6–8 Folien nur als Stichwörter und
  drei erwartbare Jury-Fragen mit Antwortentwürfen, zugeschnitten auf Redezeit (Standard 3–5
  Minuten) und Jury-Kriterien. Der Text klingt laut gesprochen natürlich, ohne
  Marketing-Floskeln. Nutze diesen Skill, wenn für einen Hackathon der Pitch entsteht oder
  geübt wird: "Pitch schreiben", "Jury-Präsentation", "was sagen wir in den 3 Minuten",
  "Folien für den Pitch", "pitch for the judges", "hackathon presentation", "demo day pitch".
  NICHT für Investoren- oder Sales-Pitches ausserhalb eines Hackathons und nicht für die
  technische Demo-Absicherung (dafür demo-safety-net).
---

# Hackathon-Pitch

## Zweck

Die Jury sieht zwanzig Projekte an einem Nachmittag. Sie erinnert sich an das, was in drei
Minuten klar, konkret und vorgeführt war. Dieser Skill baut einen Pitch, der jedes
Jury-Kriterium einmal sichtbar bedient und sich laut gesprochen wie ein Mensch anhört.

## Wann nutzen – und wann nicht

**Nutzen:** nach dem Feature-Freeze, wenn klar ist, was die Demo zeigt; und zum Kürzen oder
Üben eines bestehenden Pitches.

**Nicht nutzen:** für Investoren-, Sales- oder Konferenz-Präsentationen; für die technische
Checkliste vor der Demo (→ `demo-safety-net`).

## Vorgehen

1. **Input sammeln.** Projekt (README, Plan, Repo lesen), Jury-Kriterien, Redezeit, Sprache,
   wer spricht, Live-Demo ja/nein, Zeit für Fragen. Fehlt die Redezeit: mit 3 Minuten planen
   (kürzen ist schwerer als strecken) und das als Annahme nennen.
2. **Zeit budgetieren.** Gesprochen etwa 120–130 Wörter pro Minute. Richtwerte:

   | Abschnitt | 3 min | 5 min |
   |---|---|---|
   | Problem | 0:25 | 0:40 |
   | Lösung | 0:20 | 0:30 |
   | Live-Demo | 1:15 | 2:00 |
   | Technik | 0:20 | 0:40 |
   | Impact / Ausblick | 0:15 | 0:30 |
   | Team / Schluss | 0:05 | 0:20 |

   Die Demo ist der grösste Block. Ohne Live-Demo: Video oder Screenshots an derselben Stelle.
3. **Kriterien abbilden.** Jedes Jury-Kriterium bekommt einen Ort im Pitch, wo es *hörbar*
   bedient wird. Ein Kriterium ohne Ort ist verschenkt.
4. **Sprechtext schreiben.** Regeln für gesprochene Sprache:
   - Kurze Sätze, höchstens etwa 15 Wörter. Verben statt Substantivketten.
   - Erster Satz ist das Problem, konkret, mit einer Person oder Situation. Nicht "Hallo,
     wir sind Team X".
   - Eine konkrete Zahl schlägt drei Adjektive, aber nur belegte Zahlen. Sonst `[Zahl prüfen]`.
   - Verboten: "revolutionär", "nahtlos", "Game Changer", "die Zukunft von", "innovativ",
     "disruptiv", "next level", "KI-gestützt" ohne Inhalt, "wir freuen uns".
   - Übergänge, die man sagen kann: "Schauen wir es uns an." statt Folie "Demo".
   - Letzter Satz: was als Nächstes kommt oder was das Team sich wünscht. Kein "Danke für
     eure Aufmerksamkeit" als Inhalt.
5. **Folien.** Höchstens 6–8. Pro Folie ein Titel und höchstens drei Stichwörter oder ein Bild.
   Eine Folie markiert den Wechsel in die Demo; eine Backup-Folie hält Screenshots bereit.
6. **Jury-Fragen.** Die drei wahrscheinlichsten, abgeleitet aus Kriterien und Schwachstellen.
   Typisch: Was ist echt und was gemockt? Was unterscheidet euch von ‹bestehende Lösung›? Wie
   geht es weiter, wer bezahlt? Datenschutz? Antworten höchstens drei Sätze, ehrlich. Gemocktes
   offen zugeben, das kostet weniger als dabei ertappt zu werden.
7. **Lautprobe.** Wortzahl pro Abschnitt angeben und empfehlen, einmal laut mit Timer zu
   lesen. Was beim Lesen stolpert, umschreiben.

## Ausgabeformat

```markdown
## Pitch – ‹Projekt› (‹Redezeit›, ‹Sprache›)

| Kriterium | Wo im Pitch |
|---|---|

### 1. Problem (0:00–0:25, ~55 Wörter)
‹Sprechtext›

### 2. Lösung (…)
…

### 3. Live-Demo (…)
| Zeit | Aktion | Satz |
|---|---|---|

…

## Folien
1. ‹Titel› – ‹Stichwort, Stichwort›
…

## Jury-Fragen
1. **‹Frage›** – ‹Antwort, max. 3 Sätze›

## Offen
- [Zahl prüfen] …
```

## Grenzen

- Erfindet keine Zahlen, Nutzer, Partner oder Ergebnisse. Unbelegtes wird markiert.
- Erstellt keine Foliendatei, ausser auf Wunsch; dann mit den vorhandenen Slides- bzw.
  pptx-Werkzeugen.
- Ersetzt keine Probe. Der Text ist ein Entwurf, bis ihn jemand laut gesprochen hat.
