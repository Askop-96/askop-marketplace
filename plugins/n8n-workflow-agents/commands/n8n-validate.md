---
name: n8n-validate
description: Validar um workflow n8n existente
argument-hint: "<workflow-id>"
allowed-tools:
  - Task
  - Read
  - Write
  - mcp__MCP_DOCKER__n8n_get_workflow
  - mcp__MCP_DOCKER__validate_workflow
  - mcp__MCP_DOCKER__n8n_validate_workflow
---

# /n8n-validate - Validar Workflow n8n

Este comando valida um workflow n8n existente, identificando erros, warnings e sugestões de melhoria.

## Uso

```bash
/n8n-validate <workflow-id>
```

## Argumentos

- **workflow-id**: ID do workflow no n8n (obrigatório)

## Fluxo de Execução

### 1. Obter Workflow
```
n8n_get_workflow({id: "<workflow-id>"})
```

### 2. Acionar Validator

Lance o agente n8n-validator:

```
Task(subagent_type: "n8n-validator", prompt: "Valide o workflow ID <workflow-id>")
```

O Validator vai:
1. Executar validação de estrutura
2. Executar validação de expressões
3. Executar validação completa
4. Categorizar problemas
5. Identificar false positives
6. Sugerir correções

### 3. Resultado

Exiba o resultado da validação:

**Se válido:**
```
✅ Workflow válido!

- ID: <id>
- Nome: <nome>
- Nodes: <quantidade>
- Erros: 0
- Warnings: <X>
- Sugestões: <Y>
```

**Se com erros:**
```
❌ Workflow com problemas!

- ID: <id>
- Erros: <X> (bloqueantes)
- Warnings: <Y>

Erros encontrados:
1. [Node]: [descrição] - Fix: [sugestão]
2. ...

Use /n8n-fix <id> para corrigir automaticamente.
```

## Níveis de Validação Executados

1. **Estrutura**: Conexões, ciclos, triggers
2. **Expressões**: Sintaxe {{}}
3. **Nodes**: Configurações
4. **Online**: Validação no n8n

## Exemplos

```bash
/n8n-validate abc123
/n8n-validate "meu-workflow-id"
```

## Responda em português brasileiro.
