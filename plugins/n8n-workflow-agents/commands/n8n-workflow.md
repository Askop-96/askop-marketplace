---
name: n8n-workflow
description: Criar um workflow n8n completo usando o framework de subagentes especializados
argument-hint: "<descrição do workflow> [--ralph] [--max-iterations N]"
allowed-tools:
  - Task
  - Read
  - Write
  - Glob
  - Bash
  - TodoWrite
  - AskUserQuestion
  - mcp__MCP_DOCKER__n8n_health_check
  - mcp__MCP_DOCKER__n8n_diagnostic
---

# /n8n-workflow - Criar Workflow n8n

Este comando inicia o processo de criação de um workflow n8n usando o framework de subagentes especializados.

## Uso

```bash
/n8n-workflow "Descrição do que o workflow deve fazer"
/n8n-workflow "Descrição" --ralph --max-iterations 20
```

## Argumentos

- **descrição**: O que o workflow deve fazer (obrigatório)
- **--ralph**: Usar Ralph Loop para execução iterativa até completar
- **--max-iterations N**: Número máximo de iterações (default: 20)

## Fluxo de Execução

### 1. Verificação Inicial
Verifique se o n8n está conectado e configurado:

```!
# Verificar saúde do n8n
```

Execute `n8n_health_check()` e `n8n_diagnostic()` para verificar conectividade.

### 2. Criar Sessão
Crie a pasta de sessão para comunicação entre agentes:

```!
mkdir -p .n8n-session
```

### 3. Salvar Contexto
Salve os requisitos do usuário:

```json
// .n8n-session/context.json
{
  "createdAt": "[timestamp]",
  "userRequest": "[descrição do usuário]",
  "useRalph": [true/false],
  "maxIterations": [N]
}
```

### 4. Analisar Complexidade

Determine a complexidade baseado na descrição:
- **Simples** (< 5 nodes): Webhook, Set, uma integração
- **Médio** (5-15 nodes): Múltiplas integrações, condições
- **Complexo** (> 15 nodes ou AI): AI Agents, múltiplos fluxos

### 5. Acionar Orchestrator

Lance o agente n8n-orchestrator para coordenar todo o processo:

```
Task(subagent_type: "n8n-orchestrator", prompt: "...")
```

O Orchestrator vai:
1. Acionar Architect (se médio/complexo)
2. Acionar Node-Discoverer
3. Acionar Configurator (se médio/complexo)
4. Acionar AI-Specialist (se envolve AI)
5. Acionar Builder (pede confirmação)
6. Acionar Validator
7. Acionar Fixer (se erros)
8. Retornar resultado

### 6. Integração Ralph Loop

Se `--ralph` foi passado, o workflow executa em loop:

```bash
# O prompt será repetido até completion promise
# Claude verá trabalho anterior em .n8n-session/
# Output <promise>WORKFLOW_COMPLETE</promise> quando pronto
```

### 7. Resultado Final

Após sucesso, exiba:
- ID do workflow criado
- Nome do workflow
- Quantidade de nodes
- Link para o n8n (se disponível)
- Instruções para ativar/testar

## Completion Promises (Ralph Loop)

| Situação | Promise |
|----------|---------|
| Workflow completo e validado | `WORKFLOW_COMPLETE` |
| Bloqueado, precisa ajuda | `BLOCKED_NEEDS_HELP` |

## Exemplos

### Simples
```bash
/n8n-workflow "Webhook que envia mensagem para Slack"
```

### Com Ralph Loop
```bash
/n8n-workflow "API REST completa com autenticação e banco de dados" --ralph --max-iterations 30
```

### AI Agent
```bash
/n8n-workflow "Chatbot inteligente que responde perguntas sobre documentos"
```

## Arquivos de Sessão

Após execução, a pasta `.n8n-session/` conterá:

```
.n8n-session/
├── context.json           # Requisitos originais
├── workflow-plan.md       # Plano do Architect
├── nodes-discovered.json  # Nodes e configurações
├── workflow-id.txt        # ID do workflow criado
├── validation-result.json # Resultado da validação
├── checkpoint.json        # Estado para continuação
└── execution-log.md       # Log de todas as ações
```

## Tratamento de Erros

- Se n8n não conectado: Exibe instruções de configuração
- Se validação falha: Aciona Fixer automaticamente
- Se Fixer falha após 3 tentativas: Pede ajuda ao usuário
- Se Ralph Loop excede iterações: Documenta progresso e para

## Responda em português brasileiro.
