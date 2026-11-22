#!/usr/bin/env bash
# Sucht in UI-Code nach Mustern, die nach KI-generiertem Standard aussehen.
# Gibt Hinweise aus, keine Urteile: jeden Treffer ansehen und entscheiden.
#
# Aufruf:  ki-look-check.sh [ordner]      (Standard: src)
# Exit 0:  keine Treffer, Exit 1: Treffer gefunden, Exit 2: Ordner fehlt.

set -uo pipefail

dir=${1:-src}
[ -d "$dir" ] || { echo "Ordner nicht gefunden: $dir" >&2; exit 2; }

# Nur UI-Dateien, ohne Abhängigkeiten, Build-Ausgaben und Tests
files=()
while IFS= read -r -d '' f; do files+=("$f"); done < <(
  find "$dir" \( -name node_modules -o -name dist -o -name build -o -name .next -o -name .git \) -prune -o \
    -type f \( -name '*.tsx' -o -name '*.jsx' -o -name '*.ts' -o -name '*.js' -o -name '*.vue' \
               -o -name '*.svelte' -o -name '*.html' -o -name '*.css' -o -name '*.scss' \) \
    -not -name '*.test.*' -not -name '*.spec.*' -not -name '*.d.ts' -print0)

[ ${#files[@]} -gt 0 ] || { echo "Keine UI-Dateien in $dir"; exit 0; }

# Dateien, in denen Farbwerte stehen dürfen
is_token_file() {
  case $1 in
    *tailwind.config.*|*theme.*|*tokens.*|*index.css|*globals.css|*variables.css) return 0 ;;
  esac
  return 1
}

total=0
check() {
  local label=$1 pattern=$2 mode=${3:-E} skip_tokens=${4:-no}
  local out="" f hits
  for f in "${files[@]}"; do
    [ "$skip_tokens" = yes ] && is_token_file "$f" && continue
    hits=$(grep -n"$mode" -- "$pattern" "$f" 2>/dev/null | cut -c1-160) || continue
    out+=$(printf '%s\n' "$hits" | sed "s|^|  $f:|")$'\n'
  done
  if [ -n "$out" ]; then
    local n; n=$(printf '%s' "$out" | grep -c .)
    total=$((total + n))
    printf '\n%s (%d)\n%s' "$label" "$n" "$out"
  fi
}

check "Emojis (als Icons oder im Text)" \
  '[\x{1F300}-\x{1FAFF}\x{2600}-\x{27BF}\x{2B50}]' P
check "Grossbuchstaben-Überschriften" \
  '\buppercase\b|tracking-(wide|wider|widest)\b|text-transform:\s*uppercase'
check "Grosse Rundung" \
  'rounded-(2xl|3xl)\b|border-radius:\s*(1[6-9]|[2-9][0-9])px'
check "rounded-full (gewollt nur bei Punkten, Avataren, dünnen Balken)" \
  'rounded-full\b'
check "Schatten" \
  'shadow-(md|lg|xl|2xl)\b|box-shadow:\s*0\s+[0-9]+px\s+[0-9]{2,}px'
check "Verläufe und Glas-Effekt" \
  'bg-gradient-|from-[a-z]+-[0-9]{2,3}\b.*to-[a-z]+-|linear-gradient|radial-gradient|backdrop-blur|bg-clip-text'
check "Standard-Tailwind-Grau und -Blau/Violett statt Tokens" \
  '\b(bg|text|border|ring|divide|from|to|via)-(zinc|slate|gray|neutral|stone|indigo|violet|purple|blue)-[0-9]{2,3}\b' E yes
check "Hex-Farben in Komponenten (gehören in die Tokens)" \
  '#[0-9a-fA-F]{6}\b|#[0-9a-fA-F]{3}\b' E yes
check "Ladeskelette und Hover-Hebeeffekte" \
  'animate-(pulse|bounce|ping)\b|hover:(scale|-?translate-y)-'
check "Donut-/Tortendiagramme" \
  '<(PieChart|Pie|Doughnut)\b|type:\s*["'"'"'](pie|doughnut)["'"'"']'
check "Floskeln und Ausrufezeichen in Texten" \
  '>[^<{]*!\s*<|Willkommen zurück|Los geht|Entfessle|Insights|Powered by|Let'"'"'s get started|Welcome back|Unlock'

echo
if [ $total -eq 0 ]; then
  echo "Keine Treffer in ${#files[@]} Dateien."
  exit 0
fi
echo "$total Hinweise in ${#files[@]} Dateien. Jeden ansehen: gewollt lassen, sonst nach SKILL.md ersetzen."
exit 1
