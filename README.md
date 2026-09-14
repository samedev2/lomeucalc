# lomeucalc

Skill para [Claude Code](https://claude.com/claude-code) feita para **indicadores, dashboards e sistemas de telemetria de dados** — ativa um modo de análise hiper objetivo e decisivo, token-econômico, sem rodeio, sem pesquisa desnecessária, sem inventar número para preencher lacuna.

Aplicação primária: leitura de KPI/dashboard com definição travada de numerador/denominador/período, frescor do dado (staleness), classificação contra limiar (dentro do range / atenção / crítico) e detecção rápida de anomalia — tudo isso apoiado em 3 sistemas de domínio (Financeiro, Dados, Telemetria), um protocolo de escalação para análise profunda quando os sinais exigem ("Modo Bruto"), um mandato de integridade que proíbe alucinar dado ausente, e um protocolo de checkpoint para análises longas não perderem o escopo original pelo caminho. Detalhes completos em [lomeucalc/SKILL.md](lomeucalc/SKILL.md).

Inclui 2 subagentes embutidos que a skill aciona nos pontos certos do fluxo:
- **`lomeucalc-triangulador`** — confirma um número por pelo menos 2 fontes independentes antes de reportá-lo como fato.
- **`lomeucalc-auditor-integridade`** — roda o checklist de confiabilidade de dado (Completude/Consistência/Amostra) e audita checkpoints.

## Instalar em uma máquina

```bash
git clone https://github.com/samedev2/lomeucalc.git
cd lomeucalc
./install.sh
```

No Windows, via PowerShell:

```powershell
git clone https://github.com/samedev2/lomeucalc.git
cd lomeucalc
.\install.ps1
```

O script copia a skill para `~/.claude/skills/lomeucalc/` e os 2 agentes para `~/.claude/agents/` — os locais pessoais que o Claude Code lê automaticamente em qualquer projeto, nesta máquina. Repita o clone + script em qualquer outra máquina onde quiser a mesma skill disponível. Reexecutar é seguro: só sobrescreve com a versão atual do repo.

Se `~/.claude/agents/` não existia antes da instalação, reinicie a sessão do Claude Code para os agentes aparecerem na lista de agentes disponíveis.

## Estrutura

```
lomeucalc/
├── SKILL.md              # a skill em si
└── agents/                # cópias versionadas dos 2 agentes (ver agents/README.md)
    ├── lomeucalc-triangulador.md
    └── lomeucalc-auditor-integridade.md
install.sh                 # instalador para macOS/Linux/Git Bash
install.ps1                # instalador para PowerShell (Windows nativo)
```
