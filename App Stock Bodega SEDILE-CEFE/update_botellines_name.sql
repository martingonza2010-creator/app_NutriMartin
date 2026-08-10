-- Script de Migración: Renombrar 'Botellines de 220 ml...' a 'Botellines'
-- Ejecute este script en el Editor SQL de Supabase para mantener la consistencia de los datos históricos.

-- 1. Actualizar en la tabla de mermas
UPDATE public.mermas_sedile 
SET producto_unidad = 'Botellines' 
WHERE producto_unidad = 'Botellines de 220 ml (Ensure/Glucerna/Pedia/Supp)';

-- 2. Actualizar en la tabla de carga laboral
UPDATE public.carga_laboral_sedile 
SET producto_unidad = 'Botellines' 
WHERE producto_unidad = 'Botellines de 220 ml (Ensure/Glucerna/Pedia/Supp)';
