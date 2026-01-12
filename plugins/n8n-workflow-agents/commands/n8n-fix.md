---
name: n8n-fix
description: Corrigir erros em um workflow n8n
argument-hint: "<workflow-id>"
allowed-tools:
  - Task
  - Read
  - Write
  - mcp__MCP_DOCKER__n8n_get_workflow
  - mcp__MCP_DOCKER__n8n_autofix_workflow
  - mcp__MCP_DOCKER__n8n_update_partial_workflow
---

# /n8n-fix - Corrigir Workflow n8n

Este comando corrige erros em um workflow n8n existente, aplicando correções automáticas e manuais.

## Uso

```bash
/n8n-fix <workflow-id>
```

## Argumentos

- **workflow-id**: ID do workflow no n8n (obrigatório)

## Fluxo de Execução

### 1. Verificar Validação Anterior

Se existe `.n8n-session/validation-result.json`:
- Use os erros já identificados

Se não existe:
- Execute validação primeiro

### 2. Acionar Fixer

Lance o agente n8n-fixer:

```
Task(subagent_type: "n8n-fixer", prompt: "Corrija o workflow ID <workflow-id>")
```

O Fixer vai:
1. Aplicar autofix para erros comuns
2. Aplicar correções manuais
3. Limpar conexões órfãs
4. Documentar correções

### 3. Re-validar

Após correções, execute validação novamente para confirmar.

### 4. Resultado

**Se corrigido com sucesso:**
```
✅ Workflow corrigido!

- ID: <id>
- Autofix aplicados: <X>
- Correções manuais: <Y>
- Conexões limpas: <Z>

O workflow agora está válido.
```

**Se correção parcial:**
```
⚠️ Correções parciais aplicadas

- Corrigidos: <X> erros
- Restantes: <Y> erros

Erros que precisam de intervenção manual:
1. [erro]: [descrição]
2. ...
```

## Tipos de Correção

### Automáticas (autofix)
- Formato de expressões
- TypeVersion incorreto
- Error output config
- Webhook path faltando

### Manuais
- Campos obrigatórios faltando
- Conexões inválidas
- Configurações específicas

## Limite de Tentativas

Máximo 3 tentativas de correção por sessão.

## Exemplos

```bash
/n8n-fix abc123
/n8n-fix "meu-workflow-id"
```

## Responda em português brasileiro.
