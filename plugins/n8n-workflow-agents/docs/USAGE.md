# Guia de Uso Completo

Este guia explica todas as formas de usar o n8n-workflow-agents, desde comandos básicos até configurações avançadas.

---

## Sumário

1. [Comandos Disponíveis](#1-comandos-disponíveis)
2. [Criando Workflows](#2-criando-workflows)
3. [Validando Workflows](#3-validando-workflows)
4. [Corrigindo Erros](#4-corrigindo-erros)
5. [Usando com Ralph Loop](#5-usando-com-ralph-loop)
6. [Invocando Agentes Diretamente](#6-invocando-agentes-diretamente)
7. [Arquivos de Sessão](#7-arquivos-de-sessão)
8. [Exemplos por Caso de Uso](#8-exemplos-por-caso-de-uso)
9. [Dicas Avançadas](#9-dicas-avançadas)

---

## 1. Comandos Disponíveis

### /n8n-workflow

Cria um workflow n8n completo baseado em uma descrição.

```bash
/n8n-workflow "<descrição do workflow>"
/n8n-workflow "<descrição>" --ralph
/n8n-workflow "<descrição>" --ralph --max-iterations 30
```

**Parâmetros:**
| Parâmetro | Descrição | Padrão |
|-----------|-----------|--------|
| `descrição` | O que o workflow deve fazer | Obrigatório |
| `--ralph` | Usar Ralph Loop para execução iterativa | false |
| `--max-iterations` | Máximo de iterações (com --ralph) | 20 |

---

### /n8n-validate

Valida um workflow existente por ID.

```bash
/n8n-validate <workflow-id>
```

**Exemplo:**
```bash
/n8n-validate abc123def456
```

---

### /n8n-fix

Corrige erros em um workflow existente.

```bash
/n8n-fix <workflow-id>
```

**Exemplo:**
```bash
/n8n-fix abc123def456
```

---

## 2. Criando Workflows

### Workflow Simples (< 5 nodes)

```bash
# Webhook + Resposta
/n8n-workflow "Webhook que retorna os dados recebidos"

# Webhook + Slack
/n8n-workflow "Webhook que envia mensagem para canal #general do Slack"

# Webhook + Email
/n8n-workflow "Webhook que envia email com os dados do formulário"

# Agendamento simples
/n8n-workflow "Tarefa que roda todo dia às 9h e envia relatório por email"
```

O framework detecta automaticamente que é simples e usa o fluxo:
```
Orchestrator → Node-Discoverer → Builder → Validator
```

---

### Workflow Médio (5-15 nodes)

```bash
# API + Transformação + Notificação
/n8n-workflow "Busca dados de uma API REST, filtra registros ativos e envia para Google Sheets"

# Múltiplas condições
/n8n-workflow "Webhook que verifica tipo de pedido e envia para diferentes canais do Slack"

# Integração completa
/n8n-workflow "Recebe formulário, salva no banco de dados, envia email de confirmação e notifica no Slack"
```

O framework usa:
```
Orchestrator → Architect → Node-Discoverer → Configurator → Builder → Validator
```

---

### Workflow Complexo (> 15 nodes)

```bash
# Sistema completo
/n8n-workflow "Sistema de onboarding que: recebe dados do funcionário, cria usuário no Google Workspace, adiciona ao Slack, envia kit de boas-vindas por email, cria card no Trello e notifica o gestor"

# Pipeline de dados
/n8n-workflow "ETL que extrai dados de 3 APIs diferentes, transforma e normaliza, detecta duplicatas, enriquece com dados externos e carrega no PostgreSQL"
```

---

### Workflow com AI Agent

```bash
# Chatbot básico
/n8n-workflow "Chatbot com GPT-4 que responde perguntas sobre a empresa"

# Chatbot com tools
/n8n-workflow "Assistente AI que pode buscar no Google, fazer cálculos e enviar emails"

# RAG (Retrieval Augmented Generation)
/n8n-workflow "Sistema RAG que indexa documentos PDF e responde perguntas sobre eles"

# Multi-agente
/n8n-workflow "Sistema de 3 agentes: pesquisador, escritor e revisor que colaboram para criar conteúdo"
```

O framework aciona o AI-Specialist:
```
Orchestrator → Architect → Node-Discoverer → AI-Specialist → Configurator → Builder → Validator
```

---

## 3. Validando Workflows

### Validar workflow recém-criado

Após criar um workflow, você pode validar novamente:

```bash
/n8n-validate <id-do-workflow>
```

### Validar workflow existente

Se você tem um workflow no n8n que quer verificar:

1. Encontre o ID do workflow na URL do n8n: `http://localhost:5678/workflow/abc123`
2. Execute:
   ```bash
   /n8n-validate abc123
   ```

### O que a validação verifica

- Campos obrigatórios preenchidos
- Conexões entre nodes válidas
- Sintaxe de expressões `{{ }}`
- Credenciais configuradas
- TypeVersion dos nodes
- Configurações de error handling

### Resultado da validação

A validação gera um relatório categorizado:

| Categoria | Descrição | Ação |
|-----------|-----------|------|
| **Erros** | Bloqueiam execução | Corrigir obrigatoriamente |
| **Warnings** | Podem causar problemas | Recomendado corrigir |
| **Sugestões** | Melhorias possíveis | Opcional |
| **False Positives** | Podem ser ignorados | Nenhuma |

---

## 4. Corrigindo Erros

### Correção automática

```bash
/n8n-fix <id-do-workflow>
```

O Fixer tenta:
1. **Autofix** - Correções automáticas do n8n
2. **Correções manuais** - Via update_partial_workflow
3. **Limpeza** - Remove conexões órfãs

### Tipos de correção suportados

| Tipo | Automático | Manual |
|------|------------|--------|
| TypeVersion incorreto | Sim | - |
| Expressão malformada | Sim | Sim |
| Campo obrigatório faltando | - | Sim |
| Conexão inválida | - | Sim |
| Node desconectado | - | Sim |
| Webhook sem path | Sim | - |

### Limite de tentativas

O Fixer tenta no máximo **3 vezes**. Se não conseguir:
- Documenta o que foi tentado
- Lista erros restantes
- Sugere intervenção manual

---

## 5. Usando com Ralph Loop

O Ralph Loop permite execução iterativa até o workflow estar completo.

### Sintaxe básica

```bash
/ralph-loop "/n8n-workflow 'Descrição'" --completion-promise "WORKFLOW_COMPLETE" --max-iterations 30
```

### Parâmetros do Ralph Loop

| Parâmetro | Descrição | Recomendado |
|-----------|-----------|-------------|
| `--completion-promise` | Promise que indica conclusão | `WORKFLOW_COMPLETE` |
| `--max-iterations` | Máximo de iterações | 20-30 |

### Usando a flag --ralph

Alternativa mais simples:

```bash
/n8n-workflow "Descrição do workflow" --ralph --max-iterations 25
```

### Completion Promises

O sistema usa promises para indicar progresso:

| Promise | Significado | Próximo Passo |
|---------|-------------|---------------|
| `ARCHITECTURE_READY` | Planejamento OK | Descobrir nodes |
| `NODES_DISCOVERED` | Nodes encontrados | Configurar |
| `NODES_CONFIGURED` | Configuração OK | Construir |
| `WORKFLOW_BUILT` | Criado no n8n | Validar |
| `VALIDATION_PASSED` | Sem erros | Finalizar |
| `WORKFLOW_COMPLETE` | **Tudo pronto** | Loop termina |
| `BLOCKED_NEEDS_HELP` | Precisa ajuda | Loop termina |

---

## 6. Invocando Agentes Diretamente

Você pode invocar agentes específicos sem usar os comandos slash.

### Via conversa natural

```
"Use o n8n-architect para planejar um workflow de integração Slack + Sheets"

"Acione o n8n-validator para validar o workflow xyz123"

"Use o n8n-ai-specialist para configurar um chatbot com memória"
```

### Via Task tool (para outros plugins)

```
Task(
  subagent_type: "n8n-orchestrator",
  prompt: "Crie um workflow que..."
)
```

### Quando invocar diretamente

| Agente | Quando Invocar |
|--------|----------------|
| **orchestrator** | Criar workflow completo |
| **architect** | Apenas planejar estrutura |
| **node-discoverer** | Pesquisar nodes disponíveis |
| **configurator** | Ajudar com configuração específica |
| **builder** | Modificar workflow existente |
| **validator** | Validar sem correção |
| **fixer** | Corrigir sem validar novamente |
| **ai-specialist** | Ajuda com AI Agents |

---

## 7. Arquivos de Sessão

Durante a execução, o framework cria arquivos em `.n8n-session/`:

### context.json

Armazena os requisitos originais do usuário:

```json
{
  "createdAt": "2026-01-12T10:00:00Z",
  "userRequest": "Webhook que envia para Slack",
  "useRalph": false,
  "maxIterations": 20
}
```

### workflow-plan.md

Plano criado pelo Architect:

```markdown
# Plano de Workflow: Slack Notification

## Padrão Identificado
Webhook Processing

## Estrutura
1. Webhook - Recebe dados
2. Set - Formata mensagem
3. Slack - Envia notificação
...
```

### nodes-discovered.json

Nodes encontrados pelo Node-Discoverer:

```json
{
  "nodes": [
    {
      "nodeType": "nodes-base.webhook",
      "requiredFields": ["path", "httpMethod"],
      "examples": [...]
    }
  ]
}
```

### workflow-id.txt

ID do workflow criado:
```
abc123def456
```

### validation-result.json

Resultado da validação:

```json
{
  "valid": true,
  "errors": [],
  "warnings": [],
  "suggestions": []
}
```

### checkpoint.json

Estado para continuação (se interrompido):

```json
{
  "phase": "building",
  "progress": 75,
  "lastAgent": "builder"
}
```

### execution-log.md

Log de todas as ações:

```markdown
[2026-01-12 10:00:00] Orchestrator iniciado
[2026-01-12 10:00:05] Architect acionado
[2026-01-12 10:00:30] Plano criado
...
```

### Limpando a sessão

```powershell
# Windows
.\n8n-workflow-agents\scripts\cleanup-session.ps1

# Ou manualmente
Remove-Item -Recurse ".n8n-session"
```

```bash
# Linux/Mac
./n8n-workflow-agents/scripts/cleanup-session.sh

# Ou manualmente
rm -rf .n8n-session
```

---

## 8. Exemplos por Caso de Uso

### Integrações

```bash
# Slack
/n8n-workflow "Integração que monitora menções no Slack e salva em planilha"

# Google
/n8n-workflow "Sync automático entre Google Calendar e Notion"

# E-commerce
/n8n-workflow "Integração Shopify que notifica novos pedidos no Discord"

# CRM
/n8n-workflow "Sync de contatos entre HubSpot e Mailchimp"
```

### APIs

```bash
# REST API
/n8n-workflow "API REST que recebe dados, valida e salva no PostgreSQL"

# GraphQL
/n8n-workflow "Proxy que converte REST para GraphQL"

# Agregador
/n8n-workflow "API que busca dados de múltiplas fontes e retorna consolidado"
```

### Automações

```bash
# Relatórios
/n8n-workflow "Relatório semanal que agrega métricas e envia por email"

# Monitoramento
/n8n-workflow "Monitor de uptime que verifica URLs e alerta no Slack se cair"

# Backup
/n8n-workflow "Backup automático de documentos do Google Drive para S3"
```

### AI/ML

```bash
# Classificação
/n8n-workflow "Classificador de tickets que usa AI para categorizar e rotear"

# Análise de sentimento
/n8n-workflow "Análise de feedback que detecta sentimento e notifica urgentes"

# Geração de conteúdo
/n8n-workflow "Gerador de posts que cria conteúdo baseado em trending topics"
```

---

## 9. Dicas Avançadas

### Descrições efetivas

**Ruim:**
```bash
/n8n-workflow "workflow com slack"
```

**Bom:**
```bash
/n8n-workflow "Webhook que recebe dados de formulário de contato, valida email, envia confirmação para o cliente e notifica equipe de vendas no canal #leads do Slack"
```

**Elementos de uma boa descrição:**
- Trigger (como inicia)
- Dados (o que processa)
- Transformações (o que faz)
- Destino (para onde vai)
- Condições especiais

---

### Workflows incrementais

Para workflows muito complexos, crie em partes:

```bash
# Parte 1: Core
/n8n-workflow "Webhook que recebe pedidos e salva no banco"

# Parte 2: Adicionar notificação (depois de validar parte 1)
"Adicione ao workflow <id> um node que envia notificação para Slack"
```

---

### Usando templates

Mencione templates conhecidos:

```bash
/n8n-workflow "Igual ao template de integração Slack+Sheets, mas com Discord no lugar de Slack"
```

O Architect buscará templates similares e adaptará.

---

### Debug de expressões

Se expressões estão falhando:

```bash
"Mostre como referenciar os dados do webhook no node Set"
# Resposta: {{ $json.body.campo }}
```

---

### Credenciais

O framework não cria credenciais automaticamente. Configure no n8n antes:

1. Acesse n8n > Credentials
2. Crie a credencial necessária (Slack, Google, etc.)
3. Execute o workflow - o Builder usará a credencial existente

---

### Modo verbose

Para ver mais detalhes durante execução:

```bash
"Crie o workflow com logs detalhados em cada passo"
```

O execution-log.md terá informações completas.

---

### Continuando de checkpoint

Se a execução foi interrompida:

```bash
# Mesmo comando - o sistema detecta o checkpoint
/n8n-workflow "Mesma descrição anterior"
```

Ou explicitamente:
```bash
"Continue o workflow de onde parou"
```

---

## Atalhos Úteis

| Ação | Comando |
|------|---------|
| Listar workflows | "Liste meus workflows no n8n" |
| Ver workflow | "Mostre o workflow <id>" |
| Ativar workflow | "Ative o workflow <id>" |
| Ver execuções | "Mostre as últimas execuções do workflow <id>" |
| Deletar workflow | "Delete o workflow <id>" (pede confirmação) |

---

## Próximos Passos

- Leia [Referência de Agentes](AGENTS.md) para entender cada agente em detalhes
- Consulte [Troubleshooting](TROUBLESHOOTING.md) se encontrar problemas
- Veja [MCP Tools Reference](MCP-TOOLS.md) para ferramentas disponíveis
