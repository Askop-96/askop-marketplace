#!/bin/bash
# cleanup-session.sh
# Script para limpar arquivos de sessão do n8n-workflow-agents

SESSION_DIR=".n8n-session"

echo "n8n Workflow Agents - Limpeza de Sessão"
echo "========================================"

if [ -d "$SESSION_DIR" ]; then
    echo "Encontrada pasta de sessão: $SESSION_DIR"
    echo ""
    echo "Arquivos que serão removidos:"
    ls -la "$SESSION_DIR"
    echo ""

    read -p "Deseja remover todos os arquivos de sessão? (s/N): " confirm

    if [[ "$confirm" =~ ^[Ss]$ ]]; then
        rm -rf "$SESSION_DIR"
        echo "Sessão limpa com sucesso!"
    else
        echo "Operação cancelada."
    fi
else
    echo "Nenhuma pasta de sessão encontrada (.n8n-session/)"
    echo "Nada a limpar."
fi
