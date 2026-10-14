# Hackathon-Skills

Zehn Skills für Hackathons, in der Reihenfolge, in der sie gebraucht werden. Alle triggern nur im
Hackathon-Kontext (Hackathon, Challenge, Jury, Abgabe, Pitch, Demo, START Hack o. Ä.), nicht bei
normalen Entwicklungsfragen.

## Ablauf

| # | Phase | Skill | Wofür |
|---|---|---|---|
| 1 | Start | [`hack-kickoff`](hack-kickoff/SKILL.md) | Challenge und Jury-Kriterien → einseitiger Plan: Problem, MVP, Stretch, Rollen, Zeitplan rückwärts ab Abgabe, Top-3-Risiken |
| 2 | Start | [`hack-stack-picker`](hack-stack-picker/SKILL.md) | Langweiligen, bekannten Stack wählen, Zeitfresser vermeiden, Sponsor-APIs einordnen |
| 3 | Start | [`hack-scaffold`](hack-scaffold/SKILL.md) | Lauffähiges Starter-Repo mit Health-Endpoint und Hello-World von UI bis DB, Start in unter 10 Minuten |
| 4 | Während | [`scope-guard`](scope-guard/SKILL.md) | Jede neue Idee: Go / Später / Streichen, mit zwei Sätzen Begründung |
| 5 | Während | [`mock-data-gen`](mock-data-gen/SKILL.md) | Deterministische Demo-Daten und Seed-Skript, ohne echte Personendaten |
| 6 | Abgabe | [`readme-quick`](readme-quick/SKILL.md) | README für Jury und Abgabe, mit geprüften Setup-Schritten |
| 7 | Abgabe | [`devpost-writer`](devpost-writer/SKILL.md) | Abgabetext für Devpost o. Ä., nur aus belegbaren Inhalten |
| 8 | Abgabe | [`pitch-builder`](pitch-builder/SKILL.md) | Pitch-Struktur, Sprechtext mit Zeiten, Folien-Stichwörter, Jury-Fragen |
| 9 | Abgabe | [`demo-safety-net`](demo-safety-net/SKILL.md) | Checkliste vor der Live-Demo, Fallbacks, "Wenn X ausfällt, dann Y" |
| 10 | Danach | [`hack-retro`](hack-retro/SKILL.md) | Retro, Verbesserungen für diese Skills, optional Starter-Template und Vault-Notiz |

## Abgrenzung zu den anderen Skills

| Hackathon-Skill | Nachbar | Grenze |
|---|---|---|
| `scope-guard` | `idea-challenger` | idea-challenger ist offenes Sparring ohne Deadline. scope-guard entscheidet unter Zeitdruck mit drei festen Fragen. Ein Pivot geht an idea-challenger. |
| `hack-kickoff`, `hack-stack-picker` | `idea-challenger` | Die Hackathon-Skills planen für Jury und Frist. Ob eine Idee grundsätzlich trägt, klärt idea-challenger. |
| `hack-scaffold` | `git-branch-pr-workflow` | hack-scaffold baut den Starter. Branches, Commits und PRs regelt der Git-Workflow, ab dem ersten Commit auf `main`. |
| `readme-quick` | `obsidian-documentation` | README im Projekt-Repo gegen Notiz im Vault. |
| `readme-quick` | `devpost-writer` | README für das Repo, Devpost-Text für die Abgabeplattform. |
| `pitch-builder` | `demo-safety-net` | pitch-builder schreibt, was gesagt wird. demo-safety-net sichert ab, dass die Demo läuft. |
| `demo-safety-net` | `security-watchdog` | Ein gefundener Key im Repo wird an security-watchdog zur Einordnung übergeben. |
| `hack-retro` | `obsidian-documentation` | hack-retro bietet die Notiz an. Ort und Format bestimmt obsidian-documentation. |

## Einrichtung: Skills verlinken

Claude Code findet Skills nur eine Ebene tief: `~/.claude/skills/<name>/SKILL.md`. Die
Unterordner hier unter `hackathon/` sieht es nicht von selbst. Jeder Skill braucht deshalb einen
eigenen Symlink. Das erledigt `link-skills.sh` im Repo-Root:

```bash
~/claude-skills/link-skills.sh hackathon           # Vorschau, ändert nichts
~/claude-skills/link-skills.sh --apply hackathon   # fehlende Links anlegen
```

Danach Claude Code neu starten. Das Skript legt nur fehlende Links an. Es löscht und
überschreibt nie, meldet aber falsche, verwaiste oder doppelte Einträge. Skills, die schon
über den claude.ai-Sync kommen (`synced/`), überspringt es, damit sie nicht doppelt auftauchen.
Nach jedem `git pull`, der neue Skills bringt, einmal ohne Ordner-Argument laufen lassen.

### Gerät mit altem Aufbau

Ist `~/.claude/skills` selbst ein einziger Symlink auf das Repo, bricht das Skript ab: Die Links
würden sonst im Repo landen. Umstellung auf einzelne Links:

```bash
ls -la ~/.claude/skills        # muss "-> …/claude-skills" zeigen, also ein Symlink sein
rm ~/.claude/skills            # entfernt nur den Symlink, nicht das Repo
mkdir ~/.claude/skills
~/claude-skills/link-skills.sh # Vorschau prüfen, dann mit --apply
```

Der claude.ai-Sync legt `~/.claude/skills/synced/` beim nächsten Start von Claude Code neu an.
Steht `java-tutor` in der Vorschau als `fehlt` statt `uebersprungen`, ist der Sync noch nicht
gelaufen: Claude Code einmal starten, dann das Skript erneut ausführen.
