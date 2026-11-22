---
name: ui-ohne-ki-look
description: Sorgt dafür, dass Oberflächen nicht nach KI-generiertem Standard aussehen. Nutze diesen Skill IMMER, bevor eine UI-Komponente, Seite, Karte, Tabelle, ein Formular, Chart, Dashboard oder eine Website gebaut oder umgebaut wird (React, Vue, Svelte, HTML, Tailwind, CSS), auch wenn der Nutzer das Aussehen nicht erwähnt. Ebenfalls nutzen, wenn er sagt "sieht nach KI aus", "zu generisch", "sieht aus wie ein Template", "mach das weniger KI", "prüf das Design", oder bevor ein PR mit sichtbaren Änderungen aufgeht. Prüft vor dem Bauen die Design-Regeln des Projekts, baut nach festen Ersatzregeln und kontrolliert am Ende mit einem Prüfskript und einem Screenshot. Nicht für reine Logik ohne Oberfläche, nicht für Artifacts auf claude.ai (dafür gibt es eigene Design-Regeln) und nicht für Texte ohne UI.
---

# UI ohne KI-Look

VestingDart will Oberflächen, die aussehen, als hätte sie ein Mensch für genau diese App gebaut. Was ein
Sprachmodell ohne Vorgaben baut, sieht überall gleich aus: Emojis als Icons, eine runde Karte pro Eintrag,
Überschriften in Grossbuchstaben, eine riesige Zahl mit kleinem Etikett, Verläufe, viel Akzentfarbe. Wer das
einmal gesehen hat, erkennt es sofort, und die App wirkt dann wie ein Prototyp.

Die Regel ist nicht «schöner machen», sondern **die Standardentscheidung bewusst durch eine passende ersetzen**.
Jede Fläche, Farbe und Hervorhebung muss einen Grund haben, den man in einem Satz sagen kann.

## Ablauf

### 1. Vor dem Bauen: Regeln des Projekts finden

Zuerst nachsehen, was es schon gibt, und das verwenden statt Neues zu erfinden:

- Design-Tokens: `tailwind.config.*` (eigene Farben wie `paper`, `ink`, `accent`), CSS-Variablen in
  `:root`, ein `theme.ts` für Charts
- gemeinsame Klassen in `index.css` / `globals.css` (`@layer components`: z.B. `.surface`, `.btn-primary`)
- Bausteine wie `Icon`, `Tag`, `Badge`, `Button` in `src/components/`
- Design-Regeln in `CLAUDE.md`, `README.md`, `docs/` oder im Memory

Gibt es Tokens, **nur diese** verwenden: keine rohen `zinc-`/`slate-`/`gray-`/`blue-`-Klassen und keine
Hex-Farben in Komponenten. Gibt es noch keine, dann zuerst kleine Tokens anlegen (Flächen, Schrift in 3–4
Stufen, **eine** Akzentfarbe, Zustandsfarben) und erst dann die Komponente bauen. Das in einem Satz sagen.

### 2. Beim Bauen: die Ersatzregeln

| KI-Standard | Stattdessen |
|---|---|
| Emojis als Icons (🏃 🔥 💪 ✨ 📊) | echte SVG-Icons aus einem Satz (eigene `Icon`-Komponente oder lucide), oder ein farbiger Punkt mit Wort |
| Jeder Eintrag in einer eigenen runden Karte mit Schatten | wenige Flächen, darin Zeilen mit feinen Trennlinien (`divide-y`); Listen als Tabelle, wenn es Spalten gibt |
| `rounded-2xl`/`rounded-3xl`, `shadow-lg`/`shadow-xl` | kleine Rundung (`rounded-md`/`rounded-lg`), dezenter Rand statt Schatten |
| Überschriften in GROSSBUCHSTABEN mit `tracking-widest` | normal geschriebene Titel in Satzschreibung, klein und halbfett |
| Riesige Zahl mit Mini-Etikett («4'333 PTS»), Kennzahlen-Kacheln im Raster | Kennzahlen in einer Zeile oder Tabelle, Zahl und Einheit gleich gross, `tabular-nums` |
| Akzentfarbe überall (Buttons, Rahmen, Icons, Text) | Akzent nur für die eine Hauptaktion und den aktuellen Zustand (heute, ausgewählt) |
| Pillen-Buttons, Pillen-Badges in Regenbogenfarben | rechteckige Buttons mit kleiner Rundung; Status als Punkt + Wort |
| Verläufe, Glas-Effekt (`backdrop-blur`), leuchtende Ränder | einfarbige Flächen in 2–3 Helligkeitsstufen |
| Blau-violette Standardpalette, kaltes `zinc`/`slate` | eigene, zur App passende Farben; Kategoriefarben auf Farbenblindheit geprüft |
| Donut-/Tortendiagramm | sortierte Balkenliste mit Zahl daneben |
| Recharts/Chart.js im Standard-Look (Gitter, Legende oben, Tooltip-Box) | ein gemeinsames Chart-Thema: leise Achsen, kaum Gitter, direkte Beschriftung statt Legende |
| Chat mit Sprechblasen links/rechts | Gesprächsprotokoll: Zeilen mit Absender oder Stichwort am Rand |
| Drei Feature-Karten mit Icon im farbigen Kreis | Text mit Struktur; Icons nur, wo sie etwas unterscheiden |
| `animate-pulse`-Skelette, Hover-Hebeeffekte (`hover:scale`, `-translate-y`) | schlichtes «Laden…» oder Platzhalterzeile; Hover nur Farbwechsel |
| Text und Überschriften mittig ausgerichtet, viel Leerraum | Text linksbündig, dichter, Informationen nebeneinander, wo Platz ist. Bei Dashboards und App-Ansichten nutzt der Inhalt die ganze freie Breite neben der Seitenleiste (nur Seitenrand, keine `max-w-…`), damit auf grossen Bildschirmen kein leerer Streifen bleibt. Fliesstext wie Doku oder Artikel darf schmaler sein |

**Texte gehören dazu.** KI-Look entsteht auch über Wörter:

- keine Ausrufezeichen und keine Begrüssungen («Willkommen zurück! 👋», «Los geht's!»)
- keine Marketing-Floskeln («Entfessle dein Potenzial», «Insights», «Smart», «Powered by AI»)
- Beschriftungen sagen, was da ist: «Distanz pro Woche» statt «Deine Fortschritte»
- Leerzustände sagen, was zu tun ist: «Noch keine Aktivitäten. Strava verbinden, um sie zu laden.»
- die Sprache der App einhalten (Deutsch mit Schweizer Schreibweise, wenn die App so schreibt)

### 3. Nach dem Bauen: prüfen

**a) Prüfskript.** Findet die Muster aus der Tabelle, die man im Code erkennen kann:

```bash
bash ~/.claude/skills/ui-ohne-ki-look/scripts/ki-look-check.sh <projektordner>/src
```

Das Skript sucht nur Hinweise. Ein Treffer ist nicht automatisch falsch: Ein `rounded-full` für einen
Statuspunkt ist richtig, ein `rounded-full` für einen Button nicht. Jeden Treffer ansehen und entscheiden.
Hex-Farben sind in Token-Dateien (`tailwind.config`, `theme.ts`, `index.css`) erlaubt.

**b) Hinsehen.** Viele Muster erkennt kein grep: zu viele Kästen, alles gleich laut, Zahlen ohne Bezug.
Darum die geänderte Ansicht in Desktop- und Handybreite ansehen. Wenn die App einen Login braucht, mit dem
Skill `ui-vorschau-ohne-login`. Beim Ansehen fragen:

- Wie viele umrandete Flächen sehe ich? Lassen sich welche zu einer mit Trennlinien zusammenlegen?
- Wo ist die Akzentfarbe? Ist jede Stelle die wichtigste Aktion oder der aktuelle Zustand?
- Würde ein Mensch, der nur diese App baut, das so machen, oder ist es die Vorlage aus jedem Tutorial?
- Steht irgendwo ein Emoji, ein Ausrufezeichen oder ein Wort in Grossbuchstaben?

Was auffällt, sofort ändern und neu ansehen, nicht nur notieren.

## Melden

Am Ende kurz sagen, was geprüft wurde:

```
KI-Look geprüft: Prüfskript ohne Treffer (2 Statuspunkte mit rounded-full sind gewollt),
Ansicht «Aktivitäten» am Desktop und am Handy angesehen. Geändert: Karten pro Eintrag → Tabelle.
```

Konnte eine Ansicht nicht angesehen werden, das so sagen und nicht «sieht gut aus» behaupten.

## Wenn der Nutzer etwas will, das auf der Liste steht

Die Tabelle ist der Standard, kein Verbot. Will er ausdrücklich eine Karte, ein Emoji oder einen Verlauf,
wird das gebaut. Höchstens einmal kurz sagen, dass es vom bisherigen Stil abweicht, dann nicht weiter
diskutieren. Wiederholt er den Wunsch, gilt er als neue Regel für das Projekt.
