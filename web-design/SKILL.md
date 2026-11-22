---
name: web-design
description: >
  Legt vor dem Bauen jeder Web-Oberfläche eine eigene, zum Inhalt passende Designrichtung fest
  (Konzept, Schrift, Farben, Layout, ein Erkennungsmerkmal) und setzt sie dann um, damit das
  Ergebnis nicht nach generischer AI-Website aussieht: keine lila Verläufe, kein Inter-Einheitslook,
  kein zentrierter Hero mit drei Icon-Karten, kein Glassmorphism, keine Floskeln wie "Unlock" oder
  "Seamless". Nutze diesen Skill immer, wenn eine Website, Landingpage, Server-Seite, Shop, Wiki,
  Portfolio, Dashboard, App-Oberfläche, HTML-Artifact oder irgendein Frontend neu gebaut oder
  grundlegend neu gestaltet wird, egal mit welchem Stack (HTML/CSS, Tailwind, React, Next, Astro,
  Svelte), auch wenn das Wort "Design" gar nicht fällt ("bau mir eine Seite für X", "mach eine
  Landingpage", "ich brauch ein Frontend dafür"). NICHT für reine Backend-Arbeit, kleine Bugfixes
  an bestehendem CSS oder wenn ein festes Design-System/Figma vorgegeben ist, das nur umgesetzt wird.
---

# Web-Design ohne AI-Look

Generierte Websites sehen sich ähnlich, weil jede Entscheidung auf den wahrscheinlichsten Wert
fällt: die Schrift, die am häufigsten vorkommt, die Farbe, die "modern" heißt, das Layout, das in
tausend SaaS-Templates steht. Jede einzelne Wahl ist vertretbar, zusammen ergeben sie den Look,
den man sofort als AI erkennt. Ein Mensch entscheidet anders: vom Gegenstand aus. Ein
Minecraft-Server, eine Bäckerei und ein Entwickler-Tool brauchen verschiedene Seiten, weil sie
verschiedene Dinge sind.

Darum dreht dieser Skill die Reihenfolge um: **erst eine Richtung festlegen, dann bauen.** Wer
ohne Richtung anfängt, landet automatisch bei den Defaults.

---

## Ablauf

### 1. Den Gegenstand verstehen

Bevor du auch nur eine Farbe denkst, kläre:

- **Worum geht es konkret?** Nicht "ein Gaming-Server", sondern was ihn ausmacht: Survival mit
  Wirtschaft, eine bestimmte Welt, eine Community mit eigenem Ton.
- **Wer schaut die Seite an und was will diese Person dort tun?** Joinen, kaufen, nachschlagen,
  kontaktieren. Die wichtigste Handlung bestimmt die Gewichtung der Seite.
- **Welches echte Material gibt es?** Namen, Texte, Screenshots, Logos, Zahlen, Regeln, Preise.
  Echtes Material ist der stärkste Schutz gegen generisches Aussehen, weil es nicht austauschbar ist.

Wenn Wesentliches fehlt und sich nicht aus dem Kontext ergibt, frag kurz nach (höchstens zwei,
drei Fragen). Bei kleinen Aufgaben oder klaren Vorgaben: mit vernünftigen Annahmen weitermachen
und sie im Brief nennen.

### 2. Einen Design-Brief schreiben

Schreib vor dem Code einen kurzen Brief und zeig ihn mit (fünf bis acht Zeilen reichen). Er
zwingt dazu, jede Entscheidung bewusst zu treffen:

```
Konzept:     <ein Satz: welches Bild/welche Welt die Seite trägt>
Referenz:    <ein Vorbild außerhalb des Webs, aus dem Gegenstand abgeleitet>
Schrift:     <Display-Schrift + Text-Schrift, mit Begründung>
Farben:      <3–5 Werte mit Rolle: Grund, Text, Akzent, ggf. Fläche/Linie>
Layout:      <das Ordnungsprinzip, z. B. "Zeitungsraster, 12 Spalten, harte Linien">
Merkmal:     <das eine Element, an dem man die Seite wiedererkennt>
Bewusst weg: <welche naheliegenden Defaults du hier nicht nimmst>
```

**Die Referenz ist der wichtigste Hebel.** Such sie außerhalb von Websites, im Umfeld des
Gegenstands: Fahrpläne, Etiketten, Speisekarten, Handbücher, Plakate, Ladenschilder, Karten,
Bedienfelder, Zeitschriften, Verpackungen. Eine Seite, die sich an einem Zugfahrplan oder einem
Apothekenetikett orientiert, kann gar nicht nach Template aussehen, weil das Template diese
Referenz nicht kennt.

Beispiele, wie das klingt:

- *Minecraft-Survival-Server mit Händler-Wirtschaft:* Referenz Marktplatz-Aushang und
  Kontorbuch. Serifenschrift mit Charakter für Überschriften, Monospace für Preise/Koordinaten,
  Pergament-Grund mit Tintenfarbe, Tabellen statt Karten. Merkmal: die Server-IP als
  "Stempel" zum Kopieren.
- *CLI-Tool für Entwickler:* Referenz technisches Datenblatt. Eng gesetzte Grotesk, viel
  Monospace, ein einziger Signalfarbton, sichtbares Raster mit Maßlinien. Merkmal: echte
  Terminal-Ausgabe statt Illustration.
- *Lokale Bäckerei:* Referenz handgeschriebene Tafel und Papiertüte. Warme Töne, eine Schrift
  mit Handwerk, Öffnungszeiten groß und zuerst, weil das die meistgesuchte Info ist.

### 3. Bauen

Setz den Brief um. Dabei gilt:

- **Echte Inhalte zuerst.** Wo Inhalte fehlen, deutlich markierte Platzhalter (`[Preis eintragen]`)
  statt erfundener Zahlen, Testimonials oder Kundenlogos. Erfundene Social Proof ist nicht nur
  ein AI-Merkmal, auf einer echten Seite ist sie irreführend.
- **Design-Werte als Variablen** (CSS Custom Properties oder Tailwind-Theme), damit die Richtung
  aus dem Brief an einer Stelle lebt und nicht in hundert Klassen zerfällt.
- **Bei Tailwind:** die Defaults sind genau das Problem (`slate`, `indigo`, `rounded-2xl`,
  `shadow-lg`, `gap-8` überall). Leg im Theme eigene Farben, Radien und Abstände an und nutze die.
- **Text schreiben wie ein Mensch, der das Ding kennt.** Konkret, kurz, ohne Marketing-Verben.
  "Survival mit Spieler-Shops, Reset nur alle 6 Monate" statt "Erlebe ein einzigartiges
  Abenteuer".
- **Benutzbarkeit bleibt Pflicht.** Kontrast (WCAG AA), lesbare Textgröße (ab 16px Fließtext),
  Fokuszustände, mobil ohne horizontales Scrollen. Eigenständig heißt nicht unbedienbar.

### 4. Gegenprüfen

Geh am Ende die Liste der AI-Merkmale in `references/ai-tells.md` durch. Ein einzelnes Merkmal
ist kein Drama, wenn es bewusst gewählt ist und zum Brief passt. Kritisch ist die Häufung: drei,
vier Treffer zusammen ergeben den erkennbaren Look. Für jeden Treffer, der nicht begründet ist:
ersetzen.

Dann die Schlussfrage: **Würde jemand die Seite wiedererkennen, wenn man Logo und Namen
wegnimmt?** Wenn nein, fehlt das Merkmal aus dem Brief oder es ist zu schwach umgesetzt.

Wenn du die Seite rendern und ansehen kannst (Browser-Tool, Screenshot), tu es vor dem Abschluss.
Am Code allein sieht man Rhythmus und Gewichtung schlecht.

---

## Die Falle "anders um jeden Preis"

Gegen Defaults zu arbeiten erzeugt eigene Klischees. Inzwischen gibt es einen zweiten AI-Look,
der "kreativ" sein will: Space Grotesk oder Instrument Serif, cremefarbener Grund mit
Terrakotta-Akzent, riesige Serif-Headline, Brutalismus mit dicken schwarzen Rändern, alles
klein geschrieben. Das ist genauso austauschbar.

Der Ausweg ist immer derselbe: zurück zum Gegenstand. Eine Entscheidung ist gut, wenn sie sich
aus dem Brief begründen lässt, nicht weil sie ungewöhnlich ist. Ein schlichtes, ruhiges Design
kann völlig richtig sein, wenn es zum Inhalt passt.

---

## Dashboards und App-Oberflächen

Bei Tools, Dashboards und Admin-Oberflächen ist der Spielraum kleiner, weil Dichte und
Lesbarkeit vorgehen. Der Brief wird kürzer, die Prinzipien bleiben: eine bewusste Schrift (gern
eine mit guten Tabellenziffern), eine eigene kleine Palette statt Tailwind-Grau plus Indigo,
Information nach Wichtigkeit statt alles in gleich großen Karten, keine dekorativen Verläufe.
Für Diagramme gilt der `dataviz`-Skill, falls vorhanden.

---

## Ausgabe

1. Den Design-Brief (kurz, im Chat, vor dem Code).
2. Die umgesetzte Seite.
3. Zwei, drei Sätze, wo der Brief sichtbar wird und welche Platzhalter noch mit echten Inhalten
   gefüllt werden müssen.
