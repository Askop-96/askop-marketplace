# Guia de Contribuição

Obrigado por considerar contribuir com o n8n-workflow-agents! Este documento fornece diretrizes para contribuir com o projeto.

---

## Sumário

1. [Como Contribuir](#como-contribuir)
2. [Configuração de Desenvolvimento](#configuração-de-desenvolvimento)
3. [Estrutura do Projeto](#estrutura-do-projeto)
4. [Padrões de Código](#padrões-de-código)
5. [Criando Agentes](#criando-agentes)
6. [Criando Comandos](#criando-comandos)
7. [Testando](#testando)
8. [Pull Requests](#pull-requests)
9. [Reportando Bugs](#reportando-bugs)
10. [Sugerindo Melhorias](#sugerindo-melhorias)

---

## Como Contribuir

### Tipos de Contribuição

- **Bug fixes:** Correções de problemas existentes
- **Novos agentes:** Adicionar agentes especializados
- **Novos comandos:** Criar comandos slash adicionais
- **Documentação:** Melhorar docs, exemplos, traduções
- **Testes:** Adicionar casos de teste
- **Performance:** Otimizações de tokens e velocidade

### Processo

1. **Fork** o repositório
2. **Clone** seu fork
3. **Crie uma branch** para sua feature
4. **Faça suas mudanças**
5. **Teste** localmente
6. **Commit** com mensagem descritiva
7. **Push** para seu fork
8. **Abra um Pull Request**

---

## Configuração de Desenvolvimento

### Pré-requisitos

- Claude Code instalado
- Node.js 18+
- n8n rodando (local ou cloud)
- MCP n8n configurado
- Git

### Setup

```bash
# 1. Fork e clone
git clone https://github.com/SEU_USUARIO/n8n-workflow-agents.git
cd n8n-workflow-agents

# 2. Crie branch de desenvolvimento
git checkout -b feature/minha-feature

# 3. Configure como plugin local (para testes)
# Adicione ao settings.json:
# "plugins": ["./caminho/para/n8n-workflow-agents"]

# 4. Configure variáveis de ambiente
export MAX_MCP_OUTPUT_TOKENS=50000
export MCP_TIMEOUT=30000
```

### Testando mudanças

```bash
# Reinicie Claude Code após cada mudança
# Teste os comandos e agentes modificados
```

---

## Estrutura do Projeto

```
n8n-workflow-agents/
├── .claude-plugin/
│   └── plugin.json         # Manifest - NÃO modificar estrutura
│
├── agents/                  # Agentes especializados
│   ├── orchestrator.md     # Coordenador (modificar com cuidado)
│   ├── architect.md        # Planejador
│   ├── node-discoverer.md  # Descobridor de nodes
│   ├── configurator.md     # Configurador
│   ├── builder.md          # Construtor
│   ├── validator.md        # Validador
│   ├── fixer.md            # Corretor
│   └── ai-specialist.md    # Especialista AI
│
├── commands/               # Comandos slash
│   ├── n8n-workflow.md    # /n8n-workflow
│   ├── n8n-validate.md    # /n8n-validate
│   └── n8n-fix.md         # /n8n-fix
│
├── hooks/
│   └── hooks.json         # Hooks de eventos
│
├── skills/                # Skills do plugin
│   └── n8n-agents-guide/
│       └── SKILL.md
│
├── scripts/              # Scripts utilitários
│   ├── init-session.ps1
│   └── cleanup-session.ps1
│
├── templates/            # Templates JSON
│   ├── checkpoint.json
│   └── session-context.json
│
└── docs/                # Documentação
    ├── INSTALLATION.md
    ├── USAGE.md
    ├── TROUBLESHOOTING.md
    ├── AGENTS.md
    └── MCP-TOOLS.md
```

---

## Padrões de Código

### Agentes (.md)

#### Frontmatter obrigatório

```yaml
---
name: nome-do-agente  # lowercase, hifenizado
description: |
  Descrição curta do agente.

  <example>
  Context: Quando usar
  user: "Prompt do usuário"
  assistant: "Resposta esperada"
  <commentary>
  Explicação de quando acionar
  </commentary>
  </example>

model: inherit  # ou específico: sonnet, opus, haiku
color: blue     # cor do agente na UI
tools:          # ferramentas disponíveis
  - Task
  - Read
  - Write
  - mcp__MCP_DOCKER__ferramenta
---
```

#### Estrutura do body

```markdown
# Nome do Agente

Descrição detalhada.

## Idioma

Responda **SEMPRE em português brasileiro**.

## Responsabilidades

1. Primeira responsabilidade
2. Segunda responsabilidade
...

## Processo de Trabalho

### 1. Primeiro passo
...

## Regras Importantes

1. **SEMPRE** faça X
2. **NUNCA** faça Y
...

## Formato de Resposta

```
Template de resposta esperada
```
```

### Comandos (.md)

```yaml
---
name: nome-comando
description: Descrição curta
argument-hint: "<arg1> [--flag]"
allowed-tools:
  - Task
  - Read
  - Write
---

# /nome-comando

Descrição do comando.

## Uso

```bash
/nome-comando <args>
```

## Fluxo de Execução

1. Passo 1
2. Passo 2
...
```

### Convenções

- Use **português brasileiro** em todos os textos
- Mantenha comentários em português
- Use markdown para formatação
- Siga o padrão existente de outros arquivos

---

## Criando Agentes

### Novo agente simples

1. Crie `agents/meu-agente.md`
2. Adicione frontmatter com name, description, model, color, tools
3. Escreva o system prompt seguindo o padrão
4. Teste invocando diretamente

### Checklist de agente

- [ ] Nome único e descritivo
- [ ] Description com `<example>` blocks
- [ ] Tools mínimas necessárias
- [ ] Idioma configurado
- [ ] Responsabilidades claras
- [ ] Processo de trabalho definido
- [ ] Regras importantes listadas
- [ ] Formato de resposta padronizado

### Integrando com Orchestrator

Se o novo agente deve ser parte do fluxo principal:

1. Adicione ao frontmatter do orchestrator
2. Documente quando acionar
3. Defina protocolo de comunicação via arquivos de sessão

---

## Criando Comandos

### Novo comando

1. Crie `commands/meu-comando.md`
2. Adicione frontmatter
3. Documente uso e fluxo
4. Teste com `/meu-comando`

### Checklist de comando

- [ ] Nome curto e memorável
- [ ] Descrição clara
- [ ] argument-hint útil
- [ ] allowed-tools definidas
- [ ] Exemplos de uso
- [ ] Tratamento de erros

---

## Testando

### Teste manual

```bash
# 1. Reinicie Claude Code
# 2. Verifique se comando aparece no /help
# 3. Execute o comando com diferentes inputs
# 4. Verifique logs em .n8n-session/
```

### Casos de teste sugeridos

| Cenário | Teste |
|---------|-------|
| Workflow simples | < 5 nodes |
| Workflow médio | 5-15 nodes |
| Workflow complexo | > 15 nodes |
| AI Agent | Com LangChain |
| Erro de validação | Campo faltando |
| Recovery | Interromper e continuar |

### Validando agentes

```bash
# Verificar se agente é acionado corretamente
"Use o meu-agente para fazer X"

# Verificar se não é acionado incorretamente
"Faça algo não relacionado ao agente"
```

---

## Pull Requests

### Antes de submeter

- [ ] Código segue os padrões
- [ ] Testado localmente
- [ ] Documentação atualizada
- [ ] Sem conflitos com main

### Template de PR

```markdown
## Descrição

Breve descrição do que foi feito.

## Tipo de mudança

- [ ] Bug fix
- [ ] Nova feature
- [ ] Melhoria de performance
- [ ] Documentação
- [ ] Outro: _______

## Como testar

1. Passo para testar
2. Outro passo
3. Resultado esperado

## Screenshots (se aplicável)

## Checklist

- [ ] Testei localmente
- [ ] Atualizei documentação
- [ ] Código segue padrões
```

### Review process

1. PR é criado
2. Revisão automática de estrutura
3. Revisão manual por mantenedor
4. Feedback/ajustes se necessário
5. Aprovação e merge

---

## Reportando Bugs

### Template de bug

```markdown
## Descrição do Bug

Descrição clara e concisa.

## Para Reproduzir

1. Execute '...'
2. Faça '...'
3. Veja erro

## Comportamento Esperado

O que deveria acontecer.

## Screenshots

Se aplicável.

## Ambiente

- OS: [Windows/Linux/Mac]
- Claude Code: [versão]
- n8n: [versão]
- Node.js: [versão]

## Logs

```
Cole logs relevantes aqui
```

## Contexto Adicional

Qualquer informação extra.
```

---

## Sugerindo Melhorias

### Template de feature

```markdown
## Problema/Motivação

Que problema isso resolve?

## Solução Proposta

Descrição da solução.

## Alternativas Consideradas

Outras abordagens pensadas.

## Impacto

- Quais agentes afeta?
- Mudança de API?
- Breaking changes?

## Disposição para implementar

- [ ] Sim, posso implementar
- [ ] Preciso de ajuda
- [ ] Apenas sugestão
```

---

## Código de Conduta

- Seja respeitoso
- Aceite feedback construtivo
- Foque na solução, não no problema
- Documente suas mudanças
- Teste antes de submeter

---

## Dúvidas?

- Abra uma Issue com label "question"
- Consulte a documentação existente
- Verifique Issues fechadas por respostas anteriores

---

Obrigado por contribuir!
