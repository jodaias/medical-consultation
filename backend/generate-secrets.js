#!/usr/bin/env node

const crypto = require('crypto');

console.log('🔐 Gerando secrets JWT seguros...\n');

// Gerar JWT_SECRET
const jwtSecret = crypto.randomBytes(64).toString('hex');
console.log('JWT_SECRET=' + jwtSecret);

// Gerar JWT_REFRESH_SECRET
const jwtRefreshSecret = crypto.randomBytes(64).toString('hex');
console.log('JWT_REFRESH_SECRET=' + jwtRefreshSecret);

console.log('\n📝 Copie essas linhas para seu arquivo .env');
console.log('⚠️  IMPORTANTE: Nunca compartilhe esses secrets!');
console.log('🔒 Use secrets diferentes em produção!');