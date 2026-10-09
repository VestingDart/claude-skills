---
name: obsidian-documentation
description: >
  Nach komplizierter Arbeit eine Doku im Obsidian-Vault anbieten. Nutze diesen Skill am ENDE
  einer Aufgabe, wenn eines davon zutrifft: ein Problem war kompliziert oder hat mehrere
  Anläufe gebraucht; die Ursache war nicht offensichtlich; auf dem PC oder Laptop wurde etwas
  Grosses neu eingerichtet oder installiert (Dienst, Sync, Treiber, Toolchain, systemd-Unit,
  Serverzugang); oder es wurde eine Konfiguration geändert, die man in Monaten nicht mehr aus
  dem Kopf weiss. Dann fragen, ob eine Notiz im Vault angelegt werden soll. Ebenfalls nutzen,
  wenn der Nutzer sagt "dokumentiere das", "schreib das in meine Notizen", "mach eine Doku
  dazu" oder Ähnliches. Niemals ungefragt schreiben.
---

# Doku im Obsidian-Vault anbieten

Wissen, das man sich einmal erarbeitet hat, ist in drei Monaten weg. Dieser Skill sorgt dafür,
dass es vorher in den Vault wandert — aber nur mit Zustimmung und nur dann, wenn es sich lohnt.

## Wann anbieten

Am Ende der Arbeit prüfen, ob mindestens eines zutrifft:

- **Mehrere Anläufe nötig.** Der erste Versuch hat nicht funktioniert, es gab Fehlermeldungen,
  Umwege oder falsche Fährten.
- **Ursache war nicht offensichtlich.** Die Fehlermeldung zeigte nicht auf den echten Grund
  (Beispiel: eine Login-Fehlermeldung, deren Ursache ein falsches Feld im Config-Dialog war).
- **Etwas Grosses neu eingerichtet.** Dienst, Daemon, systemd-Unit, Cloud-Sync, Treiber,
  Toolchain, Datenbank, Serverzugang, neue Hardware, neuer Rechner.
- **Konfiguration geändert, die man selten anfasst.** Settings-Dateien, Hooks, Netzwerk,
  Bootloader, Kernel-Parameter, Rechte.
- **Es gibt eine Stolperfalle.** Etwas verhält sich anders als die Doku oder die Intuition
  erwarten lässt. Das ist der wertvollste Inhalt überhaupt.

## Wann nicht anbieten

Nicht fragen bei: einzelnen Code-Änderungen in einem Repo (das steht in der Git-Historie),
kurzen Wissensfragen, Tippfehler-Korrekturen, Dingen die in einer CLAUDE.md oder README
stehen, und allem was beim nächsten Mal sowieso in zwei Minuten erledigt ist. Im Zweifel
lieber nicht fragen — eine Doku-Frage nach jeder Kleinigkeit nervt und entwertet den Skill.

## Wie anbieten

**Erst wenn die Arbeit fertig ist**, nicht mittendrin. Eine einzelne Zeile am Ende der Antwort,
die konkret benennt, was in die Notiz käme und wo sie landen würde:

> Soll ich das als Notiz in deinem Vault ablegen (`CachyOS/…`)? Die Stolperfalle mit
> `--max-delete` und der Login-Fehler wären die zwei Dinge, die beim nächsten Mal Zeit sparen.

Keine Nachfrage, wenn der Nutzer nicht antwortet oder ablehnt. Niemals ungefragt eine Datei
im Vault anlegen.

## Wo ablegen

Vault auf dem Linux-Rechner: `~/Desktop/Notizen/notizen/`. Den Pfad vorher verifizieren
(`ls`), auf anderen Geräten kann er abweichen — dann im Home nach einem Ordner mit
`.obsidian` suchen.

Ordner nach Thema wählen, und zwar **anhand der tatsächlich vorhandenen Ordner** (vorher
auflisten, die Struktur wächst):

| Thema | Ordner |
|---|---|
| Linux, System, Treiber, systemd, Pakete | `CachyOS/` |
| Claude Code, Skills, Hooks, Settings | `Coding 🚀/Claude/` |
| Programmieren, Sprachen, Lernpfade | `Coding 🚀/…` |
| Valeryn-Projekt (Server, Konzept, Team) | `Valeryn.net 📜/…` |
| Spiele, Proton, Kompatibilität | `Gaming/` |

Passt nichts, den naheliegendsten Ordner nehmen und die Wahl in einem Satz begründen, damit
der Nutzer widersprechen kann. Keine neuen Top-Level-Ordner anlegen, ohne zu fragen.

## Format

Der Vault hat eine klare Konvention — **kein YAML-Frontmatter** (62 von 63 Notizen haben
keins). Stattdessen:

```markdown
# ☁️ Kurzer Titel mit Emoji

> **System:** CachyOS · relevante Hardware oder Versionen
> **Eingerichtet:** 2026-10-09

---

## Zweck
```

Dateiname: sprechender Titel mit Emoji, Leerzeichen erlaubt (so wie die bestehenden Notizen).

Danach eine von zwei Gliederungen:

**Bei einem gelösten Problem:** `## Problem` → `## Ursache` → `## Lösung` → `## Troubleshooting`

**Bei einer Einrichtung:** `## Zweck` → `## Komponenten` (Tabelle mit allen Pfaden) →
`## Bedienung` → `## Stolperfallen` → `## Troubleshooting` → `## Verlauf`

Am Stil der Nachbarnotizen im Zielordner orientieren, nicht an einer fremden Vorlage.

## Was hineingehört

- **Die echten Fehlermeldungen**, wörtlich und in einem Codeblock. Danach sucht man später.
- **Die tatsächliche Ursache**, nicht nur die Lösung.
- **Was nicht funktioniert hat** und warum. Erspart beim nächsten Mal den gleichen Umweg.
- **Alle Pfade, Unit-Namen, Befehle** — vollständig und kopierbar, in der Shell des Nutzers (fish).
- **Absolute Daten** (`2026-10-09`), nie "gestern" oder "letzte Woche".
- **Stolperfallen** als eigener, hervorgehobener Abschnitt.

Nicht hineinschreiben: Passwörter, Tokens, API-Keys, Session-Cookies. Wenn ein Geheimnis zur
Erklärung gehört, nur das Feld benennen, nie den Wert.

## Bestehende Notiz aktualisieren

Vor dem Anlegen prüfen, ob es zum Thema schon eine Notiz gibt (`find` oder `grep` im Vault).
Falls ja: dort ergänzen statt eine zweite Datei anlegen, und unter `## Verlauf` eine Zeile mit
dem Datum und dem, was sich geändert hat, hinzufügen.

## Git

Der Vault ist ein Git-Repo mit dem obsidian-git-Plugin. **Nicht committen oder pushen**, ausser
der Nutzer verlangt es ausdrücklich — das Plugin erledigt das normalerweise selbst. Nach dem
Schreiben den Pfad der Notiz nennen und erwähnen, dass nicht committet wurde.
