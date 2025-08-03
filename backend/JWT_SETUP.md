# Configuração de JWT Secrets

## Visão Geral

Este projeto usa dois secrets JWT diferentes para máxima segurança:

1. **JWT_SECRET**: Para tokens de acesso (access tokens)
2. **JWT_REFRESH_SECRET**: Para tokens de renovação (refresh tokens)

## Por que usar secrets diferentes?

- **Segurança**: Se um secret for comprometido, o outro permanece seguro
- **Controle de acesso**: Tokens de acesso e refresh podem ter políticas diferentes
- **Rotação de secrets**: Pode-se rotacionar um secret sem afetar o outro

## Configuração

### 1. Gerar Secrets Seguros

Use o comando abaixo para gerar secrets seguros:

```bash
# Para JWT_SECRET
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"

# Para JWT_REFRESH_SECRET
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
```

### 2. Configurar no .env

```env
# JWT Configuration
JWT_SECRET=seu-jwt-secret-aqui-64-caracteres
JWT_REFRESH_SECRET=seu-refresh-secret-aqui-64-caracteres
JWT_EXPIRES_IN=2h
JWT_REFRESH_EXPIRES_IN=7d
```

### 3. Recomendações de Duração

- **JWT_EXPIRES_IN**: `2h` (2 horas) - Tokens de acesso curtos
- **JWT_REFRESH_EXPIRES_IN**: `7d` (7 dias) - Tokens de renovação mais longos

## Funcionamento

1. **Login/Registro**: Usuário recebe access token + refresh token
2. **Requisições**: Access token é usado para autenticar requisições
3. **Token Expirado**: Frontend automaticamente usa refresh token para obter novo access token
4. **Refresh Expirado**: Usuário é redirecionado para login

## Segurança

- Secrets devem ter pelo menos 64 caracteres
- Nunca compartilhe os secrets
- Use variáveis de ambiente diferentes em produção
- Considere usar um gerenciador de secrets (AWS Secrets Manager, HashiCorp Vault, etc.)

## Exemplo de Secrets

```env
JWT_SECRET=a1b2c3d4e5f6789012345678901234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890
JWT_REFRESH_SECRET=f1e2d3c4b5a6789012345678901234567890fedcba1234567890fedcba1234567890fedcba1234567890fedcba1234567890fedcba1234567890
```
