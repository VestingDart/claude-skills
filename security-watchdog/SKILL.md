---
name: security-watchdog
description: >
  Sicherheitsprüfung für den Code und die Server von VestingDart. Nutze diesen Skill, sobald Code
  geschrieben oder geändert wurde, der mit Nutzereingaben, Datenbanken, Netzwerk, Authentifizierung,
  Dateien, Zahlungen oder Rechten zu tun hat — also bei Paper/Velocity-Plugins, Node/Express-Backends,
  der Website, Server-Konfiguration und systemd/SSH/Firewall-Themen. Ebenfalls nutzen, wenn er direkt
  fragt "ist das sicher", "prüf das mal auf Sicherheitslücken", "kann man das ausnutzen", "schau dir
  das sicherheitstechnisch an", oder bevor etwas auf den Root-Server oder live geht. Melde nur, was
  in seinem Setup wirklich ausnutzbar ist, mit Schweregrad und konkreter Behebung — keine generischen
  Checklisten.
---

# Security Watchdog

VestingDart betreibt einen öffentlichen Minecraft-Server mit echten Spielern, einen Root-Server und
eine Website mit Shop. Das heißt: fremde Menschen schicken Daten an seinen Code, und manche davon
probieren absichtlich aus, was passiert. Dieser Skill prüft mit — unaufgefordert, direkt nachdem
Code entstanden ist, und auf Abruf.

Der Wert liegt nicht im Finden von möglichst viel, sondern im Finden von dem, was **wirklich
ausnutzbar** ist. Eine Liste theoretischer Bedenken nach jeder Änderung führt dazu, dass er sie
überliest — und dann rutscht die echte Lücke mit durch.

---

## Wann prüfen

**Automatisch mitprüfen**, wenn in der Arbeit mindestens eines davon vorkam:

- Eingaben von außen werden verarbeitet: Chat, Commands, Bücher/Schilder, HTTP-Request-Bodies,
  Query-Parameter, Formulare, Webhooks, Plugin-Messages
- eine Datenbank wird abgefragt oder beschrieben
- Authentifizierung, Login, Session, Token, Permissions
- Dateien werden gelesen, geschrieben oder ausgeliefert
- Netzwerk: offene Ports, Proxy-Konfiguration, CORS, Reverse Proxy
- Geld: Shop, Zahlung, Ingame-Wirtschaft, Transfers
- Server-Config: SSH, Firewall, systemd-Units, Docker, Rechte
- Secrets: `.env`, Tokens, Keys, Passwörter, Config-Dateien

**Nicht** prüfen bei reinen Umbenennungen, Formatierung, Notizen im Vault, Build-Config ohne
Netzwerkbezug, lokalen Skripten ohne Fremdeingabe. Da gibt es nichts zu finden, und die Meldung
"keine Auffälligkeiten" nach jeder Kleinigkeit ist selbst ein Problem.

**Abgrenzung zu `/security-review`:** Das eingebaute Kommando prüft den Diff eines Branches auf
Anfrage. Dieser Skill läuft mitten in der Arbeit mit und kennt seinen Stack. Wenn er einen
vollständigen Review des ganzen Branches will, verweise auf `/security-review` statt es doppelt
zu machen.

---

## Wie melden

Kurz, nach Schweregrad, und nur das Echte. Format:

```
🔴 Kritisch — <was> (<datei:zeile>)
   Ausnutzbar: <wie konkret jemand das missbraucht>
   Fix: <was zu ändern ist>
```

**🔴 Kritisch** — jemand von außen kann es ohne besondere Voraussetzungen ausnutzen und es
verursacht echten Schaden: Datenbank auslesen, Admin-Rechte bekommen, Server übernehmen, Geld
erzeugen, Accounts übernehmen.

**🟡 Wichtig** — ausnutzbar, aber mit Hürden (braucht einen Account, Insider-Wissen, bestimmte
Umstände), oder der Schaden ist begrenzt.

**⚪ Hinweis** — jetzt kein Problem, wird aber eines, wenn das System wächst. Höchstens zwei davon
pro Meldung, sonst ertrinkt das Wichtige.

Das "Ausnutzbar"-Feld ist der wichtigste Teil. Wenn du es nicht konkret ausformulieren kannst,
hast du vermutlich kein echtes Finding — dann weglassen. Kein "könnte potenziell unsicher sein".

Nichts gefunden und du hast wirklich geprüft? Eine Zeile: "Sicherheitstechnisch sauber — Eingaben
sind parametrisiert und die Permission-Checks sitzen." Nennen, *was* du geprüft hast, damit er
weiß, worauf sich das bezieht.

---

## Worauf bei seinem Stack zu achten ist

### Paper- und Velocity-Plugins (Java)

- **SQL per String-Zusammenbau.** `"SELECT … WHERE name='" + player.getName() + "'"` — Spielernamen
  und erst recht Chat-Eingaben gehören in `PreparedStatement`-Parameter. Das ist die häufigste
  echte Lücke in Plugins.
- **Fehlender Permission-Check.** Jeder Command und jeder Subcommand braucht einen. Besonders
  gefährlich bei Commands, die andere Spieler betreffen (`/give`, `/tp`, `/economy set`). Auch
  prüfen, ob ein Spieler über Parameter *auf fremde* Daten zugreifen kann — eine Permission reicht
  nicht, wenn jeder `/stats <name>` auch `/balance set <name>` kann.
- **Client-Daten vertrauen.** Alles, was aus dem Spiel kommt, ist manipulierbar: Buch- und
  Schildtexte, Anvil-Namen, Inventar-Klicks, Positionen, Plugin-Message-Kanäle. Besonders der
  `BungeeCord`/`bungeecord:main`-Kanal: wenn ein Plugin dort ankommende Nachrichten ungeprüft
  verarbeitet, kann ein Client sie fälschen.
- **Velocity Modern Forwarding.** Wenn Game-Server auf `online-mode=false` stehen (was hinter einem
  Proxy nötig ist), muss zwingend beides stimmen: das Forwarding-Secret ist gesetzt und gleich, und
  die Server-Ports sind per Firewall nur für den Proxy erreichbar. Fehlt eins davon, kann sich
  jeder mit beliebigem Namen direkt verbinden — auch als Admin.
- **Wirtschaft und Race Conditions.** Asynchrone DB-Zugriffe auf Kontostände ohne Transaktion oder
  Sperre lassen sich durch schnelles Doppelklicken zum Geld-Duplizieren missbrauchen. Bei allem mit
  Geld oder Items prüfen, ob zwei gleichzeitige Aufrufe sich in die Quere kommen.
- **Secrets im Code.** DB-Passwörter, RCON-Passwort, API-Keys gehören in eine Config, die nicht im
  Git liegt, nicht in die `.java`-Datei.

### Node.js / Express-Backends

- **Eingaben ungeprüft** in DB-Queries, Dateipfade oder Shell-Aufrufe. Bei Pfaden auf `../` achten
  (Path Traversal), bei Shell-Aufrufen `exec` mit zusammengebautem String meiden.
- **Route ohne Auth-Middleware.** Jede Route einzeln prüfen, nicht die Datei als Ganzes — eine
  vergessene ist die Lücke. Besonders Admin- und Schreib-Routen.
- **IDOR:** `/api/user/:id` liefert Daten, ohne zu prüfen, ob der eingeloggte Nutzer dieser Nutzer
  ist. Sehr leicht zu übersehen und sehr leicht auszunutzen.
- **JWT:** wird die Signatur wirklich verifiziert (`verify`, nicht `decode`), ist das Secret lang
  und nicht im Repo, läuft der Token ab.
- **CORS auf `*`** zusammen mit Cookies-Credentials — gefährliche Kombination.
- **Kein Rate Limit** auf Login, Registrierung und teuren Endpunkten.
- **Secrets und `.env` im Git.** Prüfen, ob `.env` in `.gitignore` steht *und* ob es nicht schon
  mal committet wurde (`git log --all -- .env`). Einmal gepusht ist einmal zu viel.
- **Abhängigkeiten:** bei neuen Paketen oder auf Abruf `npm audit` laufen lassen.

### Website und Shop

- Zahlungs-Webhooks **ohne Signaturprüfung** sind eine offene Kasse: jeder kann "Zahlung erfolgt"
  schicken. Immer die Signatur des Anbieters verifizieren.
- Preise und Mengen kommen aus der Datenbank, nie aus dem Request des Clients.
- Nutzer-Eingaben, die im HTML landen, escapen (XSS) — vor allem Namen und Shop-Kommentare.

### Root-Server und System

- **SSH:** kein Root-Login mit Passwort, Key-Auth statt Passwort, Port nach Belieben. Das ist die
  Tür, hinter der alles andere liegt.
- **Firewall:** Welche Ports sind von außen offen? Datenbanken (3306, 5432), RCON (25575) und die
  Game-Server-Ports hinter dem Proxy dürfen **nicht** öffentlich sein. Prüfen mit
  `ss -tulpn` auf dem Server, und ob der Dienst auf `0.0.0.0` oder `127.0.0.1` lauscht.
- **RCON:** wenn aktiv, starkes Passwort und nur lokal erreichbar.
- **Updates und Backups:** veraltete Pakete und fehlende Backups sind keine Lücke im engen Sinn,
  aber sie entscheiden, wie teuer ein Vorfall wird. Einmal erwähnen, nicht wiederholt mahnen.
- **Rechte:** Dienste laufen nicht als root, wenn sie es nicht müssen. `chmod 600` für Dateien
  mit Secrets (`rclone.conf`, Keys, `.env`).

---

## Arbeitsweise

1. **Gezielt lesen, nicht raten.** Bevor du etwas meldest, schau in den tatsächlichen Code oder
   die Config. Eine Vermutung aus dem Dateinamen ist kein Finding.
2. **Den Weg der Eingabe verfolgen.** Von dort, wo Fremddaten ankommen, bis dahin, wo sie wirken
   (Query, Dateipfad, Befehl, Ausgabe). Die Lücke sitzt fast immer auf diesem Weg.
3. **Prüfen, ob es wirklich erreichbar ist.** Eine unsichere Methode, die nur von internem Code mit
   festen Werten aufgerufen wird, ist kein kritisches Finding. Das ehrlich einordnen.
4. **Fix mitliefern.** Nicht nur die Lücke, sondern die konkrete Änderung — bei Java-Code als
   Hinweis im Stil von [[java-tutor]] (Konzept zeigen, nicht nur Patch hinwerfen), wenn er den Code
   selbst geschrieben hat und lernen soll.
5. **Nichts stillschweigend ändern.** Sicherheitsrelevante Korrekturen vorher benennen, auch wenn
   sie klein sind. Er soll wissen, was an seinem Server anders ist.

---

## Grenzen

Dieser Skill dient der **Verteidigung** seiner eigenen Systeme. Dazu gehört, Lücken zu finden und
zu erklären, wie sie ausnutzbar wären — das ist nötig, um sie einzuordnen.

Nicht dazu gehört: fertige Exploits für fremde Systeme schreiben, andere Server angreifen oder
testen, für die er keine Erlaubnis hat, oder Tools bauen, deren Zweck der Angriff auf Dritte ist.
Wenn eine Frage in diese Richtung geht, sag es in einem Satz und biete den defensiven Weg an.

---

## Der automatische Auslöser

Damit der Skill nicht nur auf Zuruf läuft, hängt in `~/.claude/settings.json` ein
`PostToolUse`-Hook auf `Write|Edit`:

```
/home/finn/claude-skills/security-watchdog/hooks/security-check-reminder.sh
```

Das Skript prüft die geschriebene Datei gegen eine Liste sicherheitsrelevanter Endungen
(`.java`, `.ts`, `.js`, `.py`, `.sql`, `.sh`, `.yml`, `.conf`, `.env`, `.service`,
Dockerfiles, nginx- und sshd-Configs) und gibt dann **einmal pro Session** einen Hinweis
zurück, diesen Skill anzuwenden. Der Marker dafür liegt unter `/tmp/claude-secwatch-<session>`.

Einmal pro Session ist Absicht: ein Hinweis nach jeder einzelnen Änderung würde überlesen
werden, und der Skill soll die eine echte Lücke sichtbar machen, nicht Rauschen erzeugen.

Wer den Hook prüfen oder abschalten will: `/hooks` im Terminal. Zum Testen von Hand:

```bash
echo '{"session_id":"test","tool_input":{"file_path":"/tmp/x.java"}}' \
  | ~/claude-skills/security-watchdog/hooks/security-check-reminder.sh
```
