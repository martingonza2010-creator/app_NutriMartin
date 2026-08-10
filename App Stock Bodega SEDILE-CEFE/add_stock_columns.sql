-- =========================================================
-- SCRIPT DE ACTUALIZACIÓN DE COLUMNAS DE BODEGA Y LOGÍSTICA
-- Objetivo: Agregar columnas de Factor de Empaque, Área y Stock Bodega de Leches
-- =========================================================

-- 1. Agregar columnas si no existen
ALTER TABLE public.stock_sedile ADD COLUMN IF NOT EXISTS factor_empaque TEXT;
ALTER TABLE public.stock_sedile ADD COLUMN IF NOT EXISTS area TEXT;
ALTER TABLE public.stock_sedile ADD COLUMN IF NOT EXISTS stock_bodega_leches NUMERIC DEFAULT 0;

-- 2. Asegurar que el caché de Supabase se entere del cambio de inmediato
NOTIFY pgrst, 'reload config';

-- 3. Confirmación visual para verificar que las columnas fueron creadas
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'stock_sedile';
