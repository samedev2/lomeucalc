# Installs LomeuCalc (skill + embedded agents) into this machine's personal
# Claude Code config. Safe to re-run -- it just overwrites with the repo's
# current version.
$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillSrc = Join-Path $ScriptDir "lomeucalc"
$SkillDest = Join-Path $HOME ".claude\skills\lomeucalc"
$AgentsDest = Join-Path $HOME ".claude\agents"

if (-not (Test-Path $SkillSrc)) {
    Write-Error "Expected to find a 'lomeucalc' folder next to this script (at $SkillSrc)."
    exit 1
}

$AgentsExisted = Test-Path $AgentsDest

New-Item -ItemType Directory -Force -Path $SkillDest | Out-Null
New-Item -ItemType Directory -Force -Path $AgentsDest | Out-Null

# Copy everything in lomeucalc/ except the agents/ folder, which holds
# reference copies for version control, not the functional skill files.
Get-ChildItem -Path $SkillSrc | Where-Object { $_.Name -ne "agents" } | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination $SkillDest -Recurse -Force
}

# Copy the functional agent definitions to the location Claude Code
# actually scans for personal subagents.
Copy-Item -Path (Join-Path $SkillSrc "agents\lomeucalc-triangulador.md") -Destination $AgentsDest -Force
Copy-Item -Path (Join-Path $SkillSrc "agents\lomeucalc-auditor-integridade.md") -Destination $AgentsDest -Force

Write-Host "LomeuCalc installed:"
Write-Host "  Skill  -> $SkillDest"
Write-Host "  Agents -> $AgentsDest (lomeucalc-triangulador, lomeucalc-auditor-integridade)"
Write-Host ""
if (-not $AgentsExisted) {
    Write-Host "Note: ~/.claude/agents/ did not exist before this install -- restart your"
    Write-Host "Claude Code session so the new agents are picked up."
}
