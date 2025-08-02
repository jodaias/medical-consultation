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
# Chave secreta para assinar tokens JWT
JWT_SECRET=your-super-secret-jwt-key-here

# Tempo de expiração do token de acesso
JWT_EXPIRES_IN=7d

# Tempo de expiração do token de refresh
JWT_REFRESH_EXPIRES_IN=30d
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

### **JWT Secret**

```bash
# Gerar chave JWT segura
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
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

## **🚨 Segurança**

### **⚠️ IMPORTANTE**

1. **NUNCA** commite o arquivo `.env` no repositório
2. **SEMPRE** use valores únicos e seguros em produção
3. **ROTACIONE** as chaves JWT e pepper regularmente
4. **MONITORE** os logs de segurança
5. **BACKUP** as configurações de segurança

### **🔐 Boas Práticas**

- Use pelo menos 64 caracteres para `JWT_SECRET`
- Use pelo menos 32 caracteres para `PASSWORD_PEPPER`
- Configure `BCRYPT_ROUNDS` entre 12-14
- Use HTTPS em produção
- Configure CORS adequadamente
- Monitore tentativas de login falhadas

---

**📝 Nota**: Este arquivo serve como referência. Copie as variáveis necessárias para seu arquivo `.env` e configure os valores apropriados para seu ambiente.
