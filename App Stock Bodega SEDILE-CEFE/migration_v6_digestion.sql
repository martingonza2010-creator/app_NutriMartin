-- =========================================================
-- SCRIPT DE ACTUALIZACIÓN: SEGUIMIENTO DIGESTIVO AVANZADO
-- Objetivo: Añadir columnas para evacuación y dificultad
-- =========================================================

ALTER TABLE public.daily_logs ADD COLUMN IF NOT EXISTS digestive_evacuated boolean;
ALTER TABLE public.daily_logs ADD COLUMN IF NOT EXISTS digestive_difficulty boolean;

-- Notificar recarga de configuración (opcional)
NOTIFY pgrst, 'reload config';

-- Verificar columnas finales
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'daily_logs';
