# Referência de MCP Tools do n8n

Lista completa das 47 MCP tools do n8n e em qual agente cada uma está disponível.

---

## Legenda

| Símbolo | Significado |
|---------|-------------|
| ✅ | Disponível no agente |
| - | Não disponível |

---

## Sistema/Diagnóstico

| Tool | Descrição | Orch | Arch | Disc | Conf | Build | Valid | Fix | AI |
|------|-----------|:----:|:----:|:----:|:----:|:-----:|:-----:|:---:|:--:|
| `tools_documentation` | Documentação de todas as tools | ✅ | - | - | - | - | - | - | ✅ |
| `n8n_diagnostic` | Diagnóstico completo | ✅ | - | - | - | - | - | - | - |
| `n8n_health_check` | Verificar conectividade | ✅ | - | - | - | - | - | - | - |
| `n8n_list_available_tools` | Listar tools | ✅ | - | - | - | - | - | - | - |
| `get_database_statistics` | Estatísticas (542 nodes, 2709 templates) | ✅ | - | - | - | - | - | - | - |

---

## Descoberta de Nodes

| Tool | Descrição | Orch | Arch | Disc | Conf | Build | Valid | Fix | AI |
|------|-----------|:----:|:----:|:----:|:----:|:-----:|:-----:|:---:|:--:|
| `search_nodes` | Buscar por keyword | - | - | ✅ | - | - | - | - | ✅ |
| `get_node_essentials` | Detalhes essenciais (~5KB) | - | - | ✅ | ✅ | - | - | - | ✅ |
| `get_node_info` | Schema completo (~100KB) | - | - | ✅ | - | - | - | - | - |
| `get_node_documentation` | Documentação legível | - | - | ✅ | - | - | - | - | - |
| `list_nodes` | Listar por categoria | - | - | ✅ | - | - | - | - | - |
| `list_ai_tools` | 272 nodes AI-capable | - | - | - | - | - | - | - | ✅ |
| `get_node_as_tool_info` | Como usar como AI tool | - | - | - | - | - | - | - | ✅ |
| `get_property_dependencies` | Dependências de campos | - | - | - | ✅ | - | - | - | - |
| `search_node_properties` | Buscar propriedade | - | - | - | ✅ | - | - | - | - |

---

## Validação

| Tool | Descrição | Orch | Arch | Disc | Conf | Build | Valid | Fix | AI |
|------|-----------|:----:|:----:|:----:|:----:|:-----:|:-----:|:---:|:--:|
| `validate_node_minimal` | Campos obrigatórios | - | - | - | ✅ | - | - | - | - |
| `validate_node_operation` | Validação completa | - | - | - | ✅ | - | ✅ | - | - |
| `validate_workflow` | Estrutura offline | - | - | - | - | - | ✅ | - | - |
| `validate_workflow_connections` | Apenas conexões | - | - | - | - | - | ✅ | - | - |
| `validate_workflow_expressions` | Apenas expressões | - | - | - | - | - | ✅ | - | - |
| `n8n_validate_workflow` | Validar por ID (online) | - | - | - | - | - | ✅ | - | - |
| `n8n_autofix_workflow` | Auto-correção | - | - | - | - | - | - | ✅ | - |

---

## Templates

| Tool | Descrição | Orch | Arch | Disc | Conf | Build | Valid | Fix | AI |
|------|-----------|:----:|:----:|:----:|:----:|:-----:|:-----:|:---:|:--:|
| `search_templates` | Buscar por keyword | - | ✅ | - | - | - | - | - | - |
| `search_templates_by_metadata` | Por complexidade/serviço | - | ✅ | - | - | - | - | - | - |
| `get_template` | Obter completo | - | ✅ | - | - | - | - | - | - |
| `get_templates_for_task` | Por categoria | - | ✅ | - | - | - | - | - | - |
| `list_templates` | Listar com paginação | - | ✅ | - | - | - | - | - | - |
| `list_tasks` | 29 tasks categorizadas | - | ✅ | - | - | - | - | - | - |
| `list_node_templates` | Templates por node | - | ✅ | - | - | - | - | - | - |

---

## Gerenciamento de Workflows

| Tool | Descrição | Orch | Arch | Disc | Conf | Build | Valid | Fix | AI |
|------|-----------|:----:|:----:|:----:|:----:|:-----:|:-----:|:---:|:--:|
| `n8n_create_workflow` | Criar workflow | - | - | - | - | ✅ | - | - | - |
| `n8n_update_partial_workflow` | Atualização incremental | - | - | - | - | ✅ | - | ✅ | - |
| `n8n_update_full_workflow` | Substituir inteiro | - | - | - | - | - | - | - | - |
| `n8n_get_workflow` | Obter por ID | - | - | - | - | ✅ | ✅ | - | - |
| `n8n_get_workflow_details` | Detalhes + stats | ✅ | - | - | - | - | - | - | - |
| `n8n_get_workflow_structure` | Nodes e conexões | - | - | - | - | ✅ | ✅ | - | - |
| `n8n_get_workflow_minimal` | ID, nome, status | ✅ | - | - | - | - | - | - | - |
| `n8n_delete_workflow` | Deletar | - | - | - | - | - | - | - | - |
| `n8n_list_workflows` | Listar | ✅ | - | - | - | - | - | - | - |
| `n8n_workflow_versions` | Versões/rollback | - | - | - | - | - | - | ✅ | - |

---

## Execuções

| Tool | Descrição | Orch | Arch | Disc | Conf | Build | Valid | Fix | AI |
|------|-----------|:----:|:----:|:----:|:----:|:-----:|:-----:|:---:|:--:|
| `n8n_trigger_webhook_workflow` | Disparar via webhook | - | - | - | - | - | - | - | - |
| `n8n_get_execution` | Detalhes de execução | - | - | - | - | - | ✅ | - | - |
| `n8n_list_executions` | Listar execuções | ✅ | - | - | - | - | - | - | - |
| `n8n_delete_execution` | Deletar execução | - | - | - | - | - | - | - | - |

---

## Contagem por Agente

| Agente | MCP Tools |
|--------|-----------|
| Orchestrator | 8 |
| Architect | 7 |
| Node-Discoverer | 5 |
| Configurator | 5 |
| Builder | 4 |
| Validator | 8 |
| Fixer | 3 |
| AI-Specialist | 5 |

---

## Tools NÃO Atribuídas a Nenhum Agente

Estas tools estão disponíveis mas não foram atribuídas por design:

| Tool | Motivo |
|------|--------|
| `n8n_update_full_workflow` | Preferir update_partial (incremental) |
| `n8n_delete_workflow` | Ação destrutiva, evitar uso automático |
| `n8n_trigger_webhook_workflow` | Uso manual/testes |
| `n8n_delete_execution` | Raramente necessário |

---

## Sintaxe Correta de nodeType

### Para Busca (search_nodes, get_node_*)
```
nodes-base.slack
nodes-base.webhook
nodes-base.httpRequest
```

### Para Criação (n8n_create_workflow)
```
n8n-nodes-base.slack
n8n-nodes-base.webhook
n8n-nodes-base.httpRequest
```

### LangChain Nodes
```
@n8n/n8n-nodes-langchain.agent
@n8n/n8n-nodes-langchain.lmChatOpenAi
```

---

## Sintaxe de addConnection

**CORRETO** - 4 parâmetros separados:
```json
{
  "type": "addConnection",
  "source": "Webhook",
  "target": "Slack",
  "sourcePort": "main",
  "targetPort": "main"
}
```

**Para IF nodes** - usar branch:
```json
{
  "type": "addConnection",
  "source": "IF",
  "target": "Success",
  "sourcePort": "main",
  "targetPort": "main",
  "branch": "true"
}
```

---

## Perfis de Validação

| Perfil | Uso | Rigor |
|--------|-----|-------|
| `minimal` | Check rápido | Baixo |
| `runtime` | Padrão | Médio |
| `ai-friendly` | Para AI | Médio |
| `strict` | Máximo | Alto |
