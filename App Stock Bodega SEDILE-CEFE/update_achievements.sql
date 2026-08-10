-- Añadir columna de medallas/logros de excelencia
ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS achievements TEXT[] DEFAULT '{}';
