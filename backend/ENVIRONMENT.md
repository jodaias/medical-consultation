# 🔧 Variáveis de Ambiente - Medical Consultation API

## **Visão Geral**

Este documento descreve todas as variáveis de ambiente necessárias para configurar a API de Consultas Médicas Online.

## **📋 Lista Completa de Variáveis**

### **🔧 Configuração do Servidor**

```env
# Porta do servidor
PORT=3001

# Ambiente de execução
NODE_ENV=development
```

### **🗄️ Banco de Dados**

```env
# URL de conexão com PostgreSQL
DATABASE_URL="postgresql://username:password@localhost:5432/medical_consultation"
```

### **🔐 Autenticação JWT**

```env
# Chave secreta para assinar tokens JWT de acesso
JWT_SECRET=your-super-secret-jwt-key-here

# Chave secreta para assinar tokens JWT de refresh
JWT_REFRESH_SECRET=your-super-secret-refresh-jwt-key-here

# Tempo de expiração do token de acesso (recomendado: 2h)
JWT_EXPIRES_IN=2h

# Tempo de expiração do token de refresh (recomendado: 7d)
JWT_REFRESH_EXPIRES_IN=7d
```

### **🔒 Segurança Bcrypt**

```env
# Número de rounds para hash de senha (mais alto = mais seguro)
BCRYPT_ROUNDS=14

# Pepper (chave secreta adicional) para hash de senha
PASSWORD_PEPPER=medical-consultation-pepper-2025-secure
```

### **🛡️ Segurança de Conta**

```env
# Máximo de tentativas de login antes do bloqueio
MAX_LOGIN_ATTEMPTS=5

# Duração do bloqueio em minutos
LOCKOUT_DURATION=15
```

### **📊 Recursos de Segurança**

```env
# Habilitar logging de segurança
SECURITY_LOGGING=true

# Habilitar backup automático
SECURITY_BACKUP=true
```

### **📧 Email (Recuperação de Senha)**

```env
# Servidor SMTP
SMTP_HOST=smtp.gmail.com

# Porta SMTP
SMTP_PORT=587

# Email do sistema
SMTP_USER=your-email@gmail.com

# Senha do app (não a senha normal)
SMTP_PASS=your-app-password
```

### **📁 Upload de Arquivos**

```env
# Caminho para armazenar uploads
UPLOAD_PATH=./uploads

# Tamanho máximo de arquivo em bytes (5MB)
MAX_FILE_SIZE=5242880
```

### **🚦 Rate Limiting**

```env
# Janela de tempo para rate limiting em minutos
RATE_LIMIT_WINDOW=15

# Máximo de requisições por janela
RATE_LIMIT_MAX=100
```

### **🌐 CORS**

```env
# Origem permitida para CORS
CORS_ORIGIN=http://localhost:3000
```

### **🔌 Socket.io**

```env
# Origem permitida para Socket.io
SOCKET_CORS_ORIGIN=http://localhost:3000
```

## **⚙️ Configuração por Ambiente**

### **Desenvolvimento**

```env
NODE_ENV=development
PORT=3001
DATABASE_URL="postgresql://postgres:password@localhost:5432/medical_consultation_dev"
SECURITY_LOGGING=true
SECURITY_BACKUP=false
CORS_ORIGIN=http://localhost:3000
SOCKET_CORS_ORIGIN=http://localhost:3000
```

### **Produção**

```env
NODE_ENV=production
PORT=3001
DATABASE_URL="postgresql://user:password@host:5432/medical_consultation_prod"
SECURITY_LOGGING=true
SECURITY_BACKUP=true
BCRYPT_ROUNDS=14
MAX_LOGIN_ATTEMPTS=5
LOCKOUT_DURATION=15
```

## **🔑 Geração de Chaves Seguras**

### **JWT Secrets**

```bash
# Gerar chave JWT de acesso segura
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"

# Gerar chave JWT de refresh segura
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"

# Ou usar o script fornecido
node generate-secrets.js
```

### **Password Pepper**

```bash
# Gerar pepper seguro
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

## **⚠️ Variáveis Críticas**

### **Obrigatórias**

- `DATABASE_URL`
- `JWT_SECRET`
- `JWT_REFRESH_SECRET`
- `BCRYPT_ROUNDS`
- `PASSWORD_PEPPER`

### **Recomendadas**

- `MAX_LOGIN_ATTEMPTS`
- `LOCKOUT_DURATION`
- `SECURITY_LOGGING`
- `SECURITY_BACKUP`

### **Opcionais**

- `SMTP_*` (para recuperação de senha)
- `UPLOAD_PATH`
- `MAX_FILE_SIZE`

## **🔄 Sistema de Refresh Tokens**

### **Como Funciona**

O sistema implementa um mecanismo de refresh tokens para melhorar a segurança e experiência do usuário:

1. **Login/Registro**: Usuário recebe access token (2h) + refresh token (7d)
2. **Requisições**: Access token é usado para autenticar requisições
3. **Token Expirado**: Frontend automaticamente usa refresh token para obter novo access token
4. **Refresh Expirado**: Usuário é redirecionado para login

### **Benefícios**

- ✅ **Segurança**: Tokens de acesso curtos reduzem risco de comprometimento
- ✅ **UX**: Usuário não precisa fazer login novamente quando token expira
- ✅ **Controle**: Secrets separados permitem políticas diferentes
- ✅ **Robustez**: Sistema funciona mesmo com tokens expirados

### **Configuração**

```env
# Tokens de acesso (curtos para segurança)
JWT_SECRET=seu-access-token-secret
JWT_EXPIRES_IN=2h

# Tokens de refresh (longos para conveniência)
JWT_REFRESH_SECRET=seu-refresh-token-secret
JWT_REFRESH_EXPIRES_IN=7d
```

## **🚨 Segurança**

### **⚠️ IMPORTANTE**

1. **NUNCA** commite o arquivo `.env` no repositório
2. **SEMPRE** use valores únicos e seguros em produção
3. **ROTACIONE** as chaves JWT (access e refresh) e pepper regularmente
4. **MONITORE** os logs de segurança
5. **BACKUP** as configurações de segurança

### **🔐 Boas Práticas**

- Use pelo menos 64 caracteres para `JWT_SECRET` e `JWT_REFRESH_SECRET`
- Use secrets diferentes para access e refresh tokens
- Use pelo menos 32 caracteres para `PASSWORD_PEPPER`
- Configure `BCRYPT_ROUNDS` entre 12-14
- Use HTTPS em produção
- Configure CORS adequadamente
- Monitore tentativas de login falhadas
- Configure tokens de acesso curtos (2h) e refresh tokens longos (7d)

---

**📝 Nota**: Este arquivo serve como referência. Copie as variáveis necessárias para seu arquivo `.env` e configure os valores apropriados para seu ambiente.
