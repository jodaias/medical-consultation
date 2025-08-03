#!/bin/bash

# 🚀 Script de Deploy da API
# Uso: ./deploy.sh [railway|render|heroku]

set -e

echo "🚀 Iniciando deploy da API..."

# Verificar se o Node.js está instalado
if ! command -v node &> /dev/null; then
    echo "❌ Node.js não encontrado. Instale o Node.js primeiro."
    exit 1
fi

# Verificar se o npm está instalado
if ! command -v npm &> /dev/null; then
    echo "❌ npm não encontrado. Instale o npm primeiro."
    exit 1
fi

# Instalar dependências
echo "📦 Instalando dependências..."
npm install

# Gerar Prisma client
echo "🔧 Gerando Prisma client..."
npx prisma generate

# Verificar variáveis de ambiente
echo "🔍 Verificando variáveis de ambiente..."
if [ -z "$DATABASE_URL" ]; then
    echo "⚠️  DATABASE_URL não encontrada"
    echo "   Configure a variável DATABASE_URL"
fi

if [ -z "$JWT_SECRET" ]; then
    echo "⚠️  JWT_SECRET não encontrada"
    echo "   Execute: node generate-secrets.js"
fi

if [ -z "$JWT_REFRESH_SECRET" ]; then
    echo "⚠️  JWT_REFRESH_SECRET não encontrada"
    echo "   Execute: node generate-secrets.js"
fi

# Testar build
echo "🧪 Testando build..."
npm run start &
PID=$!
sleep 5

# Testar health check
if curl -f http://localhost:3001/health > /dev/null 2>&1; then
    echo "✅ Health check passou"
else
    echo "❌ Health check falhou"
    kill $PID
    exit 1
fi

kill $PID

# Deploy baseado no argumento
case "${1:-railway}" in
    "railway")
        echo "🚂 Deploy no Railway..."
        echo "   1. Acesse: https://railway.app"
        echo "   2. Conecte seu repositório GitHub"
        echo "   3. Configure as variáveis de ambiente"
        echo "   4. Deploy automático acontecerá"
        ;;
    "render")
        echo "🎨 Deploy no Render..."
        echo "   1. Acesse: https://render.com"
        echo "   2. Crie um novo Web Service"
        echo "   3. Conecte seu repositório GitHub"
        echo "   4. Configure as variáveis de ambiente"
        ;;
    "heroku")
        echo "🦸 Deploy no Heroku..."
        if ! command -v heroku &> /dev/null; then
            echo "❌ Heroku CLI não encontrado"
            echo "   Instale: https://devcenter.heroku.com/articles/heroku-cli"
            exit 1
        fi

        echo "🔐 Fazendo login no Heroku..."
        heroku login

        echo "🏗️  Criando app no Heroku..."
        heroku create medical-consultation-api

        echo "🗄️  Adicionando PostgreSQL..."
        heroku addons:create heroku-postgresql:mini

        echo "⚙️  Configurando variáveis..."
        heroku config:set NODE_ENV=production

        echo "🚀 Fazendo deploy..."
        git push heroku main

        echo "✅ Deploy concluído!"
        echo "🔗 URL: https://medical-consultation-api.herokuapp.com"
        ;;
    *)
        echo "❌ Plataforma não reconhecida: $1"
        echo "   Use: railway, render ou heroku"
        exit 1
        ;;
esac

echo "🎉 Deploy configurado!"
echo "📋 Próximos passos:"
echo "   1. Configure as variáveis de ambiente"
echo "   2. Configure o banco de dados"
echo "   3. Atualize o frontend com a nova URL"
echo "   4. Teste todas as funcionalidades"