---
name: demo-safety-net
description: >
  Checkliste vor der Live-Demo im Hackathon: frischer Start, Offline-Fallback (Screenshots,
  Video, lokale Kopie), API-Keys, Rate Limits und Quotas, Demo-Account und Seed-Daten,
  WLAN-Ausfallplan, Browser/Zoom/Benachrichtigungen, Zweitgerät, ein Demo-Pfad von höchstens
  3 Minuten mit Sprechpunkten und eine "Wenn X ausfällt, dann Y"-Tabelle. Prüft selbst, was
  prüfbar ist (z. B. Health-Endpoints), und markiert den Rest als manuell. Nutze diesen Skill
  vor einer Hackathon-Demo oder Jury-Präsentation: "Demo-Check", "sind wir bereit für die
  Demo", "was kann bei der Demo schiefgehen", "gleich Jury-Präsentation", "demo checklist",
  "before we present to the judges". NICHT für Produktions-Releases, Deployment-Checklisten
  oder Monitoring in normalen Projekten.
---

# Demo-Sicherheitsnetz

## Zweck

Die meisten Hackathon-Demos scheitern nicht am Code, sondern am WLAN, an einem abgelaufenen
Key oder an einer Benachrichtigung mitten im Pitch. Dieser Skill geht alles durch, was vor
der Jury schiefgehen kann, prüft das Prüfbare selbst und sorgt dafür, dass es für jeden
Ausfall einen Plan B gibt.

## Wann nutzen – und wann nicht

**Nutzen:** ab dem Feature-Freeze, spätestens eine Stunde vor der Demo; zweiter kurzer
Durchgang direkt vor dem Auftritt.

**Nicht nutzen:** für Releases oder Deployments ausserhalb eines Hackathons. Für den
Pitch-Text selbst ist `pitch-builder` zuständig. Hier geht es um Klickpfad und Absicherung.

## Vorgehen

1. **Kontext klären.** Zeitpunkt der Demo, Format (vor Ort, remote, nur Video), Projekt-URL
   und/oder lokaler Start, Pfad zum Repo, wer klickt und wer spricht.
2. **Automatisch prüfen**, nur lesend. Vorher in einem Satz sagen, was ausgeführt wird.
   - Health-Endpoint lokal und deployt: `curl -fsS --max-time 5 ‹url›/health`
   - Deployte URL: HTTP-Status, TLS gültig, Ladezeit grob
   - Env-Variablen: alle im Code genutzten Namen (z. B. `process.env.*`, `os.environ`) stehen
     in `.env.example`; in der lokalen `.env` sind sie gesetzt. **Nur Namen prüfen, nie Werte
     ausgeben.**
   - Kein Key im Repo: kurzer `git grep` auf typische Key-Muster; bei Treffer
     `security-watchdog` für die Einordnung
   - Seed-Skript vorhanden und Demo-Datensätze da (siehe `mock-data-gen`)
   - Git: uncommittete Änderungen? Demo-Stand als Tag sichern vorschlagen (`git tag demo`),
     anlegen nur nach Rückfrage
   - Frischer Start im sauberen Clone (Wegwerf-Ordner): nur nach Rückfrage, das dauert
3. **Manuell abhaken lassen.** Diese Punkte kann nur das Team prüfen:
   - Offline-Fallback: Screenshot jedes Demo-Schritts, aufgenommenes Video (2–3 Minuten),
     lokale Kopie, die ohne Internet startet
   - API-Quotas und Rate Limits im Dashboard ansehen; wie viele Calls braucht ein Durchlauf?
   - Demo-Account eingeloggt, Passwort nicht live tippen
   - WLAN-Plan: Handy-Hotspot vorher getestet
   - Browser: eigenes Profil, nur Demo-Tabs, Zoom 125–150 %, Lesezeichenleiste aus,
     Passwort-Manager-Popups aus
   - System: Nicht stören an, Chat-Apps zu, Bildschirmschoner aus, Akku voll, Ladegerät da
   - Beamer: Adapter, Auflösung, gespiegelt oder erweitert getestet
   - Zweitgerät mit Video und deployter Version bereit
4. **Demo-Pfad festlegen.** Höchstens 3 Minuten, 3 bis 6 Schritte, jeder mit Aktion,
   Sprechpunkt und Zeit. Der stärkste Moment kommt früh, nicht am Ende. Liegt ein Pitch aus
   `pitch-builder` vor, dessen Demo-Abschnitt übernehmen.
5. **Ausfallplan.** Für jeden kritischen Punkt: woran man den Ausfall erkennt und was sofort
   passiert, ohne Diskussion auf der Bühne.
6. **Generalprobe.** Einmal komplett mit Timer, aus frischem Browser-Fenster. Danach die
   Checkliste aktualisieren.

## Ausgabeformat

```markdown
## Demo-Check – ‹Projekt› · ‹Datum, Uhrzeit›

| # | Punkt | Status | Geprüft | Notiz |
|---|---|---|---|---|
| 1 | /health deployt | ok | automatisch | 200 in 180 ms |
| 2 | Video-Fallback | offen | manuell | |
| 3 | API-Quota | Risiko | manuell | 50 Calls/Tag, Demo braucht 12 |

## Demo-Pfad (≤ 3:00)
| Zeit | Aktion | Sprechpunkt |
|---|---|---|

## Wenn X ausfällt, dann Y
| Ausfall | Erkennen | Sofort |
|---|---|---|
| WLAN | Seite lädt nicht | Hotspot; sonst lokale Kopie |
| externe API | Fehler/Spinner > 5 s | Video ab Minute ‹x› |
| Laptop | – | Zweitgerät mit Video |

## Nächste 3 Schritte
1. …
```

Status: **ok** nur, wenn in dieser Session tatsächlich geprüft. **offen**, wenn noch nicht
geprüft oder manuell. **Risiko**, wenn geprüft und problematisch. Manuelle Punkte nie auf
Verdacht als ok markieren.

## Grenzen

- Prüft nur lesend. Ändert, deployt, taggt und klont nichts ohne Rückfrage.
- Gibt nie Werte von Keys oder Passwörtern aus, auch nicht gekürzt.
- Garantiert nichts. "ok" heisst: zum Zeitpunkt der Prüfung ok.
