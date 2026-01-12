<p align="center">
  <h1 align="center">Askop Marketplace</h1>
  <p align="center">
    <strong>Coleção curada de plugins poderosos para Claude Code</strong>
  </p>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/plugins-1-blue.svg" alt="Plugins">
  <img src="https://img.shields.io/badge/version-1.0.0-green.svg" alt="Version">
  <img src="https://img.shields.io/badge/claude--code-marketplace-purple.svg" alt="Claude Code">
  <img src="https://img.shields.io/badge/license-MIT-orange.svg" alt="License">
</p>

---

## Instalação

### Adicionar o Marketplace

```bash
/plugin marketplace add https://github.com/Askop-96/askop-marketplace
```

### Instalar um Plugin

```bash
/plugin install <nome-do-plugin>@askop-marketplace
```

---

## Plugins Disponíveis

### n8n-workflow-agents

**Framework de 8 subagentes especializados para n8n**

Automatize a criação de workflows n8n complexos com inteligência artificial. O framework utiliza 8 agentes especializados que trabalham em conjunto para planejar, construir, validar e corrigir workflows.

| Comando | Descrição |
|---------|-----------|
| `/n8n-workflow` | Criar workflow n8n completo |
| `/n8n-validate` | Validar workflow existente |
| `/n8n-fix` | Corrigir erros automaticamente |

**Características:**
- 8 agentes especializados com contexto otimizado
- Suporte a AI Agents (LangChain)
- Loop automático de validação/correção
- Busca inteligente de templates
- Integração com Ralph Loop

**Instalar:**
```bash
/plugin install n8n-workflow-agents@askop-marketplace
```

**Documentação:** [plugins/n8n-workflow-agents](./plugins/n8n-workflow-agents/)

---

## Requisitos

| Plugin | Requisitos |
|--------|------------|
| n8n-workflow-agents | MCP n8n configurado, n8n rodando |

---

## Estrutura do Marketplace

```
askop-marketplace/
├── .claude-plugin/
│   └── marketplace.json      # Manifest do marketplace
├── plugins/
│   └── n8n-workflow-agents/  # Plugin de workflows n8n
│       ├── .claude-plugin/
│       │   └── plugin.json
│       ├── agents/           # 8 agentes especializados
│       ├── commands/         # Comandos slash
│       ├── hooks/            # Hooks de eventos
│       ├── skills/           # Skills do plugin
│       └── docs/             # Documentação
└── README.md
```

---

## Configuração Recomendada

Antes de usar os plugins, configure:

```bash
# Windows PowerShell (adicione ao $PROFILE)
$env:MAX_MCP_OUTPUT_TOKENS = 50000
$env:MCP_TIMEOUT = 30000

# Linux/Mac (adicione ao ~/.bashrc ou ~/.zshrc)
export MAX_MCP_OUTPUT_TOKENS=50000
export MCP_TIMEOUT=30000
```

---

## Adicionar Novo Plugin (Desenvolvedores)

1. Crie a pasta do plugin em `plugins/seu-plugin/`
2. Adicione `.claude-plugin/plugin.json`
3. Adicione entrada no `marketplace.json`
4. Faça PR ou push

---

## Contribuindo

Contribuições são bem-vindas! Veja o guia de contribuição em cada plugin.

---

## Licença

MIT License - Veja [LICENSE](LICENSE) para detalhes.

---

<p align="center">
  <sub>Feito com Claude Code</sub>
</p>
