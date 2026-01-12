# Guia de Customização

Este guia explica como modificar e personalizar o framework de subagentes n8n.

---

## Estrutura dos Arquivos de Agente

Cada agente é um arquivo Markdown com esta estrutura:

```markdown
---
name: nome-do-agente
description: |
  Quando usar este agente.

  <example>
  Context: Situação
  user: "O que o usuário diz"
  assistant: "O que o Claude responde"
  <commentary>
  Por que este agente é acionado
  </commentary>
  </example>

model: inherit
color: blue
tools:
  - Tool1
  - Tool2
---

# Título do Agente

Conteúdo do system prompt...
```

---

## Modificar Comportamento de Agente

### Exemplo 1: Fazer Builder sempre pedir confirmação

Abra `agents/builder.md` e localize a seção "Regras Importantes":

**Antes:**
```markdown
## Regras Importantes

1. **SEMPRE** peça confirmação antes de criar/modificar
```

**Depois:**
```markdown
## Regras Importantes

1. **OBRIGATÓRIO**: Peça confirmação ANTES de QUALQUER operação, incluindo:
   - Criar workflow
   - Adicionar node
   - Modificar parâmetro
   - Criar conexão
```

### Exemplo 2: Adicionar nodes favoritos ao Node-Discoverer

Abra `agents/node-discoverer.md` e adicione uma seção:

```markdown
## Nodes Prioritários do Projeto

Sempre considere estes nodes primeiro:
- nodes-base.meuNodeCustom
- nodes-base.outroNode
- @empresa/nodes-internos.meuNode
```

### Exemplo 3: Mudar idioma para inglês

Em cada arquivo de agente, localize:
```markdown
Responda **SEMPRE em português brasileiro**.
```

Altere para:
```markdown
Always respond in **English**.
```

---

## Adicionar Novo Agente

### Passo 1: Criar arquivo

Crie `agents/meu-novo-agente.md`

### Passo 2: Definir frontmatter

```yaml
---
name: meu-novo-agente
description: |
  Use este agente quando [condição específica].

  <example>
  Context: [Situação]
  user: "[Pedido do usuário]"
  assistant: "[Resposta esperada]"
  <commentary>
  [Por que este agente é apropriado]
  </commentary>
  </example>

model: inherit
color: green
tools:
  - Read
  - Tool_Necessaria
---
```

### Passo 3: Escrever system prompt

```markdown
# Meu Novo Agente

Você é [descrição do papel].

## Idioma

Responda **SEMPRE em português brasileiro**.

## Responsabilidades

1. [Responsabilidade 1]
2. [Responsabilidade 2]

## Processo de Trabalho

### 1. [Primeiro passo]
...

## Regras Importantes

1. **SEMPRE** [regra]
2. **NUNCA** [regra]

## Formato de Resposta

```
[Como formatar a resposta]
```
```

### Passo 4: Referenciar no Orchestrator (opcional)

Se o novo agente deve ser chamado pelo Orchestrator, edite `agents/orchestrator.md`:

```markdown
## Subagentes Disponíveis

| Agente | Função | Quando Usar |
|--------|--------|-------------|
...
| `meu-novo-agente` | [função] | [quando usar] |
```

---

## Modificar Comandos

### Estrutura de Comando

```markdown
---
name: nome-do-comando
description: O que o comando faz
argument-hint: "<arg1> [arg2]"
allowed-tools:
  - Tool1
  - Tool2
---

# /nome-do-comando

Instruções do comando...
```

### Adicionar Novo Comando

1. Crie `commands/meu-comando.md`
2. Defina frontmatter com name, description, argument-hint
3. Escreva instruções
4. Reinicie Claude Code

---

## Modificar Hooks

### Estrutura de Hooks

`hooks/hooks.json`:

```json
{
  "PreToolUse": [
    {
      "matcher": "regex_para_tool",
      "hooks": [
        {
          "type": "command",
          "command": "comando_a_executar",
          "timeout": 5
        }
      ]
    }
  ],
  "PostToolUse": [...],
  "SubagentStop": [...]
}
```

### Adicionar Novo Hook

Exemplo: Logar toda criação de workflow:

```json
{
  "PostToolUse": [
    {
      "matcher": "mcp__MCP_DOCKER__n8n_create_workflow",
      "hooks": [
        {
          "type": "command",
          "command": "powershell -Command \"Add-Content -Path 'workflow-history.log' -Value \\\"$(Get-Date): Workflow criado\\\"\"",
          "timeout": 5
        }
      ]
    }
  ]
}
```

---

## Modificar Tools de Agentes

### Restringir Tools

Para que um agente use MENOS tools, edite o frontmatter:

```yaml
tools:
  - Read
  - mcp__MCP_DOCKER__search_nodes
  # Removidas outras tools
```

### Expandir Tools

Para dar MAIS tools a um agente:

```yaml
tools:
  - Read
  - Write
  - Bash
  - mcp__MCP_DOCKER__search_nodes
  - mcp__MCP_DOCKER__nova_tool
```

**Atenção**: Mais tools = mais contexto consumido. Mantenha só o necessário.

---

## Modificar Skills dos Agentes

### Adicionar Skill

No system prompt do agente, adicione:

```markdown
## Skills Ativas

Você tem conhecimento das skills:
- `skill-existente`
- `nova-skill-adicionada`

### Nova Skill: [Nome]

[Conteúdo da skill]
```

### Criar Nova Skill

1. Crie pasta `skills/minha-skill/`
2. Crie `skills/minha-skill/SKILL.md`
3. Defina frontmatter e conteúdo

---

## Modificar Templates

### checkpoint.json

Template para estado de continuação. Modifique para adicionar campos:

```json
{
  "meuCampoCustom": "",
  "outrosDados": {}
}
```

### session-context.json

Template para contexto inicial. Adicione campos conforme necessidade.

---

## Dicas de Customização

### 1. Mantenha Separação de Contexto

Cada agente deve ter APENAS as tools/skills que precisa. Isso:
- Reduz uso de tokens
- Evita confusão do modelo
- Melhora performance

### 2. Use Examples na Description

A `description` do agente PRECISA ter `<example>` blocks para o Claude saber quando acionar:

```yaml
description: |
  Use quando [condição].

  <example>
  Context: [situação]
  user: "[pedido]"
  assistant: "[resposta]"
  <commentary>[motivo]</commentary>
  </example>
```

### 3. Teste Incrementalmente

Ao modificar um agente:
1. Faça uma mudança pequena
2. Teste
3. Se funcionar, faça próxima mudança
4. Repita

### 4. Documente Mudanças

Adicione comentários ou notas sobre suas customizações para referência futura.

---

## Revertendo Mudanças

Se algo quebrar:

1. **Backup**: Se você fez backup, restaure
2. **Re-download**: Copie novamente do original
3. **Git**: Se usando git, faça `git checkout -- arquivo`

---

## Exemplos de Customização

### Workflow de E-commerce

Adicione ao Node-Discoverer:

```markdown
## Nodes de E-commerce Prioritários

- nodes-base.shopify
- nodes-base.wooCommerce
- nodes-base.stripe
- nodes-base.paypal
```

### Integração com Empresa

Adicione agente customizado:

```markdown
---
name: empresa-integrator
description: |
  Use para integrar com sistemas internos da empresa.
---

# Integrador Empresa

Você conhece as APIs internas:
- API de Clientes: https://api.empresa.com/clientes
- API de Produtos: https://api.empresa.com/produtos

Sempre use autenticação OAuth2 com o token em $env.EMPRESA_TOKEN
```

### Workflow com Aprovação

Modifique o Builder para sempre pedir aprovação:

```markdown
## Processo de Aprovação

ANTES de criar ou modificar:
1. Mostre preview completo do que será feito
2. Pergunte: "Confirma esta operação? (sim/não/detalhes)"
3. Se "não": cancele e pergunte o que ajustar
4. Se "detalhes": explique cada node/conexão
5. Se "sim": execute
```
