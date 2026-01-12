# Guia de Instalação Completo

Este guia detalha todas as etapas para instalar e configurar o n8n-workflow-agents, incluindo possíveis erros e como resolvê-los.

---

## Sumário

1. [Pré-requisitos](#1-pré-requisitos)
2. [Verificação do Ambiente](#2-verificação-do-ambiente)
3. [Instalação do Plugin](#3-instalação-do-plugin)
4. [Configuração de Tokens](#4-configuração-de-tokens)
5. [Habilitando o Plugin](#5-habilitando-o-plugin)
6. [Verificação da Instalação](#6-verificação-da-instalação)
7. [Configuração do MCP n8n](#7-configuração-do-mcp-n8n)
8. [Instalação do Ralph Loop (Opcional)](#8-instalação-do-ralph-loop-opcional)
9. [Erros Comuns e Soluções](#9-erros-comuns-e-soluções)

---

## 1. Pré-requisitos

### Obrigatórios

| Componente | Como Verificar | Link de Instalação |
|------------|----------------|-------------------|
| **Claude Code** | `claude --version` | [Download](https://claude.ai/claude-code) |
| **Node.js 18+** | `node --version` | [Download](https://nodejs.org/) |
| **n8n** | Acessar UI do n8n | [Docs](https://docs.n8n.io/hosting/) |
| **MCP n8n** | Ver seção 7 | Configurar no Claude Code |

### Opcionais (Recomendados)

| Componente | Função |
|------------|--------|
| **Ralph Loop Plugin** | Execução iterativa até conclusão |
| **Git** | Clonar e atualizar o repositório |

---

## 2. Verificação do Ambiente

### Windows PowerShell

```powershell
# Verificar Claude Code
claude --version
# Esperado: alguma versão como "claude 1.x.x"

# Verificar Node.js
node --version
# Esperado: v18.x.x ou superior

# Verificar se n8n está rodando (se local)
Invoke-WebRequest -Uri "http://localhost:5678" -UseBasicParsing
# Esperado: StatusCode 200
```

### Linux/Mac

```bash
# Verificar Claude Code
claude --version

# Verificar Node.js
node --version

# Verificar n8n
curl -I http://localhost:5678
# Esperado: HTTP/1.1 200 OK
```

**Se algum componente não estiver instalado, instale antes de continuar.**

---

## 3. Instalação do Plugin

### Método A: Via Git (Recomendado)

```bash
# 1. Clone o repositório
git clone https://github.com/SEU_USUARIO/n8n-workflow-agents.git

# 2. Copie para a pasta de plugins
```

**Windows PowerShell:**
```powershell
# Criar pasta de plugins se não existir
if (-not (Test-Path "$env:USERPROFILE\.claude\plugins")) {
    New-Item -ItemType Directory -Path "$env:USERPROFILE\.claude\plugins" -Force
}

# Copiar o plugin
Copy-Item -Recurse "n8n-workflow-agents" "$env:USERPROFILE\.claude\plugins\"

# Verificar
Get-ChildItem "$env:USERPROFILE\.claude\plugins\n8n-workflow-agents"
```

**Linux/Mac:**
```bash
# Criar pasta de plugins se não existir
mkdir -p ~/.claude/plugins

# Copiar o plugin
cp -r n8n-workflow-agents ~/.claude/plugins/

# Verificar
ls ~/.claude/plugins/n8n-workflow-agents
```

### Método B: Download Manual

1. Baixe o ZIP do repositório
2. Extraia o conteúdo
3. Copie a pasta `n8n-workflow-agents` para `~/.claude/plugins/`

### Método C: Por Projeto (Local)

Se preferir ter o plugin apenas em um projeto específico:

```bash
# Na raiz do seu projeto
cp -r /caminho/para/n8n-workflow-agents ./
```

---

## 4. Configuração de Tokens

**CRÍTICO**: O MCP do n8n tem 40+ ferramentas que consomem muitos tokens. Configure ANTES de usar!

### Windows PowerShell

**Temporário (apenas sessão atual):**
```powershell
$env:MAX_MCP_OUTPUT_TOKENS = 50000
$env:MCP_TIMEOUT = 30000
claude  # Inicie o Claude Code
```

**Permanente (recomendado):**
```powershell
# Abrir o arquivo de profile
notepad $PROFILE

# Se o arquivo não existir, crie:
if (-not (Test-Path $PROFILE)) {
    New-Item -Path $PROFILE -ItemType File -Force
}
notepad $PROFILE
```

Adicione ao arquivo:
```powershell
# Configurações para n8n-workflow-agents
$env:MAX_MCP_OUTPUT_TOKENS = 50000
$env:MCP_TIMEOUT = 30000
```

Salve e feche. Para aplicar imediatamente:
```powershell
. $PROFILE
```

### Linux/Mac

**Temporário:**
```bash
MAX_MCP_OUTPUT_TOKENS=50000 MCP_TIMEOUT=30000 claude
```

**Permanente (bash):**
```bash
echo 'export MAX_MCP_OUTPUT_TOKENS=50000' >> ~/.bashrc
echo 'export MCP_TIMEOUT=30000' >> ~/.bashrc
source ~/.bashrc
```

**Permanente (zsh):**
```bash
echo 'export MAX_MCP_OUTPUT_TOKENS=50000' >> ~/.zshrc
echo 'export MCP_TIMEOUT=30000' >> ~/.zshrc
source ~/.zshrc
```

---

## 5. Habilitando o Plugin

### Opção A: Global (Todos os Projetos)

Edite ou crie `~/.claude/settings.json`:

**Windows:** `C:\Users\SeuUsuario\.claude\settings.json`
**Linux/Mac:** `~/.claude/settings.json`

```json
{
  "plugins": [
    "~/.claude/plugins/n8n-workflow-agents"
  ]
}
```

### Opção B: Por Projeto

Na raiz do projeto, crie `.claude/settings.json`:

```json
{
  "plugins": [
    "./n8n-workflow-agents"
  ]
}
```

### Sintaxe do Caminho

| Sistema | Formato |
|---------|---------|
| Windows | `C:/Users/Usuario/.claude/plugins/n8n-workflow-agents` |
| Windows (home) | `~/.claude/plugins/n8n-workflow-agents` |
| Linux/Mac | `~/.claude/plugins/n8n-workflow-agents` |
| Relativo | `./n8n-workflow-agents` |

**Dica:** Use barras normais `/` mesmo no Windows. O Claude Code aceita ambos.

---

## 6. Verificação da Instalação

### Passo 1: Reinicie o Claude Code

```bash
# Feche qualquer instância do Claude Code
# Abra novamente
claude
```

### Passo 2: Verifique os Comandos

```bash
/help
```

Deve mostrar os comandos:
- `/n8n-workflow` - Criar workflow n8n
- `/n8n-validate` - Validar workflow
- `/n8n-fix` - Corrigir erros

### Passo 3: Verifique a Conexão MCP

No Claude Code, pergunte:
```
Verifique a conexão com o n8n
```

O Claude deve executar `n8n_health_check()` e mostrar status de conexão.

### Passo 4: Teste Básico

```bash
/n8n-workflow "Webhook simples que retorna Hello World"
```

---

## 7. Configuração do MCP n8n

Se o MCP do n8n não estiver configurado, siga estes passos:

### 7.1 Verifique se o MCP está disponível

No Claude Code:
```
Liste as ferramentas MCP disponíveis que começam com n8n_
```

Se não encontrar nenhuma, o MCP não está configurado.

### 7.2 Configuração do MCP

O MCP do n8n deve estar configurado no seu ambiente Claude Code. A configuração depende de como você instalou o servidor MCP.

**Exemplo de configuração típica:**

```json
{
  "mcpServers": {
    "n8n": {
      "command": "node",
      "args": ["/path/to/n8n-mcp-server/index.js"],
      "env": {
        "N8N_API_URL": "http://localhost:5678/api/v1",
        "N8N_API_KEY": "sua-api-key-aqui"
      }
    }
  }
}
```

### 7.3 Obter API Key do n8n

1. Acesse o n8n (http://localhost:5678)
2. Vá em **Settings** > **API**
3. Clique em **Create API Key**
4. Copie a chave gerada

### 7.4 Verificar Conectividade

No Claude Code:
```
Execute n8n_diagnostic() e mostre o resultado
```

---

## 8. Instalação do Ralph Loop (Opcional)

O Ralph Loop permite execução iterativa até o workflow estar completo.

### Via Marketplace Claude Code

1. Abra o Claude Code
2. Vá em configurações de plugins
3. Procure por "ralph-loop"
4. Instale

### Uso com n8n-workflow-agents

```bash
/ralph-loop "/n8n-workflow 'Workflow complexo'" --completion-promise "WORKFLOW_COMPLETE" --max-iterations 30
```

---

## 9. Erros Comuns e Soluções

### Erro: "Plugin not found"

**Causa:** Caminho incorreto no settings.json

**Solução:**
```json
// Use caminho absoluto
{
  "plugins": [
    "C:/Users/SeuUsuario/.claude/plugins/n8n-workflow-agents"
  ]
}
```

---

### Erro: "Commands not showing in /help"

**Causa:** Plugin não foi carregado corretamente

**Solução:**
1. Verifique se a pasta `.claude-plugin` existe dentro do plugin
2. Verifique se `plugin.json` está correto
3. Reinicie o Claude Code

```bash
# Verificar estrutura
ls ~/.claude/plugins/n8n-workflow-agents/.claude-plugin/
# Deve mostrar: plugin.json
```

---

### Erro: "MCP timeout" ou "Token limit exceeded"

**Causa:** Configurações de token insuficientes

**Solução:**
```powershell
# Windows
$env:MAX_MCP_OUTPUT_TOKENS = 100000  # Aumente se necessário
$env:MCP_TIMEOUT = 60000  # 60 segundos

# Linux/Mac
export MAX_MCP_OUTPUT_TOKENS=100000
export MCP_TIMEOUT=60000
```

---

### Erro: "n8n_health_check failed"

**Causa:** n8n não está rodando ou MCP não configurado

**Soluções:**

1. **Verifique se n8n está rodando:**
   ```bash
   curl http://localhost:5678
   ```

2. **Verifique a API key:**
   - Acesse n8n > Settings > API
   - Confirme que a API key está válida

3. **Verifique a URL do n8n no MCP:**
   - Deve ser `http://localhost:5678/api/v1` para instalação local
   - Para n8n Cloud, use a URL da sua instância

---

### Erro: "Agent not triggered"

**Causa:** Description do agente não tem examples corretos

**Solução:**
1. Verifique se o arquivo do agente tem bloco `<example>` válido
2. Reinicie o Claude Code

---

### Erro: "Cannot create .n8n-session folder"

**Causa:** Permissões de escrita no diretório

**Solução:**
```bash
# Verifique permissões
ls -la .

# Crie manualmente se necessário
mkdir .n8n-session
```

---

### Erro: "settings.json syntax error"

**Causa:** JSON malformado

**Solução:**
Verifique a sintaxe do JSON:
```json
{
  "plugins": [
    "~/.claude/plugins/n8n-workflow-agents"
  ]
}
```

**Pontos de atenção:**
- Vírgulas no lugar certo
- Aspas duplas (não simples)
- Sem vírgula após o último item do array

---

### Erro: "Workflow creation failed"

**Causa:** Erro na configuração de nodes

**Soluções:**

1. **Verifique logs:**
   ```
   Leia o arquivo .n8n-session/execution-log.md
   ```

2. **Execute diagnóstico:**
   ```
   Execute n8n_diagnostic() com verbose=true
   ```

3. **Verifique credenciais:**
   - Nodes como Slack, Gmail precisam de credenciais configuradas no n8n

---

### Erro: "Context overflow" ou "CHECKPOINT"

**Causa:** Tarefa muito grande para um único agente

**Solução:**
- O sistema de checkpoint salva o progresso automaticamente
- Execute novamente o mesmo comando
- O agente continuará de onde parou

---

## Checklist de Instalação

Use esta lista para verificar se tudo está configurado:

- [ ] Claude Code instalado e funcionando
- [ ] Node.js 18+ instalado
- [ ] n8n rodando (local ou cloud)
- [ ] MCP n8n configurado com API key
- [ ] Plugin copiado para `~/.claude/plugins/`
- [ ] `settings.json` configurado com caminho do plugin
- [ ] Variáveis de ambiente configuradas (`MAX_MCP_OUTPUT_TOKENS`, `MCP_TIMEOUT`)
- [ ] Claude Code reiniciado
- [ ] Comandos `/n8n-workflow`, `/n8n-validate`, `/n8n-fix` aparecem no `/help`
- [ ] `n8n_health_check()` retorna sucesso

---

## Próximos Passos

Após a instalação bem-sucedida:

1. Leia o [Guia de Uso](USAGE.md) para aprender os comandos
2. Consulte [Troubleshooting](TROUBLESHOOTING.md) se encontrar problemas
3. Veja [Referência de Agentes](AGENTS.md) para entender cada agente

---

## Suporte

Se encontrar problemas não listados aqui:

1. Verifique os [Issues](https://github.com/SEU_USUARIO/n8n-workflow-agents/issues) do repositório
2. Abra um novo Issue com:
   - Sistema operacional
   - Versão do Claude Code
   - Versão do n8n
   - Erro completo
   - Passos para reproduzir
