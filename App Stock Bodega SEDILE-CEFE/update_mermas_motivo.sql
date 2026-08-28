-- Script de Migración: Actualizar lista de motivos de mermas en SEDILE-CEFE
-- Ejecute este script en el Editor SQL de Supabase (SQL Editor) para actualizar su base de datos.

-- 1. Eliminar restricciones antiguas de motivo si existen
ALTER TABLE public.mermas_sedile DROP CONSTRAINT IF EXISTS mermas_sedile_motivo_check;
ALTER TABLE public.mermas_sedile DROP CONSTRAINT IF EXISTS check_mermas_motivo;

-- 2. Asegurar que la columna motivo sea de tipo TEXT para admitir motivos dinámicos y 'Otro'
ALTER TABLE public.mermas_sedile ALTER COLUMN motivo TYPE TEXT;

