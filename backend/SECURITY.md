# 🔒 Guia de Segurança - Medical Consultation API

## **Visão Geral**

Este documento descreve as medidas de segurança implementadas na API de Consultas Médicas Online, seguindo as melhores práticas da indústria.

## **🛡️ Medidas de Segurança Implementadas**

### **1. Autenticação e Autorização**

#### **JWT (JSON Web Tokens)**

- **Algoritmo**: HS256 (HMAC SHA-256)
- **Expiração**: 7 dias (configurável)
- **Claims de segurança**: iat, exp, issuer, audience
- **Verificação rigorosa**: Algoritmo específico na verificação

#### **Bcrypt com Salt + Pepper**

- **Rounds**: 14 (muito mais seguro que 12)
- **Pepper**: Chave secreta adicional armazenada em variável de ambiente
- **Salt automático**: Cada hash tem salt único
- **Proteção contra rainbow tables**: Combinação de salt + pepper

### **2. Validação de Senhas**

#### **Requisitos Mínimos**

- **Comprimento**: Mínimo 8 caracteres, máximo 128
- **Maiúsculas**: Pelo menos 1 letra maiúscula
- **Minúsculas**: Pelo menos 1 letra minúscula
- **Números**: Pelo menos 1 número
- **Caracteres especiais**: Pelo menos 1 caractere especial
- **Prevenção de reutilização**: Não pode ser igual à senha atual

#### **Validação de Entrada**

- **Nome**: Apenas letras e espaços, 2-100 caracteres
- **Email**: Regex rigoroso, máximo 254 caracteres
- **Telefone**: Formato internacional, apenas números

### **3. Proteção contra Ataques**

#### **Rate Limiting**

- **Login**: Máximo 5 tentativas em 15 minutos
- **Registro**: Máximo 3 tentativas em 1 hora
- **API geral**: Máximo 1000 requisições em 15 minutos
- **Uploads**: Máximo 10 uploads em 1 hora

#### **Bloqueio de Conta**

- **Tentativas máximas**: 5 tentativas de login
- **Duração do bloqueio**: 15 minutos
- **Reset automático**: Após 24 horas
- **Log de tentativas**: Rastreamento de tentativas falhadas

### **4. Headers de Segurança**

```javascript
// Headers implementados
'X-Content-Type-Options': 'nosniff'
'X-Frame-Options': 'DENY'
'X-XSS-Protection': '1; mode=block'
'Strict-Transport-Security': 'max-age=31536000; includeSubDomains'
'Content-Security-Policy': "default-src 'self'"
```

### **5. Tratamento de Erros Seguro**

#### **Exceções Customizadas**

- **ValidationException**: Erros de validação (400)
- **UnauthorizedException**: Credenciais inválidas (401)
- **ForbiddenException**: Acesso negado (403)
- **NotFoundException**: Recurso não encontrado (404)
- **ConflictException**: Conflito de dados (409)

#### **Logs de Segurança**

- **Tentativas de login falhadas**
- **Alterações de senha**
- **Bloqueios de conta**
- **Atividade suspeita**

### **6. Arquitetura Segura**

#### **Princípios SOLID**

- **Separação de responsabilidades**
- **Inversão de dependência**
- **Validação em camadas**
- **Tratamento de erros centralizado**

#### **DTOs de Segurança**

- **Validação rigorosa de entrada**
- **Sanitização de dados**
- **Prevenção de injeção**

## **🔧 Configuração de Ambiente**

### **Variáveis de Ambiente Obrigatórias**

```env
# JWT
JWT_SECRET=your-super-secret-jwt-key-here
JWT_EXPIRES_IN=7d

# Bcrypt
BCRYPT_ROUNDS=14
PASSWORD_PEPPER=medical-consultation-pepper-2025-secure

# Rate Limiting
MAX_LOGIN_ATTEMPTS=5
LOCKOUT_DURATION=15

# Segurança
NODE_ENV=production
SECURITY_LOGGING=true
SECURITY_BACKUP=true
```

### **Configurações Recomendadas**

```env
# CORS
CORS_ORIGIN=https://yourdomain.com

# Rate Limiting
RATE_LIMIT_WINDOW=15
RATE_LIMIT_MAX=100

# Logging
LOG_LEVEL=info
```

## **📊 Monitoramento de Segurança**

### **Métricas Importantes**

- **Tentativas de login falhadas**
- **Contas bloqueadas**
- **Tentativas de registro suspeitas**
- **Rate limiting atingido**
- **Erros de validação**

### **Alertas Recomendados**

- **Mais de 10 tentativas de login falhadas por hora**
- **Contas bloqueadas por mais de 1 hora**
- **Múltiplos registros do mesmo IP**
- **Padrões de acesso suspeitos**

## **🔄 Atualizações de Segurança**

### **Manutenção Regular**

- **Atualizar dependências** mensalmente
- **Revisar logs de segurança** semanalmente
- **Testar rate limiting** mensalmente
- **Backup de dados** diariamente

### **Auditoria de Segurança**

- **Testes de penetração** trimestralmente
- **Revisão de código** mensalmente
- **Análise de vulnerabilidades** mensalmente
- **Treinamento da equipe** semestralmente

## **🚨 Resposta a Incidentes**

### **Procedimentos**

1. **Identificar** o tipo de incidente
2. **Isolar** sistemas afetados
3. **Documentar** detalhes do incidente
4. **Corrigir** vulnerabilidades
5. **Notificar** usuários afetados
6. **Aprender** com o incidente

### **Contatos de Emergência**

- **Equipe de segurança**: security@company.com
- **Suporte técnico**: support@company.com
- **Compliance**: compliance@company.com

## **📚 Recursos Adicionais**

### **Documentação**

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Node.js Security Best Practices](https://nodejs.org/en/docs/guides/security/)
- [JWT Security](https://jwt.io/introduction)

### **Ferramentas de Teste**

- **OWASP ZAP**: Teste de vulnerabilidades
- **Burp Suite**: Proxy de segurança
- **Nmap**: Scanner de rede
- **Metasploit**: Framework de teste

---

**⚠️ Importante**: Este documento deve ser revisado e atualizado regularmente para manter a segurança da aplicação.
