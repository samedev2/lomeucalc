# Agentes embutidos da LomeuCalc

Cópias versionadas dos 2 subagentes que a skill referencia (`lomeucalc-triangulador` e `lomeucalc-auditor-integridade`). Estão aqui só para controle de versão junto com a skill.

A cópia **funcional** — a que o Claude Code realmente descobre e usa via `Agent` tool — precisa estar em `~/.claude/agents/`, fora deste repositório. Depois de editar um arquivo aqui, copie de volta:

```bash
cp agents/lomeucalc-triangulador.md ~/.claude/agents/
cp agents/lomeucalc-auditor-integridade.md ~/.claude/agents/
```
