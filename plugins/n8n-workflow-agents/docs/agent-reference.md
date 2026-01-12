# Referência dos Agentes

Documentação completa de cada um dos 8 agentes especializados.

---

## Visão Geral

| # | Agente | Cor | Função Principal |
|---|--------|-----|------------------|
| 1 | **Orchestrator** | Azul | Coordenar todo o fluxo |
| 2 | **Architect** | Ciano | Planejar estrutura |
| 3 | **Node-Discoverer** | Verde | Encontrar nodes |
| 4 | **Configurator** | Amarelo | Configurar parâmetros |
| 5 | **Builder** | Magenta | Criar workflow |
| 6 | **Validator** | Vermelho | Validar workflow |
| 7 | **Fixer** | Amarelo | Corrigir erros |
| 8 | **AI-Specialist** | Magenta | Configurar AI |

---

## 1. Orchestrator (n8n-orchestrator)

### Resumo
Coordenador central que gerencia todo o fluxo de criação de workflows.

### Cor: 🔵 Azul

### Quando é Acionado
- Comando `/n8n-workflow`
- Pedidos para criar workflows n8n
- Menções a "n8n", "automatizar", "workflow"

### Responsabilidades
1. Interpretar requisitos do usuário
2. Analisar complexidade do workflow
3. Decidir quais subagentes acionar
4. Coordenar comunicação entre agentes
5. Gerenciar loop de validação/correção
6. Compilar e entregar resultado final

### Tools Disponíveis
**Claude:**
- Task, Read, Write, Glob, Grep, Bash, TodoWrite, AskUserQuestion

**MCP n8n:**
- tools_documentation
- n8n_diagnostic
- n8n_health_check
- n8n_list_available_tools
- get_database_statistics
- n8n_list_workflows
- n8n_get_workflow_minimal
- n8n_list_executions

### Skills
Nenhuma (contexto limpo para coordenação)

### Output
- Cria `.n8n-session/context.json`
- Coordena criação de todos os outros arquivos
- Entrega resultado final ao usuário

---

## 2. Architect (n8n-architect)

### Resumo
Planejador de estrutura que identifica padrões e busca templates.

### Cor: 🔷 Ciano

### Quando é Acionado
- Workflows médios/complexos (5+ nodes)
- Busca de templates existentes
- Planejamento de estrutura

### Responsabilidades
1. Identificar padrão correto (Webhook, API, Database, AI, Scheduled)
2. Buscar templates existentes (SEMPRE antes de planejar do zero)
3. Definir estrutura do workflow
4. Mapear fluxo de dados
5. Propor nodes necessários

### Tools Disponíveis
**Claude:**
- Read, Grep, Glob

**MCP n8n:**
- search_templates
- search_templates_by_metadata
- get_template
- get_templates_for_task
- list_templates
- list_tasks
- list_node_templates

### Skills
- `n8n-workflow-patterns` - 5 padrões arquiteturais

### Output
- Cria `.n8n-session/workflow-plan.md`

---

## 3. Node-Discoverer (n8n-node-discoverer)

### Resumo
Descobridor de nodes que busca e documenta nodes apropriados.

### Cor: 🟢 Verde

### Quando é Acionado
- Sempre (após planejamento ou direto em workflows simples)
- Busca de nodes por funcionalidade
- Listagem de nodes por categoria

### Responsabilidades
1. Buscar nodes por funcionalidade
2. Extrair informações essenciais de cada node
3. Mapear operações disponíveis
4. Documentar campos obrigatórios
5. Listar credenciais necessárias

### Tools Disponíveis
**Claude:**
- Read

**MCP n8n:**
- search_nodes
- get_node_essentials
- get_node_documentation
- list_nodes
- get_node_info (raramente)

### Skills
- `n8n-mcp-tools-expert` - Guia de uso das tools MCP

### Output
- Cria `.n8n-session/nodes-discovered.json`

---

## 4. Configurator (n8n-configurator)

### Resumo
Configurador que preenche parâmetros e escreve expressões.

### Cor: 🟡 Amarelo

### Quando é Acionado
- Workflows médios/complexos
- Configuração de parâmetros
- Escrita de expressões n8n

### Responsabilidades
1. Configurar cada node com parâmetros corretos
2. Resolver dependências de propriedades
3. Escrever expressões {{}} corretas
4. Validar configuração node a node
5. Documentar configurações no JSON

### Tools Disponíveis
**Claude:**
- Read

**MCP n8n:**
- get_node_essentials
- get_property_dependencies
- search_node_properties
- validate_node_minimal
- validate_node_operation

### Skills
- `n8n-node-configuration` - Configuração operation-aware
- `n8n-expression-syntax` - Sintaxe de expressões
- `n8n-code-javascript` - Código JS em Code nodes
- `n8n-code-python` - Código Python em Code nodes

### Output
- Atualiza `.n8n-session/nodes-discovered.json` com configurações

---

## 5. Builder (n8n-builder)

### Resumo
Construtor que cria e modifica workflows no n8n.

### Cor: 🟣 Magenta

### Quando é Acionado
- Após configuração
- Criação de workflow
- Modificação de workflow existente

### Responsabilidades
1. Criar workflow no n8n
2. Adicionar nodes incrementalmente
3. Criar conexões entre nodes
4. Usar smart parameters (branch, case)
5. Salvar workflow-id

### Tools Disponíveis
**Claude:**
- Read, Write, AskUserQuestion

**MCP n8n:**
- n8n_create_workflow
- n8n_update_partial_workflow
- n8n_get_workflow
- n8n_get_workflow_structure

### Skills
- `n8n-mcp-tools-expert` - Sintaxe de conexões

### Output
- Cria workflow no n8n
- Salva `.n8n-session/workflow-id.txt`

### Importante
**SEMPRE** pede confirmação antes de criar/modificar!

---

## 6. Validator (n8n-validator)

### Resumo
Validador que executa validação completa e identifica problemas.

### Cor: 🔴 Vermelho

### Quando é Acionado
- Após build
- Comando `/n8n-validate`
- Verificação de workflow existente

### Responsabilidades
1. Executar validação de estrutura
2. Executar validação de expressões
3. Executar validação completa
4. Categorizar erros/warnings/sugestões
5. Identificar false positives
6. Propor correções específicas

### Tools Disponíveis
**Claude:**
- Read

**MCP n8n:**
- validate_workflow
- validate_workflow_connections
- validate_workflow_expressions
- n8n_validate_workflow
- n8n_get_execution
- validate_node_operation
- n8n_get_workflow

### Skills
- `n8n-validation-expert` - Interpretar erros de validação

### Output
- Cria `.n8n-session/validation-result.json`

---

## 7. Fixer (n8n-fixer)

### Resumo
Corretor que aplica correções automáticas e manuais.

### Cor: 🟡 Amarelo

### Quando é Acionado
- Quando validação falha
- Comando `/n8n-fix`
- Após erros identificados

### Responsabilidades
1. Aplicar autofix para erros comuns
2. Corrigir erros manualmente
3. Limpar conexões órfãs
4. Documentar correções aplicadas
5. Gerenciar rollback se necessário

### Tools Disponíveis
**Claude:**
- Read

**MCP n8n:**
- n8n_autofix_workflow
- n8n_update_partial_workflow
- n8n_workflow_versions

### Skills
- `n8n-validation-expert` - Entender erros
- `n8n-node-configuration` - Corrigir configurações

### Output
- Aplica correções no workflow
- Cria `.n8n-session/fixes-applied.json`

### Limite
Máximo 3 tentativas de correção por sessão.

---

## 8. AI-Specialist (n8n-ai-specialist)

### Resumo
Especialista em AI Agents, LangChain, memory, embeddings e RAG.

### Cor: 🟣 Magenta

### Quando é Acionado
- Workflows com AI Agents
- Configuração de LangChain
- Sistemas RAG
- Embeddings e vector stores

### Responsabilidades
1. Identificar tipo de aplicação AI
2. Selecionar nodes LangChain apropriados
3. Configurar conexões ai_*
4. Definir language model e tools
5. Configurar memory e embeddings

### Tools Disponíveis
**Claude:**
- Read

**MCP n8n:**
- tools_documentation (ai_agents_guide)
- list_ai_tools
- get_node_as_tool_info
- get_node_essentials
- search_nodes

### Skills
- `n8n-mcp-tools-expert` - Conexões AI

### Conhecimento Especial
- 8 tipos de conexão AI: ai_languageModel, ai_tool, ai_memory, ai_embedding, ai_vectorStore, ai_document, ai_textSplitter, ai_outputParser
- 272 nodes AI-capable
- Streaming vs non-streaming
- Fallback language models
- Padrões RAG

### Output
- Cria `.n8n-session/ai-config.json`

---

## Fluxos de Execução

### Simples (< 5 nodes)
```
Orchestrator → Node-Discoverer → Builder → Validator
```

### Médio (5-15 nodes)
```
Orchestrator → Architect → Node-Discoverer → Configurator → Builder → Validator
```

### Complexo (> 15 nodes)
```
Orchestrator → Architect → Node-Discoverer → Configurator → Builder → Validator → Fixer
```

### Com AI
```
Orchestrator → Architect → Node-Discoverer → AI-Specialist → Configurator → Builder → Validator → Fixer
```

---

## Tabela de MCP Tools por Agente

| Tool | Orch | Arch | Disc | Conf | Build | Valid | Fix | AI |
|------|:----:|:----:|:----:|:----:|:-----:|:-----:|:---:|:--:|
| search_nodes | | | ✅ | | | | | |
| get_node_essentials | | | ✅ | ✅ | | | | ✅ |
| validate_node_* | | | | ✅ | | ✅ | | |
| search_templates | | ✅ | | | | | | |
| n8n_create_workflow | | | | | ✅ | | | |
| n8n_update_partial | | | | | ✅ | | ✅ | |
| validate_workflow* | | | | | | ✅ | | |
| n8n_autofix | | | | | | | ✅ | |
| list_ai_tools | | | | | | | | ✅ |

---

## Tabela de Skills por Agente

| Skill | Orch | Arch | Disc | Conf | Build | Valid | Fix | AI |
|-------|:----:|:----:|:----:|:----:|:-----:|:-----:|:---:|:--:|
| workflow-patterns | | ✅ | | | | | | |
| mcp-tools-expert | | | ✅ | | ✅ | | | ✅ |
| validation-expert | | | | | | ✅ | ✅ | |
| node-configuration | | | | ✅ | | | ✅ | |
| expression-syntax | | | | ✅ | | | | |
| code-javascript | | | | ✅ | | | | |
| code-python | | | | ✅ | | | | |
