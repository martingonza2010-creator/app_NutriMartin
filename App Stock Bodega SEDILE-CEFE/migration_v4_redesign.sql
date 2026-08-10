-- =========================================================
-- SCRIPT DE MIGRACIÓN: REDISEÑO NUTRIMARTIN V4.0
-- Objetivo: Soportar Anillo de Movimiento y Métricas de Evolución
-- =========================================================

-- 1. Actualizar tabla 'daily_logs' para el Anillo de Movimiento
ALTER TABLE public.daily_logs ADD COLUMN IF NOT EXISTS active_minutes numeric DEFAULT 0;
ALTER TABLE public.daily_logs ADD COLUMN IF NOT EXISTS burned_calories numeric DEFAULT 0;
ALTER TABLE public.daily_logs ADD COLUMN IF NOT EXISTS movement_category text;
ALTER TABLE public.daily_logs ADD COLUMN IF NOT EXISTS movement_intensity text;

-- 2. Asegurar que las columnas de evolución también existan en el log diario (para históricos)
ALTER TABLE public.daily_logs ADD COLUMN IF NOT EXISTS waist_circumference numeric;
-- (Peso, Grasa y Músculo ya existen según scripts anteriores, pero los aseguramos)
ALTER TABLE public.daily_logs ADD COLUMN IF NOT EXISTS weight numeric;
ALTER TABLE public.daily_logs ADD COLUMN IF NOT EXISTS fat_percent numeric;
ALTER TABLE public.daily_logs ADD COLUMN IF NOT EXISTS muscle_percent numeric;

-- 3. Actualizar tabla 'profiles' para Composición Corporal editable
-- (Usamos nombres snake_case para consistencia con Postgres)
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS current_weight numeric;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS current_height numeric;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS current_waist numeric;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS current_fat numeric;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS current_muscle numeric;

-- 4. Actualizar RLS o recargar esquema si es necesario
NOTIFY pgrst, 'reload config';

-- Confirmación visual de las columnas en daily_logs
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'daily_logs';
