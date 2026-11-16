---
name: ui-vorschau-ohne-login
description: Eine neue oder geänderte Oberfläche (React/Vite-Komponente, Seite, Chart, Karte) selbst ansehen, bevor der Nutzer sie sieht, auch wenn die App einen Login oder ein Backend braucht. Baut eine Wegwerf-Vorschau mit ersetztem Backend-Client und macht Screenshots in Desktop- und Handybreite mit einem Headless-Browser. Nutze diesen Skill, wenn UI gebaut oder umgebaut wurde und im Bericht sonst "nicht im Browser geprüft" stünde, wenn der Nutzer sagt "schau dir an wie das aussieht", "mach einen Screenshot", "passt das am Handy", oder bevor ein PR mit sichtbaren Änderungen aufgeht. Nicht für reine Logik ohne Oberfläche und nicht als Ersatz für Tests der Rechenlogik.
---

# UI-Vorschau ohne Login

Typecheck und Tests sagen nichts darüber, ob eine Oberfläche gut aussieht: ob eine Beschriftung umbricht, eine Kurve
flach gedrückt ist oder am Handy etwas über den Rand läuft. Solche Fehler findet man nur durch Hinsehen. Meistens
steht dem ein Login im Weg, für den man kein Passwort hat. Die Lösung ist, die Komponente ausserhalb der App zu
rendern und nur das Backend zu ersetzen.

## Das Prinzip

1. Ein Wegwerf-Ordner im Projekt (z.B. `.harness/`) mit eigener `index.html`, `main.tsx` und `vite.config.ts`.
2. Die Vite-Config leitet den Import des Backend-Clients (Supabase, API-Client) auf eine Attrappe um. Die Komponente
   selbst bleibt unverändert.
3. `main.tsx` rendert die Komponente mit Beispiel- oder echten Daten.
4. Ein Headless-Browser macht Screenshots, die du dir mit dem Read-Tool ansiehst.
5. Den Ordner danach löschen. Er kommt nie in einen Commit.

Der Ordner liegt im Projekt und nicht im Scratchpad, weil Vite `node_modules`, Tailwind und PostCSS des Projekts
braucht.

## Die Vite-Config

```ts
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import path from "node:path";

export default defineConfig({
  root: path.resolve(__dirname),
  plugins: [
    react(),
    // Antwort verzögern, damit der Screenshot erst nach dem Rendern entsteht (siehe unten)
    { name: "slow", configureServer(s) { s.middlewares.use("/slow.png", (_q, res) => setTimeout(() => { res.statusCode = 204; res.end(); }, 2500)); } },
    // Backend-Client durch die Attrappe ersetzen
    { name: "mock", enforce: "pre", resolveId(src, importer) {
        if (/(^|\/)supabase$/.test(src) && importer && !importer.includes(".harness")) return path.resolve(__dirname, "supabase-mock.ts");
    } },
  ],
  css: { postcss: path.resolve(__dirname, "..") },
  server: { port: 5199, strictPort: true, fs: { allow: [path.resolve(__dirname, "..")] } },
});
```

Der Ausdruck im `resolveId` muss zu **allen** Schreibweisen des Imports passen: `../lib/supabase` aus Komponenten
und `./supabase` aus Nachbardateien. Greift er nicht, lädt die echte Datei und die Seite bleibt leer (im Vite-Log
steht dann z.B. «supabaseUrl is required»).

## Die Attrappe

Nur so viel nachbauen, wie die Komponente aufruft. Für verkettete Abfragen reicht ein Objekt, das sich selbst
zurückgibt und am Ende Daten liefert:

```ts
const data: Record<string, unknown> = { feedback: [/* … */], daily_metrics: { ctl: 18.9, atl: 7.5 } };
function query(table: string) {
  const q: Record<string, unknown> = {};
  for (const m of ["select", "eq", "order", "limit"]) q[m] = () => q;
  q.maybeSingle = () => Promise.resolve({ data: data[table] ?? null });
  q.then = (resolve: (v: unknown) => void) => resolve({ data: data[table] ?? null });
  return q;
}
export const supabase = { from: query, auth: { getSession: () => Promise.resolve({ data: { session: null } }) } };
```

**Echte Daten sind besser als erfundene.** Lange Namen, fehlende Werte und Ausreisser zeigen Layoutfehler, die
saubere Beispieldaten verstecken. Wenn ein Service-Role-Key lokal vorhanden ist, die Daten mit einem kleinen Script
in eine JSON-Datei im Harness-Ordner holen und von dort einlesen. Steht Platzhaltertext in der Vorschau, das im
Bericht sagen, damit niemand ihn für echte Ausgabe hält.

## Screenshots

Server im Hintergrund starten (`run_in_background`), dann:

```bash
D="<scratchpad>"; mkdir -p "$D/ffp"
for i in 1 2 3 4 5 6 7 8; do curl -s -o /dev/null http://localhost:5199/ && break; done
timeout 40 firefox --headless --no-remote --profile "$D/ffp" --window-size=900,1300 --screenshot "$D/desktop.png" "http://localhost:5199/?view=a"
timeout 40 firefox --headless --no-remote --profile "$D/ffp" --window-size=390,1200 --screenshot "$D/handy.png" "http://localhost:5199/?view=a"
```

- `--no-remote --profile <eigener Ordner>` verhindert, dass der Aufruf im laufenden Firefox des Nutzers landet.
- Immer **beide Breiten**: Desktop und Handy (390 px). Die meisten Fehler zeigen sich nur in einer.
- Chromium geht genauso (`chromium --headless --screenshot=… --window-size=…`), falls installiert. Vorher mit
  `which` nachsehen, was da ist.

**Der Screenshot kommt zu früh.** Firefox fotografiert beim `load`-Ereignis, React und Charts zeichnen aber danach.
Das Ergebnis ist «Laden…» oder leere Chart-Flächen. Abhilfe: In die `index.html` ein unsichtbares Bild einbauen,
das der Server verzögert beantwortet (`<img src="/slow.png" style="display:none">` plus die `slow`-Middleware oben).
Das `load`-Ereignis wartet darauf, und der Screenshot entsteht nach dem Rendern.

Sehr kleine PNG-Dateien (wenige KB) sind ein Zeichen für eine leere Seite: dann das Vite-Log lesen, nicht den
Screenshot.

## Worauf beim Ansehen achten

- Umbrüche und abgeschnittener Text, vor allem in Karten und Tabellen am Handy
- Doppelte oder überflüssige Beschriftungen («Schwimmen: Schwimmen: Technik»)
- Achsen, die durch Ausreisser unbrauchbar werden
- Leere und Lade-Zustände: Was steht da, wenn keine Daten kommen?
- Zwei Datenreihen: sind sie unterscheidbar und beschriftet?

Gefundenes sofort beheben und neu fotografieren, nicht nur notieren.

## Aufräumen

- Den Server über seine Prozess-ID beenden (`pgrep -f "node.*vite"`, dann `kill <pid>`). **Kein `pkill -f` mit einem
  Muster, das auch im eigenen Befehl vorkommt**: das trifft die eigene Shell und bricht den Befehl ab.
- `.harness/` löschen und mit `git status --short` prüfen, dass nichts davon übrig ist.
- Eigenschaften, die nur für die Vorschau in eine Komponente kamen (z.B. ein vorausgewählter Zustand), wieder entfernen.

## Was die Vorschau nicht zeigt

Sie beweist das Aussehen, nicht das Zusammenspiel: Login, echte Antworten des Servers und Klickwege sind damit
nicht getestet. Im Bericht deshalb getrennt sagen, was angeschaut wurde (welche Ansicht, welche Breiten, echte oder
Beispieldaten) und was erst in der eingeloggten App sichtbar wird.
