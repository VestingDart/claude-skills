---
name: obsidian-vault-organizer
description: >
  Struktur im Obsidian-Vault von VestingDart in Ordnung halten. Nutze diesen Skill, wenn eine Datei
  im Vault angelegt, verschoben, umbenannt, zusammengeführt oder aufgeteilt werden soll, wenn ein
  Ordner neu sortiert wird, oder wenn der Nutzer sagt "sortier das ein", "räum den Vault auf",
  "mach einen Ordner für X", "das gehört woanders hin", "benenn das um", "wo soll das hin".
  Ebenfalls nutzen, bevor eine neue Notiz irgendwo abgelegt wird, damit sie nicht an einer
  willkürlichen Stelle landet. Der Skill schlägt den Zielort vor, führt es aus, prüft die
  Wiki-Links und meldet am Ende, was wo liegt. Nicht für das Verfassen von Doku-Inhalten —
  dafür ist obsidian-documentation da.
---

# Vault-Struktur pflegen

Ein Vault verfällt nicht durch schlechte Notizen, sondern dadurch, dass niemand weiß, wo etwas
liegt. Dieser Skill hält die Struktur konsistent und sorgt dafür, dass beim Umsortieren keine
Links brechen.

**Abgrenzung:** [[obsidian-documentation]] entscheidet, *ob* etwas dokumentiert wird, und
schreibt den Inhalt. Dieser Skill entscheidet, *wo* es liegt und wie es heißt, und räumt
Bestehendes um. Beim Anlegen einer neuen Doku greifen beide: Inhalt von dort, Ablageort von hier.

---

## Arbeitsweise: vorschlagen, machen, melden

Der Nutzer will nicht bei jedem Schritt gefragt werden, aber er will wissen, was passiert ist.
Deshalb immer in dieser Reihenfolge:

1. **In einem Satz sagen, was du vorhast** — mit dem konkreten Zielpfad, nicht "ich sortiere das
   ein". Er soll widersprechen können, bevor es passiert, ohne dass du auf eine Antwort wartest.
2. **Ausführen**, inklusive Link-Prüfung (siehe unten).
3. **Melden**, was jetzt wo liegt. Bei mehr als zwei Dateien als kleiner Baum, sonst als Satz.

Eine Rückfrage *vor* der Ausführung ist nur in diesen Fällen nötig:

- Ein neuer **Top-Level-Ordner** soll entstehen. Die oberste Ebene ist seine Landkarte; die
  ändert man nicht nebenbei.
- Eine Datei würde **gelöscht** oder ihr Inhalt überschrieben. Umbenennen und Verschieben ist
  harmlos und reversibel, Löschen nicht.
- Zwei Notizen sollen **zusammengeführt** werden, wobei Inhalt wegfallen würde.
- Der richtige Ort ist **echt unklar** — zwei Ordner wären gleich plausibel. Dann die zwei
  Optionen nennen statt zu raten.

---

## Vault finden

Auf dem Linux-Rechner: `~/Desktop/Notizen/notizen/`. Vorher verifizieren, die Struktur wächst:

```bash
find ~ -maxdepth 4 -name ".obsidian" -type d 2>/dev/null
ls ~/Desktop/Notizen/notizen/
```

Achtung: es gibt zwei `.obsidian`-Ordner (`Notizen/` und `Notizen/notizen/`). Der echte Vault
mit den Inhalten ist `Notizen/notizen/`. Die `Welcome.md` eine Ebene höher gehört nicht dazu.

---

## Wo etwas hingehört

Die oberste Ebene ist nach **Lebensbereich** sortiert, nicht nach Dateityp. Innerhalb eines
Bereichs wird nach Thema verschachtelt, und zwar erst dann, wenn es mehr als eine Notiz zum
Thema gibt — ein Ordner mit einer einzigen Datei drin ist nur eine Hürde.

Die aktuelle Struktur immer frisch auflisten, statt aus dieser Tabelle zu arbeiten:

| Bereich | Ordner | Was dort liegt |
|---|---|---|
| Linux, System, Shell | `Linux 🐧/` | Commands, Desktop-Umgebungen; distro-spezifisches in `Linux 🐧/CachyOS/` |
| Programmieren | `Coding 🚀/` | pro Sprache/Thema ein Unterordner (`Node.js 🌿/`, `Claude/`, `Lernen/`) |
| Minecraft-Projekt | `Valeryn.net 📜/` | `Konzept 🧠/`, `Developement 🧩/`, `Team 👥/`, `Ideen 💡/` |
| Spiele | `Gaming/` | pro Spiel ein Unterordner, wenn mehr als eine Notiz |
| Link-Sammlungen | `Links 🔗/` | nur noch themenfremde Sammlungen |
| Aufgaben, Listen | `Tasks 📚/` | |
| Weitere | `Fitness Traker/`, `Unreal Engine/` | |

**Zwei Regeln, die er selbst so entschieden hat:**

- Ein Thema, das eigenständig genug ist, bekommt einen Ordner auf oberster Ebene — es wird nicht
  unter ein verwandtes Thema gehängt. (Linux lag unter `Coding 🚀/` und wurde am 2026-10-12
  hochgezogen, weil es kein Programmier-Unterthema ist.)
- Gehört eine Link-Sammlung klar zu einem Thema, liegt sie **beim Thema** und heißt dort
  `Links 🔗.md` — nicht im globalen `Links 🔗/`-Ordner mit dem Thema als Dateinamen.
  (So wurde aus `Links 🔗/Linux 🐧.md` → `Linux 🐧/Links 🔗.md`.)

Das dahinterliegende Prinzip: **der Ordner sagt das Thema, der Dateiname sagt den Inhalt.**
Wenn Ordner- und Dateiname dasselbe sagen, ist einer davon falsch.

---

## Namen

- Sprechender Titel mit Emoji am Ende: `Basic Commands 💻.md`, `Root Server 🛡️.md`
- Leerzeichen sind erlaubt und üblich — keine Kebab-Case-Namen erfinden
- Sprache wie im Nachbarordner (gemischt Deutsch/Englisch, nicht angleichen)
- Das Emoji passt zum Inhalt und wird bei verwandten Notizen wiederverwendet (🐧 Linux, 💻
  Terminal, 🔗 Links, ☁️ Sync, 🎮 Gaming)
- Kein Emoji erzwingen, wenn keines passt

---

## Links nicht brechen

Obsidian löst `[[Name]]` über den **Dateinamen** auf, nicht über den Pfad. Daraus folgt:

- **Verschieben** ist unkritisch — Links bleiben heil.
- **Umbenennen** bricht jeden Link, der auf den alten Namen zeigt.

Deshalb vor jedem Umbenennen prüfen, wer auf die Datei zeigt:

```bash
cd ~/Desktop/Notizen/notizen
grep -rn "\[\[Alter Name" --include="*.md" .
```

Findet sich etwas, nach dem Umbenennen mitziehen:

```bash
grep -rl "\[\[Alter Name\]\]" --include="*.md" . | xargs sed -i 's|\[\[Alter Name\]\]|[[Neuer Name]]|g'
```

Auch auf Links mit Alias (`[[Name|Anzeigetext]]`) und auf eingebettete Notizen (`![[Name]]`)
achten — das Suchmuster `[[Alter Name` ohne schließende Klammern findet beide.

Nach dem Umräumen einmal melden, ob Links angepasst werden mussten oder keine betroffen waren.
Das ist die Information, die er braucht, um dem Ergebnis zu trauen.

---

## Umsortieren in größerem Stil

Wenn mehrere Dateien oder ganze Ordner wandern:

1. **Erst den Ist-Zustand zeigen** (`find <ordner>`), damit beide vom gleichen Bild ausgehen.
2. Bewegungen mit `mv` ausführen — nicht kopieren und löschen, das verliert die Git-Historie
   des Vaults.
3. Nach jedem Schritt den neuen Stand prüfen, nicht blind weiterziehen.
4. Am Ende einen kleinen Baum des Ergebnisses zeigen und dazu, was mit den Links passiert ist.

Leere Ordner, die beim Umräumen übrig bleiben, entfernen (`rmdir`) — aber nur, wenn sie wirklich
leer sind, und das dann erwähnen.

---

## Git

Der Vault ist ein Git-Repo mit dem obsidian-git-Plugin. **Nicht committen und nicht pushen**,
außer der Nutzer verlangt es ausdrücklich — das Plugin macht das selbst. Beim Melden einmal
erwähnen, dass nicht committet wurde, damit er es nicht vermutet.
