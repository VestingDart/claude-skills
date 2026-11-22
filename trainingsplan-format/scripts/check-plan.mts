// Prüft eine plan.md mit dem Parser der Fitness-App (parsePlan aus api/_lib/plan/format.ts).
// So gelten genau die Regeln, die auch der Import in der App anwendet.
//
// Aufruf (aus dem Repo-Ordner des Fitness-Trackers, wegen node_modules):
//   npx tsx ~/.claude/skills/trainingsplan-format/scripts/check-plan.mts plan.md [--zonen 124,154,169,184] [--hrmax 194]
//
// Exit 0: importierbar (Warnungen möglich), 1: Fehler im Plan, 2: Aufruf falsch.
import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import { pathToFileURL } from "node:url";

const args = process.argv.slice(2);
const file = args.find((a) => !a.startsWith("--") && !/^\d/.test(a));
const opt = (name: string) => {
  const i = args.indexOf(name);
  return i >= 0 ? args[i + 1] : undefined;
};

if (!file) {
  console.error("Aufruf: npx tsx check-plan.mts <plan.md> [--zonen 124,154,169,184] [--hrmax 194] [--repo <pfad>]");
  process.exit(2);
}

const repo = resolve(opt("--repo") ?? process.cwd());
const formatPath = resolve(repo, "api/_lib/plan/format.ts");
type Issue = { line: number; message: string };
type Plan = { title: string; start: string; end: string; blocks: unknown[]; sessions: unknown[] };
type Format = {
  parsePlan(md: string, o: { zoneMax?: number[]; hrMax?: number }): { plan: Plan | null; errors: Issue[]; warnings: Issue[] };
  weekOverview(p: Plan): { week: string; sessions: number; optional: number; hours: number; sports: string }[];
};
let mod: Format;
try {
  mod = await import(pathToFileURL(formatPath).href);
} catch {
  console.error(`Parser nicht gefunden: ${formatPath}`);
  console.error("Im Repo des Fitness-Trackers ausführen oder --repo <pfad> angeben.");
  process.exit(2);
}

const zones = opt("--zonen");
const hrMax = opt("--hrmax");
const result = mod.parsePlan(readFileSync(file, "utf8"), {
  zoneMax: zones ? zones.split(",").map(Number) : undefined,
  hrMax: hrMax ? Number(hrMax) : undefined,
});

const where = (line: number) => (line > 0 ? `Zeile ${line}: ` : "");
for (const e of result.errors) console.log(`FEHLER   ${where(e.line)}${e.message}`);
for (const w of result.warnings) console.log(`WARNUNG  ${where(w.line)}${w.message}`);

if (!result.plan) {
  console.log(`\nNicht importierbar: ${result.errors.length} Fehler.`);
  process.exit(1);
}

const p = result.plan;
console.log(`\nImportierbar: «${p.title}», ${p.start} bis ${p.end}, ${p.blocks.length} Blöcke, ${p.sessions.length} Einheiten.`);
for (const w of mod.weekOverview(p)) {
  console.log(`  Woche ab ${w.week}: ${w.sessions} Einheiten (${w.optional} optional), ${w.hours} h, ${w.sports}`);
}
