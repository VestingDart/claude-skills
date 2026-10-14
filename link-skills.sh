#!/usr/bin/env bash
# Verlinkt die Skills aus diesem Repo einzeln nach ~/.claude/skills.
#
# Claude Code findet Skills nur eine Ebene tief (<skills-ordner>/<name>/SKILL.md).
# Gruppierte Skills wie hackathon/<name>/SKILL.md brauchen deshalb je einen
# eigenen Symlink. Das Skript legt nur fehlende Links an. Es loescht und
# ueberschreibt nie etwas, und ohne --apply aendert es gar nichts.
#
# Aufruf:
#   ./link-skills.sh                    Vorschau fuer alle Skills
#   ./link-skills.sh hackathon          Vorschau nur fuer einen Ordner
#   ./link-skills.sh --apply hackathon  fehlende Links wirklich anlegen
#
# Zielordner aenderbar mit CLAUDE_SKILLS_DIR (Standard: ~/.claude/skills).

set -euo pipefail

repo=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
target=${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}
apply=false
filters=()

for arg in "$@"; do
  case $arg in
    --apply) apply=true ;;
    -h|--help) sed -n '2,14p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -*) echo "Unbekannte Option: $arg" >&2; exit 2 ;;
    *)
      dir=$(cd "$repo" && cd "$arg" 2>/dev/null && pwd -P) \
        || { echo "Ordner nicht gefunden: $arg" >&2; exit 2; }
      case $dir/ in
        "$repo"/*) filters+=("$dir") ;;
        *) echo "Liegt nicht im Repo: $arg" >&2; exit 2 ;;
      esac
      ;;
  esac
done

if [ ! -d "$target" ]; then
  echo "Zielordner fehlt: $target" >&2
  exit 1
fi
if [ "$(cd "$target" && pwd -P)" = "$repo" ]; then
  echo "$target zeigt direkt auf dieses Repo (alter Aufbau mit einem einzigen Symlink)." >&2
  echo "Gruppierte Skills funktionieren so nicht. Umstellung: siehe hackathon/README.md." >&2
  exit 1
fi

# Alle Skill-Ordner: <name>/SKILL.md oder <gruppe>/<name>/SKILL.md.
# Ordner, deren Elternordner selbst ein Skill ist, gehoeren zu diesem Skill.
skills=()
while IFS= read -r file; do
  dir=${file%/SKILL.md}
  [ -f "$(dirname "$dir")/SKILL.md" ] && continue
  skills+=("$dir")
done < <(find "$repo" -mindepth 2 -maxdepth 3 -name SKILL.md \
           -not -path "$repo/.git/*" -not -path "$repo/synced/*" | sort)

# Skill-Namen muessen eindeutig sein, sonst wuerden sich Links gegenseitig verdecken.
dupes=$(for d in "${skills[@]}"; do basename "$d"; done | sort | uniq -d)
if [ -n "$dupes" ]; then
  echo "Doppelte Skill-Namen, nichts verlinkt:" >&2
  echo "$dupes" | sed 's/^/  /' >&2
  exit 1
fi

created=0
problems=0
line() { printf '  %-13s %-26s %s\n' "$1" "$2" "$3"; }

for dir in "${skills[@]}"; do
  if [ ${#filters[@]} -gt 0 ]; then
    match=false
    for f in "${filters[@]}"; do
      case $dir/ in "$f"/*) match=true ;; esac
    done
    $match || continue
  fi

  name=$(basename "$dir")
  rel=${dir#"$repo"/}
  link=$target/$name

  fm_name=$(awk 'NR == 1 && /^---$/ { fm = 1; next }
                 fm && /^---$/ { exit }
                 fm && /^name:/ { sub(/^name:[[:space:]]*/, ""); print; exit }' "$dir/SKILL.md")
  if [ "$fm_name" != "$name" ]; then
    line WARNUNG "$name" "name im Frontmatter ist \"$fm_name\""
    problems=$((problems + 1))
  fi

  if [ -L "$link" ]; then
    if [ "$(readlink -f "$link")" = "$dir" ]; then
      line ok "$name" "$rel"
    else
      line WARNUNG "$name" "Link zeigt auf $(readlink "$link"), nicht angefasst"
      problems=$((problems + 1))
    fi
  elif [ -e "$link" ]; then
    line WARNUNG "$name" "existiert als echter Ordner, nicht angefasst"
    problems=$((problems + 1))
  elif compgen -G "$target/synced/*/$name/SKILL.md" > /dev/null; then
    line uebersprungen "$name" "kommt schon ueber den claude.ai-Sync"
  elif $apply; then
    ln -s "$dir" "$link"
    line angelegt "$name" "$rel"
    created=$((created + 1))
  else
    line fehlt "$name" "$rel (mit --apply anlegen)"
  fi
done

# Tote Links im Zielordner (Skill geloescht oder verschoben). Nur melden.
for link in "$target"/*; do
  if [ -L "$link" ] && [ ! -e "$link" ]; then
    line verwaist "$(basename "$link")" "zeigt ins Leere ($(readlink "$link")), nicht geloescht"
    problems=$((problems + 1))
  fi
done

if [ $created -gt 0 ]; then
  echo "$created Link(s) angelegt. Claude Code neu starten, damit die Skills geladen werden."
fi
[ $problems -eq 0 ] || exit 1
