# Guia de Troubleshooting

Este guia cobre todos os problemas conhecidos do n8n-workflow-agents e suas soluções.

---

## Sumário

1. [Problemas de Instalação](#1-problemas-de-instalação)
2. [Problemas de Conexão](#2-problemas-de-conexão)
3. [Problemas de Execução](#3-problemas-de-execução)
4. [Problemas de Validação](#4-problemas-de-validação)
5. [Problemas de Performance](#5-problemas-de-performance)
6. [Problemas com AI Agents](#6-problemas-com-ai-agents)
7. [Logs e Diagnóstico](#7-logs-e-diagnóstico)
8. [FAQ](#8-faq)

---

## 1. Problemas de Instalação

### Plugin não aparece após instalação

**Sintoma:** Comandos `/n8n-workflow`, `/n8n-validate`, `/n8n-fix` não aparecem no `/help`

**Causas e Soluções:**

| Causa | Solução |
|-------|---------|
| Caminho incorreto no settings.json | Use caminho absoluto |
| Estrutura de pasta incorreta | Verifique se `.claude-plugin/plugin.json` existe |
| Claude Code não reiniciado | Feche e abra novamente |
| settings.json com erro de sintaxe | Valide o JSON |

**Verificação passo a passo:**

```powershell
# 1. Verificar estrutura
Get-ChildItem "$env:USERPROFILE\.claude\plugins\n8n-workflow-agents\.claude-plugin"
# Deve mostrar: plugin.json

# 2. Verificar settings.json
Get-Content "$env:USERPROFILE\.claude\settings.json"
# Deve conter o caminho do plugin

# 3. Testar com caminho absoluto
# No settings.json, use:
"plugins": ["C:/Users/SeuUsuario/.claude/plugins/n8n-workflow-agents"]
```

---

### Erro "Cannot find module"

**Sintoma:** Erro de módulo não encontrado ao carregar plugin

**Solução:**
```bash
# Verifique se Node.js está instalado
node --version

# Deve ser 18+
# Se não estiver, instale: https://nodejs.org/
```

---

### Erro de permissão na pasta

**Sintoma:** "Access denied" ou "Permission denied"

**Solução Windows:**
```powershell
# Execute PowerShell como Administrador
# Ou copie para outra pasta com permissão

# Verificar permissões
Get-Acl "$env:USERPROFILE\.claude\plugins\n8n-workflow-agents"
```

**Solução Linux/Mac:**
```bash
# Dar permissão de leitura/escrita
chmod -R 755 ~/.claude/plugins/n8n-workflow-agents
```

---

## 2. Problemas de Conexão

### MCP n8n não conecta

**Sintoma:** `n8n_health_check()` falha ou retorna erro

**Diagnóstico:**
```
Execute n8n_diagnostic() com verbose=true
```

**Causas comuns:**

#### n8n não está rodando

```bash
# Verificar se n8n está acessível
curl http://localhost:5678

# Se não responder, inicie o n8n:
n8n start

# Ou via Docker:
docker start n8n
```

#### API key inválida ou expirada

1. Acesse n8n > Settings > API
2. Verifique se a API key existe e está ativa
3. Crie uma nova se necessário
4. Atualize no MCP

#### URL incorreta

A URL deve ser:
- **Local:** `http://localhost:5678/api/v1`
- **Docker:** `http://host.docker.internal:5678/api/v1`
- **Cloud:** `https://sua-instancia.app.n8n.cloud/api/v1`

---

### Timeout nas requisições

**Sintoma:** "Request timeout" ou operações demoram muito

**Solução:**
```powershell
# Aumentar timeout
$env:MCP_TIMEOUT = 60000  # 60 segundos

# Para operações muito longas
$env:MCP_TIMEOUT = 120000  # 2 minutos
```

---

### Erro de certificado SSL

**Sintoma:** "UNABLE_TO_VERIFY_LEAF_SIGNATURE" ou erro de SSL

**Solução (desenvolvimento apenas):**
```bash
# Desabilitar verificação SSL (NÃO use em produção!)
export NODE_TLS_REJECT_UNAUTHORIZED=0
```

**Solução correta:**
- Instale certificado válido no n8n
- Use HTTP em desenvolvimento local

---

## 3. Problemas de Execução

### Erro "Token limit exceeded"

**Sintoma:** Execução para com erro de limite de tokens

**Soluções:**

1. **Aumentar limite:**
   ```powershell
   $env:MAX_MCP_OUTPUT_TOKENS = 100000
   ```

2. **Usar checkpoint:**
   - O sistema salva progresso automaticamente
   - Execute o mesmo comando novamente
   - Continuará de onde parou

3. **Dividir tarefa:**
   - Crie workflows menores
   - Adicione funcionalidades incrementalmente

---

### Agente não é acionado

**Sintoma:** Claude não usa o agente especializado

**Causas:**

1. **Description sem examples:** O agente precisa de `<example>` blocks

2. **Nome incorreto:** Use o nome exato do agente

3. **Plugin não carregado:** Verifique instalação

**Solução:**
```markdown
# Verifique se o frontmatter do agente tem:
description: |
  <example>
  Context: ...
  user: "..."
  assistant: "..."
  </example>
```

---

### Sessão corrompida

**Sintoma:** Erros estranhos ao continuar execução

**Solução:**
```powershell
# Limpar sessão e recomeçar
Remove-Item -Recurse ".n8n-session" -Force

# Ou usar script
.\n8n-workflow-agents\scripts\cleanup-session.ps1
```

---

### Erro "Workflow ID not found"

**Sintoma:** Não consegue encontrar workflow criado

**Causas:**
1. Workflow não foi criado (falha no Builder)
2. ID incorreto no arquivo
3. Workflow foi deletado

**Solução:**
```bash
# Listar workflows no n8n
"Liste todos os workflows"

# Ou via MCP
n8n_list_workflows()
```

---

## 4. Problemas de Validação

### Validação sempre falha

**Sintoma:** Validação reporta erros mesmo quando workflow parece correto

**Verificações:**

1. **Perfil muito rigoroso:**
   ```bash
   # Use perfil runtime em vez de strict
   "Valide com perfil runtime"
   ```

2. **False positives:**
   - Verifique se são realmente erros
   - Alguns alertas podem ser ignorados

3. **Campos dinâmicos:**
   - Expressões `{{ }}` não podem ser validadas estaticamente
   - São marcadas como "unvalidatable"

---

### Erro de expressão

**Sintoma:** "Invalid expression" ou "Expression syntax error"

**Erros comuns:**

| Erro | Problema | Solução |
|------|----------|---------|
| `{{ $json.field }}` em webhook | Dados estão em body | `{{ $json.body.field }}` |
| `{{ $json }}` em Code node | Expressões não funcionam em Code | Use `$json` direto |
| Aspas incorretas | Usando ' em vez de " | Use aspas duplas |
| Falta de fechamento | `{{ $json.field }` | `{{ $json.field }}` |

---

### Erro de conexão entre nodes

**Sintoma:** "Invalid connection" ou "Source node not found"

**Causas:**

1. **Nome do node incorreto:**
   - Use o nome EXATO do node (case sensitive)
   - Verifique se não tem espaços extras

2. **Node não existe:**
   - Verifique se o node foi criado
   - Use `n8n_get_workflow_structure()` para ver nodes

3. **Tipo de porta errado:**
   - Use `main` para conexões normais
   - Use `ai_*` para conexões AI

---

## 5. Problemas de Performance

### Execução muito lenta

**Sintoma:** Agentes demoram muito para responder

**Soluções:**

1. **Reduzir uso de get_node_info:**
   - Prefira `get_node_essentials` (5KB vs 100KB)

2. **Usar buscas paralelas:**
   - O framework faz isso automaticamente
   - Não interfira no fluxo

3. **Limpar cache:**
   ```bash
   # MCP tem cache de 15 min
   # Aguarde ou reinicie Claude Code
   ```

---

### Context overflow

**Sintoma:** "Context limit reached" ou CHECKPOINT frequente

**Soluções:**

1. **Workflows menores:**
   - Divida em partes
   - Crie incrementalmente

2. **Menos verbosidade:**
   - Não peça logs detalhados
   - Deixe o framework trabalhar

3. **Checkpoint:**
   - É normal em workflows grandes
   - Continue a execução

---

## 6. Problemas com AI Agents

### AI Agent não funciona

**Sintoma:** Workflow com AI não executa corretamente

**Verificações:**

1. **Language Model conectado:**
   ```
   Verifique se o AI Agent tem conexão ai_languageModel
   ```

2. **Credenciais de LLM:**
   - OpenAI API key configurada
   - Anthropic API key (se usar Claude)
   - Ollama rodando (se local)

3. **Conexões corretas:**
   - `ai_languageModel` (obrigatório)
   - `ai_tool` (opcional)
   - `ai_memory` (opcional)

---

### Erro de conexão AI

**Sintoma:** "Invalid AI connection" ou similar

**Solução:**
Conexões AI têm formato específico:

```json
{
  "type": "addConnection",
  "source": "OpenAI Chat Model",
  "target": "AI Agent",
  "sourcePort": "ai_languageModel",
  "targetPort": "ai_languageModel"
}
```

---

### Tools não funcionam

**Sintoma:** AI Agent não usa as tools configuradas

**Verificações:**

1. Tools conectadas via `ai_tool`
2. Tools têm descrição clara
3. Modelo suporta tool use

---

## 7. Logs e Diagnóstico

### Onde encontrar logs

| Log | Localização | Conteúdo |
|-----|-------------|----------|
| Execução | `.n8n-session/execution-log.md` | Ações dos agentes |
| Validação | `.n8n-session/validation-result.json` | Erros e warnings |
| Checkpoint | `.n8n-session/checkpoint.json` | Estado de progresso |

### Comandos de diagnóstico

```bash
# Diagnóstico do MCP
"Execute n8n_diagnostic() com verbose=true"

# Status do n8n
"Execute n8n_health_check()"

# Listar ferramentas disponíveis
"Execute n8n_list_available_tools()"

# Estatísticas do banco
"Execute get_database_statistics()"
```

### Habilitando logs detalhados

```bash
# Durante criação de workflow
"Crie o workflow com logs detalhados de cada passo"

# O execution-log.md terá mais detalhes
```

---

## 8. FAQ

### Por que meu workflow foi criado inativo?

**Resposta:** Todos os workflows são criados inativos por segurança. Ative manualmente no n8n após verificar que está correto.

---

### Posso editar o workflow criado no n8n?

**Resposta:** Sim! O workflow é totalmente editável na UI do n8n. O framework apenas cria a estrutura inicial.

---

### Como atualizo o plugin?

**Resposta:**
```bash
# Via git
cd ~/.claude/plugins/n8n-workflow-agents
git pull

# Ou baixe novamente e substitua
```

---

### O plugin funciona com n8n Cloud?

**Resposta:** Sim, desde que o MCP esteja configurado com a URL e API key corretas do n8n Cloud.

---

### Posso usar com outros idiomas além de português?

**Resposta:** Sim! Edite cada arquivo de agente em `agents/` e altere a linha:
```markdown
Responda **SEMPRE em português brasileiro**.
```

---

### Quantos workflows posso criar por sessão?

**Resposta:** Não há limite. Recomenda-se limpar a sessão entre workflows grandes para evitar contexto poluído.

---

### O framework modifica workflows existentes?

**Resposta:** Somente se você usar `/n8n-fix` ou pedir explicitamente. `/n8n-workflow` sempre cria novos.

---

### Como reportar um bug?

**Resposta:**
1. Verifique se não está neste guia
2. Colete informações:
   - Sistema operacional
   - Versões (Claude Code, n8n, Node.js)
   - Erro completo
   - Passos para reproduzir
3. Abra Issue no GitHub

---

## Comandos de Reset

Se nada funcionar, reset completo:

```powershell
# 1. Limpar sessão
Remove-Item -Recurse ".n8n-session" -Force

# 2. Reiniciar Claude Code
# Feche todas as janelas e abra novamente

# 3. Verificar variáveis de ambiente
$env:MAX_MCP_OUTPUT_TOKENS
$env:MCP_TIMEOUT

# 4. Testar conexão básica
# No Claude Code:
"Verifique a conexão com o n8n"
```

---

## Suporte

Se o problema persistir após seguir este guia:

1. **Issues do GitHub:** Abra um issue detalhado
2. **Logs:** Inclua execution-log.md e validation-result.json
3. **Reprodução:** Descreva exatamente como reproduzir o problema
