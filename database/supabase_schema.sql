-- Script SQL para Supabase - Medical Consultation Online
-- Baseado no schema Prisma

-- Habilitar extensões necessárias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Função para gerar cuid (compatible com Prisma) -> caso use cuid() no Prisma
-- CREATE OR REPLACE FUNCTION cuid()
-- RETURNS TEXT AS $$
-- DECLARE
--     timestamp BIGINT;
--     counter INTEGER;
--     random_part TEXT;
--     cuid_result TEXT;
-- BEGIN
--     -- Obter timestamp em milissegundos
--     timestamp := EXTRACT(EPOCH FROM NOW()) * 1000;

--     -- Gerar contador aleatório
--     counter := floor(random() * 1000000);

--     -- Gerar parte aleatória
--     random_part := encode(gen_random_bytes(8), 'hex');

--     -- Montar cuid no formato: c + timestamp + counter + random
--     cuid_result := 'c' ||
--                    lpad(timestamp::text, 12, '0') ||
--                    lpad(counter::text, 6, '0') ||
--                    random_part;

--     RETURN cuid_result;
-- END;
-- $$ LANGUAGE plpgsql;

-- Criar tipos ENUM
CREATE TYPE "UserType" AS ENUM ('PATIENT', 'DOCTOR');
CREATE TYPE "Gender" AS ENUM ('MALE', 'FEMALE', 'OTHER');
CREATE TYPE "ConsultationStatus" AS ENUM ('SCHEDULED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED', 'NO_SHOW');
CREATE TYPE "MessageType" AS ENUM ('TEXT', 'IMAGE', 'FILE', 'AUDIO');
CREATE TYPE "ReportType" AS ENUM ('CONSULTATION', 'FINANCIAL', 'PATIENT', 'RATING', 'PRESCRIPTION');
CREATE TYPE "FormatType" AS ENUM ('PDF', 'CSV', 'EXCEL');
CREATE TYPE "ReportStatus" AS ENUM ('PENDING', 'PROCESSING', 'COMPLETED', 'FAILED');

-- Tabela de usuários
CREATE TABLE "users" (
    "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    "email" TEXT UNIQUE NOT NULL,
    "password" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "phone" TEXT,
    "dateOfBirth" TIMESTAMP,
    "gender" "Gender",
    "userType" "UserType" DEFAULT 'PATIENT',
    "isVerified" BOOLEAN DEFAULT false,
    "isActive" BOOLEAN DEFAULT true,
    "profileImage" TEXT,
    "loginAttempts" INTEGER DEFAULT 0,
    "isLocked" BOOLEAN DEFAULT false,
    "lockoutUntil" TIMESTAMP,
    "lastLoginAt" TIMESTAMP,
    "passwordChangedAt" TIMESTAMP,
    "createdAt" TIMESTAMP DEFAULT NOW(),
    "updatedAt" TIMESTAMP DEFAULT NOW()
);

-- Tabela de perfis de médicos
CREATE TABLE "doctor_profiles" (
    "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    "userId" TEXT UNIQUE NOT NULL REFERENCES "users"("id") ON DELETE CASCADE,
    "crm" TEXT UNIQUE NOT NULL,
    "specialty" TEXT NOT NULL,
    "experience" INTEGER NOT NULL,
    "education" TEXT[] DEFAULT '{}',
    "certifications" TEXT[] DEFAULT '{}',
    "bio" TEXT,
    "consultationFee" DECIMAL(10,2) NOT NULL,
    "availability" JSONB NOT NULL,
    "isAvailable" BOOLEAN DEFAULT true,
    "createdAt" TIMESTAMP DEFAULT NOW(),
    "updatedAt" TIMESTAMP DEFAULT NOW()
);

-- Tabela de perfis de pacientes
CREATE TABLE "patient_profiles" (
    "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    "userId" TEXT UNIQUE NOT NULL REFERENCES "users"("id") ON DELETE CASCADE,
    "emergencyContact" TEXT,
    "allergies" TEXT[] DEFAULT '{}',
    "medicalHistory" TEXT,
    "currentMedications" TEXT[] DEFAULT '{}',
    "insurance" TEXT,
    "createdAt" TIMESTAMP DEFAULT NOW(),
    "updatedAt" TIMESTAMP DEFAULT NOW()
);

-- Tabela de consultas
CREATE TABLE "consultations" (
    "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    "patientId" TEXT NOT NULL REFERENCES "users"("id"),
    "doctorId" TEXT NOT NULL REFERENCES "users"("id"),
    "status" "ConsultationStatus" DEFAULT 'SCHEDULED',
    "scheduledAt" TIMESTAMP NOT NULL,
    "startedAt" TIMESTAMP,
    "endedAt" TIMESTAMP,
    "notes" TEXT,
    "diagnosis" TEXT,
    "prescription" TEXT,
    "createdAt" TIMESTAMP DEFAULT NOW(),
    "updatedAt" TIMESTAMP DEFAULT NOW()
);

-- Tabela de mensagens
CREATE TABLE "messages" (
    "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    "consultationId" TEXT NOT NULL REFERENCES "consultations"("id") ON DELETE CASCADE,
    "senderId" TEXT NOT NULL REFERENCES "users"("id"),
    "receiverId" TEXT NOT NULL REFERENCES "users"("id"),
    "content" TEXT NOT NULL,
    "messageType" "MessageType" DEFAULT 'TEXT',
    "isRead" BOOLEAN DEFAULT false,
    "createdAt" TIMESTAMP DEFAULT NOW()
);

-- Tabela de agendamentos
CREATE TABLE "schedules" (
    "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    "doctorId" TEXT NOT NULL REFERENCES "users"("id") ON DELETE CASCADE,
    "dayOfWeek" INTEGER NOT NULL CHECK ("dayOfWeek" >= 0 AND "dayOfWeek" <= 6),
    "startTime" TEXT NOT NULL,
    "endTime" TEXT NOT NULL,
    "isAvailable" BOOLEAN DEFAULT true,
    "createdAt" TIMESTAMP DEFAULT NOW(),
    "updatedAt" TIMESTAMP DEFAULT NOW()
);

-- Tabela de prescrições
CREATE TABLE "prescriptions" (
    "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    "consultationId" TEXT NOT NULL REFERENCES "consultations"("id") ON DELETE CASCADE,
    "doctorId" TEXT NOT NULL REFERENCES "users"("id"),
    "patientId" TEXT NOT NULL REFERENCES "users"("id"),
    "medications" JSONB NOT NULL,
    "instructions" TEXT NOT NULL,
    "dosage" TEXT NOT NULL,
    "duration" TEXT NOT NULL,
    "createdAt" TIMESTAMP DEFAULT NOW(),
    "updatedAt" TIMESTAMP DEFAULT NOW()
);

-- Tabela de avaliações
CREATE TABLE "ratings" (
    "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    "patientId" TEXT NOT NULL REFERENCES "users"("id"),
    "doctorId" TEXT NOT NULL REFERENCES "users"("id"),
    "consultationId" TEXT REFERENCES "consultations"("id"),
    "rating" INTEGER NOT NULL CHECK ("rating" >= 1 AND "rating" <= 5),
    "comment" TEXT,
    "createdAt" TIMESTAMP DEFAULT NOW()
);

-- Tabela de relatórios
CREATE TABLE "reports" (
    "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    "userId" TEXT NOT NULL REFERENCES "users"("id") ON DELETE CASCADE,
    "reportType" "ReportType" NOT NULL,
    "startDate" TIMESTAMP NOT NULL,
    "endDate" TIMESTAMP NOT NULL,
    "filters" JSONB,
    "format" "FormatType" DEFAULT 'PDF',
    "status" "ReportStatus" DEFAULT 'PENDING',
    "fileUrl" TEXT,
    "createdAt" TIMESTAMP DEFAULT NOW(),
    "updatedAt" TIMESTAMP DEFAULT NOW()
);

-- Criar índices para melhor performance
CREATE INDEX IF NOT EXISTS "idx_users_email" ON "users"("email");
CREATE INDEX IF NOT EXISTS "idx_users_userType" ON "users"("userType");
CREATE INDEX IF NOT EXISTS "idx_consultations_patientId" ON "consultations"("patientId");
CREATE INDEX IF NOT EXISTS "idx_consultations_doctorId" ON "consultations"("doctorId");
CREATE INDEX IF NOT EXISTS "idx_consultations_status" ON "consultations"("status");
CREATE INDEX IF NOT EXISTS "idx_consultations_scheduledAt" ON "consultations"("scheduledAt");
CREATE INDEX IF NOT EXISTS "idx_messages_consultationId" ON "messages"("consultationId");
CREATE INDEX IF NOT EXISTS "idx_messages_senderId" ON "messages"("senderId");
CREATE INDEX IF NOT EXISTS "idx_messages_receiverId" ON "messages"("receiverId");
CREATE INDEX IF NOT EXISTS "idx_messages_createdAt" ON "messages"("createdAt");
CREATE INDEX IF NOT EXISTS "idx_schedules_doctorId" ON "schedules"("doctorId");
CREATE INDEX IF NOT EXISTS "idx_schedules_dayOfWeek" ON "schedules"("dayOfWeek");
CREATE INDEX IF NOT EXISTS "idx_ratings_doctorId" ON "ratings"("doctorId");
CREATE INDEX IF NOT EXISTS "idx_ratings_patientId" ON "ratings"("patientId");
CREATE INDEX IF NOT EXISTS "idx_reports_userId" ON "reports"("userId");
CREATE INDEX IF NOT EXISTS "idx_reports_reportType" ON "reports"("reportType");
CREATE INDEX IF NOT EXISTS "idx_reports_status" ON "reports"("status");
CREATE INDEX IF NOT EXISTS "idx_reports_createdAt" ON "reports"("createdAt");

-- Função para atualizar updatedAt automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW."updatedAt" = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers para atualizar updatedAt
CREATE TRIGGER "update_users_updatedAt" BEFORE UPDATE ON "users"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER "update_doctor_profiles_updatedAt" BEFORE UPDATE ON "doctor_profiles"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER "update_patient_profiles_updatedAt" BEFORE UPDATE ON "patient_profiles"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER "update_consultations_updatedAt" BEFORE UPDATE ON "consultations"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER "update_schedules_updatedAt" BEFORE UPDATE ON "schedules"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER "update_prescriptions_updatedAt" BEFORE UPDATE ON "prescriptions"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER "update_reports_updatedAt" BEFORE UPDATE ON "reports"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Políticas de segurança RLS (Row Level Security)
-- Habilitar RLS em todas as tabelas
ALTER TABLE "users" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "doctor_profiles" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "patient_profiles" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "consultations" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "messages" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "schedules" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "prescriptions" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "ratings" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "reports" ENABLE ROW LEVEL SECURITY;

-- Políticas para usuários
CREATE POLICY "Users can view their own profile" ON "users"
    FOR SELECT USING (auth.uid()::text = "id");

CREATE POLICY "Users can update their own profile" ON "users"
    FOR UPDATE USING (auth.uid()::text = "id");

CREATE POLICY "Users can insert their own profile" ON "users"
    FOR INSERT WITH CHECK (auth.uid()::text = "id");

-- Políticas para perfis de médicos
CREATE POLICY "Doctors can view their own profile" ON "doctor_profiles"
    FOR SELECT USING (auth.uid()::text = "userId");

CREATE POLICY "Doctors can update their own profile" ON "doctor_profiles"
    FOR UPDATE USING (auth.uid()::text = "userId");

CREATE POLICY "Doctors can insert their own profile" ON "doctor_profiles"
    FOR INSERT WITH CHECK (auth.uid()::text = "userId");

-- Políticas para perfis de pacientes
CREATE POLICY "Patients can view their own profile" ON "patient_profiles"
    FOR SELECT USING (auth.uid()::text = "userId");

CREATE POLICY "Patients can update their own profile" ON "patient_profiles"
    FOR UPDATE USING (auth.uid()::text = "userId");

CREATE POLICY "Patients can insert their own profile" ON "patient_profiles"
    FOR INSERT WITH CHECK (auth.uid()::text = "userId");

-- Políticas para consultas
CREATE POLICY "Users can view consultations they participate in" ON "consultations"
    FOR SELECT USING (auth.uid()::text = "patientId" OR auth.uid()::text = "doctorId");

CREATE POLICY "Doctors can update consultations they are involved in" ON "consultations"
    FOR UPDATE USING (auth.uid()::text = "doctorId");

CREATE POLICY "Users can insert consultations" ON "consultations"
    FOR INSERT WITH CHECK (auth.uid()::text = "patientId" OR auth.uid()::text = "doctorId");

-- Políticas para mensagens
CREATE POLICY "Users can view messages in their consultations" ON "messages"
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM "consultations"
            WHERE "id" = "messages"."consultationId"
            AND ("patientId" = auth.uid()::text OR "doctorId" = auth.uid()::text)
        )
    );

CREATE POLICY "Users can insert messages in their consultations" ON "messages"
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM "consultations"
            WHERE "id" = "messages"."consultationId"
            AND ("patientId" = auth.uid()::text OR "doctorId" = auth.uid()::text)
        )
    );

-- Políticas para agendamentos
CREATE POLICY "Doctors can manage their schedules" ON "schedules"
    FOR ALL USING (auth.uid()::text = "doctorId");

-- Políticas para prescrições
CREATE POLICY "Users can view prescriptions they are involved in" ON "prescriptions"
    FOR SELECT USING (auth.uid()::text = "patientId" OR auth.uid()::text = "doctorId");

CREATE POLICY "Doctors can insert prescriptions" ON "prescriptions"
    FOR INSERT WITH CHECK (auth.uid()::text = "doctorId");

-- Políticas para avaliações
CREATE POLICY "Users can view ratings" ON "ratings"
    FOR SELECT USING (true);

CREATE POLICY "Patients can insert ratings" ON "ratings"
    FOR INSERT WITH CHECK (auth.uid()::text = "patientId");

-- Políticas para relatórios
CREATE POLICY "Users can view their own reports" ON "reports"
    FOR SELECT USING (auth.uid()::text = "userId");

CREATE POLICY "Users can insert their own reports" ON "reports"
    FOR INSERT WITH CHECK (auth.uid()::text = "userId");

CREATE POLICY "Users can update their own reports" ON "reports"
    FOR UPDATE USING (auth.uid()::text = "userId");

CREATE POLICY "Users can delete their own reports" ON "reports"
    FOR DELETE USING (auth.uid()::text = "userId");

-- Função para obter usuário atual
CREATE OR REPLACE FUNCTION get_current_user()
RETURNS "users" AS $$
BEGIN
    RETURN (SELECT * FROM "users" WHERE "id" = auth.uid()::text);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Função para verificar se usuário é médico
CREATE OR REPLACE FUNCTION is_doctor()
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM "users"
        WHERE "id" = auth.uid()::text
        AND "userType" = 'DOCTOR'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Função para verificar se usuário é paciente
CREATE OR REPLACE FUNCTION is_patient()
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM "users"
        WHERE "id" = auth.uid()::text
        AND "userType" = 'PATIENT'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Dados de exemplo (opcional)
-- Inserir alguns usuários de exemplo
INSERT INTO "users" ("id", "email", "password", "name", "userType", "isVerified", "createdAt", "updatedAt") VALUES
('user_doctor_1', 'doctor@example.com', '$2b$10$example_hash', 'Dr. João Silva', 'DOCTOR', true, NOW(), NOW()),
('user_patient_1', 'patient@example.com', '$2b$10$example_hash', 'Maria Santos', 'PATIENT', true, NOW(), NOW());

-- Inserir perfil de médico
INSERT INTO "doctor_profiles" ("id", "userId", "crm", "specialty", "experience", "consultationFee", "availability", "createdAt", "updatedAt") VALUES
(gen_random_uuid()::text, 'user_doctor_1', 'CRM12345', 'Cardiologia', 10, 150.00, '{"monday": {"start": "08:00", "end": "18:00"}, "tuesday": {"start": "08:00", "end": "18:00"}}', NOW(), NOW());

-- Inserir perfil de paciente
INSERT INTO "patient_profiles" ("id", "userId", "emergencyContact", "allergies", "createdAt", "updatedAt") VALUES
(gen_random_uuid()::text, 'user_patient_1', '(11) 99999-9999', ARRAY['Penicilina'], NOW(), NOW());

-- Comentários sobre o script:
-- 1. Este script cria toda a estrutura do banco de dados para o Supabase
-- 2. Inclui tipos ENUM, tabelas, índices, triggers e políticas de segurança
-- 3. As políticas RLS garantem que usuários só acessem seus próprios dados
-- 4. Funções auxiliares para verificar tipos de usuário
-- 5. Dados de exemplo para teste
-- 6. Compatível com o schema Prisma existente
-- 7. Usa camelCase como o Prisma