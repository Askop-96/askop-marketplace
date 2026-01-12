<p align="center">
  <img src="https://img.shields.io/badge/version-1.0.0-blue.svg" alt="Version">
  <img src="https://img.shields.io/badge/license-MIT-green.svg" alt="License">
  <img src="https://img.shields.io/badge/claude--code-plugin-purple.svg" alt="Claude Code Plugin">
  <img src="https://img.shields.io/badge/n8n-compatible-orange.svg" alt="n8n Compatible">
</p>

# n8n Workflow Agents

**Framework de 8 subagentes especializados para criar, validar e corrigir workflows n8n com Claude Code.**

Um sistema de agentes autônomos que automatiza a criação de workflows n8n complexos, desde o planejamento até a validação, usando inteligência artificial e o poder do Claude Code.

---

## Highlights

- **8 Agentes Especializados** - Cada agente tem uma função específica e contexto otimizado
- **Separação de Contexto** - Máxima eficiência de tokens com agentes focados
- **Validação Automática** - Loop de validação/correção até o workflow funcionar
- **Templates First** - Busca templates existentes antes de criar do zero
- **AI Agents Ready** - Suporte completo para workflows com LangChain/AI
- **Integração Ralph Loop** - Execução iterativa até conclusão

---

## Requisitos

| Componente | Versão Mínima | Obrigatório |
|------------|---------------|-------------|
| **Claude Code** | Latest | Sim |
| **MCP n8n** | Configurado e funcionando | Sim |
| **n8n** | 1.0+ (local ou cloud) | Sim |
| **Node.js** | 18+ | Sim |
| **Ralph Loop Plugin** | Latest | Não (recomendado) |

### MCP n8n

Este plugin **depende** do MCP Server do n8n estar configurado no Claude Code. O MCP fornece as 40+ ferramentas necessárias para interagir com o n8n.

Verifique se está funcionando:
```bash
# No Claude Code, pergunte:
"Verifique a conexão com o n8n"
# Claude deve executar n8n_health_check() com sucesso
```

---

## Instalação Rápida

### Via GitHub (Recomendado)

```bash
# 1. Clone o repositório
git clone https://github.com/SEU_USUARIO/n8n-workflow-agents.git

# 2. Copie para a pasta de plugins do Claude Code
# Windows
copy -Recurse n8n-workflow-agents "$env:USERPROFILE\.claude\plugins\"

# Linux/Mac
cp -r n8n-workflow-agents ~/.claude/plugins/
```

### Configuração

1. **Adicione ao settings.json** (`~/.claude/settings.json`):

```json
{
  "plugins": [
    "~/.claude/plugins/n8n-workflow-agents"
  ]
}
```

2. **Configure variáveis de ambiente** (IMPORTANTE):

```bash
# Windows PowerShell (adicione ao $PROFILE)
$env:MAX_MCP_OUTPUT_TOKENS = 50000
$env:MCP_TIMEOUT = 30000

# Linux/Mac (adicione ao ~/.bashrc ou ~/.zshrc)
export MAX_MCP_OUTPUT_TOKENS=50000
export MCP_TIMEOUT=30000
```

3. **Reinicie o Claude Code**

Veja o [Guia de Instalação Completo](docs/INSTALLATION.md) para instruções detalhadas.

---

## Uso

### Criar Workflow

```bash
# Workflow simples
/n8n-workflow "Webhook que envia mensagem para Slack"

# Workflow com AI Agent
/n8n-workflow "Chatbot inteligente que responde perguntas sobre documentos"

# Com Ralph Loop (execução iterativa)
/ralph-loop "/n8n-workflow 'API REST completa'" --completion-promise "WORKFLOW_COMPLETE" --max-iterations 30
```

### Validar Workflow Existente

```bash
/n8n-validate abc123
```

### Corrigir Erros

```bash
/n8n-fix abc123
```

Veja o [Guia de Uso Completo](docs/USAGE.md) para mais exemplos.

---

## Os 8 Agentes

| Agente | Cor | Função | Quando é Acionado |
|--------|-----|--------|-------------------|
| **Orchestrator** | Azul | Coordena todo o fluxo | Sempre (entrada principal) |
| **Architect** | Ciano | Planeja estrutura, busca templates | Workflows médios/complexos |
| **Node-Discoverer** | Verde | Encontra nodes apropriados | Sempre |
| **Configurator** | Amarelo | Configura parâmetros dos nodes | Workflows médios/complexos |
| **Builder** | Magenta | Cria workflow no n8n | Sempre |
| **Validator** | Vermelho | Valida e identifica erros | Sempre (após build) |
| **Fixer** | Amarelo | Corrige erros automaticamente | Quando validação falha |
| **AI-Specialist** | Magenta | Configura AI Agents/LangChain | Workflows com AI |

### Fluxo de Execução

```
Workflow Simples (< 5 nodes):
Orchestrator → Node-Discoverer → Builder → Validator

Workflow Médio (5-15 nodes):
Orchestrator → Architect → Node-Discoverer → Configurator → Builder → Validator

Workflow Complexo (> 15 nodes ou AI):
Orchestrator → Architect → Node-Discoverer → AI-Specialist → Configurator → Builder → Validator → Fixer
```

---

## Estrutura do Plugin

```
n8n-workflow-agents/
├── .claude-plugin/
│   └── plugin.json           # Manifest do plugin
├── agents/                   # 8 agentes especializados
│   ├── orchestrator.md       # Coordenador central
│   ├── architect.md          # Planejador de estrutura
│   ├── node-discoverer.md    # Descobridor de nodes
│   ├── configurator.md       # Configurador de parâmetros
│   ├── builder.md            # Construtor de workflows
│   ├── validator.md          # Validador
│   ├── fixer.md              # Corretor de erros
│   └── ai-specialist.md      # Especialista em AI
├── commands/                 # Comandos slash
│   ├── n8n-workflow.md       # /n8n-workflow
│   ├── n8n-validate.md       # /n8n-validate
│   └── n8n-fix.md            # /n8n-fix
├── hooks/
│   └── hooks.json            # Hooks de validação
├── skills/
│   └── n8n-agents-guide/
│       └── SKILL.md          # Guia de uso
├── scripts/
│   ├── init-session.ps1      # Inicializar sessão
│   └── cleanup-session.ps1   # Limpar sessão
├── templates/
│   ├── checkpoint.json       # Template de checkpoint
│   └── session-context.json  # Template de contexto
└── docs/
    ├── INSTALLATION.md       # Guia de instalação
    ├── USAGE.md              # Guia de uso
    ├── TROUBLESHOOTING.md    # Solução de problemas
    ├── AGENTS.md             # Referência de agentes
    └── MCP-TOOLS.md          # Referência de ferramentas MCP
```

---

## Sistema de Sessão

Durante a execução, o framework cria uma pasta `.n8n-session/` para comunicação entre agentes:

```
.n8n-session/
├── context.json           # Requisitos do usuário
├── workflow-plan.md       # Plano do Architect
├── nodes-discovered.json  # Nodes encontrados
├── workflow-id.txt        # ID do workflow criado
├── validation-result.json # Resultado da validação
├── checkpoint.json        # Estado para continuação
└── execution-log.md       # Log de execução
```

Limpe após uso:
```bash
# Windows
.\n8n-workflow-agents\scripts\cleanup-session.ps1

# Linux/Mac
./n8n-workflow-agents/scripts/cleanup-session.sh
```

---

## Integração com Ralph Loop

Para execução iterativa até o workflow estar completo:

```bash
/ralph-loop "/n8n-workflow 'Descrição detalhada'" --completion-promise "WORKFLOW_COMPLETE" --max-iterations 30
```

### Completion Promises

| Promise | Significado |
|---------|-------------|
| `ARCHITECTURE_READY` | Planejamento concluído |
| `NODES_DISCOVERED` | Nodes identificados |
| `NODES_CONFIGURED` | Parâmetros configurados |
| `WORKFLOW_BUILT` | Workflow criado no n8n |
| `VALIDATION_PASSED` | Sem erros de validação |
| `WORKFLOW_COMPLETE` | Tudo pronto |
| `BLOCKED_NEEDS_HELP` | Precisa intervenção |

---

## Skills do n8n (Recomendadas)

Para máxima eficiência, instale também as skills do n8n:

| Skill | Função |
|-------|--------|
| `n8n-workflow-patterns` | Padrões arquiteturais |
| `n8n-mcp-tools-expert` | Uso correto das ferramentas MCP |
| `n8n-node-configuration` | Configuração de nodes |
| `n8n-expression-syntax` | Sintaxe de expressões `{{}}` |
| `n8n-validation-expert` | Interpretação de erros |
| `n8n-code-javascript` | Code nodes JS |
| `n8n-code-python` | Code nodes Python |

---

## Troubleshooting

### Plugin não aparece

```bash
# Verifique se o caminho está correto no settings.json
# Use caminho absoluto se necessário
"plugins": ["C:/Users/SeuUsuario/.claude/plugins/n8n-workflow-agents"]
```

### MCP não conecta

```bash
# Verifique se n8n está rodando
# Execute no Claude Code:
"Execute n8n_diagnostic()"
```

### Erro de tokens

```bash
# Configure tokens maiores
$env:MAX_MCP_OUTPUT_TOKENS = 50000
```

Veja o [Guia de Troubleshooting Completo](docs/TROUBLESHOOTING.md).

---

## Customização

### Modificar Idioma

Em cada arquivo de agente (`agents/*.md`), localize:
```markdown
Responda **SEMPRE em português brasileiro**.
```
E altere para o idioma desejado.

### Adicionar Novo Agente

1. Crie `agents/meu-agente.md`
2. Adicione frontmatter com name, description, model, color, tools
3. Escreva o system prompt
4. O agente será automaticamente descoberto

Veja o [Guia de Customização](docs/customization-guide.md).

---

## Contribuindo

Contribuições são bem-vindas! Por favor, leia o [CONTRIBUTING.md](CONTRIBUTING.md).

### Como Contribuir

1. Fork o repositório
2. Crie uma branch para sua feature (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'Adiciona MinhaFeature'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abra um Pull Request

---

## Licença

Este projeto está licenciado sob a MIT License - veja o arquivo [LICENSE](LICENSE) para detalhes.

---

## Links Úteis

- [Documentação do n8n](https://docs.n8n.io/)
- [Claude Code](https://claude.ai/claude-code)
- [MCP Protocol](https://modelcontextprotocol.io/)

---

<p align="center">
  Feito com by Claude Code + n8n
</p>
