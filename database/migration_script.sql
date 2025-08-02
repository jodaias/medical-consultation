-- Script de Migração para Supabase
-- Use este script se você já tem um banco de dados existente

-- 1. Backup dos dados existentes (execute antes da migração)
-- CREATE TABLE users_backup AS SELECT * FROM users;
-- CREATE TABLE doctor_profiles_backup AS SELECT * FROM doctor_profiles;
-- CREATE TABLE patient_profiles_backup AS SELECT * FROM patient_profiles;
-- CREATE TABLE consultations_backup AS SELECT * FROM consultations;
-- CREATE TABLE messages_backup AS SELECT * FROM messages;
-- CREATE TABLE schedules_backup AS SELECT * FROM schedules;
-- CREATE TABLE prescriptions_backup AS SELECT * FROM prescriptions;
-- CREATE TABLE ratings_backup AS SELECT * FROM ratings;

-- 2. Remover tabelas existentes (se necessário)
-- DROP TABLE IF EXISTS ratings CASCADE;
-- DROP TABLE IF EXISTS prescriptions CASCADE;
-- DROP TABLE IF EXISTS schedules CASCADE;
-- DROP TABLE IF EXISTS messages CASCADE;
-- DROP TABLE IF EXISTS consultations CASCADE;
-- DROP TABLE IF EXISTS patient_profiles CASCADE;
-- DROP TABLE IF EXISTS doctor_profiles CASCADE;
-- DROP TABLE IF EXISTS users CASCADE;

-- 3. Remover tipos ENUM existentes (se necessário)
-- DROP TYPE IF EXISTS user_type CASCADE;
-- DROP TYPE IF EXISTS gender CASCADE;
-- DROP TYPE IF EXISTS consultation_status CASCADE;
-- DROP TYPE IF EXISTS message_type CASCADE;

-- 4. Executar o script principal
-- Execute o conteúdo do arquivo supabase_schema.sql aqui

-- 5. Restaurar dados (se necessário)
-- INSERT INTO users SELECT * FROM users_backup;
-- INSERT INTO doctor_profiles SELECT * FROM doctor_profiles_backup;
-- INSERT INTO patient_profiles SELECT * FROM patient_profiles_backup;
-- INSERT INTO consultations SELECT * FROM consultations_backup;
-- INSERT INTO messages SELECT * FROM messages_backup;
-- INSERT INTO schedules SELECT * FROM schedules_backup;
-- INSERT INTO prescriptions SELECT * FROM prescriptions_backup;
-- INSERT INTO ratings SELECT * FROM ratings_backup;

-- 6. Limpar backups
-- DROP TABLE users_backup;
-- DROP TABLE doctor_profiles_backup;
-- DROP TABLE patient_profiles_backup;
-- DROP TABLE consultations_backup;
-- DROP TABLE messages_backup;
-- DROP TABLE schedules_backup;
-- DROP TABLE prescriptions_backup;
-- DROP TABLE ratings_backup;

-- Script para verificar integridade dos dados após migração
SELECT
    'users' as table_name,
    COUNT(*) as record_count
FROM users
UNION ALL
SELECT
    'doctor_profiles' as table_name,
    COUNT(*) as record_count
FROM doctor_profiles
UNION ALL
SELECT
    'patient_profiles' as table_name,
    COUNT(*) as record_count
FROM patient_profiles
UNION ALL
SELECT
    'consultations' as table_name,
    COUNT(*) as record_count
FROM consultations
UNION ALL
SELECT
    'messages' as table_name,
    COUNT(*) as record_count
FROM messages
UNION ALL
SELECT
    'schedules' as table_name,
    COUNT(*) as record_count
FROM schedules
UNION ALL
SELECT
    'prescriptions' as table_name,
    COUNT(*) as record_count
FROM prescriptions
UNION ALL
SELECT
    'ratings' as table_name,
    COUNT(*) as record_count
FROM ratings;

-- Verificar relacionamentos
SELECT
    'users with doctor_profiles' as relationship,
    COUNT(*) as count
FROM users u
LEFT JOIN doctor_profiles dp ON u.id = dp.user_id
WHERE u.user_type = 'DOCTOR'
UNION ALL
SELECT
    'users with patient_profiles' as relationship,
    COUNT(*) as count
FROM users u
LEFT JOIN patient_profiles pp ON u.id = pp.user_id
WHERE u.user_type = 'PATIENT';

-- Verificar índices
SELECT
    indexname,
    tablename
FROM pg_indexes
WHERE schemaname = 'public'
AND tablename IN ('users', 'doctor_profiles', 'patient_profiles', 'consultations', 'messages', 'schedules', 'prescriptions', 'ratings')
ORDER BY tablename, indexname;