---
name: skills-update-check
description: >
  Prüfen, ob neue oder geänderte Claude-Code-Skills verfügbar sind, und sie holen. Nutze
  diesen Skill, wenn der Nutzer fragt "gibt es neue Skills", "sind meine Skills aktuell",
  "hol die neuesten Skills", "skills updaten", "hast du alle Skills" oder Ähnliches. Ebenfalls
  nutzen, wenn der Nutzer auf einem Gerät arbeitet, an dem er länger nicht war, wenn ein Skill
  erwartet wird der nicht in der Skill-Liste auftaucht, oder wenn ein neu angelegter Skill auf
  einem anderen Gerät ankommen soll. Prüft beide Quellen: das Git-Repo ~/claude-skills und den
  claude.ai-Sync unter synced/. Nie ohne Rückfrage pullen, nie committen oder pushen.
---

# Skills aktuell halten

Es gibt **zwei** Quellen für Skills, und nur eine davon aktualisiert sich selbst. Das ist der
Grund, warum ein Skill auf einem Gerät fehlen kann, obwohl er auf einem anderen längst da ist.

| Quelle | Ort | Aktualisierung |
|---|---|---|
| **Eigenes Git-Repo** | `~/claude-skills` (Symlink von `~/.claude/skills`) | **Manuell** per `git pull` |
| **claude.ai-Sync** | `~/claude-skills/synced/<uuid>/<skill>/` | **Automatisch**, etwa alle 10 Minuten |

Der Sync-Ordner ist ein Cache und steht in der `.gitignore`. Er enthält die mitgelieferten
Standard-Skills und alle, die auf claude.ai aktiviert sind. Dort etwas zu bearbeiten ist
sinnlos — beim nächsten Durchlauf wird es überschrieben.

## Ablauf

Alle Schritte sind lesend. Erst nach Rückfrage wird etwas geändert.

1. **Repo-Stand prüfen.**

   ```bash
   cd ~/claude-skills
   git fetch origin
   git status -sb
   ```

   `behind N` heisst: es liegen N Commits auf `origin/main`, die hier fehlen.

2. **Was genau fehlt.**

   ```bash
   git log --oneline HEAD..origin/main
   git diff --name-only HEAD origin/main
   ```

   Neue Skills sind neue `<name>/SKILL.md`-Dateien. Geänderte Skills erscheinen als
   modifizierte `SKILL.md`.

3. **Lokale Skills, die noch nirgends liegen.** `git status --short` zeigt untracked
   Skill-Ordner. Die existieren nur auf diesem Gerät und fehlen auf allen anderen — das ist
   erwähnenswert, aber kein Fehler.

4. **Persönliche Skills im Sync-Cache.** Ordner unter `synced/*/` mit dem Repo vergleichen.
   Taucht dort ein Skill auf, der offensichtlich selbst geschrieben ist (nennt den Nutzer oder
   seine Projekte namentlich) und **nicht** im Repo liegt, darauf hinweisen: er geht beim
   nächsten Sync-Durchlauf verloren, wenn er auf claude.ai deaktiviert wird. Anbieten, ihn ins
   Repo zu übernehmen (kopieren, nicht verschieben — den Cache nie anfassen).

5. **Ergebnis melden**, in wenigen Zeilen: was neu ist, was geändert wurde, was nur lokal
   existiert. Wenn alles aktuell ist, genau das sagen — in einem Satz, ohne Tabelle.

## Pullen

Nur nach Zustimmung, und nur so:

```bash
cd ~/claude-skills
git pull --ff-only origin main
```

`--ff-only` ist Absicht: Gibt es lokale Commits, die noch nicht gepusht sind, bricht der Pull
ab statt still einen Merge-Commit zu erzeugen. Dann melden und fragen, statt zu mergen oder zu
rebasen.

**Vorher prüfen**, ob uncommittete Änderungen an einer `SKILL.md` im Arbeitsverzeichnis liegen.
Falls ja: nicht pullen, sondern den Nutzer fragen (committen, stashen oder verwerfen). Ein Pull
über eigene Änderungen hinweg ist der einzige Weg, in diesem Setup Arbeit zu verlieren.

Nie `--force`, nie `git reset --hard`, nie selbst committen oder pushen. Zum Hochladen eines
neuen Skills ist `git-branch-pr-workflow` zuständig.

## Nach dem Pullen

Neu hinzugekommene Skills werden erst nach einem **Neustart von Claude Code** geladen. Das
sagen — sonst wundert sich der Nutzer, warum der Skill noch fehlt. (Skills aus dem
claude.ai-Sync erscheinen teils auch ohne Neustart.)

## Grenze dieses Skills

Ein Skill läuft nicht von selbst — er braucht einen Auslöser aus dem Gespräch. Für eine
wirklich automatische Prüfung bei jedem Start bräuchte es einen `SessionStart`-Hook in
`~/.claude/settings.json`, der `git fetch` ausführt. Wenn der Nutzer das möchte, darauf
hinweisen, statt zu behaupten, dieser Skill prüfe von allein.
