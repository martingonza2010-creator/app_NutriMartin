-- =========================================================
-- SCRIPT DE ACTUALIZACIÓN: HISTORIAL DE EXÁMENES
-- Objetivo: Asegurar que biochemical_exams soporte edición individual
-- =========================================================

-- 1. Agregar columna ID si no existe (Primary Key alternativa)
-- Nota: Si tu tabla ya tiene ID, este script lo ignorará.
ALTER TABLE public.biochemical_exams ADD COLUMN IF NOT EXISTS id uuid DEFAULT gen_random_uuid() PRIMARY KEY;

-- 2. Asegurar que la fecha sea manejable
-- (No hacemos cambios de tipo de datos por seguridad, pero aseguramos columnas)
ALTER TABLE public.biochemical_exams ADD COLUMN IF NOT EXISTS user_id uuid REFERENCES auth.users(id);
ALTER TABLE public.biochemical_exams ADD COLUMN IF NOT EXISTS date text; -- Por consistencia con DailyLog

-- 3. Notificar cambios
NOTIFY pgrst, 'reload config';

-- 4. Verificación
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'biochemical_exams';
