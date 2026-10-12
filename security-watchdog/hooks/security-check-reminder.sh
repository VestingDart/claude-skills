#!/usr/bin/env bash
# PostToolUse-Hook (Write|Edit): erinnert einmal pro Session daran, den Skill
# security-watchdog auf sicherheitsrelevant geaenderten Code anzuwenden.
# Haelt sich absichtlich kurz: nur ein Hinweis pro Session, nur bei passenden Dateitypen.

input=$(cat)
file=$(printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_response.filePath // empty' 2>/dev/null)
session=$(printf '%s' "$input" | jq -r '.session_id // "nosession"' 2>/dev/null)

[ -z "$file" ] && exit 0

case "$file" in
  *.java|*.kt|*.js|*.mjs|*.cjs|*.ts|*.tsx|*.jsx|*.py|*.php|*.sql|*.sh|*.fish \
  |*.yml|*.yaml|*.conf|*.env|*.service|*.timer|*.properties|*.toml|*.ini \
  |*Dockerfile|*docker-compose*|*nginx*|*sshd_config*) ;;
  *) exit 0 ;;
esac

marker="/tmp/claude-secwatch-${session}"
[ -e "$marker" ] && exit 0
: > "$marker"

ctx="In dieser Session wurde sicherheitsrelevanter Code oder Config geaendert (${file}). "
ctx+="Wende vor dem Abschluss der Aufgabe den Skill security-watchdog auf die Aenderungen an: "
ctx+="Eingabepfade pruefen, Auth und Permissions, DB-Queries, Secrets. "
ctx+="Ist nichts davon sicherheitsrelevant, einfach weiterarbeiten und nichts melden."

jq -n --arg c "$ctx" \
  '{hookSpecificOutput:{hookEventName:"PostToolUse",additionalContext:$c}}'
