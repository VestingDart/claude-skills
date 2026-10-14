---
name: hack-stack-picker
description: >
  Wählt für einen Hackathon einen bewusst langweiligen, bekannten Tech-Stack plus eine
  Alternative, benennt Zeitfresser (eigene Auth, eigenes Deployment, Microservices,
  Frameworks, die niemand kennt), schlägt Gratis-Ersatz vor (Hosted Auth, SQLite, Vercel o. Ä.)
  und berücksichtigt Sponsor-APIs und Sponsor-Preise der Challenge. Nutze diesen Skill, wenn im
  Hackathon die Technik entschieden wird: "welchen Stack für den Hackathon", "womit bauen wir
  das in 24 Stunden", "sollen wir die Sponsor-API nehmen", "tech stack for the hackathon",
  "which framework for the hackathon", "START Hack Stack". Nur im Hackathon-Kontext mit
  Zeitlimit und Jury. NICHT für Architektur- oder Framework-Entscheidungen in normalen Projekten
  (dafür idea-challenger) und nicht zum Aufsetzen des Repos (dafür hack-scaffold).
---

# Hackathon-Stack wählen

## Zweck

Im Hackathon gewinnt nicht der interessanteste Stack, sondern der, mit dem das Team nach einer
Stunde etwas Laufendes hat. Dieser Skill empfiehlt die langweiligste Lösung, die die Challenge
erfüllt, und macht die Stellen sichtbar, an denen sonst Stunden verschwinden.

## Wann nutzen – und wann nicht

**Nutzen:** nach dem Kickoff, bevor das Repo entsteht; oder wenn mitten im Event eine Schicht
ausgetauscht werden soll (z. B. "die DB macht Probleme").

**Nicht nutzen:** für Stack-Entscheidungen ausserhalb eines Hackathons. Dort zählen Wartbarkeit
und Lernen, nicht 24 Stunden. Das gehört zu idea-challenger.

## Vorgehen

1. **Input klären.** Teamskills (was wurde schon *produktiv* benutzt, nicht "mal ein Tutorial
   gemacht"), Zeitrahmen, Art des Projekts (Web, Mobile, Daten, ML, Hardware), erlaubte Tools,
   Sponsor-APIs und Sponsor-Preise, Abgabeform (Live-URL nötig? Repo öffentlich?). Liegt ein
   Plan aus `hack-kickoff` vor, daraus übernehmen. Sonst höchstens drei Rückfragen.
2. **Pro Schicht das Bekannteste wählen.** Regel: Was mindestens zwei Personen im Team schon
   benutzt haben, schlägt alles Neue. *Neu* höchstens an einer Stelle und nur, wenn es Punkte
   bringt (Sponsor-Preis, Kernkriterium der Jury).
3. **Zeitfresser prüfen und ersetzen.**

   | Zeitfresser | Stattdessen |
   |---|---|
   | Eigene Auth (Passwörter, Sessions, Mails) | Hosted Auth (z. B. Supabase Auth, Clerk, Firebase Auth) oder gar kein Login: ein fester Demo-Account |
   | Eigener Server, eigenes Deployment, Kubernetes | Vercel, Netlify, Render, Railway, Fly.io o. Ä. |
   | Microservices | ein Backend, ein Repo |
   | Datenbank-Server aufsetzen | SQLite oder eine gehostete DB (z. B. Supabase, Neon) |
   | Framework, das niemand im Team kennt | das bekannte Framework |
   | Eigenes ML-Training | fertige API oder vortrainiertes Modell |
   | Native App, wenn Mobile kein Kriterium ist | Web-App bzw. PWA |
   | Eigene Echtzeit-Infrastruktur | Realtime-Funktion eines Hosting-Anbieters oder Polling |

   Free Tiers, Limits und Preise ändern sich. Vor Ort prüfen (Anbieter-Seite), nicht aus dem
   Gedächtnis zusagen. In der Tabelle als "prüfen" markieren, wenn nicht verifiziert.
4. **Sponsor-APIs einordnen.** Für jede relevante API: Gibt es einen eigenen Preis? Passt sie
   in den Demo-Pfad, oder wäre sie nur angeklebt? Wie kommt man an Key und Quota? Faustregel:
   Key in der ersten Stunde besorgen und einen echten Call testen. Gefährdet die API das MVP,
   die Abwägung offen nennen (Preis-Chance gegen Demo-Risiko). Entscheiden muss das Team.
5. **Eine Alternative nennen**, mit dem Fall, in dem sie besser wäre ("Wenn ihr lieber Python
   schreibt: …").
6. **Risiko pro Schicht** in einem Halbsatz: was am wahrscheinlichsten klemmt.

## Ausgabeformat

```markdown
## Stack-Empfehlung – ‹Projekt›

| Schicht | Wahl | Begründung | Risiko |
|---|---|---|---|
| Frontend | … | … | … |
| Backend / API | … | … | … |
| Datenbank | … | … | … |
| Auth | … | … | … |
| Hosting / Deploy | … | … | … |
| Externe APIs / KI | … | … | … |
| Sponsor-Integration | … | … | … |

**Alternative:** ‹1–2 Sätze, wann sie besser wäre›

**Bewusst weggelassen:** ‹Zeitfresser, die vermieden werden›

**Erste Stunde:** Keys besorgen und testen · Hello World deployen · alle starten lokal

**Annahmen:** …
```

Danach anbieten, mit `hack-scaffold` das Grundgerüst aufzusetzen.

## Grenzen

- Empfiehlt nur, entscheidet nicht. Setzt nichts auf und installiert nichts.
- Keine Preise, Limits oder Gratis-Kontingente als Fakt ohne Prüfung.
- Keine API-Keys in Dateien oder im Chat-Ergebnis. Nur benennen, *welche* Keys gebraucht werden.
- Schreiben die Event-Regeln Tools vor oder verbieten welche, gelten die Regeln.
