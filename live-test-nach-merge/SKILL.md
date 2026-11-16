---
name: live-test-nach-merge
description: Prüfen, ob eine Änderung nach dem Merge wirklich live ist und funktioniert, bei Web-Projekten mit automatischem Deployment (Vercel, Netlify, Cloudflare Pages) und Datenbank-Migrationen (Supabase, Postgres). Nutze diesen Skill, sobald der Nutzer sagt "ist gemerged", "PR ist drin", "teste das mal live", "schau ob es funktioniert", "ich sehe die Änderung nicht", "bei mir kommt noch das Alte", "nicht angemeldet" oder wenn nach einem Merge gegen Production getestet werden soll. Ebenfalls nutzen, bevor ein Test mit echtem Login, echten Nutzerdaten oder einer bezahlten API (z.B. Claude-API) gegen Production läuft. Nicht für lokale Tests, Unit-Tests oder Projekte ohne Deployment.
---

# Live-Test nach dem Merge

«Gemerged» heisst nicht «live», und «live» heisst nicht «beim Nutzer sichtbar». Zwischen Merge und Bildschirm liegen
vier Stufen, und jede kann die alte Version zeigen: Deployment, Datenbank, Browser-Cache, Sitzung. Wer eine Stufe
überspringt, testet die alte Version, hält den Fehler für einen neuen Bug und verbrennt dabei Zeit und (bei bezahlten
APIs) Geld.

Die Reihenfolge unten ist die, in der man am wenigsten rät.

## 1. Ist das Deployment für genau diesen Commit fertig?

Ein Deployment braucht nach dem Merge 30 Sekunden bis einige Minuten. Ein Test in dieser Lücke trifft die alte Version.

```bash
sha=$(git ls-remote origin refs/heads/main | cut -f1)
gh api "repos/<owner>/<repo>/deployments?sha=$sha" --jq '.[] | "\(.environment) \(.created_at)"'
date -u +%FT%TZ
```

Erst testen, wenn ein **Production**-Eintrag für diesen SHA da ist. Fehlt er, warten und nochmal nachsehen, nicht
auf gut Glück testen. Bei Vercel erscheint der Eintrag, sobald das Deployment steht.

## 2. Ist die Migration ausgeführt?

Wenn der Nutzer Migrationen von Hand ausführt (Supabase SQL-Editor), gehört die Migration **vor** den Merge, sobald
der neue Code neue Spalten liest oder schreibt. Vor dem Test kurz prüfen, statt es anzunehmen:

```ts
const r = await db.from("tabelle").select("neue_spalte").limit(1);
// r.error → Migration fehlt
```

Migrationen so schreiben, dass ein zweites Ausführen nicht schadet (`add column if not exists`,
`create table if not exists`, `drop policy if exists` vor `create policy`, `create or replace function`). Der
Nutzer führt sie im Zweifel doppelt aus.

## 3. Liefert der Server wirklich die neue Version?

Nicht annehmen, nachsehen. Die ausgelieferte Seite laden und nach einem Text suchen, den es erst seit der Änderung gibt:

```bash
js=$(curl -s https://<domain>/ | grep -o '/assets/index-[^"]*\.js' | head -1)
curl -s "https://<domain>$js" | grep -c "Neuer Text aus der Änderung"
```

Treffer > 0: Der Server ist in Ordnung, und alles Weitere ist ein Problem auf dem Gerät des Nutzers. Diese eine
Prüfung trennt «Merge kaputt» von «Browser zeigt Altes» und erspart die halbe Fehlersuche.

## 4. Zeigt das Gerät des Nutzers die neue Version?

Sagt der Nutzer «ich sehe es nicht», obwohl Schritt 3 stimmt, ist es fast immer der Cache, bei installierbaren
Web-Apps (PWA) der Service Worker.

- Eine offene App läuft mit dem alten Stand weiter, bis sie neu geladen wird.
- Ein Service Worker, der auf Bestätigung wartet (`registerType: "prompt"`), bleibt hängen, wenn die gespeicherte
  ältere Version den Bestätigungs-Knopf noch nicht kennt. Dann hilft auch normales Neuladen nicht. Für kleine Apps
  ist `autoUpdate` mit regelmässigem `registration.update()` die robustere Wahl.
- Abhilfe für den Nutzer, vom Harmlosen zum Gründlichen: zweimal neu laden, dann Strg+Shift+R, dann den Service
  Worker in den Entwicklerwerkzeugen abmelden bzw. die Website-Daten löschen.

Am besten gar nicht erst raten müssen: Die App zeigt irgendwo klein ihre **Version** (Commit-Kürzel und Build-Zeit,
z.B. per `define` in der Vite-Config aus `VERCEL_GIT_COMMIT_SHA`). Dann reicht die Frage «Welche Version steht bei dir?».

Bevor du eine technische Ursache suchst, auch die einfache prüfen: Sucht der Nutzer an der richtigen Stelle? Ein
neues Feature, das in einem bestehenden Tab versteckt ist, wird leicht nicht gefunden.

## 5. Mit echtem Login testen, ohne etwas kaputt zu machen

Für Endpunkte, die einen Login brauchen, lässt sich mit dem Service-Role-Key eine Sitzung für das Konto des Nutzers
erzeugen (Supabase: `auth.admin.generateLink({ type: "magiclink" })` und danach `verifyOtp` mit dem `hashed_token`).
Dabei gelten drei Regeln:

- **Vorher sagen**, dass und wofür du dich als der Nutzer anmeldest.
- **Nie `auth.signOut()` ohne `{ scope: "local" }` aufrufen.** Der Standard ist global und meldet den Nutzer auf
  allen Geräten ab. Er sieht dann «Nicht angemeldet», obwohl die App eingeloggt aussieht. Am einfachsten: am Ende
  gar nicht abmelden.
- **Nichts an den echten Daten ändern**, ohne dass der Nutzer es ausdrücklich will. Lesen und prüfen ist in Ordnung;
  einen Plan umschreiben, etwas löschen oder importieren nicht. Lässt sich ein Schreibweg nur mit Änderung testen,
  die harmlose Variante nehmen (ablehnen statt annehmen, gleichen Wert zurückschreiben) und den Rest dem Nutzer lassen.

Testdaten, die im Verlauf des Nutzers landen (Chat-Nachrichten, Vorschläge, Log-Einträge), sieht er. Hinterher
aufräumen oder ihm sagen, welche Einträge von dir stammen.

## 6. Bezahlte Aufrufe zählen

Bei Tests gegen eine bezahlte API (Claude-API und Ähnliches):

- Vor dem ersten Aufruf die Schritte 1 bis 3 erledigen. Ein Aufruf gegen die alte Version kostet und sagt nichts.
- So wenige Aufrufe wie nötig, und nach jedem Fehler erst die Ursache klären, dann erneut aufrufen.
- Den echten Verbrauch auslesen (Token-Felder der Antwort bzw. die gespeicherten Werte) und dem Nutzer nennen:
  wie viele Aufrufe, was sie gekostet haben, was davon durch eigene Fehler verloren ging.

## 7. Ehrlich berichten

Am Ende klar trennen: Was lief gegen Production und hat funktioniert? Was ist nur lokal oder mit Testdaten geprüft?
Was ist gar nicht getestet, und warum (fehlende Berechtigung, würde Daten ändern)? Ein «funktioniert» ohne diese
Trennung ist für den Nutzer nichts wert, wenn es beim ersten Klick dann doch hakt.
