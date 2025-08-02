-- Script SQL para Supabase - Medical Consultation Online
-- Baseado no schema Prisma

-- Habilitar extensões necessárias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Criar tipos ENUM
CREATE TYPE user_type AS ENUM ('PATIENT', 'DOCTOR');
CREATE TYPE gender AS ENUM ('MALE', 'FEMALE', 'OTHER');
CREATE TYPE consultation_status AS ENUM ('SCHEDULED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED', 'NO_SHOW');
CREATE TYPE message_type AS ENUM ('TEXT', 'IMAGE', 'FILE', 'AUDIO');

-- Tabela de usuários
CREATE TABLE users (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    name TEXT NOT NULL,
    phone TEXT,
    date_of_birth TIMESTAMP,
    gender gender,
    user_type user_type DEFAULT 'PATIENT',
    is_verified BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    profile_image TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Tabela de perfis de médicos
CREATE TABLE doctor_profiles (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    user_id TEXT UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    crm TEXT UNIQUE NOT NULL,
    specialty TEXT NOT NULL,
    experience INTEGER NOT NULL,
    education TEXT[] DEFAULT '{}',
    certifications TEXT[] DEFAULT '{}',
    bio TEXT,
    consultation_fee DECIMAL(10,2) NOT NULL,
    availability JSONB NOT NULL,
    is_available BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Tabela de perfis de pacientes
CREATE TABLE patient_profiles (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    user_id TEXT UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    emergency_contact TEXT,
    allergies TEXT[] DEFAULT '{}',
    medical_history TEXT,
    current_medications TEXT[] DEFAULT '{}',
    insurance TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Tabela de consultas
CREATE TABLE consultations (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    patient_id TEXT NOT NULL REFERENCES users(id),
    doctor_id TEXT NOT NULL REFERENCES users(id),
    status consultation_status DEFAULT 'SCHEDULED',
    scheduled_at TIMESTAMP NOT NULL,
    started_at TIMESTAMP,
    ended_at TIMESTAMP,
    notes TEXT,
    diagnosis TEXT,
    prescription TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Tabela de mensagens
CREATE TABLE messages (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    consultation_id TEXT NOT NULL REFERENCES consultations(id) ON DELETE CASCADE,
    sender_id TEXT NOT NULL REFERENCES users(id),
    receiver_id TEXT NOT NULL REFERENCES users(id),
    content TEXT NOT NULL,
    message_type message_type DEFAULT 'TEXT',
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Tabela de agendamentos
CREATE TABLE schedules (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    doctor_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    day_of_week INTEGER NOT NULL CHECK (day_of_week >= 0 AND day_of_week <= 6),
    start_time TEXT NOT NULL,
    end_time TEXT NOT NULL,
    is_available BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Tabela de prescrições
CREATE TABLE prescriptions (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    consultation_id TEXT NOT NULL REFERENCES consultations(id) ON DELETE CASCADE,
    doctor_id TEXT NOT NULL REFERENCES users(id),
    patient_id TEXT NOT NULL REFERENCES users(id),
    medications JSONB NOT NULL,
    instructions TEXT NOT NULL,
    dosage TEXT NOT NULL,
    duration TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Tabela de avaliações
CREATE TABLE ratings (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    patient_id TEXT NOT NULL REFERENCES users(id),
    doctor_id TEXT NOT NULL REFERENCES users(id),
    consultation_id TEXT REFERENCES consultations(id),
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Criar índices para melhor performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_user_type ON users(user_type);
CREATE INDEX idx_consultations_patient_id ON consultations(patient_id);
CREATE INDEX idx_consultations_doctor_id ON consultations(doctor_id);
CREATE INDEX idx_consultations_status ON consultations(status);
CREATE INDEX idx_consultations_scheduled_at ON consultations(scheduled_at);
CREATE INDEX idx_messages_consultation_id ON messages(consultation_id);
CREATE INDEX idx_messages_sender_id ON messages(sender_id);
CREATE INDEX idx_messages_receiver_id ON messages(receiver_id);
CREATE INDEX idx_messages_created_at ON messages(created_at);
CREATE INDEX idx_schedules_doctor_id ON schedules(doctor_id);
CREATE INDEX idx_schedules_day_of_week ON schedules(day_of_week);
CREATE INDEX idx_ratings_doctor_id ON ratings(doctor_id);
CREATE INDEX idx_ratings_patient_id ON ratings(patient_id);

-- Função para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers para atualizar updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_doctor_profiles_updated_at BEFORE UPDATE ON doctor_profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_patient_profiles_updated_at BEFORE UPDATE ON patient_profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_consultations_updated_at BEFORE UPDATE ON consultations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_schedules_updated_at BEFORE UPDATE ON schedules
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_prescriptions_updated_at BEFORE UPDATE ON prescriptions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Políticas de segurança RLS (Row Level Security)
-- Habilitar RLS em todas as tabelas
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE doctor_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE patient_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE consultations ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE schedules ENABLE ROW LEVEL SECURITY;
ALTER TABLE prescriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE ratings ENABLE ROW LEVEL SECURITY;

-- Políticas para usuários
CREATE POLICY "Users can view their own profile" ON users
    FOR SELECT USING (auth.uid()::text = id);

CREATE POLICY "Users can update their own profile" ON users
    FOR UPDATE USING (auth.uid()::text = id);

CREATE POLICY "Users can insert their own profile" ON users
    FOR INSERT WITH CHECK (auth.uid()::text = id);

-- Políticas para perfis de médicos
CREATE POLICY "Doctors can view their own profile" ON doctor_profiles
    FOR SELECT USING (auth.uid()::text = user_id);

CREATE POLICY "Doctors can update their own profile" ON doctor_profiles
    FOR UPDATE USING (auth.uid()::text = user_id);

CREATE POLICY "Doctors can insert their own profile" ON doctor_profiles
    FOR INSERT WITH CHECK (auth.uid()::text = user_id);

-- Políticas para perfis de pacientes
CREATE POLICY "Patients can view their own profile" ON patient_profiles
    FOR SELECT USING (auth.uid()::text = user_id);

CREATE POLICY "Patients can update their own profile" ON patient_profiles
    FOR UPDATE USING (auth.uid()::text = user_id);

CREATE POLICY "Patients can insert their own profile" ON patient_profiles
    FOR INSERT WITH CHECK (auth.uid()::text = user_id);

-- Políticas para consultas
CREATE POLICY "Users can view consultations they participate in" ON consultations
    FOR SELECT USING (auth.uid()::text = patient_id OR auth.uid()::text = doctor_id);

CREATE POLICY "Doctors can update consultations they are involved in" ON consultations
    FOR UPDATE USING (auth.uid()::text = doctor_id);

CREATE POLICY "Users can insert consultations" ON consultations
    FOR INSERT WITH CHECK (auth.uid()::text = patient_id OR auth.uid()::text = doctor_id);

-- Políticas para mensagens
CREATE POLICY "Users can view messages in their consultations" ON messages
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM consultations
            WHERE id = messages.consultation_id
            AND (patient_id = auth.uid()::text OR doctor_id = auth.uid()::text)
        )
    );

CREATE POLICY "Users can insert messages in their consultations" ON messages
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM consultations
            WHERE id = messages.consultation_id
            AND (patient_id = auth.uid()::text OR doctor_id = auth.uid()::text)
        )
    );

-- Políticas para agendamentos
CREATE POLICY "Doctors can manage their schedules" ON schedules
    FOR ALL USING (auth.uid()::text = doctor_id);

-- Políticas para prescrições
CREATE POLICY "Users can view prescriptions they are involved in" ON prescriptions
    FOR SELECT USING (auth.uid()::text = patient_id OR auth.uid()::text = doctor_id);

CREATE POLICY "Doctors can insert prescriptions" ON prescriptions
    FOR INSERT WITH CHECK (auth.uid()::text = doctor_id);

-- Políticas para avaliações
CREATE POLICY "Users can view ratings" ON ratings
    FOR SELECT USING (true);

CREATE POLICY "Patients can insert ratings" ON ratings
    FOR INSERT WITH CHECK (auth.uid()::text = patient_id);

-- Função para obter usuário atual
CREATE OR REPLACE FUNCTION get_current_user()
RETURNS users AS $$
BEGIN
    RETURN (SELECT * FROM users WHERE id = auth.uid()::text);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Função para verificar se usuário é médico
CREATE OR REPLACE FUNCTION is_doctor()
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM users
        WHERE id = auth.uid()::text
        AND user_type = 'DOCTOR'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Função para verificar se usuário é paciente
CREATE OR REPLACE FUNCTION is_patient()
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM users
        WHERE id = auth.uid()::text
        AND user_type = 'PATIENT'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Dados de exemplo (opcional)
-- Inserir alguns usuários de exemplo
INSERT INTO users (id, email, password, name, user_type, is_verified) VALUES
('user_doctor_1', 'doctor@example.com', '$2b$10$example_hash', 'Dr. João Silva', 'DOCTOR', true),
('user_patient_1', 'patient@example.com', '$2b$10$example_hash', 'Maria Santos', 'PATIENT', true);

-- Inserir perfil de médico
INSERT INTO doctor_profiles (user_id, crm, specialty, experience, consultation_fee, availability) VALUES
('user_doctor_1', 'CRM12345', 'Cardiologia', 10, 150.00, '{"monday": {"start": "08:00", "end": "18:00"}, "tuesday": {"start": "08:00", "end": "18:00"}}');

-- Inserir perfil de paciente
INSERT INTO patient_profiles (user_id, emergency_contact, allergies) VALUES
('user_patient_1', '(11) 99999-9999', ARRAY['Penicilina']);

-- Comentários sobre o script:
-- 1. Este script cria toda a estrutura do banco de dados para o Supabase
-- 2. Inclui tipos ENUM, tabelas, índices, triggers e políticas de segurança
-- 3. As políticas RLS garantem que usuários só acessem seus próprios dados
-- 4. Funções auxiliares para verificar tipos de usuário
-- 5. Dados de exemplo para teste
-- 6. Compatível com o schema Prisma existente