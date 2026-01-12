# cleanup-session.ps1
# Script para limpar sessão de trabalho n8n

param(
    [switch]$Force,
    [switch]$KeepLogs,
    [int]$OlderThanHours = 24
)

$SessionPath = ".n8n-session"

if (-not (Test-Path $SessionPath)) {
    Write-Host "ℹ️ Nenhuma sessão encontrada para limpar." -ForegroundColor Yellow
    exit 0
}

# Verificar se sessão está ativa (checkpoint recente)
$checkpointFile = Join-Path $SessionPath "checkpoint.json"
if (Test-Path $checkpointFile) {
    $checkpoint = Get-Content $checkpointFile | ConvertFrom-Json
    $lastUpdate = [DateTime]::Parse($checkpoint.timestamp)
    $hoursSinceUpdate = (Get-Date) - $lastUpdate | Select-Object -ExpandProperty TotalHours

    if ($hoursSinceUpdate -lt $OlderThanHours -and -not $Force) {
        Write-Host "⚠️ Sessão ainda ativa (última atualização: $($hoursSinceUpdate.ToString('F1'))h atrás)" -ForegroundColor Yellow
        Write-Host "Use -Force para limpar mesmo assim." -ForegroundColor Yellow
        exit 1
    }
}

# Confirmar limpeza
if (-not $Force) {
    $confirm = Read-Host "Deseja realmente limpar a sessão? (s/N)"
    if ($confirm -ne "s" -and $confirm -ne "S") {
        Write-Host "Operação cancelada." -ForegroundColor Yellow
        exit 0
    }
}

# Backup de logs se solicitado
if ($KeepLogs) {
    $logFile = Join-Path $SessionPath "execution-log.md"
    if (Test-Path $logFile) {
        $backupDir = ".n8n-session-backups"
        if (-not (Test-Path $backupDir)) {
            New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
        }
        $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $backupFile = Join-Path $backupDir "execution-log-$timestamp.md"
        Copy-Item $logFile $backupFile
        Write-Host "📋 Log salvo em: $backupFile" -ForegroundColor Cyan
    }
}

# Arquivos a remover
$filesToRemove = @(
    "context.json",
    "workflow-plan.md",
    "nodes-discovered.json",
    "workflow-id.txt",
    "validation-result.json",
    "checkpoint.json",
    "fixes-applied.json",
    "ai-config.json"
)

if (-not $KeepLogs) {
    $filesToRemove += "execution-log.md"
}

$removedCount = 0
foreach ($file in $filesToRemove) {
    $filePath = Join-Path $SessionPath $file
    if (Test-Path $filePath) {
        Remove-Item $filePath -Force
        $removedCount++
        Write-Host "🗑️ Removido: $file" -ForegroundColor DarkGray
    }
}

# Remover diretório se vazio ou não mantendo logs
$remainingFiles = Get-ChildItem $SessionPath -File
if ($remainingFiles.Count -eq 0) {
    Remove-Item $SessionPath -Force
    Write-Host ""
    Write-Host "✅ Sessão completamente removida." -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "✅ Sessão limpa. $removedCount arquivo(s) removido(s)." -ForegroundColor Green
    Write-Host "📁 Arquivos restantes: $($remainingFiles.Count)" -ForegroundColor Yellow
}

Write-Host ""
