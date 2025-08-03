# 🚀 Guia de Deploy da API

## 📋 Pré-requisitos

1. **Conta no GitHub** com o código da API
2. **Banco de dados PostgreSQL** (Railway, Supabase, etc.)
3. **Variáveis de ambiente** configuradas

## 🎯 Opção 1: Railway (Recomendado)

### 1. Criar conta no Railway

- Acesse: https://railway.app
- Faça login com GitHub

### 2. Criar novo projeto

```bash
# Clique em "New Project"
# Selecione "Deploy from GitHub repo"
# Escolha seu repositório
```

### 3. Configurar banco de dados

```bash
# No Railway Dashboard:
# 1. Clique em "New"
# 2. Selecione "Database" → "PostgreSQL"
# 3. Copie a DATABASE_URL
```

### 4. Configurar variáveis de ambiente

```bash
# No Railway Dashboard → Variables:
DATABASE_URL=sua_url_do_postgresql
JWT_SECRET=seu_jwt_secret
JWT_REFRESH_SECRET=seu_jwt_refresh_secret
NODE_ENV=production
PORT=3001
CORS_ORIGIN=https://seu-frontend.vercel.app
```

### 5. Deploy automático

- O Railway detecta automaticamente o `package.json`
- Deploy acontece a cada push no GitHub

## 🎯 Opção 2: Render

### 1. Criar conta no Render

- Acesse: https://render.com
- Faça login com GitHub

### 2. Criar novo Web Service

```bash
# 1. Clique em "New" → "Web Service"
# 2. Conecte seu repositório GitHub
# 3. Configure:
#    - Name: medical-consultation-api
#    - Environment: Node
#    - Build Command: npm install
#    - Start Command: npm start
```

### 3. Configurar banco PostgreSQL

```bash
# 1. Clique em "New" → "PostgreSQL"
# 2. Copie a DATABASE_URL
# 3. Adicione nas variáveis de ambiente
```

### 4. Variáveis de ambiente

```bash
DATABASE_URL=sua_url_do_postgresql
JWT_SECRET=seu_jwt_secret
JWT_REFRESH_SECRET=seu_jwt_refresh_secret
NODE_ENV=production
PORT=3001
CORS_ORIGIN=https://seu-frontend.vercel.app
```

## 🎯 Opção 3: Heroku

### 1. Instalar Heroku CLI

```bash
# Windows
winget install --id=Heroku.HerokuCLI

# macOS
brew tap heroku/brew && brew install heroku
```

### 2. Login e criar app

```bash
heroku login
heroku create medical-consultation-api
```

### 3. Configurar banco PostgreSQL

```bash
heroku addons:create heroku-postgresql:mini
```

### 4. Configurar variáveis

```bash
heroku config:set JWT_SECRET=seu_jwt_secret
heroku config:set JWT_REFRESH_SECRET=seu_jwt_refresh_secret
heroku config:set NODE_ENV=production
heroku config:set CORS_ORIGIN=https://seu-frontend.vercel.app
```

### 5. Deploy

```bash
git push heroku main
```

## 🔧 Configurações Importantes

### 1. Scripts no package.json

```json
{
  "scripts": {
    "start": "node src/server.js",
    "dev": "nodemon src/server.js",
    "prisma:generate": "prisma generate",
    "prisma:migrate": "prisma migrate deploy",
    "prisma:push": "prisma db push"
  }
}
```

### 2. Health Check

```javascript
// Já configurado em /health
app.get("/health", (req, res) => {
  res.json({
    status: "OK",
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV,
  });
});
```

### 3. Variáveis de ambiente obrigatórias

```bash
DATABASE_URL=postgresql://...
JWT_SECRET=seu_secret_aqui
JWT_REFRESH_SECRET=seu_refresh_secret_aqui
NODE_ENV=production
PORT=3001
CORS_ORIGIN=https://seu-frontend.vercel.app
```

## 🗄️ Banco de Dados

### Opção 1: Railway PostgreSQL

- Gratuito até $5/mês
- Incluído no mesmo projeto

### Opção 2: Supabase

- 500MB gratuitos
- Interface web amigável
- Acesse: https://supabase.com

### Opção 3: Neon

- 3GB gratuitos
- Serverless PostgreSQL
- Acesse: https://neon.tech

## 🔍 Verificação do Deploy

### 1. Health Check

```bash
curl https://sua-api.railway.app/health
```

### 2. Teste da API

```bash
curl https://sua-api.railway.app/api/users/specialties
```

### 3. Logs

```bash
# Railway
railway logs

# Render
# Dashboard → Logs

# Heroku
heroku logs --tail
```

## 🚨 Troubleshooting

### Erro de conexão com banco

```bash
# Verificar DATABASE_URL
echo $DATABASE_URL

# Testar conexão
npx prisma db push
```

### Erro de CORS

```bash
# Verificar CORS_ORIGIN
# Deve apontar para o frontend
CORS_ORIGIN=https://seu-frontend.vercel.app
```

### Erro de JWT

```bash
# Gerar novos secrets
node generate-secrets.js
```

## 📱 Frontend

### Atualizar URL da API

```dart
// frontend/lib/core/utils/constants.dart
class ApiConstants {
  static const String baseUrl = 'https://sua-api.railway.app';
  static const String socketUrl = 'https://sua-api.railway.app';
}
```

## 🎉 Próximos Passos

1. **Deploy da API** (escolha uma opção acima)
2. **Configurar banco de dados**
3. **Atualizar frontend** com nova URL
4. **Testar todas as funcionalidades**
5. **Configurar domínio personalizado** (opcional)

## 💰 Custos

- **Railway**: $5/mês (crédito gratuito)
- **Render**: Gratuito (750h/mês)
- **Heroku**: $7/mês (após período gratuito)
- **Supabase**: Gratuito (500MB)
- **Neon**: Gratuito (3GB)
