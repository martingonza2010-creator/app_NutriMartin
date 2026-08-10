-- Script para añadir columnas de gamificación y racha
ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS streak INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS learned_myth_ids INTEGER[] DEFAULT '{}';

COMMENT ON COLUMN profiles.streak IS 'Días consecutivos de uso de la aplicación';
COMMENT ON COLUMN profiles.learned_myth_ids IS 'ID de los mitos que el usuario ha aprendido/acertado';
