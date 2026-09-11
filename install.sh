#!/usr/bin/env bash
# Installs LomeuCalc (skill + embedded agents) into this machine's personal
# Claude Code config. Safe to re-run — it just overwrites with the repo's
# current version.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_SRC="$SCRIPT_DIR/lomeucalc"
SKILL_DEST="$HOME/.claude/skills/lomeucalc"
AGENTS_DEST="$HOME/.claude/agents"

if [ ! -d "$SKILL_SRC" ]; then
  echo "Error: expected to find a 'lomeucalc' folder next to this script (at $SKILL_SRC)." >&2
  exit 1
fi

AGENTS_EXISTED=true
if [ ! -d "$AGENTS_DEST" ]; then
  AGENTS_EXISTED=false
fi

mkdir -p "$SKILL_DEST" "$AGENTS_DEST"

# Copy everything in lomeucalc/ except the agents/ folder, which holds
# reference copies for version control, not the functional skill files.
for item in "$SKILL_SRC"/*; do
  name="$(basename "$item")"
  if [ "$name" != "agents" ]; then
    cp -r "$item" "$SKILL_DEST/"
  fi
done

# Copy the functional agent definitions to the location Claude Code
# actually scans for personal subagents.
cp "$SKILL_SRC/agents/lomeucalc-triangulador.md" "$AGENTS_DEST/"
cp "$SKILL_SRC/agents/lomeucalc-auditor-integridade.md" "$AGENTS_DEST/"

echo "LomeuCalc installed:"
echo "  Skill  -> $SKILL_DEST"
echo "  Agents -> $AGENTS_DEST (lomeucalc-triangulador, lomeucalc-auditor-integridade)"
echo ""
if [ "$AGENTS_EXISTED" = false ]; then
  echo "Note: ~/.claude/agents/ did not exist before this install — restart your"
  echo "Claude Code session so the new agents are picked up."
fi
