# init-session.ps1
# Script para inicializar sessão de trabalho n8n

param(
    [string]$SessionId = (New-Guid).ToString().Substring(0, 8),
    [string]$UserRequest = ""
)

$SessionPath = ".n8n-session"

# Criar diretório de sessão
if (-not (Test-Path $SessionPath)) {
    New-Item -ItemType Directory -Path $SessionPath -Force | Out-Null
    Write-Host "✅ Sessão criada: $SessionPath" -ForegroundColor Green
} else {
    Write-Host "📁 Sessão existente encontrada" -ForegroundColor Yellow
}

# Criar arquivo de contexto inicial
$contextFile = Join-Path $SessionPath "context.json"
$context = @{
    createdAt = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
    sessionId = $SessionId
    userRequest = @{
        original = $UserRequest
        interpreted = ""
        clarifications = @()
    }
    complexity = @{
        level = "pending"
        estimatedNodes = 0
        hasAI = $false
        hasDatabase = $false
        hasMultipleOutputs = $false
    }
    pattern = @{
        identified = ""
        confidence = 0
        alternatives = @()
    }
    template = @{
        used = $false
        id = ""
        name = ""
        author = ""
        url = ""
    }
    agents = @{
        planned = @()
        executed = @()
        current = ""
    }
    ralphLoop = @{
        enabled = $false
        maxIterations = 20
        currentIteration = 0
        completionPromise = "WORKFLOW_COMPLETE"
    }
    n8nConnection = @{
        healthy = $false
        apiConfigured = $false
        baseUrl = ""
        lastCheck = ""
    }
    outputs = @{
        workflowId = ""
        workflowName = ""
        nodesCount = 0
        validationStatus = ""
        createdAt = ""
    }
}

$context | ConvertTo-Json -Depth 10 | Set-Content $contextFile -Encoding UTF8
Write-Host "📝 Contexto criado: $contextFile" -ForegroundColor Cyan

# Criar arquivo de log de execução
$logFile = Join-Path $SessionPath "execution-log.md"
$logContent = @"
# Log de Execução - Sessão $SessionId

Criado em: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Eventos

"@
$logContent | Set-Content $logFile -Encoding UTF8
Write-Host "📋 Log criado: $logFile" -ForegroundColor Cyan

# Criar checkpoint inicial
$checkpointFile = Join-Path $SessionPath "checkpoint.json"
$checkpoint = @{
    agentId = ""
    timestamp = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
    phase = "planning"
    currentStep = 0
    totalSteps = 0
    workflowId = ""
    workflowName = ""
    nodesCreated = @()
    nodesPending = @()
    nodesConfigured = @()
    connectionsCreated = @()
    connectionsPending = @()
    lastValidation = @{
        valid = $false
        errors = @()
        warnings = @()
        fixesApplied = 0
    }
    iterationCount = 0
    maxIterations = 20
    completionPromise = "WORKFLOW_COMPLETE"
    contextUsage = @{
        estimatedTokens = 0
        threshold = 50000
        shouldContinue = $true
    }
    notes = @()
}

$checkpoint | ConvertTo-Json -Depth 10 | Set-Content $checkpointFile -Encoding UTF8
Write-Host "💾 Checkpoint criado: $checkpointFile" -ForegroundColor Cyan

Write-Host ""
Write-Host "🚀 Sessão $SessionId inicializada com sucesso!" -ForegroundColor Green
Write-Host ""

# Retornar caminho da sessão
return $SessionPath
