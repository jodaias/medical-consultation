# 🚀 Script de Deploy da API (PowerShell)
# Uso: .\deploy.ps1 [railway|render|heroku]

param(
    [string]$Platform = "railway"
)

Write-Host "🚀 Iniciando deploy da API..." -ForegroundColor Green

# Verificar se o Node.js está instalado
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Node.js não encontrado. Instale o Node.js primeiro." -ForegroundColor Red
    exit 1
}

# Verificar se o npm está instalado
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "❌ npm não encontrado. Instale o npm primeiro." -ForegroundColor Red
    exit 1
}

# Instalar dependências
Write-Host "📦 Instalando dependências..." -ForegroundColor Yellow
npm install

# Gerar Prisma client
Write-Host "🔧 Gerando Prisma client..." -ForegroundColor Yellow
npx prisma generate

# Verificar variáveis de ambiente
Write-Host "🔍 Verificando variáveis de ambiente..." -ForegroundColor Yellow
if (-not $env:DATABASE_URL) {
    Write-Host "⚠️  DATABASE_URL não encontrada" -ForegroundColor Yellow
    Write-Host "   Configure a variável DATABASE_URL" -ForegroundColor Gray
}

if (-not $env:JWT_SECRET) {
    Write-Host "⚠️  JWT_SECRET não encontrada" -ForegroundColor Yellow
    Write-Host "   Execute: node generate-secrets.js" -ForegroundColor Gray
}

if (-not $env:JWT_REFRESH_SECRET) {
    Write-Host "⚠️  JWT_REFRESH_SECRET não encontrada" -ForegroundColor Yellow
    Write-Host "   Execute: node generate-secrets.js" -ForegroundColor Gray
}

# Testar build
Write-Host "🧪 Testando build..." -ForegroundColor Yellow
Start-Process -FilePath "npm" -ArgumentList "start" -WindowStyle Hidden
$PID = $LASTEXITCODE
Start-Sleep -Seconds 5

# Testar health check
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3001/health" -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Health check passou" -ForegroundColor Green
    } else {
        Write-Host "❌ Health check falhou" -ForegroundColor Red
        Stop-Process -Id $PID -Force -ErrorAction SilentlyContinue
        exit 1
    }
} catch {
    Write-Host "❌ Health check falhou" -ForegroundColor Red
    Stop-Process -Id $PID -Force -ErrorAction SilentlyContinue
    exit 1
}

Stop-Process -Id $PID -Force -ErrorAction SilentlyContinue

# Deploy baseado no argumento
switch ($Platform) {
    "railway" {
        Write-Host "🚂 Deploy no Railway..." -ForegroundColor Cyan
        Write-Host "   1. Acesse: https://railway.app" -ForegroundColor White
        Write-Host "   2. Conecte seu repositório GitHub" -ForegroundColor White
        Write-Host "   3. Configure as variáveis de ambiente" -ForegroundColor White
        Write-Host "   4. Deploy automático acontecerá" -ForegroundColor White
    }
    "render" {
        Write-Host "🎨 Deploy no Render..." -ForegroundColor Cyan
        Write-Host "   1. Acesse: https://render.com" -ForegroundColor White
        Write-Host "   2. Crie um novo Web Service" -ForegroundColor White
        Write-Host "   3. Conecte seu repositório GitHub" -ForegroundColor White
        Write-Host "   4. Configure as variáveis de ambiente" -ForegroundColor White
    }
    "heroku" {
        Write-Host "🦸 Deploy no Heroku..." -ForegroundColor Cyan
        if (-not (Get-Command heroku -ErrorAction SilentlyContinue)) {
            Write-Host "❌ Heroku CLI não encontrado" -ForegroundColor Red
            Write-Host "   Instale: https://devcenter.heroku.com/articles/heroku-cli" -ForegroundColor Gray
            exit 1
        }

        Write-Host "🔐 Fazendo login no Heroku..." -ForegroundColor Yellow
        heroku login

        Write-Host "🏗️  Criando app no Heroku..." -ForegroundColor Yellow
        heroku create medical-consultation-api

        Write-Host "🗄️  Adicionando PostgreSQL..." -ForegroundColor Yellow
        heroku addons:create heroku-postgresql:mini

        Write-Host "⚙️  Configurando variáveis..." -ForegroundColor Yellow
        heroku config:set NODE_ENV=production

        Write-Host "🚀 Fazendo deploy..." -ForegroundColor Yellow
        git push heroku main

        Write-Host "✅ Deploy concluído!" -ForegroundColor Green
        Write-Host "🔗 URL: https://medical-consultation-api.herokuapp.com" -ForegroundColor Cyan
    }
    default {
        Write-Host "❌ Plataforma não reconhecida: $Platform" -ForegroundColor Red
        Write-Host "   Use: railway, render ou heroku" -ForegroundColor Gray
        exit 1
    }
}

Write-Host "🎉 Deploy configurado!" -ForegroundColor Green
Write-Host "📋 Próximos passos:" -ForegroundColor Yellow
Write-Host "   1. Configure as variáveis de ambiente" -ForegroundColor White
Write-Host "   2. Configure o banco de dados" -ForegroundColor White
Write-Host "   3. Atualize o frontend com a nova URL" -ForegroundColor White
Write-Host "   4. Teste todas as funcionalidades" -ForegroundColor White