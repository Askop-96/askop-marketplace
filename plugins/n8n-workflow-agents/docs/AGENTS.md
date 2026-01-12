# Referência de Agentes

Documentação detalhada de cada um dos 8 agentes especializados do n8n-workflow-agents.

---

## Sumário

1. [Visão Geral](#visão-geral)
2. [Orchestrator](#1-orchestrator)
3. [Architect](#2-architect)
4. [Node-Discoverer](#3-node-discoverer)
5. [Configurator](#4-configurator)
6. [Builder](#5-builder)
7. [Validator](#6-validator)
8. [Fixer](#7-fixer)
9. [AI-Specialist](#8-ai-specialist)
10. [Fluxos de Execução](#fluxos-de-execução)
11. [Comunicação entre Agentes](#comunicação-entre-agentes)

---

## Visão Geral

| Agente | Arquivo | Cor | Função Principal |
|--------|---------|-----|------------------|
| Orchestrator | `orchestrator.md` | Azul | Coordenar fluxo |
| Architect | `architect.md` | Ciano | Planejar estrutura |
| Node-Discoverer | `node-discoverer.md` | Verde | Encontrar nodes |
| Configurator | `configurator.md` | Amarelo | Configurar parâmetros |
| Builder | `builder.md` | Magenta | Criar workflow |
| Validator | `validator.md` | Vermelho | Validar workflow |
| Fixer | `fixer.md` | Amarelo | Corrigir erros |
| AI-Specialist | `ai-specialist.md` | Magenta | Configurar AI |

---

## 1. Orchestrator

### Função
Coordenador central que gerencia todo o fluxo de criação de workflows.

### Quando é Acionado
- Comando `/n8n-workflow`
- Pedidos para criar workflows n8n
- Menções a "n8n", "automatizar", "workflow"

### Responsabilidades
1. Interpretar requisitos do usuário
2. Analisar complexidade (simples/médio/complexo)
3. Decidir quais agentes acionar
4. Gerenciar sequência de execução
5. Criar e manter sessão (`.n8n-session/`)
6. Controlar loop validação/correção
7. Entregar resultado final

### Tools Disponíveis
```
- Task (para invocar outros agentes)
- Read, Write, Glob, Grep, Bash
- TodoWrite
- AskUserQuestion
- mcp__MCP_DOCKER__tools_documentation
- mcp__MCP_DOCKER__n8n_diagnostic
- mcp__MCP_DOCKER__n8n_health_check
- mcp__MCP_DOCKER__n8n_list_available_tools
- mcp__MCP_DOCKER__get_database_statistics
- mcp__MCP_DOCKER__n8n_list_workflows
- mcp__MCP_DOCKER__n8n_get_workflow_minimal
- mcp__MCP_DOCKER__n8n_list_executions
```

### O que NÃO faz
- Não busca nodes diretamente
- Não configura parâmetros
- Não cria workflows
- Não valida
- Delega tudo para agentes especializados

### Decisão de Complexidade

| Complexidade | Critério | Agentes Acionados |
|--------------|----------|-------------------|
| Simples | < 5 nodes | Node-Discoverer → Builder → Validator |
| Médio | 5-15 nodes | Architect → Node-Discoverer → Configurator → Builder → Validator |
| Complexo | > 15 nodes ou AI | Todos os agentes |

---

## 2. Architect

### Função
Planejador de estrutura e padrões arquiteturais.

### Quando é Acionado
- Workflows médios e complexos
- Quando precisa buscar templates
- Quando precisa definir padrão arquitetural

### Responsabilidades
1. Analisar requisitos do usuário
2. Identificar padrão arquitetural
3. Buscar templates existentes
4. Definir estrutura do workflow
5. Documentar em `workflow-plan.md`

### Tools Disponíveis
```
- Read, Grep, Glob
- mcp__MCP_DOCKER__search_templates
- mcp__MCP_DOCKER__search_templates_by_metadata
- mcp__MCP_DOCKER__get_template
- mcp__MCP_DOCKER__get_templates_for_task
- mcp__MCP_DOCKER__list_templates
- mcp__MCP_DOCKER__list_tasks
- mcp__MCP_DOCKER__list_node_templates
```

### 5 Padrões Arquiteturais

| Padrão | Trigger | Uso Principal |
|--------|---------|---------------|
| Webhook Processing | Webhook | Receber dados externos |
| HTTP API Integration | HTTP Request | Consumir APIs |
| Database Operations | DB nodes | CRUD em bancos |
| AI Agent | AI Agent | Automações inteligentes |
| Scheduled Tasks | Schedule Trigger | Tarefas periódicas |

### Princípio: Templates First
**SEMPRE** busca templates antes de planejar do zero.

### Output
```
.n8n-session/workflow-plan.md
```

---

## 3. Node-Discoverer

### Função
Encontrar e documentar nodes apropriados para o workflow.

### Quando é Acionado
- Sempre (após planejamento, se houver)
- Quando precisa pesquisar nodes

### Responsabilidades
1. Ler plano do Architect
2. Buscar nodes por funcionalidade
3. Extrair informações essenciais
4. Documentar requisitos de cada node
5. Listar credenciais necessárias

### Tools Disponíveis
```
- Read
- mcp__MCP_DOCKER__search_nodes
- mcp__MCP_DOCKER__get_node_essentials
- mcp__MCP_DOCKER__get_node_documentation
- mcp__MCP_DOCKER__list_nodes
- mcp__MCP_DOCKER__get_node_info
```

### Hierarquia de Busca
1. `search_nodes` - Busca por keyword (preferido)
2. `get_node_essentials` - Detalhes (~5KB)
3. `get_node_documentation` - Descrição legível
4. `get_node_info` - Schema completo (~100KB, evitar)

### Formato de nodeType

| Contexto | Formato | Exemplo |
|----------|---------|---------|
| Busca | `nodes-base.xxx` | `nodes-base.slack` |
| Criação | `n8n-nodes-base.xxx` | `n8n-nodes-base.slack` |
| LangChain | `@n8n/n8n-nodes-langchain.xxx` | `@n8n/n8n-nodes-langchain.agent` |

### Output
```
.n8n-session/nodes-discovered.json
```

---

## 4. Configurator

### Função
Configurar parâmetros de cada node corretamente.

### Quando é Acionado
- Workflows médios e complexos
- Quando nodes precisam de configuração detalhada

### Responsabilidades
1. Ler nodes descobertos
2. Verificar dependências de propriedades
3. Configurar todos os parâmetros
4. Escrever expressões `{{ }}`
5. Validar node a node

### Tools Disponíveis
```
- Read
- mcp__MCP_DOCKER__get_node_essentials
- mcp__MCP_DOCKER__get_property_dependencies
- mcp__MCP_DOCKER__search_node_properties
- mcp__MCP_DOCKER__validate_node_minimal
- mcp__MCP_DOCKER__validate_node_operation
```

### Princípio: Never Trust Defaults
**SEMPRE** configura todos os parâmetros explicitamente.

### Sintaxe de Expressões

| Variável | Uso | Exemplo |
|----------|-----|---------|
| `$json` | Dados do item | `{{ $json.name }}` |
| `$json.body` | Dados de webhook | `{{ $json.body.email }}` |
| `$node["Name"]` | Dados de outro node | `{{ $node["Webhook"].json.body }}` |
| `$now` | Data/hora atual | `{{ $now.toISO() }}` |
| `$env` | Variáveis de ambiente | `{{ $env.API_KEY }}` |

### Output
Atualiza `nodes-discovered.json` com configurações.

---

## 5. Builder

### Função
Criar e modificar workflows no n8n.

### Quando é Acionado
- Após configuração dos nodes
- Para modificar workflows existentes

### Responsabilidades
1. Ler configurações dos nodes
2. Pedir confirmação ao usuário
3. Criar workflow no n8n
4. Criar conexões entre nodes
5. Salvar ID do workflow

### Tools Disponíveis
```
- Read, Write
- AskUserQuestion
- mcp__MCP_DOCKER__n8n_create_workflow
- mcp__MCP_DOCKER__n8n_update_partial_workflow
- mcp__MCP_DOCKER__n8n_get_workflow
- mcp__MCP_DOCKER__n8n_get_workflow_structure
```

### Sintaxe CRÍTICA: Conexões

```json
// CORRETO - 4 strings separadas
{
  "type": "addConnection",
  "source": "Webhook",
  "target": "Slack",
  "sourcePort": "main",
  "targetPort": "main"
}

// IF nodes - use branch
{
  "type": "addConnection",
  "source": "IF",
  "target": "Success Handler",
  "sourcePort": "main",
  "targetPort": "main",
  "branch": "true"
}
```

### Princípio: Confirmação Antes de Criar
**SEMPRE** pede confirmação via AskUserQuestion.

### Output
```
.n8n-session/workflow-id.txt
```

---

## 6. Validator

### Função
Validar workflows e identificar problemas.

### Quando é Acionado
- Após build
- Comando `/n8n-validate`

### Responsabilidades
1. Executar todas as validações
2. Categorizar por severidade
3. Identificar false positives
4. Propor correções
5. Documentar resultado

### Tools Disponíveis
```
- Read
- mcp__MCP_DOCKER__validate_workflow
- mcp__MCP_DOCKER__validate_workflow_connections
- mcp__MCP_DOCKER__validate_workflow_expressions
- mcp__MCP_DOCKER__n8n_validate_workflow
- mcp__MCP_DOCKER__n8n_get_execution
- mcp__MCP_DOCKER__validate_node_operation
- mcp__MCP_DOCKER__n8n_get_workflow
```

### Níveis de Validação

| Nível | Ferramenta | O que Verifica |
|-------|------------|----------------|
| Estrutura | `validate_workflow_connections` | Nodes, conexões, ciclos |
| Expressões | `validate_workflow_expressions` | Sintaxe `{{ }}` |
| Completa | `validate_workflow` | Tudo |
| Online | `n8n_validate_workflow` | Validação real no n8n |

### Categorias de Problemas

| Categoria | Severidade | Ação |
|-----------|------------|------|
| Erros | Bloqueante | Corrigir obrigatoriamente |
| Warnings | Média | Recomendado corrigir |
| Sugestões | Baixa | Opcional |
| False Positives | Nenhuma | Ignorar |

### Output
```
.n8n-session/validation-result.json
```

---

## 7. Fixer

### Função
Corrigir erros identificados pelo Validator.

### Quando é Acionado
- Quando validação falha
- Comando `/n8n-fix`

### Responsabilidades
1. Ler resultado da validação
2. Aplicar autofix quando possível
3. Corrigir manualmente quando necessário
4. Limpar conexões órfãs
5. Documentar correções

### Tools Disponíveis
```
- Read
- mcp__MCP_DOCKER__n8n_autofix_workflow
- mcp__MCP_DOCKER__n8n_update_partial_workflow
- mcp__MCP_DOCKER__n8n_workflow_versions
```

### Tipos de Autofix

| Tipo | Descrição |
|------|-----------|
| `expression-format` | Corrige sintaxe de expressões |
| `typeversion-correction` | Atualiza typeVersion |
| `error-output-config` | Configura error output |
| `webhook-missing-path` | Adiciona path faltando |

### Limite de Iterações
**Máximo 3 tentativas** de correção por sessão.

### Output
```
.n8n-session/fixes-applied.json
```

---

## 8. AI-Specialist

### Função
Especialista em configuração de AI Agents e LangChain.

### Quando é Acionado
- Workflows com AI
- LangChain, embeddings, RAG
- Chatbots inteligentes

### Responsabilidades
1. Identificar tipo de aplicação AI
2. Selecionar nodes LangChain apropriados
3. Configurar conexões ai_*
4. Escolher language models
5. Documentar arquitetura AI

### Tools Disponíveis
```
- Read
- mcp__MCP_DOCKER__tools_documentation
- mcp__MCP_DOCKER__list_ai_tools
- mcp__MCP_DOCKER__get_node_as_tool_info
- mcp__MCP_DOCKER__get_node_essentials
- mcp__MCP_DOCKER__search_nodes
```

### 8 Tipos de Conexão AI

| Tipo | Descrição |
|------|-----------|
| `ai_languageModel` | Modelo de linguagem |
| `ai_tool` | Tools para o agente |
| `ai_memory` | Memória de conversação |
| `ai_embedding` | Geração de embeddings |
| `ai_vectorStore` | Armazenamento vetorial |
| `ai_document` | Loader de documentos |
| `ai_textSplitter` | Divisor de texto |
| `ai_outputParser` | Parser de saída |

### Arquitetura AI Agent

```
AI Agent
├── ai_languageModel (obrigatório)
├── ai_tool (opcional, múltiplos)
├── ai_memory (opcional)
└── ai_outputParser (opcional)
```

### Output
```
.n8n-session/ai-config.json
```

---

## Fluxos de Execução

### Simples (< 5 nodes)

```
┌─────────────┐     ┌─────────────────┐     ┌─────────┐     ┌───────────┐
│ Orchestrator│────▶│ Node-Discoverer │────▶│ Builder │────▶│ Validator │
└─────────────┘     └─────────────────┘     └─────────┘     └───────────┘
```

### Médio (5-15 nodes)

```
┌─────────────┐     ┌───────────┐     ┌─────────────────┐     ┌──────────────┐
│ Orchestrator│────▶│ Architect │────▶│ Node-Discoverer │────▶│ Configurator │
└─────────────┘     └───────────┘     └─────────────────┘     └──────────────┘
                                                                      │
                    ┌───────────┐     ┌─────────┐                     │
                    │ Validator │◀────│ Builder │◀────────────────────┘
                    └───────────┘     └─────────┘
```

### Complexo (> 15 nodes ou AI)

```
┌─────────────┐     ┌───────────┐     ┌─────────────────┐     ┌───────────────┐
│ Orchestrator│────▶│ Architect │────▶│ Node-Discoverer │────▶│ AI-Specialist │
└─────────────┘     └───────────┘     └─────────────────┘     └───────────────┘
                                                                      │
┌───────┐     ┌───────────┐     ┌─────────┐     ┌──────────────┐     │
│ Fixer │◀────│ Validator │◀────│ Builder │◀────│ Configurator │◀────┘
└───────┘     └───────────┘     └─────────┘     └──────────────┘
    │                                                   ▲
    └───────────────────────────────────────────────────┘
                     (loop até validar)
```

---

## Comunicação entre Agentes

### Via Arquivos de Sessão

```
.n8n-session/
├── context.json           ← Orchestrator cria
├── workflow-plan.md       ← Architect cria
├── nodes-discovered.json  ← Node-Discoverer cria
├── ai-config.json         ← AI-Specialist cria
├── workflow-id.txt        ← Builder cria
├── validation-result.json ← Validator cria
├── fixes-applied.json     ← Fixer cria
├── checkpoint.json        ← Qualquer agente atualiza
└── execution-log.md       ← Todos escrevem
```

### Protocolo de Delegação

1. Orchestrator escreve contexto em arquivo
2. Lança agente via Task tool
3. Agente lê arquivo de entrada
4. Agente executa tarefa
5. Agente escreve arquivo de saída
6. Agente retorna status ao Orchestrator
7. Orchestrator lê resultado e decide próximo passo

### Sistema de Checkpoint

Se um agente retorna "CHECKPOINT":
1. Orchestrator lê `checkpoint.json`
2. Lança novo agente do mesmo tipo
3. Passa flag `--continue` no prompt
4. Novo agente continua de onde parou
