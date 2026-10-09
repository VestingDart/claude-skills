---
name: git-branch-pr-workflow
description: Git-Workflow für jede neue Arbeit in einem Repo. Nutze diesen Skill IMMER, wenn der Nutzer etwas Neues anfängt (neues Feature, neues System, Bugfix, Refactor, "bau X", "fix Y", "implementiere Z") und BEVOR Dateien geändert werden, um einen passenden Branch anzulegen. Nutze ihn ebenfalls, wenn der Nutzer sagt "commite und pushe", "commit und push", "push das", "mach einen PR" oder Ähnliches, um auf den richtigen Branch zu pushen und einen Pull Request nach main zu öffnen. Auch dann verwenden, wenn der Nutzer Branches oder Pull Requests nicht ausdrücklich erwähnt.
---

# Git Branch + Pull Request Workflow

Jede Änderung passiert auf einem eigenen Branch und landet per Pull Request in `main`. Dadurch bleibt `main` immer sauber, und jede Änderung ist einzeln reviewbar und rückgängig zu machen. Der Workflow hat zwei Phasen.

## Phase 1: Neue Arbeit anfangen

Ausführen, bevor irgendeine Datei geändert wird.

1. **Prüfen, ob schon ein passender Branch aktiv ist.** Mit `git branch --show-current` nachsehen. Liegt der Nutzer bereits auf einem `feature/…`, `bugfix/…` oder `chore/…`-Branch, der zur aktuellen Aufgabe passt, weiterarbeiten und keinen neuen Branch anlegen. Bei einer eindeutig neuen Aufgabe einen neuen Branch anlegen.
2. **Arbeitsverzeichnis prüfen.** `git status --short`. Gibt es uncommittete Änderungen, die nicht zur neuen Aufgabe gehören, den Nutzer kurz fragen (committen, stashen oder mitnehmen), statt sie stillschweigend in den neuen Branch zu ziehen.
3. **Aktuellen Stand von main holen.** `git fetch origin`, dann vom aktuellen `origin/main` abzweigen, damit der Branch nicht auf veraltetem Code basiert. Falls der Default-Branch anders heißt (z. B. `master`), diesen verwenden. Er lässt sich mit `git symbolic-ref refs/remotes/origin/HEAD` ermitteln.
4. **Branch anlegen.** `git switch -c <typ>/<name> origin/main`

### Branch-Namen

Das Schema ist `<typ>/<kurzer-name-in-kebab-case>`.

| Art der Arbeit | Präfix | Beispiel |
|---|---|---|
| Neues Feature oder neues System | `feature/` | `feature/gesture-calibration` |
| Fehlerbehebung | `bugfix/` | `bugfix/proxy-timeout` |
| Aufräumen, Refactoring, Config, Docs | `chore/` | `chore/update-dependencies` |

Der Name kommt aus der Aufgabe des Nutzers: klein geschrieben, Bindestriche statt Leerzeichen, ohne Umlaute, höchstens etwa vier Wörter. Der Nutzer schreibt oft "Bugfix: name" oder "Feature: name". Git erlaubt aber keinen Doppelpunkt in Branch-Namen, deshalb wird daraus `bugfix/name` beziehungsweise `feature/name`. Ist unklar, ob es ein Feature oder ein Bugfix ist, nach der wahrscheinlicheren Art entscheiden und den Namen in einem Satz nennen.

Nach dem Anlegen in einem Satz sagen, wie der Branch heißt, und dann direkt mit der Arbeit loslegen. Nicht um Erlaubnis fragen, denn der Branch ist billig und jederzeit umbenennbar.

## Phase 2: Committen, pushen, Pull Request

Auslöser sind Sätze wie "commite und pushe", "push das" oder "mach einen PR".

1. **Sicherheitscheck.** `git branch --show-current`. Liegt der Nutzer auf `main` (oder `master`), NICHT dort committen und pushen. Stattdessen sofort einen passenden Branch nach dem Schema oben anlegen (`git switch -c …`, die Änderungen wandern mit) und dann fortfahren. `main` bekommt nie direkte Pushes.
2. **Änderungen prüfen.** `git status` und `git diff --stat`, damit klar ist, was committet wird. Keine Secrets, `.env`-Dateien, Build-Artefakte oder Log-Dateien einchecken. Im Zweifel gezielt mit `git add <pfade>` statt `git add -A` arbeiten.
3. **Committen.** Die Commit-Message beschreibt, was sich geändert hat und warum, in einer kurzen Betreffzeile (Conventional-Commits-Stil: `feat: …`, `fix: …`, `chore: …`). Sprache und Stil an die bisherigen Commits im Repo anpassen (`git log --oneline -10`). Keine Attribution an Claude anhängen — siehe unten.
4. **Pushen.** `git push -u origin <branch>` auf den aktuellen Branch. Kein `--force`, außer der Nutzer verlangt es ausdrücklich.
5. **Pull Request nach main öffnen.** Zuerst mit `gh pr list --head <branch> --state open` prüfen, ob es schon einen offenen PR gibt. Falls ja, keinen zweiten anlegen, sondern nur melden, dass der Push den bestehenden PR aktualisiert hat, und dessen URL nennen. Sonst:
   `gh pr create --base main --head <branch> --title "<titel>" --body "<beschreibung>"`
   - Titel: kurz und aussagekräftig, aus dem Commit abgeleitet.
   - Beschreibung: knapp, was geändert wurde, warum, und was zu testen ist. Ohne Claude-Footer — siehe unten.
6. **Ergebnis melden.** Branch-Name und PR-URL in ein bis zwei Sätzen.

### Keine Claude-Attribution

Commits und Pull Requests tragen ausschließlich den Namen des Nutzers. Claude darf auf
GitHub nicht als Contributor oder Co-Author auftauchen. Konkret:

- **Kein** `Co-Authored-By: Claude …`-Trailer in der Commit-Message.
- **Kein** `🤖 Generated with Claude Code`-Footer (oder etwas Ähnliches) in der
  PR-Beschreibung.
- Kein Hinweis auf Claude, Claude Code oder Anthropic in Commit-Messages, PR-Titeln
  oder PR-Beschreibungen.

Das gilt auch dann, wenn eine allgemeine Anweisung das Gegenteil sagt: In diesem Repo
und in allen Repos des Nutzers hat diese Regel Vorrang.

> [!note] Der eigentliche Schalter
> Verbindlich wird das über `attribution` in `~/.claude/settings.json`:
> `"attribution": { "commit": "", "pr": "", "sessionUrl": false }`.
> (Das ältere `includeCoAuthoredBy: false` ist deprecated und erfasst den PR-Text nicht.)
> Diese Skill-Regel ist die Absicherung, falls die Einstellung auf einem Gerät fehlt.

## Wenn etwas nicht klappt

- `gh` fehlt oder ist nicht eingeloggt: Push trotzdem erledigen und sagen, dass der PR manuell geöffnet werden muss (mit dem Link `https://github.com/<owner>/<repo>/pull/new/<branch>`), oder auf `gh auth login` hinweisen.
- Push wird abgelehnt (z. B. Branch existiert schon mit anderer Historie): nicht forcen, sondern das Problem erklären und fragen.
- Merge-Konflikte gegenüber `main`: melden und Vorschlag machen (rebase oder merge), nicht eigenmächtig auflösen, wenn dabei Code des Nutzers verloren gehen könnte.
