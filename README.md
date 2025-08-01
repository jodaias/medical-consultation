# Medical Consultation Online

Aplicativo completo de consultas médicas online com chat em tempo real.

## 🏗️ Arquitetura

### Frontend (Flutter)

- **Framework**: Flutter 3.x
- **Gerenciamento de Estado**: MobX
- **Arquitetura**: Modular + Clean Architecture
- **Rotas**: Nomeadas com GoRouter
- **UI**: Material Design 3

### Backend (Node.js)

- **Framework**: Express.js
- **Autenticação**: JWT
- **Banco de Dados**: PostgreSQL
- **Chat em Tempo Real**: Socket.io
- **Documentação**: Swagger

## 🚀 Funcionalidades

### Para Pacientes

- ✅ Registro e login
- ✅ Perfil completo
- ✅ Busca de médicos
- ✅ Agendamento de consultas
- ✅ Chat em tempo real
- ✅ Histórico de consultas
- ✅ Avaliações de médicos

### Para Médicos

- ✅ Registro e verificação
- ✅ Perfil profissional
- ✅ Gestão de agenda
- ✅ Chat com pacientes
- ✅ Histórico de atendimentos
- ✅ Receitas e prescrições

## 📱 Telas Principais

1. **Autenticação**

   - Login
   - Registro (Paciente/Médico)
   - Recuperação de senha

2. **Paciente**

   - Dashboard
   - Busca de médicos
   - Agendamento
   - Chat
   - Perfil
   - Histórico

3. **Médico**
   - Dashboard
   - Agenda
   - Chat
   - Perfil
   - Histórico

## 🛠️ Tecnologias

### Frontend

- Flutter 3.x
- MobX (Gerenciamento de Estado)
- Modular (Injeção de Dependência)
- GoRouter (Navegação)
- Dio (HTTP Client)
- Socket.io (Chat)

### Backend

- Node.js
- Express.js
- PostgreSQL
- Prisma (ORM)
- Socket.io
- JWT
- Bcrypt
- Multer (Upload)

## 📦 Instalação

### Pré-requisitos

- Flutter SDK
- Node.js 18+
- PostgreSQL
- Android Studio / Xcode

### Backend

```bash
cd backend
npm install
npm run dev
```

### Frontend

```bash
cd frontend
flutter pub get
flutter run
```

## 🔐 Segurança

- Autenticação JWT
- Criptografia de senhas
- Validação de dados
- Rate limiting
- HTTPS obrigatório
- Sanitização de inputs

## 📊 Banco de Dados

PostgreSQL com as seguintes tabelas principais:

- users (pacientes e médicos)
- consultations
- messages
- schedules
- prescriptions
- ratings

## 🚀 Deploy

### Backend

- Vercel / Railway / Heroku
- Banco: Supabase / Railway PostgreSQL

### Frontend

- Google Play Store
- Apple App Store
- Firebase App Distribution (testes)

## 📝 Licença

MIT License
