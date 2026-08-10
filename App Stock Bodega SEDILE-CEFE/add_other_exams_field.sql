-- =========================================================
-- SCRIPT DE ACTUALIZACIÓN DE ESQUEMA (OTROS EXÁMENES)
-- Objetivo: Agregar columna de texto libre para otros exámenes en biochemical_exams
-- =========================================================

-- 1. Agregar columna si no existe
ALTER TABLE public.biochemical_exams ADD COLUMN IF NOT EXISTS other_exams text;

-- 2. Recargar configuración de caché de API
NOTIFY pgrst, 'reload config';

-- 3. Confirmación
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'biochemical_exams' AND column_name = 'other_exams';
