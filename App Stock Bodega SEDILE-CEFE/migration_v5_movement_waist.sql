-- =========================================================
-- SCRIPT DE ACTUALIZACIÓN: EVOLUCIÓN CINTURA Y MOVIMIENTO
-- Objetivo: Asegurar que la tabla daily_logs tenga la columna de cintura
-- =========================================================

ALTER TABLE public.daily_logs ADD COLUMN IF NOT EXISTS waist_circumference numeric;

-- Notificar recarga de configuración (opcional)
NOTIFY pgrst, 'reload config';

-- Verificar columnas finales
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'daily_logs';
