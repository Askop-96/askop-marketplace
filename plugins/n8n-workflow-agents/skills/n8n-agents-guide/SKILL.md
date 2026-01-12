---
name: n8n-agents-guide
description: |
  Guia completo de uso do framework de subagentes n8n. Use esta skill quando precisar entender como os agentes funcionam, quando usar cada um, ou como customizar o framework.
version: 1.0.0
---

# Guia do Framework de Subagentes n8n

Este framework fornece 8 agentes especializados para criar, validar e corrigir workflows n8n com separação máxima de contexto.

## Comandos Disponíveis

| Comando | Descrição |
|---------|-----------|
| `/n8n-workflow <desc>` | Criar um workflow n8n completo |
| `/n8n-validate <id>` | Validar workflow existente |
| `/n8n-fix <id>` | Corrigir erros em workflow |

## Os 8 Agentes Especializados

### 1. Orchestrator (Azul)
**Função**: Coordenador central que gerencia todo o fluxo.

**Quando é acionado**:
- /n8n-workflow
- Pedidos para criar workflows n8n
- Menções a "n8n", "automatizar", "workflow"

**O que faz**:
- Interpreta requisitos
- Analisa complexidade
- Delega para outros agentes
- Gerencia loop de validação
- Entrega resultado final

### 2. Architect (Ciano)
**Função**: Planejador de estrutura e padrões.

**Quando é acionado**:
- Workflows médios/complexos
- Busca de templates

**O que faz**:
- Identifica padrão (Webhook, API, Database, AI, Scheduled)
- Busca templates existentes
- Define estrutura do workflow
- Cria workflow-plan.md

### 3. Node-Discoverer (Verde)
**Função**: Encontrador de nodes apropriados.

**Quando é acionado**:
- Sempre (após planejamento)

**O que faz**:
- Busca nodes por funcionalidade
- Extrai informações essenciais
- Documenta requisitos
- Cria nodes-discovered.json

### 4. Configurator (Amarelo)
**Função**: Configurador de parâmetros de nodes.

**Quando é acionado**:
- Workflows médios/complexos

**O que faz**:
- Configura cada node
- Resolve dependências de propriedades
- Escreve expressões {{}}
- Valida node a node

### 5. Builder (Magenta)
**Função**: Construtor de workflows no n8n.

**Quando é acionado**:
- Após configuração

**O que faz**:
- Cria workflow no n8n
- Adiciona nodes
- Cria conexões
- Salva workflow-id

### 6. Validator (Vermelho)
**Função**: Validador de workflows.

**Quando é acionado**:
- Após build
- /n8n-validate

**O que faz**:
- Executa validação completa
- Categoriza erros/warnings
- Identifica false positives
- Cria validation-result.json

### 7. Fixer (Amarelo)
**Função**: Corretor de erros.

**Quando é acionado**:
- Quando validação falha
- /n8n-fix

**O que faz**:
- Aplica autofix
- Corrige manualmente
- Limpa conexões órfãs
- Documenta correções

### 8. AI-Specialist (Magenta)
**Função**: Especialista em AI Agents.

**Quando é acionado**:
- Workflows com AI
- LangChain, embeddings, RAG

**O que faz**:
- Configura AI Agents
- Define conexões ai_*
- Escolhe language models
- Configura tools e memory

## Fluxos de Execução

### Workflow Simples (< 5 nodes)
```
Orchestrator → Node-Discoverer → Builder → Validator
```

### Workflow Médio (5-15 nodes)
```
Orchestrator → Architect → Node-Discoverer → Configurator → Builder → Validator
```

### Workflow Complexo (> 15 nodes ou AI)
```
Orchestrator → Architect → Node-Discoverer → AI-Specialist → Configurator → Builder → Validator → Fixer
```

## Integração com Ralph Loop

Para execução iterativa até completar:

```bash
/ralph-loop "/n8n-workflow 'Descrição'" --completion-promise "WORKFLOW_COMPLETE" --max-iterations 30
```

Ou usando flag:
```bash
/n8n-workflow "Descrição" --ralph --max-iterations 30
```

### Completion Promises

| Promise | Significado |
|---------|-------------|
| `ARCHITECTURE_READY` | Planejamento concluído |
| `NODES_DISCOVERED` | Nodes identificados |
| `NODES_CONFIGURED` | Nodes configurados |
| `WORKFLOW_BUILT` | Workflow criado |
| `VALIDATION_PASSED` | Sem erros |
| `WORKFLOW_COMPLETE` | Tudo pronto |
| `BLOCKED_NEEDS_HELP` | Precisa ajuda |

## Sistema de Sessão

Os agentes se comunicam via arquivos em `.n8n-session/`:

```
.n8n-session/
├── context.json           # Requisitos
├── workflow-plan.md       # Plano
├── nodes-discovered.json  # Nodes
├── workflow-id.txt        # ID criado
├── validation-result.json # Validação
├── checkpoint.json        # Estado
└── execution-log.md       # Log
```

## Customização

### Modificar Comportamento de Agente

1. Abra o arquivo do agente em `agents/`
2. Modifique o system prompt
3. Salve o arquivo

### Adicionar Novo Agente

1. Crie arquivo `.md` em `agents/`
2. Adicione frontmatter com name, description, model, color, tools
3. Escreva system prompt

### Modificar Idioma

Em cada agente, localize:
```
Responda **SEMPRE em português brasileiro**.
```
E altere para o idioma desejado.

## MCP Tools por Agente

### Orchestrator
- tools_documentation, n8n_diagnostic, n8n_health_check
- n8n_list_workflows, n8n_list_executions

### Architect
- search_templates, get_template, list_tasks
- search_templates_by_metadata

### Node-Discoverer
- search_nodes, get_node_essentials
- list_nodes, get_node_documentation

### Configurator
- get_node_essentials, get_property_dependencies
- validate_node_minimal, validate_node_operation

### Builder
- n8n_create_workflow, n8n_update_partial_workflow
- n8n_get_workflow

### Validator
- validate_workflow, validate_workflow_connections
- n8n_validate_workflow

### Fixer
- n8n_autofix_workflow, n8n_update_partial_workflow
- n8n_workflow_versions

### AI-Specialist
- tools_documentation, list_ai_tools
- get_node_as_tool_info

## Skills por Agente

| Agente | Skills |
|--------|--------|
| Orchestrator | Nenhuma (contexto limpo) |
| Architect | n8n-workflow-patterns |
| Node-Discoverer | n8n-mcp-tools-expert |
| Configurator | n8n-node-configuration, n8n-expression-syntax |
| Builder | n8n-mcp-tools-expert |
| Validator | n8n-validation-expert |
| Fixer | n8n-validation-expert, n8n-node-configuration |
| AI-Specialist | n8n-mcp-tools-expert |

## Configuração de Tokens

Antes de usar, configure no PowerShell:

```powershell
$env:MAX_MCP_OUTPUT_TOKENS = 50000
$env:MCP_TIMEOUT = 30000
```

Ou adicione ao `$PROFILE` para persistir.

## Troubleshooting

### n8n não conecta
1. Verifique se n8n está rodando
2. Verifique API key configurada
3. Execute `n8n_diagnostic()` para detalhes

### Validação sempre falha
1. Verifique se todos campos obrigatórios estão preenchidos
2. Use perfil `runtime` em vez de `strict`
3. Verifique false positives

### Agente não é acionado
1. Verifique se a description tem examples corretos
2. Verifique se o plugin está habilitado
3. Reinicie o Claude Code

### Context overflow
1. Aumente MAX_MCP_OUTPUT_TOKENS
2. O sistema de checkpoint salvará progresso
3. Novo agente continuará automaticamente
