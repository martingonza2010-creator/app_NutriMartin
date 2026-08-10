-- =========================================================
-- SCRIPT DE ACTUALIZACIÓN DE ESQUEMA (COLUMNAS FALTANTES)
-- Objetivo: Agregar columnas de peso y composición corporal a la tabla daily_logs
-- =========================================================

-- 1. Agregar columnas si no existen
ALTER TABLE public.daily_logs ADD COLUMN IF NOT EXISTS weight numeric;
ALTER TABLE public.daily_logs ADD COLUMN IF NOT EXISTS fat_percent numeric;
ALTER TABLE public.daily_logs ADD COLUMN IF NOT EXISTS muscle_percent numeric;

-- 2. Asegurar que el caché de Supabase se entere del cambio (Opcional, pero recomendado)
NOTIFY pgrst, 'reload config';

-- 3. Confirmación visual (opcional)
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'daily_logs';
