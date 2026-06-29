#!/bin/bash

# Este script pode ser colocado no 'cron' do seu servidor Linux para rodar 
# diariamente e apagar os IPAs antigos e manifestos, evitando que o disco lote.

echo "🧹 Limpando arquivos temporários e IPAs gerados há mais de 2 dias..."

# Caminhos do projeto (ajuste se necessário)
DIRETORIO_PROJETO="/root/assinador-web"

find "$DIRETORIO_PROJETO/uploads" -type f -mtime +2 -delete
find "$DIRETORIO_PROJETO/assinados" -type f -mtime +2 -delete
find "$DIRETORIO_PROJETO/public/manifests" -type f -mtime +2 -delete

echo "✅ Limpeza concluída com sucesso!"
