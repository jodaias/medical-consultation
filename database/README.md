# Banco de Dados - Medical Consultation Online

Este diretório contém os scripts e configurações para o banco de dados Supabase.

## Arquivos

- `supabase_schema.sql` - Script completo para criar toda a estrutura do banco de dados
- `README.md` - Esta documentação

## Configuração do Supabase

### 1. Criar projeto no Supabase

1. Acesse [supabase.com](https://supabase.com)
2. Crie uma nova conta ou faça login
3. Clique em "New Project"
4. Preencha as informações:
   - **Name**: `medical-consultation-online`
   - **Database Password**: Escolha uma senha forte
   - **Region**: Escolha a região mais próxima
5. Clique em "Create new project"

### 2. Executar o script SQL

1. No dashboard do Supabase, vá para **SQL Editor**
2. Clique em **New Query**
3. Copie todo o conteúdo do arquivo `supabase_schema.sql`
4. Cole no editor SQL
5. Clique em **Run** para executar o script

### 3. Verificar a estrutura criada

Após executar o script, você pode verificar se tudo foi criado corretamente:

1. Vá para **Table Editor** no menu lateral
2. Verifique se as seguintes tabelas foram criadas:
   - `users`
   - `doctor_profiles`
   - `patient_profiles`
   - `consultations`
   - `messages`
   - `schedules`
   - `prescriptions`
   - `ratings`

### 4. Configurar variáveis de ambiente

No seu projeto, configure as seguintes variáveis de ambiente:

```env
# Backend (.env)
DATABASE_URL="postgresql://postgres:[YOUR-PASSWORD]@db.[YOUR-PROJECT-REF].supabase.co:5432/postgres"
SUPABASE_URL="https://[YOUR-PROJECT-REF].supabase.co"
SUPABASE_ANON_KEY="[YOUR-ANON-KEY]"
SUPABASE_SERVICE_ROLE_KEY="[YOUR-SERVICE-ROLE-KEY]"

# Frontend (.env)
SUPABASE_URL="https://[YOUR-PROJECT-REF].supabase.co"
SUPABASE_ANON_KEY="[YOUR-ANON-KEY]"
```

Para obter essas informações:

1. No dashboard do Supabase, vá para **Settings** > **API**
2. Copie as URLs e chaves necessárias

## Estrutura do Banco

### Tabelas Principais

#### `users`

- Armazena informações básicas dos usuários
- Suporte para pacientes e médicos
- Campos: id, email, password, name, phone, date_of_birth, gender, user_type, etc.

#### `doctor_profiles`

- Perfil específico para médicos
- Campos: crm, specialty, experience, education, certifications, consultation_fee, availability

#### `patient_profiles`

- Perfil específico para pacientes
- Campos: emergency_contact, allergies, medical_history, current_medications, insurance

#### `consultations`

- Consultas médicas
- Campos: patient_id, doctor_id, status, scheduled_at, started_at, ended_at, notes, diagnosis

#### `messages`

- Mensagens do chat
- Campos: consultation_id, sender_id, receiver_id, content, message_type, is_read

#### `schedules`

- Agenda dos médicos
- Campos: doctor_id, day_of_week, start_time, end_time, is_available

#### `prescriptions`

- Prescrições médicas
- Campos: consultation_id, doctor_id, patient_id, medications, instructions, dosage, duration

#### `ratings`

- Avaliações dos médicos
- Campos: patient_id, doctor_id, consultation_id, rating, comment

### Tipos ENUM

- `user_type`: PATIENT, DOCTOR
- `gender`: MALE, FEMALE, OTHER
- `consultation_status`: SCHEDULED, IN_PROGRESS, COMPLETED, CANCELLED, NO_SHOW
- `message_type`: TEXT, IMAGE, FILE, AUDIO

## Segurança

### Row Level Security (RLS)

O script inclui políticas de segurança que garantem:

1. **Usuários só acessam seus próprios dados**
2. **Médicos só gerenciam suas consultas e agendamentos**
3. **Pacientes só veem consultas em que participam**
4. **Mensagens só são visíveis para participantes da consulta**

### Funções Auxiliares

- `get_current_user()` - Retorna dados do usuário atual
- `is_doctor()` - Verifica se usuário é médico
- `is_patient()` - Verifica se usuário é paciente

## Índices

O script cria índices otimizados para:

- Busca por email
- Filtros por tipo de usuário
- Consultas por paciente/médico
- Ordenação por data
- Busca por status de consulta

## Triggers

Triggers automáticos para atualizar o campo `updated_at` sempre que um registro for modificado.

## Dados de Exemplo

O script inclui dados de exemplo para teste:

- Um médico: Dr. João Silva (Cardiologia)
- Um paciente: Maria Santos
- Perfis correspondentes

## Compatibilidade

Este script é compatível com:

- Supabase (PostgreSQL)
- Schema Prisma existente
- API Node.js/Express
- Frontend Flutter

## Próximos Passos

1. Execute o script no Supabase
2. Configure as variáveis de ambiente
3. Teste a conexão com o backend
4. Implemente autenticação JWT
5. Configure upload de arquivos (se necessário)

## Troubleshooting

### Erro: "relation already exists"

- Algumas tabelas podem já existir se você executou o script antes
- Use `DROP TABLE IF EXISTS` antes de criar as tabelas

### Erro: "permission denied"

- Verifique se você tem permissões de administrador no projeto
- Certifique-se de estar usando a conexão correta

### Erro: "enum type already exists"

- Os tipos ENUM podem já existir
- O script usa `CREATE TYPE IF NOT EXISTS` para evitar esse erro

## Suporte

Para dúvidas sobre o banco de dados:

1. Consulte a [documentação do Supabase](https://supabase.com/docs)
2. Verifique os logs no dashboard do Supabase
3. Teste as queries no SQL Editor
