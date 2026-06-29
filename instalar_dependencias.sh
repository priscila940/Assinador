#!/bin/bash

# Atualiza a lista de pacotes do servidor Linux
echo "📦 Atualizando pacotes do sistema..."
sudo apt update && sudo apt upgrade -y

# Instala as dependências necessárias para compilar o zsign
echo "🛠️ Instalação das ferramentas de compilação..."
sudo apt install clang g++ libssl-dev git nodejs npm -y

# Cria a estrutura de pastas do assinador
echo "📁 Criando estrutura de pastas para o projeto..."
mkdir -p certificados uploads assinados public/manifests

# Baixa e compila o zsign globalmente no sistema
echo "🚀 Baixando e compilando o zsign..."
if [ ! -d "zsign" ]; then
    git clone https://github.com/zhlynn/zsign.git
fi
cd zsign
g++ *.cpp -lcrypto -O3 -o zsign
sudo cp zsign /usr/local/bin/
cd ..

# Instala as dependências do Node.js
echo "🟢 Instalação das dependências do Node.js..."
npm install

echo "✅ Instalação concluída com sucesso!"
echo "👉 Coloque seu certificado (.p12) e profile (.mobileprovision) dentro da pasta 'certificados/'"
echo "👉 Edite o arquivo 'server.js' com a senha do certificado e use 'npm start' para rodar."
