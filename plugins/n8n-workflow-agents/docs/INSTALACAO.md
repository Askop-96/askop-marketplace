# Guia de Instalação Completo

Este guia explica como instalar e usar o framework de subagentes n8n em qualquer projeto.

---

## Pré-requisitos

Antes de instalar, certifique-se de ter:

1. **Claude Code** instalado e funcionando
2. **MCP do n8n** configurado (o servidor MCP que conecta ao n8n)
3. **n8n** rodando (local ou cloud)
4. **(Opcional)** Plugin Ralph Loop para execução iterativa

---

## Instalação

### Método 1: Plugin Global (Recomendado)

Instale uma vez e use em todos os projetos.

**Passo 1**: Copie a pasta do plugin

```powershell
# No PowerShell
Copy-Item -Recurse "C:\Users\Askop\Desktop\SubAgents_Criation\n8n-workflow-agents" "$env:USERPROFILE\.claude\plugins\"
```

**Passo 2**: Adicione ao settings.json global

Abra ou crie: `~/.claude/settings.json`

```json
{
  "plugins": [
    "~/.claude/plugins/n8n-workflow-agents"
  ]
}
```

**Passo 3**: Reinicie o Claude Code

---

### Método 2: Plugin por Projeto

Cada projeto tem sua própria cópia do plugin.

**Passo 1**: Copie para o projeto

```powershell
# Na pasta do seu projeto
Copy-Item -Recurse "C:\caminho\para\n8n-workflow-agents" ".\"
```

**Passo 2**: Crie settings.json no projeto

Crie: `.claude/settings.json` na raiz do projeto

```json
{
  "plugins": [
    "./n8n-workflow-agents"
  ]
}
```

---

## Configuração de Tokens (IMPORTANTE!)

O MCP do n8n tem 40+ ferramentas que consomem tokens. Configure ANTES de usar:

### Windows PowerShell

**Temporário** (só para esta sessão):
```powershell
$env:MAX_MCP_OUTPUT_TOKENS = 50000
$env:MCP_TIMEOUT = 30000
claude
```

**Permanente** (adicione ao $PROFILE):
```powershell
# Abra o profile
notepad $PROFILE

# Adicione estas linhas:
$env:MAX_MCP_OUTPUT_TOKENS = 50000
$env:MCP_TIMEOUT = 30000

# Salve e feche
```

### Linux/Mac

```bash
# Temporário
export MAX_MCP_OUTPUT_TOKENS=50000
export MCP_TIMEOUT=30000
claude

# Permanente (adicione ao ~/.bashrc ou ~/.zshrc)
echo 'export MAX_MCP_OUTPUT_TOKENS=50000' >> ~/.bashrc
echo 'export MCP_TIMEOUT=30000' >> ~/.bashrc
```

---

## Verificação da Instalação

Após instalar, verifique:

### 1. Plugin está carregado

Execute no Claude Code:
```
/help
```

Deve mostrar os comandos:
- `/n8n-workflow`
- `/n8n-validate`
- `/n8n-fix`

### 2. MCP do n8n está conectado

Peça ao Claude:
```
Verifique se o n8n está conectado
```

O Claude deve usar `n8n_health_check()` e mostrar status.

### 3. Teste básico

```
/n8n-workflow "Webhook simples que retorna Hello World"
```

---

## Usando com Ralph Loop

O Ralph Loop garante execução iterativa até completar.

### Se já tem Ralph Loop instalado

```bash
/ralph-loop "/n8n-workflow 'Descrição do workflow'" --completion-promise "WORKFLOW_COMPLETE" --max-iterations 30
```

### Se não tem Ralph Loop

Instale via marketplace de plugins do Claude Code, ou use sem ele:
```bash
/n8n-workflow "Descrição do workflow"
```

O framework funciona sem Ralph Loop, mas pode precisar de ajustes manuais se houver erros.

---

## Estrutura de Arquivos Durante Uso

Quando você executa `/n8n-workflow`, o sistema cria:

```
seu-projeto/
├── .n8n-session/              # Criado automaticamente
│   ├── context.json           # Contexto da sessão
│   ├── workflow-plan.md       # Plano do Architect
│   ├── nodes-discovered.json  # Nodes encontrados
│   ├── workflow-id.txt        # ID do workflow criado
│   ├── validation-result.json # Resultado da validação
│   ├── checkpoint.json        # Estado para continuação
│   └── execution-log.md       # Log de execução
```

Esses arquivos são usados para comunicação entre agentes e podem ser limpos após uso:

```powershell
# Limpar sessão
.\n8n-workflow-agents\scripts\cleanup-session.ps1
```

---

## Usando em Outro Projeto

### Se você já tem tudo organizado

1. **Copie a pasta** `n8n-workflow-agents` para o novo projeto
2. **Crie** `.claude/settings.json` com o caminho do plugin
3. **Configure** as variáveis de ambiente de tokens
4. **Use** os comandos `/n8n-workflow`, `/n8n-validate`, `/n8n-fix`

### Exemplo completo

```powershell
# 1. Vá para seu projeto
cd C:\MeuProjeto

# 2. Copie o plugin
Copy-Item -Recurse "C:\caminho\n8n-workflow-agents" ".\"

# 3. Crie configuração
mkdir .claude
@'
{
  "plugins": [
    "./n8n-workflow-agents"
  ]
}
'@ | Out-File -Encoding UTF8 ".claude\settings.json"

# 4. Inicie o Claude Code com tokens configurados
$env:MAX_MCP_OUTPUT_TOKENS = 50000
claude
```

---

## Customização

### Modificar um Agente

1. Abra o arquivo do agente em `agents/`
2. Modifique o system prompt conforme necessário
3. Salve o arquivo

Exemplo: Fazer o Builder SEMPRE pedir confirmação:

```markdown
# Em agents/builder.md, na seção de regras:

## Regras Importantes

1. **SEMPRE** peça confirmação antes de QUALQUER operação
...
```

### Adicionar Novo Agente

1. Crie `agents/meu-agente.md`
2. Adicione frontmatter com name, description, model, color, tools
3. Escreva o system prompt

### Mudar Idioma

Em cada arquivo de agente, localize:
```
Responda **SEMPRE em português brasileiro**.
```
E altere para o idioma desejado.

---

## Troubleshooting

### Plugin não carrega

1. Verifique o caminho no `settings.json`
2. Use caminho absoluto: `"C:/Users/.../n8n-workflow-agents"`
3. Reinicie o Claude Code

### Comandos não aparecem no /help

1. Verifique se `commands/` tem os arquivos .md
2. Verifique se o frontmatter está correto
3. Reinicie o Claude Code

### Agente não é acionado

1. Verifique a `description` no frontmatter do agente
2. A description precisa ter `<example>` blocks
3. Use o nome exato do agente ao invocar via Task

### Erro de tokens/contexto

1. Configure `MAX_MCP_OUTPUT_TOKENS = 50000`
2. O sistema de checkpoint salva progresso automaticamente
3. Se parar, execute novamente - continuará de onde parou

### n8n não conecta

1. Verifique se n8n está rodando
2. Verifique configuração do MCP Server
3. Execute `n8n_diagnostic()` para ver detalhes
4. Verifique API key

---

## Suporte

- Documentação: `docs/` nesta pasta
- Guia de agentes: `docs/agent-reference.md`
- Customização: `docs/customization-guide.md`
