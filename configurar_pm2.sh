#!/bin/bash

# Este script configura o PM2 para manter o seu assinador web rodando para sempre,
# mesmo se o servidor Linux for reiniciado.

echo "🔄 Instalando o PM2 globalmente..."
sudo npm install pm2 -g

echo "🚀 Iniciando o assinador com o PM2..."
pm2 start ecosystem.config.js

echo "💾 Configurando para iniciar automaticamente com o sistema..."
pm2 startup

echo "📝 Salvando a lista de processos atual..."
pm2 save

echo "✅ Pronto! O seu assinador web está rodando em segundo plano."
echo "👉 Use 'pm2 status' para ver se está online."
echo "👉 Use 'pm2 logs' para monitorar os erros e assinaturas em tempo real."
