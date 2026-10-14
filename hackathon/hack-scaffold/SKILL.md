---
name: hack-scaffold
description: >
  Setzt nach Rückfrage in einem neuen Ordner ein lauffähiges Starter-Repo für einen Hackathon
  auf: Frontend, Backend, .env.example, optional Docker Compose, README-Skelett, Deploy-Config,
  Lint/Format, Health-Endpoint und einen durchgehenden Hello-World-Weg von der UI bis zur DB,
  damit alle im Team in unter 10 Minuten lokal starten können. Nutze diesen Skill, wenn im
  Hackathon das Projekt-Grundgerüst entstehen soll: "Hackathon-Repo aufsetzen", "Starter für
  die Challenge", "Boilerplate für den Hackathon", "scaffold the hackathon project", "hackathon
  starter repo". Nur im Hackathon-Kontext. NICHT für Branches, Commits oder Pull Requests
  (dafür git-branch-pr-workflow) und nicht zum Aufsetzen normaler Projekte ausserhalb eines
  Hackathons.
---

# Hackathon-Grundgerüst

## Zweck

Ein Starter, der bei allen läuft, spart im Team schnell eine Stunde Setup-Chaos. Ziel: Clone,
ein paar Befehle, und der komplette Weg *UI → API → DB → UI* funktioniert. Danach baut jede
Person auf etwas auf, das schon läuft.

## Wann nutzen – und wann nicht

**Nutzen:** nach der Stack-Wahl (`hack-stack-picker`), bevor jemand Features schreibt.

**Nicht nutzen:** für Git-Abläufe (Branch, Commit, PR → git-branch-pr-workflow); für normale
Projekte ohne Hackathon; in einem bestehenden Repo, das schon läuft.

## Vorgehen

1. **Stack klären.** Aus `hack-stack-picker` übernehmen, sonst eine Rückfrage: Frontend,
   Backend, DB, Paketmanager, Sprachversion.
2. **Zielordner bestätigen.** Einen neuen Ordner vorschlagen und mit `ls` prüfen, dass er nicht
   existiert. Nie in einen bestehenden Ordner schreiben, ohne zu fragen.
3. **Plan zeigen und Freigabe holen.** Struktur und alle Befehle, die laufen werden
   (Generatoren und Installationen laden Pakete aus dem Netz). Eine Freigabe für den ganzen
   Plan reicht.
4. **Aufsetzen**, in dieser Reihenfolge, damit es nach jedem Schritt lauffähig bleibt:
   1. Offizielle Generatoren statt Boilerplate von Hand (z. B. `create-vite`,
      `create-next-app`), mit nicht-interaktiven Flags.
   2. Backend mit `GET /health` → `{"status":"ok","db":"ok"}`. Der DB-Teil zeigt, ob die
      Verbindung wirklich steht.
   3. DB: standardmässig SQLite (Datei in `.gitignore`); Postgres per Docker Compose nur, wenn
      gewählt. Eine Beispiel-Tabelle, ein Init-Skript, ein Seed-Eintrag.
   4. **Hello-World-Pfad:** ein Button in der UI → `GET /api/items` → DB → Anzeige. Das beweist
      alle Schichten auf einmal.
   5. `.env.example` mit allen Variablen und Platzhaltern, `.env` in `.gitignore`. Keine
      echten Werte, auch keine "nur zum Testen".
   6. Lint/Format: was der Generator mitbringt (z. B. ESLint + Prettier, ruff), plus ein
      Befehl `lint`.
   7. Deploy-Config als Datei (z. B. `vercel.json`, `render.yaml`, `Dockerfile`). Deployen
      nur nach eigener Rückfrage.
   8. README-Skelett mit Startbefehlen; ausformuliert wird später mit `readme-quick`.
   9. Ein Befehl für alles (z. B. `npm run dev` mit parallelen Prozessen, oder
      `docker compose up`).
5. **Verifizieren wie ein neues Teammitglied.** Install und Start vom frischen Stand, `curl`
   auf `/health`, Hello-World-Pfad einmal durchklicken bzw. per Request prüfen. Zeit gegen das
   10-Minuten-Ziel halten. Fehler beheben, bevor es ans Team geht.
6. **Git.** `git init` und `.gitignore` gehören dazu. Remote anlegen, committen und pushen nur
   nach Rückfrage. Ein frisches Repo hat noch kein `origin/main` zum Abzweigen: Der erste
   Commit mit dem Starter landet nach Rückfrage auf `main`, ab dann gilt
   `git-branch-pr-workflow` für alle weiteren Änderungen.

## Ausgabeformat

```markdown
## Starter – ‹Projekt› (‹Pfad›)

‹Baumstruktur, 2–3 Ebenen›

### Start (neues Teammitglied)
1. git clone ‹url› && cd ‹ordner›
2. cp .env.example .env   # Werte vom Team holen, nie committen
3. ‹install›
4. ‹dev-Befehl›
5. http://localhost:‹port› – Health: http://localhost:‹port›/health

### Geprüft
| Check | Ergebnis |
|---|---|
| Frischer Install + Start | ok, ‹Minuten› |
| /health | ok |
| UI → API → DB | ok |
| Lint | ok |
```

Befehle so schreiben, dass sie in bash, zsh und fish laufen (kein `export VAR=…`, keine
`$(…)`-Konstrukte in den Startschritten).

## Grenzen

- Schreibt nur in einen neuen, bestätigten Ordner. Löscht und überschreibt nichts.
- Deployt nicht, legt keine Accounts an, schreibt keine Secrets.
- Verbieten die Event-Regeln vorbereiteten Code, erst nach dem offiziellen Start aufsetzen.
  Öffentliche Generatoren sind üblich erlaubt; im Zweifel die Orga fragen.
- Neue Netzwerk-Endpunkte oder Auth-Code: kurz `security-watchdog` mitdenken, aber im
  Hackathon nur echte Risiken melden (z. B. Key im Frontend-Bundle).
