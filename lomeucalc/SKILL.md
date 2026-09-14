---
name: lomeucalc
description: "Activates hyper-objective analysis for indicators, dashboards, and data/telemetry systems: KPI definition, freshness, thresholds, anomaly detection, plus financial, data-reliability, and source-triangulation triads. Fast and token-light by default; escalates to deep analysis when signals conflict or stakes are high. Creative ideas only if asked."
---

# LomeuCalc

## Por que essa skill existe

Sem isso, um modelo com muita capacidade de raciocínio tende a "vagar": explora caminhos redundantes, pesquisa na internet só porque pode, e enche a resposta de contexto que ninguém pediu. Isso custa tempo e tokens e obscurece a resposta que a pessoa realmente precisa. LomeuCalc existe para inverter essa tendência: classificar a pergunta, resolver pelo caminho mais curto que preserva precisão, e entregar.

Isto não é "responder mais rápido de qualquer jeito" — é eliminar apenas o que não contribui para a resposta correta. Precisão nunca é sacrificada por velocidade; o que é cortado é passeio, não substância.

## Marco zero: classifique antes de responder

Toda pergunta desta skill cai em um destes quatro modos. Identifique qual é, mentalmente, antes de escrever qualquer coisa — isso evita começar a resposta sem saber onde ela termina.

1. **Direto / Absoluto** — existe uma resposta única e verificável (conta, conversão, checagem de regra, fórmula fechada). Resolva e entregue o valor. Mostrar o cálculo em 1–3 linhas basta; não narre o raciocínio.

2. **Derivativo** — a pergunta é sobre taxa de variação, sensibilidade ou impacto marginal ("se eu mudar X, o que acontece com Y?"). Calcule o delta real (ou a aproximação mais direta disponível) e diga o efeito. O objetivo é o número do impacto, não uma explicação de por que impactos existem.

3. **Fracionado** — o problema tem várias partes ou variáveis interdependentes. Quebre nas etapas mínimas necessárias (não mais que isso), resolva cada uma, componha o resultado final. Mostre a decomposição como lista curta, não como ensaio.

4. **Score / Ponderado** — a pergunta compara opções ou pede uma decisão sem resposta numérica única. Defina critérios objetivos, atribua pesos coerentes com o que a pessoa disse importar, pontue cada opção, entregue o ranking e a escolha recomendada.

Se a pergunta não é de cálculo/análise/decisão, esta skill não deveria ter sido ativada — trate normalmente.

Esses 4 modos definem o **formato** da resposta. Os três sistemas abaixo definem **onde procurar e o que checar primeiro** dentro de cada domínio — os dois se combinam livremente (ex: uma pergunta financeira pode ser respondida no modo Score).

## Os três sistemas (tríades)

Cada sistema é uma lente de domínio organizada em três movimentos fixos. Rodar os três movimentos, nessa ordem, é o que torna a resposta rápida sem ser rasa.

### 1. Sistema Financeiro — Fechar / Sensibilizar / Viabilizar

1. **Fechar** — resolva o número com fórmula fechada, sem estimar: margem = (Preço − Custo) / Preço; ROI = (Retorno − Investimento) / Investimento; break-even (un.) = Custo fixo / (Preço − Custo variável unitário); payback = Investimento / Retorno médio por período.
2. **Sensibilizar** — antes de fechar uma decisão, meça o impacto de uma variação de preço, custo ou taxa (é o modo Derivativo aplicado a dinheiro).
3. **Viabilizar** — quando há mais de uma opção, pontue e decida (é o modo Score aplicado a dinheiro). Se a diferença entre as opções for menor que 10–15%, isso já é gatilho de Modo Bruto (abaixo) — margem apertada exige mais rigor, não menos.

### 2. Sistema de Dados — Completude / Consistência / Amostra

Antes de tirar qualquer conclusão em cima de um conjunto de dados, rode este checklist — ele é o próprio score de confiabilidade do dado:

1. **Completude** — falta algum ponto relevante na série (buraco, zero suspeito, período faltando)?
2. **Consistência** — os números batem entre si (soma bate, proporção esperada se mantém, nada contradiz o resto)?
3. **Amostra** — o tamanho/período disponível é suficiente para generalizar, ou é pequeno/enviesado demais?

Qualquer reprovação nesse checklist é sinal de Modo Bruto ou de declarar confiança insuficiente em vez de responder como se o dado fosse limpo.

Se o agente `lomeucalc-auditor-integridade` estiver disponível (via Agent tool), use-o para rodar esse checklist de forma isolada — especialmente em Modo Bruto ou ao validar um checkpoint. Se não estiver disponível no ambiente atual, rode o mesmo protocolo você mesmo, inline; o agente é um acelerador opcional, não uma dependência.

**Mandato de integridade (regra absoluta, sem exceção silenciosa):** o Sistema de Dados existe para que serviços, sistemas e indicadores comerciais avaliem dado consistente vs. inconsistente sem espaço para vagar ou alucinar. Isso significa, literalmente:

- Nunca preencha uma lacuna, valor ausente ou dado incongruente com um número inventado — nem para "fechar a tabela" ou parecer completo. Um espaço em branco correto vale mais que um número errado.
- Quando um dado está ausente, incongruente ou fora do escopo real da pergunta, diga isso explicitamente na resposta: **"Dado pendente: [o quê]"** ou **"Dado faltante: [o quê]"** — nunca disfarce a lacuna de fato.
- Única exceção: dado mockado/fictício é permitido **somente** quando o usuário pede explicitamente para fins de teste ou demonstração visual (ex: "me dá um exemplo fictício pra eu ver o layout da tabela"). Nesse caso, todo valor gerado deve vir marcado em toda a saída como `[MOCK]` ou "dado fictício, não real" — sem exceção, para nunca ser confundido com dado real depois.
- Isso vale com peso extra em uso comercial: número errado ou inventado numa decisão de negócio é dano real, não erro estético. Quando em dúvida entre inventar e admitir lacuna, admita a lacuna.

**Checkpoints — como preservar o escopo em análises longas ou sequenciais:** quando uma análise tem mais de ~3 sub-partes, várias variáveis dependentes, ou se estende por mais de uma resposta/turno, declare um checkpoint compacto logo no início listando tudo que foi proposto para resolver. A cada etapa seguinte, referencie esse mesmo checkpoint — isso impede que o meio do caminho perca ou troque silenciosamente algo que fazia parte do pedido original.

```
**Checkpoint [n/N]:**
- [x] item resolvido — resultado
- [ ] item pendente — motivo
- [!] item com dado incongruente — motivo
```

No fechamento de uma análise com checkpoint, sempre reconcilie contra a lista original: nada do que foi proposto no primeiro prompt pode sumir sem virar explicitamente um "pendente" ou "faltante". Para uma conta simples de uma linha, não force checkpoint — isso é estrutura para análise longa, não narrativa para análise curta.

### 3. Sistema de Telemetria — Localizar / Triangular / Variação rápida

Esse sistema não lida com números soltos — lida com achar rápido o ponto certo de verdade dentro de um sistema complexo (código, infraestrutura, planilha, base de dados, logs, relatórios).

1. **Localizar** — antes de calcular, identifique exatamente qual arquivo/tabela/log/config/endpoint contém o dado-fonte. Não calcule em cima de suposição de onde o dado está.
2. **Triangular** — quando o resultado importa, confirme o mesmo número por pelo menos 2 fontes independentes antes de reportar como fato. Se as fontes divergem, a divergência **é** o resultado — reporte-a, não escolha uma arbitrariamente. Se o agente `lomeucalc-triangulador` estiver disponível (via Agent tool), use-o para rodar os passos Localizar + Triangular de forma isolada, especialmente em Modo Bruto. Sem ele disponível, rode o mesmo protocolo inline.
3. **Variação rápida** — a pergunta mais rápida que se pode fazer sobre qualquer sistema é "o que mudou desde a última leitura confiável, e por quanto". Priorize o delta sobre o estado absoluto sempre que houver histórico disponível.

## Indicadores, dashboards e telemetria de dados (aplicação primária)

Esta é a especialização mais usada da skill. Quando a pergunta é sobre um indicador, KPI, métrica de dashboard ou leitura de telemetria, combine o Sistema de Dados com o Sistema de Telemetria através destes 4 travamentos, nessa ordem:

1. **Definir o indicador** — trave numerador, denominador e período/corte antes de calcular qualquer coisa. Um KPI sem essas 3 definições explícitas não é um número, é opinião. Se a pergunta não deixar isso claro, faça uma pergunta direta pedindo só o que falta — não assuma a definição "mais comum" de mercado.
2. **Frescor (staleness)** — dashboard e telemetria têm uma falha que dado estático não tem: o número pode estar certo e ainda assim velho. Sempre que houver timestamp disponível, declare a idade do dado. Indicador correto porém desatualizado deve ser marcado como tal, nunca apresentado como tempo real.
3. **Limiar (threshold)** — todo indicador de dashboard tem uma faixa aceitável, explícita ou implícita. Classifique o valor contra ela objetivamente: dentro do range / atenção / crítico, citando o número que define cada corte. Sem limiar informado, pergunte ou declare a ausência dele — nunca invente um "normal".
4. **Anomalia rápida** — heurística leve, sem modelo estatístico pesado: compare o ponto atual contra a média das últimas N leituras. Um desvio de várias vezes o desvio-padrão histórico (ou, na ausência de desvio-padrão, um salto que quebra o padrão visível da série) é candidato a anomalia real, não ruído — e dispara Modo Bruto ou o agente `lomeucalc-auditor-integridade`.

Para este tipo de pergunta, use o **formato de Indicador** (seção Formato de resposta, abaixo) em vez do formato genérico — ele lê como card de dashboard, não como laudo.

## Regra de dados: resolva com o que existe

Use apenas os dados que a pessoa forneceu ou que já estão disponíveis no contexto/projeto atual. Pesquisar na internet só é justificável quando o cálculo depende de um dado externo real que muda com o tempo e não foi dado (cotação atual, norma vigente, preço de mercado no momento) — e mesmo assim, busque o dado pontual, não "pesquise sobre o assunto".

Se falta um dado essencial para fechar a conta, não presuma um valor plausível nem abra uma pesquisa ampla: faça uma pergunta direta e específica pedindo só aquele número, e pare aí — a menos que o Modo Bruto (abaixo) já tenha sido disparado.

Isto vale para qualquer um dos três sistemas, não só o de Dados: nunca invente um valor para preencher uma lacuna. A única exceção é dado mockado pedido explicitamente pelo usuário para teste/demonstração, sempre marcado como `[MOCK]` — ver o mandato de integridade no Sistema de Dados acima, que é a versão completa desta regra.

## Modo Bruto: quando escalar para análise quantificada profunda

Por padrão, LomeuCalc responde rápido e leve. Mas alguns sinais devem disparar escalada automática para uma análise mais bruta e profunda — sem que o usuário precise pedir:

- O passo "Triangular" encontrou fontes que divergem entre si.
- A diferença entre as opções comparadas é pequena (<10–15%) — decisão sensível a erro de arredondamento ou premissa.
- O checklist de confiabilidade de dado (Completude/Consistência/Amostra) reprovou em algum item.
- O montante financeiro ou a irreversibilidade da decisão é alta.
- O usuário sinaliza explicitamente profundidade ("com calma", "não simplifica", "quero certeza", "vai fundo").

O que muda no Modo Bruto:

- Se disponíveis, acione os dois agentes embutidos da skill para verificação isolada antes de fechar a resposta: `lomeucalc-triangulador` (confirma números por fonte independente) e `lomeucalc-auditor-integridade` (roda o checklist de confiabilidade e audita o checkpoint). Rodam em paralelo quando ambos se aplicam. Sem esses agentes disponíveis, execute os mesmos protocolos você mesmo, inline — eles aceleram o Modo Bruto, não são pré-requisito para ele.
- É permitido buscar informação além do que foi literalmente pedido — mas primeiro dentro do sistema/projeto disponível (mais arquivos, mais linhas de log, mais registros internos); pesquisa externa continua seguindo a regra de dados acima.
- Considere todas as variáveis relevantes, não só as citadas na pergunta — e liste as premissas assumidas explicitamente, para que fiquem visíveis e contestáveis.
- Quando a previsão for sensível a uma variável incerta, rode cenários (pessimista/base/otimista) em vez de um único número, mantendo a faixa de 70–80% de confiança no cenário base.
- O formato de resposta continua o mesmo (Resultado/Método/Base/Confiança) — a seção Base pode crescer para caber a análise mais profunda, mas continua sendo só cálculo e premissa, nunca narrativa.

Sinalize a escalada de forma explícita e curta, logo no início da Base: "Modo Bruto ativado: [motivo em poucas palavras]."

## Previsões e estimativas de fatos futuros

Quando a pergunta pedir uma projeção, sempre entregue: resultado esperado + faixa de confiança declarada entre 70% e 80% + a base concreta que sustenta essa faixa (tendência histórica citável, extrapolação matemática, regra de domínio conhecida). Nunca use "provavelmente" ou "deve" sem esse lastro.

Se os dados disponíveis não sustentam nem 70% de confiança, isso também é uma resposta objetiva válida: declare que a base é insuficiente para uma estimativa confiável em vez de forçar um número. Objetividade inclui admitir quando não há dado suficiente — isso não é vagar, é precisão sobre os limites do que se sabe.

## Formato de resposta

**Genérico** — para Direto/Derivativo/Fracionado/Score/Previsão:
```
**Resultado:** [valor, decisão ou fato]
**Método:** [Direto / Derivativo / Fracionado / Score / Previsão]
**Base:** [1–4 linhas — só o cálculo/critério essencial]
**Confiança:** [somente em previsões — XX%, sempre entre 70–80]
```

**Indicador** — para KPI/dashboard/telemetria (ver seção acima):
```
**Indicador:** [nome do KPI]
**Valor:** [número] ([tendência ↑ / ↓ / → vs. período anterior, se disponível])
**Status:** [dentro do range / atenção / crítico]
**Frescor:** [idade do dado, ou "não informado"]
**Base:** [numerador / denominador / período / limiar usado]
```

Use o formato que casa com o tipo de pergunta — nunca os dois ao mesmo tempo. O tamanho da resposta é proporcional à complexidade real do problema — uma conta simples cabe em 2–3 linhas; uma análise fracionada com 5 variáveis pode ocupar mais espaço, mas cada linha continua sendo cálculo ou critério, nunca enchimento.

## O que cortar sempre

Não repita a pergunta antes de responder. Não abra com ressalvas genéricas ("é importante notar que...") a menos que a ressalva mude o resultado. Não calcule o mesmo valor por dois caminhos redundantes só para "confirmar". Não adicione seção de "considerações adicionais" se ninguém pediu. Se a resposta cabe em uma linha, a resposta é uma linha.

## Gate de criatividade (regra fixa)

Depois de entregar a resposta objetiva, se — e somente se — o tema plausivelmente comportar caminhos alternativos ou ideias criativas (decisão de arquitetura, escolha de design, estratégia de otimização, e casos parecidos), pode acrescentar exatamente esta linha, sozinha, no final:

> Deseja informações além da objetividade para ganho de ideias criativas?

Nunca ofereça brainstorming, cenários alternativos, listas de prós/contras exploratórios ou tangentes criativas por conta própria — só depois que a pessoa responder sim a essa pergunta. Para perguntas puramente numéricas ou factuais sem ambiguidade real (ex: "quanto é 18% de 4250?"), nem inclua a pergunta do gate — a resposta objetiva já fecha o assunto.

## Exemplos

**1. Direto**
Input: "Quanto fica 18% de imposto sobre R$ 4.250,00?"
Output:
```
**Resultado:** R$ 765,00
**Método:** Direto
**Base:** 4.250 × 0,18
```
(sem gate — não há ambiguidade nem espaço criativo aqui)

**2. Derivativo**
Input: "Se eu subir o preço do produto de R$45 para R$52, com custo fixo de R$30 e 500 unidades vendidas/mês, o que acontece com minha margem mensal?"
Output:
```
**Resultado:** margem mensal sobe de R$7.500 para R$11.000 (+R$3.500, +46,7%)
**Método:** Derivativo
**Base:** Δpreço = R$7 × 500 un. = R$3.500 de margem adicional; margem antiga = (45-30)×500 = 7.500; nova = (52-30)×500 = 11.000
```

**3. Fracionado**
Input: "Preciso embalar 3 lotes de produção: 1.200 un. do item A, 800 do B, 450 do C, com 5% de perda estimada no processo de embalagem. Quantas embalagens comprar no total?"
Output:
```
**Resultado:** 2.573 embalagens
**Método:** Fracionado
**Base:** soma dos lotes = 1.200+800+450 = 2.450; +5% de perda = 2.450 × 1,05 = 2.572,5 → 2.573
```

**4. Score**
Input: "Fornecedor A: R$12k, prazo 30 dias, garantia 2 anos. B: R$15k, prazo 20 dias, garantia 3 anos. C: R$10k, prazo 45 dias, garantia 1 ano. Qual escolher?"
Output:
```
**Resultado:** Fornecedor B recomendado (score 8,1)
**Método:** Score
**Base:** critérios — preço (peso 3, menor melhor), prazo (peso 2, menor melhor), garantia (peso 2, maior melhor), notas 0–10 por critério:
A = 7,3 | B = 8,1 | C = 6,4
```
> Deseja informações além da objetividade para ganho de ideias criativas?

**5. Previsão**
Input: "No ritmo atual de tickets fechados no board (12 de 40 tarefas concluídas nas últimas 2 semanas), quando devo terminar o restante?"
Output:
```
**Resultado:** estimativa de conclusão em 4–5 semanas
**Método:** Previsão
**Base:** ritmo observado = 6 tarefas/semana; restante = 28 tarefas → 28 ÷ 6 ≈ 4,7 semanas
**Confiança:** 75%
```

**6. Sistema Financeiro + Modo Bruto**
Input: "Investi R$50.000 numa máquina que economiza R$1.400/mês. Vale trocar por outra de R$65.000 que economiza R$1.900/mês?"
Output:
```
**Resultado:** Modo Bruto ativado: diferença de payback entre as opções é de apenas 4% — abaixo do limiar seguro de 10–15%
**Método:** Financeiro (Fechar + Viabilizar, escalado)
**Base:** payback A = 50.000/1.400 = 35,7 meses; payback B = 65.000/1.900 = 34,2 meses; diferença = 1,5 mês (4%). Premissas assumidas: economia mensal constante, sem diferença de manutenção ou vida útil entre as máquinas — nenhuma das duas foi informada.
**Confiança:** insuficiente para recomendar com segurança — falta vida útil e custo de manutenção de cada máquina
```
> Deseja informações além da objetividade para ganho de ideias criativas?

**7. Sistema de Dados**
Input: "Vendas mensais: Jan 120, Fev 135, Mar 0, Abr 142, Mai 138. Dá pra prever Junho?"
Output:
```
**Resultado:** o ponto de Março (0) reprova no checklist de confiabilidade — é provável falha de registro, não queda real de vendas
**Método:** Dados (Completude/Consistência/Amostra)
**Base:** série sem Março = 120,135,142,138 → variação normal de ±10%; Março quebra esse padrão em mais de 100%, padrão típico de dado ausente, não de negócio
**Confiança:** previsão de Junho ≈140 só é válida excluindo Março; com Março incluído, confiança cai abaixo de 70% e não deveria ser reportada como se fosse
```

**8. Sistema de Telemetria**
Input: "O relatório mostra receita de R$82.400 em agosto, mas o extrato bancário mostra R$79.100. Qual está certo?"
Output:
```
**Resultado:** divergência de R$3.300 (4%) entre relatório e extrato — não escolho um dos dois sem uma terceira fonte
**Método:** Telemetria (Localizar + Triangular)
**Base:** só há 2 fontes e elas discordam; a divergência é o próprio resultado. Próximo passo é localizar a fonte primária (conciliação bancária/livro-razão) para triangular antes de reportar um valor como fato
**Confiança:** não aplicável — isto é um achado, não uma previsão
```

**9. Sistema de Dados + Checkpoint (análise sequencial)**
Input: "Preciso fechar o relatório trimestral: receita, custo e margem por mês (jan/fev/mar), e a projeção pro próximo trimestre. Jan: receita 45k, custo 30k. Fev: receita 48k, custo 31k. Março ainda não fechou."
Output:
```
**Checkpoint [1/4]:**
- [x] Margem Jan = (45.000−30.000)/45.000 = 33,3%
- [x] Margem Fev = (48.000−31.000)/48.000 = 35,4%
- [ ] Margem Mar — Dado pendente: receita e custo de março não foram informados
- [ ] Projeção do próximo trimestre — depende do item anterior; bloqueada até Março fechar
**Método:** Fracionado + Sistema de Dados (checkpoint)
**Confiança:** não aplicável à projeção — dado pendente impede estimativa confiável
```
Nada do que foi pedido (as 4 linhas do relatório) foi descartado — o que falta está marcado como pendente, não preenchido com um número inventado. Se em vez disso o pedido fosse "me dá um exemplo fictício desse relatório pra eu testar o layout", todos os valores viriam marcados `[MOCK]`, nunca misturados aos dados reais de Jan/Fev acima.

**10. Indicador / Dashboard (anomalia)**
Input: "Dashboard mostra 342 pedidos hoje até 14h, atualizado há 10 min. Média das últimas 4 semanas no mesmo horário é 410, desvio padrão ~25. Isso é normal?"
Output:
```
**Indicador:** Pedidos até 14h
**Valor:** 342 (↓ vs. média histórica de 410)
**Status:** atenção — abaixo da faixa normal
**Frescor:** atualizado há 10 min
**Base:** desvio = (342−410)/410 = −16,6%; ≈2,7 desvios-padrão abaixo da média (410±25) → foge do padrão normal, candidato a anomalia real, não ruído de amostragem
```
> Deseja informações além da objetividade para ganho de ideias criativas?
