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

## 🗄️ Estrutura do Banco de Dados

### Tabelas Principais

- **`users`** - Usuários (pacientes e médicos)
- **`doctor_profiles`** - Perfis específicos de médicos
- **`patient_profiles`** - Perfis específicos de pacientes
- **`consultations`** - Consultas médicas
- **`messages`** - Mensagens do chat
- **`schedules`** - Agenda dos médicos
- **`prescriptions`** - Prescrições médicas
- **`ratings`** - Avaliações dos médicos

### Segurança

- **Row Level Security (RLS)** habilitado em todas as tabelas
- **Políticas de acesso** baseadas no tipo de usuário
- **Funções auxiliares** para validações de permissão
- **Índices otimizados** para consultas frequentes

### Relacionamentos

- Usuários podem ser pacientes ou médicos
- Consultas conectam pacientes e médicos
- Mensagens pertencem a consultas específicas
- Agendamentos são específicos para médicos
- Prescrições e avaliações têm relacionamentos com consultas

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

### Banco de Dados

- **Supabase** (PostgreSQL gerenciado)
- **Row Level Security (RLS)** para segurança
- **Índices otimizados** para performance
- **Triggers automáticos** para timestamps
- **Funções auxiliares** para validações

## 📦 Instalação

### Pré-requisitos

- Flutter SDK
- Node.js 18+
- PostgreSQL ou Supabase
- Android Studio / Xcode

### Banco de Dados

#### Opção 1: Supabase (Recomendado)

1. Crie um projeto no [Supabase](https://supabase.com)
2. Execute o script SQL em `database/supabase_schema.sql`
3. Configure as variáveis de ambiente (veja `database/README.md`)

#### Opção 2: PostgreSQL Local

1. Instale PostgreSQL
2. Crie um banco de dados
3. Configure a variável `DATABASE_URL` no `.env`

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
