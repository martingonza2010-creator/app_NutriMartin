-- Script de Migración: Reemplazar 'Devolución por no consumo' por 'Rechazo de suplemento'
-- Ejecute este script en el Editor SQL de Supabase (SQL Editor) para actualizar su base de datos.

-- 1. Eliminar explícitamente el check constraint original primero
ALTER TABLE public.mermas_sedile DROP CONSTRAINT IF EXISTS mermas_sedile_motivo_check;
ALTER TABLE public.mermas_sedile DROP CONSTRAINT IF EXISTS check_mermas_motivo;

-- 2. Ahora que no hay restricción, actualizar los registros existentes
UPDATE public.mermas_sedile 
SET motivo = 'Rechazo de suplemento' 
WHERE motivo = 'Devolución por no consumo';

-- 3. Crear el nuevo check constraint con los motivos actualizados
ALTER TABLE public.mermas_sedile 
ADD CONSTRAINT check_mermas_motivo CHECK (motivo IN ('Acumulación', 'Alta informada', 'Alta no informada', 'Deceso', 'Devolución para reutilizar', 'Rechazo de suplemento'));
