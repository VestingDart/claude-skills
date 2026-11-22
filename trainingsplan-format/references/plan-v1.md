# Format plan-v1 für Trainingspläne

Die Trainings-App liest Pläne nur in diesem Format. Gib den Plan als eine Markdown-Datei `plan.md` aus, ohne Text davor oder danach.

## Aufbau

```markdown
# Trainingsplan: Aufbau Winter, Teil 2

- Format: plan-v1
- Zeitraum: 2026-11-23 bis 2026-12-20

## Hinweise für den Coach
Freier Text für den Coach in der App (ein kleineres Modell, das jede Einheit kommentiert
und Fragen beantwortet). Schreib hier, worauf es in diesem Plan ankommt, woran er eine gute
Einheit erkennt und wann er zu Kürzen oder Pause raten soll.

## Block: Aufbau 1 (aufbau)
- Zeitraum: 2026-11-23 bis 2026-12-13

### Woche ab 2026-11-23

#### Mo 2026-11-23 18:00 | Laufen | Intervalle 5x1000 m
- Dauer: 60 min
- Distanz: 9 km
- Zone: 4
- Puls: 170-184
- Pace: 4:15-4:25 /km
- Zweck: Tempohärte für die 10 km
- Ablauf: 15 min einlaufen (6:30 /km), 4 Steigerungen. 5x1000 m mit 2 min Trabpause. 10 min auslaufen.

#### Mi 2026-11-25 19:00 | Schwimmen | Technik
- Dauer: 60 min
- Distanz: 1100 m
- Zone: 2
- Pace: 2:20-2:30 /100 m
- Zweck: Wasserlage und Armzug
- Ablauf: 200 m einschwimmen. 8x50 m Drills mit 20 s Pause. 6x50 m Kraul locker. 100 m ausschwimmen.

#### Do 2026-11-26 18:00 | Kraft | Oberkörper und Rumpf
- Dauer: 60 min
- Optional: ja
- Ablauf: Latzug 3x8, Rudern 3x10, Liegestütze 3x12, Dead Bug 3x10 pro Seite.

## Block: Erholung (erholung)
- Zeitraum: 2026-12-14 bis 2026-12-20
```

## Regeln

**Kopf**
- Erste Zeile: `# Trainingsplan: Titel`.
- `- Format: plan-v1` und `- Zeitraum: JJJJ-MM-TT bis JJJJ-MM-TT` sind Pflicht. Der Zeitraum beginnt an einem Montag und endet an einem Sonntag.
- Der Import ersetzt alle geplanten Einheiten in diesem Zeitraum. Was im Zeitraum nicht im neuen Plan steht, fällt weg. Schreib deshalb auch feste Termine wie den Turnverein wieder hinein.

**Blöcke**
- `## Block: Name (typ)`, darunter `- Zeitraum: … bis …`. Typ ist `aufbau`, `erholung` oder `test`.
- Blöcke liegen im Zeitraum des Plans und überschneiden sich nicht.
- `### Woche ab JJJJ-MM-TT` dient nur der Gliederung.

**Einheiten**
- Überschrift: `#### Wochentag Datum Uhrzeit | Sportart | Titel`. Wochentag als Mo, Di, Mi, Do, Fr, Sa, So. Er muss zum Datum passen, sonst wird der Plan abgelehnt.
- Sportart: Laufen, Rad, Schwimmen, Kraft oder Turnverein.
- Uhrzeit ist die Startzeit in Schweizer Zeit, 24 Stunden.
- Felder, je eine Zeile `- Feld: Wert`:

| Feld | Pflicht | Format | Bedeutung |
|---|---|---|---|
| Dauer | ja | `60 min` | ganze Einheit inklusive Ein- und Auslaufen |
| Distanz | nein | `9 km` oder `1200 m` | Ziel-Distanz |
| Zone | nein | `1` bis `5` | Pulszone des Hauptteils |
| Puls | nein | `140-155` | Ziel-Puls des Hauptteils in Schlägen pro Minute |
| Pace | nein | `6:20-6:50 /km`, `2:10 /100 m` | Ziel-Tempo des Hauptteils |
| Optional | nein | `ja` oder `nein` | optionale Einheiten zählen nicht zum Pflichtumfang |
| Zweck | nein | ein Satz | wozu die Einheit dient |
| Ablauf | nein | Text | Einlaufen, Hauptteil mit Pausen, Auslaufen |

- Gib bei Ausdauer-Einheiten immer Zone und Puls an und bei Lauf und Schwimmen zusätzlich die Pace. Die Pulszonen stehen im Abschnitt «Athlet» des Exports und stammen aus Strava: verwende genau diese Grenzen und rechne keine eigenen aus. Der Puls einer Einheit liegt ganz innerhalb der genannten Zone.
- Bei Intervallen beschreiben Zone, Puls und Pace die Belastungsphasen. Das Ein- und Auslaufen steht im Ablauf.
- Keine weiteren Felder, keine Tabellen, keine verschachtelten Listen innerhalb einer Einheit.

## Was die App prüft

Abgelehnt wird der Plan bei: falschem Wochentag, unbekannter Sportart, fehlender Dauer, Einheiten ausserhalb des Zeitraums, überlappenden Blöcken, doppelten Einheiten zur selben Zeit.

Gewarnt wird bei: mehr als 30 % mehr Trainingszeit als in der Vorwoche, einer Woche ohne freien Tag, einem Puls, der nicht ganz in der genannten Zone liegt.
